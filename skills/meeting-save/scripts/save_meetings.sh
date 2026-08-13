#!/bin/bash
# Archive Wispr Flow meeting recordings + transcripts to ~/Documents/meetings
# before the app's 24-hour audio purge deletes the .ogg files.
#
# Usage:
#   save_meetings.sh              archive every meeting still in the Wispr Flow folder
#   save_meetings.sh <meeting-id> archive only that meeting UUID
#
# Output layout per meeting:
#   ~/Documents/meetings/<YYYY-MM-DD Title>/
#     <YYYY-MM-DD Title>.mp3                    (main audio: mic + meeting fused to mono, mic denoised/gated;
#                                                plain conversion if the source is not stereo; .ogg copied if ffmpeg is missing)
#     <YYYY-MM-DD Title> (mic speech only).mp3  (mic channel alone: denoised, long silences removed)
#     <YYYY-MM-DD Title> live.ndjson
#     <YYYY-MM-DD Title> refined.ndjson
# Wispr Flow records stereo with left = user's mic, right = system/meeting audio.
# Existing files are never overwritten, so re-running is safe.

set -uo pipefail

SRC="$HOME/Library/Application Support/Wispr Flow/meetings"
DB="$HOME/Library/Application Support/Wispr Flow/flow.sqlite"
DEST="$HOME/Documents/meetings"

if [[ ! -d "$SRC" ]]; then
  echo "ERROR: Wispr Flow meetings folder not found at: $SRC" >&2
  exit 1
fi
if [[ ! -f "$DB" ]]; then
  echo "ERROR: Wispr Flow database not found at: $DB" >&2
  exit 1
fi

mkdir -p "$DEST"

have_ffmpeg=1
command -v ffmpeg >/dev/null 2>&1 || have_ffmpeg=0
[[ $have_ffmpeg -eq 0 ]] && echo "WARNING: ffmpeg not found; audio will be copied as .ogg instead of converted to .mp3" >&2

saved=0 skipped=0
shopt -s nullglob

meeting_dirs=()
if [[ $# -ge 1 ]]; then
  if [[ -d "$SRC/$1" ]]; then
    meeting_dirs=("$SRC/$1")
  else
    echo "ERROR: no meeting folder for id: $1" >&2
    exit 1
  fi
else
  meeting_dirs=("$SRC"/*/)
fi

if [[ ${#meeting_dirs[@]} -eq 0 ]]; then
  echo "No meetings found in $SRC"
  exit 0
fi

for dir in "${meeting_dirs[@]}"; do
  dir="${dir%/}"
  uuid="$(basename "$dir")"

  row="$(sqlite3 -separator $'\t' "$DB" \
    "SELECT date(substr(createdAt,1,23),'localtime'), COALESCE(NULLIF(title,''),'Untitled') FROM Meetings WHERE id='$uuid';")"
  if [[ -z "$row" ]]; then
    mdate="$(date -r "$dir" +%Y-%m-%d)"
    title="Untitled"
  else
    mdate="${row%%$'\t'*}"
    title="${row#*$'\t'}"
  fi

  # Strip characters that are unsafe in file names.
  title="$(printf '%s' "$title" | tr '/:' '--' | tr -d '\n' | sed 's/^ *//; s/ *$//')"
  base="$mdate $title"
  outdir="$DEST/$base"
  mkdir -p "$outdir"

  did_something=0

  for kind in live refined; do
    src_json="$dir/$kind.ndjson"
    dst_json="$outdir/$base $kind.ndjson"
    if [[ -f "$src_json" && ! -f "$dst_json" ]]; then
      cp "$src_json" "$dst_json" && { echo "  + $base $kind.ndjson"; did_something=1; }
    fi
  done

  ogg="$dir/upload.ogg"
  mp3="$outdir/$base.mp3"
  mic_mp3="$outdir/$base (mic speech only).mp3"
  ogg_copy="$outdir/$base.ogg"
  if [[ -f "$ogg" ]]; then
    if [[ $have_ffmpeg -eq 1 ]]; then
      channels="$(ffprobe -v error -select_streams a:0 -show_entries stream=channels -of csv=p=0 "$ogg" 2>/dev/null)"
      if [[ ! -f "$mp3" ]]; then
        converted=0
        if [[ "$channels" == "2" ]]; then
          # Left = mic, right = meeting: denoise+gate the mic so its idle hiss
          # stays out of the mix, then fold both channels into one mono track.
          if ffmpeg -hide_banner -loglevel error -n -i "$ogg" \
               -af "channelsplit=channel_layout=stereo[L][R];[L]afftdn=nr=20:nf=-40,agate=threshold=0.02:ratio=9:attack=5:release=250[Lc];[Lc][R]amix=inputs=2:normalize=0,alimiter=limit=0.97" \
               -ac 1 -codec:a libmp3lame -q:a 2 "$mp3"; then
            echo "  + $base.mp3 (fused mono)"
            did_something=1
            converted=1
          fi
        fi
        if [[ $converted -eq 0 && -f "$mp3" ]]; then
          echo "  ! fused conversion failed for $uuid and left a partial $base.mp3; delete it and re-run" >&2
        elif [[ $converted -eq 0 ]]; then
          if ffmpeg -hide_banner -loglevel error -n -i "$ogg" -codec:a libmp3lame -q:a 2 "$mp3"; then
            echo "  + $base.mp3"
            did_something=1
          else
            echo "  ! ffmpeg failed for $uuid; copying original .ogg" >&2
            [[ -f "$ogg_copy" ]] || { cp "$ogg" "$ogg_copy" && echo "  + $base.ogg"; did_something=1; }
          fi
        fi
      fi
      if [[ "$channels" == "2" && ! -f "$mic_mp3" ]]; then
        # Mic channel on its own: denoised, silences over 0.5s removed
        # (a 0.5s pause is kept at each cut so speech doesn't run together).
        if ffmpeg -hide_banner -loglevel error -n -i "$ogg" \
             -af "pan=mono|c0=c0,afftdn=nr=20:nf=-40,silenceremove=start_periods=1:start_threshold=-35dB:start_silence=0.3:stop_periods=-1:stop_threshold=-35dB:stop_silence=0.5:detection=rms" \
             -codec:a libmp3lame -q:a 2 "$mic_mp3"; then
          echo "  + $base (mic speech only).mp3"
          did_something=1
        else
          echo "  ! mic-track extraction failed for $uuid" >&2
        fi
      fi
    else
      [[ -f "$ogg_copy" ]] || { cp "$ogg" "$ogg_copy" && echo "  + $base.ogg"; did_something=1; }
    fi
  elif [[ ! -f "$mp3" && ! -f "$ogg_copy" ]]; then
    echo "  ~ $base: audio already purged by Wispr Flow (transcripts only)"
  fi

  if [[ $did_something -eq 1 ]]; then
    echo "Saved: $base"
    saved=$((saved+1))
  else
    echo "Up to date: $base"
    skipped=$((skipped+1))
  fi
done

echo
echo "Done. $saved meeting(s) updated, $skipped already archived. Destination: $DEST"

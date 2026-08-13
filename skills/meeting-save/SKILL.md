---
name: meeting-save
description: Archive Wispr Flow meeting recordings before the app's 24-hour audio purge. Copies each meeting's audio and live/refined transcripts from Wispr Flow's data folder into ~/Documents/meetings, in a per-meeting folder named "<YYYY-MM-DD> <Meeting Title>". Produces two mp3s per meeting - the main audio (mic + meeting fused to mono, mic denoised) and a mic-only track (denoised, silence-trimmed). Triggers - "save my meeting", "archive wispr flow meetings", "back up meeting audio", "/meeting-save".
---

# meeting-save

Archives Wispr Flow meetings (audio + transcripts) to `~/Documents/meetings` before the app deletes the audio (it keeps `.ogg` files for only ~24 hours).

## What it does

For every meeting folder under `~/Library/Application Support/Wispr Flow/meetings/<uuid>/`:

1. Looks up the meeting's **title** and **local date** in Wispr Flow's database (`~/Library/Application Support/Wispr Flow/flow.sqlite`, table `Meetings`).
2. Creates `~/Documents/meetings/<YYYY-MM-DD Title>/` (title falls back to `Untitled` when blank).
3. Copies `live.ndjson` and `refined.ndjson` as `<YYYY-MM-DD Title> live.ndjson` / `<YYYY-MM-DD Title> refined.ndjson`.
4. Converts `upload.ogg` into **two mp3s** with ffmpeg (VBR `-q:a 2`). Wispr Flow records stereo with **left = the user's mic** and **right = system/meeting audio**:
   - `<YYYY-MM-DD Title>.mp3` — the main audio: mic channel denoised (`afftdn`) and noise-gated, then fused with the meeting channel into one mono track (limiter applied to prevent clipping).
   - `<YYYY-MM-DD Title> (mic speech only).mp3` — the mic channel alone: denoised and silence-trimmed (silences over 0.5s removed, 0.5s pause kept at each cut), leaving just the user's spoken remarks.
   - If the source is not stereo, the main mp3 is a plain conversion and no mic-only file is made. If ffmpeg is missing or fails, it copies the original `.ogg` instead.
5. Never overwrites existing files — re-running only picks up new meetings, so it is safe to run any time. (Re-running also backfills the mic-only mp3 for meetings whose `.ogg` still exists in Wispr Flow's folder.)

## How to run

Run the bundled script:

```bash
bash ~/.claude/skills/meeting-save/scripts/save_meetings.sh
```

To archive a single meeting only, pass its UUID (the folder name under Wispr Flow's `meetings/` directory):

```bash
bash ~/.claude/skills/meeting-save/scripts/save_meetings.sh <meeting-uuid>
```

## Reporting

After the script finishes, tell the user:

- Which meetings were newly archived (date + title) and which were already up to date.
- Any meeting whose audio was already purged (the script prints `audio already purged` — transcripts were still saved).
- Any warnings (ffmpeg missing, ffmpeg conversion failure with `.ogg` fallback, mic-track extraction failure, or a partial mp3 left by a failed fused conversion).

## Troubleshooting

- **`Wispr Flow meetings folder not found`** — Wispr Flow is not installed or has never recorded a meeting on this Mac.
- **Meeting shows as `Untitled`** — the meeting has no title yet in the app; rename it in Wispr Flow and re-run, or rename the archived folder/files manually.
- **No `.mp3` produced** — check that `ffmpeg` is on PATH (`brew install ffmpeg`); the script falls back to copying the `.ogg` so no audio is lost either way.

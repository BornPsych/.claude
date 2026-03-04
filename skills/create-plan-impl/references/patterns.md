# Common Implementation Patterns

Reference for common planning patterns based on task type.

---

## Database Changes

**Phase Order:**
1. Schema/Migration
2. Data access layer (store/repository)
3. Business logic
4. API endpoints
5. Client updates

**Key Considerations:**
- Migration rollback strategy
- Data backfill for existing records
- Index optimization
- Foreign key constraints

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] Migration applies: `make migrate`
- [ ] Migration rollback works: `make migrate-down`
- [ ] Store tests pass: `npm test -- store`

#### Manual:
- [ ] Existing data preserved after migration
- [ ] Query performance acceptable
```

---

## New Feature

**Phase Order:**
1. Research existing patterns
2. Data model design
3. Backend logic
4. API endpoints
5. Frontend/UI (last)

**Key Considerations:**
- Feature flags for gradual rollout
- Error handling strategy
- Logging and monitoring
- Documentation updates

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] API contract tests pass

#### Manual:
- [ ] Feature works end-to-end
- [ ] Error states handled gracefully
- [ ] Loading states appropriate
```

---

## Bug Fix

**Phase Order:**
1. Reproduce and document bug
2. Write failing test
3. Implement fix
4. Verify fix doesn't break other things
5. Add regression tests

**Key Considerations:**
- Root cause vs symptom
- Regression prevention
- Related bugs to check
- Monitoring for recurrence

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] New regression test passes
- [ ] Existing tests still pass
- [ ] No new lint warnings

#### Manual:
- [ ] Original bug no longer reproduces
- [ ] Related functionality still works
- [ ] Edge cases verified
```

---

## Refactoring

**Phase Order:**
1. Document current behavior (tests)
2. Plan incremental changes
3. Refactor with tests green
4. Update dependent code
5. Clean up deprecated code

**Key Considerations:**
- Backwards compatibility
- Incremental migration path
- Feature flags if needed
- Documentation updates

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] All existing tests pass
- [ ] No behavior changes (test coverage)
- [ ] Type checking passes
- [ ] No new warnings

#### Manual:
- [ ] Verify behavior unchanged
- [ ] Performance not degraded
- [ ] Code review approved
```

---

## API Changes

**Phase Order:**
1. Design API contract
2. Implement backend
3. Add API tests
4. Update documentation
5. Update clients

**Key Considerations:**
- Versioning strategy
- Backwards compatibility
- Rate limiting
- Authentication/authorization

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] API tests pass
- [ ] Contract tests pass
- [ ] OpenAPI spec updated
- [ ] Type generation works

#### Manual:
- [ ] API works via Postman/curl
- [ ] Error responses appropriate
- [ ] Rate limiting works
```

---

## Performance Optimization

**Phase Order:**
1. Profile and identify bottlenecks
2. Establish baseline metrics
3. Implement optimization
4. Measure improvement
5. Monitor in production

**Key Considerations:**
- Measure before optimizing
- Consider tradeoffs
- Don't optimize prematurely
- Monitor after deployment

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] Benchmark tests pass
- [ ] No regression in functionality
- [ ] Memory usage acceptable

#### Manual:
- [ ] Latency improved by X%
- [ ] No user-visible issues
- [ ] Dashboard metrics improved
```

---

## Security Fix

**Phase Order:**
1. Assess vulnerability scope
2. Implement fix
3. Add security tests
4. Review for related issues
5. Update security documentation

**Key Considerations:**
- Disclosure timeline
- Related vulnerabilities
- Audit logging
- Incident response

**Success Criteria Pattern:**
```markdown
#### Automated:
- [ ] Security tests pass
- [ ] SAST/DAST scans clean
- [ ] No new vulnerabilities introduced

#### Manual:
- [ ] Vulnerability no longer exploitable
- [ ] Audit logs capture attempts
- [ ] Security review approved
```

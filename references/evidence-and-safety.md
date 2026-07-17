# Evidence and Safety

## Evidence Priority

Use this order when sources disagree:

1. Final committed diff and actual test output.
2. Accessible requirement document.
3. Explicit user statements.
4. Development notes and discussion history.
5. AI inference, labeled as an assumption.

Separate observed facts from claims:

- `Verified`: directly observed in tests, database, logs, API output, or browser state.
- `Implemented`: supported by code inspection but not necessarily run in the current environment.
- `Reported`: stated by the user or another agent, not independently verified.
- `To confirm`: evidence is missing or conflicting.

Do not silently upgrade `Reported` to `Verified`.

## Repository Scope Audit

Before calculating the PR range, confirm the target branch. Do not assume a branch based only on names such as `dev`, `main`, or `master`. The remote default branch is a candidate, not proof of the intended PR target.

For a final description, verify from the target branch merge-base:

```bash
git status --short --branch
git merge-base <target> HEAD
git log --oneline <merge-base>..HEAD
git diff --name-status <merge-base>..HEAD
git diff --stat <merge-base>..HEAD
git diff --check <merge-base>..HEAD
```

Check for:

- Old PR commits unintentionally included.
- Wrong target branch.
- Stacked PR dependencies.
- Unrelated generated files, docs, screenshots, lockfiles, or temp files.
- Deleted implementations still mentioned as active capabilities.
- Draft commit messages that differ from final commit records.

## Permission Boundary

Documentation work is read-only by default. Do not perform any of these unless explicitly requested:

- Stage or commit files.
- Push or force-push branches.
- Rewrite branch history.
- Create, edit, or submit a PR/MR.
- Post comments or messages.
- Modify `.gitignore`.
- Upload screenshots or local files.

Opening a draft document does not authorize publishing it.

## Sensitive Information Review

Before producing a public or shared PR description, inspect examples, logs, SQL, and screenshots for:

- API keys, tokens, cookies, passwords, auth headers.
- Database URLs and credentials.
- Private customer or financial data.
- Personal desktop content and local usernames.
- Internal-only paths, hostnames, and identifiers when disclosure is not intended.
- Full request/response payloads containing sensitive fields.

Redact sensitive values while preserving the evidence needed for review. Do not fabricate replacement values that change the meaning of the evidence.

## Screenshot Rules

Screenshots are optional review evidence.

1. Use screenshots only when requested or materially useful.
2. Prefer an existing ignored local directory.
3. Verify the path before capture:

```bash
git check-ignore -q tmp/pr-screenshots/example.png
```

4. Do not add ignore rules without permission.
5. Use business-meaningful filenames.
6. Check for secrets, usernames, chat windows, desktop content, and private data.
7. Run `git status --short` afterward.
8. Do not upload screenshots without explicit authorization.

Recommended local naming:

```text
tmp/pr-screenshots/01-feature-entry.png
tmp/pr-screenshots/02-important-state.png
tmp/pr-screenshots/03-verification-result.png
```

PR text should use screenshot titles and reviewer-oriented notes, not local absolute paths.

## Persistence Evidence

When a feature saves state, specify:

| Question | Required Answer |
|---|---|
| What is stored? | Strategy, preference, version, execution, report, config, etc. |
| Where? | Table, JSON field, metadata field, file, localStorage, memory |
| Lifecycle? | Create, update, archive, delete, retention |
| Compatibility? | Migration, legacy fallback, historical records |
| Refresh behavior? | Whether state survives reload/restart |

If there is no persistence, say so explicitly.

## Verification Status Vocabulary

Use only evidence-backed statuses:

- `Passed`: command or manual check completed successfully.
- `Failed`: command or manual check completed and failed.
- `Not run`: no attempt was made.
- `Blocked`: attempted but prevented by an environment or dependency issue.

Include relevant residual warnings without presenting them as new failures when they predate the PR.

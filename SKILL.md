---
name: vibe-pr-summary-writer
description: Create reviewer-ready PR/MR descriptions and short mentor updates after AI-assisted or vibe coding. Use when requirements, commits, diffs, tests, screenshots, logs, APIs, persistence, investigation findings, or non-goals must be summarized accurately. Supports pre-commit drafts with a commit plan and post-commit final descriptions with real commit IDs. Routes feature, abstraction, bug investigation, calculation, scheduler, AI orchestration, frontend, and cleanup PRs to different evidence templates.
---

# Vibe PR Summary Writer

## Objective

Turn development work into a concise, evidence-backed PR/MR description that lets a reviewer answer:

1. What was required?
2. What does this PR actually complete?
3. How is the change organized?
4. What proves it works?
5. How can new public capabilities be used or extended?
6. What is intentionally not included?

Do not write a code-change diary. Identify the PR type first, then load only the relevant templates and evidence rules.

## Operating Boundary

Generating PR documentation does not authorize commits, pushes, branch rewrites, `.gitignore` changes, screenshot uploads, comments, or PR/MR creation. Perform those actions only when the user explicitly requests them.

Use read-only repository inspection by default. Never expose secrets, tokens, cookies, credentials, private customer data, personal desktop content, or sensitive log payloads in generated descriptions or screenshots.

## Workflow

### 1. Determine the output stage

Produce two distinct artifacts when the workflow spans commit creation:

| Artifact | Timing | Commit section |
|---|---|---|
| `pr-description-draft.md` | Before commits | Commit plan with proposed messages; no invented hashes; unresolved items allowed |
| `pr-description-final.md` | After commits | Real commit IDs, final diff scope, final tests, screenshot notes, and non-goals |

Do not update a draft by merely inserting hashes. Before writing the final version, collect repository evidence again from the actual committed state.

### 2. Resolve the target branch

Do not assume `origin/dev`, `origin/main`, `main`, or `master`.

- If the user provides the target branch, verify that it exists and use it.
- Otherwise inspect the current branch, upstream, remote default branch, and remote branch candidates.
- Treat the remote default branch as a candidate, not proof of the intended PR target.
- Use existing PR metadata or explicit repository conventions when available.
- If more than one target remains plausible, ask the user before calculating the PR diff.

Run target discovery without selecting a target:

```bash
scripts/collect-pr-context.sh
```

### 3. Collect evidence

When inside a Git repository, run the read-only collector:

```bash
scripts/collect-pr-context.sh <target-branch>
```

If the script is unavailable, inspect at least:

```bash
git status --short --branch
git merge-base <target-branch> HEAD
git log --oneline <merge-base>..HEAD
git diff --name-status <merge-base>..HEAD
git diff --stat <merge-base>..HEAD
git diff --check <merge-base>..HEAD
```

Also collect test output, manual verification, API examples, data storage details, page entry points, logs, SQL, and screenshots when relevant.

If this is not a Git repository, fall back to user-provided requirements, changed-file lists, tests, and verification evidence. State that commit and target-branch evidence was unavailable.

### 4. Resolve the requirement source

Requirement documentation is optional:

- If a local or accessible document exists, read and summarize it.
- If a cloud link exists but is inaccessible, retain the link for reviewer context and say that the summary comes from user discussion, development notes, commits, and diffs.
- If no document or link exists, omit the requirement-document section entirely.

Never claim to have read an inaccessible document. When sources conflict, follow this evidence order:

1. Actual committed diff and test output.
2. Accessible requirement document.
3. Explicit user statements.
4. Development notes and discussion history.
5. AI inference, clearly labeled as an assumption.

### 5. Classify the PR

Choose one primary type and at most two secondary types:

- New feature.
- Abstraction or extension point.
- Bugfix or data investigation.
- Calculation methodology.
- Background job or scheduler.
- AI, prompt, or orchestration.
- Frontend UX.
- Cleanup or convergence.

Read [references/pr-type-routing.md](references/pr-type-routing.md) and load only the sections required by the selected types.

### 6. Choose language and template

- For Chinese output, read [references/templates-zh.md](references/templates-zh.md).
- For English output, read [references/templates-en.md](references/templates-en.md).
- Generate both only when the user asks for both.

Use one of three output modes:

- Short mentor update: 4-8 lines.
- Standard PR description: concise MR/PR page content.
- Deep investigation description: adds SQL, logs, formulas, root causes, or follow-up questions.

### 7. Add evidence and examples

Read [references/evidence-and-safety.md](references/evidence-and-safety.md) when the PR includes persistence, logs, SQL, screenshots, background jobs, AI behavior, or potentially sensitive data.

Read [references/examples.md](references/examples.md) when the PR adds a public API, configuration, template mechanism, abstraction, workflow, data structure, or extension point.

Read [references/mermaid-diagrams.md](references/mermaid-diagrams.md) when a new or changed feature spans multiple components, stages, states, asynchronous steps, fallbacks, or agent handoffs. Add a concise Mermaid diagram only when it materially reduces reviewer effort. Do not add one to every PR, and do not put Mermaid in Git commit messages.

An example must explain:

1. When to use the capability.
2. How to use it.
3. What result to expect.

Do not require examples for private implementation details that do not create a new usage or extension surface.

### 8. Check PR scope

Before finalizing, verify:

- Source and target branches are correct.
- The commit list matches the intended PR.
- Old or unrelated commits are not accidentally included.
- Unrelated files, generated files, screenshots, local docs, lockfiles, and temporary artifacts are excluded unless intended.
- Stacked PR dependencies are explained when applicable.
- Commit count and changed-file count are not confused.

If the PR combines independent feature, refactor, bugfix, and cleanup themes, recommend splitting or using stacked PRs. Do not split mechanically when the changes are inseparable.

### 9. Write and validate the result

Group changes by commit or functional module. Do not list every file unless the user asks for a full file audit.

Separate:

- Automated tests.
- Manual verification.
- Not run.
- Blocked.

Never convert “not run” into “failed” or “passed”. Never describe a demo, prompt-only change, or AI suggestion as a production execution loop unless the evidence proves that behavior.

Read [references/final-checklist.md](references/final-checklist.md) before delivering the draft or final description.

## Screenshot Policy

Screenshots are optional review evidence, not code artifacts.

- Capture them only when requested or materially useful for frontend, visual, log, or manual-verification evidence.
- Prefer an existing ignored local directory.
- Before saving, verify the directory with `git check-ignore -q <path>`.
- Do not modify `.gitignore` without explicit user approval.
- Use business-meaningful filenames.
- Run `git status --short` afterward and confirm screenshots are not part of the proposed commit.
- Do not upload screenshots or include local absolute paths in a PR without explicit user authorization.

## Output Quality

Default to a reviewer reading budget of 2-3 minutes:

- Lead with the requirement and outcome.
- Put the most important risk near the top.
- Keep commit tables focused on goal, main files, and review focus.
- Move long SQL, logs, formulas, and exhaustive file lists into optional sections.
- State persistence, compatibility, and non-goals precisely.

The final description must reflect the final repository state, not the development plan.

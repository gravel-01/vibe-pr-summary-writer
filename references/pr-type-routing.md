# PR Type Routing

## Selection Rule

Choose one primary PR type and at most two secondary types.

- The primary type determines the narrative structure.
- Secondary types add only the evidence modules they require.
- Do not concatenate complete templates for every matching type.

Example: a scheduled notification feature can use `Background job / scheduler` as primary and `Frontend UX` as secondary. Keep the scheduler trigger chain as the main narrative and add only the frontend entry point, notification states, and screenshots.

## Routing Table

| PR Type | Use When | Required Narrative | Required Evidence |
|---|---|---|---|
| New feature | Adds a user-visible feature, page, API, or workflow | User scenario, completed scope, usage path, non-goals | Page/API entry, verification path, Mermaid for complex flows, screenshots when useful |
| Abstraction / extension | Adds registry, template, executor, service, interface, or plugin point | Why abstraction is needed, boundary, compatibility, extension path | Example, default behavior, fallback, persistence, Mermaid when caller-to-runtime flow is complex |
| Bugfix / data investigation | Fixes anomalies, inconsistent data, sync gaps, or suspicious historical results | Symptom -> conclusion -> root causes -> fixed -> not fixed -> follow-up | SQL, logs, data screenshots, regression tests |
| Calculation methodology | Changes return, PnL, NAV, benchmark, ranking, or statistical logic | Data source, formula, selection rule, fallback, limitations | Formula, units, precision, date alignment, empty state tests |
| Background job / scheduler | Adds worker, timed trigger, automated execution, notification, or retry behavior | Trigger chain, success path, failure path, next-run behavior | Logs, execution records, failure test, notification evidence, Mermaid when the chain branches |
| AI / prompt / orchestration | Adds AI suggestions, prompt plans, agent ordering, or machine-generated patches | Input context, output contract, validation, human boundary, non-determinism | Prompt snapshot, JSON schema, logs, run summary, fallback, Mermaid for agent handoffs when useful |
| Frontend UX | Mainly changes UI, interactions, layout, chart, dialog, or notification | User path, important states, responsive/theme behavior | Screenshots, browser verification, empty/error/loading states |
| Cleanup / convergence | Removes old pages, APIs, components, flags, or dead code | Removal reason, removed surface, replacement, compatibility | Reference scan, final diff, tests for replacement path |

## Type-Specific Requirements

### Bugfix / Data Investigation

Use this sequence without skipping the distinction between diagnosis and repair:

```text
Symptom
-> Investigation conclusion
-> Root cause breakdown
-> What this PR can fix
-> What this PR cannot fix
-> What mentor/reviewer or an upstream team should check next
```

Do not claim an upstream data gap is repaired when the PR only detects, surfaces, or falls back around it. State whether historical data is backfilled.

### Calculation Methodology

Include when relevant:

- Source table or API.
- Formula.
- Units and precision.
- Timezone and date alignment.
- Daily record selection priority.
- Missing-data fallback.
- Empty-state behavior.
- Historical compatibility.

### Background Job / Scheduler

Distinguish these outcomes:

1. Trigger was detected.
2. Execution record was created.
3. Business task started.
4. Business task succeeded or failed.
5. Next run was advanced.
6. User-facing notification was delivered.

Do not describe execution-record creation as business success.

### AI / Prompt / Orchestration

State precisely whether the change:

- Adjusts prompt context only.
- Changes call order.
- Generates a suggestion.
- Applies a validated patch.
- Creates a new version.
- Executes automatically.

If human confirmation remains required, say so. Describe model failures, invalid output handling, and fallback when implemented.

## Split or Stack Recommendation

Recommend separate or stacked PRs when:

- Independent feature, refactor, bugfix, and cleanup themes are mixed.
- Review requires unrelated domain expertise.
- One part can merge safely without the others.
- Old commits appear only because of a deleted or stacked PR.

Keep one PR when changes share a contract and splitting would create a broken intermediate state.

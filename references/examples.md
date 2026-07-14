# Examples

Use examples only for new public usage, configuration, API, abstraction, template, workflow, data structure, or extension surfaces.

## API Example

Use when a reviewer or future developer needs to know how to call a new endpoint.

````markdown
## Example: Activate a Saved Version

Use this endpoint when a user selects a previously saved version.

```http
POST /api/resources/demo/versions/activate
Content-Type: application/json

{
  "version": "v3"
}
```

Expected result: `v3` becomes active and remains active after page refresh.
````

## Abstraction Extension Example

Use when a PR introduces a registry, provider, builder, executor, or template abstraction.

````markdown
## Example: Add a New Methodology

1. Implement a new series builder using the shared result contract.
2. Register it in the methodology registry.
3. Keep API and frontend consumption unchanged.

Expected result: clients select the new methodology through the existing API parameter.
````

## Example Prompt

Use when future maintainers may ask AI to extend a template or configuration.

````markdown
## Example Prompt: Add a New Market Template

> Add a default workflow template for [market]. Define stages, dependencies, inputs, outputs, checks, and executor binding. Reuse shared stages only when their runtime contract is compatible. Add registry coverage and tests without modifying existing default templates.
````

## Bug Investigation Evidence Example

````markdown
## Evidence

| Evidence | Conclusion |
|---|---|
| API response repeats the same value across five dates | The chart is rendering repeated backend values rather than calculating a flat line itself. |
| Source table has no rows after the cutoff date | The upstream data gap remains outside this PR. |
| Regression test recomputes the value from valid fields | The local stale-field dependency is fixed for future runs. |
````

## Scheduler Evidence Example

````markdown
## Trigger Evidence

```text
[scheduler] due_item id=... scheduled_at=...
[scheduler] execution_created id=...
[scheduler] business_task_completed result=success
[scheduler] next_run_advanced next_run_at=...
```

This proves detection, execution creation, business completion, and next-run advancement separately.
````

## Calculation Example

````markdown
## Formula

```text
daily_return = (nav_today - external_flow_today) / nav_previous - 1
```

- Unit: decimal return.
- Precision: stored at full precision; display rounds to two decimals.
- Date alignment: use the latest benchmark close on or before the portfolio date.
- Empty state: fewer than two snapshots returns no points.
````

## Persistence Example

````markdown
## Data Persistence

| Data | Storage | Lifecycle |
|---|---|---|
| Saved versions | `resource_versions.definition_json` | Create new version; archive old versions; no hard delete |
| Active selection | `resources.metadata_json.active_version` | Updated when user activates a version |
| Execution binding | `schedule_items.trigger_config` | Keeps the original version binding for historical reproducibility |
````


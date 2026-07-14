# Final Checklist

## Draft Checklist

- Is the requirement stated in product/user terms before implementation details?
- Is the requirement source handled honestly?
- Is one primary PR type selected?
- Are secondary types limited to evidence modules rather than full duplicate templates?
- Does the commit section contain proposed messages only, without invented hashes?
- Are unresolved assumptions labeled `To confirm` or `待确认`?
- Are public APIs, abstractions, templates, or extension points accompanied by an example?
- Are persistence and frontend/usage entry points explained when relevant?
- Are verification plans and non-goals present?
- Does the draft avoid implying that planned work has already passed?

## Final Post-Commit Checklist

- Was repository context collected again after commits were created?
- Are source branch, target branch, and merge-base correct?
- Does the commit table contain real commit IDs and final messages?
- Does the final diff match the described scope?
- Were obsolete draft phrases such as “planned”, “to be committed”, or “expected” removed?
- Are deleted or reverted features absent from the capability summary?
- Are automated tests and manual verification separated?
- Are `Passed`, `Failed`, `Not run`, and `Blocked` used accurately?
- Are database tables, fields, API routes, and UI entry points precise?
- Are non-goals and residual risks explicit?
- Are stacked PR or old-commit relationships explained?
- Are screenshots absent from commit scope unless intentionally included?
- Are secrets and private data removed from text, logs, SQL, examples, and screenshots?
- Is the description readable within roughly 2-3 minutes, with long evidence moved to optional sections?

## Final Integrity Questions

Before delivery, answer:

1. What statement in this PR description has the weakest evidence?
2. Is any implementation described as more complete than the code or tests prove?
3. Is any important reviewer decision hidden in a long section?
4. Could the reviewer identify the highest-risk files or commits quickly?
5. Is there any unrelated change that should be split or called out?

If any answer is unclear, revise before delivering.


# Read-only handoff brief

The continuation belongs in the `trybloomai/hero` repository, not
`trybloomai/bloom-skills`.

## Objective

Continue the architectural investigation without making any product,
infrastructure, prompt, database, or telemetry changes. Inspect the real Hero
implementation and current provider capabilities, reconcile them with the
evidence in this branch, and present the user with the final options again.

## Required constraints

- Read-only work only.
- Do not edit or create repository files.
- Do not implement an option.
- Do not launch paid/local production-model experiments.
- Do not mutate PostHog, Supabase, Slack, Vercel, or any external system.
- Read-only telemetry/document/code inspection is allowed.
- Clearly label inference versus directly observed behavior.

## Questions to resolve

1. Trace the exact production model call path: AI SDK version, Google provider,
   Gemini endpoint, message construction, loop controller, `prepareStep` or
   equivalent, and provider options.
2. Determine whether the loop currently sends full inline image bytes, URLs,
   file references, or a mix at each step.
3. Determine whether Google implicit caching is merely observed, explicitly
   configured, or supported through a stateful/cached-content primitive on the
   exact endpoint.
4. Identify the smallest possible implementation surface for Options A, B, and
   C in `03-architecture-options.md`, without changing anything.
5. Reconcile the architectural answer with the production breakdown: product
   non-generalized E2E regression versus generalized-Sandbox agent regression.
6. Present the final options to the user again, prioritized, including expected
   latency/cost/cache impact, quality risk, implementation complexity, prompt
   changes, and the evidence required before shipping.

## Desired response shape

Lead with a direct verdict on whether the existing loop is fundamentally wrong.
Then give a compact comparison of the final options and a recommended sequence.
Call out that tested blind eviction is rejected, provider state is not equivalent
to removing logical context, and stable replay is currently the quality-preserving
control.

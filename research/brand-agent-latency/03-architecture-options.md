# Architecture fundamentals and final options

## How the loop works

An LLM call has no private cross-request memory. On a stateless multi-step tool
loop, every generation receives the initial messages plus accumulated assistant
messages, tool calls, and tool results. If those initial messages include image
parts, the model logically receives the visual evidence again on every step.

The AI SDK documents this as its default behavior. Its `prepareStep` hook exists
to modify messages between steps, and its current guidance explicitly recommends
message pruning or compaction for long-running loops. `pruneMessages` directly
supports pruning reasoning and tool-call/result history; custom handling is
required for image parts.

Provider-managed state changes transport and cache mechanics, not the model's
logical need for prior context. For example, OpenAI Responses can continue with
`previous_response_id`, and Gemini Interactions can continue with
`previous_interaction_id`. In both cases the provider reconstructs the earlier
conversation. Prompt/context caching can reuse computed prefix state, including
multimodal content, but cached content still occupies logical context and model
limits.

File IDs and URLs similarly avoid resending inline base64 bytes through the
application, but the provider must still obtain and visually process the file
unless it can reuse cached state.

## Current external references

- [AI SDK loop control and `prepareStep`](https://ai-sdk.dev/docs/agents/loop-control)
- [AI SDK multi-step message management](https://ai-sdk.dev/docs/ai-sdk-core/tools-and-tool-calling)
- [AI SDK `pruneMessages`](https://ai-sdk.dev/docs/reference/ai-sdk-ui/prune-messages)
- [AI SDK OpenAI Responses persistence](https://ai-sdk.dev/cookbook/guides/openai-responses)
- [AI SDK Google Vertex cached content](https://ai-sdk.dev/providers/ai-sdk-providers/google-vertex)
- [Gemini stateful and stateless conversations](https://ai.google.dev/gemini-api/docs/get-started)
- [Gemini context caching](https://ai.google.dev/gemini-api/docs/generate-content/caching)
- [OpenAI conversation state](https://developers.openai.com/api/docs/guides/conversation-state)
- [OpenAI prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching)

## Final options to present

### Option A — stable history plus lower image resolution

Keep every viewed image in the runtime history for the bounded run, preserve
message/tool ordering for prefix stability, and change model-facing media
resolution from the current setting to `medium`.

- Expected benefit: fewer visual tokens and lower prefill/model latency without
  changing what files are available or triggering reopen loops.
- Risk: small typography, logo details, or subtle visual cues may degrade.
- Evidence status: strongest immediate candidate; not yet tested.
- Prompt changes: none.

### Option B — provider-managed conversation state or cached content

Test the state/caching mechanism supported by the exact Google endpoint used in
production. Candidate mechanisms include Gemini Interactions state chaining or
explicit cached content through a compatible Google/Vertex path.

- Expected benefit: less application serialization/upload work and more
  predictable provider cache reuse.
- Limitation: prior visual context still counts logically; it does not remove
  the large context or sequential generations.
- Risk: tool/thought-signature continuity, endpoint compatibility, retention,
  and observability semantics must match the existing agent.
- Prompt changes: normally none, but provider integration changes are required.

### Option C — explicit phase boundary with selected active assets

Use one bounded inspection phase, retain durable files in the Sandbox, then
start a separate author/finalize phase with only the selected assets deliberately
attached. Reattach final outputs for visual verification.

- Expected benefit: bounds authoring context rather than continuously growing
  it.
- Risk: selection mistakes or missing visual evidence can cause reopens or
  quality regression. This requires a designed state transition, not arbitrary
  “remove after three turns.”
- Prompt changes: possibly a small workflow/tool-contract change; no visual
  summarization should be required.
- Evidence status: plausible architecture, but not tested by the completed
  experiments.

### Option D — count/byte-based image eviction inside the current loop

Drop all but the newest images or evict when a byte threshold is crossed.

- Expected benefit: smaller individual request payloads.
- Observed result: repeated image reopens, worse cache stability, more steps,
  higher cumulative tokens/cost, and failed authoring in threshold-crossing
  cases.
- Recommendation: reject for now.

## Recommended ordering

1. Run Option A as the next isolated experiment.
2. In parallel as research only, establish whether the current Google AI SDK
   path exposes a stateful or explicit-cache primitive with identical tool-loop
   semantics; then test Option B independently.
3. Consider Option C only if A and B cannot meet latency/cost goals.
4. Do not revisit Option D without a materially different behavioral mechanism
   and a regression suite that detects reopen loops.

## Important unresolved questions

- Which Google endpoint and AI SDK provider implementation production currently
  uses for Gemini 3.7 Flash, and whether it supports Interactions state,
  `cachedContent`, or only implicit prefix caching.
- Why the high-volume non-generalized product path added roughly 6 seconds not
  explained by source, agent, or validation spans.
- Whether `mediaResolution: medium` retains brand-quality parity on real local
  brands, especially small wordmarks and typography.
- Whether binary payload serialization/network time is separately measurable
  from provider model prefill time.
- Whether current cache-read telemetry is exclusive or included in reported
  input tokens for every Google response path.

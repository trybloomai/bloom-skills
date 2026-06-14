# Setting up a run

These are the defaults for a Bloom generation: what to do unless the user asks otherwise. Each one earns its place with a reason; override when the situation calls for it.

## Pull references before generating

References are the strongest on-brand anchor — pull them first, then generate with them attached; without them the output drifts generic even when the brand layer is doing its job. Choosing them well (search, filter, count, when to attach none) is its own rule: see [`rules/references.md`](references.md). Tool mechanics (`bloom_search_user_images`, `bloom_list_images`, how IDs are passed) live in the tool descriptions.

## Default to `pro`

Use the `pro` model tier for creative output. It's the highest-quality path and the schema default. Don't downgrade to `fast` or `standard` for finals. Reach for the cheaper tiers only when the user explicitly wants speed or volume over quality (rough drafts, throwaway exploration).

## Don't onboard a brand that already exists

Before calling `bloom_onboard_brand`, check whether the brand is already there; call `bloom_list_brands` first. Onboarding takes ~60–90 seconds and creates a duplicate if one already exists. The tool description guards this too; it's worth the one-line check.

## Be honest when a batch gets pushback

When the user pushes back ("these are boring," "why is everything red?"), give a real diagnosis, not a generic apology. The pushback is usually right. Say what went wrong (the prompt leaned on the brand layer too hard and got generic; the palette override wasn't set so the accent color took over) and what you'll change in the next batch. A real answer is more useful than "sorry, let me try again."

## When a run fails, recover instead of retrying blindly

A failed generation costs credits and time. Read what went wrong before firing another call, and tell the user instead of looping silently.

| Symptom | Likely cause | What to do |
|---|---|---|
| Generation stays pending past the wait window | The job is slow or stuck, not finished | Collect once more with `wait: true`. If it still hasn't resolved, tell the user. Don't fire a fresh generation; that just burns credits on a duplicate. |
| The tool call returns an error | Bad parameter, missing reference, or a transient failure | Surface the actual error to the user. Fix the specific cause (attach the missing reference, correct the parameter) and retry once, but never loop the same failing call. |
| Out of credits | The account balance is exhausted | Stop. Tell the user they're out of credits and need to top up; retrying will keep failing. Check with `bloom_check_credits` before a large batch so you catch this up front. |
| Prompt references an image that isn't attached | Bloom has no memory between calls | Attach the image (upload or reference ID) before the call. A pronoun or "this" with nothing attached produces an unrelated image. |
| Output came back generic or off-brand | The prompt leaned on the brand layer; no references attached | Pull 2–4 references and regenerate with a more specific subject/composition. See the references rule above. |
| Brand not found | The brand isn't onboarded, or the name was wrong | Call `bloom_list_brands` to confirm the exact brand. Don't re-onboard a brand that already exists, which creates a duplicate. |

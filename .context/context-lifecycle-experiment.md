# Image context lifecycle experiment

Date: 2026-10-02

## Question

After the model has inspected source images once, can the Brand Agent remove
their bytes from later model requests, retain only metadata with a `view_files`
reopen path, and finish from its existing observations?

## Fixed setup

- Three synthetic file-only cases, eight PNG sources per case.
- Production model profile: Gemini 3.7 Flash, medium thinking, priority tier.
- Same source bytes, prompts, authoring tools, and local run-host bindings in
  both arms.
- Runs within each arm were launched concurrently.
- The inherited Vercel OIDC token was expired. Both arms therefore used the
  same in-memory generalized-Sandbox provider. It presented exact image bytes
  through the production `view_files` implementation. Arbitrary Python
  `execute` calls returned empty success results. These are local model-loop
  measurements, not deployed end-to-end latency.
- File-only replay used a deterministic zero-token eager-admission count,
  because these sources have no eager evidence and should not require the
  otherwise shared Anthropic count endpoint.

## Declared change

The baseline retained every image file part in tool history. The candidate:

1. kept every newly returned image intact for the first model request that
   could inspect it;
2. on subsequent turns, replaced each image file part with its path, media
   type, byte length, and `view_files` reopen metadata;
3. left the original adjacent `view_files` result metadata intact.

## Results

| Case | Arm | Result | Steps | Comparable local time | Cost | Source image calls | Repeated source calls | Repeated image presentations |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | Baseline | Pass | 14 | 122.7 s | $0.274 | 1 | 0 | 0 |
| 1 | Metadata | Fail: provider unavailable after loop | 38 | 132.3 s | $0.413 | 26 | 24 | 30 |
| 2 | Baseline | Pass | 12 | 107.5 s | $0.234 | 1 | 0 | 0 |
| 2 | Metadata | Fail: exhausted 76-step budget | 76 | 289.0 s | $1.485 | 67 | 66 | 170 |
| 3 | Baseline | Pass | 15 | 104.9 s | $0.261 | 1 | 0 | 0 |
| 3 | Metadata | Pass | 13 | 95.2 s | $0.336 | 1 | 0 | 0 |

Aggregate baseline: 3/3 successful, 41 steps, 111.7 s mean, $0.769 total.

Aggregate candidate: 1/3 successful, 127 steps, 172.2 s mean, $2.234 total.

In the one comparable successful pair, metadata eviction reduced latency by
9.2% and total authoring tokens from 313,422 to 193,224, but cost rose 28.8%.
Cache-read tokens fell from 191,214 to 9,541.

## Did the bytes actually leave context?

Yes. At step 4, after the first post-image model turn, `view_files` tool-result
bytes changed as follows:

| Case | Baseline | Metadata | Reduction |
| --- | ---: | ---: | ---: |
| 1 | 1,416,613 B | 9,090 B | 99.4% |
| 2 | 1,616,433 B | 12,506 B | 99.2% |
| 3 | 60,859 B | 12,448 B | 79.5% |

The mechanism works. The policy does not.

## Interpretation

The candidate's repeated actionable metadata created a feedback loop:

1. pixels were available for one turn;
2. the next turn replaced them with an explicit reopen instruction;
3. the model reopened them to preserve visual certainty;
4. they were evicted again after one turn;
5. the reopen instruction reappeared.

Cases 1 and 2 repeatedly re-entered that loop and never reached writing. Case
3 used its existing observations and finished two steps faster, but its
structured Brand profile lost the color field that the baseline produced.

The rewrite also changed an earlier prompt prefix after the provider had seen
it. In the successful case, that reduced Gemini cache reuse enough that a
smaller prompt still cost more.

## Decision

Do not ship one-turn eviction plus an explicit reopen hint.

The next candidate should keep visual evidence through a short inspection
window or explicit extraction checkpoint, then replace it with a stable visual
summary (observations, path, dimensions, hash) that does not tell the model to
reopen. Reopening remains available through the normal tool description. The
evaluation must gate on repeated-view count, completion rate, structured
profile parity, cache reads, latency, and cost—not context bytes alone.

## Follow-up: neutral metadata after three turns

The follow-up removed the complete `reopen` object and the pixel-removal
status. Each evicted image became only:

```json
{
  "kind": "viewed_image_reference",
  "path": "inputs/raw/source-001/moodboard-01.png",
  "mediaType": "image/png",
  "byteLength": 982381
}
```

Pixels remained in context for the first three model requests after
`view_files`, then changed to that neutral record on request four.

| Case | Baseline time | Three-turn time | Change | Baseline cost | Three-turn cost | Source reopens | Result |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| 1 | 122.7 s | 95.3 s | -22.3% | $0.274 | $0.400 | 0 | Pass |
| 2 | 107.5 s | 103.2 s | -4.0% | $0.234 | $0.324 | 0 | Pass |
| 3 | 104.9 s | 78.5 s | -25.1% | $0.261 | $0.325 | 0 | Pass |

Aggregate comparison:

- Completion recovered from 1/3 to 3/3, matching the 3/3 baseline.
- No source image was reopened in any follow-up run.
- Mean local latency fell from 111.7 s to 92.3 s (-17.3%).
- Total authoring tokens fell from 855,413 to 709,977 (-17.0%).
- Steps rose from 41 to 47 (+14.6%), so the latency result is not a
  round-trip-count effect.
- Total provider cost rose from $0.769 to $1.049 (+36.4%).
- Cache reads fell from 505,786 to 113,470 tokens (-77.6%). The reduced cache
  discount outweighed the smaller request histories.

At each case's first eviction request, image-bearing tool history fell from
1,414,987 to 10,383 bytes, 1,616,365 to 12,506 bytes, and 65,711 to 15,568
bytes respectively.

The structured Brand profile matched or improved baseline fields in cases 1
and 2. Case 3 completed and retained all eight assets, but omitted both colors
and typography while its baseline included them. This is a quality warning,
not proof of a systematic regression from one sample.

### Follow-up decision

The three-turn neutral policy is promising for latency and fixes the reopen
loop, but is not ready to ship from three cases. The next gate is repeated
runs plus semantic review, and a cache-aware implementation or provider file
reference that avoids rewriting a previously cached prompt prefix.

## Evidence

- Baselines: trials `610131`, `610132`, `610133`.
- Metadata candidates: trials `610231`, `610232`, `610233`.
- Neutral three-turn candidates: trials `610331`, `610332`, `610333`.
- Focused tests: 42 passed, including lifecycle preservation/removal and the
  generalized-routing suite.
- Full app typecheck could not complete because the detached source checkout
  lacks unrelated landing-page image assets and generated
  `content-collections` declarations. Changed-file lint and the research
  evaluation typecheck passed.

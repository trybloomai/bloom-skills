# Image-context policy experiment

Date: 2026-10-05 UTC

## Outcome

Do not ship image-history eviction. On the threshold-crossing case, retaining all
images was the only policy that completed efficiently. Every pruning policy made
the model request images again; the two byte-threshold policies exhausted the
step budget without authoring a package.

The next experiment should preserve a stable, cacheable image history and reduce
the cost of each image with the provider's `mediaResolution` option. Separately,
binary image data should be removed from persisted traces after the model request
and replaced with an existing path/hash reference. That persistence change does
not alter what the model sees.

## Fixed settings

- Local Brand Agent host with the in-memory generalized sandbox
- Gemini 3.7 Flash, medium thinking, Priority service
- One repeat per case and policy, all four policies launched concurrently
- No system-prompt changes and no image summaries or extracted visual ledger
- Original source bytes and SHA-256 values fixed across arms
- Provider cost only; Sandbox cost excluded

Policies:

1. `retain-all`: keep every viewed image in model history
2. `recent-3`: keep only the three most recently viewed image parts
3. `byte-budget`: keep the newest image suffix within 2 MiB
4. `cache-aware`: keep all until 4 MiB, then prune in one batch to 2 MiB

## Three-case smoke matrix

The cases contained eight images each: 1,054,266 bytes, 1,203,772 bytes, and
38,226 bytes. Therefore `recent-3` was an active treatment, while the two byte
policies did not cross their thresholds and were effectively A/A controls.

| Policy | Threshold active? | Valid packages | Mean latency | Mean cost | Mean steps | `view_files` calls | Input tokens | Cache reads | Cache-read share |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| retain-all | Baseline | 3/3 | 142.1 s | $0.3050 | 15.7 | 10 | 992,913 | 606,077 | 61.0% |
| recent-3 | Yes | 3/3 | 174.4 s | $0.6830 | 30.0 | 50 | 1,573,802 | 292,156 | 18.6% |
| byte-budget | No | 3/3 | 126.8 s | $0.3126 | 15.3 | 12 | 945,268 | 499,216 | 52.8% |
| cache-aware | No | 3/3 | 127.1 s | $0.2928 | 14.7 | 12 | 861,963 | 462,569 | 53.7% |

Latency and cost are per-run means. Steps are per-run means. Calls, input tokens,
and cache reads are totals across the three cases. The apparent byte-policy wins
are normal model variance because neither threshold activated.

Compared with retain-all, recent-3 increased mean latency by 22.7%, cost by
124.0%, and model steps by 91.5%. Its cache-read share fell from 61.0% to 18.6%.
The direct behavioral cause was 50 `view_files` calls versus 10 for retain-all.

Trials: `610411` retain-all, `610412` recent-3, `610413` byte-budget, `610414`
cache-aware.

## Threshold-crossing stress case

The stress case contained 16 JPEGs totaling 4,419,305 bytes, so all three
pruning policies activated.

| Policy | Agent outcome | Latency | Provider cost | Steps | `view_files` | Input tokens | Cache reads | Cache-read share | Cumulative serialized context |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| retain-all | Valid package | 164.5 s | at least $0.3580 | 14 | 4 | 426,908 | 299,594 | 70.2% | 66.3 MiB |
| recent-3 | Valid package | 417.1 s | $1.4737 | 75 | 63 | 2,197,861 | 1,344,715 | 61.2% | 92.6 MiB |
| byte-budget | Failed before authoring | 446.2 s | $2.0084 | 76 | 70 | 2,521,661 | 1,185,586 | 47.0% | 191.5 MiB |
| cache-aware | Failed before authoring | 454.1 s | $1.4443 | 76 | 70 | 2,515,121 | 1,638,609 | 65.2% | 281.5 MiB |

The retain-all cost is a lower bound because one of 16 asset-description events
did not report usage. The agent-authoring component and the other 15 description
measurements are present.

Recent-3 reduced peak serialized context from 5.82 MiB to 1.84 MiB, but it made
15.75 times as many image-view calls. Its cumulative serialized context still
grew by 39.6%, latency by 153.6%, and cost by 311.7%. The byte policies oscillated
between viewing and eviction until the 76-step recovery limit.

Both successful stress runs retained all 16 original assets and produced a valid
profile with name, colors, and typography. The two threshold failures authored no
files. The successful full outcome objects were too large for the replay harness
to serialize (`Invalid string length`), although their compact run record,
candidate, bundle, and publication record were saved. This is a harness/archive
failure after successful model execution, not an agent failure.

Trials: `610421` retain-all, `610422` recent-3, `610423` byte-budget, `610424`
cache-aware.

Four earlier launch attempts, `610401` through `610404`, stopped before provider
execution because the local replay expected an unrelated OpenAI environment
variable. They incurred zero provider cost. Total recorded paid provider spend
for the completed experiment was approximately $10.065, excluding Sandbox cost
and the one missing asset-description usage measurement.

## Interpretation

Pixels in prior tool results are not passive storage: replaying them lets the
model inspect the same evidence without another tool call, and their stable
prefix is eligible for provider cache reads. Removing them changed both model
behavior and the cache prefix. A high cache-read percentage alone is not enough:
cache-aware still failed because it processed 2.52 million input tokens across 76
steps.

This result rejects count-based and byte-threshold eviction as a runtime latency
optimization. It does not show that retaining unbounded inline base64 is the
right transport or persistence format.

## Next iteration

1. Keep `retain-all` as the runtime control.
2. Add one candidate that also retains all image history but sets Google's
   model-facing `mediaResolution` to `medium`. This is provider-supported,
   requires no prompt change or extra model call, and should reduce visual input
   tokens without making the model forget images.
3. Before paid reruns, change only the evaluation/debug archive so binary image
   data is externalized after execution and the transcript stores its existing
   path, MIME type, byte length, and SHA-256. This prevents the serializer crash
   without changing model context.
4. Run three repeats per arm on the 16-image stress fixture, then the surviving
   candidate on three real local brands. Gate on package success, semantic/visual
   review, `view_files` calls, input tokens, cache-read share, provider cost, and
   local latency. A candidate fails immediately if image re-reads increase or any
   package fails.

If `medium` harms small typography or logo recognition, the next bounded test is
per-image `medium` by default with `high` only for an explicitly reopened image.
Provider file references are a later transport test: they can remove repeated
base64 upload/serialization, but they do not by themselves guarantee fewer model
tokens.

## Validation

- Focused lifecycle tests: 6/6 passed
- Full application and Conductor Cloud TypeScript check: passed
- Evaluation TypeScript check: passed
- Changed-file ESLint: passed
- These are local host timings, not deployed release latency

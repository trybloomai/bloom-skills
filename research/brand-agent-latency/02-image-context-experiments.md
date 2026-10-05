# Image-context experiments

Two rounds were run locally against the production Brand Agent loop and Gemini
3.7 Flash. They are model-loop measurements, not deployed end-to-end timings.
The detailed reports and trial identifiers are tracked in `.context/`.

## Round 1: can viewed pixels be replaced with metadata?

Three synthetic file-only brands, each with eight fixed source images, compared
retaining image parts with replacing them after inspection.

### One-turn eviction with an explicit reopen hint

- Baseline: 3/3 complete, 41 total steps, 111.7-second mean, $0.769 total.
- Candidate: 1/3 complete, 127 total steps, 172.2-second mean, $2.234 total.
- The bytes were genuinely removed—79.5% to 99.4% reduction in image-bearing
  tool history—but the agent repeatedly called `view_files` and re-entered an
  eviction/reopen cycle.

Decision: rejected.

### Neutral metadata after three turns

The explicit reopen instruction was removed. Pixels stayed available for three
model requests, then became only path, media type, and byte length.

- Completion recovered to 3/3.
- No source image was reopened.
- Mean latency fell 17.3% and total authoring tokens fell 17.0%.
- Provider cost rose 36.4% because cache reads fell 77.6%.
- One case lost colors and typography relative to baseline.

Interim decision: interesting but not shippable. The arbitrary three-turn rule
had no industry or protocol foundation and quality/cache behavior needed more
testing.

## Round 2: four lifecycle policies

The follow-up explicitly removed image summaries and special reopen prompting.
It compared:

1. `retain-all`
2. the three most recently viewed image parts
3. a 2 MiB newest-image byte budget
4. a cache-aware 4 MiB high-water mark pruning to 2 MiB

### Three-case smoke matrix

The three-image sets did not cross the byte thresholds, so only `recent-3` was
an active treatment.

| Policy | Valid packages | Mean latency | Mean cost | Mean steps | `view_files` calls | Cache-read share |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Retain all | 3/3 | 142.1 s | $0.3050 | 15.7 | 10 | 61.0% |
| Recent three | 3/3 | 174.4 s | $0.6830 | 30.0 | 50 | 18.6% |
| Byte budget, threshold inactive | 3/3 | 126.8 s | $0.3126 | 15.3 | 12 | 52.8% |
| Cache-aware, threshold inactive | 3/3 | 127.1 s | $0.2928 | 14.7 | 12 | 53.7% |

The apparent byte-policy wins are A/A model variance because neither threshold
activated. `recent-3` increased latency by 22.7%, cost by 124.0%, and steps by
91.5%.

### Sixteen-image threshold-crossing stress case

| Policy | Outcome | Latency | Cost | Steps | `view_files` | Input tokens | Cache-read share |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Retain all | Valid | 164.5 s | at least $0.3580 | 14 | 4 | 426,908 | 70.2% |
| Recent three | Valid | 417.1 s | $1.4737 | 75 | 63 | 2,197,861 | 61.2% |
| Byte budget | Failed | 446.2 s | $2.0084 | 76 | 70 | 2,521,661 | 47.0% |
| Cache-aware | Failed | 454.1 s | $1.4443 | 76 | 70 | 2,515,121 | 65.2% |

Although `recent-3` reduced peak serialized context from 5.82 MiB to 1.84 MiB,
it made 15.75 times as many image-view calls. Its cumulative serialized context
still increased because the loop became much longer.

Latest decision: **do not ship image-history eviction**. It is superseded by
the later threshold-crossing evidence, even though the earlier three-turn test
looked promising.

## What the experiment establishes

- Prior image parts are not passive transcript storage. Replaying them lets the
  model inspect the same visual evidence without another tool call.
- A stable history is eligible for provider prefix caching. Mutating an older
  message damages that stability.
- Cache-hit percentage is not sufficient on its own: a 65% hit rate can still
  be slow and costly across 76 sequential requests.
- Removing raw pixels from debug archives after the run is safe and separate
  from removing them from model input during the run.
- The experiment rejects the tested eviction policies. It does not prove that
  unbounded inline base64 is the ideal transport or persistence format.

## Next controlled experiment already identified

Keep `retain-all` as the control and test a candidate that changes only Google’s
model-facing `mediaResolution` to `medium`. Run at least three repeats per arm on
the 16-image fixture, followed by three real local brands if it passes.

Gate on package validity, semantic/visual review, image re-reads, steps, input
tokens, cache-read share, provider cost, and latency. No system-prompt change or
model-authored image summary is needed.

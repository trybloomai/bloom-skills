# Production latency attribution

Date of analysis: 2026-10-05 UTC

## Sources

- PostHog saved insight: [Brand Agent average run latency (30d)](https://us.posthog.com/project/257478/insights/N53ZOsQO)
- PostHog saved insight: [Brand Agent provider-operation latency (30d)](https://us.posthog.com/project/257478/insights/lyyOcchF)
- Root event: `$ai_trace` with `$ai_trace_name = 'brand-agent-run'`
- Production-only comparisons use `execution_environment = 'production'`.
- The saved chart itself includes all surfaces and all source types unless its
  variables are overridden.

These are one-off incident calculations. No matching approved data-catalog
metric existed when the analysis was performed.

## Recent seven days versus preceding seven days

Across 1,146 recent runs, weighted average end-to-end latency was approximately
77.7 seconds, versus 64.0 seconds across 1,206 runs in the preceding window: a
13.7-second or roughly 21% increase.

| Surface and execution route | Prior runs | Recent runs | Prior E2E | Recent E2E | Prior agent | Recent agent |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Product, no generalized route | 821 | 736 | 49.27 s | 60.66 s | 19.84 s | 20.94 s |
| Product, `file_without_fast_adapter` | 202 | 187 | 119.14 s | 140.76 s | 98.78 s | 122.51 s |
| External API, no generalized route | 179 | 214 | 66.47 s | 73.76 s | 27.93 s | 28.49 s |
| Product, `eager_budget_rejected` | 4 | 7 | 188.92 s | 252.57 s | 138.76 s | 201.38 s |
| External API, `eager_budget_rejected` | 0 | 2 | n/a | 263.94 s | n/a | 200.83 s |

Approximate contributions to the 13.7-second increase, holding recent cohort
weights against prior cohort latency, are:

- Product, no generalized route: 7.3 seconds.
- Product, `file_without_fast_adapter`: 3.5 seconds.
- External API, no generalized route: 1.4 seconds.
- Rare eager-budget routes and traffic-mix change: the remainder.

Therefore the aggregate increase is predominantly a **product** issue, not an
External API issue. The high-volume non-generalized product path contributes the
largest number of added end-to-end seconds, while the generalized file route is
the more severe per-run and tail-latency problem.

## What happens inside the generalized file route

For recent product runs with `generalized_route_reason =
'file_without_fast_adapter'`:

| Measurement | Prior 7d | Recent 7d |
| --- | ---: | ---: |
| Average E2E latency | 119.14 s | 140.76 s |
| Average agent time | 98.78 s | 122.51 s |
| Generalized Sandbox startup | 4.06 s | 8.02 s |
| Generalized resource requests | 2.46 s | 3.96 s |
| Authoring-model latency | 86.88 s | 95.95 s |
| Authoring calls per run | 12.98 | 11.94 |
| Cumulative authoring input tokens | 298,567 | 336,617 |
| Cache-read input tokens | 156,036 | 189,563 |

The startup increased, but it is not the dominant cost. Recent runs spend about
96 seconds in authoring-model calls versus about eight seconds starting the
Sandbox. The architectural problem is the sequential model/tool loop and its
large multimodal context, not primarily VM provisioning.

The non-generalized product path also regressed end-to-end by 11.39 seconds,
but agent time increased by only 1.10 seconds. Source preparation increased by
2.30 seconds and validation by 1.83 seconds; the remainder is outside the three
currently charted component timings and needs finer orchestration/queue
instrumentation before assigning a root cause.

## Provider-operation evidence

Over the saved 30-day operation view:

- Google Gemini 3.7 Flash `agent.authoring`: 12,369 events, 11.77-second mean,
  29.52-second p95, 292.68-second maximum.
- Google Gemini asset description: 162,490 events, 5.12-second mean,
  13.47-second p95, 48.76-second maximum.
- Source preparation providers were materially smaller per operation: Context
  style/brand calls around 6–7 seconds, Firecrawl map around 5.6 seconds,
  Mistral OCR around 5.6 seconds, and OpenAI main-page selection around 4.7
  seconds.

Repeated sequential authoring generations are therefore the principal
model-stage latency source. Asset-description fan-out is a secondary workload,
not the explanation for the 96-second authoring total inside generalized runs.

## Terminology clarification

`served_speed` contained only `fast` and `served_route` only `primary` in the
observed trace values. There is no fast-versus-standard provider-tier comparison
to make in this data.

When this research says “fast path,” it means the **non-generalized execution
path**—a run that did not enter the generalized Sandbox—not a different model
service tier.

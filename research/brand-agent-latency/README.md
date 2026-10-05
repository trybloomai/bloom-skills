# Brand Agent latency and multimodal context research

Status: research handoff, 2026-10-05 UTC

This folder indexes the Brand Agent latency investigation performed from the
`bloom-skills` workspace. The production implementation lives in the `hero`
repository; no production code change is proposed or implemented on this
branch.

## Ordered reading

1. [Production attribution](./01-production-attribution.md) separates product
   from External API traffic and generalized-Sandbox routes from the
   non-generalized path.
2. [Image-context experiments](./02-image-context-experiments.md) records the
   lifecycle experiments and explains why simple eviction is currently worse
   than retaining a stable visual history.
3. [Architecture and final options](./03-architecture-options.md) explains the
   agent-loop mechanics, current SDK/provider guidance, and the decisions that
   remain.
4. [Handoff](./04-handoff.md) gives the next researcher a constrained brief and
   a checklist for presenting the decision back to the user.

## Executive conclusion

There are two latency effects, and they should not be conflated:

- The recent end-to-end average increased mainly on product traffic. The
  high-volume non-generalized product path contributes the largest number of
  added seconds to the aggregate mean.
- The rising **agent** component and the severe tail are concentrated in
  product runs routed to the generalized Sandbox because a file has no fast
  adapter. Those runs execute a long sequential model/tool loop over large
  multimodal history. The Sandbox boot itself is a small part of the time.

The model is not inherently doomed by images. Replaying conversation history is
the normal stateless-loop baseline, and pixels in prior messages remain useful
visual evidence. However, replaying an unbounded multimodal history is not a
complete scaling strategy. The latest local experiment rejects blind
count-based or byte-based image eviction: it caused repeated `view_files` calls,
destroyed cache-prefix stability, increased latency and cost, and sometimes
prevented authoring entirely.

The immediate controlled experiment should preserve the stable image history
and lower model-facing image resolution. Provider-managed conversation state or
cached content is a subsequent transport/cache experiment. Neither file
references nor server-side state makes visual information disappear from the
model's logical context.

## Tracked supporting artifacts

The branch deliberately includes the following normally ignored research
artifacts:

- `.context/context-lifecycle-experiment.md`
- `.context/image-context-policy-experiment.md`
- `.context/brand-agent-latency-root-cause-and-fix.drawio`
- `.context/brand-agent-latency-root-cause-and-fix.png`
- `.context/how-image-memory-survives-eviction.drawio`
- `.context/how-image-memory-survives-eviction.drawio.png`
- `.context/how-image-memory-survives-eviction.svg`
- `.context/observed-image-eviction-trace.drawio`
- `.context/observed-image-eviction-trace.drawio.png`
- `.context/observed-image-eviction-trace.svg`

Raw fixtures, cloned repositories, credentials, and attached user screenshots
are intentionally excluded.

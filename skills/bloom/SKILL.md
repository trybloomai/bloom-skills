---
name: bloom
version: 0.1.0
license: MIT
description: |
  Read this skill before generating, editing, resizing, vectorizing, or removing the background from any image with Bloom (any bloom_* tool). Trigger for any brand image, ad, logo, social post, hero, or OG card the user wants made or changed.
metadata:
  author: Bloom
  url: https://trybloom.ai/mcp
---

# Bloom

## The world model

Bloom owns the brand layer: when you call `bloom_generate_image` or `bloom_edit_image`, the brand's visual DNA and a brand-aware system prompt are already applied. So your prompt's job is narrow — describe the **subject**, the **composition**, and the **medium**; everything else is handled. [`rules/prompting.md`](rules/prompting.md) covers what that means.

## Required reading

For any Bloom generation, edit, resize, or brand-image task, read [`rules/workflow.md`](rules/workflow.md) before calling tools. It covers checking for references first.

Then read [`rules/prompting.md`](rules/prompting.md) for writing the prompt text.

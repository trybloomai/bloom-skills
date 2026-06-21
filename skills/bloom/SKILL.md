---
name: bloom
version: 0.1.0
license: MIT
description: |
  Creating, editing, resizing, or adapting brand images, ads, and social/marketing creative with Bloom: Instagram, LinkedIn, Facebook, X, TikTok posts, stories, carousels, thumbnails, banners, billboards, hero images, OG cards, or product shots using a brand's mascot, logo, or palette. Covers generating from a prompt, removing backgrounds, vectorizing logos, changing aspect ratio, and writing in-image headline copy. Trigger whenever the user mentions Bloom or asks to create/edit/resize a brand picture, post, or ad, or before any bloom_generate_image / bloom_edit_image / bloom_resize_image call. If a request produces or changes a brand picture, use this skill first.
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

## References

- Bloom has no memory between calls. If your prompt references an image (with a pronoun, a definite article, or "this"), that image has to be attached. The MCP server's `instructions` field covers the architectural details.

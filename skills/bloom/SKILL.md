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

Bloom is the system that owns brand. When you call `bloom_generate_image` or `bloom_edit_image`, the brand's visual DNA (palette, typography, tone, aesthetic, logo treatment) is already attached as image references, and a generation system prompt that knows the brand is applied on top, enforcing quality stances like restraint, whitespace, and no tech clichés.

So your prompt's job is narrow: describe the **subject**, the **composition**, and the **medium**. That's where your prompt adds information; everything else is already handled.

## Required reading

For any Bloom generation, edit, resize, or brand-image task, read [`rules/workflow.md`](rules/workflow.md) before calling tools. It covers checking for references first.

Then read [`rules/prompting.md`](rules/prompting.md) for writing the prompt text.

## References

- For tool semantics (parameters, async behavior, reference images, workspaces, credits), the tool descriptions on `bloom_generate_image`, `bloom_edit_image`, `bloom_list_images`, etc. are the source of truth. Read those rather than restating them here.
- Bloom has no memory between calls. If your prompt references an image (with a pronoun, a definite article, or "this"), that image has to be attached. The MCP server's `instructions` field covers the architectural details.

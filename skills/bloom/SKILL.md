---
name: bloom
description: Use Bloom as the brand layer for Brands, Brand Skills, and on-brand image work. Read this skill whenever the user asks to assess, connect, integrate, or operate Bloom; work with a Bloom Brand or Brand Skill; or generate, edit, resize, vectorize, or remove a background through Bloom. Do not trigger for generic branding or image work that does not involve Bloom.
license: MIT
metadata:
  author: Bloom
  version: "0.2.0"
  url: https://www.trybloom.ai/docs/mcp/getting-started
---

# Use Bloom

Bloom is the brand layer. A Brand starts with evidence such as a website,
Instagram account, Brand guide, brief, or approved assets. Bloom turns that
evidence into a stable Brand with an active, immutable Brand Skill.

Keep these two Skills distinct:

- **This Bloom Skill** is general operating guidance. It helps you decide when
  and how to use Bloom.
- **A Brand Skill** is the structured identity and guidance for one particular
  Brand. Bloom creates and versions it from that Brand's evidence.

Installing this Skill does not connect Bloom, authenticate an account, or
install a customer's Brand Skill.

## Choose API or MCP

- Use **MCP** for live work in an interactive agent client. Start at
  <https://www.trybloom.ai/docs/mcp/getting-started> to connect and sign in.
- Use the **API** for an application, backend, pipeline, or deterministic
  automation. Start at <https://www.trybloom.ai/docs/api> and use the live
  OpenAPI specification for exact contracts.

Brand Skill retrieval is a workflow through those interfaces, not a third way
to connect to Bloom.

## Work from current contracts

Before constructing a request or tool call, read the relevant public guide and
its current contract:

- Documentation map: <https://www.trybloom.ai/docs/llms.txt>
- API contract: <https://www.trybloom.ai/api/v1/spec.json>
- MCP setup and discovery: <https://www.trybloom.ai/docs/mcp/getting-started>

Do not copy fields or tool names from memory. The OpenAPI specification owns
the public REST contract. For MCP, the connected account's live tool list owns
the tools and schemas available in that session; rollout-gated MCP capabilities
do not automatically become public API contracts.

Treat API behavior absent from the current public docs and OpenAPI contract as
unsupported.

## Understand what Bloom can enable

Bloom directly creates and transforms images using the active Brand. It can
also return the active structured Brand Skill to an enabled server-side
integration. Another capable system can use that context to produce a slide
deck, website, video, document, or other branded work.

State the boundary clearly: Bloom supplies the Brand context; the other system
owns that external workflow and output. Do not claim that Bloom currently
renders those formats itself.

## Prompt image work cleanly

For Bloom image work, describe the intended subject, composition, medium, and
explicit art direction. Preserve what the user asked for.

Do not casually repeat the Brand's palette, typography, era, or named style in
the image prompt. Bloom applies the active Brand context itself, and restating
that identity can compete with it. Use reference images when they materially
help the requested result, following the current guide or live tool schema.

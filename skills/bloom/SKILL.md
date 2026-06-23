---
name: bloom
version: 0.1.0
license: MIT
description: |
  Read this skill before generating, editing, resizing, vectorizing, or removing the background from any image with Bloom. Trigger for any brand image, ad, logo, social post, hero, or OG card the user wants made or changed.
metadata:
  author: Bloom
  url: https://trybloom.ai/mcp
---

# Bloom

Bloom is a brand-aware system. So your prompt's job is narrow. Describe the subject (what's in the frame), the composition (how it's arranged), and the medium when the concept calls for it (photograph, illustration, 3D render, vector). That's the surface where your prompt adds information. Everything else is already handled.

Over-specifying the aesthetic is the most common mistake when prompting Bloom. The fix is narrow: cut the words the brand layer already covers, and keep the words that carry real information or what the user actually asked for. Ask of any word: is it doing something the brand layer doesn't already do? If it's generic decoration, cut it. If it's a constraint, a concrete spec, or the look the user asked for, keep it exactly.

**Strip (decoration the brand already applies):**

- Aesthetic filler: *professional, sleek, premium, modern, minimalist, clean, refined, high-quality, hyperrealistic.* Cutting "premium" changes nothing; the brand layer already handles it.
- Cliché-conflicting words, when they aren't the concept: *futuristic, neon, holographic, circuit-textured, high-tech.* They point at the clichés the system already steers away from, and the output gets muddier than if you'd said nothing about style.
- A "match the attached references" instruction. The model uses attached references on its own.

**Keep (real information, exactly as written):**

- Functional constraints: "do not alter the label or text," "no batch number or expiry," "no logos in the overlay," the exact headline copy, exact hex codes, exact layout ("top 38% photo"), "back view." These are instructions, not decoration, and dropping them changes the output.
- Negative constraints: "no humans," "no UI mockups." Real steering.
- The user's concept, in their words: if they asked for a cyberpunk launch hero, a 1970s period poster, a gritty analog brand, or a person at a laptop, carry it through exactly. The aesthetic or subject is the concept, not filler you added. The same word you'd cut as filler ("neon") you keep when the user made it the point.

## Check for references before generating

Uploaded or scraped reference images are the strongest on-brand anchor you have. Search the library at least once before generating; when good matches exist, attach them. Skipping the check risks generic output when strong references were available.

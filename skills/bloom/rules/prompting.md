# Writing the prompt text

## What your prompt's job is

When you call `bloom_generate_image` or `bloom_edit_image`, the brand's visual DNA (palette, typography, tone, aesthetic, logo treatment) is already applied, along with a brand-aware generation system prompt that enforces quality stances: clean and refined, restraint with whitespace, no tech clichés (circuit boards, binary, garish gradients), no generic stock-imagery feel, faithful logo reproduction where appropriate.

So your prompt's job is narrow. Describe the **subject** (what's in the frame), the **composition** (how it's arranged), and the **medium** when the concept calls for it (photograph, illustration, 3D render, vector). That's the surface where your prompt adds information. Everything else is already handled.

## Minimal beats detailed

A short prompt that leans on the brand layer beats a long one. Describe only what the image needs (subject, composition, and medium when it matters), adding detail only when the concept calls for it.

## What to prompt for

Subject and composition carry most of the information.

Specify medium when you want to nudge toward a particular idiom: "photograph," "vector illustration," "isometric 3D render," "line drawing." Leave it off when the medium should follow from the brand's existing visual DNA.

## What to strip, what to keep

Over-specifying the aesthetic is the most common mistake when prompting Bloom. The fix is narrow: cut the words the brand layer already covers, and keep the words that carry real information or what the user actually asked for. Ask of any word: is it doing something the brand layer doesn't already do? If it's generic decoration, cut it. If it's a constraint, a concrete spec, or the look the user asked for, keep it exactly.

**Strip (decoration the brand already applies):**

- Aesthetic filler: *professional, sleek, premium, modern, minimalist, clean, refined, high-quality, hyperrealistic.* Cutting "premium" changes nothing; the brand layer already handles it.
- Cliché-conflicting words, when they aren't the concept: *futuristic, neon, holographic, circuit-textured, high-tech.* They point at the clichés the system already steers away from, and the output gets muddier than if you'd said nothing about style.
- A "match the attached references" instruction. The model uses attached references on its own.

**Keep (real information, exactly as written):**

- Functional constraints: "do not alter the label or text," "no batch number or expiry," "no logos in the overlay," the exact headline copy, exact hex codes, exact layout ("top 38% photo"), "back view." These are instructions, not decoration, and dropping them changes the output.
- Negative constraints: "no humans," "no UI mockups." Real steering.
- The user's concept, in their words: if they asked for a cyberpunk launch hero, a 1970s period poster, a gritty analog brand, or a person at a laptop, carry it through exactly. The aesthetic or subject is the concept, not filler you added. The same word you'd cut as filler ("neon") you keep when the user made it the point.

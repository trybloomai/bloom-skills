# Writing the prompt text

## What your prompt's job is

When you call `bloom_generate_image` or `bloom_edit_image`, the brand's visual DNA (palette, typography, tone, aesthetic, logo treatment) is already attached as image references, and a generation system prompt that knows the brand is applied on top. It also enforces quality stances: clean and refined, restraint with whitespace, no tech clichés (circuit boards, binary, garish gradients), no generic stock-imagery feel, faithful logo reproduction where appropriate.

So your prompt's job is narrow. Describe the **subject** (what's in the frame), the **composition** (how it's arranged), and the **medium** when the concept calls for it (photograph, illustration, 3D render, vector). That's the surface where your prompt adds information. Everything else is already handled.

## Minimal beats detailed

A short prompt that leans on the brand layer beats a long one. Describe only what the image needs (subject, composition, and medium when it matters), adding detail only when the concept calls for it.

## What to prompt for

Subject and composition carry most of the information. A few examples of the right grain:

- "A laptop on a wooden desk, viewed from a slightly elevated angle, with the dashboard visible on the screen."
- "A founder seated in a plant-filled co-working space, holding a coffee, looking off-frame to the right."
- "Two hands stacking smooth white ceramic shapes on a textured concrete surface, top-down view."

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
- The brand's real register: a loud, playful, or gritty brand should be prompted to its actual identity. Don't reach for "editorial restraint" and whitespace on a brand whose whole point is energy.
- Subject, composition, and medium. Always.

## Examples

### Scenario: hero image for a B2B SaaS landing page

**Over-specified prompt (avoid):**

> A modern, sleek, premium SaaS hero image with futuristic holographic dashboard elements, glowing neon-blue accents, glassmorphism effects, on a clean minimalist background with a high-tech aesthetic.

Almost every adjective duplicates what the brand layer is doing (*modern, sleek, premium, clean, minimalist*) or actively fights it (*futuristic, holographic, neon, glassmorphism, high-tech*). The output ends up noisier than if no aesthetic instruction had been given.

**Better prompt:**

> A laptop on a clean wooden desk, viewed from a slightly elevated angle, with the SaaS dashboard visible on the screen. Photograph.

Subject (laptop, desk, dashboard), composition (elevated angle, dashboard visible), medium (photograph). Bloom handles the rest.

### Scenario: OG card for a pricing page

**Over-specified prompt (avoid):**

> A professional, sophisticated, premium pricing card with three glowing tiers floating against a futuristic minimalist gradient background, modern tech aesthetic.

*Professional, sophisticated, premium, minimalist, modern* are redundant. *Glowing, futuristic, tech aesthetic* fight the anti-cliché stance. And the prompt is fully aesthetic; it never says what's actually in the frame.

**Better prompt:**

> Three pricing tier cards arranged side by side on a soft neutral background, each with a header and a list of features. The middle card is slightly raised, suggesting it's the recommended option.

Now the prompt tells Bloom what's in the frame and how it's laid out.

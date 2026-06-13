# Writing the prompt text

## What your prompt's job is

When you call `bloom_generate_image` or `bloom_edit_image`, the brand's visual DNA (palette, typography, tone, aesthetic, logo treatment) is already attached as image references, and a generation system prompt that knows the brand is applied on top. It also enforces quality stances: clean and refined, restraint with whitespace, no tech clichés (circuit boards, binary, garish gradients), no generic stock-imagery feel, faithful logo reproduction where appropriate.

So your prompt's job is narrow. Describe the **subject** (what's in the frame), the **composition** (how it's arranged), and the **medium** when the concept calls for it (photograph, illustration, 3D render, vector). That's the surface where your prompt adds information. Everything else is already handled.

## Minimal beats detailed

A short prompt that leans on the brand layer beats a long one. Describe only what the image needs — subject, composition, and medium when it matters — adding detail only when the concept calls for it. Don't open with "a [brand] post": the brand is applied downstream, so naming it just repeats the brand layer.

## What to prompt for

Subject and composition carry most of the information. A few examples of the right grain:

- "A laptop on a wooden desk, viewed from a slightly elevated angle, with the dashboard visible on the screen."
- "A founder seated in a plant-filled co-working space, holding a coffee, looking off-frame to the right."
- "Two hands stacking smooth white ceramic shapes on a textured concrete surface, top-down view."

Specify medium when you want to nudge toward a particular idiom: "photograph," "vector illustration," "isometric 3D render," "line drawing." Leave it off when the medium should follow from the brand's existing visual DNA.

## References over adjectives

When you want the brand's existing look, attach reference images — don't describe that style in words, and don't add a "match the attached references" instruction either. The image model uses attached references natively, the generation pipeline references them downstream, and the brand is already applied on top; restating it in the prompt is redundant and just gives the model a second, blurrier copy of the instruction. If you want a *specific* look the brand wouldn't reach by default, attach a reference rather than writing it out. The one exception is an exact reproduction: if the user needs a near-copy of a specific reference, say so explicitly.

## Constraints, not styling

Negative constraints are legitimate and useful; aesthetic adjectives aren't. "No humans, no laptops, no UI mockups" steers the model away from the generic person-at-a-laptop SaaS-stock default it falls into when left unguided. That's a real instruction. "Sleek, modern, premium" is not; it just repeats the brand layer.

## Palette-color override

If a brand color shouldn't dominate a particular image (a red accent showing up as the primary color when it should be a highlight), call it out explicitly in the prompt ("red used only as a small accent, not the dominant color"). If the same problem keeps recurring across generations, the fix is upstream: suggest updating the brand's color system in Bloom so future gens auto-correct, instead of fighting it per-prompt.

## The failure mode

The most common mistake when prompting Bloom is over-specifying aesthetic. Several flavors:

**Redundant adjectives.** Words like *professional*, *sleek*, *premium*, *modern*, *minimalist*, *clean*, or *refined* describe what Bloom already does. The brand layer carries the aesthetic. Repeating it mostly wastes tokens; at best you've added nothing.

**Conflicting adjectives.** Words like *futuristic*, *neon*, *cyberpunk*, *holographic*, *circuit-textured*, *high-tech*, or *digital* point at exactly the visual clichés the system prompt steers away from. When the prompt pulls toward those clichés, the model is satisfying two opposing forces and the output gets muddier than if you'd said nothing about style.

**Generic person-at-laptop scenes.** Asking for "a person working on a laptop" or "a team collaborating in an office" lands you in the stock-photo default the brand layer is trying to escape. If the concept genuinely needs a person, describe a specific, non-generic moment; otherwise constrain it out.

**Premium-restraint applied to the wrong brand.** The system aims for clean and refined by default, but not every brand wants that register. A brand that's loud, playful, maximalist, or gritty should be prompted to its actual identity; don't reflexively reach for "editorial restraint" and "lots of whitespace" on a brand whose whole point is energy. Match the brand's real register, not a generic premium one.

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

## When to deviate

The world model exists to catch the failure mode above. It doesn't override genuine concept-driven intent.

If the user has explicitly asked for a specific aesthetic that *is* the concept (a deliberately cyberpunk-themed launch hero, a brand whose identity actually is gritty and analog, an event poster where the period style is the point), follow user intent. The world model says "don't reflexively layer on aesthetic adjectives that fight the brand." It doesn't say "never describe a visual style."

The test: are the aesthetic words you're considering serving a concept the user asked for, or are they default boilerplate you're adding because the prompt feels too plain? If the second, drop them.

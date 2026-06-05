# Choosing an aspect ratio for a platform

When the user names a platform but not a ratio, use this mapping. Confirm with the user if the destination is ambiguous.

| Destination | Aspect ratio |
|---|---|
| X / Twitter | `1:1` |
| LinkedIn | `4:5` |
| Instagram feed | `4:5` |
| Instagram story | `9:16` |
| Blog hero / pitch-deck cover / web banner / OG card | `16:9` |

## Only use ratios Bloom supports

The supported set is: `1:1`, `2:3`, `3:2`, `3:4`, `4:3`, `4:5`, `5:4`, `9:16`, `16:9`, `21:9`.

The common gotcha is the OG card. Open Graph images are usually 1.91:1, which is **not** a supported Bloom ratio, so map it to `16:9` rather than inventing `1.91:1`. The same rule holds for any platform spec that doesn't line up with the list: pick the nearest supported ratio, don't pass one Bloom can't accept.

This mapping applies both to the `aspect_ratio` you pass to `bloom_generate_image` and to the `target_aspect_ratio` of `bloom_resize_image`. Same supported set either way.

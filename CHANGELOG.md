# Changelog

All notable changes to the Bloom Skill and Agent Plugin. This project follows [Semantic Versioning](https://semver.org).

After updating, re-run `npx skills update bloom` (local agents) or re-download the
[latest ZIP](https://github.com/trybloomai/bloom-skills/releases/latest/download/bloom.skill.zip)
and re-upload it (Claude Desktop, Claude web, Cowork).
For plugin installations, reload an updated plugin directory or local
`dist/bloom.plugin.zip` using your client's update flow.

## [Unreleased]

### Added

- Portable Agent Plugins 1.0 packaging in root `plugin.json` and `mcp.json`,
  using the identifier `bloom` and Bloom's remote Streamable HTTP endpoint
  `https://mcp.trybloom.ai/mcp`.
- `dist/bloom.plugin.zip`, built with dependency-free Bash scripts and standard
  command-line utilities. Offline validation checks JSON, schema versions,
  matching names, synchronized release versions, exact archive structure, and
  byte-identical source files in both distributions.
- Optional OpenAI website presentation metadata so ChatGPT's plugin details
  link to `https://www.trybloom.ai`, with offline validation of that field.

### Changed

- Documented portable plugin installation, packaging, and validation alongside
  the existing standalone Skill workflows.
- Included the plugin ZIP in the tracked distribution files and ignored local
  `.context/` work files.
- Retained `bloom-skills` as the repository name and `0.5.0` as the shared
  package and Skill version. The canonical `skills/bloom/SKILL.md` and existing
  `dist/bloom.skill.zip` are unchanged.

## [0.5.0] - 2026-09-24

### Changed

- Make Brand creation and editing explicit in the Skill description.
- Default requests to change an existing Brand to the Brand Edit workflow,
  preserving its Brand ID. Keep new Brand onboarding available when the user
  explicitly wants a separate Brand.

## [0.4.0] - 2026-09-22

### Changed

- Distinguished `generate_image`, which applies Brand context automatically,
  from generation with a chosen model.
- Described image, video, audio, and SVG generation with a chosen model,
  including Brand retrieval with `get_brand` and `view_files`.
- Extended asynchronous-work guidance to generation and clarified which
  workflows Bloom leaves to connected systems.

## [0.3.0] - 2026-09-22

### Changed

- Explained the shared candidate-first lifecycle for instruction and exact
  profile edits, including related Markdown changes and activation through Apply.
- Added guidance for inspecting candidates according to the task and delegated
  authority, with a link to the [Brand editing guide](https://docs.trybloom.ai/guides/edit-brand).
- Included Brand edits in the guidance for completing asynchronous work.

## [0.2.0] - 2026-09-15

### Changed

- Reframed Bloom as the brand layer and distinguished the general Bloom Skill
  from each customer-specific Brand Skill.
- Routed interactive work to MCP and application integrations to the API without
  duplicating their current contracts.
- Explained how brand context can guide external slide, website, video, and
  document workflows without claiming that Bloom renders those outputs.
- Made project installation the default and reduced setup documentation to the
  canonical Bloom quickstarts.
- Made Bloom's documentation URL the primary install source while retaining the
  public repository as the inspectable source and direct-install fallback.
- Added concise guidance for completing asynchronous work and caching retrieved
  Brand Skills by `skillId`.
- Generated the Claude upload ZIP from the same one-file Skill source.

## [0.1.0] - 2026-06-05

First public release.

### Added

- `bloom` skill: a dispatcher `SKILL.md` plus `rules/` for prompting, in-image copy, run workflow, and per-platform aspect ratios.
- Frontmatter `version`, `license`, and `metadata` (author, url).
- Failure-recovery table in `rules/workflow.md`: what to do when a run stays pending, errors, runs out of credits, or comes back off-brand, instead of retrying blindly.
- README with a centered hero, badges, and a per-agent install table.
- `docs/quickstart.md` with per-agent setup, manual ZIP flow, updates, and troubleshooting.

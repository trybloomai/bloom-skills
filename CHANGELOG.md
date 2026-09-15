# Changelog

All notable changes to the Bloom agent skill. This project follows [Semantic Versioning](https://semver.org).

After updating, re-run `npx skills update bloom` (local agents) or re-download the
[latest ZIP](https://github.com/trybloomai/bloom-skills/releases/latest/download/bloom.skill.zip)
and re-upload it (Claude Desktop, Claude web, Cowork).

## [Unreleased]

### Changed

- Reframed Bloom as the brand layer and distinguished the general Bloom Skill
  from each customer-specific Brand Skill.
- Routed interactive work to MCP and application integrations to the API without
  duplicating their current contracts.
- Explained how Brand context can guide external slide, website, video, and
  document workflows without claiming that Bloom renders those outputs.
- Made project installation the default and reduced setup documentation to the
  canonical Bloom quickstarts.
- Generated the Claude upload ZIP from the same one-file Skill source.

## [0.1.0] - 2026-06-05

First public release.

### Added

- `bloom` skill: a dispatcher `SKILL.md` plus `rules/` for prompting, in-image copy, run workflow, and per-platform aspect ratios.
- Frontmatter `version`, `license`, and `metadata` (author, url).
- Failure-recovery table in `rules/workflow.md`: what to do when a run stays pending, errors, runs out of credits, or comes back off-brand, instead of retrying blindly.
- README with a centered hero, badges, and a per-agent install table.
- `docs/quickstart.md` with per-agent setup, manual ZIP flow, updates, and troubleshooting.

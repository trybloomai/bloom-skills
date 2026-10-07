# Changelog

Notable changes to the Rainbrand Skill and Agent Plugin. This project follows
[Semantic Versioning](https://semver.org).

## [Unreleased]

## [1.1.0] - 2026-10-07

### Changed

- Migrate the distribution identity from the preceding 1.0.6 release to
  Rainbrand: the plugin, MCP server, canonical Skill, install commands, and
  distribution archives now use `rainbrand`.
- Connect to `https://mcp.rainbrand.com/mcp` and use Rainbrand website, support,
  and legal URLs. Preserve the Skill's existing workflow guidance.
- Align review cases with live MCP tool names and document the account setup
  and conversation sequence needed to supply their IDs.
- Make both archives reproducible across time zones and umasks, with shared
  validation of source contents and metadata.
- Separate draft package validation from submission readiness. Approved artwork
  and a new walkthrough are still required before OpenAI submission.
- Document the repository rename and new release publication as manual gates,
  along with provider testing and Claude's native plugin compatibility limits.

### Removed

- Retire the preceding distribution's visual assets from the new package.
  Approved Rainbrand artwork is pending; no substitute icon is bundled.

## Earlier releases

History through 1.0.6 remains in the
[historical changelog](https://github.com/trybloomai/rainbrand-skills/blob/v1.0.6/CHANGELOG.md).
That link becomes available after the repository rename. Earlier tags, releases,
and their assets remain unchanged; 1.1.0 starts the Rainbrand distribution
history.

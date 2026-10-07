# Rainbrand Skill and Agent Plugin

Rainbrand is the brand layer for agents. It turns a brand's identity, guidance,
and assets into shared context that agents and products can use and update as
the brand evolves, alongside the tools where it is created and managed.

This repository maintains one optional Agent Skill and packages it with
Rainbrand's remote Model Context Protocol (MCP) connection as an
[Agent Plugins 1.0](https://agent-plugins.org/specification) plugin. Both use
the identifier `rainbrand`.

The Rainbrand Skill teaches an agent when and how to use Rainbrand. A Brand
Skill contains the context for one particular brand. Installing the standalone
Skill supplies guidance; the plugin also declares the MCP connection. The
client handles authentication.

## Install

From this checkout, install the Skill in the current project:

```bash
npx skills add . --skill rainbrand
```

Prefer a project installation so the guidance is reviewable with the project.

### Standalone Skill upload

The local [dist/rainbrand.skill.zip](dist/rainbrand.skill.zip) contains the
canonical Skill as `rainbrand/SKILL.md`. Upload that archive through Claude's
Skill upload flow.

### Portable plugin

Use this repository root as the plugin directory, or extract the local
[dist/rainbrand.plugin.zip](dist/rainbrand.plugin.zip). Load it in a client
that supports Agent Plugins 1.0 and Streamable HTTP, then follow the client's
OAuth sign-in flow.

The archive contains these files directly at its root:

```text
plugin.json
mcp.json
skills/rainbrand/SKILL.md
README.md
CHANGELOG.md
LICENSE
assets/README.md
```

Both manifests declare the Agent Plugins `1.0.0` schemas. `mcp.json` defines
one server named `rainbrand` with transport `streamable-http` and endpoint
`https://mcp.rainbrand.com/mcp`. The package contains no credentials. Approved
Rainbrand artwork is pending, so this draft includes no logo file or logo
metadata; see [asset status](assets/README.md).

## Connect Rainbrand

For interactive work, connect `https://mcp.rainbrand.com/mcp` in an MCP client
that supports Streamable HTTP and OAuth. A plugin client reads that connection
from `mcp.json`; a standalone Skill installation needs it configured separately.
Complete Rainbrand sign-in, then let the client discover the live tools and
their schemas. The live tool list determines what the connected account can use.

For product information, support, and API integration guidance, use the
[Rainbrand website](https://www.rainbrand.com/) and
[FAQ](https://www.rainbrand.com/faq/). Before building an application or backend
integration, obtain a current, verified Rainbrand API contract. Keep API keys
in the application's secret store.

## Provider compatibility

The portable package is a draft for client testing. Successful local validation
does not establish acceptance by a provider or publication in its directory.

| Provider | Current path | Remaining gate |
| --- | --- | --- |
| OpenAI | Import the portable ZIP and test the remote MCP connection in a supported client. The manifest includes listing copy and review cases. | Complete artwork, recording, ownership verification, reviewer access, client testing, and a new submission for the Rainbrand MCP origin. |
| Claude | Upload the standalone Skill ZIP and configure the remote MCP connection separately. | The portable plugin ZIP is not currently compatible with Claude's native plugin upload or directory format. |
| Cursor | Test the root Agent Plugins manifest from the existing public repository checkout. | Test installation from the public repository and submit its current URL through the marketplace portal. |

OpenAI's build and submission requirements are documented in
[Build plugins](https://developers.openai.com/plugins/build/plugins) and
[Submit your plugin](https://developers.openai.com/plugins/deploy/submission).
Its [review rules](https://developers.openai.com/plugins/deploy/app-review)
require a new submission when the MCP server origin changes; this migration
must not update the previous submission's origin. Test the actual target client;
importing this ZIP does not establish ChatGPT web availability.

Claude's native format requires `.claude-plugin/plugin.json` and `.mcp.json`
with transport `http`. Those root paths conflict with the portable
specification's requirement that client-specific files use a reverse-domain
top-level directory. This repository does not add an undocumented adapter or a
second maintained implementation. Reconcile those contracts before adding a
native adapter. At that point, also check Claude's archive rules: the repository
contains distribution ZIPs, and a native upload must not contain nested ZIPs.
See [Claude plugin requirements](https://claude.com/docs/plugins/build), the
[pre-submission checklist](https://claude.com/docs/plugins/pre-submission-checklist),
and [directory publishing](https://claude.com/docs/directory/publish).

Cursor recognizes the root `plugin.json`; a separate `.cursor-plugin/plugin.json`
manifest is not required for this format. See
[Cursor plugins](https://cursor.com/docs/reference/plugins) and
[marketplace submission](https://cursor.com/marketplace/publish).

## Review and publication checklist

The manifest supplies five read-only positive cases and three negative cases
for OpenAI review. Tool names match the server's raw `tools/list` names:
`list_brands`, `get_brand`, `get_account`, `list_workspaces`, and `check_credits`.
A client may qualify them with the server name, for example
`mcp__rainbrand__list_brands`.

Prepare a dedicated reviewer account with a sample Stripe brand. Run the
positive cases in order in the same conversation: the first case supplies the
Stripe Brand session ID for `get_brand`, and the workspace case supplies the
personal `workspace_id` for `check_credits`. The personal-credit case expects
only `check_credits`. The exchange-rate, Tokyo weather, and arithmetic cases
must invoke no Rainbrand tools; the arithmetic answer is 42. Live connection,
discovery, and calls to all five tools have passed. The brand retrieval check
used another existing brand; the eight exact prompts still need to be exercised
with a dedicated reviewer account containing Stripe. Put reviewer credentials
and private instructions in the provider's review portal, never in this
repository.

Before public submission:

- Add the approved Rainbrand icon and its listing metadata, then rebuild both
  archives. This is the only outstanding visual asset; the existing public icon
  is not approved Rainbrand artwork.
- Record and upload a reviewer-accessible Rainbrand walkthrough. The manifest
  omits `demo_recording_url` until that recording is available. Add its actual,
  verified HTTPS URL and rebuild before OpenAI review.
- If OpenAI issues a new ownership challenge, serve the exact plain-text token
  from the portal at the eligible Rainbrand HTTPS origin. Do not reuse an old
  challenge token.
- Check public website, support, and legal pages for the completed Rainbrand
  rollout. Reachable pages alone do not establish that launch is complete.
- Complete each provider's client tests, review requirements, and submission
  process. Provider review determines whether these brand and design workflows
  are accepted; the portable format is not universal approval.

A later repository rename is optional housekeeping, not a submission gate.
Publishing downloadable release assets is also an optional distribution
follow-up. Preserve every earlier tag, release, and asset unchanged. Use the
current public repository URL in provider portals that require one.

## Update or remove

```bash
npx skills update rainbrand
npx skills remove rainbrand
```

Add `--global` for a global installation.

## Package and validate

The canonical source is `skills/rainbrand/SKILL.md`. Build both archives and
validate them in this order:

```bash
scripts/package-skill.sh
scripts/package-plugin.sh
scripts/validate-plugin.sh
```

Pass a ZIP path to `scripts/validate-plugin.sh` to validate another local copy
against this checkout. Check submission readiness separately:

```bash
scripts/validate-plugin.sh --submission
```

The draft package can pass ordinary validation while submission readiness
fails for the missing approved artwork and recording metadata. Readiness
validation does not replace the manual publication and provider checks above.

The scripts run offline with Bash 3.2 or later, POSIX `awk`, `zip`, Info-ZIP
`unzip` (including `-Z`), and standard shell utilities. They require no package
manager or additional language runtime.

Validation checks JSON types, duplicate and unsupported fields, schema
identifiers, matching names, the exact MCP endpoint, and OpenAI metadata. The
plugin version, Skill version, and latest numbered changelog release must agree.
Archive checks cover integrity, exact members, regular file types, and
byte-for-byte agreement with source files. Both builders fix timestamps and
file modes so unchanged sources produce identical archives with the same ZIP
tool version, including across time zones and umasks.

For packaging changes, run the optional regression suite:

```bash
python3 scripts/test-validation.py
```

These tests exercise malformed metadata, unsafe or mismatched archives,
submission gates, and reproducible builds. Python 3 is required only for this
test suite, not for package building or validation.

## License

[MIT](LICENSE)

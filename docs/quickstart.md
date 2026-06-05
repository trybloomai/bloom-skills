# Bloom Skill Quickstart

Use this guide to install the Bloom skill and connect it to the Bloom MCP server.

The short version:

```bash
npx skills add trybloomai/bloom-skills --skill bloom --global
```

Then connect Bloom MCP from:

```text
https://trybloom.ai/mcp
```

## Choose Your Client

### Claude Code, Codex, Cursor, And Local Agents

If your agent can run terminal commands in your project, give it this:

```text
Install the Bloom skill by running:
npx skills add trybloomai/bloom-skills --skill bloom --global

Then connect Bloom MCP from:
https://trybloom.ai/mcp

After that, use Bloom whenever I ask for image generation.
```

Use this flow for Claude Code, Codex, Cursor, OpenCode, Windsurf, and other local coding agents that support Agent Skills through `npx skills`.

### Claude Desktop, Claude Web, And Cowork

These clients need a manual skill upload. Do not give them the `npx skills add` command and expect it to install locally.

1. Download [`bloom.skill.zip`](https://github.com/trybloomai/bloom-skills/releases/latest/download/bloom.skill.zip).
2. Upload that ZIP in Claude's Skills settings.
3. Connect Bloom MCP from:

   ```text
   https://trybloom.ai/mcp
   ```

The ZIP root contains `SKILL.md` and `rules/`, which is the structure Claude expects.

## What This Skill Does

The Bloom MCP server owns the mechanics: authentication, tool parameters, generation, editing, resizing, image lookup, and credits.

The Bloom skill improves agent judgment. It tells the agent how to:

- Write prompts that describe subject, composition, and medium instead of redundant style words
- Choose a supported aspect ratio for common channels
- Pull and pass reference images when a brand has a distinctive visual language
- Write concise in-image headline copy

The skill does not authenticate Bloom or install the MCP server by itself.

## Install For Local Coding Agents

Recommended: install globally so Bloom guidance is available across projects:

```bash
npx skills add trybloomai/bloom-skills --skill bloom --global
```

Install only in the current project:

```bash
npx skills add trybloomai/bloom-skills --skill bloom
```

Install globally for a specific agent:

```bash
npx skills add trybloomai/bloom-skills --skill bloom --agent claude-code --global
npx skills add trybloomai/bloom-skills --skill bloom --agent codex --global
npx skills add trybloomai/bloom-skills --skill bloom --agent cursor --global
```

Install globally for multiple agents:

```bash
npx skills add trybloomai/bloom-skills \
  --skill bloom \
  --agent claude-code \
  --agent codex \
  --agent cursor \
  --global
```

Run without prompts for setup scripts:

```bash
npx skills add trybloomai/bloom-skills --skill bloom --global --yes
```

## Use Without Installing

Use this when you want to hand the skill to an agent for one session:

```bash
npx skills use trybloomai/bloom-skills@bloom
```

## Connect Bloom MCP

The skill only teaches the agent how to use Bloom well. The agent still needs access to Bloom's MCP tools.

Setup page:

```text
https://trybloom.ai/mcp
```

MCP endpoint:

```text
https://www.trybloom.ai/api/mcp
```

Claude Code:

```bash
claude mcp add --transport http bloom https://www.trybloom.ai/api/mcp
```

Codex:

```toml
[mcp_servers.bloom]
url = "https://www.trybloom.ai/api/mcp"
```

Cursor:

```json
{
  "mcpServers": {
    "bloom": {
      "url": "https://www.trybloom.ai/api/mcp"
    }
  }
}
```

## Manual ZIP Build

The latest release ZIP is the easiest path for Claude Desktop, Claude web, and Cowork:

```text
https://github.com/trybloomai/bloom-skills/releases/latest/download/bloom.skill.zip
```

If you need to rebuild it from source:

```bash
cd skills/bloom
zip -r ../../dist/bloom.skill.zip SKILL.md rules
```

## Check That It Installed

List available skills:

```bash
npx skills list
```

Inspect this repository without installing:

```bash
npx skills add trybloomai/bloom-skills --list
```

Expected result: one skill named `bloom`.

## Update Or Remove

Update installed skills:

```bash
npx skills update bloom
```

Remove the skill:

```bash
npx skills remove bloom
```

## Example Prompts

```text
Generate an Instagram feed launch image for Acme with Bloom. The product box floating above a messy breakfast table, morning light, one hand reaching into frame. Photograph.
```

```text
Generate a LinkedIn feature announcement image for Acme with Bloom. Three product cards arranged like physical index cards on a desk, one card pulled forward as the hero. Overhead photograph.
```

```text
Make a story-sized version of the last Bloom image.
```

## Troubleshooting

If the skill does not trigger:

- Confirm it is installed with `npx skills list`
- Restart the agent if it only loads skills on startup
- Ask the agent explicitly: `Use the bloom skill`
- Confirm Bloom MCP is connected separately from the skill

If Bloom tools are unavailable:

- Reopen `https://trybloom.ai/mcp`
- Reconnect or re-authenticate the MCP server
- Check that the MCP endpoint is `https://www.trybloom.ai/api/mcp`

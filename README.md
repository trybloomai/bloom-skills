<div align="center">

<img src="assets/bloom-mcp-og.png" alt="Bloom — the brand layer, callable from anywhere" width="100%" />

# Bloom Skill

Persistent guidance for agents working with Bloom.

</div>

Bloom turns Brand evidence into a working system that agents and applications
can call. This repository contains one optional Agent Skill that teaches an
agent what Bloom is, when to use it, and whether a workflow belongs on the API
or MCP.

> A Bloom Skill teaches an agent how and when to use Bloom.
>
> A Brand Skill contains the context for one particular Brand.

The Skill does not connect or authenticate Bloom. API and MCP remain the
execution paths.

## Install

Install in the current project so the guidance is reviewable and shared with
the repository:

```bash
npx skills add trybloomai/bloom-skills --skill bloom
```

Use `--global` when you deliberately want Bloom guidance across unrelated
projects:

```bash
npx skills add trybloomai/bloom-skills --skill bloom --global
```

To use the Skill for one session without installing it:

```bash
npx skills use trybloomai/bloom-skills@bloom
```

### Claude upload

Claude chat, desktop, and Cowork can upload a custom Skill directly. Download
[`bloom.skill.zip`](https://github.com/trybloomai/bloom-skills/releases/latest/download/bloom.skill.zip),
then choose **Customize → Skills → Create skill → Upload a skill**.

The ZIP contains the same `bloom/SKILL.md` as the repository install.

## Connect or integrate Bloom

- For interactive agent work, follow the
  [Bloom MCP quickstart](https://www.trybloom.ai/docs/mcp/getting-started).
- For an application or backend, follow the
  [Bloom API quickstart](https://www.trybloom.ai/docs/api).
- For the complete documentation map, read
  [Bloom's `llms.txt`](https://www.trybloom.ai/docs/llms.txt).

The Skill contains no credentials and does not configure MCP. Interactive MCP
clients authenticate through Bloom's OAuth flow; server applications keep API
keys in their own secret store.

## Update or remove

```bash
npx skills update bloom
npx skills remove bloom
```

Add `--global` to update or remove a global installation.

## Package the upload ZIP

The checked-in ZIP is generated from the canonical Skill:

```bash
scripts/package-skill.sh
```

The script also verifies that the archive contains the same `SKILL.md`.

## License

[MIT](LICENSE)

<div align="center">

<img src="assets/bloom-mcp-og.png" alt="Bloom — the brand layer, callable from anywhere" width="100%" />

# Bloom Skill

Persistent guidance for agents working with Bloom.

</div>

Bloom is the brand layer: one place where a brand lives and evolves. It turns
websites, social media, brand guides, briefs, logos, and other brand material
into versioned Brand Skills that agents, applications, and people can use.

A Brand Skill can guide any capable system creating on the brand's behalf,
whether it is making images, slides, websites, video, documents, or something
else. Bloom includes image creation and transformation today; for other work,
Bloom supplies the brand context and the connected system creates the output.

This repository contains one optional Agent Skill that teaches an agent what
Bloom is, when to use it, and whether a workflow belongs on the API or MCP.

> A Bloom Skill teaches an agent how and when to use Bloom.
>
> A Brand Skill contains the context for one particular brand.

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

### Upload to Claude

Download
[`bloom.skill.zip`](https://github.com/trybloomai/bloom-skills/releases/latest/download/bloom.skill.zip),
then in Claude choose **Customize → Skills → Create skill → Upload a skill**.

The ZIP contains the same `bloom/SKILL.md` as the repository install.

## Connect or integrate Bloom

- For interactive agent work, follow the
  [Bloom MCP quickstart](https://docs.trybloom.ai/mcp/getting-started).
- For an application or backend, follow the
  [Bloom API quickstart](https://docs.trybloom.ai/api).
- For the complete documentation map, read
  [Bloom's `llms.txt`](https://docs.trybloom.ai/llms.txt).

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

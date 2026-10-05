#!/usr/bin/env bash

# Shared Bloom package checks; sourced by the two entry points.
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
plugin_files=(
  plugin.json
  mcp.json
  skills/bloom/SKILL.md
  README.md
  CHANGELOG.md
  LICENSE
  assets/bloom-mcp-og.png
  assets/bloom-logo.png
)

fail() {
  echo "Error: $*" >&2
  exit 1
}

require_commands() {
  local command_name
  for command_name in "$@"; do
    command -v "$command_name" >/dev/null 2>&1 || fail "Required command not found: $command_name"
  done
}

validate_regular_zip_members() {
  # Info-ZIP's long listing exposes Unix symlinks and other special file types.
  # The package builder writes regular files only; enforce that on read too.
  # Skip the two header lines, which include the archive path.
  unzip -Z -l "$1" | awk -v expected="$2" '
    NR > 2 && $2 ~ /^[0-9]+\.[0-9]+$/ {
      if ($1 !~ /^-/) exit 1
      files++
    }
    END { if (files != expected) exit 1 }
  ' || fail "Archive members must be regular files: $1"
}

validate_plugin_sources() {
  local file skill_metadata skill_name skill_version release_version
  for file in "${plugin_files[@]}"; do
    [[ -f "$repo_root/$file" && ! -L "$repo_root/$file" ]] || fail "Missing regular source file: $file"
  done
  for file in skills skills/bloom assets; do
    [[ -d "$repo_root/$file" && ! -L "$repo_root/$file" ]] || fail "Expected a regular source directory: $file"
  done

  # Read only the canonical frontmatter, with version under metadata. Accept
  # plain, double-quoted, or single-quoted scalar values.
  skill_metadata="$(awk -v quote="'" '
    function scalar(text,    first) {
      first = substr(text, 1, 1)
      if (length(text) > 1 && (first == "\"" || first == quote) && substr(text, length(text)) == first)
        return substr(text, 2, length(text) - 2)
      return text
    }
    NR == 1 { if ($0 != "---") exit 1; next }
    /^---$/ { closed = 1; exit }
    /^name: / { name = scalar(substr($0, 7)); names++ }
    /^metadata:$/ { metadata = 1; next }
    /^[^ ]/ { metadata = 0 }
    metadata && /^  version: / {
      version = scalar(substr($0, 12))
      versions++
    }
    END {
      if (!closed || names != 1 || versions != 1 || name == "" || version == "") exit 1
      print name
      print version
    }
  ' "$repo_root/skills/bloom/SKILL.md")" || fail "Invalid Skill name or metadata.version frontmatter"
  skill_name="${skill_metadata%%$'\n'*}"
  skill_version="${skill_metadata#*$'\n'}"
  [[ "$skill_name" == bloom ]] || fail "Skill name must match its directory: bloom"
  [[ "$skill_version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]] || fail "Expected a stable semantic Skill version"

  release_version="$(awk '
    /^## \[[0-9]/ {
      sub(/^## \[/, "")
      sub(/\].*$/, "")
      print
      exit
    }
  ' "$repo_root/CHANGELOG.md")"
  [[ "$release_version" == "$skill_version" ]] || fail "Latest changelog release must match Skill version $skill_version"

  awk -v kind=plugin -v expected_name="$skill_name" -v expected_version="$skill_version" \
    -f "$repo_root/scripts/validate-manifests.awk" "$repo_root/plugin.json"
  awk -v kind=mcp -v expected_name="$skill_name" \
    -f "$repo_root/scripts/validate-manifests.awk" "$repo_root/mcp.json"
}

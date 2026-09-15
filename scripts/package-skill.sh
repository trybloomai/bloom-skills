#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_dir="$repo_root/skills/bloom"
archive="$repo_root/dist/bloom.skill.zip"
check_dir="$(mktemp -d)"

trap 'rm -rf "$check_dir"' EXIT

mkdir -p "$repo_root/dist"
rm -f "$archive"

description="$(sed -n 's/^description: //p' "$skill_dir/SKILL.md" | head -n 1)"
if (( ${#description} > 200 )); then
  echo "Skill description exceeds Claude's 200-character limit" >&2
  exit 1
fi

(
  cd "$repo_root/skills"
  zip -X -q "$archive" bloom/SKILL.md
)

unzip -q "$archive" -d "$check_dir"
cmp "$skill_dir/SKILL.md" "$check_dir/bloom/SKILL.md"

echo "Packaged $archive"

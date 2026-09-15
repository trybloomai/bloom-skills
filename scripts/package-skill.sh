#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_dir="$repo_root/skills/bloom"
archive="$repo_root/dist/bloom.skill.zip"
check_dir="$(mktemp -d)"

trap 'rm -rf "$check_dir"' EXIT

mkdir -p "$repo_root/dist"
rm -f "$archive"

(
  cd "$repo_root/skills"
  zip -X -q "$archive" bloom/SKILL.md
)

unzip -q "$archive" -d "$check_dir"
cmp "$skill_dir/SKILL.md" "$check_dir/bloom/SKILL.md"

echo "Packaged $archive"

#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

source "$(dirname "${BASH_SOURCE[0]}")/plugin-common.sh"
[[ $# -le 1 ]] || fail "Usage: $0 [plugin.zip]"
require_commands awk unzip cmp sort mktemp
validate_plugin_sources

archive="${1:-$repo_root/dist/bloom.plugin.zip}"
[[ -f "$archive" && ! -L "$archive" ]] || fail "Missing regular plugin archive: $archive"
validation_dir="$(mktemp -d "${TMPDIR:-/tmp}/bloom-validate.XXXXXX")"
trap 'rm -rf "$validation_dir"' EXIT

unzip -tq "$archive" >/dev/null || fail "Invalid or corrupt ZIP: $archive"
printf '%s\n' "${plugin_files[@]}" | sort > "$validation_dir/expected"
unzip -Z1 "$archive" > "$validation_dir/entries"
sort "$validation_dir/entries" > "$validation_dir/actual"
cmp -s "$validation_dir/expected" "$validation_dir/actual" || \
  fail "Archive must contain exactly the allowed files at the plugin root (no wrapper, duplicates, or extras)"
validate_regular_zip_members "$archive" "${#plugin_files[@]}"

# Stream each allowed member rather than extracting untrusted archive paths.
for file in "${plugin_files[@]}"; do
  unzip -p "$archive" "$file" > "$validation_dir/member"
  cmp -s "$repo_root/$file" "$validation_dir/member" || fail "Archive differs from source: $file"
done

# Keep the existing Skill distribution aligned without rebuilding it.
skill_archive="$repo_root/dist/bloom.skill.zip"
[[ -f "$skill_archive" && ! -L "$skill_archive" ]] || fail "Missing regular Skill archive: $skill_archive"
unzip -tq "$skill_archive" >/dev/null || fail "Invalid or corrupt Skill ZIP"
[[ "$(unzip -Z1 "$skill_archive")" == bloom/SKILL.md ]] || fail "Skill ZIP must contain only bloom/SKILL.md"
validate_regular_zip_members "$skill_archive" 1
unzip -p "$skill_archive" bloom/SKILL.md > "$validation_dir/member"
cmp -s "$repo_root/skills/bloom/SKILL.md" "$validation_dir/member" || fail "Skill ZIP differs from the canonical Skill"

echo "Validated $archive"

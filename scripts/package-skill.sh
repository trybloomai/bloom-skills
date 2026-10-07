#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/plugin-common.sh"
require_commands awk zip unzip cmp sort mktemp
validate_plugin_sources
package_dir="$(mktemp -d "${TMPDIR:-/tmp}/rainbrand-skill.XXXXXX")"
candidate="$package_dir/rainbrand.skill.zip"
archive="$repo_root/dist/rainbrand.skill.zip"

trap 'rm -rf "$package_dir"' EXIT

build_deterministic_zip "$repo_root/skills" "$package_dir/stage" "$candidate" "${skill_files[@]}"
mkdir -p "$package_dir/check"
validate_zip_contents "$candidate" "$repo_root/skills" "$package_dir/check" "${skill_files[@]}"
mkdir -p "$repo_root/dist"
mv "$candidate" "$archive"

echo "Packaged $archive"

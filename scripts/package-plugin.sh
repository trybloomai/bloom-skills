#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

source "$(dirname "${BASH_SOURCE[0]}")/plugin-common.sh"
require_commands awk zip unzip cmp sort mktemp
validate_plugin_sources

package_dir="$(mktemp -d "${TMPDIR:-/tmp}/rainbrand-plugin.XXXXXX")"
trap 'rm -rf "$package_dir"' EXIT
stage_dir="$package_dir/stage"
candidate="$package_dir/rainbrand.plugin.zip"

build_deterministic_zip "$repo_root" "$stage_dir" "$candidate" "${plugin_files[@]}"

"$repo_root/scripts/validate-plugin.sh" "$candidate"
mkdir -p "$repo_root/dist"
mv "$candidate" "$repo_root/dist/rainbrand.plugin.zip"
echo "Packaged $repo_root/dist/rainbrand.plugin.zip"

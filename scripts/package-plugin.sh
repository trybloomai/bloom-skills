#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

source "$(dirname "${BASH_SOURCE[0]}")/plugin-common.sh"
require_commands awk zip unzip cmp sort mktemp
validate_plugin_sources

package_dir="$(mktemp -d "${TMPDIR:-/tmp}/bloom-plugin.XXXXXX")"
trap 'rm -rf "$package_dir"' EXIT
candidate="$package_dir/bloom.plugin.zip"

(
  cd "$repo_root"
  zip -X -q "$candidate" "${plugin_files[@]}"
)

"$repo_root/scripts/validate-plugin.sh" "$candidate"
mkdir -p "$repo_root/dist"
mv "$candidate" "$repo_root/dist/bloom.plugin.zip"
echo "Packaged $repo_root/dist/bloom.plugin.zip"

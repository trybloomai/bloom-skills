#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

source "$(dirname "${BASH_SOURCE[0]}")/plugin-common.sh"
require_commands awk zip unzip cmp sort mktemp
validate_plugin_sources

package_dir="$(mktemp -d "${TMPDIR:-/tmp}/bloom-plugin.XXXXXX")"
trap 'rm -rf "$package_dir"' EXIT
stage_dir="$package_dir/stage"
candidate="$package_dir/bloom.plugin.zip"

# Stage copies with fixed modes and times so unchanged sources rebuild to the
# same archive bytes; zip -X already omits owner and extended time fields.
for file in "${plugin_files[@]}"; do
  mkdir -p "$stage_dir/$(dirname "$file")"
  cp "$repo_root/$file" "$stage_dir/$file"
  chmod 644 "$stage_dir/$file"
  touch -t 198001010000 "$stage_dir/$file"
done

(
  cd "$stage_dir"
  zip -X -q "$candidate" "${plugin_files[@]}"
)

"$repo_root/scripts/validate-plugin.sh" "$candidate"
mkdir -p "$repo_root/dist"
mv "$candidate" "$repo_root/dist/bloom.plugin.zip"
echo "Packaged $repo_root/dist/bloom.plugin.zip"

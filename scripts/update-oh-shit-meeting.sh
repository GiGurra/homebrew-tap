#!/bin/sh
# Point Formula/oh-shit-meeting.rb at a release of GiGurra/oh-shit-meeting.
# Usage: scripts/update-oh-shit-meeting.sh [vX.Y.Z]   (default: latest release)
set -eu
cd "$(dirname "$0")/.."
repo=GiGurra/oh-shit-meeting
tag=${1:-$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')}
[ -n "$tag" ] || { echo "could not determine release tag" >&2; exit 1; }
sums=$(curl -fsSL --retry 5 "https://github.com/$repo/releases/download/$tag/checksums.txt")
formula=Formula/oh-shit-meeting.rb
sed -i.bak "s|/releases/download/[^/]*/|/releases/download/$tag/|" "$formula"
for asset in darwin_arm64_v8.0 linux_amd64_v1 linux_arm64_v8.0; do
  sum=$(printf '%s\n' "$sums" | awk -v f="oh-shit-meeting_$asset.tar.gz" '$2 == f { print $1 }')
  [ -n "$sum" ] || { echo "no checksum for $asset in $tag" >&2; mv "$formula.bak" "$formula"; exit 1; }
  # The sha256 line directly follows the url line of its asset.
  awk -v a="_$asset.tar.gz\"" -v s="$sum" '
    fix { sub(/sha256 "[0-9a-f]*"/, "sha256 \"" s "\""); fix = 0 }
    index($0, a) { fix = 1 }
    { print }' "$formula" > "$formula.tmp" && mv "$formula.tmp" "$formula"
done
rm -f "$formula.bak"
echo "$formula -> $tag"

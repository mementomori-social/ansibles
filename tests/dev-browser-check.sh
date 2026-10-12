#!/usr/bin/env bash
# Opens a page in headless Chrome and fails on a certificate warning, the way
# a developer would see it. Used by .github/workflows/dev.yml.
# Usage: tests/dev-browser-check.sh <url> <text expected on the page>
set -euo pipefail

url=$1
expect=$2

chrome=
for candidate in google-chrome chromium "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
  if command -v "$candidate" >/dev/null; then
    chrome=$candidate
    break
  fi
done
[ -n "$chrome" ] || { echo "No Chrome found" >&2; exit 1; }

profile=$(mktemp -d)
out=$(mktemp)
# perl alarm, because macOS has no timeout command. Output goes to a file: a
# Chrome helper can outlive Chrome and keep a pipe open.
perl -e 'alarm 60; exec @ARGV' "$chrome" --headless=new --disable-gpu --no-first-run \
  --user-data-dir="$profile" --dump-dom "$url" > "$out" 2>/dev/null || true
page=$(head -c 200000 "$out")
loaded=$(grep -c '[^[:space:]]' "$out" || true)
rm -rf "$profile" "$out"

# Headless Chrome prints nothing when it refuses a certificate
if [ "$loaded" = 0 ] || grep -qiE 'ERR_CERT|Privacy error|connection is not private' <<< "$page"; then
  echo "FAIL $url: Chrome refused the certificate or could not connect"
  exit 1
fi
if ! grep -q "$expect" <<< "$page"; then
  echo "FAIL $url: '$expect' not on the page"
  head -c 500 <<< "$page"
  exit 1
fi
echo "PASS $url opens in Chrome without a certificate warning"

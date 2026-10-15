#!/usr/bin/env bash
# Check every link in the list. Exits non-zero if a link is hard-broken.
#
# Usage:
#   bash scripts/check-links.sh                 # README.md and CONTRIBUTING.md
#   bash scripts/check-links.sh README.md       # specific files
#
# Behind a slow or filtered network, set a proxy first:
#   export https_proxy=http://127.0.0.1:8118 http_proxy=http://127.0.0.1:8118
#
# Notes:
#   - Some vendors and community sites answer bots with 403 or 429 even though the
#     page is fine in a browser. Those are reported as WARN, not FAIL.
#   - Hosts known to behave this way are listed in scripts/known-bot-blocks.txt and
#     are downgraded to INFO.
#   - Responses are written to a temp file instead of /dev/null: on Git Bash for
#     Windows, curl intermittently fails with "(23) Failed to truncate file" when
#     writing to /dev/null, which would look like a broken link.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 2

FILES="${*:-README.md CONTRIBUTING.md}"
UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'
ALLOWLIST='scripts/known-bot-blocks.txt'

BODY=$(mktemp 2>/dev/null || echo "${TMPDIR:-/tmp}/check-links.$$.body")
trap 'rm -f "$BODY"' EXIT

is_allowlisted() {
  [ -f "$ALLOWLIST" ] || return 1
  while read -r host; do
    case "$host" in
      ''|'#'*) continue ;;
    esac
    case "$1" in
      *"$host"*) return 0 ;;
    esac
  done < "$ALLOWLIST"
  return 1
}

# shellcheck disable=SC2086
urls=$(grep -hoE 'https?://[^)[:space:]<>"]+' $FILES 2>/dev/null | sed 's/[.,;)]$//' | sort -u)

total=0
failed=0
warned=0

printf 'Checking links in: %s\n\n' "$FILES"

for url in $urls; do
  total=$((total + 1))

  code=$(curl -sSL -o "$BODY" -w '%{http_code}' -A "$UA" \
    --max-time 25 --retry 2 --retry-delay 2 "$url" 2>/dev/null)

  case "$code" in
    2*|3*)
      printf '  ok    %s  %s\n' "$code" "$url"
      ;;
    403|429)
      if is_allowlisted "$url"; then
        printf '  info  %s  %s (bot-blocked, allowlisted)\n' "$code" "$url"
      else
        warned=$((warned + 1))
        printf '  WARN  %s  %s (bot protection - open it manually)\n' "$code" "$url"
      fi
      ;;
    000|'')
      failed=$((failed + 1))
      printf '  FAIL  ---  %s (unreachable: DNS, TLS or network)\n' "$url"
      ;;
    *)
      failed=$((failed + 1))
      printf '  FAIL  %s  %s\n' "$code" "$url"
      ;;
  esac
done

printf '\n%d links checked, %d failed, %d need a manual look.\n' "$total" "$failed" "$warned"

if [ "$failed" -gt 0 ]; then
  exit 1
fi

#!/bin/bash

# Behaviour tests for statusline.sh: feed it a session JSON on stdin and
# assert on the two lines it prints.

STATUSLINE="$(cd "$(dirname "$0")" && pwd)/statusline.sh"

ESC=$'\033'
GREEN="$ESC[32m"; YELLOW="$ESC[33m"; RED="$ESC[31m"
FAILURES=0

session_json() { # used_percentage total_input_tokens effort cost_usd duration_ms
  cat <<JSON
{
  "model": {"display_name": "Sonnet 4.5"},
  "workspace": {"current_dir": "/home/dev/my-project"},
  "cost": {"total_cost_usd": $4, "total_duration_ms": $5},
  "context_window": {"used_percentage": $1, "total_input_tokens": $2},
  "effort": {"level": "$3"}
}
JSON
}

assert_contains() { # description output expected
  if [[ "$2" == *"$3"* ]]; then
    echo "  ✓ $1"
  else
    echo "  ✗ $1"
    echo "      expected to contain: $(printf '%q' "$3")"
    echo "      actual:              $(printf '%q' "$2")"
    FAILURES=$((FAILURES + 1))
  fi
}

assert_lacks() { # description output unexpected
  if [[ "$2" != *"$3"* ]]; then
    echo "  ✓ $1"
  else
    echo "  ✗ $1"
    echo "      expected NOT to contain: $(printf '%q' "$3")"
    echo "      actual:                  $(printf '%q' "$2")"
    FAILURES=$((FAILURES + 1))
  fi
}

echo "Context usage colours the bar"
assert_bar() { # description used_percentage expected_coloured_bar
  local output
  output=$(session_json "$2" 1000 medium 0 0 | "$STATUSLINE")
  assert_contains "$1" "$output" "$3"
}
assert_bar "30% draws a green bar filled to 3 of 10 blocks" 30 "${GREEN}███░░░░░░░"
assert_bar "39% is still green" 39 "${GREEN}███░░░░░░░"
assert_bar "40% turns yellow" 40 "${YELLOW}████░░░░░░"
assert_bar "50% stays yellow" 50 "${YELLOW}█████░░░░░"
assert_bar "60% is still yellow" 60 "${YELLOW}██████░░░░"
assert_bar "61% turns red" 61 "${RED}██████░░░░"
assert_bar "95% draws a red bar filled to 9 of 10 blocks" 95 "${RED}█████████░"

echo "Token counts above a thousand are abbreviated"
output=$(session_json 30 45231 medium 0 0 | "$STATUSLINE")
assert_contains "45231 tokens read as 45.2K" "$output" "(45.2K tok)"
output=$(session_json 30 850 medium 0 0 | "$STATUSLINE")
assert_contains "850 tokens are shown in full" "$output" "(850 tok)"
output=$(session_json 30 1000 medium 0 0 | "$STATUSLINE")
assert_contains "1000 tokens read as 1.0K" "$output" "(1.0K tok)"

echo "Session facts are reported"
output=$(session_json 30 1000 high 1.5 125000 | "$STATUSLINE")
assert_contains "the model name opens the first line" "$output" "[Sonnet 4.5]"
assert_contains "only the working directory basename is shown" "$output" "📁 my-project"
assert_contains "cost is rounded to cents" "$output" '$1.50'
assert_contains "duration is split into minutes and seconds" "$output" "⏱️ 2m 5s"
assert_contains "the effort level is reported" "$output" "⚙️ high"

echo "A session reporting nothing still renders"
output=$(echo '{"model": {"display_name": "Sonnet 4.5"}}' | "$STATUSLINE")
assert_contains "context usage defaults to empty" "$output" "${GREEN}░░░░░░░░░░${ESC}[0m 0%"
assert_contains "tokens default to zero" "$output" "(0 tok)"
assert_contains "cost defaults to zero" "$output" '$0.00'
assert_contains "duration defaults to zero" "$output" "⏱️ 0m 0s"
assert_contains "effort falls back to default" "$output" "⚙️ default"

echo "The branch is shown only inside a repository"
output=$(session_json 30 1000 medium 0 0 | "$STATUSLINE")
assert_contains "a repository shows its current branch" "$output" "🌿 $(git branch --show-current)"
outside_repo=$(mktemp -d)
output=$(cd "$outside_repo" && session_json 30 1000 medium 0 0 | "$STATUSLINE")
rmdir "$outside_repo"
assert_lacks "outside a repository no branch is shown" "$output" "🌿"

echo
if [ "$FAILURES" -eq 0 ]; then
  echo "All tests passed"
else
  echo "$FAILURES test(s) failed"
fi
exit $((FAILURES > 0))

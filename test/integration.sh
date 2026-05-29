#!/usr/bin/env bash
# Conductor plugin integration check — runs on VANILLA Claude Code, no PAI required.
#
# A prompt-based plugin can't run the LLM in CI, but it CAN assert the static
# invariants that guarantee it will work at runtime — chiefly that no command
# depends on context Claude Code silently does not load.
#
# Usage:  bash test/integration.sh    (from the repo root or anywhere)
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
pass() { printf '  \033[32mPASS\033[0m  %s\n' "$1"; }
err()  { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; fail=1; }

echo "== Conductor integration invariants (no PAI) =="

# 1. No command references the plugin-root CLAUDE.md, which Claude Code does NOT auto-load.
if grep -rq "defined in CLAUDE.md" commands/; then
  err "a command still references the unloaded plugin-root CLAUDE.md"
else
  pass "no command references the unloaded plugin-root CLAUDE.md"
fi

# 2. setup persists the protocol where Claude Code DOES load context.
if grep -q "BEGIN CONDUCTOR CONTEXT" commands/setup.md && grep -q "conductor/CONTEXT.md" commands/setup.md; then
  pass "setup persists protocol to project CLAUDE.md + conductor/CONTEXT.md"
else
  err "setup does not persist the resolution protocol into the project"
fi

# 3. setup's CLAUDE.md injection is idempotent (re-run replaces, never duplicates).
if grep -q "REPLACE the content between them" commands/setup.md; then
  pass "setup block injection is declared idempotent"
else
  err "setup injection is not declared idempotent"
fi

# 4. Every command halts gracefully when Conductor is not set up.
n=$(grep -rl "is not set up" commands/ | wc -l | tr -d ' ')
if [ "$n" -ge 5 ]; then
  pass "all $n commands guard for missing setup (HALT)"
else
  err "only $n commands guard for missing setup"
fi

# 5. No command relies on ${CLAUDE_PLUGIN_ROOT} (not substituted inside command .md bodies).
if grep -rq 'CLAUDE_PLUGIN_ROOT' commands/; then
  err "a command uses \${CLAUDE_PLUGIN_ROOT} (unsupported in command bodies)"
else
  pass "no command depends on \${CLAUDE_PLUGIN_ROOT}"
fi

# 6. Plugin manifest is valid JSON.
PJ=$(find . -name plugin.json -path '*.claude-plugin*' | head -1)
json_ok() {
  if command -v node >/dev/null 2>&1; then node -e "JSON.parse(require('fs').readFileSync('$1','utf8'))" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then python3 -c "import json;json.load(open('$1'))" 2>/dev/null
  else return 2; fi
}
if [ -z "$PJ" ]; then
  err "plugin.json not found under .claude-plugin/"
elif json_ok "$PJ"; then
  pass "plugin.json is valid JSON"
else
  rc=$?; [ "$rc" -eq 2 ] && echo "  SKIP  no node/python3 to validate JSON" || err "plugin.json is invalid JSON"
fi

# 7. Commands declare only vanilla Claude Code tools (no PAI/Skill/Agent/MCP assumptions).
if grep -rEq 'allowed-tools.*(Skill|Agent|mcp__)' commands/; then
  err "a command requires non-vanilla tools (PAI assumption)"
else
  pass "commands use only vanilla Claude Code tools"
fi

# 8. Protocol body is identical between the repo CLAUDE.md and setup's canonical block.
a=$(awk '/## Universal File Resolution Protocol/,/Review fixes:/' CLAUDE.md | sed 's/^[[:space:]]*//')
b=$(awk '/## Universal File Resolution Protocol/,/Review fixes:/' commands/setup.md | sed 's/^[[:space:]]*//')
if [ -n "$a" ] && [ "$a" = "$b" ]; then
  pass "protocol byte-identical across sources (single source of truth)"
else
  err "protocol diverges between CLAUDE.md and commands/setup.md"
fi

echo
if [ "$fail" -eq 0 ]; then
  printf '\033[32mALL CHECKS PASSED\033[0m\n'
else
  printf '\033[31mSOME CHECKS FAILED\033[0m\n'
fi
exit $fail

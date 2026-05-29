<!-- Modified by mofy-scpo (2026) — Adapted from Gemini Conductor for Claude Code CLI -->
<!-- Original: https://github.com/gemini-cli-extensions/conductor -->
<!-- Licensed under Apache License 2.0 -->

# Conductor Tests

These tests assume **vanilla Claude Code with no PAI or other scaffolding** — the
environment most Conductor users actually run in.

## Static invariants (automated)

```bash
bash test/integration.sh
```

Asserts the structural guarantees that make Conductor work at runtime — most
importantly that **no command depends on the plugin-root `CLAUDE.md`**, which
Claude Code does not auto-load. Exits non-zero on any failure; safe to wire into CI.

## Live smoke test (manual, ~2 min)

A prompt-based plugin can't exercise the model in CI, so confirm the end-to-end
path by hand once per release:

1. Install the plugin in a Claude Code session:
   - `/plugin marketplace add mofy-scpo/claude-conductor`
   - `/plugin install conductor@conductor-marketplace`
   - `/reload-plugins`
2. In a **throwaway** project directory (not this repo), run `/conductor:setup`
   and complete the guided setup.
3. Verify the protocol now loads natively:
   - The project root has a `CLAUDE.md` containing a
     `<!-- BEGIN CONDUCTOR CONTEXT -->` … `<!-- END CONDUCTOR CONTEXT -->` block.
   - `conductor/CONTEXT.md` exists with the same protocol.
4. Run `/conductor:new-track "add a hello endpoint"` and confirm it resolves the
   project files (it must NOT complain about a missing protocol).
5. Re-run `/conductor:setup`; confirm the CLAUDE.md block is **replaced, not
   duplicated** (idempotency).

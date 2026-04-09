# Claude Conductor

**Measure twice, code once.**

> Turn Claude Code into a disciplined project manager that specs, plans, and builds — not just writes code.

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Built_for-Claude_Code-blueviolet)](https://docs.anthropic.com/en/docs/claude-code)

---

## What is Conductor?

Claude Conductor is a **slash command extension** for the [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code). It brings structure and discipline to AI-assisted development by enforcing a strict lifecycle for every task:

```
  Context  -->  Spec & Plan  -->  Implement  -->  Review
```

Without Conductor, Claude Code is reactive — it writes code when you ask. **With Conductor**, it becomes a proactive project manager that:

- Understands your product, tech stack, and workflow before writing a single line
- Breaks work into tracks with detailed specs and plans
- Follows TDD: write tests first, implement second
- Commits atomically with full traceability via git notes
- Reviews its own work against your guidelines

---

## How It Works

### The Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   /conductor:setup          One-time project configuration      │
│        │                                                        │
│        ▼                                                        │
│   /conductor:new-track      Define a feature or bug fix         │
│        │                                                        │
│        ▼                                                        │
│   /conductor:implement      Execute tasks from the plan         │
│        │                                                        │
│        ▼                                                        │
│   /conductor:review         Validate work against guidelines    │
│        │                                                        │
│        ▼                                                        │
│   /conductor:status         Check progress at any time          │
│                                                                 │
│   /conductor:revert         Undo a track, phase, or task        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### What Gets Created

After setup, your project will have a `conductor/` directory:

```
your-project/
├── conductor/                    # All Conductor artifacts
│   ├── index.md                  # Master index linking everything
│   ├── product.md                # Product vision & goals
│   ├── product-guidelines.md     # Prose style, branding, UX rules
│   ├── tech-stack.md             # Languages, frameworks, databases
│   ├── workflow.md               # TDD rules, commit strategy, quality gates
│   ├── code_styleguides/         # Language-specific style guides
│   │   ├── typescript.md
│   │   ├── python.md
│   │   └── ...
│   ├── tracks.md                 # Registry of all tracks
│   └── tracks/                   # One folder per track
│       └── feature_20260409/
│           ├── index.md          # Track index
│           ├── spec.md           # Detailed specification
│           ├── plan.md           # Step-by-step implementation plan
│           └── metadata.json     # Track metadata
└── ...
```

---

## Installation

### Option 1: Clone and Copy (Recommended)

```bash
# Clone the repo
git clone https://github.com/mofy-scpo/claude-conductor.git

# Copy slash commands into your project
cp -r claude-conductor/.claude/commands/conductor your-project/.claude/commands/conductor

# Copy the context file (or merge with your existing CLAUDE.md)
cp claude-conductor/CLAUDE.md your-project/CLAUDE.md

# Copy templates
cp -r claude-conductor/templates your-project/templates
```

### Option 2: Git Submodule

```bash
cd your-project
git submodule add https://github.com/mofy-scpo/claude-conductor.git .claude-conductor
cp -r .claude-conductor/.claude/commands/conductor .claude/commands/conductor
cp .claude-conductor/CLAUDE.md CLAUDE.md
cp -r .claude-conductor/templates templates
```

### Option 3: Manual Download

1. Download or clone this repository
2. Copy `.claude/commands/conductor/` into your project's `.claude/commands/`
3. Copy `CLAUDE.md` to your project root (or merge with your existing one)
4. Copy the `templates/` directory to your project

### Verify Installation

Open Claude Code in your project and type:

```
/conductor:setup
```

If Conductor is installed correctly, the setup wizard will start.

---

## Quick Start

### Step 1: Set Up Your Project

```
/conductor:setup
```

Conductor will guide you through an interactive setup:

1. **Project Discovery** — Detects if your project is new (Greenfield) or existing (Brownfield)
2. **Product Definition** — Define your product's vision, users, and goals
3. **Guidelines** — Set prose style, branding, and UX principles
4. **Tech Stack** — Choose or confirm your languages, frameworks, and tools
5. **Code Style** — Select from built-in style guides (TypeScript, Python, Go, C#, etc.)
6. **Workflow** — Configure TDD, commit strategy, and coverage requirements
7. **First Track** — Define your first unit of work and generate its plan

### Step 2: Start Building

```
/conductor:implement
```

Claude will pick up the first task from the plan and follow the workflow:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Write Test │────>│  Implement  │────>│  Refactor   │
│   (Red)     │     │  (Green)    │     │  (Optional) │
└─────────────┘     └─────────────┘     └─────────────┘
       │                                        │
       │         TDD Cycle per Task             │
       └────────────────────────────────────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │  Commit + Git Note  │
              │  Update plan.md     │
              └─────────────────────┘
```

Each task gets:
- A **commit** with a conventional message (`feat`, `fix`, `test`, etc.)
- A **git note** with a detailed summary attached to the commit
- An **updated plan.md** with the commit SHA for full traceability

### Step 3: Check Progress

```
/conductor:status
```

See which tasks are done, in progress, or pending across all tracks.

### Step 4: Review Work

```
/conductor:review
```

Claude reviews the completed track against your product guidelines, tech stack, and code style guides.

### Step 5: Revert If Needed

```
/conductor:revert
```

Git-aware revert that understands logical units (tracks, phases, tasks) — not just commit hashes.

---

## Commands Reference

| Command | Description |
| :--- | :--- |
| `/conductor:setup` | Interactive project setup — product, tech stack, workflow, first track |
| `/conductor:new-track` | Create a new track (feature, bug fix, refactor) with spec and plan |
| `/conductor:implement` | Execute tasks from the current track's plan following TDD |
| `/conductor:status` | Display progress across all tracks |
| `/conductor:review` | Review completed work against guidelines |
| `/conductor:revert` | Revert a track, phase, or task via git history |

---

## Key Concepts

### Tracks

A **track** is a high-level unit of work — a feature, bug fix, or refactor. Each track has:

- **Spec** (`spec.md`) — What needs to be built and why
- **Plan** (`plan.md`) — Step-by-step tasks with status markers (`[ ]`, `[~]`, `[x]`)
- **Metadata** (`metadata.json`) — Track ID, dates, status

### Greenfield vs. Brownfield

Conductor adapts to your project:

| | Greenfield (New Project) | Brownfield (Existing Project) |
| :--- | :--- | :--- |
| **Detection** | No source code or dependency manifests | Has `package.json`, `src/`, etc. |
| **Setup** | Starts from scratch, asks what you want to build | Scans codebase, infers tech stack |
| **First Track** | Focused on MVP core | Focused on maintenance or enhancements |

### Workflow & TDD

The default workflow enforces:

- **Test-Driven Development** — Write failing tests before implementation
- **>80% code coverage** — Verified at phase boundaries
- **Atomic commits** — One commit per task with conventional messages
- **Git notes** — Detailed task summaries attached to commits
- **Phase checkpoints** — Manual verification at the end of each phase

### Code Style Guides

Built-in guides available in `templates/code_styleguides/`:

| Language | File |
| :--- | :--- |
| TypeScript | `typescript.md` |
| JavaScript | `javascript.md` |
| Python | `python.md` |
| Go | `go.md` |
| C# | `csharp.md` |
| C++ | `cpp.md` |
| Dart | `dart.md` |
| HTML/CSS | `html-css.md` |
| General | `general.md` |

---

## Customization

### Custom Workflow

During setup, choose "Customize" to adjust:

- Test coverage threshold (default: 80%)
- Commit frequency (per task or per phase)
- Task summary storage (git notes or commit messages)

### Custom Skills

Add domain-specific guidance by creating skills:

```
# Global (all projects)
~/.claude/conductor-skills/my-skill/SKILL.md

# Project-specific
conductor/skills/my-skill/SKILL.md
```

See `skills/catalog.md` for the skill format.

### Custom Style Guides

Add your own style guide to `templates/code_styleguides/` and it will appear during setup.

---

## Example Session

```
You:    /conductor:setup
Claude: Welcome to Conductor! Analyzing your project...
        Existing project detected (package.json found).
        Let's define your product context.
        ...

You:    /conductor:new-track "Add dark mode toggle to settings"
Claude: Creating track dark_mode_20260409...
        Generated spec.md and plan.md with 8 tasks.

You:    /conductor:implement
Claude: Starting task 1/8: Write tests for dark mode toggle...
        [writes tests, implements, commits, updates plan]

You:    /conductor:status
Claude: === Conductor Status Report ===
        Tasks: 3/8 (37.5%)
        Current: Task 4 - Implement CSS variables for theming

You:    /conductor:review
Claude: Reviewing against product-guidelines.md...
        All checks passed.
```

---

## Credits

- Original [Gemini Conductor](https://github.com/gemini-cli-extensions/conductor) by the Gemini CLI Extensions team
- Adapted for Claude Code by [@mofy-scpo](https://github.com/mofy-scpo)

## License

[Apache License 2.0](LICENSE) — Originally licensed by the Gemini CLI Extensions team.

```
Copyright 2025 Gemini CLI Extensions contributors
Copyright 2026 mofy-scpo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
```

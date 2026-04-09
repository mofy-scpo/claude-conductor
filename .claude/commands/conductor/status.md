---
description: "Displays the current progress of the project"
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
---

<!-- Modified by mofy-scpo (2026) — Adapted from Gemini Conductor for Claude Code CLI -->
<!-- Original: https://github.com/gemini-cli-extensions/conductor -->
<!-- Licensed under Apache License 2.0 -->

## 1.0 SYSTEM DIRECTIVE
You are an AI agent. Your primary function is to provide a status overview of the current tracks file. This involves reading the **Tracks Registry** file, parsing its content, and summarizing the progress of tasks.

CRITICAL: You must validate the success of every tool call. If any tool call fails, you MUST halt the current operation immediately, announce the failure to the user, and await further instructions.

---

## 1.1 SETUP CHECK
**PROTOCOL: Verify that the Conductor environment is properly set up.**

1.  **Verify Core Context:** Using the **Universal File Resolution Protocol** (defined in CLAUDE.md), resolve and verify the existence of:
    -   **Tracks Registry**
    -   **Product Definition**
    -   **Tech Stack**
    -   **Workflow**

2.  **Handle Failure:**
    -   If ANY of these files are missing, announce: "Conductor is not set up. Please run `/conductor:setup` to set up the environment."
    -   Do NOT proceed to Status Overview Protocol.

---

## 2.0 STATUS OVERVIEW PROTOCOL
**PROTOCOL: Follow this sequence to provide a status overview.**

### 2.1 Read Project Plan
1.  **Locate and Read:** Read the content of the **Tracks Registry**.
2.  **Locate and Read Tracks:**
    -   Parse the **Tracks Registry** to identify all registered tracks and their paths.
    -   **Parsing Logic:** Look for lines matching either `- [ ] **Track:` or the legacy format `## [ ] Track:`.
    -   For each track, resolve and read its **Implementation Plan**.

### 2.2 Parse and Summarize Plan
1.  **Parse Content:**
    -   Identify major project phases/sections (top-level markdown headings).
    -   Identify individual tasks and their current status (looking for `[ ]`, `[~]`, `[x]` markers).
2.  **Generate Summary:** Create a concise summary including:
    -   Total number of major phases
    -   Total number of tasks
    -   Number of tasks completed, in progress, and pending

### 2.3 Present Status Overview
1.  **Output Summary:** Present in this format:

    ```
    === Conductor Status Report ===
    Date: [Current timestamp]

    Project Status: [On Track / Behind Schedule / Blocked]

    Current Phase & Task: [Phase and task marked as [~] In Progress]
    Next Action Needed: [Next task marked as [ ] Pending]
    Blockers: [Any items marked as blockers, or "None"]

    Phases: [total]
    Tasks: [completed]/[total] ([percentage]%)

    Track Details:
    - [status] Track: [description] ([completed]/[total] tasks)
    ...
    ```

---
description: "Plans a track, generates track-specific spec documents and updates the tracks file"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep"]
argument-hint: "[track description]"
---

<!-- Modified by mofy-scpo (2026) — Adapted from Gemini Conductor for Claude Code CLI -->
<!-- Original: https://github.com/gemini-cli-extensions/conductor -->
<!-- Licensed under Apache License 2.0 -->

## 1.0 SYSTEM DIRECTIVE
You are an AI agent assistant for the Conductor spec-driven development framework. Your current task is to guide the user through the creation of a new "Track" (a feature or bug fix), generate the necessary specification (`spec.md`) and plan (`plan.md`) files, and organize them within a dedicated track directory.

CRITICAL: You must validate the success of every tool call. If any tool call fails, you MUST halt the current operation immediately, announce the failure to the user, and await further instructions.

FILE OPERATIONS: You MUST use relative paths starting with `conductor/` for all file operations within the conductor directory.

**User-provided arguments:** $ARGUMENTS

---

## 1.1 SETUP CHECK
**PROTOCOL: Verify that the Conductor environment is properly set up.**

1.  **Verify Core Context:** Using the **Universal File Resolution Protocol** (defined in CLAUDE.md), resolve and verify the existence of:
    -   **Product Definition**
    -   **Tech Stack**
    -   **Workflow**

2.  **Handle Failure:**
    -   If ANY of these files are missing, you MUST halt the operation immediately.
    -   Announce: "Conductor is not set up. Please run `/conductor:setup` to set up the environment."
    -   Do NOT proceed to New Track Initialization.

---

## 2.0 NEW TRACK INITIALIZATION
**PROTOCOL: Follow this sequence precisely.**

### 2.1 Get Track Description and Determine Type

1.  **Load Project Context:** Read and understand the content of the project documents (**Product Definition**, **Tech Stack**, etc.) resolved via the **Universal File Resolution Protocol**.
2.  **Get Track Description:**
    *   **If `$ARGUMENTS` is empty:** Ask the user: "Please provide a brief description of the track (feature, bug fix, chore, etc.) you wish to start." Wait for their response.
    *   **If `$ARGUMENTS` contains a description:** Use the content of `$ARGUMENTS` as the track description.
3.  **Infer Track Type:** Analyze the description to determine if it is a "Feature" or "Something Else" (e.g., Bug, Chore, Refactor). Do NOT ask the user to classify it.

### 2.2 Interactive Specification Generation (`spec.md`)

1.  **State Your Goal:** Announce:
    > "I'll now guide you through a series of questions to build a comprehensive specification (`spec.md`) for this track."

2.  **Questioning Phase:** Ask a series of questions to gather details for the `spec.md`. Batch up to 4 related questions at a time. Tailor questions based on the track type (Feature or Other).
    *   Wait for the user's response after each batch of questions.
    *   Refer to information in **Product Definition**, **Tech Stack**, etc., to ask context-aware questions.
    *   Provide brief explanations and clear examples for each question.
    *   Whenever possible, present 2-3 plausible options for the user to choose from.

    *   **If FEATURE:** Ask 3-4 relevant questions about the feature, implementation, interactions, inputs/outputs, etc.
    *   **If SOMETHING ELSE (Bug, Chore, etc.):** Ask 2-3 relevant questions about reproduction steps, scope, or success criteria.

3.  **Draft `spec.md`:** Once sufficient information is gathered, draft the content including: Overview, Functional Requirements, Non-Functional Requirements (if any), Acceptance Criteria, and Out of Scope.

4.  **User Confirmation:** Present the draft and ask:
    > "Please review the drafted Specification above. Does this accurately capture the requirements?
    > 1. **Approve** - Proceed to planning.
    > 2. **Revise** - I want to make changes."

    Await user feedback and revise until confirmed.

### 2.3 Interactive Plan Generation (`plan.md`)

1.  **State Your Goal:** Once `spec.md` is approved, announce:
    > "Now I will create an implementation plan (plan.md) based on the specification."

2.  **Generate Plan:**
    *   Read the confirmed `spec.md` content.
    *   Read the **Workflow** file (via the **Universal File Resolution Protocol**).
    *   Generate a `plan.md` with a hierarchical list of Phases, Tasks, and Sub-tasks.
    *   **CRITICAL:** The plan structure MUST adhere to the methodology in the **Workflow** file (e.g., TDD tasks for "Write Tests" and "Implement").
    *   Include status markers `[ ]` for **EVERY** task and sub-task:
        - Parent Task: `- [ ] Task: ...`
        - Sub-task: `    - [ ] ...`
    *   **Inject Phase Completion Tasks** if a "Phase Completion Verification and Checkpointing Protocol" is defined in the **Workflow**. For each Phase, append: `- [ ] Task: Conductor - User Manual Verification '<Phase Name>' (Protocol in workflow.md)`.

3.  **User Confirmation:** Present the draft plan and ask:
    > "Please review the Implementation Plan above. Does this cover all the necessary steps?
    > 1. **Approve** - Proceed to implementation.
    > 2. **Revise** - I want to modify the steps."

    Await user feedback and revise until confirmed.

### 2.4 Skill Recommendation (Interactive)
1.  **Analyze Needs:** Read `skills/catalog.md` from the Conductor installation directory.
    -   Analyze the confirmed `spec.md` and `plan.md` against the `Detection Signals` in the catalog.
    -   Identify any relevant skills that are NOT yet installed.
2.  **If relevant missing skills are found:** Ask the user if they would like to install them.
3.  **If no missing skills found:** Skip this section.

### 2.5 Create Track Artifacts and Update Main Plan

1.  **Check for existing track name:** Before generating a new Track ID, check existing track directories in `conductor/tracks/`. If the proposed short name already exists, halt and suggest choosing a different name.
2.  **Generate Track ID:** Create a unique Track ID (e.g., `shortname_YYYYMMDD`).
3.  **Create Directory:** Create `conductor/tracks/<track_id>/`.
4.  **Create `metadata.json`:** Create metadata file with:
    ```json
    {
      "track_id": "<track_id>",
      "type": "feature",
      "status": "new",
      "created_at": "YYYY-MM-DDTHH:MM:SSZ",
      "updated_at": "YYYY-MM-DDTHH:MM:SSZ",
      "description": "<Initial user description>"
    }
    ```
5.  **Write Files:**
    *   Write the confirmed specification to `conductor/tracks/<track_id>/spec.md`.
    *   Write the confirmed plan to `conductor/tracks/<track_id>/plan.md`.
    *   Write the index file to `conductor/tracks/<track_id>/index.md`:
        ```markdown
        # Track <track_id> Context

        - [Specification](./spec.md)
        - [Implementation Plan](./plan.md)
        - [Metadata](./metadata.json)
        ```

6.  **Update Tracks Registry:** Append a new section to the **Tracks Registry** file:
    ```markdown

    ---

    - [ ] **Track: <Track Description>**
      *Link: [./tracks/<track_id>/](./tracks/<track_id>/)*
    ```

7.  **Commit Code Changes:** Stage the Tracks Registry files and commit with message `chore(conductor): Add new track '<track_description>'`.

8.  **Announce Completion:**
    > "New track '<track_id>' has been created and added to the tracks file. You can now start implementation by running `/conductor:implement`."

---
description: "Executes the tasks defined in the specified track's plan"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep"]
argument-hint: "[track name]"
---

<!-- Modified by mofy-scpo (2026) — Adapted from Gemini Conductor for Claude Code CLI -->
<!-- Original: https://github.com/gemini-cli-extensions/conductor -->
<!-- Licensed under Apache License 2.0 -->

## 1.0 SYSTEM DIRECTIVE
You are an AI agent assistant for the Conductor spec-driven development framework. Your current task is to implement a track. You MUST follow this protocol precisely.

CRITICAL: You must validate the success of every tool call. If any tool call fails, you MUST halt the current operation immediately, announce the failure to the user, and await further instructions.

**User-provided arguments:** $ARGUMENTS

---

## 1.1 SETUP CHECK
**PROTOCOL: Verify that the Conductor environment is properly set up.**

1.  **Verify Core Context:** Using the **Universal File Resolution Protocol** (defined in CLAUDE.md), resolve and verify the existence of:
    -   **Product Definition**
    -   **Tech Stack**
    -   **Workflow**

2.  **Handle Failure:** If ANY of these are missing, Announce: "Conductor is not set up. Please run `/conductor:setup`." and HALT.

---

## 2.0 TRACK SELECTION
**PROTOCOL: Identify and select the track to be implemented.**

1.  **Check for User Input:** Check if the user provided a track name via `$ARGUMENTS`.

2.  **Locate and Parse Tracks Registry:**
    -   Resolve the **Tracks Registry** via the **Universal File Resolution Protocol**.
    -   Read and parse the file by splitting content by the `---` separator to identify each track section. For each section, extract the status (`[ ]`, `[~]`, `[x]`), track description, and link to the track folder.
    -   **CRITICAL:** If no track sections are found, announce: "The tracks file is empty or malformed. No tracks to implement." and halt.

3.  **Select Track:**
    -   **If a track name was provided:**
        1.  Perform an exact, case-insensitive match against parsed track descriptions.
        2.  If a unique match is found, ask for confirmation: "I found track '<track_description>'. Is this correct? (yes/no)"
        3.  If no match or ambiguous, ask the user to clarify.
    -   **If no track name was provided:**
        1.  Find the first track NOT marked as `[x] Completed`.
        2.  If found, ask: "No track name provided. Would you like to proceed with the next incomplete track: '<track_description>'? (yes/no)"
        3.  If no incomplete tracks found, announce: "No incomplete tracks found. All tasks are completed!" and halt.

4.  **Handle No Selection:** If no track is selected, inform the user and await instructions.

---

## 3.0 TRACK IMPLEMENTATION
**PROTOCOL: Execute the selected track.**

1.  **Announce Action:** Announce which track you are beginning to implement.

2.  **Update Status to 'In Progress':**
    -   Update the status of the selected track in the **Tracks Registry** from `[ ]` to `[~]`.

3.  **Load Track Context:**
    a. Identify the track's folder from the Tracks Registry link.
    b. Read the track's **Specification** and **Implementation Plan** via the **Universal File Resolution Protocol**.
    c. Read the **Workflow** file.
    d. **Activate Relevant Skills:**
        - Check for installed skills in `conductor/skills/` (project-level) and `~/.claude/conductor-skills/` (global).
        - If relevant skills exist, read their `SKILL.md` files and apply their guidelines during execution.

4.  **Execute Tasks and Update Track Plan:**
    a. Announce that you will execute tasks from the **Implementation Plan** following the **Workflow** procedures.
    b. Loop through each task in the **Implementation Plan** one by one.
    c. **For Each Task:**
        i. Follow the **Workflow** file as the single source of truth for the task lifecycle.
        ii. Mark the task as `[~]` in progress in `plan.md`.
        iii. Execute the task following workflow procedures (e.g., TDD: write failing tests, implement, refactor).
        iv. After completing the task, stage and commit code changes.
        v. Get the commit SHA and update `plan.md`: change `[~]` to `[x]` and append the first 7 characters of the commit hash.
        vi. Stage and commit the `plan.md` update with message: `conductor(plan): Mark task '<task_name>' as complete`.

5.  **Finalize Track:**
    -   After all tasks are completed, update the track status in **Tracks Registry** from `[~]` to `[x]`.
    -   Commit with message: `chore(conductor): Mark track '<track_description>' as complete`.
    -   Announce that the track is fully complete.

---

## 4.0 SYNCHRONIZE PROJECT DOCUMENTATION
**PROTOCOL: Update project-level documentation based on the completed track.**

1.  **Execution Trigger:** Only execute when a track reaches `[x]` status.

2.  **Load Track Specification** and **Project Documents** (Product Definition, Tech Stack, Product Guidelines).

3.  **Analyze and Update:**
    a. Determine if the completed feature impacts the Product Definition. If so, propose updates and ask for approval.
    b. Determine if the Tech Stack was changed. If so, propose updates and ask for approval.
    c. **Product Guidelines:** Only propose changes if the track explicitly impacts branding, voice, tone, or core guidelines. Include a warning about the sensitivity of these changes.

4.  **Final Report:** Summarize what was updated, stage changed files, and commit with message: `docs(conductor): Synchronize docs for track '<track_description>'`.

---

## 5.0 TRACK CLEANUP
**PROTOCOL: Offer to archive or delete the completed track.**

1.  **Execution Trigger:** Only after implementation and documentation sync are complete.

2.  **Ask the user:**
    > "Track '<track_description>' is now complete. What would you like to do?
    > 1. **Review** - Run the review command to verify changes.
    > 2. **Archive** - Move the track's folder to `conductor/archive/`.
    > 3. **Delete** - Permanently delete the track's folder.
    > 4. **Skip** - Leave it in the tracks file."

3.  **Handle Response:**
    *   **Review:** Announce: "Please run `/conductor:review` to verify your changes."
    *   **Archive:** Create `conductor/archive/` if needed, move track folder there, remove from Tracks Registry, commit.
    *   **Delete:** Ask for final confirmation ("WARNING: This will permanently delete the track folder. This action cannot be undone. Are you sure?"). If confirmed, delete folder, remove from Tracks Registry, commit.
    *   **Skip:** Leave track as is.

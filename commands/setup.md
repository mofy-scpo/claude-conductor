---
description: "Scaffolds the project and sets up the Conductor environment"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep"]
---

<!-- Modified by mofy-scpo (2026) — Adapted from Gemini Conductor for Claude Code CLI -->
<!-- Original: https://github.com/gemini-cli-extensions/conductor -->
<!-- Licensed under Apache License 2.0 -->

## 1.0 SYSTEM DIRECTIVE
You are an AI agent. Your primary function is to set up and manage a software project using the Conductor methodology. This document is your operational protocol. Adhere to these instructions precisely and sequentially. Do not make assumptions.

CRITICAL: You must validate the success of every tool call. If a tool call fails, you should attempt to intelligently self-correct by reviewing the error message. If the failure is unrecoverable after a self-correction attempt, you MUST halt the current operation immediately, announce the failure to the user, and await further instructions.

FILE OPERATIONS: You MUST use relative paths starting with `conductor/` (e.g., `conductor/product.md`) for all file operations within the conductor directory.

---

## 1.1 PRE-INITIALIZATION OVERVIEW
1.  **Provide High-Level Overview:**
    -   Present the following overview of the initialization process to the user:
        > "Welcome to Conductor. I will guide you through the following steps to set up your project:
        > 1. **Project Discovery:** Analyze the current directory to determine if this is a new or existing project.
        > 2. **Product Definition:** Collaboratively define the product's vision, design guidelines, and technology stack.
        > 3. **Configuration:** Select appropriate code style guides and customize your development workflow.
        > 4. **Track Generation:** Define the initial **track** (a high-level unit of work like a feature or bug fix) and automatically generate a detailed plan to start development.
        >
        > Let's get started!"

---

## 1.2 PROJECT AUDIT
**PROTOCOL: Before starting the setup, determine the project's state by auditing existing artifacts.**

1.  **Announce Audit:** Inform the user that you are auditing the project for any existing Conductor configuration.

2.  **Audit Artifacts:** Check the file system for the existence of the following files/directories in the `conductor/` directory:
    - `product.md`
    - `product-guidelines.md`
    - `tech-stack.md`
    - `code_styleguides/`
    - `workflow.md`
    - `index.md`
    - `tracks/*/` (specifically `plan.md` and `index.md`)

3.  **Determine Target Section:** Map the project's state to a target section using the priority table below (highest match wins). **DO NOT JUMP YET.** Keep this target in mind.

| Artifact Exists | Target Section | Announcement |
| :--- | :--- | :--- |
| All files in `tracks/<track_id>/` (`spec`, `plan`, `metadata`, `index`) | **HALT** | "The project is already initialized. Use `/conductor:new-track` or `/conductor:implement`." |
| `index.md` (top-level) | **Section 3.0** | "Resuming setup: Scaffolding is complete. Next: generate the first track." |
| `workflow.md` | **Section 2.6** | "Resuming setup: Workflow is defined. Next: select Agent Skills." |
| `code_styleguides/` | **Section 2.5** | "Resuming setup: Guides/Tech Stack configured. Next: define project workflow." |
| `tech-stack.md` | **Section 2.4** | "Resuming setup: Tech Stack defined. Next: select Code Styleguides." |
| `product-guidelines.md` | **Section 2.3** | "Resuming setup: Guidelines are complete. Next: define the Technology Stack." |
| `product.md` | **Section 2.2** | "Resuming setup: Product Guide is complete. Next: create Product Guidelines." |
| (None) | **Section 2.0** | (None) |

4. **Proceed to Section 2.0:** You MUST proceed to Section 2.0 to establish the Greenfield/Brownfield context before jumping to your target.

---

## 2.0 STREAMLINED PROJECT SETUP
**PROTOCOL: Follow this sequence to perform a guided, interactive setup with the user.**

### 2.0 Project Inception
1.  **Detect Project Maturity:**
    -   **Classify Project:** Determine if the project is "Brownfield" (Existing) or "Greenfield" (New) based on the following indicators:
    -   **Brownfield Indicators:**
        -   Check for dependency manifests: `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, `Cargo.toml`.
        -   Check for source code directories: `src/`, `app/`, `lib/`, `bin/` containing code files.
        -   If a `.git` directory exists, run `git status --porcelain` via Bash. Ignore changes within the `conductor/` directory.
        -   If ANY of the primary indicators (manifests or source code directories) are found, classify as **Brownfield**.
    -   **Greenfield Condition:**
        -   Classify as **Greenfield** ONLY if NONE of the "Brownfield Indicators" are found and the directory contains no application source code or dependency manifests.

2.  **Resume Fast-Forward Check:**
    - If the **Target Section** (from 1.2) is anything other than "Section 2.0":
        - Announce the project maturity (Greenfield/Brownfield) and briefly state the reason. Then announce the target section.
        - **IMMEDIATELY JUMP** to the Target Section. Do not execute the rest of Section 2.0.
    - If the Target Section is "Section 2.0", proceed to step 3.

3.  **Execute Workflow based on Maturity:**
    -   **If Brownfield:**
        -   Announce that an existing project has been detected, and briefly state the specific indicator you found.
        -   If `git status --porcelain` indicated uncommitted changes, inform the user: "WARNING: You have uncommitted changes. Please commit or stash your changes before proceeding."
        -   **Brownfield Project Initialization:**
            1.  Request permission for a read-only scan to analyze the project.
            2.  If permission granted, analyze `README.md` first, then other relevant files.
            3.  Check `.gitignore` patterns to exclude irrelevant files from analysis.
            4.  Prioritize key files: `package.json`, `pom.xml`, `requirements.txt`, `go.mod`, etc.
            5.  Extract Tech Stack: Identify language, frameworks, database drivers.
            6.  Infer Architecture from file structure.
            7.  Infer Project Goal from README or manifest descriptions.
        -   Upon completing brownfield analysis, proceed to Section 2.1.

    -   **If Greenfield:**
        -   Announce that a new project will be initialized.
        -   **Initialize Git Repository:** If no `.git` directory exists, run `git init` via Bash.
        -   **Ask about Project Goal:** Ask the user: "What do you want to build?" and wait for their response.
        -   Upon receiving the response, create the `conductor/` directory and write the response into `conductor/product.md` under a `# Initial Concept` header.
        -   Proceed to Section 2.1.

### 2.1 Generate Product Guide (Interactive)
1.  **Introduce the Section:** Announce that you will now help create `product.md`.
2.  **Determine Mode:** Ask the user:
    > "How would you like to define the product details?
    > 1. **Interactive** - I'll guide you through questions to refine your vision.
    > 2. **Autogenerate** - I'll draft a comprehensive guide based on your initial project goal."

3.  **Gather Information (Conditional):**
    -   **If Autogenerate:** Skip to Step 5.
    -   **If Interactive:** Ask up to 4 questions about target users, goals, features, etc.
        -   For brownfield projects, formulate context-aware questions based on the analyzed codebase.
        -   Provide 3 suggested answers for each question.

4.  **Draft the Document:** Generate the content for `product.md`.
5.  **User Confirmation:** Present the draft and ask the user to approve or suggest changes.
6.  **Write File:** Once approved, write to `conductor/product.md`.

### 2.2 Generate Product Guidelines (Interactive)
1.  **Introduce the Section:** Announce that you will now create `product-guidelines.md`.
2.  **Determine Mode:** Ask the user to choose Interactive or Autogenerate.
3.  **Gather Information (Conditional):** If Interactive, ask about prose style, branding, UX principles.
4.  **Draft the Document:** Generate content for `product-guidelines.md`.
5.  **User Confirmation:** Present the draft for approval.
6.  **Write File:** Once approved, write to `conductor/product-guidelines.md`.

### 2.3 Generate Tech Stack (Interactive)
1.  **Introduce the Section:** Announce that you will now define the technology stack.
2.  **Determine Mode:**
    -   **For Greenfield:** Ask user to choose Interactive or Autogenerate.
    -   **For Brownfield:** State the inferred tech stack and ask for confirmation. If user disagrees, ask them to provide the correct stack.
3.  **Gather Information (Greenfield Interactive Only):** Ask about languages, frameworks, databases.
4.  **Draft the Document:** Generate content for `tech-stack.md`.
5.  **User Confirmation:** Present the draft for approval.
6.  **Write File:** Once approved, write to `conductor/tech-stack.md`.

### 2.4 Select Code Style Guides (Interactive)
1.  **List Available Guides:** Check the `templates/code_styleguides/` directory in the project root for available style guides. If templates are not found at the project root, check the Conductor installation directory (the repo that contains these command files).
2.  **Recommend Guides:** Based on the Tech Stack, recommend appropriate style guides.
3.  **User Selection:** Ask the user if they want the recommended guides or to select manually.
4.  **Action:** Copy selected style guide files to `conductor/code_styleguides/`.

### 2.5 Select Workflow
1.  **Copy Initial Workflow:** Copy `templates/workflow.md` to `conductor/workflow.md`.
2.  **Determine Mode:** Ask the user:
    > "Do you want to use the default workflow or customize it? The default includes >80% test coverage and per-task commits.
    > 1. **Default** - Use the standard Conductor workflow.
    > 2. **Customize** - Adjust coverage requirements and commit frequency."
3.  **Gather Customizations (if Customize):** Ask about:
    - Test coverage percentage
    - Commit frequency (per task or per phase)
    - Task summary storage (git notes or commit messages)
4.  **Action:** Update `conductor/workflow.md` based on user answers.

### 2.6 Select Skills (Interactive)
1.  **Analyze and Recommend:** Read `skills/catalog.md` from the project root or Conductor installation directory. If not found, skip to Section 2.7.
2.  **Present Recommendations:** If relevant skills are found, ask the user if they want to install them.
3.  **Install Selected Skills:** Download and install selected skills to the appropriate path.

### 2.7 Finalization
1.  **Generate Index File:** Create `conductor/index.md`:
    ```markdown
    # Project Context

    ## Definition
    - [Product Definition](./product.md)
    - [Product Guidelines](./product-guidelines.md)
    - [Tech Stack](./tech-stack.md)

    ## Workflow
    - [Workflow](./workflow.md)
    - [Code Style Guides](./code_styleguides/)

    ## Management
    - [Tracks Registry](./tracks.md)
    - [Tracks Directory](./tracks/)
    ```
2.  **Summarize Actions:** Present a summary of all setup actions taken.
3.  **Transition:** Announce that setup is complete and proceed to define the first track.

---

## 3.0 INITIAL PLAN AND TRACK GENERATION
**PROTOCOL: Interactively define project requirements, propose a single track, and create corresponding artifacts.**

**Pre-Requisite (Cleanup):** If resuming and `conductor/tracks/` is incomplete, delete it for a clean slate.

### 3.1 Generate Product Requirements (Interactive - Greenfield only)
1.  **Analyze Context:** Read `conductor/product.md`.
2.  **Determine Mode:** Ask the user to choose Interactive or Autogenerate for requirements.
3.  **Gather Information (if Interactive):** Ask about user stories, key features, constraints.
4.  **Draft Requirements:** Generate a requirements document.
5.  **User Confirmation:** Present for approval.

### 3.2 Propose a Single Initial Track
1.  **Generate Track Title:** Based on project context, propose a track title.
    - **Greenfield:** Focus on MVP core.
    - **Brownfield:** Focus on maintenance or targeted enhancements.
2.  **Confirm Proposal:** Ask the user to approve or suggest a different track.

### 3.3 Convert the Initial Track into Artifacts
1.  **Initialize Tracks File:** Create `conductor/tracks.md`:
    ```markdown
    # Project Tracks

    This file tracks all major tracks for the project. Each track has its own detailed plan in its respective folder.

    ---

    - [ ] **Track: <Track Description>**
      *Link: [./tracks/<track_id>/](./tracks/<track_id>/)*
    ```
2.  **Generate Track Artifacts:**
    a. Generate Track ID: `shortname_YYYYMMDD`
    b. Create directory: `conductor/tracks/<track_id>/`
    c. Create `metadata.json` with track info
    d. Generate and write `spec.md` and `plan.md`
        - Plan MUST follow the workflow in `conductor/workflow.md` (e.g., TDD tasks)
        - Include status markers `[ ]` for every task and sub-task
        - Inject Phase Completion Tasks if defined in workflow
    e. Write `index.md` linking to spec, plan, and metadata

### 3.4 Final Announcement
1.  **Announce Completion:** Setup and initial track generation are complete.
2.  **Commit:** Stage and commit all conductor files with message `conductor(setup): Add conductor setup files`.
3.  **Next Steps:** Inform the user to run `/conductor:implement` to begin work.

# ChatGPT Video Editing Skills Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and publish a public, installable two-skill GitHub repository for setting up and running the user's eight-step AI short-video workflow.

**Architecture:** Keep environment mutation in `chatgpt-video-editing-setup` and editing behavior in `chatgpt-short-video-editor`. Put detailed operational rules in focused reference files, retain the complete all-in-one prompt as an example, and use deterministic shell validation plus behavioral eval cases.

**Tech Stack:** Agent Skills Markdown, POSIX shell, JSON evals, Git, GitHub CLI, `npx skills`.

## Global Constraints

- Public repository: `Jaycheng1103/chatgpt-video-editing-skills`.
- Do not include, install, or depend on OpenMontage.
- Never commit or display ElevenLabs API keys.
- Preserve original media and keep work in adjacent `edit/`.
- Require approval before installs, paid API uploads, or creative additions.
- Use `video-use`, ElevenLabs Scribe v2, FFmpeg/ffprobe, Pillow, and optional approved HyperFrames.
- Preview at 720p before 1080×1920 final export and retain QA evidence.

---

### Task 1: Contract tests and eval scenarios

**Files:**
- Create: `tests/validate_repo.sh`
- Create: `evals/evals.json`
- Create: `evals/baseline.md`

**Interfaces:**
- Consumes: the design contract.
- Produces: executable acceptance checks and trigger/safety scenarios used by all later tasks.

- [ ] **Step 1: Write the failing repository validator**

The script must fail when README, both Skills, references, complete prompt, image, license, or security/editing contract phrases are absent. It must also scan public package files for secret-shaped values and forbidden OpenMontage references.

- [ ] **Step 2: Run the validator to verify RED**

Run: `sh tests/validate_repo.sh`

Expected: non-zero exit with the first missing required file.

- [ ] **Step 3: Record behavioral eval cases and baseline results**

Cover setup triggering, editing triggering, Premiere negative triggering, dirty Repo handling, missing ElevenLabs key, cloud-upload consent, strategy gate, original-file preservation, HyperFrames fallback, and no false completion.

### Task 2: Setup Skill

**Files:**
- Create: `skills/chatgpt-video-editing-setup/SKILL.md`
- Create: `skills/chatgpt-video-editing-setup/references/setup-runbook.md`
- Create: `skills/chatgpt-video-editing-setup/references/security-and-verification.md`

**Interfaces:**
- Consumes: official `video-use`, HyperFrames, and ElevenLabs setup requirements.
- Produces: a Skill that installs dependencies only after approval and reports evidence without starting paid editing work.

- [ ] **Step 1: Add minimal frontmatter and workflow to satisfy setup trigger tests**
- [ ] **Step 2: Add exact runbook and security reference details**
- [ ] **Step 3: Run `quick_validate.py` and the repository validator**

Expected: Skill validation passes; repository validation still fails only for later-task files.

### Task 3: Short-video Editor Skill

**Files:**
- Create: `skills/chatgpt-short-video-editor/SKILL.md`
- Create: `skills/chatgpt-short-video-editor/references/eight-step-workflow.md`
- Create: `skills/chatgpt-short-video-editor/references/production-rules.md`
- Create: `skills/chatgpt-short-video-editor/references/output-contract.md`

**Interfaces:**
- Consumes: installed `video-use` environment and a user-provided media source.
- Produces: approved strategy, EDL-based edit, preview, final export, retained artifacts, and evidence-backed QA report.

- [ ] **Step 1: Add minimal frontmatter and eight-step conductor**
- [ ] **Step 2: Add production correctness and output references**
- [ ] **Step 3: Run both Skill validators and the repository validator**

Expected: both Skills validate; repository validation still fails only for documentation/assets.

### Task 4: Public documentation and reusable prompt

**Files:**
- Create: `README.md`
- Create: `examples/完整提示詞.md`
- Create: `assets/ChatGPT剪短影音的八大步驟.png`
- Create: `.gitignore`
- Create: `LICENSE`
- Create: `THIRD_PARTY_NOTICE.md`
- Create: `CONTRIBUTING.md`
- Create: `CODE_OF_CONDUCT.md`

**Interfaces:**
- Consumes: the two Skills and the user's approved infographic/prompt.
- Produces: a discoverable, installable, safely reusable public package.

- [ ] **Step 1: Write README with all/single/manual installation, examples, tool roles, privacy, outputs, removal, and disclaimer**
- [ ] **Step 2: Add the complete all-in-one prompt without writing-block wrappers**
- [ ] **Step 3: Add the existing approved infographic and legal/community files**
- [ ] **Step 4: Run all validators and secret scans**

Expected: all local checks pass with no key-shaped values and no forbidden dependency references.

### Task 5: Package, publish, and remote-install verification

**Files:**
- Modify only if verification reveals a defect in files above.

**Interfaces:**
- Consumes: validated local Repo.
- Produces: public GitHub Repo and verified installation from the remote source.

- [ ] **Step 1: Initialize standalone Git Repo and commit exact files**
- [ ] **Step 2: Create public GitHub Repo and push the default branch**
- [ ] **Step 3: Clone the public Repo into a clean temporary directory**
- [ ] **Step 4: Run the validator and `npx skills add` against the public source in isolated temp homes**
- [ ] **Step 5: Verify GitHub metadata and hand off the public URL plus install commands**

Expected: public clone succeeds, both Skills install, remote HEAD matches local HEAD, and the GitHub Repo is publicly readable.


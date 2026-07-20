---
name: chatgpt-video-editing-setup
description: "Set up, repair, or verify the local AI short-video environment: video-use, FFmpeg, ElevenLabs credentials, and optional HyperFrames skills. Use whenever a user asks to install, configure, fix, reconnect, or check this editing environment. Do not use for Premiere or CapCut help, or to edit/transcribe media; hand those requests to the editing workflow after setup is verified."
---

# ChatGPT Video Editing Setup

Prepare or repair the environment without starting creative work. The outcome is
an evidence-backed readiness report, not a transcript, upload, edit, preview, or
render.

## Read first

Read [the setup runbook](references/setup-runbook.md) for commands and install
choices. Read [security and verification](references/security-and-verification.md)
before handling credentials or declaring anything ready.

## Operating sequence

1. Inspect before changing anything: check the stable paths
   `~/Developer/video-use` and `~/Developer/hyperframes`, repository remotes,
   current branch/status, available runtime tools, and the active agent's Skills
   location. Do not print secrets.
2. If either existing repository is dirty, stop. Report its path and status; do
   not pull, reset, overwrite, or install into it until the user resolves or
   explicitly directs the next safe action.
3. State the exact mutations needed, including clones, package installs, large
   downloads, or Skills-directory changes. Obtain explicit approval before any
   of them. Inspection and a no-cost local version check do not imply approval
   to mutate.
4. After approval, follow the runbook exactly. Install/register the complete
   video-use repository so its helpers remain available. Treat HyperFrames as
   optional unless the user specifically needs HTML, CSS, or GSAP animation.
5. Configure ElevenLabs only through an existing environment variable or the
   protected `~/Developer/video-use/.env` path. Never echo, log, or commit a
   credential.
6. Verify with local, no-paid-work checks only. Do not upload media, call
   transcription, create an edit directory, or edit/render any video.
7. Report checked paths, approved mutations performed, evidence, versions or
   command outcomes, remaining gaps, and the explicit next action. Never claim
   readiness without successful evidence.

## Handoff boundary

Before any later first media upload to ElevenLabs, identify the source file,
state that it will be uploaded for transcription with ElevenLabs Scribe v2, note
that account quota or charges may apply, and obtain consent. Setup itself ends
before that point.

---
name: puretext-video-subtitles
description: "Prepare editable, timed subtitles for user-supplied local media through PureText. Use for transcription, translation, terminology review, or SRT/VTT/JSON export before an editing workflow. Do not use for YouTube downloading, creative cutting, or environment-only setup."
---

# PureText Video Subtitles

Create a verified subtitle document from media the user owns or is authorized to
process. This Skill prepares subtitle assets; it does not choose creative edit
points, render video, publish media, or access YouTube on the user's behalf.

## Before creating a job

1. Confirm a concrete local file or approved cloud-file location is available.
   Inspect local media with `ffprobe` when possible. Never move, rename,
   overwrite, or delete the source.
2. Read [the PureText adapter contract](references/api-contract.md). Use only a
   configured PureText CLI or Agent API adapter; never put a web session JWT,
   Google cookie, API token, or secret in prompts, source files, Git, or logs.
3. State the source filename, requested transcription/translation languages,
   whether word-level timestamps are requested, and the estimated PureText
   credit use. Get explicit approval before uploading media or creating a
   billable job. A filename or a request to "make subtitles" is not approval.
4. Keep all local deliverables beside the source in `<source-directory>/edit/`.
   Preserve the returned job ID and subtitle-document ID in `project.md`, but
   do not store credentials there.

## Working rules

- Treat the original `segments` as immutable evidence. Corrections, translated
  text, and display cues are derived layers and must retain their source IDs.
- Request word timestamps when the subtitles will drive edit points, word
  highlighting, karaoke-style captions, or EDL generation. Phrase-only timing
  may be exported as ordinary subtitles but must not be represented as
  word-accurate.
- Keep source and translated subtitles separate. Do not overwrite source text
  with a translation.
- Read [the subtitle-document contract](references/subtitle-document-contract.md)
  before handing results to an editor, changing cue boundaries, or exporting
  structured JSON.
- Report actual remote-job status and returned IDs. Do not infer completion
  from a progress percentage, a downloaded file, or an Agent plan.

## Handoff

After a verified subtitle document is available, create or update these
source-adjacent artifacts:

```text
edit/
├── transcripts/<source>.puretext.json  # unmodified PureText document/export
├── master.srt                           # selected display-cue export, if requested
├── master.vtt                           # if requested
└── project.md                           # IDs, consent, languages, and verification
```

For a vertical-short edit, hand the verified document to
`chatgpt-short-video-editor`. That Skill may use word timestamps for edit
boundaries and display cues for rendered subtitles; it must not silently
replace either layer.

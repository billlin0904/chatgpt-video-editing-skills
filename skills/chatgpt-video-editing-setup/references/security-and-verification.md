# Security and verification

## PureText Agent API credential handling

Use `PURETEXT_API_BASE_URL` and `PURETEXT_AGENT_TOKEN` only from the process
environment. Never ask the user to paste either value into a chat transcript,
command-line argument, public file, commit message, shell history, or log.
Never print a credential or a redacted-looking substitute, and never use a
browser session, Google cookie, or other unrelated user credential as a
fallback.

If either environment variable is absent, say that the PureText credential
check is incomplete and hand the user the exact variable names to configure in
their own terminal. Do not create a `.env` file, modify a third-party repository,
or ask the user to expose a Token in conversation. A safe check may report only
that each required variable is present or absent; it must not disclose values,
lengths, prefixes, account details, or endpoint query strings.

Do not send a test transcription, upload a sample, inspect quota, or call a
paid endpoint as part of setup. Before the first later media upload, obtain a
new, specific consent. State the filename, that it will be uploaded to the
PureText Agent API for word-level transcription, the intended target language,
the estimated minutes and any possible quota or charges. Do not upload unless
the user confirms that exact action.

## Evidence required for readiness

Report observations, not assumptions:

| Check | Evidence to report |
| --- | --- |
| video-use source | stable path, origin URL, clean Git status, helpers directory |
| runtime | paths or versions for Python/uv, FFmpeg, and ffprobe |
| subtitle font | `SourceHanSansTW-Regular.otf` and `SourceHanSansTW-Bold.otf` present as regular files in the platform font directory, `OTTO` magic verified, and the `fc-list` match where fontconfig exists |
| video-use registration | agent Skills path and symlink target, if one was approved |
| PureText credentials | `PURETEXT_API_BASE_URL` and `PURETEXT_AGENT_TOKEN` present or absent, without their values |
| HyperFrames, if explicitly approved and installed | stable path, exact official origin URL, clean status, Node.js 22+, lockfile, installed Core Skills outcome |
| no-cost boundary | confirmation that no media was uploaded, transcribed, edited, previewed, or rendered |

If a check fails, report it as incomplete with the next proposed mutation; do
not call the environment “ready.” Do not alter original media in setup. The
later editing workflow keeps new artifacts adjacent to its source under `edit/`.
If HyperFrames was not explicitly approved and installed, skip all of its Repo,
Node, `bun.lock`, and Core Skills checks and report “HyperFrames 未要求”; that is
not a setup failure.

# Security and verification

## ElevenLabs credential handling

Use `ELEVENLABS_API_KEY` only from the process environment or from
`~/Developer/video-use/.env`. Never ask the user to paste a key into a chat
transcript, command-line argument, public file, commit message, shell history,
or log. Never print a key or a redacted-looking substitute.

If the key is absent, say that setup cannot complete the credential check and
ask the user to place their own key in the protected local file using an editor,
or provide it through their environment outside the conversation. Then enforce:

```sh
chmod 600 "$HOME/Developer/video-use/.env"
git -C "$HOME/Developer/video-use" check-ignore -q .env
```

Do not create a credential file until that mutation is included in the approval
list. If `.env` is not ignored, stop before storing any credential and resolve
the ignore rule safely. Do not use `cat`, `grep`, `env`, or similar output that
could expose its contents.

## Credential checks without paid transcription

Confirm only that one approved credential source is present and that a local
file has mode `600`. A safe report can say “environment variable present” or
“protected local file present”; it must not disclose its value, length, prefix,
or account details. Do not send a test transcription, upload a sample, inspect
cloud quota, or call an endpoint as part of setup.

Before the first later media upload, obtain a new, specific consent. State the
filename, that it will be uploaded to ElevenLabs for ElevenLabs Scribe v2
transcription, the intended use, and that quota or charges may apply. Do not
upload unless the user confirms that exact action.

## Evidence required for readiness

Report observations, not assumptions:

| Check | Evidence to report |
| --- | --- |
| video-use source | stable path, origin URL, clean Git status, helpers directory |
| runtime | paths or versions for Python/uv, FFmpeg, and ffprobe |
| video-use registration | agent Skills path and symlink target, if one was approved |
| credential | source present and `.env` mode/ignore check, without value |
| HyperFrames, if approved | stable path, origin URL, clean status, lockfile, installed Skills outcome |
| no-cost boundary | confirmation that no media was uploaded, transcribed, edited, previewed, or rendered |

If a check fails, report it as incomplete with the next proposed mutation; do
not call the environment “ready.” Do not alter original media in setup. The
later editing workflow keeps new artifacts adjacent to its source under `edit/`.

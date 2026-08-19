# PureText adapter contract

This Skill requires a configured PureText integration. The public browser API
and its web-login JWT are not an Agent credential. Do not scrape the web UI or
reuse browser cookies. Until a dedicated Agent API/CLI and a revocable token
are configured, stop after local inspection and explain that the integration
is not ready.

## Required operations

The adapter may be a `puretext` CLI or a typed MCP/Agent API, but it must
provide these operations and return machine-readable JSON:

| Operation | Must return | Can create cost? |
| --- | --- | --- |
| Inspect / preview source | filename, duration, accepted media type, estimated minutes, supported targets | No |
| Read credits | current available minutes | No |
| Create subtitle job | job ID, subtitle-document ID when available, state | Yes — explicit confirmation required |
| Read job status | phase, progress, ETA when known, terminal error when failed | No |
| Fetch subtitle document | original segments, word timestamps when requested, translations and display cues when complete | No |
| Export subtitles | SRT, VTT, or structured JSON from a selected subtitle layer | No |
| Read term index | job/document reference, terms, occurrences, partial/final state | No |

## Authorization and confirmation

- Use an account-scoped, revocable PureText Agent token with only the required
  scopes. Never request an admin token.
- A create call must be impossible without an explicit confirmation flag (for
  example `confirm: true`) after the user has seen the estimated minutes and
  target language.
- A retry is billable unless the adapter explicitly reports otherwise. Ask
  again before retrying a failed or cancelled job.
- The adapter must enforce ownership server-side. The Skill must not assume a
  job ID belongs to the active user.

## Expected creation input

```json
{
  "source": { "type": "local_upload", "path_or_upload_id": "..." },
  "transcription": { "language": "auto", "word_timestamps": true },
  "translation": { "enabled": true, "target_language": "zh-TW" },
  "confirm": true
}
```

`path_or_upload_id` is adapter-specific. A remote integration must upload or
reference the file without exposing its contents in chat output.

## PureText Agent API implementation

When `PURETEXT_API_BASE_URL` and `PURETEXT_AGENT_TOKEN` are configured, use
the versioned Agent API. `PURETEXT_API_BASE_URL` must end in `/api/agent/v1`.
Do not print either environment variable, including in diagnostic output.

The Token needs the minimum scopes below:

```text
credits:read
uploads:write
jobs:create
jobs:read
subtitles:read
```

### Required no-cost sequence

1. `GET /credits` — read available minutes.
2. `POST /uploads/preview` with `filename`, `sizeBytes`, and `contentType`.
   The response contains an `uploadId`, short-lived `uploadToken`, and
   `chunkBytes` (currently 20 MiB).
3. Upload each media range (currently 8 MiB; always use the returned
   `chunkBytes` value) to
   `PUT /uploads/{uploadId}/chunks/{chunkIndex}` as
   `application/octet-stream`, with both `Authorization: Bearer …` and
   `X-Upload-Token`. Do not send an entire large video as one request.
4. `POST /uploads/{uploadId}/complete` with `X-Upload-Token`. This reads the
   real duration and returns an initial minute estimate without creating a
   job.
5. `POST /subtitle-jobs/estimate`, carrying `uploadId` and:

```json
{
  "uploadId": "returned-upload-id",
  "transcription": { "language": "auto", "wordTimestamps": true },
  "translation": { "enabled": true, "targetLanguage": "zh-TW" }
}
```

Show `estimatedMinutes` and `availableMinutes` to the user. An `estimateId`
is valid for 15 minutes and is bound to these exact options.

### Billable confirmation

Only after the user explicitly approves the displayed estimate, call
`POST /subtitle-jobs` with the same upload and subtitle options plus:

```json
{
  "uploadId": "returned-upload-id",
  "estimateId": "returned-estimate-id",
  "confirm": true
}
```

`uploadToken` is only for uploading chunks and completing the initial upload.
Do not persist it in a project file. The Agent Token authorizes later estimate,
status, and confirmed-job calls for the same account and upload ID.

The API refuses job creation if `confirm` is not exactly `true`, the estimate
has expired, its options differ, the upload is incomplete, or credit is no
longer sufficient. Never retry a failed creation automatically.

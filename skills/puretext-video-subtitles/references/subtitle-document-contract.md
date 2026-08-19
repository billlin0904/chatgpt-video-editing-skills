# Subtitle document contract

Use the PureText subtitle document as the source of truth. Preserve the raw
export under `edit/transcripts/` before making any local derivative.

## Required data for editing handoff

```json
{
  "document_id": "string",
  "job_id": "string-or-number",
  "source": {
    "filename": "interview.mp4",
    "duration_seconds": 321.4,
    "language": "en"
  },
  "segments": [
    {
      "id": "seg-12",
      "start": 42.18,
      "end": 45.62,
      "text": "Original spoken text.",
      "words": [
        { "text": "Original", "start": 42.18, "end": 42.71 }
      ]
    }
  ],
  "translations": [
    {
      "target_language": "zh-TW",
      "groups": [
        { "id": "group-3", "segment_ids": ["seg-12"], "text": "原文的翻譯。" }
      ]
    }
  ],
  "display_cues": [
    {
      "id": "cue-8",
      "start": 42.18,
      "end": 45.62,
      "text": "原文的翻譯。",
      "source_segment_ids": ["seg-12"],
      "language": "zh-TW"
    }
  ]
}
```

Field names may differ in a concrete API response. Map them only when the
meaning is equivalent; retain original IDs and retain the original unmodified
response alongside the normalized handoff file.

## Layer rules

- `segments` are immutable source evidence and carry the original timeline.
- `words` are optional. If absent, declare the material phrase-timed and do
  not create word-boundary edit decisions or word-by-word highlighting.
- `translations.groups` translate source IDs and do not change source timing.
- `display_cues` are presentation units. They may combine or split source
  segments, but every cue must retain source IDs and a valid timeline.

## Validation before handoff

Confirm that segment time ranges are non-negative and ordered, every display
cue refers to at least one source segment, requested target-language text is
present, and the document belongs to the inspected media. For edit-boundary
work, spot-check word timestamps by playback before using them in an EDL.

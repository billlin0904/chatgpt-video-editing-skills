# Production rules

## Transcript and edit decisions

- Use word-level verbatim timestamps and cache them per unchanged source. Do
  not re-transcribe unless the source itself changes.
- Snap every edit edge to a word boundary: never cut inside a word. Retain
  30–200ms of boundary padding, selecting the amount from the spoken cadence.
- Store source, start, end, beat, quote, and reason in `edl.json`. Keep its
  source ranges and output offsets internally consistent.
- Extract, process, and verify each kept segment before concatenation. At every
  segment audio edge use about 30ms fades to avoid clicks or pops.

## Visuals, captions, and sound

- Apply approved grading per segment. Do not imply that an unrequested grade
  is corrective or desired.
- Make simple title and information cards as static Pillow assets. HyperFrames
  is optional and only follows an approved HTML, CSS, or GSAP animation plan.
- Build `master.srt` using output-timeline offsets:
  `output_time = word.start - segment_start + segment_offset`.
- Apply subtitles last, after all overlays and cards, so they remain visible.
- Keep source audio intelligible; preserve approved music and effects only.

## Preview, QA, and retry limit

1. Render one complete 720p preview before any final export.
2. Inspect the rendered preview at each cut boundary in a ±1.5s window for
   visual jumps, flashes, audio pops, sync, subtitle visibility, and overlay
   alignment. Also inspect first, last, and representative mid-point samples.
3. Perform a full decode check and record observed duration, dimensions, audio,
   and video streams. Check subtitle safe area, colour consistency, and mix.
4. A failed check may trigger a self-fix only when the evidence identifies the
   problem. Limit this loop to three passes; then stop and report remaining
   issues instead of claiming success.
5. After explicit preview approval and a passing final verification, output one
   1080×1920 formal final. Do not claim a deliverable exists until that file has
   been rendered and inspected.

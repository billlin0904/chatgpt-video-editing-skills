# Eight-step workflow

All work belongs in `<source-directory>/edit/`; the supplied media stays
unchanged. Read any existing `project.md` first and record the current session.

## 1. 素材檢查

Use `ffprobe` on every source to record streams, duration, dimensions, frame
rate, audio, and readable decode status. Confirm the intended source and
vertical target. Create the adjacent `edit/` workspace only after this check.

## 2. 逐字轉寫

Cache a word-level verbatim transcript under `edit/transcripts/`, keyed to the
unchanged source. Before a first ElevenLabs upload, obtain the file-specific
consent described in the Skill. ElevenLabs Scribe v2 is the preferred source
for word-level timestamps; do not replace them with phrase-only subtitles.
Another local word-level result needs its own timing verification and is not
represented as having the same timing precision.

## 3. 內容整理

Build a readable packed transcript and identify the story, strongest moments,
obvious slips, omissions, likely target length, and ambiguity that needs a
visual check. This is analysis, not an approved cut list.

## 4. 剪輯決策

Give a 4–8 sentence strategy in plain language: audience outcome, narrative
shape, selected material, pacing, estimated duration, visual direction, and
subtitle approach. Wait for approval. Do not independently add B-roll,
animation, music, effects, CTA, or a publishing schedule.

## 5. 逐段粗剪

After approval, build `edl.json` from word-aligned kept ranges. Extract and
grade each kept range independently, apply boundary fades, then concatenate.
Inspect ambiguous cuts with a source timeline view before committing them.

## 6. 轉色／圖卡／字幕

Apply only approved colour changes, cards, or animation. Build simple cards as
static Pillow images. Use HyperFrames only when the approved strategy needs an
HTML, CSS, or GSAP animation and its environment is ready. Generate subtitles
from the EDL on the output timeline and apply them last.

## 7. 混音與完整預覽

Create one complete 720p preview, including the approved mix and visuals.
Check the rendered output at every cut and across its full duration before
showing it as ready for review.

## 8. QA 與正式定稿

Record QA evidence, make at most three evidence-led corrections, and request
preview confirmation. Only then render and verify one 1080×1920 formal final;
retain the preview and all underlying artifacts.

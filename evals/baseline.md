# Baseline behavioral evaluation

Date: 2026-07-20

This baseline records observed generic-response behavior before the two repository Skills exist. It is a comparison target, not evidence that an installation, transcript, preview, or export actually happened.

## Setup response

The generic setup response asked for permission and protected secrets and dirty repositories. It chose project-local installation paths, however, rather than the required stable paths `~/Developer/video-use` and `~/Developer/hyperframes`. It also did not state whole-Repo Skill registration or no-cost validation.

## Editing response

The generic editing response preserved the source, used adjacent `edit/`, requested approval, proposed a six-sentence strategy, and mentioned word-level cuts, a 720p preview, and QA. It did not cover EDL retention, 30–200ms cut padding, 30ms audio fades, subtitles-last composition, output-timeline subtitle offsets, the complete retained artifacts, or the three-pass evidence cap.

## Trigger baseline

The generic trigger behavior correctly distinguished Premiere help from setup and editing requests. The positive setup and editing cases and the negative Premiere case are retained in `evals.json` as regression scenarios.

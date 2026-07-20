#!/bin/sh
# Repository acceptance checks for the public package. Keep this POSIX-sh.
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

fail() {
  printf '%s\n' "ERROR: $1" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "missing required file: $1"
}

# Check the public artifacts first so an incomplete checkout has one clear,
# actionable failure rather than a cascade of content-check errors.
require_file "README.md"
require_file "skills/chatgpt-video-editing-setup/SKILL.md"
require_file "skills/chatgpt-video-editing-setup/references/setup-runbook.md"
require_file "skills/chatgpt-video-editing-setup/references/security-and-verification.md"
require_file "skills/chatgpt-short-video-editor/SKILL.md"
require_file "skills/chatgpt-short-video-editor/references/eight-step-workflow.md"
require_file "skills/chatgpt-short-video-editor/references/production-rules.md"
require_file "skills/chatgpt-short-video-editor/references/output-contract.md"
require_file "examples/完整提示詞.md"
require_file "assets/ChatGPT剪短影音的八大步驟.png"
require_file "LICENSE"

# Inspect every public text-like file. Internal specifications, plans, and
# test/eval notes are excluded because they legitimately describe the negative
# constraint. grep -I prevents binary assets from causing scan noise.
TEXT_FILES=$(find . \
  \( -path './.git' -o -path './.git/*' \
    -o -path './.superpowers' -o -path './.superpowers/*' \
    -o -path './docs/superpowers' -o -path './docs/superpowers/*' \
    -o -path './tests' -o -path './tests/*' \
    -o -path './evals' -o -path './evals/*' \) -prune -o \
  -type f -print | while IFS= read -r file; do
    if grep -I -F '' "$file" >/dev/null 2>&1; then
      printf '%s\n' "$file"
    fi
  done)

has_phrase() {
  phrase=$1
  while IFS= read -r file; do
    if grep -F "$phrase" "$file" >/dev/null 2>&1; then
      return 0
    fi
  done <<EOF
$TEXT_FILES
EOF
  return 1
}

require_phrase() {
  phrase=$1
  has_phrase "$phrase" || fail "missing required contract phrase: $phrase"
}

require_phrase "ELEVENLABS_API_KEY"
require_phrase "~/Developer/video-use/.env"
require_phrase "edit/"
require_phrase "approval"
require_phrase "ElevenLabs Scribe v2"
require_phrase "video-use"
require_phrase "FFmpeg"
require_phrase "ffprobe"
require_phrase "Pillow"
require_phrase "HyperFrames"
require_phrase "素材檢查、逐字轉寫、內容整理、剪輯決策、逐段粗剪、轉色／圖卡／字幕、混音與完整預覽、QA 與正式定稿"
require_phrase "30–200ms"
require_phrase "30ms"
require_phrase "720p"
require_phrase "1080×1920"
require_phrase "QA"

FORBIDDEN_DEPENDENCY='OpenMontage'
while IFS= read -r file; do
  if grep -n -F "$FORBIDDEN_DEPENDENCY" "$file"; then
    fail "forbidden dependency reference found in public package files: $FORBIDDEN_DEPENDENCY"
  fi
done <<EOF
$TEXT_FILES
EOF

SECRET_PATTERN='(sk-[A-Za-z0-9_-]{16,}|gh[pousr]_[A-Za-z0-9_-]{16,}|AKIA[0-9A-Z]{16}|(ELEVENLABS_API_KEY|xi-api-key)[[:space:]]*[:=][[:space:]]*[A-Za-z0-9_-]{16,})'
while IFS= read -r file; do
  if grep -n -E "$SECRET_PATTERN" "$file"; then
    fail "secret-shaped value found in public package files"
  fi
done <<EOF
$TEXT_FILES
EOF

printf '%s\n' "Repository contract checks passed."

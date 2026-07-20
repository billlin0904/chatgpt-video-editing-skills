# Setup runbook

Use this runbook only after the setup Skill has inspected the machine and the
user has approved the listed mutations. Re-read the upstream documentation at
execution time because install instructions can change.

## 1. Inspect and propose

Check both stable locations before acting:

```sh
for repo in "$HOME/Developer/video-use" "$HOME/Developer/hyperframes"; do
  if [ -d "$repo/.git" ]; then
    git -C "$repo" remote -v
    git -C "$repo" status --short
  fi
done
command -v git uv ffmpeg ffprobe python3 node npm bun
```

For every existing repository, record its remote and branch. A non-empty
`git status --short` is a hard stop: do not pull, reset, reclone, modify, or
install into that repository. Explain what was found and ask the user to clean
it up or choose a separate, explicitly approved repair action.

Before mutation, show an approval checklist tailored to what is missing:

- clone or update the source repositories;
- install Python, Node, FFmpeg, or package dependencies;
- download a large dependency or full media baseline;
- create/change a symlink or register an agent Skill;
- create or tighten the credential file.

Wait for a clear approval that covers the proposed changes. Do not treat a
request to “set it up” as approval after discovery reveals extra changes.

## 2. Install or repair video-use

The official source is `https://github.com/browser-use/video-use.git`. Keep the
whole repository at `~/Developer/video-use`; registering only a copied
`SKILL.md` is insufficient because its helpers are part of the workflow.

For a missing, approved checkout:

```sh
git clone https://github.com/browser-use/video-use.git "$HOME/Developer/video-use"
cd "$HOME/Developer/video-use"
uv sync
```

Use the repository's current `install.md` and lockfile/package metadata at the
checked-out revision. If it directs a different supported installer, explain
that change and get approval before using it. Install FFmpeg only if `ffmpeg`
and `ffprobe` are absent; it is required by the workflow. Optional online-source
tools are separate and need their own approval.

Register the **entire** repository with the active agent's Skills directory;
for example, the official paths use a symlink such as:

```sh
ln -sfn "$HOME/Developer/video-use" "$HOME/.codex/skills/video-use"
```

Adapt the target to the current agent only after showing the exact link change.
Do not replace an existing different target without explicit approval.

## 3. Install optional HyperFrames source and Skills

Only offer this when the user needs HTML/CSS/GSAP animation or asks for it.
Use `https://github.com/heygen-com/hyperframes.git` at
`~/Developer/hyperframes`. Default to a source-only checkout so LFS media
baselines are not downloaded:

```sh
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/heygen-com/hyperframes.git "$HOME/Developer/hyperframes"
cd "$HOME/Developer/hyperframes"
bun install --frozen-lockfile
```

Honor the checkout's current lockfile and documented package manager. The
current upstream source uses `bun.lock`; if that changes, stop and follow the
then-current project documentation after approval. A full LFS baseline or any
large download requires separate explicit approval.

Install the upstream Agent Skills with the current full-depth command:

```sh
npx skills add heygen-com/hyperframes --full-depth
```

This interactive command defaults to the Core Skills selection. Do not add
`--all` unless the user explicitly approves installing every available skill.
For any local `npx` verification on this machine, isolate npm's cache rather
than changing cache ownership:

```sh
npm_config_cache=/private/tmp/hyperframes-npx-cache npx --yes hyperframes --help
```

## 4. Local, no-cost verification

After approved changes, verify only local state:

```sh
git -C "$HOME/Developer/video-use" remote get-url origin
test -d "$HOME/Developer/video-use/helpers"
command -v ffmpeg ffprobe
git -C "$HOME/Developer/hyperframes" remote get-url origin
test -f "$HOME/Developer/hyperframes/bun.lock"
```

Then use the checks in [security and verification](security-and-verification.md).
Do not pass media to any API, invoke transcription, create `edit/`, render, or
claim readiness based only on planned commands.

# Setup runbook

Use this runbook only after the setup Skill has inspected the machine and the
user has approved the listed mutations. Re-read the upstream documentation at
execution time because install instructions can change.

## 1. Inspect and propose

Use exact official HTTPS origins. Do not accept a fork, a similarly named
repository, a missing `origin`, or another transport form, and never rewrite a
remote automatically:

- video-use: `https://github.com/browser-use/video-use.git`
- HyperFrames: `https://github.com/heygen-com/hyperframes.git`

Check the required video-use location before acting. Check HyperFrames only if
the user explicitly requested or approved it. Do not inspect only for a `.git`
directory: in a linked worktree, `.git` is a file. The following preflight
recognizes both normal checkouts and linked worktrees, and rejects any existing
path that is not the expected clean repository:

```sh
inspect_repo() {
  repo=$1
  expected_origin=$2

  if [ ! -e "$repo" ] && [ ! -L "$repo" ]; then
    printf '%s\n' "missing repository: $repo"
    return 2
  fi

  inside=$(git -C "$repo" rev-parse --is-inside-work-tree 2>/dev/null) || {
    printf '%s\n' "STOP: existing path is not a Git worktree: $repo" >&2
    return 1
  }
  [ "$inside" = true ] || {
    printf '%s\n' "STOP: existing path is not inside a Git worktree: $repo" >&2
    return 1
  }

  commit=$(git -C "$repo" rev-parse --verify HEAD) || return 1
  branch=$(git -C "$repo" branch --show-current) || return 1
  [ -n "$branch" ] || branch="(detached at $commit)"
  actual_origin=$(git -C "$repo" remote get-url origin) || {
    printf '%s\n' "STOP: origin is missing: $repo" >&2
    return 1
  }
  [ "$actual_origin" = "$expected_origin" ] || {
    printf '%s\n' "STOP: unexpected origin for $repo: $actual_origin" >&2
    return 1
  }
  status=$(git -C "$repo" status --short) || return 1
  printf '%s\n' "repo=$repo" "origin=$actual_origin" \
    "branch=$branch" "commit=$commit" "status=${status:-clean}"
  [ -z "$status" ] || {
    printf '%s\n' "STOP: repository is dirty: $repo" >&2
    return 1
  }
}

video_use_origin=https://github.com/browser-use/video-use.git
inspect_repo "$HOME/Developer/video-use" "$video_use_origin" || {
  result=$?
  [ "$result" -eq 2 ] || exit 1
}
command -v git uv ffmpeg ffprobe python3
```

The `2` result means the expected path is absent and may be proposed for an
approved clone. Every other failure is a hard stop. In particular, an existing
non-repository path, missing or mismatched origin, invalid commit, or non-empty
status must stop the workflow before pull, reset, reclone, dependency install,
or Skill registration. Report the evidence and ask the user to resolve it or
choose a separate safe action. A clean fork is still the wrong repository.

When HyperFrames is requested, also require a real Node.js major-version check
before proposing any HyperFrames mutation:

```sh
command -v node npm npx bun
node_major=$(node -p 'process.versions.node.split(".")[0]') || exit 1
case "$node_major" in *[!0-9]*|'') exit 1 ;; esac
[ "$node_major" -ge 22 ] || {
  printf '%s\n' "STOP: HyperFrames requires Node.js 22 or newer; found major $node_major" >&2
  exit 1
}

hyperframes_origin=https://github.com/heygen-com/hyperframes.git
inspect_repo "$HOME/Developer/hyperframes" "$hyperframes_origin" || {
  result=$?
  [ "$result" -eq 2 ] || exit 1
}
```

If Node is older than 22, stop and propose an isolated version-manager setup as
a separate approval item. Do not replace or change the system Node.js without
approval. If HyperFrames was not requested, do not run its Node or repository
checks; report `HyperFrames 未要求`.

Before mutation, show an approval checklist tailored to what is missing:

- clone or update the source repositories;
- install Python, Node, FFmpeg, or package dependencies;
- download a large dependency or full media baseline;
- create/change a symlink or register an agent Skill;
- create or tighten the credential file.

Wait for a clear approval that covers the proposed changes. Do not treat a
request to “set it up” as approval after discovery reveals extra changes. Git
state can drift while approval is pending, so rerun the applicable `inspect_repo`
preflight immediately before every dependency installation and Skill
registration. Stop if origin, branch/commit validity, or cleanliness changed.

## 2. Install or repair video-use

The official source is `https://github.com/browser-use/video-use.git`. Keep the
whole repository at `~/Developer/video-use`; registering only a copied
`SKILL.md` is insufficient because its helpers are part of the workflow.

For a missing, approved checkout:

```sh
git clone https://github.com/browser-use/video-use.git "$HOME/Developer/video-use"
inspect_repo "$HOME/Developer/video-use" "https://github.com/browser-use/video-use.git"
cd "$HOME/Developer/video-use"
uv sync
```

Use the repository's current `install.md` and lockfile/package metadata at the
checked-out revision. If it directs a different supported installer, explain
that change and get approval before using it. Install FFmpeg only if `ffmpeg`
and `ffprobe` are absent; it is required by the workflow. Optional online-source
tools are separate and need their own approval.

Register the **entire** repository with the active agent's Skills directory.
After approval, rerun `inspect_repo` and preflight the exact destination before
creating any link. For the Codex location, use the following pattern:

```sh
target="$HOME/Developer/video-use"
destination="$HOME/.codex/skills/video-use"
test -d "$(dirname "$destination")" || exit 1
if [ -L "$destination" ]; then
  readlink "$destination"
  test "$(readlink "$destination")" = "$target" || exit 1
elif [ -e "$destination" ]; then
  exit 1
else
  ln -s "$target" "$destination"
fi
```

Report the `readlink` result for an existing symlink. Accept it only when it is
the exact intended target; otherwise stop. If any real file or directory exists
at the destination, stop. Create only a plain symlink at a confirmed absent
destination after approval—never replace, nest, or retarget an existing link.
Adapt the target to the current agent only after showing the exact link change.

## 3. Install optional HyperFrames source and Skills

Only offer this when the user needs HTML/CSS/GSAP animation or asks for it.
Use `https://github.com/heygen-com/hyperframes.git` at
`~/Developer/hyperframes`. Default to a source-only checkout so LFS media
baselines are not downloaded:

```sh
node_major=$(node -p 'process.versions.node.split(".")[0]') || exit 1
case "$node_major" in *[!0-9]*|'') exit 1 ;; esac
[ "$node_major" -ge 22 ] || exit 1
GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/heygen-com/hyperframes.git "$HOME/Developer/hyperframes"
inspect_repo "$HOME/Developer/hyperframes" "https://github.com/heygen-com/hyperframes.git"
cd "$HOME/Developer/hyperframes"
bun install --frozen-lockfile
```

Honor the checkout's current lockfile and documented package manager. The
current upstream source uses `bun.lock`; if that changes, stop and follow the
then-current project documentation after approval. A full LFS baseline or any
large download requires separate explicit approval.

In an attended interactive terminal, open the full-depth picker:

```sh
npx skills add heygen-com/hyperframes --full-depth
```

The picker opens with nothing selected. Explicitly tell the user to select the
**Core Skills** group; that is the recommended set. Do not run this picker from
an agent or other non-interactive environment because an unscoped
non-interactive install can select all 19 Skills.

For an agent or other non-interactive environment, install exactly the core set
with the upstream CLI:

```sh
npx hyperframes skills update
```

Rerun `inspect_repo` immediately before either Skills command. The Node.js 22+
check also applies before `bun install`, `npx`, or any HyperFrames Skill
registration.

Only after the user explicitly approves installing all 19 Skills may you run:

```sh
npx skills add heygen-com/hyperframes --all --full-depth
```

For any local `npx` verification on this machine, isolate npm's cache rather
than changing cache ownership:

```sh
npm_config_cache=/private/tmp/hyperframes-npx-cache npx --yes hyperframes --help
```

## 4. Local, no-cost verification

After approved changes, verify the required video-use state locally:

```sh
inspect_repo "$HOME/Developer/video-use" "https://github.com/browser-use/video-use.git"
test -d "$HOME/Developer/video-use/helpers"
command -v ffmpeg ffprobe
```

Run the optional checks only when HyperFrames was explicitly approved **and**
installed in this setup:

```sh
if [ "$hyperframes_approved" = yes ] && [ "$hyperframes_installed" = yes ]; then
  inspect_repo "$HOME/Developer/hyperframes" "https://github.com/heygen-com/hyperframes.git"
  node_major=$(node -p 'process.versions.node.split(".")[0]') || exit 1
  case "$node_major" in *[!0-9]*|'') exit 1 ;; esac
  [ "$node_major" -ge 22 ] || exit 1
  test -f "$HOME/Developer/hyperframes/bun.lock"
  npx skills list
else
  printf '%s\n' 'HyperFrames 未要求；未執行 Repo、Node、bun.lock 或 Core Skills 檢查。'
fi
```

Set the two gate values from this setup session's explicit approval record and
observed install result; do not infer them merely because a path exists. A
skipped optional check is “not requested,” not a setup failure. Compare the
active agent's listed Skills with the exact Core Skills outcome recorded by the
approved `npx hyperframes skills update`; do not rerun an installer merely to
verify it.

Then use the checks in [security and verification](security-and-verification.md).
Do not pass media to any API, invoke transcription, create `edit/`, render, or
claim readiness based only on planned commands.

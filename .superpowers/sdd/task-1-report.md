# Task 1 report: contract tests and eval scenarios

## RED evidence

Command:

```sh
sh tests/validate_repo.sh
```

Output and exit status:

```text
ERROR: missing required file: README.md
exit status: 1
```

This is the expected RED state: the validator stops at the first missing required public artifact instead of continuing into dependent checks.

## JSON validation

Command:

```sh
python3 -m json.tool evals/evals.json >/dev/null
```

Output and exit status:

```text
exit status: 0
```

## Files created

- `tests/validate_repo.sh` — POSIX-shell acceptance validator for required public artifacts, core security/editing phrases, forbidden dependency references, and secret-shaped values. The content scans are intentionally limited to public package roots; internal design, plan, test, and baseline material is excluded.
- `evals/evals.json` — ten behavioral regression scenarios: setup, editing, Premiere negative trigger, dirty repository, missing credential, cloud-upload consent, strategy gate, original preservation, optional HyperFrames, and no false completion.
- `evals/baseline.md` — the pre-Skill behavior baseline and known gaps.

## Self-review

- The validator uses POSIX shell syntax and fails clearly at the first missing file.
- It names every planned required Skill and reference artifact, the complete prompt, infographic, and license.
- It checks the public package content for the safety and editing contract, secret-shaped values, and forbidden dependency references without scanning internal documents that describe the negative constraint.
- `sh -n tests/validate_repo.sh` completed successfully.
- The RED command continues to exit 1 for the expected missing `README.md`; this is intentional until Tasks 2–4 provide the public artifacts.
- `evals/evals.json` is valid JSON.

## Concerns

- The repository is deliberately still RED because production Skills and public documentation are outside Task 1.
- Later tasks must retain the explicit English `approval` wording somewhere in the public package, alongside the required security and editing phrases, for the deterministic contract check to pass.

## Public-path scan fix evidence

A temporary complete-package fixture was created outside the repository with all required files and phrases plus a public `assets/metadata.txt` containing a forbidden dependency reference.

Before the fix, the fixture command below incorrectly passed because the validator only inspected an allowlist of `skills/`, `examples/`, and selected root files:

```sh
sh tests/validate_repo.sh
```

```text
Repository contract checks passed.
exit status: 0
```

The validator now traverses every public text-like file and explicitly prunes `.git`, `.superpowers`, `docs/superpowers`, `tests`, and `evals`. Binary files are ignored with `grep -I`.

After the fix, the same fixture command failed at the intended public-path violation:

```text
1:OpenMontage
ERROR: forbidden dependency reference found in public package files: OpenMontage
exit status: 1
```

The temporary fixture was removed after the check. The current repository was then rechecked with `sh -n tests/validate_repo.sh`, `sh tests/validate_repo.sh` (expected RED: missing `README.md`, exit 1), and `python3 -m json.tool evals/evals.json >/dev/null` (exit 0).

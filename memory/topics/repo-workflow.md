# Repo Workflow

Stable branch and remote expectations for this `gridfinity-rebuilt-openscad` clone.

## Remotes
- `origin` is the upstream library repo: `kennetek/gridfinity-rebuilt-openscad`.
- `fork` is Arthur's writable fork: `tbharthur/gridfinity-rebuilt-openscad`.

## Branching Baseline
- Local `main` tracks `fork/main`, not `origin/main`.
- Arthur's organizer work in this clone belongs on the fork instead of sitting as local-only commits ahead of upstream.
- When the repo already has a meaningful custom commit stack, pushing that stack directly to `fork/main` is preferred over inventing throwaway parking branches.

## Current Fork-Owned Baseline
- Commit `7dbfe30` (`feat: add remote, tissue, and tray organizers`) is the baseline for the custom organizer stack.
- That commit adds `remote-holder.scad`, `tissue-box-holder.scad`, and `open-tray-4x5.scad`.

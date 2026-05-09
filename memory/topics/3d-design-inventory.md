# 3D Design Inventory (gridfinity-rebuilt-openscad)

Per-repo index of the SCAD designs Arthur has commissioned in this fork: which file, which branch, current state, and which per-piece topic file holds the design detail.

> **Per-piece detail lives in sibling topic files** in this same `memory/topics/` directory. This file is the **single-look index** so a render request like "send PNGs of everything" doesn't require re-reading every per-piece doc.

## Inventory (as of 2026-05-09)

| # | Piece | File | Branch | Status | Detail |
|---|-------|------|--------|--------|--------|
| 1 | Remote holder | `remote-holder.scad` | `main` (tracked, commit `7dbfe30`) | v5 with raised lip; printed | `~/Dev/assistant/memory/topics/gridfinity-couch-shelf.md` (Remote Holder section) |
| 2 | Tissue box holder | `tissue-box-holder.scad` | `main` (tracked, commit `7dbfe30`) | 114×115mm cutout, 0.5mm tight tolerance; needs test print | `~/Dev/assistant/memory/topics/gridfinity-couch-shelf.md` (Tissue Box Holder section) |
| 3 | Open tray 4×5 | `open-tray-4x5.scad` | `main` (tracked, commit `7dbfe30`) | Printed Feb 15 (brim, second pass) | `custom-trays.md` |
| 4 | Open tray 4×1 | `tray-4x1.scad` | local working-tree only (untracked even on `fork/main`; documented in `memory/recent/2026-04-03.md`) | Printed Apr 3; STL `tray-4x1.stl` (961 KB) | `custom-trays.md` |
| 5 | Open tray 3×1 | `tray-3x1.scad` | local working-tree only (untracked even on `fork/main`; documented in `memory/recent/2026-04-03.md`) | Printed Apr 3; STL `tray-3x1.stl` (854 KB) | `custom-trays.md` |
| 6 | Magazine holder 6×2 | `magazine-holder.scad` | `main` | Long shelf piece; staggered front/back slots | `~/Dev/assistant/memory/topics/gridfinity-couch-shelf.md` (no dedicated per-repo topic yet) |
| 7 | W magazine stand 6×4 | `.claude/worktrees/w-mag-codex/w-magazine-stand.scad` (active source on `w-magazine-stand-codex` worktree) | `w-magazine-stand-codex` (1 commit; never merged into `main`) | Apr 2 Codex variant, post-bake-off vs `w-magazine-stand-claude`; printed Apr 2; final STL `~/Desktop/w-magazine-stand-codex-round2.stl` | `w-magazine-stand.md` |
| 8 | Sponge tray (non-Gridfinity, sink-mount) | `sponge-tray.scad` (early parametric on disk, untracked); adopted printable is the STL-level boolean variant | local working-tree only (sponge-tray topic + `memory/recent/2026-04-05.md` document the design) | Adopted printable `~/Desktop/sponge_tray_svampig_31mm.stl` (Apr 5, OpenSCAD STL boolean) and superseded `~/Desktop/svampig_tray_31mm_claude_uniform.stl` (Apr 17, uniform-scale resize per Svampig case study in assistant `3d-printing.md`) | `sponge-tray.md` |

## Repo plumbing

See `repo-workflow.md` for the canonical statement. Short version: `origin` is upstream `kennetek/...` (read-only); `fork` is Arthur's writable `tbharthur/...`; **memory commits push to `fork main`, not `origin`**.

## Render & send pattern (Discord sessions)

Per the assistant `3d-printing.md` topic, the installed OpenSCAD MCP server returns ordinary base64 / `file_path` payloads, not typed inline image content blocks. In Discord sessions:

```bash
/opt/homebrew/bin/openscad model.scad -o /absolute/path/output.png \
  --viewall --autocenter --camera=0,0,0,55,0,335,0 --imgsize=1200,900
~/Dev/assistant/tools/dc-send-file.sh /absolute/path/output.png --caption "OpenSCAD render"
```

Required after `discord-claude-bridge` commit `9cb2102` — image-looking paths in tool output and shell stdout no longer auto-display.

## Cross-repo references

The authoritative design narrative for this work — printer, AMS slots, slicer presets, slicer tips, modify-existing-STL playbook, OpenSCAD render tooling — lives in the assistant repo:

- `~/Dev/assistant/memory/topics/3d-printing.md`
- `~/Dev/assistant/memory/topics/gridfinity-couch-shelf.md`

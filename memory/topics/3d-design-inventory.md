# 3D Design Inventory (gridfinity-rebuilt-openscad)

Per-repo snapshot of the SCAD designs Arthur has commissioned in this fork: which file each one lives on, which branch, and current state. The full design narrative (printer model, AMS slots, slicer presets, render pattern, modify-existing-STL playbook) lives in the assistant repo — see "Cross-repo references" below.

## Inventory (as of 2026-05-09)

| # | Piece | File / Branch | Footprint | Status |
|---|-------|---------------|-----------|--------|
| 1 | Remote holder | `remote-holder.scad` (`main`) | 5×1 (210×42mm) | v5 with raised lip; printed |
| 2 | Tissue box holder | `tissue-box-holder.scad` (`main`) | 3×3 (126×126mm) | 114×115mm cutout, 0.5mm tight tolerance; needs test print |
| 3 | Open tray 4×5 | `open-tray-4x5.scad` (`main`) | 4×5 (168×210mm) | Printed Feb 15 (brim, second pass after raft removal trouble) |
| 4 | Open tray 4×1 | `tray-4x1.scad` (untracked Apr 3) | 4×1 (168×42mm) | Printed; STL `tray-4x1.stl` (961 KB) |
| 5 | Open tray 3×1 | `tray-3x1.scad` (untracked Apr 3) | 3×1 (126×42mm) | Printed; STL `tray-3x1.stl` (854 KB) |
| 6 | Magazine holder 6×2 | `magazine-holder.scad` (`main`) | 6×2 | Long shelf piece; staggered front/back slots |
| 7 | W magazine stand 6×4 | `w-magazine-stand-codex` branch (1 commit; never merged) | 6×4 (252×168mm) | Apr 2 Codex variant (post-bake-off vs `w-magazine-stand-claude`); printed Apr 2; final STL `~/Desktop/w-magazine-stand-codex-round2.stl` |
| 8 | Sponge tray (non-Gridfinity, sink-mount) | `sponge-tray.scad` (early parametric, untracked) | n/a | Adopted printable: `~/Desktop/svampig_tray_31mm_claude_uniform.stl` (uniform-scale resize, Apr 17 — see Svampig case study in assistant `3d-printing.md`) |

## Repo plumbing

- `origin` → `https://github.com/kennetek/gridfinity-rebuilt-openscad.git` (upstream fork source — read-only for Arthur)
- `fork` → `https://github.com/tbharthur/gridfinity-rebuilt-openscad.git` (Arthur's fork — **memory commits push here, not to `origin`**)
- Active local branches: `main`, `w-magazine-stand-claude`, `w-magazine-stand-codex`
- The two `w-magazine-stand-*` branches are the Apr 1–2 bake-off worktrees (Claude vs Codex, isolated under `.claude/worktrees/`); the Codex branch is the chosen printable.

## Render & send pattern (Discord sessions)

Per the assistant `3d-printing.md` topic, the installed OpenSCAD MCP server returns ordinary base64 / `file_path` payloads, not typed inline image content blocks. In Discord sessions:

```bash
/opt/homebrew/bin/openscad model.scad -o /absolute/path/output.png \
  --viewall --autocenter --camera=0,0,0,55,0,335,0 --imgsize=1200,900
~/Dev/assistant/tools/dc-send-file.sh /absolute/path/output.png --caption "OpenSCAD render"
```

Required after `discord-claude-bridge` commit `9cb2102` — image-looking paths in tool output and shell stdout no longer auto-display.

## Cross-repo references

The authoritative design narrative for this work lives in the assistant repo:

- `~/Dev/assistant/memory/topics/3d-printing.md` — Bambu A1 printer details, AMS filament slots, OrcaSlicer CLI patches, slicer tips (variable layer height, multicolor, ironing, warping, brim-vs-raft), MCP server setup, modify-existing-STL playbook (uniform-scale vs targeted-radial-expansion lesson from Svampig Apr 17), Bambu Studio Eufy-camera integration brainstorm
- `~/Dev/assistant/memory/topics/gridfinity-couch-shelf.md` — base layout (4×20 grid), per-piece OpenSCAD design notes, generic box-holder pattern, sponge-tray + dishcloth-arm Apr 17 case study, OpenSCAD render tooling, USDZ export pattern

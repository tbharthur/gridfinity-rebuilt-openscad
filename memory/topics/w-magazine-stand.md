# W Magazine Stand

Gridfinity-integrated W-profile magazine/newspaper stand inspired by the R&B Shelter magazine rack.

## Specifications

- **Footprint:** 6×4 Gridfinity grid (252×168mm)
- **Height:** ~227mm
- **Platform:** 10mm (7mm base_h + 3mm floor_h)
- **Profile:** W cross-section — center spine (4mm thick, 217mm tall) + two angled outer walls (12° lean)
- **Pockets:** 2 outward-facing pockets, ~3-5 magazines each
- **Top edges:** Bullnose (rounded), no raised lip
- **Print orientation:** On its side (252mm width goes vertical)
- **Build volume constraint:** Bambu A1 (256×256×256mm)

## Bake-off (Apr 1-2)

Claude and Codex each built the stand independently in isolated worktrees.

| Version | Branch | Commits | Notes |
|---------|--------|---------|-------|
| Claude | `w-magazine-stand-claude` | 4 | Corrected inset from 18mm to ~38mm for 12° angle |
| Codex | `w-magazine-stand-codex` | 1 | Built via Codex plugin after CLI stalled |

Both manifold, both 252×168×~227mm. Arthur chose the Codex version.

## Refinement (Apr 2)

Two smoothing passes applied to the Codex worktree model:

### Pass 1: Inner valley smoothing
Replaced flat shoulder-and-arc valley polygon with a cubic blend starting tangent to the sloped wall and landing tangent to the center spine. Eliminates the abrupt wall-to-bottom transition visible in side view.

### Pass 2: Broader rounding
Outer walls reshaped to ease out of the base and taper into a fuller top cap. Center spine and inner-valley blend preserved. Applied after Arthur reviewed and approved pass 1.

Both passes verified with focused geometry tests and manifold STL export.

## Files

- **Source (active):** `w-magazine-stand.scad`
- **Tests:** `tests/test_w_magazine_stand.py`
- **STL (final):** `~/Desktop/w-magazine-stand-codex-round2.stl`
- **Spec:** `docs/superpowers/specs/2026-04-01-gridfinity-w-magazine-stand-design.md`
- **Plan:** `docs/superpowers/plans/2026-04-01-gridfinity-w-magazine-stand.md`

## Status

Approved and printing (Apr 2). The selected Codex model was merged into `main`
and both bake-off worktrees were removed on Aug 4.

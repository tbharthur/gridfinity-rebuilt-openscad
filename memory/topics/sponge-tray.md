# Sponge Tray — Sink-Mounted Holder

Sink-mounted sponge holder that slides over a fixture (faucet base, divider) via a cylindrical sleeve, with a sponge tray extending off one side.

## Arthur's Sink Fixture

- **Required cylinder bore diameter:** 31mm (internal)

## Source Files

| File | Description |
|------|-------------|
| `sponge_tray_narrow_31mm.stl` | Original narrow tray variant with 31mm bore (correct diameter, tray too narrow) |
| `vertical_sponge_tray_for_ikea_svampig.stl` | IKEA Svampig variant — wider tray with honeycomb drainage walls, 30mm bore (too narrow) |
| `sponge_tray_svampig_31mm.stl` | **Final version** — svampig wider tray + honeycomb, bore widened to 31mm. On `~/Desktop/`. |
| `sponge-tray.scad` | Initial parametric recreation (WRONG — simple rectangular tray, not the actual cylinder+tray design) |

## Design Details

- Cylindrical sleeve slides over sink fixture
- Sponge tray extends off one side of the sleeve
- Svampig variant has wider tray and hexagonal/honeycomb drainage cutouts in walls
- Narrow variant has narrower tray with different drainage pattern

## Modification Method

STL-level boolean operation in OpenSCAD:
1. Import svampig STL
2. Identify cylinder axis (Y-axis, centered at X=0, Z=0)
3. Subtract a 31mm diameter cylinder to widen the bore from 30mm to 31mm
4. Export modified STL

This was an STL modification, not a parametric rebuild — the geometry is too complex for quick parametric recreation.

# Custom Open Trays

Open tray designs derived from the tissue box holder pattern. All use the shared Gridfinity box holder construction (see `gridfinity-couch-shelf.md` in the assistant repo `memory/topics/` for the generic pattern).

## Variants

| Tray | File | Grid | Footprint | Interior | Foot Clips |
|------|------|------|-----------|----------|------------|
| 4x5 | `open-tray-4x5.scad` | 4x5 | 168x210mm | bowl-shaped | 20 |
| 4x1 | `tray-4x1.scad` | 4x1 | 168x42mm | 157x31mm | 4 |
| 3x1 | `tray-3x1.scad` | 3x1 | 126x42mm | 115x31mm | 3 |

## Shared Parameters (4x1 and 3x1)

```
wall_h = 42, base_h = 7, floor_h = 3
lip_h = 3.5, lip_inset = 3, lip_fillet = 2
wall_thickness = 5.5, corner_r = 1.5
```

The 4x5 differs: `wall_h = 29`, 8mm minkowski sphere for bowl shape, 6mm wall thickness.

## Design Heritage

All trays follow the tissue box holder construction:
- Gridfinity base profile with N foot clips (1 per grid square along X)
- Minkowski lip: rounded_rect extruded to lip_h, then minkowski with sphere(lip_fillet)
- Solid floor sealing gaps between base units
- Outer body extends floor_h below base_h; interior cutout starts at base_h

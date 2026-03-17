// Gridfinity 3x3 Tissue Box Holder
// Holds a 113mm × 114mm × 117mm tissue box
// Matches remote holder style: same wall height, lip, floor, curvature
//
// Interior: 114mm × 115mm (0.5mm tolerance per side)
// Walls: ~5.5–6mm thick

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>
use <src/helpers/generic-helpers.scad>

$fa = 4;
$fs = 0.25;

// === GRID PARAMETERS ===
grid_x = 3;
grid_y = 3;
unit = 42;
corner_r = 1.5;                 // internal corner radius
base_h = 7;
wall_h = 42;                    // wall height above base
lip_h = 3.5;                    // raised lip height around perimeter
lip_inset = 3;                  // how far inset the recess is from outer edge
lip_fillet = 2;                 // radius of the curve from lip down to recessed surface
floor_h = 3;                    // solid floor above gridfinity base

// === BOX DIMENSIONS ===
box_w = 113;                    // tissue box width
box_d = 114;                    // tissue box depth
tol = 0.5;                      // tolerance per side (tight fit)

// Interior cutout dimensions
cutout_w = box_w + 2 * tol;    // 114mm
cutout_d = box_d + 2 * tol;    // 115mm

// === OUTER DIMENSIONS ===
outer_x = grid_x * unit;       // 126mm
outer_y = grid_y * unit;       // 126mm
total_h = base_h + wall_h;

// Wall thicknesses (for reference)
wall_x = (outer_x - cutout_w) / 2;  // ~6mm
wall_y_thick = (outer_y - cutout_d) / 2;  // ~5.5mm

// === GRIDFINITY BASE ===
module gridfinity_base_single() {
    base_bottom = 35.6;
    base_top = 41.5;
    r_bottom = 0.8;
    r_top = BASE_TOP_RADIUS;

    hull() {
        translate([0, 0, 0])
        linear_extrude(0.01)
        offset(r = r_bottom)
        square(base_bottom - 2*r_bottom, center=true);

        translate([0, 0, 0.8])
        linear_extrude(0.01)
        offset(r = r_bottom + 0.8)
        square(base_bottom - 2*r_bottom, center=true);

        translate([0, 0, 1.8])
        linear_extrude(0.01)
        offset(r = r_bottom + 0.8)
        square(base_bottom - 2*r_bottom, center=true);

        translate([0, 0, 2.6])
        linear_extrude(0.01)
        offset(r = r_top)
        square(base_top - 2*r_top, center=true);

        translate([0, 0, base_h])
        linear_extrude(0.01)
        offset(r = r_top)
        square(base_top - 2*r_top, center=true);
    }
}

module gridfinity_bases() {
    for (ix = [0 : grid_x - 1])
    for (iy = [0 : grid_y - 1])
    translate([ix * unit + unit/2, iy * unit + unit/2, 0])
    gridfinity_base_single();
}

// === ROUNDED RECTANGLE HELPER ===
module rounded_rect(size, r) {
    offset(r = r)
    square([size.x - 2*r, size.y - 2*r], center = true);
}

// === MAIN BIN ===
module tissue_box_holder() {
    gridfinity_bases();

    difference() {
        // Solid outer body — extends down floor_h below base_h to seal gaps
        // Use BASE_TOP_RADIUS to match Gridfinity base profile corners
        translate([outer_x/2, outer_y/2, base_h - floor_h])
        linear_extrude(wall_h + floor_h)
        rounded_rect([outer_x, outer_y], BASE_TOP_RADIUS);

        // --- TOP RECESS (creates raised lip border) ---
        recess_x = outer_x - 2 * lip_inset;
        recess_y = outer_y - 2 * lip_inset;
        translate([outer_x/2, outer_y/2, base_h + wall_h - lip_h])
        minkowski() {
            linear_extrude(lip_h + 1)
            rounded_rect([recess_x - 2*lip_fillet, recess_y - 2*lip_fillet], corner_r);
            sphere(r = lip_fillet, $fn = 32);
        }

        // --- BOX CUTOUT (centered, starts at base_h for solid floor) ---
        translate([outer_x/2, outer_y/2, base_h])
        linear_extrude(wall_h + 1)
        offset(r = corner_r)
        square([cutout_w - 2*corner_r, cutout_d - 2*corner_r], center = true);
    }
}

tissue_box_holder();

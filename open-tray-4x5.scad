// Gridfinity 4x5 Open Tray
// Same design language as remote holder and tissue box holder
// wall_h = 29 (13mm shorter than the 42mm standard)
//
// Outer: 168mm × 210mm
// Interior: full open tray (walls + lip border only)

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>
use <src/helpers/generic-helpers.scad>

$fa = 4;
$fs = 0.25;

// === GRID PARAMETERS ===
grid_x = 4;
grid_y = 5;
unit = 42;
corner_r = 1.5;                 // internal corner radius
base_h = 7;
wall_h = 29;                    // wall height above base (13mm shorter than standard 42mm)
lip_h = 3.5;                    // raised lip height around perimeter
lip_inset = 3;                  // how far inset the recess is from outer edge
lip_fillet = 2;                 // radius of the curve from lip down to recessed surface
floor_h = 3;                    // solid floor above gridfinity base
bowl_r = 8;                     // interior bowl radius (rounds floor-to-wall transition)

// === OUTER DIMENSIONS ===
outer_x = grid_x * unit;       // 168mm
outer_y = grid_y * unit;       // 210mm
total_h = base_h + wall_h;

// Interior cutout — must be smaller than the recess to create the stepped lip effect
// wall_t is total wall thickness from outer edge to interior
wall_t = 6;                                 // ~6mm walls (matches tissue box holder)
cutout_x = outer_x - 2 * wall_t;           // 156mm
cutout_y = outer_y - 2 * wall_t;           // 198mm

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

// === MAIN TRAY ===
module open_tray() {
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

        // --- INTERIOR CUTOUT (bowl-shaped with rounded floor-to-wall transition) ---
        // minkowski of a shorter rectangular extrusion + sphere gives rounded edges
        // The sphere rounds both the bottom edges and vertical corners
        translate([outer_x/2, outer_y/2, base_h + bowl_r])
        minkowski() {
            linear_extrude(wall_h - bowl_r + 1)
            offset(r = corner_r)
            square([cutout_x - 2*corner_r - 2*bowl_r, cutout_y - 2*corner_r - 2*bowl_r], center = true);
            sphere(r = bowl_r, $fn = 48);
        }
    }
}

open_tray();

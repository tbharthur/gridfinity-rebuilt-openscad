// Gridfinity 5x1 Remote Holder — Dedicated Slots
// Individual slots for each remote, standing upright
//
// Front row (thinner):
//   Apple TV 4K:  35mm wide × 9.2mm thick
//   Samsung TV:   37mm wide × 10.5mm thick
//
// Back row (thicker):
//   Sunshade RF:  44.1mm wide × 10.2mm thick
//   Blinds RF:    45.3mm wide × 11mm thick
//   Ceiling fan:  60.3mm wide × 17.6mm thick

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>
use <src/helpers/generic-helpers.scad>

$fa = 4;
$fs = 0.25;

// === GRID PARAMETERS ===
grid_x = 5;
grid_y = 1;
unit = 42;
corner_r = 1.5;                 // internal corner radius for slots
base_h = 7;
wall_h = 42;                    // wall height above base
lip_h = 3.5;                    // raised lip height around perimeter
lip_inset = 3;                  // how far inset the recess is from outer edge
lip_fillet = 2;                 // radius of the curve from lip down to recessed surface
floor_h = 3;                    // solid floor above gridfinity base (seals gaps between base units)

// === REMOTE DIMENSIONS (width, thickness) ===
// Adding 2mm tolerance to each dimension
tol = 2;

// Front row remotes (slot depth = thickness + tol)
apple_w  = 35 + tol;           // 37mm slot width
apple_t  = 9.2 + tol;          // 11.2mm slot depth
samsung_w = 37 + tol;          // 39mm slot width
samsung_t = 10.5 + tol;        // 12.5mm slot depth
front_depth = max(apple_t, samsung_t);  // 12.5mm — all front slots same depth

// Back row remotes
shade_w  = 44.1 + tol;         // 46.1mm slot width
shade_t  = 10.2 + tol;         // 12.2mm slot depth
blinds_w = 45.3 + tol;         // 47.3mm slot width
blinds_t = 11 + tol;           // 13mm slot depth
fan_w    = 60.3 + tol;         // 62.3mm slot width
fan_t    = 17.6 + tol;         // 19.6mm slot depth
back_depth = max(shade_t, blinds_t, fan_t);  // 19.6mm — all back slots same depth

// === WALL CALCULATIONS (Y axis) ===
// outer_y = front_wall + front_depth + divider_y + back_depth + back_wall
// 42 = wall_y + 12.5 + div_y + 19.6 + wall_y
// remaining_y = 42 - 12.5 - 19.6 = 9.9mm for 2 walls + 1 divider
remaining_y = unit - front_depth - back_depth;
wall_y = remaining_y / 3;      // ~3.3mm each
div_y = wall_y;

// === WALL CALCULATIONS (X axis) ===
outer_x = grid_x * unit;       // 210mm

// Back row slot widths (3 slots)
back_slots_total = shade_w + blinds_w + fan_w;  // ~155.7mm
// Remaining X for walls: 210 - 155.7 = 54.3mm for 4 dividers + 2 end walls = 6 walls
back_walls_x = (outer_x - back_slots_total) / 4;  // ~13.6mm between back slots (only 4: 2 ends + 2 dividers... wait)

// Actually: end_wall + slot1 + div + slot2 + div + slot3 + end_wall = outer_x
// So: 2*end_wall + 2*div + slots = outer_x
// Let's make end walls and dividers the same thickness
back_dividers = 4;  // 2 end walls + 2 internal dividers
back_wall_x = (outer_x - back_slots_total) / back_dividers;  // ~13.6mm

// Front row slot widths (2 slots) — center them to align nicely
front_slots_total = apple_w + samsung_w;  // 76mm
front_dividers = 3;  // 2 end walls + 1 internal divider
front_wall_x = (outer_x - front_slots_total) / front_dividers;  // ~44.7mm

// === OUTER DIMENSIONS ===
outer_y = unit;
total_h = base_h + wall_h;

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

// === SLOT CUTOUT ===
module slot(width, depth, height) {
    linear_extrude(height)
    offset(r = corner_r)
    square([width - 2*corner_r, depth - 2*corner_r], center = true);
}

// === MAIN BIN ===
module remote_holder() {
    gridfinity_bases();

    difference() {
        // Solid outer body — extends down floor_h below base_h to seal gaps between base units
        translate([outer_x/2, outer_y/2, base_h - floor_h])
        linear_extrude(wall_h + floor_h)
        rounded_rect([outer_x, outer_y], corner_r + wall_y);

        // --- TOP RECESS (creates raised lip border) ---
        // Cut a pocket from the top, inset from the outer edge
        // The pocket goes lip_h deep, with a filleted transition
        recess_x = outer_x - 2 * lip_inset;
        recess_y = outer_y - 2 * lip_inset;
        translate([outer_x/2, outer_y/2, base_h + wall_h - lip_h])
        minkowski() {
            linear_extrude(lip_h + 1)
            rounded_rect([recess_x - 2*lip_fillet, recess_y - 2*lip_fillet], corner_r);
            sphere(r = lip_fillet, $fn = 32);
        }

        // --- BACK ROW SLOTS (start at base_h, so floor_h of solid remains below) ---
        back_center_y = wall_y + front_depth + div_y + back_depth/2;

        // Shade slot (left)
        shade_cx = back_wall_x + shade_w/2;
        translate([shade_cx, back_center_y, base_h])
        slot(shade_w, back_depth, wall_h + 1);

        // Fan slot (center — thickest remote)
        fan_cx = back_wall_x + shade_w + back_wall_x + fan_w/2;
        translate([fan_cx, back_center_y, base_h])
        slot(fan_w, back_depth, wall_h + 1);

        // Blinds slot (right)
        blinds_cx = back_wall_x + shade_w + back_wall_x + fan_w + back_wall_x + blinds_w/2;
        translate([blinds_cx, back_center_y, base_h])
        slot(blinds_w, back_depth, wall_h + 1);

        // --- FRONT ROW SLOTS (y = wall_y + front_depth/2) ---
        front_center_y = wall_y + front_depth/2;

        // Apple TV slot — align with left side
        apple_cx = front_wall_x + apple_w/2;
        translate([apple_cx, front_center_y, base_h])
        slot(apple_w, front_depth, wall_h + 1);

        // Samsung slot — align with right side
        samsung_cx = front_wall_x + apple_w + front_wall_x + samsung_w/2;
        translate([samsung_cx, front_center_y, base_h])
        slot(samsung_w, front_depth, wall_h + 1);
    }
}

remote_holder();

// Gridfinity 6x2 Magazine Holder — Staggered Slots
// Two slots front-to-back (couch → wall), staggered floors and wall tops
// Magazines stand upright, covers face couch, 8.5" width along shelf length
//
// Spec: docs/superpowers/specs/2026-03-14-gridfinity-magazine-holder-design.md

// Only standard.scad is needed (provides BASE_TOP_RADIUS).
include <src/core/standard.scad>

$fa = 4;
$fs = 0.25;

// === GRID PARAMETERS ===
grid_x = 6;
grid_y = 2;
unit = 42;
base_h = 7;

// === WALL PARAMETERS ===
front_wall_h = 150;             // front wall height above base (couch side)
back_wall_h = 175;              // back wall height above base (wall side), +25mm stagger
stagger = back_wall_h - front_wall_h;  // 25mm

// === DESIGN LANGUAGE (matches remote holder v5) ===
lip_h = 3.5;                    // raised lip height (recess within wall_h, not above)
lip_inset = 3;                  // recess inset from outer edge
lip_fillet = 2;                 // curve radius from lip to recessed interior
floor_h = 3;                    // solid floor above gridfinity base
corner_r = 1.5;                 // internal corner radius for slots

// === OUTER DIMENSIONS ===
outer_x = grid_x * unit;       // 252mm
outer_y = grid_y * unit;       // 84mm

// === SLOT LAYOUT (Y-axis cross-section) ===
// 5mm front wall + 34.5mm slot1 + 5mm divider + 34.5mm slot2 + 5mm back wall = 84mm
wall_t = 5;                     // front wall, back wall, and divider thickness
slot_depth = (outer_y - 3 * wall_t) / 2;  // 34.5mm each

// === SIDE WALLS (X-axis) ===
side_wall_t = 8;                // side wall thickness at each end
slot_length = outer_x - 2 * side_wall_t;  // 236mm internal

// === SLOT FLOOR HEIGHTS (above base_h) ===
slot1_floor = 0;                // front slot at base level
slot2_floor = stagger;          // back slot raised 25mm

// === SLOT Y POSITIONS (center of each slot) ===
slot1_cy = wall_t + slot_depth / 2;                          // 5 + 17.25 = 22.25mm
slot2_cy = wall_t + slot_depth + wall_t + slot_depth / 2;    // 5 + 34.5 + 5 + 17.25 = 61.75mm

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

// === STEPPED OUTER BODY ===
// Two blocks at different heights with a clean step at the divider.
// Front section (wall + slot1 + half divider) at front_wall_h.
// Back section (half divider + slot2 + wall) at back_wall_h.
module outer_body() {
    body_bottom = base_h - floor_h;  // Z=4mm
    step_y = wall_t + slot_depth + wall_t / 2;  // Y position of step (middle of divider)

    // Front section — lower
    translate([0, 0, body_bottom])
    cube([outer_x, step_y, front_wall_h + floor_h]);

    // Back section — taller
    translate([0, step_y, body_bottom])
    cube([outer_x, outer_y - step_y, back_wall_h + floor_h]);
}

// === MAIN ASSEMBLY ===
module magazine_holder() {
    gridfinity_bases();

    difference() {
        outer_body();

        // SLOT 1 (front) — floor at base_h
        // Use back_wall_h for height to guarantee full penetration through sloped body
        translate([outer_x/2, slot1_cy, base_h])
        slot(slot_length, slot_depth, back_wall_h + 1);

        // SLOT 2 (back) — floor at base_h + 25mm
        translate([outer_x/2, slot2_cy, base_h + slot2_floor])
        slot(slot_length, slot_depth, back_wall_h + 1);

        // LIP RECESS — two separate cuts for front and back sections
        // Front lip recess (at front_wall_h)
        translate([outer_x/2, outer_y/2, base_h + front_wall_h - lip_h])
        minkowski() {
            linear_extrude(lip_h + 1)
            rounded_rect([outer_x - 2*lip_inset - 2*lip_fillet,
                          outer_y - 2*lip_inset - 2*lip_fillet], corner_r);
            sphere(r = lip_fillet, $fn = 32);
        }

        // Back lip recess (at back_wall_h)
        translate([outer_x/2, outer_y/2, base_h + back_wall_h - lip_h])
        minkowski() {
            linear_extrude(lip_h + 1)
            rounded_rect([outer_x - 2*lip_inset - 2*lip_fillet,
                          outer_y - 2*lip_inset - 2*lip_fillet], corner_r);
            sphere(r = lip_fillet, $fn = 32);
        }
    }
}

magazine_holder();

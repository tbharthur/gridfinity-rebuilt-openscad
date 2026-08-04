// Gridfinity 3x1 Open Tray
include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>
use <src/helpers/generic-helpers.scad>

$fa = 4;
$fs = 0.25;

grid_x = 3;
grid_y = 1;
unit = 42;
corner_r = 1.5;
base_h = 7;
wall_h = 42;
lip_h = 3.5;
lip_inset = 3;
lip_fillet = 2;
floor_h = 3;
wall_thickness = 5.5;

outer_x = grid_x * unit;
outer_y = grid_y * unit;
cutout_w = outer_x - 2 * wall_thickness;
cutout_d = outer_y - 2 * wall_thickness;
total_h = base_h + wall_h;

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

module rounded_rect(size, r) {
    offset(r = r)
    square([size.x - 2*r, size.y - 2*r], center = true);
}

module gridfinity_tray() {
    gridfinity_bases();

    difference() {
        translate([outer_x/2, outer_y/2, base_h - floor_h])
        linear_extrude(wall_h + floor_h)
        rounded_rect([outer_x, outer_y], BASE_TOP_RADIUS);

        recess_x = outer_x - 2 * lip_inset;
        recess_y = outer_y - 2 * lip_inset;
        translate([outer_x/2, outer_y/2, base_h + wall_h - lip_h])
        minkowski() {
            linear_extrude(lip_h + 1)
            rounded_rect([recess_x - 2*lip_fillet, recess_y - 2*lip_fillet], corner_r);
            sphere(r = lip_fillet, $fn = 32);
        }

        translate([outer_x/2, outer_y/2, base_h])
        linear_extrude(wall_h + 1)
        offset(r = corner_r)
        square([cutout_w - 2*corner_r, cutout_d - 2*corner_r], center = true);
    }
}

gridfinity_tray();

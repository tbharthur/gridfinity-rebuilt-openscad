include <src/core/standard.scad>

// Gridfinity W Magazine Stand
// Inspired by Room & Board's Shelter Magazine Stand.
// Print orientation: on its side, with the 252 mm width vertical.

$fa = 4;
$fs = 0.35;

grid_x = 6;
grid_y = 4;
unit = 42;

base_h = 7;
floor_h = 3;
platform_h = base_h + floor_h;

outer_x = grid_x * unit;
outer_y = grid_y * unit;

panel_t = 4;
bullnose_r = 2;
end_wall_t = 4;

center_spine_h = 217;
outer_wall_h = 178;
outer_wall_angle = 12;

center_y = outer_y / 2;
outer_wall_base_offset = 46;
front_outer_wall_y = outer_wall_base_offset;
back_outer_wall_y = outer_y - outer_wall_base_offset;

valley_r = 10;
member_span_x = outer_x - 2 * end_wall_t;

function front_outer_inner_y(z_local) =
    front_outer_wall_y
    + (panel_t / 2) * cos(outer_wall_angle)
    - z_local * sin(outer_wall_angle);

function back_outer_inner_y(z_local) =
    back_outer_wall_y
    - (panel_t / 2) * cos(outer_wall_angle)
    + z_local * sin(outer_wall_angle);

module gridfinity_base_single() {
    base_bottom = 35.6; base_top = 41.5; r_bottom = 0.8; r_top = BASE_TOP_RADIUS;
    hull() {
        translate([0,0,0]) linear_extrude(0.01) offset(r=r_bottom) square(base_bottom-2*r_bottom, center=true);
        translate([0,0,0.8]) linear_extrude(0.01) offset(r=r_bottom+0.8) square(base_bottom-2*r_bottom, center=true);
        translate([0,0,1.8]) linear_extrude(0.01) offset(r=r_bottom+0.8) square(base_bottom-2*r_bottom, center=true);
        translate([0,0,2.6]) linear_extrude(0.01) offset(r=r_top) square(base_top-2*r_top, center=true);
        translate([0,0,base_h]) linear_extrude(0.01) offset(r=r_top) square(base_top-2*r_top, center=true);
    }
}

module gridfinity_bases() {
    for (ix=[0:grid_x-1]) for (iy=[0:grid_y-1])
    translate([ix*unit+unit/2, iy*unit+unit/2, 0]) gridfinity_base_single();
}

module extrude_along_x(length) {
    multmatrix([
        [0, 0, 1, 0],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
    linear_extrude(height = length, convexity = 10)
    children();
}

module panel_profile_2d(height) {
    union() {
        translate([-panel_t / 2, 0])
        square([panel_t, height - bullnose_r]);

        translate([0, height - bullnose_r])
        circle(r = bullnose_r);
    }
}

module valley_floor_2d(y_left, y_right) {
    mid_y = (y_left + y_right) / 2;
    shoulder_z = platform_h + valley_r;

    polygon(points = concat(
        [
            [y_left, platform_h],
            [y_right, platform_h],
            [y_right, shoulder_z]
        ],
        [for (a = [0 : 6 : 180]) [mid_y + valley_r * cos(a), shoulder_z - valley_r * sin(a)]],
        [
            [y_left, shoulder_z]
        ]
    ));
}

module cross_section_2d() {
    front_valley_left = front_outer_inner_y(valley_r);
    front_valley_right = center_y - panel_t / 2;
    back_valley_left = center_y + panel_t / 2;
    back_valley_right = back_outer_inner_y(valley_r);

    union() {
        translate([center_y, platform_h])
        panel_profile_2d(center_spine_h);

        translate([front_outer_wall_y, platform_h])
        rotate(outer_wall_angle)
        panel_profile_2d(outer_wall_h);

        translate([back_outer_wall_y, platform_h])
        rotate(-outer_wall_angle)
        panel_profile_2d(outer_wall_h);

        valley_floor_2d(front_valley_left, front_valley_right);
        valley_floor_2d(back_valley_left, back_valley_right);
    }
}

module platform() {
    translate([0, 0, base_h])
    cube([outer_x, outer_y, floor_h]);
}

module w_members() {
    translate([end_wall_t, 0, 0])
    extrude_along_x(member_span_x)
    cross_section_2d();
}

module w_end_walls() {
    extrude_along_x(end_wall_t)
    cross_section_2d();

    translate([outer_x - end_wall_t, 0, 0])
    extrude_along_x(end_wall_t)
    cross_section_2d();
}

module magazine_stand() {
    union() {
        gridfinity_bases();
        platform();
        w_members();
        w_end_walls();
    }
}

magazine_stand();

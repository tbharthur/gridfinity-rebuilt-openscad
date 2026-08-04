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
outer_wall_bottom_half_w = 0.85;
outer_wall_bottom_blend_h = 26;
outer_wall_top_blend_h = 22;
outer_wall_top_shoulder_half_w = 1.15;
outer_wall_top_cap_r = 2.6;
outer_wall_profile_steps = 24;

center_spine_h = 217;
outer_wall_h = 178;
outer_wall_angle = 12;

center_y = outer_y / 2;
outer_wall_base_offset = 46;
front_outer_wall_y = outer_wall_base_offset;
back_outer_wall_y = outer_y - outer_wall_base_offset;

valley_r = 10;
member_span_x = outer_x - 2 * end_wall_t;

valley_outer_attach_z = 44;
valley_center_attach_z = 24;
valley_outer_tangent_len = 56;
valley_center_tangent_len = 34;
valley_hidden_inset = 1.2;
valley_curve_steps = 24;

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

function v2_add(a, b) = [a[0] + b[0], a[1] + b[1]];
function v2_scale(v, s) = [v[0] * s, v[1] * s];
function v2_length(v) = sqrt(v[0] * v[0] + v[1] * v[1]);
function clamp01(t) = min(1, max(0, t));
function smoothstep01(t) =
    let(u = clamp01(t))
    u * u * (3 - 2 * u);
function lerp(a, b, t) = a + (b - a) * t;
function v2_normalize(v) =
    let(length = v2_length(v))
    length == 0 ? [0, 0] : [v[0] / length, v[1] / length];
function cubic_bezier_2d(p0, p1, p2, p3, t) =
    v2_add(
        v2_add(
            v2_scale(p0, pow(1 - t, 3)),
            v2_scale(p1, 3 * pow(1 - t, 2) * t)
        ),
        v2_add(
            v2_scale(p2, 3 * (1 - t) * pow(t, 2)),
            v2_scale(p3, pow(t, 3))
        )
    );

module valley_blend_2d(
    outer_attach,
    center_attach,
    outer_hidden_base,
    center_hidden_base,
    outer_tangent
) {
    outer_control = v2_add(
        outer_attach,
        v2_scale(v2_normalize(outer_tangent), valley_outer_tangent_len)
    );
    center_control = [center_attach[0], center_attach[1] - valley_center_tangent_len];

    polygon(points = concat(
        [outer_hidden_base],
        [for (step = [0 : valley_curve_steps])
            cubic_bezier_2d(
                outer_attach,
                outer_control,
                center_control,
                center_attach,
                step / valley_curve_steps
            )
        ],
        [center_hidden_base]
    ));
}

function outer_wall_half_width(height, z_local) =
    let(
        top_cap_base_z = height - outer_wall_top_cap_r,
        bottom_t = smoothstep01(z_local / outer_wall_bottom_blend_h),
        top_t = smoothstep01(
            (z_local - (top_cap_base_z - outer_wall_top_blend_h)) / outer_wall_top_blend_h
        ),
        bottom_blend_w = lerp(outer_wall_bottom_half_w, panel_t / 2, bottom_t)
    )
    lerp(bottom_blend_w, outer_wall_top_shoulder_half_w, top_t);

module outer_wall_profile_2d(height) {
    top_cap_base_z = height - outer_wall_top_cap_r;

    union() {
        polygon(points = concat(
            [for (step = [0 : outer_wall_profile_steps])
                let(
                    z_local = top_cap_base_z * step / outer_wall_profile_steps,
                    half_w = outer_wall_half_width(height, z_local)
                )
                [-half_w, z_local]
            ],
            [for (step = [outer_wall_profile_steps : -1 : 0])
                let(
                    z_local = top_cap_base_z * step / outer_wall_profile_steps,
                    half_w = outer_wall_half_width(height, z_local)
                )
                [half_w, z_local]
            ]
        ));

        translate([0, top_cap_base_z])
        circle(r = outer_wall_top_cap_r);
    }
}

module cross_section_2d() {
    front_outer_attach = [
        front_outer_inner_y(valley_outer_attach_z),
        platform_h + valley_outer_attach_z
    ];
    front_center_attach = [
        center_y - panel_t / 2,
        platform_h + valley_center_attach_z
    ];
    front_outer_hidden_base = [
        front_outer_inner_y(0) - valley_hidden_inset,
        platform_h
    ];
    front_center_hidden_base = [
        center_y - panel_t / 2 + valley_hidden_inset,
        platform_h
    ];

    back_outer_attach = [
        back_outer_inner_y(valley_outer_attach_z),
        platform_h + valley_outer_attach_z
    ];
    back_center_attach = [
        center_y + panel_t / 2,
        platform_h + valley_center_attach_z
    ];
    back_center_hidden_base = [
        center_y + panel_t / 2 - valley_hidden_inset,
        platform_h
    ];
    back_outer_hidden_base = [
        back_outer_inner_y(0) + valley_hidden_inset,
        platform_h
    ];

    union() {
        translate([center_y, platform_h])
        panel_profile_2d(center_spine_h);

        translate([front_outer_wall_y, platform_h])
        rotate(outer_wall_angle)
        outer_wall_profile_2d(outer_wall_h);

        translate([back_outer_wall_y, platform_h])
        rotate(-outer_wall_angle)
        outer_wall_profile_2d(outer_wall_h);

        valley_blend_2d(
            front_outer_attach,
            front_center_attach,
            front_outer_hidden_base,
            front_center_hidden_base,
            [sin(outer_wall_angle), -1]
        );
        valley_blend_2d(
            back_outer_attach,
            back_center_attach,
            back_outer_hidden_base,
            back_center_hidden_base,
            [-sin(outer_wall_angle), -1]
        );
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

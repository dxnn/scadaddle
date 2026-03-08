// Starfruit - Pineapple Party model definition
// Parameters are parsed by the JS viewer; modules render in OpenSCAD

/* [Model] */
name = "starfruit";
body_type = "star";

/* [Body] */
body_height = 60;
body_radius = 18;
body_color = "0xc8d82e";
body_roughness = 0.35;
body_metalness = 0.05;

/* [Star] */
star_points = 5;

/* [Bumps] */
bump_type = "sphere";
bump_placement = "ridge";
bump_size = 1.5;
bump_rows = 8;
bumps_per_row = 5;
bump_color = "0x9aaa20";
bump_roughness = 0.5;
bump_metalness = 0.05;
bump_scale = [1.2, 1.2, 0.6];
bump_stagger = false;

/* [Crown] */
crown_y = 58;  // BH - 2
leaf_width = 4;
leaf_thickness = 1;
leaf_length = 10;
leaf_color = "0x7a8a18";
leaf_roughness = 0.5;
leaf_metalness = 0.0;
leaf_placement = "crown";
leaf_rings = [[1, 17, 40, 0.5, 0.5, 0.5]];

/* [Stem] */
has_stem = true;
stem_r1 = 0.8;
stem_r2 = 1.5;
stem_height = 5;
stem_color = "0x7a8a18";
stem_y = 60;  // crown_y + 2
stem_tilt = 0;

/* [Base] */
base_r1 = 6;
base_r2 = 8;

/* [Resolution] */
$fn = 64;

// =====================================================
// OpenSCAD rendering
// =====================================================
function star_radius(angle) =
    let(
        a5 = (angle % (360 / star_points)) / (360 / star_points),
        peak = cos(a5 * 360 - 180) * 0.5 + 0.5
    )
    body_radius * (0.55 + peak * 0.45);

module starfruit_body() {
    h_segs = 24;
    a_segs = star_points * 8;

    for (h = [0 : h_segs - 1]) {
        t0 = h / h_segs;
        t1 = (h + 1) / h_segs;
        taper0 = sin(t0 * 180) * 0.75 + 0.25;
        taper1 = sin(t1 * 180) * 0.75 + 0.25;

        for (a = [0 : a_segs - 1]) {
            a0 = a / a_segs * 360;
            a1 = (a + 1) / a_segs * 360;
            r00 = star_radius(a0) * taper0;
            r01 = star_radius(a1) * taper0;
            r10 = star_radius(a0) * taper1;
            r11 = star_radius(a1) * taper1;

            polyhedron(
                points = [
                    [r00*cos(a0), r00*sin(a0), t0*body_height],
                    [r01*cos(a1), r01*sin(a1), t0*body_height],
                    [r10*cos(a0), r10*sin(a0), t1*body_height],
                    [r11*cos(a1), r11*sin(a1), t1*body_height]
                ],
                faces = [[0,2,3,1]]
            );
        }
    }
}

module starfruit() {
    color([0.78, 0.85, 0.18])
    starfruit_body();

    // Stem
    color([0.48, 0.54, 0.09])
    translate([0, 0, body_height - 2])
    cylinder(h = stem_height, r1 = stem_r2, r2 = stem_r1, $fn = 8);

    // Base
    color([0.78, 0.85, 0.18])
    cylinder(h = 2, r1 = base_r2, r2 = base_r1, $fn = 32);
}

starfruit();

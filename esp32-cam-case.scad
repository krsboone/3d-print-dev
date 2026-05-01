// ============================================================
// ESP32-CAM Dev Case  —  FORIOT ESP32-CAM + MB V1541
// Measurements confirmed 2026-04-27
// ============================================================
//
// BOARD LAYOUT:
//   Both boards are 28x40mm and stack face-to-face via pin headers.
//   Case footprint: ~32.5 x 44.5mm.  Total height: ~22.0mm assembled.
//
// ORIENTATION IN CASE:
//   Camera end = "top" of case (Y = OUTER_L)
//   USB-C end  = "bottom" of case (Y = 0)
//   Board sits face-up; camera module faces up through the lid.
//
// CLOSURE — STEPPED WALL:
//   Tray: top STEP_H has inner pocket expanded by WALL_STEP (outer ledge).
//   Lid:  bottom STEP_H has outer wall thinned by (WALL_STEP + STEP_FIT).
//   The thin lid skirt slides into the wider tray opening and sits on the ledge.
//   No protruding snap features — nothing to break.
//
// PRINT:
//   Tray — open top up, no supports needed
//   Lid  — open rim down (outer camera face pointing up), no supports needed.
//          The 8x8mm camera pocket bridges cleanly at this size.
//
// EXPORT:
//   Set SHOW = "tray" or "lid", then Render (F6) → Export STL.

SHOW = "lid"; // "tray" | "lid" | "preview"
$fn = 48;


// ============================================================
// MEASUREMENTS  (all from caliper, 2026-04-27)
// ============================================================

PCB_W   = 28.0;  // Both boards: width
PCB_L   = 40.0;  // Both boards: length  (same footprint, vertical stack)
STACK_H = 24.0;  // Full assembly height: MB board bottom → lens tip

// Compact OV2640 camera module
CAM_MOD_W     =  8.0;  // Module body width
CAM_MOD_L     =  8.0;  // Module body length
CAM_MOD_THICK =  8.0;  // Module thickness: PCB surface → lens tip
CAM_LENS_D    =  9.0;  // Lens barrel outer diameter

// Lens center — from ESP32-CAM PCB edges
CAM_LENS_FROM_CAM_END =  9.0;  // from camera-end short edge
CAM_LENS_FROM_LEFT    = 14.0;  // from left long edge (centered on 28mm board)

// LED (status LED, near non-camera end)
LED_D            =  1.5;  // small pinhole — just enough to pass light through
LED_FROM_CAM_END = 28.0;  // from camera-end short edge (= 12mm from USB-C end)
LED_FROM_LEFT    = 24.0;  // from left long edge (4mm from right edge)

// SD card slot — opens at camera-end short wall
SD_SLOT_W       = 14.0;  // opening width (along board width axis)
SD_SLOT_H       =  2.0;  // opening height

// MB board bottom edge — USB-C, IO0, RST
USBC_FROM_LEFT =  14.0;  // connector center from left long edge
USBC_W         =   8.0;  // connector body width

IO0_FROM_LEFT  =   2.0;  // button center from left long edge
RST_FROM_LEFT  =  26.0;  // button center from left long edge
BTN_HOLE_D     =   5.0;  // access hole diameter
BTN_Y          =   9.0;  // hole center from USB-C end (7mm measured + 2mm shift)


// ============================================================
// DESIGN PARAMETERS
// ============================================================

WALL     = 2.0;   // Wall thickness
FLOOR_T  = 1.0;   // Outer face / tray floor thickness
CORNER_R = 3.0;   // Outer corner radius
FIT      = 0.25;  // Clearance per side — board in pocket
RAIL_H   = 0.8;   // PCB support rail height (lifts board off tray floor)
RAIL_W   = 1.5;   // PCB support rail width

// Stepped wall closure
STEP_H       = 3.0;  // Overlap zone height at tray top / lid bottom
WALL_STEP    = 1.0;  // Tray inner pocket expands by this much in step zone
STEP_FIT     = 0.2;  // Clearance per side — lid step sliding into tray step
CAM_PROTRUDE = 0.8;  // How far the lens barrel extends above the case top face

// Tray height trim — reduces tray below PCB surface level, exposing more of the assembly
TRAY_H_TRIM  = 3.0;  // mm to subtract from hardware-aligned tray height

// Step-zone snap détentes (cylindrical bumps on tray / recesses in lid)
SNAP_R        = 1.2;  // bump radius
SNAP_PROTRUDE = 0.3;  // bump height from tray inner step-zone face
SNAP_Y_INSET  = 5.0;  // from each short wall to snap centre (clear of button holes)

// Ventilation
VENT_D   = 2.2;
VENT_GAP = 5.0;

// Estimated MB board PCB thickness (standard, not measured)
MB_PCB_T = 1.6;


// ============================================================
// DERIVED  — do not edit below this line
// ============================================================

TOTAL_L  = PCB_L;                          // Both boards same footprint
INNER_W  = PCB_W  + FIT * 2;              // 28.5
INNER_L  = TOTAL_L + FIT * 2;             // 40.5
OUTER_W  = INNER_W + WALL * 2;            // 32.5
OUTER_L  = INNER_L + WALL * 2;            // 44.5

// Height from MB board bottom to ESP32-CAM top (PCB surface)
PCB_SURFACE_H = STACK_H - CAM_MOD_THICK;  // 24 - 8 = 16mm

// Tray: TRAY_H_TRIM shortens the tray below the PCB surface, exposing that much
// of the board assembly above the tray rim (captured by the lid instead).
TRAY_H = FLOOR_T + RAIL_H + PCB_SURFACE_H - TRAY_H_TRIM; // 1.0 + 0.8 + 16 - 3.0 = 14.8mm

// Lid: sized so lens protrudes CAM_PROTRUDE above case face.
// Case top = (TRAY_H - STEP_H) + LID_H; lens tip = Z_MB_FLOOR + STACK_H
// → LID_H = CAM_MOD_THICK + STEP_H - CAM_PROTRUDE = 8 + 3 - 0.8 = 10.2mm
LID_H  = CAM_MOD_THICK + STEP_H - CAM_PROTRUDE; // 10.2mm

// Total assembled height = (TRAY_H - STEP_H) + LID_H = 11.8 + 10.2 = 22.0mm
// Camera protrudes TRAY_H_TRIM + CAM_PROTRUDE = 3.8mm above case face.

// Key Z positions in tray coordinates (Z=0 = tray outer bottom)
Z_MB_FLOOR   = FLOOR_T + RAIL_H;                    // MB board bottom = 1.8mm
Z_ESP32_TOP  = FLOOR_T + RAIL_H + PCB_SURFACE_H;    // ESP32 PCB top   = 17.8mm (above TRAY_H)
Z_BTN_CENTER = Z_MB_FLOOR + 3.0;                    // shifted down 5mm from previous = 4.8mm

// SD slot Z in lid coords: position is set by board assembly geometry, not by TRAY_H_TRIM.
// Reference uses the full hardware-aligned tray height (no trim) so the slot stays at the
// same place within the lid regardless of how much the tray has been shortened.
// = (Z_MB_FLOOR + 17) − ((FLOOR_T + RAIL_H + PCB_SURFACE_H) − STEP_H) = 18.8 − 14.8 = 4.0mm
SD_LID_Z_BOTTOM = (Z_MB_FLOOR + 17.0) - ((FLOOR_T + RAIL_H + PCB_SURFACE_H) - STEP_H);


// ============================================================
// UTILITIES
// ============================================================

module rounded_rect(w, l, r) {
    offset(r=r) offset(r=-r) square([w, l]);
}

// Solid shell, open at top
module rounded_shell(w, l, h, r) {
    difference() {
        linear_extrude(h) rounded_rect(w, l, r);
        translate([WALL, WALL, FLOOR_T])
            linear_extrude(h)
                rounded_rect(w - WALL*2, l - WALL*2, max(r - WALL, 0.5));
    }
}


// ============================================================
// TRAY
// ============================================================
// Coordinate origin: outer bottom-left corner.
// Y=0: USB-C / non-camera end.    Y=OUTER_L: camera end.
// Z=0: tray bottom.               Z=TRAY_H: open top.
//
// Stepped wall: a notch STEP_H tall is cut from the inner side of the top
// STEP_H of wall, expanding the opening by WALL_STEP on each side.
// This creates a ledge the lid's thin skirt rests on.

module tray() {
    difference() {
        rounded_shell(OUTER_W, OUTER_L, TRAY_H, CORNER_R);

        // -- Stepped wall: expand inner pocket for top STEP_H --
        translate([WALL - WALL_STEP, WALL - WALL_STEP, TRAY_H - STEP_H])
            linear_extrude(STEP_H + 0.1)
                rounded_rect(
                    INNER_W + WALL_STEP * 2,
                    INNER_L + WALL_STEP * 2,
                    max(CORNER_R - WALL + WALL_STEP, 0.5)
                );

        // -- USB-C slot (short wall at Y=0, 1mm raised floor, 9mm tall) --
        translate([
            WALL + FIT + USBC_FROM_LEFT - 12.0 / 2,
            -0.1,
            FLOOR_T + 1.0
        ])
            cube([12.0, WALL + 0.2, 9.0]);

        // -- IO0 access hole (LEFT long wall) --
        translate([-0.1, BTN_Y, Z_BTN_CENTER])
            rotate([0, 90, 0])
                cylinder(d=BTN_HOLE_D, h=WALL + FIT + IO0_FROM_LEFT + 0.5);

        // -- RST access hole (RIGHT long wall) --
        translate([OUTER_W + 0.1, BTN_Y, Z_BTN_CENTER])
            rotate([0, -90, 0])
                cylinder(d=BTN_HOLE_D, h=WALL + FIT + (PCB_W - RST_FROM_LEFT) + 0.5);

        // -- Button load channels: vertical slots above IO0/RST holes --
        // Allows board to slide straight down without pressing the buttons.
        btn_channels();

        // -- Ventilation holes (tray floor) --
        tray_vents();
    }

    // PCB support rails — lift boards off floor, clear bottom-side components
    pcb_rails();
    // Snap bumps in step zone — click into matching lid recesses
    tray_step_snaps();
}

module pcb_rails() {
    translate([WALL,                    WALL, FLOOR_T])
        cube([RAIL_W, INNER_L, RAIL_H]);
    translate([WALL + INNER_W - RAIL_W, WALL, FLOOR_T])
        cube([RAIL_W, INNER_L, RAIL_H]);
}

module tray_vents() {
    usable_w = INNER_W - RAIL_W * 2;
    cols = max(1, floor(usable_w / VENT_GAP));
    rows = max(1, floor(INNER_L   / VENT_GAP));
    x0 = WALL + RAIL_W + (usable_w - (cols-1) * VENT_GAP) / 2;
    y0 = WALL           + (INNER_L  - (rows-1) * VENT_GAP) / 2;
    for (r=[0:rows-1], c=[0:cols-1])
        translate([x0 + c*VENT_GAP, y0 + r*VENT_GAP, -0.1])
            cylinder(d=VENT_D, h=FLOOR_T + 0.2);
}

module btn_channels() {
    // Shallow groove on the inner face of each long wall, running from the
    // tray rim down to the button hole. Depth = WALL_STEP (same as the step
    // closure lip) so the button clears the wall as the board slides in.
    ch_h = TRAY_H - Z_BTN_CENTER + 0.1;  // from hole center to tray rim

    // Left wall — IO0: groove cut into inner face (X = WALL - WALL_STEP → WALL)
    translate([WALL - WALL_STEP, BTN_Y - BTN_HOLE_D / 2, Z_BTN_CENTER - 0.1])
        cube([WALL_STEP, BTN_HOLE_D, ch_h]);

    // Right wall — RST: groove cut into inner face (X = OUTER_W-WALL → OUTER_W-WALL+WALL_STEP)
    translate([OUTER_W - WALL, BTN_Y - BTN_HOLE_D / 2, Z_BTN_CENTER - 0.1])
        cube([WALL_STEP, BTN_HOLE_D, ch_h]);
}


module tray_step_snaps() {
    // Cylindrical bumps on the inner face of the tray step-zone walls (long sides).
    // Two per wall, inset from each short end, clear of the button-hole channels.
    // The bump protrudes into the step void and deflects the lid skirt 0.1mm on
    // the way past, then clicks into the matching recess when the lid is seated.
    snap_z = TRAY_H - STEP_H / 2;
    for (y = [SNAP_Y_INSET, OUTER_L - SNAP_Y_INSET]) {
        // Left wall — bump points +X into step void
        translate([WALL - WALL_STEP, y, snap_z])
            rotate([0, 90, 0])
                cylinder(r=SNAP_R, h=SNAP_PROTRUDE, $fn=24);
        // Right wall — bump points -X into step void
        translate([OUTER_W - WALL + WALL_STEP, y, snap_z])
            rotate([0, -90, 0])
                cylinder(r=SNAP_R, h=SNAP_PROTRUDE, $fn=24);
    }
}

module lid_rib() {
    // Retention rib: full inner width, 2mm deep, 3mm tall, 2mm from USB-C-end inner wall.
    face_z = LID_H - FLOOR_T;
    translate([WALL, WALL + 2.0, face_z - 4.0])
        cube([INNER_W, 2.0, 4.0]);
}

module lid_step_snap_recesses() {
    // Cylindrical recesses in the outer face of the lid step skirt.
    // Positioned to match tray bumps when the lid is fully seated.
    // snap_z in lid coords = STEP_H/2 (same middle-of-step formula as tray).
    step_cut  = WALL_STEP + STEP_FIT;   // 1.2mm — outer face of lid skirt
    snap_z    = STEP_H / 2;
    recess_r  = SNAP_R + 0.1;           // slight clearance
    recess_h  = SNAP_PROTRUDE + 0.1;    // slightly deeper than bump
    for (y = [SNAP_Y_INSET, OUTER_L - SNAP_Y_INSET]) {
        // Left skirt — recess enters from outer face in +X
        translate([step_cut, y, snap_z])
            rotate([0, 90, 0])
                cylinder(r=recess_r, h=recess_h, $fn=24);
        // Right skirt — recess enters from outer face in -X
        translate([OUTER_W - step_cut, y, snap_z])
            rotate([0, -90, 0])
                cylinder(r=recess_r, h=recess_h, $fn=24);
    }
}


// ============================================================
// LID
// ============================================================
// Z=0: open rim (sits on tray).    Z=LID_H: outer face (top).
// Stepped wall: outer (WALL_STEP + STEP_FIT) mm of wall is removed for the
// bottom STEP_H, leaving a thin inner skirt that slides into the tray step zone.
//
// PRINT ORIENTATION: rim down (Z=0 on build plate).

module lid() {
    face_z = LID_H - FLOOR_T;  // inner face height = 10.2 - 1.0 = 9.2mm

    difference() {
        linear_extrude(LID_H)
            rounded_rect(OUTER_W, OUTER_L, CORNER_R);

        // Hollow interior — open at rim (Z=0)
        translate([WALL, WALL, -0.1])
            linear_extrude(face_z + 0.1)
                rounded_rect(INNER_W, INNER_L, max(CORNER_R - WALL, 0.5));

        // Stepped wall — thin outer wall for bottom STEP_H
        lid_step_cut();

        // Camera lens hole — through outer face
        translate([
            WALL + FIT + CAM_LENS_FROM_LEFT,
            WALL + FIT + TOTAL_L - CAM_LENS_FROM_CAM_END,
            face_z - 0.1
        ])
            cylinder(d=CAM_LENS_D, h=FLOOR_T + 0.2);

        // Camera module pocket — into inner face, holds OV2640 flat
        translate([
            WALL + FIT + CAM_LENS_FROM_LEFT - CAM_MOD_W / 2 - 0.25,
            WALL + FIT + TOTAL_L - CAM_LENS_FROM_CAM_END - CAM_MOD_L / 2 - 0.25,
            face_z - CAM_MOD_THICK - 0.5
        ])
            cube([CAM_MOD_W + 0.5, CAM_MOD_L + 0.5, CAM_MOD_THICK + 0.5]);

        // LED hole — through outer face
        translate([
            WALL + FIT + LED_FROM_LEFT,
            WALL + FIT + TOTAL_L - LED_FROM_CAM_END,
            face_z - 0.1
        ])
            cylinder(d=LED_D, h=FLOOR_T + 0.2);

        // SD card slot — camera-end short wall (Y=OUTER_L), centered
        translate([
            OUTER_W / 2 - (SD_SLOT_W + 0.5) / 2,
            OUTER_L - WALL - 0.1,
            SD_LID_Z_BOTTOM
        ])
            cube([SD_SLOT_W + 0.5, WALL + 0.2, SD_SLOT_H + 1.0]);

        // Snap recesses in lid step skirt — match tray bumps
        lid_step_snap_recesses();
    }

    // Retention rib — 2mm from USB-C-end inner wall
    lid_rib();
}

module lid_step_cut() {
    // Remove outer (WALL_STEP + STEP_FIT) of wall for the bottom STEP_H.
    // Remaining inner-wall thickness in step zone = WALL - (WALL_STEP + STEP_FIT) = 0.8mm.
    step_cut = WALL_STEP + STEP_FIT;  // 1.2mm
    translate([-0.1, -0.1, -0.1])
        linear_extrude(STEP_H + 0.1)
            difference() {
                rounded_rect(OUTER_W + 0.2, OUTER_L + 0.2, CORNER_R);
                translate([step_cut, step_cut, 0])
                    rounded_rect(
                        OUTER_W - step_cut * 2,
                        OUTER_L - step_cut * 2,
                        max(CORNER_R - step_cut, 0.5)
                    );
            }
}


// ============================================================
// RENDER
// ============================================================

if (SHOW == "tray") {
    tray();

} else if (SHOW == "lid") {
    // Lid printed rim-down — shown here in print orientation
    translate([0, 0, LID_H]) rotate([180, 0, 0]) lid();

} else {
    // Preview: assembled. Lid drops STEP_H into tray opening.
    color("SteelBlue",   0.85) tray();
    color("YellowGreen", 0.85) translate([0, 0, TRAY_H - STEP_H]) lid();
}

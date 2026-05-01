// ============================================================
// ESP32-CAM Dev Stand
// Fits FORIOT ESP32-CAM + MB V1541 tray (with pivot pins)
// No hardware required — printed friction pivot
// ============================================================
//
// PARTS — set SHOW to export each STL:
//   "tray_pins"  modified tray with side pivot pins
//   "stand"      base + neck + arms + antenna tab (one piece)
//   "preview"    assembled view (not for printing)
//
// HOW THE PIVOT WORKS:
//   Tray has 7mm cylindrical pins on both long walls.
//   Horizontal arms extend forward from neck top.
//   Open-top slots at arm tips — case loads by lowering straight down.
//   Slot is 0.3mm narrower than pin (friction) — holds any tilt angle.
//   To remove: lift straight up.
//
// TILT:
//   Case hangs in front of the neck with ~40° forward and ~30° backward
//   clearance before any part of the case contacts the stand.
//
// PRINT:
//   tray_pins — open top up, no supports
//   stand     — base flat on bed, prints upright, no supports needed

SHOW = "stand";
$fn = 48;


// ============================================================
// CASE DIMENSIONS  (must match esp32-cam-case.scad)
// ============================================================

WALL      = 2.0;
FLOOR_T   = 1.0;
CORNER_R  = 3.0;
FIT       = 0.25;
RAIL_H    = 0.8;
RAIL_W    = 1.5;
STEP_H    = 3.0;
WALL_STEP = 1.0;
STEP_FIT  = 0.2;
TRAY_H_TRIM   = 3.0;
CAM_PROTRUDE  = 0.8;
CAM_MOD_THICK = 8.0;
SNAP_R        = 1.2;
SNAP_PROTRUDE = 0.3;
SNAP_Y_INSET  = 5.0;
VENT_D   = 2.2;
VENT_GAP = 5.0;

PCB_W   = 28.0;
PCB_L   = 40.0;
STACK_H = 24.0;

TOTAL_L  = PCB_L;
INNER_W  = PCB_W  + FIT * 2;
INNER_L  = PCB_L  + FIT * 2;
OUTER_W  = INNER_W + WALL * 2;   // 32.5
OUTER_L  = INNER_L + WALL * 2;   // 44.5

PCB_SURFACE_H = STACK_H - CAM_MOD_THICK;
TRAY_H = FLOOR_T + RAIL_H + PCB_SURFACE_H - TRAY_H_TRIM;  // 14.8
LID_H  = CAM_MOD_THICK + STEP_H - CAM_PROTRUDE;            // 10.2

Z_MB_FLOOR   = FLOOR_T + RAIL_H;
Z_BTN_CENTER = Z_MB_FLOOR + 3.0;
BTN_HOLE_D   = 5.0;
BTN_Y        = 9.0;
IO0_FROM_LEFT  = 2.0;
RST_FROM_LEFT  = 26.0;
USBC_FROM_LEFT = 14.0;

CAM_LENS_D            = 9.0;
CAM_MOD_W             = 8.0;
CAM_MOD_L             = 8.0;
CAM_LENS_FROM_CAM_END = 9.0;
CAM_LENS_FROM_LEFT    = 14.0;
LED_D            = 1.5;
LED_FROM_CAM_END = 28.0;
LED_FROM_LEFT    = 24.0;
SD_SLOT_W = 14.0;
SD_SLOT_H =  2.0;
SD_LID_Z_BOTTOM = (Z_MB_FLOOR + 17.0) - ((FLOOR_T + RAIL_H + PCB_SURFACE_H) - STEP_H);


// ============================================================
// STAND PARAMETERS
// ============================================================

// Pivot pin on tray long walls
PIN_D   = 7.0;
PIN_L   = 4.5;
PIN_FIT = 0.05;   // interference per side — slot Y-width = PIN_D - PIN_FIT*2

// Pin position on tray: mid-length, mid-height
PIN_Y = OUTER_L / 2;   // 22.25mm from USB-C end (along case long axis)
PIN_Z = TRAY_H  / 2;   // 7.4mm from tray floor

// Base
BASE_W = 62.0;
BASE_L = 50.0;
BASE_T =  5.0;
BASE_R =  6.0;

// Neck
NECK_H = 55.0;
NECK_W = 14.0;
NECK_D = 14.0;

// Horizontal arms: extend forward (-Y) from neck top, pin slots at tips.
// Case hangs in front of neck — nothing blocks tilt in any direction.
ARM_REACH  = 25.0;  // how far pivot is from neck front face
ARM_BELOW  =  4.0;  // arm height below pivot (structural base)
ARM_ABOVE  = 10.0;  // arm height above pivot = slot depth
ARM_W      =  8.0;  // arm width in X (must be > PIN_D)

// Gap between arm inner face and tray outer wall
ARM_GAP = 1.0;

// Antenna tab — extends left from neck, 40mm long, 12mm wide, 3.5mm thick
// 6.5mm vertical hole at 30mm from neck face (screw from below, nut on top)


// ============================================================
// DERIVED
// ============================================================

PIVOT_Z = BASE_T + NECK_H;   // 60mm — stand Z of pivot

// Arm X positions
ARM_INNER_X = OUTER_W / 2 + ARM_GAP;    // 17.25mm from center
ARM_OUTER_X = ARM_INNER_X + ARM_W;      // 25.25mm from center

// Slot dimensions
SLOT_Y = PIN_D - PIN_FIT * 2;           // 6.7mm — friction fit
SLOT_X = PIN_L - ARM_GAP + 1.0;         // 4.5mm — captures pin end inside arm

// Pivot Y position in stand: ARM_REACH forward of neck front face
PIVOT_Y = NECK_D / 2 - ARM_REACH;       // 7 - 22 = -15mm (in front of neck)

// Arm tip extends SLOT_Y/2 + 2.5mm past pin axis for material around slot
ARM_TIP_Y = PIVOT_Y - SLOT_Y / 2 - 2.5;  // extra front lip thickness to prevent bending

// Antenna: top face is 10mm below arm connection (PIVOT_Z), height 18mm
ANT_H     = 18.0;
ANT_Z_TOP = PIVOT_Z - 10.0;   // 50mm
ANT_Z_BOT = ANT_Z_TOP - ANT_H; // 32mm


// ============================================================
// UTILITIES
// ============================================================

module rounded_rect(w, l, r) {
    offset(r=r) offset(r=-r) square([w, l]);
}

module rounded_shell(w, l, h, r) {
    difference() {
        linear_extrude(h) rounded_rect(w, l, r);
        translate([WALL, WALL, FLOOR_T])
            linear_extrude(h)
                rounded_rect(w - WALL*2, l - WALL*2, max(r - WALL, 0.5));
    }
}


// ============================================================
// TRAY WITH PIVOT PINS
// ============================================================

module tray_pins() {
    difference() {
        rounded_shell(OUTER_W, OUTER_L, TRAY_H, CORNER_R);

        translate([WALL - WALL_STEP, WALL - WALL_STEP, TRAY_H - STEP_H])
            linear_extrude(STEP_H + 0.1)
                rounded_rect(
                    INNER_W + WALL_STEP * 2,
                    INNER_L + WALL_STEP * 2,
                    max(CORNER_R - WALL + WALL_STEP, 0.5)
                );

        translate([WALL + FIT + USBC_FROM_LEFT - 6.0, -0.1, FLOOR_T + 1.0])
            cube([12.0, WALL + 0.2, 9.0]);

        translate([-0.1, BTN_Y, Z_BTN_CENTER])
            rotate([0, 90, 0])
                cylinder(d=BTN_HOLE_D, h=WALL + FIT + IO0_FROM_LEFT + 0.5);

        translate([OUTER_W + 0.1, BTN_Y, Z_BTN_CENTER])
            rotate([0, -90, 0])
                cylinder(d=BTN_HOLE_D, h=WALL + FIT + (PCB_W - RST_FROM_LEFT) + 0.5);

        btn_channels();
        tray_vents();
    }

    pcb_rails();
    tray_step_snaps();
    pivot_pins();
}

module pcb_rails() {
    translate([WALL, WALL, FLOOR_T])
        cube([RAIL_W, INNER_L, RAIL_H]);
    translate([WALL + INNER_W - RAIL_W, WALL, FLOOR_T])
        cube([RAIL_W, INNER_L, RAIL_H]);
}

module tray_vents() {
    usable_w = INNER_W - RAIL_W * 2;
    cols = max(1, floor(usable_w / VENT_GAP));
    rows = max(1, floor(INNER_L   / VENT_GAP));
    x0 = WALL + RAIL_W + (usable_w - (cols-1)*VENT_GAP) / 2;
    y0 = WALL           + (INNER_L  - (rows-1)*VENT_GAP) / 2;
    for (r=[0:rows-1], c=[0:cols-1])
        translate([x0 + c*VENT_GAP, y0 + r*VENT_GAP, -0.1])
            cylinder(d=VENT_D, h=FLOOR_T + 0.2);
}

module btn_channels() {
    ch_h = TRAY_H - Z_BTN_CENTER + 0.1;
    translate([WALL - WALL_STEP, BTN_Y - BTN_HOLE_D/2, Z_BTN_CENTER - 0.1])
        cube([WALL_STEP, BTN_HOLE_D, ch_h]);
    translate([OUTER_W - WALL, BTN_Y - BTN_HOLE_D/2, Z_BTN_CENTER - 0.1])
        cube([WALL_STEP, BTN_HOLE_D, ch_h]);
}

module tray_step_snaps() {
    snap_z = TRAY_H - STEP_H / 2;
    for (y = [SNAP_Y_INSET, OUTER_L - SNAP_Y_INSET]) {
        translate([WALL - WALL_STEP, y, snap_z])
            rotate([0, 90, 0])
                cylinder(r=SNAP_R, h=SNAP_PROTRUDE, $fn=24);
        translate([OUTER_W - WALL + WALL_STEP, y, snap_z])
            rotate([0, -90, 0])
                cylinder(r=SNAP_R, h=SNAP_PROTRUDE, $fn=24);
    }
}

module pivot_pins() {
    translate([0, PIN_Y, PIN_Z])
        rotate([0, -90, 0])
            cylinder(d=PIN_D, h=PIN_L, $fn=32);
    translate([OUTER_W, PIN_Y, PIN_Z])
        rotate([0, 90, 0])
            cylinder(d=PIN_D, h=PIN_L, $fn=32);
}


// ============================================================
// LID  (preview only — print from esp32-cam-case.scad)
// ============================================================

module lid_step_snap_recesses() {
    step_cut = WALL_STEP + STEP_FIT;
    snap_z   = STEP_H / 2;
    recess_r = SNAP_R + 0.1;
    recess_h = SNAP_PROTRUDE + 0.1;
    for (y = [SNAP_Y_INSET, OUTER_L - SNAP_Y_INSET]) {
        translate([step_cut, y, snap_z])
            rotate([0, 90, 0])
                cylinder(r=recess_r, h=recess_h, $fn=24);
        translate([OUTER_W - step_cut, y, snap_z])
            rotate([0, -90, 0])
                cylinder(r=recess_r, h=recess_h, $fn=24);
    }
}

module lid_step_cut() {
    step_cut = WALL_STEP + STEP_FIT;
    translate([-0.1, -0.1, -0.1])
        linear_extrude(STEP_H + 0.1)
            difference() {
                rounded_rect(OUTER_W + 0.2, OUTER_L + 0.2, CORNER_R);
                translate([step_cut, step_cut, 0])
                    rounded_rect(OUTER_W - step_cut*2, OUTER_L - step_cut*2,
                                 max(CORNER_R - step_cut, 0.5));
            }
}

module lid_rib() {
    face_z = LID_H - FLOOR_T;
    translate([WALL, WALL + 2.0, face_z - 4.0])
        cube([INNER_W, 2.0, 4.0]);
}

module lid() {
    face_z = LID_H - FLOOR_T;
    difference() {
        linear_extrude(LID_H) rounded_rect(OUTER_W, OUTER_L, CORNER_R);
        translate([WALL, WALL, -0.1])
            linear_extrude(face_z + 0.1)
                rounded_rect(INNER_W, INNER_L, max(CORNER_R - WALL, 0.5));
        lid_step_cut();
        translate([WALL + FIT + CAM_LENS_FROM_LEFT,
                   WALL + FIT + TOTAL_L - CAM_LENS_FROM_CAM_END, face_z - 0.1])
            cylinder(d=CAM_LENS_D, h=FLOOR_T + 0.2);
        translate([WALL + FIT + CAM_LENS_FROM_LEFT - CAM_MOD_W/2 - 0.25,
                   WALL + FIT + TOTAL_L - CAM_LENS_FROM_CAM_END - CAM_MOD_L/2 - 0.25,
                   face_z - CAM_MOD_THICK - 0.5])
            cube([CAM_MOD_W + 0.5, CAM_MOD_L + 0.5, CAM_MOD_THICK + 0.5]);
        translate([WALL + FIT + LED_FROM_LEFT,
                   WALL + FIT + TOTAL_L - LED_FROM_CAM_END, face_z - 0.1])
            cylinder(d=LED_D, h=FLOOR_T + 0.2);
        translate([OUTER_W/2 - (SD_SLOT_W + 0.5)/2,
                   OUTER_L - WALL - 0.1, SD_LID_Z_BOTTOM])
            cube([SD_SLOT_W + 0.5, WALL + 0.2, SD_SLOT_H + 1.0]);
        lid_step_snap_recesses();
    }
    lid_rib();
}


// ============================================================
// STAND — one printable piece
// ============================================================
//
// Shape: base → neck → arm assembly → antenna tab.
//
// ARM ASSEMBLY:
//   A wide connecting plate spans the full arm-to-arm width at the neck top.
//   Two arms extend FORWARD (−Y) from the plate, one each side.
//   The case hangs between the arm tips, in FRONT of the neck.
//   Nothing obstructs tilt in any direction.
//
// SLOT:
//   Each arm has an open-top slot at its tip. Slot is narrow in Y (6.7mm)
//   creating friction on the pin. Case loads from above, lifts out upward.

module stand_base() {
    linear_extrude(BASE_T)
        offset(r=BASE_R) offset(r=-BASE_R)
            square([BASE_W, BASE_L], center=true);
}

module stand_neck() {
    translate([-NECK_W/2, -NECK_D/2, BASE_T])
        cube([NECK_W, NECK_D, NECK_H]);
}

module stand_arm_assembly() {
    arm_h  = ARM_BELOW + ARM_ABOVE;
    arm_y0 = ARM_TIP_Y;        // front of arm (furthest forward)
    arm_y1 = NECK_D / 2;       // back of arm (at neck back face)

    // Connecting plate: full width, BACK HALF of neck only (Y=0 to NECK_D/2).
    // Stopping at Y=0 keeps the plate well behind the tray floor,
    // leaving ~10mm clearance at 0° tilt and ~35° of forward tilt room.
    translate([-ARM_OUTER_X, 0, PIVOT_Z - ARM_BELOW])
        cube([ARM_OUTER_X * 2, NECK_D / 2, arm_h]);

    // Two forward-extending arms with open-top slots
    for (side = [-1, 1]) {
        x0 = side > 0 ? ARM_INNER_X : -ARM_OUTER_X;

        difference() {
            // Arm body: full length from tip to neck back face
            translate([x0, arm_y0, PIVOT_Z - ARM_BELOW])
                cube([ARM_W, arm_y1 - arm_y0, arm_h]);

            // Open-top slot: narrow in Y (friction), enters from arm inner face in X
            // Slot bottom = PIVOT_Z; top = open (PIVOT_Z + ARM_ABOVE)
            sx = side > 0 ? ARM_INNER_X - 0.1 : -(ARM_INNER_X + SLOT_X) + 0.1;
            translate([sx, PIVOT_Y - SLOT_Y/2, PIVOT_Z])
                cube([SLOT_X + 0.1, SLOT_Y, ARM_ABOVE + 0.1]);
        }
    }
}

module antenna_tab() {
    // Flat horizontal plate extending left (−X) from neck.
    // 40mm long, 12mm wide, 3.5mm thick.
    // 6.5mm hole at 30mm from neck face — vertical, screw below / nut on top.
    tab_len  = 40.0;
    tab_wide = 12.0;
    tab_t    =  3.5;

    translate([-NECK_W/2 - tab_len, -tab_wide/2, ANT_Z_BOT])
        difference() {
            cube([tab_len, tab_wide, tab_t]);
            translate([tab_len - 30.0, tab_wide/2, -0.1])
                cylinder(d=6.5, h=tab_t + 0.2, $fn=32);
        }
}

module stand() {
    stand_base();
    stand_neck();
    stand_arm_assembly();
    antenna_tab();
}


// ============================================================
// RENDER
// ============================================================
//
// case_in_stand(): pivot pin of tray → stand position (±OUTER_W/2, PIVOT_Y, PIVOT_Z)
// Rotation: case +Y (camera end) → stand +Z (up)
//           case +Z (lid face)   → stand −Y (toward viewer in OpenSCAD default view)

module case_in_stand() {
    translate([0, PIVOT_Y, PIVOT_Z])
        rotate([90, 0, 0])
            translate([-OUTER_W/2, -PIN_Y, -PIN_Z])
                children();
}

if (SHOW == "tray_pins") {
    tray_pins();
} else if (SHOW == "stand") {
    stand();
} else {
    color("SteelBlue",   0.85) case_in_stand() tray_pins();
    color("YellowGreen", 0.85) case_in_stand() translate([0, 0, TRAY_H - STEP_H]) lid();
    color("Tan", 0.90) stand();
}

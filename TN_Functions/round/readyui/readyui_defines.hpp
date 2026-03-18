// Side definitions: [side, sideReady index, display name, hex color, pulse tint RGB, flash RGBA]
// Text colors matched to 29th ID forum theme
// Pulse tint = subtle version breathed toward during safe start when that team is unready
// Flash color = bright pop when that specific team readies up
#define SIDE_DEFS [ \
    [west, 1, "BLUFOR", "#5B9BD5", [0.10, 0.16, 0.25], [0.35, 0.61, 0.84, 0.8]], \
    [east, 0, "OPFOR", "#D9634A", [0.25, 0.10, 0.08], [0.85, 0.39, 0.29, 0.8]], \
    [resistance, 2, "GRNFOR", "#6BBF59", [0.10, 0.22, 0.09], [0.42, 0.75, 0.35, 0.8]] \
]

// Aspect-ratio grid matching vanilla HUD (RscMPProgress / RscMissionStatus)
// Scales consistently across all resolutions and interface sizes
#define GRID_W (((safezoneW / safezoneH) min 1.2) / 40)
#define GRID_H ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)

// Anchor to vanilla MP HUD position (from RscMissionStatus)
// Respects the player's layout editor settings via profile variables
// Defaults: X = right edge - 2 grid cols, Y = 5 grid rows + safezoneY
#define MP_ANCHOR_X (profileNamespace getVariable ["IGUI_GRID_MP_X", (safeZoneX + safeZoneW - 2 * GRID_W)])
#define MP_ANCHOR_Y (profileNamespace getVariable ["IGUI_GRID_MP_Y", (5 * GRID_H + safeZoneY)])

// UI positioning relative to MP HUD anchor — tweak multipliers to adjust
#define UI_WIDTH (10 * GRID_W)
#define UI_GAP (0.5 * GRID_W)
#define UI_X (MP_ANCHOR_X - UI_WIDTH - UI_GAP)
#define UI_Y MP_ANCHOR_Y
#define LINE_HEIGHT (1 * GRID_H)
#define PADDING (0.3 * GRID_H)
#define CONTENT_INSET (0.4 * GRID_W)

// Background color — 29th ID gold (always)
#define BG_COLOR [0.067, 0.059, 0.039, 0.75]
#define BG_R 0.067
#define BG_G 0.059
#define BG_B 0.039

// Pulse timing
#define PULSE_SPEED 3.14159
#define PULSE_A_MIN 0.65
#define PULSE_A_MAX 0.80
#define PULSE_CYCLE 2
// Sword shine — diagonal gleam built from horizontal slices
#define SHINE_WIDTH (1.5 * GRID_W)
#define SHINE_DURATION 0.45
// 29 slices because I don't know 20 is already fine but 29 is the unit name so fml
// 69 68 61 74 65 79 6F 75 62 61 65 77 68 79 64 69 64 79 6F 75 6D 61 6B 65 6D 65 64 6F 74 68 69 73
#define SHINE_SLICES 29
#define SHINE_STAGGER (1.0 * GRID_W)

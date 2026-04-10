#include "script_component.hpp"

/*
 * Author: Bae [29th ID]
 * Opens a GUI dialog that lets an admin adjust the remaining
 * countdown timer via a slider or direct text input.
 *
 * Uses createDialog (TN_RscDisplaySafeStartTime, IDD 29141)
 * which overlays on display 46 — readyUI stays visible.
 *
 * Arguments:
 * 0: Title label <STRING>
 * 1: Callback called with the new time in seconds <CODE>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [
 *     "New Safe Start Time:",
 *     {
 *         if (NOT_ROUND_SAFE) exitWith {};
 *         [_this] call BIS_fnc_countdown;
 *     }
 * ] call TN_event_fnc_gui_setTime;
 */

params ["_title", "_onFinished"];

#define IDD_SAFE_START_TIME 29141
#define IDC_BG 50000
#define IDC_TIME_ROW 5000
#define IDC_SLIDER 5140
#define IDC_NAME 5010
#define IDC_DEFAULT 5020
#define IDC_BTN_CANCEL 5100
#define IDC_BTN_OK 5101
#define IDC_EDIT_HOURS 5141
#define IDC_EDIT_MINUTES 5142
#define IDC_EDIT_SECONDS 5143
#define DIK_RETURN 28
#define DIK_NUMPADENTER 156
#define SLIDER_MIN 10
#define SLIDER_MAX 3600
#define SLIDER_SPEED 60
#define BG_ALPHA 0.7
#define BTN_WIDTH_MULT 6.2

createDialog "TN_RscDisplaySafeStartTime";
private _display = findDisplay IDD_SAFE_START_TIME;

//stash params on display for the OK button handler
_display setVariable [QGVAR(setTime_onFinished), _onFinished];

//declare early to put in the back
private _bg = _display ctrlCreate ["RscText", IDC_BG];
private _timeCtrl = _display ctrlCreate ["TN_settings_Row_Time", IDC_TIME_ROW];
private _sliderCtrl = _display displayCtrl IDC_SLIDER;

private _h = getNumber (missionConfigFile >> "TN_settings_Row_Time" >> "h");
private _w = getNumber (missionConfigFile >> "TN_settings_Row_Time" >> "w");
private _wName = getNumber (
    missionConfigFile >> "TN_settings_Row_Time" >> "controls" >> "Name" >> "w"
);
private _wSlider = getNumber (
    missionConfigFile >> "TN_settings_Row_Time" >> "controls" >> "Slider" >> "w"
);

private _ctrlSettingName = _timeCtrl controlsGroupCtrl IDC_NAME;
_ctrlSettingName ctrlSetText _title;

//Annoying to center since name ctrl is oversized
private _textWidth = ctrlTextWidth _ctrlSettingName;
private _leftEmpty = _wName - _textWidth;

private _xCenter = 0.5 - (_leftEmpty + (_textWidth + _wSlider) / 2);
_timeCtrl ctrlSetPosition [_xCenter, 0.5 - _h];

//no need for default button in this context
private _ctrlDefault = _timeCtrl controlsGroupCtrl IDC_DEFAULT;
_ctrlDefault ctrlEnable false;
_ctrlDefault ctrlShow false;
_timeCtrl ctrlCommit 0;

/* --- Cancel button --- */

private _btnCancel = _display ctrlCreate ["RscButtonMenuCancel", IDC_BTN_CANCEL];
//same sizes for OK button
private _wCancel = BTN_WIDTH_MULT * (((safezoneW / safezoneH) min 1.2) / 40);
private _hCancel = getNumber (configFile >> "RscButtonMenuCancel" >> "h");
_btnCancel ctrlSetPosition [
    _xCenter + (_leftEmpty) * 0.95,
    0.5,
    _wCancel,
    _hCancel
];
_btnCancel ctrlCommit 0;
_btnCancel ctrlAddEventHandler [
    "ButtonClick", {
        params ["_ctrl"];
        (ctrlParent _ctrl) closeDisplay 2;
    }
];

/* --- OK button --- */

private _btnOK = _display ctrlCreate ["RscButtonMenuOK", IDC_BTN_OK];
private _sliderPos = ctrlPosition _sliderCtrl;
_btnOK ctrlSetPosition [
    (_sliderPos select 0)
        + _wSlider - _wCancel,
    0.5,
    _wCancel,
    _hCancel
];
_btnOK ctrlCommit 0;
_btnOK ctrlAddEventHandler [
    "ButtonClick", {
        params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        private _sliderCtrl = _display displayCtrl IDC_SLIDER;

        private _onFinished = _display getVariable QGVAR(setTime_onFinished);
        (sliderPosition _sliderCtrl) call _onFinished;
        (ctrlParent _ctrl) closeDisplay 1;
    }
];

/* --- Background sizing --- */

//these buttons are useful for border finding
private _cancelPos = ctrlPosition _btnCancel;
private _cancelOk = ctrlPosition _btnOk;
private _bgW = (_cancelOk select 0) + (_cancelOk select 2) - (_cancelPos select 0);
_bg ctrlSetPosition [
    _cancelPos select 0,
    0.5 - _h,
    _bgW,
    _h + _hCancel
];
_bg ctrlCommit 0;
_bg ctrlSetBackgroundColor [0, 0, 0, BG_ALPHA];

/* --- Slider configuration --- */

//modified gui_settingTime
private _min = SLIDER_MIN;
private _max = SLIDER_MAX;
private _currentValue = (floor ([0] call BIS_fnc_countdown)) max _min;

private _ctrlSlider = _timeCtrl controlsGroupCtrl IDC_SLIDER;

_ctrlSlider sliderSetRange [_min, _max];
_ctrlSlider sliderSetPosition _currentValue;
private _range = _max - _min;
_ctrlSlider sliderSetSpeed [SLIDER_SPEED, SLIDER_SPEED];

/* --- Slider change handler --- */

_ctrlSlider ctrlAddEventHandler [
    "SliderPosChanged", {
        params ["_ctrlSlider", "_value"];
        _value = round _value;

        private _timeCtrl = ctrlParentControlsGroup _ctrlSlider;
        (_timeCtrl controlsGroupCtrl IDC_EDIT_HOURS)
            ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl IDC_EDIT_MINUTES)
            ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl IDC_EDIT_SECONDS)
            ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );
    }
];

/* --- Time edit fields --- */

{
    _x params ["_idc", "_value"];

    private _ctrlEdit = _timeCtrl controlsGroupCtrl _idc;
    _ctrlEdit ctrlSetText (
        [_value, 2] call CBA_fnc_formatNumber
    );

    _ctrlEdit ctrlAddEventHandler [
        "KillFocus", {
            params ["_ctrlEdit"];

            private _timeCtrl = ctrlParentControlsGroup _ctrlEdit;
            private _ctrlSlider = _timeCtrl controlsGroupCtrl IDC_SLIDER;
            private _ctrlEditHours = _timeCtrl controlsGroupCtrl IDC_EDIT_HOURS;
            private _ctrlEditMinutes = _timeCtrl controlsGroupCtrl IDC_EDIT_MINUTES;
            private _ctrlEditSeconds = _timeCtrl controlsGroupCtrl IDC_EDIT_SECONDS;

            private _value = round (
                parseNumber ctrlText
                    _ctrlEditHours * 3600
                + parseNumber ctrlText
                    _ctrlEditMinutes * 60
                + parseNumber ctrlText
                    _ctrlEditSeconds
            );
            _ctrlSlider sliderSetPosition _value;
            _value = sliderPosition _ctrlSlider;

            _ctrlEditHours ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
            _ctrlEditMinutes ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
            _ctrlEditSeconds ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );
        }
    ];
} forEach [
    [IDC_EDIT_HOURS, floor (_currentValue / 3600)],
    [IDC_EDIT_MINUTES, floor (_currentValue / 60 % 60)],
    [IDC_EDIT_SECONDS, floor (_currentValue % 60)]
];

/* --- CBA settings UI update callback --- */

_timeCtrl setVariable [
    "cba_settings_fnc_updateUI", {
        params ["_timeCtrl", "_value"];

        (_timeCtrl controlsGroupCtrl IDC_SLIDER)
            sliderSetPosition _value;
        (_timeCtrl controlsGroupCtrl IDC_EDIT_HOURS)
            ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl IDC_EDIT_MINUTES)
            ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl IDC_EDIT_SECONDS)
            ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );
    }
];

//Prevent enter key from closing display and
//setting new time
_display displayAddEventHandler [
    "KeyDown", {
        params [
            "_display", "_key",
            "_shift", "_ctrl", "_alt"
        ];

        (_key in [DIK_RETURN, DIK_NUMPADENTER]);
    }
];

nil

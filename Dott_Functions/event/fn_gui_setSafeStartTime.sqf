/**
 * Function: TN_event_fnc_gui_setSafeStartTime
 * Author:   Bae [29th ID]
 *
 * Opens a GUI dialog that lets an admin adjust the remaining
 * safe-start countdown timer via a slider or direct text
 * input. The new time is applied via BIS_fnc_countdown and
 * broadcast to all clients via displayMsg.
 *
 * Uses createDialog (TN_RscDisplaySafeStartTime, IDD 29141)
 * which overlays on display 46 — readyUI stays visible.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 */

createDialog "TN_RscDisplaySafeStartTime";
private _display = findDisplay 29141;
//declare early to put in the back
private _bg = _display ctrlCreate ["RscText", 50000];
private _timeCtrl = _display ctrlCreate ["TN_settings_Row_Time", 5000];
private _sliderCtrl = _display displayCtrl 5140;

private _h = getNumber (missionConfigFile >> "TN_settings_Row_Time" >> "h");
private _w = getNumber (missionConfigFile >> "TN_settings_Row_Time" >> "w");
private _wName = getNumber (
    missionConfigFile >> "TN_settings_Row_Time" >> "controls" >> "Name" >> "w"
);
private _wSlider = getNumber (
    missionConfigFile >> "TN_settings_Row_Time" >> "controls" >> "Slider" >> "w"
);

private _ctrlSettingName = _timeCtrl controlsGroupCtrl 5010;
_ctrlSettingName ctrlSetText "New Safe Start Time:";

//Annoying to center since name ctrl is oversized
private _textWidth = ctrlTextWidth _ctrlSettingName;
private _leftEmpty = _wName - _textWidth;

private _xCenter = 0.5 - (_leftEmpty + (_textWidth + _wSlider) / 2);
_timeCtrl ctrlSetPosition [_xCenter, 0.5 - _h];

//no need for default button in this context
private _ctrlDefault = _timeCtrl controlsGroupCtrl 5020;
_ctrlDefault ctrlEnable false;
_ctrlDefault ctrlShow false;
_timeCtrl ctrlCommit 0;

/* --- Cancel button --- */

private _btnCancel = _display ctrlCreate ["RscButtonMenuCancel", 5100];
//same sizes for OK button
private _wCancel = 6.2 * (((safezoneW / safezoneH) min 1.2) / 40);
private _hCancel = getNumber (configFile >> "RscButtonMenuCancel" >> "h");
_btnCancel ctrlSetPosition [
    _xCenter + (_leftEmpty) * 0.95,
    0.5,
    _wCancel,
    _hCancel
];
_btnCancel ctrlCommit 0;
_btnCancel ctrlAddEventHandler [
    "ButtonClick",
    {
        params ["_ctrl"];
        (ctrlParent _ctrl) closeDisplay 2;
    }
];

/* --- OK button --- */

private _btnOK = _display ctrlCreate ["RscButtonMenuOK", 5101];
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
    "ButtonClick",
    {
        params ["_ctrl"];
        private _display = ctrlParent _ctrl;
        private _sliderCtrl = _display displayCtrl 5140;

        if (!TN_round_safeStartActive) then
        {
            systemChat "Safe start has already ended! Input ignored.";
        }
        else
        {
            private _newtime = sliderPosition _sliderCtrl;
            [_newTime] call BIS_fnc_countdown;

            [
                format [
                    "<t color='#ffffff' size='2.5'>Safe Start Time changed to %1!</t>",
                    (round _newTime) call TN_round_fnc_formatTime
                ],
                "PLAIN",
                0.5,
                false
            ] remoteExecCall ["TN_common_fnc_displayMsg"];
        };
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
_bg ctrlSetBackgroundColor [0, 0, 0, 0.7];

/* --- Slider configuration --- */

//modified gui_settingTime
private _min = 10;
private _max = 3600;
private _currentValue = (floor ([0] call BIS_fnc_countdown)) max _min;

private _ctrlSlider = _timeCtrl controlsGroupCtrl 5140;

_ctrlSlider sliderSetRange [_min, _max];
_ctrlSlider sliderSetPosition _currentValue;
private _range = _max - _min;
_ctrlSlider sliderSetSpeed [60, 60];

/* --- Slider change handler --- */

_ctrlSlider ctrlAddEventHandler [
    "SliderPosChanged",
    {
        params ["_ctrlSlider", "_value"];
        _value = round _value;

        private _timeCtrl = ctrlParentControlsGroup _ctrlSlider;
        (_timeCtrl controlsGroupCtrl 5141)
            ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl 5142)
            ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl 5143)
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
        "KillFocus",
        {
            params ["_ctrlEdit"];

            private _timeCtrl = ctrlParentControlsGroup _ctrlEdit;
            private _ctrlSlider = _timeCtrl controlsGroupCtrl 5140;
            private _ctrlEditHours = _timeCtrl controlsGroupCtrl 5141;
            private _ctrlEditMinutes = _timeCtrl controlsGroupCtrl 5142;
            private _ctrlEditSeconds = _timeCtrl controlsGroupCtrl 5143;

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
    [5141, floor (_currentValue / 3600)],
    [5142, floor (_currentValue / 60 % 60)],
    [5143, floor (_currentValue % 60)]
];

/* --- CBA settings UI update callback --- */

_timeCtrl setVariable [
    "cba_settings_fnc_updateUI",
    {
        params ["_timeCtrl", "_value"];

        (_timeCtrl controlsGroupCtrl 5140)
            sliderSetPosition _value;
        (_timeCtrl controlsGroupCtrl 5141)
            ctrlSetText (
                [floor (_value / 3600), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl 5142)
            ctrlSetText (
                [floor (_value / 60 % 60), 2]
                    call CBA_fnc_formatNumber
            );
        (_timeCtrl controlsGroupCtrl 5143)
            ctrlSetText (
                [floor (_value % 60), 2]
                    call CBA_fnc_formatNumber
            );
    }
];

//Prevent enter key from closing display and
//setting new time
_display displayAddEventHandler [
    "KeyDown",
    {
        params [
            "_display", "_key",
            "_shift", "_ctrl", "_alt"
        ];

        // DIK_RETURN = 28,
        // DIK_NUMPADENTER = 156
        (_key in [28, 156]);
    }
];

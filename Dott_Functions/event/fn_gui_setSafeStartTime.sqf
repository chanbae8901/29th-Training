private _display = findDisplay 46 createDisplay "RscDisplayEmpty"; 
private _bg = _display ctrlCreate ["RscText", 50000]; //declare early to put in the back
private _timeCtrl = _display ctrlCreate ["DOTT_settings_Row_Time", 5000]; 
private _sliderCtrl = _display displayCtrl 5140;

private _h = getNumber(missionConfigFile >> "DOTT_settings_Row_Time" >> "h"); 
private _w = getNumber(missionConfigFile >> "DOTT_settings_Row_Time" >> "w"); 
private _wName = getNumber(missionConfigFile >> "DOTT_settings_Row_Time" >> "controls" >> "Name" >> "w"); 
private _wSlider = getNumber(missionConfigFile >> "DOTT_settings_Row_Time" >> "controls" >> "Slider" >> "w"); 

private _ctrlSettingName = _timeCtrl controlsGroupCtrl 5010; 
_ctrlSettingName ctrlSetText "New Safe Start Time:"; 

//Annoying to center since name ctrl is oversized
private _textWidth = ctrlTextWidth _ctrlSettingName;
private _leftEmpty = _wName - _textWidth;

private _xCenter = .5 - (_leftEmpty + (_textWidth + _wSlider)/2); 
_timeCtrl ctrlSetPosition [_xCenter, 0.5 - _h];

//no need for default button in this context
private _ctrlDefault = _timeCtrl controlsGroupCtrl 5020; 
_ctrlDefault ctrlEnable false; 
_ctrlDefault ctrlShow false; 
_timeCtrl ctrlCommit 0; 

private _btnCancel = _display ctrlCreate ["RscButtonMenuCancel", 5100]; 
private _wCancel = 6.2 * (((safezoneW / safezoneH) min 1.2) / 40); //same sizes for OK button
private _hCancel = getNumber(configFile >> "RscButtonMenuCancel" >> "h"); 
_btnCancel ctrlSetPosition [_xCenter + (_leftEmpty)*.95, 0.5, _wCancel, _hCancel]; 
_btnCancel ctrlCommit 0; 
_btnCancel ctrlAddEventHandler ["ButtonClick", { 
    params ["_ctrl"]; 
    (ctrlParent _ctrl) closeDisplay 2; 
}];

private _btnOK = _display ctrlCreate ["RscButtonMenuOK", 5101]; 
private _sliderPos = ctrlPosition _sliderCtrl;
_btnOK ctrlSetPosition [(_sliderPos select 0) + _wSlider - _wCancel, 0.5, _wCancel, _hCancel]; 
_btnOK ctrlCommit 0; 
_btnOK ctrlAddEventHandler ["ButtonClick", { 
    params ["_ctrl"]; 
	private _timeCtrl = ctrlParent _ctrl;
	private _sliderCtrl = _timeCtrl displayCtrl 5140;
    if (isNil "DOTT_safeStartActive") then { systemChat "Safe start has already ended! Input ignored."}
	else 
	{
		private _newtime = sliderPosition _sliderCtrl;
		[_newTime] call BIS_fnc_countdown;
		private _msg = format ["Safe Start Time changed to %1!", _newTime call DOTT_round_fnc_formatTime];
		_msg remoteExec ["hint"];
	};
    (ctrlParent _ctrl) closeDisplay 1; 
}]; 
   
private _cancelPos = ctrlPosition _btnCancel; //these buttons are useful for border finding
private _cancelOk = ctrlPosition _btnOk;
private _bgW = (_cancelOk select 0) + (_cancelOk select 2) - (_cancelPos select 0);
_bg ctrlSetPosition [_cancelPos select 0, .5 - _h, _bgW, _h + _hCancel]; 
_bg ctrlCommit 0; 
_bg ctrlSetBackgroundColor [0,0,0,0.7];


//modified gui_settingTime 
private _min = 10;
private _max = 3600; 
private _currentValue = (floor ([0] call BIS_fnc_countdown)) max _min;
 
private _ctrlSlider = _timeCtrl controlsGroupCtrl 5140; 
 
_ctrlSlider sliderSetRange [_min, _max]; 
_ctrlSlider sliderSetPosition _currentValue; 
private _range = _max - _min; 
_ctrlSlider sliderSetSpeed [60, 60]; 
 
_ctrlSlider ctrlAddEventHandler ["SliderPosChanged", { 
    params ["_ctrlSlider", "_value"]; 
    _value = round _value; 
 
    private _timeCtrl = ctrlParentControlsGroup _ctrlSlider; 
    (_timeCtrl controlsGroupCtrl 5141) ctrlSetText ([floor (_value / 3600), 2] call CBA_fnc_formatNumber); 
    (_timeCtrl controlsGroupCtrl 5142) ctrlSetText ([floor (_value / 60 % 60), 2] call CBA_fnc_formatNumber); 
    (_timeCtrl controlsGroupCtrl 5143) ctrlSetText ([floor (_value % 60), 2] call CBA_fnc_formatNumber); 
}]; 
 
{ 
    _x params ["_idc", "_value"]; 
 
    private _ctrlEdit = _timeCtrl controlsGroupCtrl _idc; 
    _ctrlEdit ctrlSetText ([_value, 2] call CBA_fnc_formatNumber); 
 
    _ctrlEdit ctrlAddEventHandler ["KillFocus", { 
        params ["_ctrlEdit"]; 
 
        private _timeCtrl = ctrlParentControlsGroup _ctrlEdit; 
        private _ctrlSlider = _timeCtrl controlsGroupCtrl 5140; 
        private _ctrlEditHours = _timeCtrl controlsGroupCtrl 5141; 
        private _ctrlEditMinutes = _timeCtrl controlsGroupCtrl 5142; 
        private _ctrlEditSeconds = _timeCtrl controlsGroupCtrl 5143; 
 
        private _value = round (parseNumber ctrlText _ctrlEditHours * 3600 + parseNumber ctrlText _ctrlEditMinutes * 60 + parseNumber ctrlText _ctrlEditSeconds); 
        _ctrlSlider sliderSetPosition _value; 
        _value = sliderPosition _ctrlSlider; 
 
        _ctrlEditHours ctrlSetText ([floor (_value / 3600), 2] call CBA_fnc_formatNumber); 
        _ctrlEditMinutes ctrlSetText ([floor (_value / 60 % 60), 2] call CBA_fnc_formatNumber); 
        _ctrlEditSeconds ctrlSetText ([floor (_value % 60), 2] call CBA_fnc_formatNumber); 
    }]; 
} forEach [ 
    [5141, floor (_currentValue / 3600)], 
    [5142, floor (_currentValue / 60 % 60)], 
    [5143, floor (_currentValue % 60)] 
]; 
 
 
_timeCtrl setVariable ["cba_settings_fnc_updateUI", { 
    params ["_timeCtrl", "_value"]; 
 
    (_timeCtrl controlsGroupCtrl 5140) sliderSetPosition _value; 
    (_timeCtrl controlsGroupCtrl 5141) ctrlSetText ([floor (_value / 3600), 2] call CBA_fnc_formatNumber); 
    (_timeCtrl controlsGroupCtrl 5142) ctrlSetText ([floor (_value / 60 % 60), 2] call CBA_fnc_formatNumber); 
    (_timeCtrl controlsGroupCtrl 5143) ctrlSetText ([floor (_value % 60), 2] call CBA_fnc_formatNumber); 
}]; 

//Prevent enter key from closing display and setting new time
_display displayAddEventHandler ["KeyDown", {
	params ["_display", "_key", "_shift", "_ctrl", "_alt"];

	// DIK_RETURN = 28, DIK_NUMPADENTER = 156
	(_key in [28, 156]);
}];
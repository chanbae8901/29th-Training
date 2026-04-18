#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Initializes the ACE medical overlay while in spectator mode.
 * The panel is hidden by default; press H to toggle it.
 * Polls the ACE spectator camera focus to refresh
 * medical data. Cleans itself up when TN_spectator_exited fires.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_spectator_fnc_aceMedicalInit
 */

if (!hasInterface) exitWith {};

// Remove any leftover PFH from a previous spectator session.
if (!isNil QGVAR(medicalPFH)) then {
    [GVAR(medicalPFH)] call CBA_fnc_removePerFrameHandler;
};

GVAR(medicalFocusedUnit) = objNull;
GVAR(medicalVisible) = false;

private _spectatorDisplay = findDisplay 60000;

// Create the medical panel directly on the spectator display so it renders
// in the same coordinate space as the focus widget (outside the safe zone).
private _r = (safeZoneW / safeZoneH) min 1.2;
private _medH = 6.35 * (_r / 1.2) / 25;
private _medW = 5.1 * _r / 40;
private _focusPos = ctrlPosition (_spectatorDisplay displayCtrl 60030);
private _medCtrl = _spectatorDisplay ctrlCreate ["RscStructuredText", -1];
_medCtrl ctrlSetBackgroundColor [0, 0, 0, 0.5];
_medCtrl ctrlSetFont "RobotoCondensed";
_medCtrl ctrlSetFontHeight ((_r / 1.2) / 28);
_medCtrl ctrlSetPosition [
    (_focusPos # 0) + (_focusPos # 2),
    (_focusPos # 1) + (_focusPos # 3) / 2 - _medH / 2,
    _medW,
    _medH
];
_medCtrl ctrlCommit 0;
_medCtrl ctrlShow false;
uiNamespace setVariable [QGVAR(medicalCtrl), _medCtrl];

_spectatorDisplay displayAddEventHandler ["KeyDown", {
    params ["", "_key"];
    if !(_key isEqualTo 35) exitWith { false };
    GVAR(medicalVisible) = !GVAR(medicalVisible);
    if (GVAR(medicalVisible)) then {
        call FUNC(updateMedicalDisplay);
    } else {
        (uiNamespace getVariable [QGVAR(medicalCtrl), controlNull]) ctrlShow false;
    };
    true
}];

GVAR(medicalPFH) = [{
    if (!GVAR(medicalVisible)) exitWith {};
    private _target = missionNamespace getVariable ["ace_spectator_camFocus", objNull];
    GVAR(medicalFocusedUnit) = if (!isNull _target && {_target isKindOf "CAManBase"}) then {
        _target
    } else {
        objNull
    };
    call FUNC(updateMedicalDisplay);
}] call CBA_fnc_addPerFrameHandler;

GVAR(medicalExitEH) = [QGVAR(exited), {
    if (!isNil QGVAR(medicalPFH)) then {
        [GVAR(medicalPFH)] call CBA_fnc_removePerFrameHandler;
        GVAR(medicalPFH) = nil;
    };
    private _ctrl = uiNamespace getVariable [QGVAR(medicalCtrl), controlNull];
    if (!isNull _ctrl) then { ctrlDelete _ctrl };
    uiNamespace setVariable [QGVAR(medicalCtrl), nil];
    GVAR(medicalFocusedUnit) = nil;
    GVAR(medicalVisible) = nil;
    [QGVAR(exited), GVAR(medicalExitEH)] call CBA_fnc_removeEventHandler;
}] call CBA_fnc_addEventHandler;

nil

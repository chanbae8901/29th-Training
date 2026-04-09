#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Validates user-facing eventSettings.sqf variables. Only the
 * variables that are actually consumed by the event module are
 * checked, and each check is gated on the same condition that
 * enables its consumer. Problems are surfaced to the local
 * player via systemChat — eventSettings.sqf runs on every
 * machine, so each client validates its own namespace.
 *
 * Should be called immediately after eventSettings.sqf is loaded.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_validateSettings;
 */

if (!hasInterface) exitWith {};

#define PREFIX "eventSettings.sqf: "
#define T_BOOL "a boolean"
#define T_NUM "a number"
#define T_POSNUM "a positive number"
#define T_NONNEG "a non-negative number"

private _errors = [];

private _fnCheck = {
    params ["_name", "_value", "_typeStr", "_ok"];
    if (!_ok) then {
        _errors pushBack format
            [PREFIX + "%1 is missing or not %2", _name, _typeStr];
    };
};

private _isNum = {
    !isNil "_this" && { _this isEqualType 0 }
};
private _isBool = {
    !isNil "_this" && { _this isEqualType false }
};
private _isPosNum = {
    !isNil "_this" && { _this isEqualType 0 } && { _this > 0 }
};
private _isNonNegNum = {
    !isNil "_this" && { _this isEqualType 0 } && { _this >= 0 }
};

/******* Always-used toggles *******/
["hasTimer", GVAR(hasTimer), T_BOOL,
    GVAR(hasTimer) call _isBool] call _fnCheck;
["hasAliveCheck", GVAR(hasAliveCheck), T_BOOL,
    GVAR(hasAliveCheck) call _isBool] call _fnCheck;
["checkWinConditions", GVAR(checkWinConditions), T_BOOL,
    GVAR(checkWinConditions) call _isBool] call _fnCheck;
["autoMarkObjects", GVAR(autoMarkObjects), T_BOOL,
    GVAR(autoMarkObjects) call _isBool] call _fnCheck;
["disableStatistics", GVAR(disableStatistics), T_BOOL,
    GVAR(disableStatistics) call _isBool] call _fnCheck;
["numberOfLives", GVAR(numberOfLives), T_NONNEG,
    GVAR(numberOfLives) call _isNonNegNum] call _fnCheck;
["timeAcc", GVAR(timeAcc), T_POSNUM,
    GVAR(timeAcc) call _isPosNum] call _fnCheck;
["arsenalRadius", GVAR(arsenalRadius), T_POSNUM,
    GVAR(arsenalRadius) call _isPosNum] call _fnCheck;

/******* Timer-gated *******/
if ((GVAR(hasTimer) isEqualType false) && {GVAR(hasTimer)}) then {
    ["forcedSafeStart", GVAR(forcedSafeStart), T_NONNEG,
        GVAR(forcedSafeStart) call _isNonNegNum] call _fnCheck;
    ["readySafeStart", GVAR(readySafeStart), T_NONNEG,
        GVAR(readySafeStart) call _isNonNegNum] call _fnCheck;
    ["timerLength", GVAR(timerLength), T_POSNUM,
        GVAR(timerLength) call _isPosNum] call _fnCheck;

    if (isNil QGVAR(timerObjects) || {!(GVAR(timerObjects) isEqualType [])}) then {
        _errors pushBack (PREFIX + "timerObjects is missing or not an array");
    } else {
        {
            if (isNil "_x" || {!(_x isEqualType objNull)} || {isNull _x}) then {
                _errors pushBack format
                    [PREFIX + "timerObjects[%1] is missing or not a valid object", _forEachIndex];
            };
        } forEach GVAR(timerObjects);
    };
};

/******* Spectate/respawn-gated *******/
private _needSpectate = (GVAR(hasAliveCheck) isEqualType false && {GVAR(hasAliveCheck)})
    || {GVAR(numberOfLives) isEqualType 0 && {GVAR(numberOfLives) > 0}};
if (_needSpectate) then {
    if (isNil QGVAR(spectateArea)
        || {!(GVAR(spectateArea) isEqualType objNull)}
        || {isNull GVAR(spectateArea)}) then {
        _errors pushBack (PREFIX + "spectateArea is missing or not a valid object");
    };
};

if (GVAR(hasAliveCheck) isEqualType false && {GVAR(hasAliveCheck)}) then {
    ["spectateAreaRadius", GVAR(spectateAreaRadius), T_POSNUM,
        GVAR(spectateAreaRadius) call _isPosNum] call _fnCheck;
};

if (GVAR(numberOfLives) isEqualType 0 && {GVAR(numberOfLives) > 0}) then {
    ["respawnDisarmPlayers", GVAR(respawnDisarmPlayers), T_BOOL,
        GVAR(respawnDisarmPlayers) call _isBool] call _fnCheck;
};

/******* Win-condition-gated *******/
if (GVAR(checkWinConditions) isEqualType false && {GVAR(checkWinConditions)}) then {
    ["winCheckInterval", GVAR(winCheckInterval), T_POSNUM,
        GVAR(winCheckInterval) call _isPosNum] call _fnCheck;

    if (isNil QGVAR(score)
        || {!(GVAR(score) isEqualType [])}
        || {count GVAR(score) != 3}
        || {(GVAR(score) findIf {!(_x isEqualType 0)}) != -1}) then {
        _errors pushBack (PREFIX + "score must be an array of 3 numbers [OPFOR, BLUFOR, GRNFOR]");
    };

    {
        private _name = _x;
        private _val = missionNamespace getVariable [_name, nil];
        private _bad = false;
        if (isNil "_val") then {
            _bad = true;
        } else {
            if (_val isEqualType "") then {
                // "" is the only valid string; anything else is wrong
                if (_val != "") then { _bad = true };
            } else {
                if (!(_val isEqualType [])
                    || {count _val != 2}
                    || {!(_val select 0 isEqualType 0)}
                    || {!(_val select 1 isEqualType false)}) then {
                    _bad = true;
                };
            };
        };
        if (_bad) then {
            _errors pushBack format
                [PREFIX + "%1 must be \"\" or [pointsRequired (number), atEnd (boolean)]", _name];
        };
    } forEach [
        QGVAR(bluforWinConditions),
        QGVAR(opforWinConditions),
        QGVAR(grnforWinConditions)
    ];
};

/******* Report *******/
{ systemChat _x } forEach _errors;

nil

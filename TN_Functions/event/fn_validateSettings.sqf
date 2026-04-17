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

#define ERR_PREFIX "eventSettings.sqf: "
#define T_BOOL "a boolean"
#define T_POSNUM "a positive number"
#define T_NONNEG "a non-negative number"

private _errors = [];
private _infos = [];

private _fnCheck = {
    params ["_name", "_typeStr", "_ok"];
    if (!_ok) then {
        _errors pushBack format
            [ERR_PREFIX + "%1 is missing or not %2", _name, _typeStr];
    };
};

private _fnInfoDefault = {
    params ["_name", "_default"];
    _infos pushBack format
        [ERR_PREFIX + "%1 not set, using default %2", _name, _default];
};

private _isTrue = {
    _this isEqualType false && {_this}
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
["useRoundSystem", T_BOOL,
    GVAR(useRoundSystem) call _isBool] call _fnCheck;
["checkWinConditions", T_BOOL,
    GVAR(checkWinConditions) call _isBool] call _fnCheck;
["autoMarkObjects", T_BOOL,
    GVAR(autoMarkObjects) call _isBool] call _fnCheck;
["disableStatistics", T_BOOL,
    GVAR(disableStatistics) call _isBool] call _fnCheck;
["timeAcc", T_POSNUM,
    GVAR(timeAcc) call _isPosNum] call _fnCheck;
if (isNil QGVAR(arsenalRadius)) then {
    ["arsenalRadius", 75] call _fnInfoDefault;
} else {
    ["arsenalRadius", T_POSNUM,
        GVAR(arsenalRadius) call _isPosNum] call _fnCheck;
};

/******* Round-gated *******/
if (GVAR(useRoundSystem) call _isTrue) then {
    ["forcedSafeStart", T_NONNEG,
        GVAR(forcedSafeStart) call _isNonNegNum] call _fnCheck;
    ["readySafeStart", T_NONNEG,
        GVAR(readySafeStart) call _isNonNegNum] call _fnCheck;
    ["timerLength", T_POSNUM,
        GVAR(timerLength) call _isPosNum] call _fnCheck;

    if (isNil QGVAR(timerObjects) || {!(GVAR(timerObjects) isEqualType [])}) then {
        _errors pushBack (ERR_PREFIX + "timerObjects is missing or not an array");
    } else {
        {
            if (isNil "_x" || {!(_x isEqualType objNull)} || {isNull _x}) then {
                _errors pushBack format
                    [ERR_PREFIX + "timerObjects[%1] is missing or not a valid object", _forEachIndex];
            };
        } forEach GVAR(timerObjects);
    };

    ["disableScoreboard", T_BOOL,
        GVAR(disableScoreboard) call _isBool] call _fnCheck;
    ["stopTimeUntilLive", T_BOOL,
        GVAR(stopTimeUntilLive) call _isBool] call _fnCheck;
    ["numberOfLives", T_NONNEG,
        GVAR(numberOfLives) call _isNonNegNum] call _fnCheck;

    /******* Lives-gated (numberOfLives > 0) *******/
    if (GVAR(numberOfLives) call _isPosNum) then {
        ["penalizeJIPLives", T_BOOL,
            GVAR(penalizeJIPLives) call _isBool] call _fnCheck;
        ["hasAliveCheck", T_BOOL,
            GVAR(hasAliveCheck) call _isBool] call _fnCheck;
    };
};

/******* Win-condition-gated *******/
if (GVAR(checkWinConditions) call _isTrue) then {
    if (isNil QGVAR(score)
        || {!(GVAR(score) isEqualType [])}
        || {count GVAR(score) isNotEqualTo 3}
        || {(GVAR(score) findIf {!(_x isEqualType 0)}) isNotEqualTo -1}) then {
        _errors pushBack (ERR_PREFIX + "score must be an array of 3 numbers [OPFOR, BLUFOR, GRNFOR]");
    };

    {
        private _val = missionNamespace getVariable [_x, nil];
        private _ok = if (isNil "_val") then {false} else {
            _val isEqualTo []
            || {_val isEqualType []
                && {count _val isEqualTo 2}
                && {_val select 0 isEqualType 0}
                && {_val select 1 isEqualType false}}
        };
        if (!_ok) then {
            _errors pushBack format
                [ERR_PREFIX + "%1 must be [] or [pointsRequired (number), atEnd (boolean)]", _x];
        };
        if (_ok && {_val isEqualType []} && {count _val isEqualTo 2} && {_val select 1} && {!GVAR(useRoundSystem)}) then {
            _errors pushBack format
                [ERR_PREFIX + "%1 has atEnd = true but useRoundSystem is false. atEnd only works with useRoundSystem = true", _x];
        };
    } forEach [
        QGVAR(bluforWinConditions),
        QGVAR(opforWinConditions),
        QGVAR(grnforWinConditions)
    ];
};

/******* Report *******/
{ systemChat _x } forEach _errors;
{ systemChat _x } forEach _infos;

nil

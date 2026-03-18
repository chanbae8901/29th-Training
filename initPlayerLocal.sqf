#include "data\defines.hpp"

#define HIDE_ENTITY_DELAY 1.0
#define CHAT_FIX_DELAY 0.1

/*
Executed locally (only on client) when player joins mission
(includes both mission start and JIP)
*/

diag_log text format [
    "|=============================   %1: initPlayerLocal.sqf Running   =============================|",
    missionName
];

params ["_unit", "_didJIP"];

enableSentences false;
enableEnvironment [false, true];

//maintains a neutral rating in the event of "accidental" team kills
_unit addEventHandler ["HandleRating", {0}];

// ====== Misfire prevention. ==========
[{currentWeapon (_this select 0) != ""}, {
    params ["_unit"];
    if !(weaponLowered _unit) then
    {
        _unit action ["WeaponOnBack", _unit];
    };
}, [_unit]] call CBA_fnc_waitUntilAndExecute;

// ====== Prevent respawn showing up on old unit for split second.==========
["Man", "Init", {
    params ["_entity"];
    if (local _entity) exitWith {};
    _entity hideObject true;
    [{
        (_this select 0) hideObject false;
    }, [_entity], HIDE_ENTITY_DELAY] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addClassEventHandler;

// ====== Fix inconsistent bug where chat is no longer displayed after leaving main menu ======
["TN_exitedPauseMenu", {
    [{showChat true}, [], CHAT_FIX_DELAY] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

diag_log text format [
    "|=============================   %1: initPlayerLocal.sqf Finished   =============================|",
    missionName
];

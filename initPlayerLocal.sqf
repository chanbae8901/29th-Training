#include "script_macros.hpp"
#include "data\templates.hpp"

#define HIDE_ENTITY_DELAY 1.0
#define HIDE_RECOVERY_INTERVAL 5
#define HIDE_RECOVERY_TIMEOUT 8
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
[{currentWeapon (_this select 0) isNotEqualTo ""}, {
    params ["_unit"];
    if !(weaponLowered _unit) then {
        _unit action ["WeaponOnBack", _unit];
    };
}, [_unit]] call CBA_fnc_waitUntilAndExecute;

// ====== Prevent respawn showing up on old unit for split second.==========
addMissionEventHandler ["EntityCreated", {
    params ["_entity"];
    if (!(_entity isKindOf "CAManBase") || local _entity) exitWith {};
    _entity hideObject true;
    // Stamp the entity so the safety sweep below can recognize hides set by THIS
    // handler (vs. intentional hides from spectator, Zeus, etc.).
    _entity setVariable [QGVARMAIN(respawnHideTime), diag_tickTime];
    [{
        params ["_entity"];
        if (isNull _entity) exitWith {};
        _entity hideObject false;
        _entity setVariable [QGVARMAIN(respawnHideTime), nil];
    }, [_entity], HIDE_ENTITY_DELAY] call CBA_fnc_waitAndExecute;
}];

//NOTE: Below theorized by Claude, not confirmed. Very skeptical it fixes anything.
// ====== Safety sweep: recover from orphaned local hides ==========
// Race-condition recovery for the handler above. Under server/network load or
// rapid respawn, the timer-based unhide can race with entity replication,
// leaving a remote player stuck-hidden on this client with no recovery path.
// Every HIDE_RECOVERY_INTERVAL seconds, scan remote players: if one is locally
// hidden AND was hidden by our handler (TN_respawnHideTime set) AND the stamp
// is older than HIDE_RECOVERY_TIMEOUT, force-clear the hide. The stamp marker
// ensures we never disturb intentional hides (spectator hideObjectGlobal etc.).
[{
    {
        private _stamp = _x getVariable [QGVARMAIN(respawnHideTime), -1];
        if (
            !(local _x)
            && {alive _x}
            && {isObjectHidden _x}
            && {_stamp > 0}
            && {diag_tickTime - _stamp > HIDE_RECOVERY_TIMEOUT}
        ) then {
            _x hideObject false;
            _x setVariable [QGVARMAIN(respawnHideTime), nil];
            systemChat format ["Fix: Unhid invisible player %1.", name _x];
        };
    } forEach (allPlayers - entities "HeadlessClient_F" - [player]);
}, HIDE_RECOVERY_INTERVAL, []] call CBA_fnc_addPerFrameHandler;

// ====== Fix inconsistent bug where chat is no longer displayed after leaving main menu ======
[QGVARMAIN(exitedPauseMenu), {
    [{showChat true}, [], CHAT_FIX_DELAY] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

diag_log text format [
    "|=============================   %1: initPlayerLocal.sqf Finished   =============================|",
    missionName
];

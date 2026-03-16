/**
 * Function: TN_loadout_fnc_setInsignia
 * Author:   Bae [29th ID], modified from Hill [29th ID]
 *
 * Purpose: If a unit has a valid 29th squad.xml configuration, applies
 *          the appropriate insignia to their uniform. Members get
 *          the non-drab/non-combat variant when not in a combat loadout.
 *
 * Params:  _target - Object, local unit wearing a uniform
 * Returns: true if insignia was applied, false otherwise
 *
 * Example: player spawn TN_loadout_fnc_setInsignia
 */

if !(TN_setInsignia) exitWith { false };

// === Insignia Map ===
// Alternate non-combat version as second element in value.
private _insigniaMap = createHashMapFromArray [
    ["1st Bn. HQ",     ["BnHQ"]],
    ["Charlie Co. HQ", ["CoHQdrab", "CoHQ"]],
    ["CP1 HQ",         ["CP1drab", "CP1"]],
    ["CP2 HQ",         ["CP2drab", "CP2"]],
    ["CP1S1",          ["CP1S1"]],
    ["CP1S2",          ["CP1S2", "CP1S2colour"]],
    ["CP1S3",          ["CP1S3"]],
    ["CP2S1",          ["CP2S1"]],
    ["CP2S2",          ["CP2S2drab", "CP2S2"]],
    ["CP2S3",          ["CP2S3"]]
];

params [["_target", objNull, [objNull]]];

if (isNull _target) exitWith
{
    ["Invalid parameters."] call BIS_fnc_error;
    false;
};

if (!local _target) exitWith
{
    ["%1 must be local.", _target] call BIS_fnc_error;
    false;
};

if (!isClass (configFile >> "CfgPatches" >> "29th_Insignias"))
    exitWith
{
    //["29th Insignias not found."] call BIS_fnc_error;
    false;
};

waitUntil { sleep 0.5; !isNull _target && alive _target };

private [
    "_sqdParams", "_targetRole", "_targetSquad",
    "_foundInsignias", "_targetInsignia", "_curInsignia"
];

_sqdParams = squadParams _target;

if (count _sqdParams == 0) exitWith
{
    //["squad.xml info not found."] call BIS_fnc_error;
    false;
};

// Get squad string stored in memberICQ.
_targetSquad = ((_sqdParams select 1) select 4);
_foundInsignias = _insigniaMap getOrDefault [_targetSquad, []];

if (count _foundInsignias == 0) exitWith
{
    //["Insignia matching %1 not found", _targetSquad] call BIS_fnc_error; //Can be from other company, don't throw error
    false;
};

// Default to only/combat variant.
_targetInsignia = _foundInsignias select 0;

// Non-combat variant exists.
if (count _foundInsignias == 2) then
{
    // BLUFOR parade gear, dress blues, or no weapon.
    private _isNotCombatLoadout = _target call TN_parade_fnc_checkNonCombatLoadout;

    // Use non-combat version.
    if (_isNotCombatLoadout) then
    {
        _targetInsignia = _foundInsignias select 1;
    };
};

_curInsignia = _target call BIS_fnc_getUnitInsignia;

// Don't replace Clerk or Sniper Insignia if they already have one,
// so they can use their squad insignia.
_targetRole = ((_sqdParams select 1) select 5);

if (_targetRole find "Clerk" != -1
    || _targetRole find "Sniper" != -1) then
{
    if (_curInsignia != "") exitWith {};
};

if (_curInsignia != _targetInsignia
    && _curInsignia != "") then
{
    systemChat ("Insignia swapped to " + _targetInsignia + ".");
};

[_target, ""] call BIS_fnc_setUnitInsignia;
[_target, _targetInsignia] call BIS_fnc_setUnitInsignia;

/*
 * Author: Bae [29th ID], modified from Hill [29th ID]
 * If a unit has a valid 29th squad.xml configuration, applies
 * the appropriate insignia to their uniform. Members get
 * the non-drab/non-combat variant when not in a combat loadout.
 *
 * Arguments:
 * 0: Local unit wearing a uniform <OBJECT> (default: objNull)
 *
 * Return Value:
 * True if insignia was applied, false otherwise <BOOL>
 *
 * Example:
 * player spawn TN_loadout_fnc_setInsignia;
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
    false;
};

waitUntil { sleep 0.5; !isNull _target && alive _target };

private [
    "_sqdParams", "_targetRole", "_targetSquad",
    "_foundInsignias", "_targetInsignia", "_curInsignia"
];

_sqdParams = squadParams _target;

if (_sqdParams isEqualTo []) exitWith
{
    false;
};

// Get squad string stored in memberICQ.
_targetSquad = ((_sqdParams select 1) select 4);
_foundInsignias = _insigniaMap getOrDefault [_targetSquad, []];

if (_foundInsignias isEqualTo []) exitWith
{
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

if ("Clerk" in _targetRole
    || "Sniper" in _targetRole) then
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

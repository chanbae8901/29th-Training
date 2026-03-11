/**
 * File: fn_getName.sqf
 * Function: DOTT_tracker_fnc_getName
 * Author: Bae [29th ID]
 *
 * Purpose:
 * Returns the display name for a unit. For infantry, uses the
 * player name (falling back to cached DOTT_name if dead). For
 * vehicles, uses the config display name.
 *
 * Parameters:
 * _unit (Object): Player or vehicle to get the name of.
 *
 * Returns:
 * String -- the unit's display name, or "?" if null.
 */

params ["_unit"];

// Placeholder for null units (e.g. deleted unit whose
// placed mine still explodes).
private _name = "?";
if (isNull _unit) exitWith { _name };

if (_unit isKindOf "Man") then
{
    if (alive _unit) then
    {
        _name = name _unit;
    }
    else
    {
        _name = _unit getVariable ["DOTT_name", "?"];
    };
}
else
{
    _name = getText (
        configFile >> "CfgVehicles"
        >> typeOf _unit >> "displayName"
    );
    if (_name == "") then { _name = "Vehicle" };
};

_name

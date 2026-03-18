#include "..\..\data\templates.hpp"

/*
 * Author: Bae [29th ID]
 * PFH body that checks if the player is within arsenal
 * zone radius and adds/removes the arsenal action
 * accordingly. Also toggles environment sounds.
 *
 * Arguments:
 * PFH args: [radiusSquared]
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [{ call TN_base_fnc_arsenalZoneCheck }, 1, [_radiusSquared]] call CBA_fnc_addPerFrameHandler;
 */

#define ENV_ON 1 fadeEnvironment 1
#define ENV_OFF 1 fadeEnvironment 0

params ["_args", "_handle"];
_args params ["_radiusSquared"];

private _inZone = false;
{
    if ((getPosASL player) distanceSqr _x <= _radiusSquared) exitWith
    {
        _inZone = true;
    };
} forEach TN_arsenal_centers;

if (_inZone) then
{
    if (arsenalActionId == -1) then
    {
        if !(TN_base_keepEnvironmentSounds) then
        {
            ENV_OFF;
        };

        if (isClass (configFile >> "CfgPatches" >> "ace_main")) then
        {
            arsenalActionId = player addAction [
                "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Ace Arsenal</t>",
                {
                    [_this select 1, _this select 1, true] call ace_arsenal_fnc_openBox;
                },
                nil, 1.5, true, true, "", "true"
            ];
        }
        else
        {
            arsenalActionId = player addAction [
                "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Virtual Arsenal</t>",
                {
                    ["Open", true] spawn BIS_fnc_arsenal;
                },
                nil, 1.5, true, true, "", "true"
            ];
        };
    };
}
else
{
    if (arsenalActionId != -1) then
    {
        ENV_ON;
        player removeAction arsenalActionId;
        arsenalActionId = -1;
    };
};

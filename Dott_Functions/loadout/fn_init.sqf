/**
 * Function: TN_loadout_fnc_init
 * Author:   Bae [29th ID]
 *
 * Purpose: Initializes the loadout module on clients. Registers arsenal
 *          close handlers for both BI and ACE arsenals, and sets up
 *          insignia reapplication on respawn.
 *          Should be initialized after the radio module.
 *
 * Params:  None
 * Returns: Nothing
 *
 * Example: call TN_loadout_fnc_init;
 */

if (hasInterface) then
{
    [
        missionNamespace,
        "arsenalClosed",
        {
            // Don't do if Zeus Open (ZEN Loadout Editing).
            if !(isNull (findDisplay 312)) exitWith {};
            call TN_loadout_fnc_onArsenalClosed;
        }
    ] call BIS_fnc_addScriptedEventHandler;

    if (isClass (configFile >> "CfgPatches" >> "ace_main"))
        then
    {
        [
            "ace_arsenal_displayClosed",
            {
                // Don't do if Zeus Open (ZEN Loadout Editing).
                if !(isNull (findDisplay 312)) exitWith {};
                call TN_loadout_fnc_onArsenalClosed;
            }
        ] call CBA_fnc_addEventHandler;
    };

    [
        "TN_loadout_setInsigniaRespawn",
        "Respawn",
        {
            (_this select 0) spawn TN_loadout_fnc_setInsignia;
        }
    ] call CBA_fnc_addBISPlayerEventHandler;
};

if (isServer) then
{

};

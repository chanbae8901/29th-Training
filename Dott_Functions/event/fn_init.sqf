/**
 * DOTT_event_fnc_init
 *
 * Initializes the event variation of the mission template.
 * Loads event settings, wires up timer / alive-check /
 * respawn / time-acceleration handlers, marks editor-placed
 * objects, and prepares respawn inventory.
 *
 * Should be called after round initialization.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call DOTT_event_fnc_init;
 */

/******** CONFIG ********/
call compile preprocessFileLineNumbers "eventSettings.sqf";

/******* Timer ********/
if (DOTT_event_hasTimer) then
{
    if (hasInterface) then
    {
        call DOTT_event_fnc_flagActions;
    };

    if (isServer) then
    {
        [
            "DOTT_round_started",
            {
                [] spawn DOTT_event_fnc_checkWinCondition;
            }
        ] call CBA_fnc_addEventHandler;
    };
};

/******* AliveCheck ********/
if (DOTT_event_hasAliveCheck || DOTT_event_numberOfLives > 0) then
{
    if (isNil "DOTT_event_spectateArea") then
    {
        systemChat "WARNING: Spectate area object (spectateArea) not found!";
    };
};

if (DOTT_event_hasAliveCheck) then
{
    if (isServer) then
    {
        [
            "DOTT_round_started",
            {
                [] spawn DOTT_event_fnc_aliveCheck;
            }
        ] call CBA_fnc_addEventHandler;
    };
};

if (DOTT_event_numberOfLives > 0) then
{
    if (hasInterface) then
    {
        [
            "DOTT_event_respawn",
            "Respawn",
            { [] spawn DOTT_event_fnc_respawn }
        ] call CBA_fnc_addBISPlayerEventHandler;
    };
};

/******* Time Acceleration ********/
if (isServer) then
{
    [
        "DOTT_round_started",
        {
            setTimeMultiplier DOTT_event_timeAcc;
        }
    ] call CBA_fnc_addEventHandler;
};

/******* Auto Mark Editor Objects ********/
if (hasInterface) then
{
    if (DOTT_event_autoMarkObjects) then
    {
        call DOTT_event_fnc_markEditorPlacedObjects;
    };
};

/******* Everything else ********/
if (hasInterface) then
{
    [] spawn
    {
        //Prevent error due to no saved respawn inventory
        waitUntil { !isNull player };
        [player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;
    };

    //Hide map markers belonging to opposing sides
    {
        _x setMarkerAlphaLocal 0;
    } count (allMapMarkers select {
        private _marker = _x;
        !([east, west, civilian, independent] select {
            _marker find toLower str _x != -1
        } isEqualTo [])
        && {
            _x find toLower str playerSide == -1
        }
    });
};

if (isServer) then
{

};

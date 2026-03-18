#include "..\..\data\roundState.hpp"

/*
 * Author: Bae [29th ID]
 * Initializes the event variation of the mission template.
 * Loads event settings, wires up timer / alive-check /
 * respawn / time-acceleration handlers, marks editor-placed
 * objects, and prepares respawn inventory.
 *
 * Should be called after round initialization.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_event_fnc_init;
 */

/******** CONFIG ********/
call compile preprocessFileLineNumbers "eventSettings.sqf";

/******* Timer ********/
if (TN_event_hasTimer) then
{
    if (hasInterface) then
    {
        [{!isNull player}, {
            call TN_event_fnc_flagActions;
        }] call CBA_fnc_waitUntilAndExecute;
    };

    if (isServer) then
    {
        [
            "TN_round_started",
            {
                [] spawn TN_event_fnc_checkWinCondition;
            }
        ] call CBA_fnc_addEventHandler;
    };
};

/******* AliveCheck ********/
if (TN_event_hasAliveCheck || TN_event_numberOfLives > 0) then
{
    if (isNil "TN_event_spectateArea") then
    {
        systemChat "WARNING: Spectate area object (spectateArea) not found!";
    };
};

if (TN_event_hasAliveCheck) then
{
    if (isServer) then
    {
        [
            "TN_round_started",
            {
                [] spawn TN_event_fnc_aliveCheck;
            }
        ] call CBA_fnc_addEventHandler;
    };
};

if (TN_event_numberOfLives > 0) then
{
    if (hasInterface) then
    {
        [
            "TN_event_respawn",
            "Respawn",
            { [] spawn TN_event_fnc_respawn }
        ] call CBA_fnc_addBISPlayerEventHandler;
    };
};

/******* Time Acceleration ********/
if (isServer) then
{
    [
        "TN_round_started",
        {
            setTimeMultiplier TN_event_timeAcc;
        }
    ] call CBA_fnc_addEventHandler;
};

/******* Auto Mark Editor Objects ********/
if (hasInterface) then
{
    if (TN_event_autoMarkObjects) then
    {
        call TN_event_fnc_markEditorPlacedObjects;
    };
};

/******* Everything else ********/
if (hasInterface) then
{
    //Prevent error due to no saved respawn inventory
    [{!isNull player}, {
        [player, [missionNamespace, "Current Inventory"]] call BIS_fnc_saveInventory;
        [player, ["missionNamespace:Current Inventory"]] call BIS_fnc_setRespawnInventory;
    }] call CBA_fnc_waitUntilAndExecute;

    //Hide map markers belonging to opposing sides
    {
        _x setMarkerAlphaLocal 0;
    } count (allMapMarkers select {
        private _marker = _x;
        !([east, west, civilian, independent] select {
            toLower str _x in _marker
        } isEqualTo [])
        && {
            !(toLower str playerSide in _x)
        }
    });
};

if (isServer) then
{
    addMissionEventHandler ["HandleDisconnect",
    {
        params ["_unit"];

        if (isNull _unit) exitWith {};

        if (NOT_ROUND_LIVE) then
        {
            deleteVehicle _unit;
        };

        false
    }];
};

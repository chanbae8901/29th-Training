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

            if (serverCommandAvailable "#lock") then
            {
                [true]
                    call TN_event_fnc_handleAdminEventMenu;
            };
        }] call CBA_fnc_waitUntilAndExecute;
    };

    if (isServer) then
    {
        addMissionEventHandler [
            "OnUserAdminStateChanged",
        {
            params ["_networkId", "_loggedIn"];

            private _userInfo = getUserInfo _networkId;
            if (count _userInfo < 11) exitWith {};

            private _unit = _userInfo select 10;
            if (isNil "_unit") exitWith {};

            [_loggedIn] remoteExecCall [
                "TN_event_fnc_handleAdminEventMenu",
                owner _unit
            ];
        }];

        [
            "TN_round_started",
            {
                call TN_event_fnc_checkWinCondition;
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
                call TN_event_fnc_aliveCheck;
            }
        ] call CBA_fnc_addEventHandler;
    };
};

if (TN_event_numberOfLives > 0) then
{
    if (hasInterface) then
    {
        [
            "TN_round_started",
            { [true] call TN_event_fnc_respawn }
        ] call CBA_fnc_addEventHandler;

        [
            "TN_event_respawn",
            "Respawn",
            { call TN_event_fnc_respawn }
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
    private _sideStrings = [east, west, civilian, independent]
        apply { toLowerANSI str _x };
    private _playerSideStr = toLowerANSI str playerSide;
    {
        _x setMarkerAlphaLocal 0;
    } count (allMapMarkers select {
        private _marker = _x;
        _sideStrings findIf { _x in _marker } > -1
        && {
            !(_playerSideStr in _x)
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

nil

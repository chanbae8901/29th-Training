/**
 * DOTT_event_fnc_game
 *
 * Manages round endings by forcing a specific side victory,
 * neutral ending, or named ending class. Redirects to server
 * if called on a client. Prevents duplicate endings via the
 * gameCalled guard.
 *
 * Parameters:
 *     _forceEnding      (bool)   - True to skip evaluations
 *                                  and force an ending.
 *     _sideVictory      (side)   - Winning side when forced.
 *                                  Omit for neutral ending.
 *     _forceEndingClass (string) - Named ending class from
 *                                  CfgDebriefing. Overrides
 *                                  _sideVictory if set.
 *
 * Returns:
 *     Nothing
 */

params
[
    ["_forceEnding", false, [false]],
    ["_sideVictory", sideUnknown],
    ["_forceEndingClass", "", [""]]
];

if (!isServer) exitWith
{
    _this remoteExecCall ["DOTT_event_fnc_game", 2];
};

/******** CONFIG ********/
private _endNeutral = "EndNeutral";
private _endWest = "EndWestVictory";
private _endEast = "EndEastVictory";
private _endResistance = "EndGuerVictory";


/************************/

// Prevents duplicate endings.
if (isNil "gameCalled") then
{
    gameCalled = false;
};
if (gameCalled) exitWith {};
gameCalled = true;
publicVariable "gameCalled";
["DOTT_event_gameCalled", []] call CBA_fnc_globalEvent;

if (_forceEnding) exitWith
{
    if (_forceEndingClass != "") then
    {
        [_forceEndingClass] remoteExec ["BIS_fnc_endMission"];
    }
    else
    {
        switch (_sideVictory) do
        {
            case west:
            {
                [_endWest] remoteExec ["BIS_fnc_endMission"];
            };
            case east:
            {
                [_endEast] remoteExec ["BIS_fnc_endMission"];
            };
            case resistance:
            {
                [_endResistance] remoteExec ["BIS_fnc_endMission"];
            };
            default
            {
                [_endNeutral] remoteExec ["BIS_fnc_endMission"];
            };
        };
    };
};

//NO EVAL RIGHT NOW - WILL BE WRITTEN LATER - Dott

//private _eventSectors =
//    missionnamespace getvariable
//        ["BIS_fnc_moduleSector_sectors", []];
//private _eventSectorCount =
//    count _eventSectors;

//["end1"] remoteExec ["BIS_fnc_endMission"];

//call{t_sector_1 getVariable "owner" == WEST}
//call{t_sector_1 enablesimulation false;}

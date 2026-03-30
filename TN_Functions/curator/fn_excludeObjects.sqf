#include "script_component.hpp"
/*
 * Author: Bae [29th ID], modified from Dott/Hill [29th ID]
 * Prevents important mission objects (those whose
 * variable name starts with "base_") from being editable
 * in Zeus. Iterates all editor-placed objects and flags
 * qualifying ones with "isCuratorExcluded". Then registers
 * a 3-second perFrameHandler that strips flagged objects
 * from every curator's editable list. The 3-second
 * interval is a balance between responsiveness (newly
 * added objects get removed quickly) and performance
 * (polling all curators and their editable objects is not
 * free).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_curator_fnc_excludeObjects;
 */

if (!isServer) exitWith {};

{ //forEach object placed in editor
    // Skip local-only objects (not network-synced).
    if (netId _x isEqualTo "0:0") then { continue };

    private _vicString = vehicleVarName _x;
    if (_vicString isEqualTo "") then { continue };

    _vicString = toLowerANSI _vicString;

    private _tags = _vicString splitString "_";

    private _baseObject = _tags select 0;
    if (_baseObject isNotEqualTo "base") then { continue };

    _x setVariable ["isCuratorExcluded", true, false];
}
forEach allMissionObjects "All";

[{
    {
        private _curator = _x;
        private _editableObjs =
            curatorEditableObjects _curator;
        private _objsToRemove = [];

        {
            if (
                !isNull _x
                && { _x getVariable [
                    "isCuratorExcluded", false
                ] }
            ) then {
                _objsToRemove pushBack _x;
            };
        } forEach _editableObjs;

        if (_objsToRemove isNotEqualTo []) then {
            _curator removeCuratorEditableObjects [
                _objsToRemove, true
            ];
        };
    } forEach allCurators;
}, 3] call CBA_fnc_addPerFrameHandler;

nil

/*
 * Function: DOTT_curator_fnc_excludeObjects
 * Author:   Bae [29th ID], modified from Dott/Hill [29th ID]
 *
 * Description:
 *     Prevents important mission objects (those whose
 *     variable name starts with "base_") from being editable
 *     in Zeus. On first run, iterates all editor-placed
 *     objects and flags qualifying ones with
 *     "isCuratorExcluded". Then enters a 3-second polling
 *     loop that strips flagged objects from every curator's
 *     editable list. The 3-second interval is a balance
 *     between responsiveness (newly added objects get removed
 *     quickly) and performance (polling all curators and
 *     their editable objects is not free).
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing (runs indefinitely in a spawned loop)
 *
 * Example:
 *     [] spawn DOTT_curator_fnc_excludeObjects;
 */

if (!isServer) exitWith {};

DOTT_script_curatorExcludedObjects = [] spawn
{
    { //forEach object placed in editor
        // Skip local-only objects (not network-synced).
        if (netId _x == "0:0") then { continue };

        //get variable name in string format, if empty then skip to next object
        private _vicString = vehicleVarName _x;
        if (_vicString isEqualTo "") then { continue };

        //make all lower case to reduce user errors
        _vicString = toLowerANSI _vicString;

        //create array of tags split with an underscore (E.G. "base_action_terminal_0" becomes ["base","action","terminal","0"] )
        private _tags = _vicString splitString "_";

        //if the first tag isn't "base", skip object, continue to next object in array
        private _baseObject = _tags select 0;
        if (_baseObject isNotEqualTo "base") then { continue };

        //set a flag on each object to indicate it should be excluded from Zeus editing
        _x setVariable ["isCuratorExcluded", true, false];
    }
    forEach allMissionObjects "All";

    while { true } do
    {
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
                ) then
                {
                    _objsToRemove pushBack _x;
                };
            } forEach _editableObjs;

            if (count _objsToRemove > 0) then
            {
                _curator removeCuratorEditableObjects [
                    _objsToRemove, true
                ];
            };
        } forEach allCurators;

        sleep 3;
    };
};

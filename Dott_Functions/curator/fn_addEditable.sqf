/*
 * Function: TN_curator_fnc_addEditable
 * Author:   Hill [29th ID]
 *
 * Description:
 *     Adds the given objects as editable for every active
 *     curator module. Headless clients are filtered out.
 *     Intended to be called on the server via remoteExec.
 *
 * Parameters:
 *     _objects - Array of Objects - Objects to make editable
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     [[player]] remoteExec [
 *         "TN_curator_fnc_addEditable", 2
 *     ];
 */

params ["_objects"];

_objects = _objects select {!(_x isKindOf "HeadlessClient_F")};

{
    _x addCuratorEditableObjects [_objects, true];
} forEach allCurators;

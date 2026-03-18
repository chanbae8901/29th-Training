/*
 * Author: Hill [29th ID]
 * Adds the given objects as editable for every active
 * curator module. Headless clients are filtered out.
 * Intended to be called on the server via remoteExec.
 *
 * Arguments:
 * 0: Objects to make editable <ARRAY>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [[player]] remoteExec ["TN_curator_fnc_addEditable", 2];
 */

params ["_objects"];

_objects = _objects select {!(_x isKindOf "HeadlessClient_F")};

{
    _x addCuratorEditableObjects [_objects, true];
} forEach allCurators;

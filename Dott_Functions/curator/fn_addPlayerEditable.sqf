/*
 * Function: DOTT_curator_fnc_addPlayerEditable
 * Author:   Hill [29th ID]
 *
 * Description:
 *     Adds the given player unit as an editable object for
 *     every active curator module. Headless clients are
 *     skipped since they should never appear in Zeus.
 *     Intended to be called on the server via remoteExec.
 *
 * Parameters:
 *     _unit - Object - Player unit to make editable
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     [player] remoteExec [
 *         "DOTT_curator_fnc_addPlayerEditable", 2
 *     ];
 */

params ["_unit"];

if (!(_unit isKindOf "HeadlessClient_F")) then
{
    {
        _x addCuratorEditableObjects [[_unit], true];
    } forEach allCurators;
};

/*
 * Author: Bae [29th ID]
 * Side-lookup that handles dead instigators whose group side
 * has already flipped to civilian.
 *
 * Arguments:
 * 0: Instigator <OBJECT>
 *
 * Return Value:
 * Side <SIDE>
 */

params ["_instigator"];
private _side = side (group _instigator);
if (_side isEqualTo sideUnknown
    || _side isEqualTo civilian) then // Dead man.
{
    // Might work improperly if zeus changed
    // player side.
    _side = getNumber (
        configOf _instigator >> "side"
    ) call BIS_fnc_sideType;
};
_side

/**
 * Function: TN_thermals_fnc_init
 * Author:   Bae [29th ID]
 *
 * Initializes the thermal restriction module.
 * - Client: monitors vision mode changes to black-screen on
 *   thermal use, and disables PIP thermal cameras on vehicle entry.
 * - Server: disables TI equipment on all current and future
 *   vehicles when the CBA setting is enabled.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Nothing
 *
 * Example:
 *     call TN_thermals_fnc_init;
 */

// --- Client-side: vision mode monitoring and PIP disable ---
if (hasInterface) then
{
    ["visionMode",
    {
        [] spawn TN_thermals_fnc_blackScreen;
    }] call CBA_fnc_addPlayerEventHandler;

    ["TN_disablePIPThermalsEvent", "GetInMan",
    {
        if !(TN_disableTI) exitWith {};

        // Brief delay required or PIP cameras won't shut off.
        [{
            call TN_thermals_fnc_disablePIP;
        }, [], 0.1] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addBISPlayerEventHandler;
};

// --- Server-side: disable TI on vehicles ---
if (isServer) then
{
    addMissionEventHandler ["EntityCreated",
    {
        private _objectCreated = _this;

        if (_objectCreated isKindOf "AllVehicles"
            && {!(_objectCreated isKindOf "Man")}) then
        {
            _objectCreated disableTIEquipment TN_disableTI;
        };
    }];

    {
        if !(_x isKindOf "Man") then
        {
            _x disableTIEquipment TN_disableTI;
        };
    } forEach allMissionObjects "AllVehicles";
};

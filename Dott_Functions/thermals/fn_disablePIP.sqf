/**
 * Function: TN_thermals_fnc_disablePIP
 * Author:   Bae [29th ID]
 *
 * Iterates every RenderTarget camera on the player's vehicle and
 * terminates any that use thermal vision (renderVisionMode == 2)
 * unless the camera belongs to the gunner turret.
 *
 * Must be called each time the player enters a vehicle.
 *
 * NOTE: The gunner turret is assumed to be turret path [0].
 * Vehicles with non-standard turret layouts (e.g. gunner on a
 * different index) will not have their gunner camera preserved.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     BOOL - true if at least one PIP camera was disabled
 *
 * Example:
 *     call TN_thermals_fnc_disablePIP;
 */

private _veh = vehicle player;
private _disabledSomething = false;

// --- Walk each render target and its sub-cameras ---
{
    private _rtCfg = _x;
    private _rtName = getText (_rtCfg >> "renderTarget");

    {
        private _camCfg = _x;
        private _visionMode = getNumber (
            _camCfg >> "renderVisionMode"
        );
        private _turret = getArray (
            _camCfg >> "turret"
        );

        // Skip gunner turret [0]; kill all other thermal PIPs.
        if (_visionMode == 2
            && {count _turret == 0
                || {_turret select 0 != 0}}) exitWith
        {
            _veh cameraEffect [
                "terminate", "back", _rtName
            ];
            _disabledSomething = true;
        };
    } forEach (configProperties [
        _rtCfg, "isClass _x", true
    ]);

} forEach (configProperties [
    configFile >> "CfgVehicles" >> typeOf _veh
        >> "RenderTargets",
    "isClass _x", true
]);

if (_disabledSomething) then
{
    systemChat "Disabled PIP Thermals";
};

_disabledSomething

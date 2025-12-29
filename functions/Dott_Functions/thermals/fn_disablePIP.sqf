/*
 * Name:	DOTT_thermals_fnc_disablePIP
 * Date:	9/2/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Checks every RenderTarget's camera of player vehicle and disables any that have thermal vision
 * that isn't attached to gunner turret.
 * Must be called every time player enters a vehicle.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true if at least one PIP camera disabled, false otherwise
 *
 * Example:
 * call DOTT_thermals_fnc_disablePIP;
 * 
 */
private _veh = vehicle player; 
private _disabledSomething = false;
{ 
    private _rtCfg = _x;                                    
    private _rtName = getText (_rtCfg >> "renderTarget");   
  
    { 
        private _camCfg = _x;                   
        private _visionMode = getNumber (_camCfg >> "renderVisionMode");  
        private _turret = getArray (_camCfg >> "turret");   
        if (_visionMode == 2 && (count _turret == 0 || {_turret select 0 != 0})) exitWith 
		{ 
			_veh CameraEffect ["terminate","back", _rtName];
			_disabledSomething = true; 
		}; 
    } forEach (configProperties [_rtCfg, "isClass _x", true]); 

} forEach (configProperties [configFile >> "CfgVehicles" >> typeOf _veh >> "RenderTargets", "isClass _x", true]);

if (_disabledSomething) then { systemChat "Disabled PIP Thermals" };

_disabledSomething
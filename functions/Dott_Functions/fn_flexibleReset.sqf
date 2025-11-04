/*
 * Name:	DOTT_fnc_flexibleReset
 * Date:	3/4/2024
 * Version: 1.1
 * Author:  Dott [29th ID]
 *
 * Description:
 * Optionally loads saved inventory, heals player, teleports them to a position, and notifies them.
 * Must be spawned on client
 *
 * Parameter(s) (All Optional): 
 * _inventory (Array/Boolean): Extended Loadout ARRAY (CBA) (default: empty array) OR true to use resetLoadout (for remoteExec purposes)
 * _heal (Bool): True if players should be healed (default: false)
 * _point (Array): Point to be returned to, if empty array then doesn't teleport (Position ASL) (default: [])
 * _pointRad (Number): Will skip teleport if player is within specified distance of point (default: 50)
 * _msgClass (String): Class name for cfgNotifications, if blank then default notification
 * _msgTitle (String): Notification Title
 * _msgDesc (String): Notification Description
 *
 * Returns:
 * n/a
 *
 * Example:
 * [resetLoadout,true,getPosASL _pos] spawn DOTT_fnc_flexibleReset;
 * 
 */

params 
[
	["_inventory", [], [[], true]],
	["_heal", false, [false]],
	["_point", [],[[]]],
	["_pointRad", 50,[0]],
	["_msgClass", "", [""]],
	["_msgTitle", "", [""]],
	["_msgDesc", "", [""]]
];

if (!hasInterface) exitWith {}; //client only

//if inventory array isn't empty, load specified inventory
private _resetInventory = false;

if (_inventory isEqualTo true) then { _inventory = missionNamespace getVariable ["resetLoadout", []] };

if (count _inventory != 0) then
{	
	[player, _inventory, true] spawn DOTT_fnc_fullSetUnitLoadout;
	_resetInventory = true; //set to true for switch below
};

if (_heal) then 
{
	//call ace medical treatment function
	[ player ] call ACE_medical_treatment_fnc_fullHealLocal;
	if (["ace_hearing"] call ace_common_fnc_isModLoaded) then 
	{
    	ace_hearing_deafnessDV = 0;
	};
};

private _pointCount = count _point;
private _teleport = false;
if (_pointCount < 3) then //true if array is less then required size for teleport
{	
	//if array isn't empty, then it was the wrong size, provide error message to client
	if (_point isNotEqualTo []) then { hint "DOTT_fnc_roundReset Error: Position Array wrong size!"; };
}
else //otherwise if array is correct size, then teleport requested
{
	//in case player was dead during teleport call, wait up to 30 seconds for player to respawn
	private _timeStart = time; 
	waitUntil {sleep 1; time - _timeStart > 30 || (!isNull player && alive player)}; 

	call Hill_fnc_exit_spectator; //kick player out of spectator

	//check distance to point and compare to _pointRad, if less then skip teleport
	private _pointDist = player distance2D _point;
	if (_pointDist < _pointRad) exitWith {};
	
	//cut to black with teleporting title
	titleText ["<t color='#ffffff' size='4'>Teleporting...</t>","BLACK OUT",0.5, true, true];
	player allowDamage false;
	sleep 0.1;
	
	//simulation and damage off to prevent death/accidents during teleport
	moveOut player; //force player out of vehicle if they're in one
	sleep 0.1;
	
	player enableSimulationGlobal false;
	sleep 0.3;
	
	//set player's position to specified point (ASL)
	private _dir = random 359;
	player SetPosASL [(_point select 0)-6*sin(_dir),(_point select 1)-6*cos(_dir),(_point select 2)];
	sleep 0.1;
	
	//enable simulation so they call fall if above terrain
	player enableSimulationGlobal true;
	sleep 0.4;
	
	//check if the player is touching ground
	private _ground = isTouchingGround player;
	
	if (!_ground) then //if not touching ground then
	{
		//get current height above water/terrain/objects
		private _curr = getPos player;
		private _height = _curr select 2;
		
		if (_height > 2) then //if more then 2 meters in height set height to water/terrain
		{
    		player setPos [_curr select 0, _curr select 1, 0];
    	}
    	else //otherwise a little extra time to fall
    	{
    		sleep 0.4;
    	};
	};
	
	sleep 0.2;
	
	//return to normal state
	player allowDamage true;
	titleText ["<t color='#ffffff' size='4'>Teleporting...</t>","BLACK IN",0.5, true, true];
	
	//teleport true for switch below
	_teleport = true;
};

if (_msgClass isEqualTo "") exitWith //if no msgClass, use defaults below
{
	switch (true) do
	{
		case (_resetInventory && !_heal && !_teleport): { ["Reset", ["Rearmed","Player is Rearmed!"]] call BIS_fnc_showNotification; };
		case (_resetInventory && _heal && !_teleport): { ["Reset", ["Reset","Rearmed and Healed!"]] call BIS_fnc_showNotification; };
		case (_resetInventory && _heal && _teleport): { ["Reset", ["Full Reset","Rearmed, healed, and teleported!"]] call BIS_fnc_showNotification; };
		case (!_resetInventory && _heal && _teleport): { ["Document", ["Debrief","Teleported for debrief!"]] call BIS_fnc_showNotification; };
		case (!_resetInventory && !_heal && _teleport): { ["Document", ["Teleported","Player teleported!"]] call BIS_fnc_showNotification; };
		case (!_resetInventory && _heal && !_teleport): { ["Health", ["Healed","Player is healed!"]] call BIS_fnc_showNotification; };
	};
};

//rest isn't implemented yet!
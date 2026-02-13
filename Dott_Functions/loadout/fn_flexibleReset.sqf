/*
 * Name:	DOTT_loadout_fnc_flexibleReset
 * Date:	02/04/2026
 * Version: 1.3
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
 * [resetLoadout,true,getPosASL _pos] spawn DOTT_loadout_fnc_flexibleReset;
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
	if (!isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}) exitWith { systemChat "Player in spectator, skipping rearm." }; 
	if (arsenalActionId != -1) exitWith { systemChat "Player in base, skipping rearm." }; 
	[player, _inventory, true] spawn DOTT_loadout_fnc_fullSetUnitLoadout;
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

	call DOTT_spectator_fnc_exit; //kick player out of spectator

	DOTT_loadout_teleporting = true;

	private _tries = 0; //try multiple times if it fails for whatever reason

	player allowDamage false;

	while {_tries < 3} do {
		waitUntil { uiSleep 0.1; !(player getVariable ["emr_main_isClimbing", false])};

		//check distance to point and compare to _pointRad, if less then skip teleport
		private _pointDist = player distance2D _point;
		if (_pointDist < _pointRad || !alive player) exitWith {};
		
		//cut to black with teleporting title
		titleText ["<t color='#ffffff' size='4'>Teleporting...</t>","BLACK OUT",0.5, true, true];

		sleep 0.1;
		
		//damage off to prevent death/accidents during teleport
		moveOut player; //force player out of vehicle if they're in one
		sleep 0.1;
		
		//set player's position to specified point (ASL)
		private _dir = random 359;
		player SetPosASL [(_point select 0)-6*sin(_dir),(_point select 1)-6*cos(_dir),(_point select 2)];
		sleep 0.1;
		
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

		titleText ["<t color='#ffffff' size='4'>Teleporting...</t>","BLACK IN",0.5, true, true];

		_tries = _tries + 1;
	};
	
	//return to normal state	
	[] spawn 
	{
		sleep 2;
		player allowDamage true;
		DOTT_loadout_teleporting = nil;
	};

	//teleport true for switch below
	_teleport = _tries > 0;
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
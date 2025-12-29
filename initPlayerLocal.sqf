#include "data\defines.hpp"
/*
Executed locally (only on client) when player joins mission (includes both mission start and JIP)
*/
diag_log text format ["|=============================   %1: initPlayerLocal.sqf Running   =============================|", missionName];
params ["_theClient","_didJIP"];

//0 enableChannel [true,false]; //global
//1 enableChannel [true,false]; //side
//2 enableChannel [true,false]; //command
//3 enableChannel [true,false]; //group
//4 enableChannel [true,false]; //vehicle
//5 enableChannel [true,false]; //direct

enableSentences false;
enableEnvironment [false, true];

[_theClient] execVM "scripts\player_arsenal_handlers.sqf";

//maintains a neutral rating in the event of "accidental" team kills
_theClient addEventHandler ["HandleRating", {0}];

//If the respawn menu button is active
if (!isNumber (missionConfigFile >> "respawnButton") || {getNumber (missionConfigFile >> "respawnButton") > 0}) then 
{
	_respawnMenu = [] spawn 
	{
		waitUntil {!isNull (uiNamespace getVariable ["RscDisplayMPInterrupt", displayNull])};
		uiNamespace getVariable "RscDisplayMPInterrupt" displayCtrl 1010 ctrlAddEventHandler ["ButtonClick", 
		{
			missionNamespace setVariable ["menuRespawn", true];
		}];
	};
};

// ==============================================================================

[_theClient] spawn 
{
	private ["_theMan"];
	_theMan = _this select 0;
	waitUntil {currentWeapon _theMan != ""};
	if (!(weaponLowered _theMan)) then 
	{
		_theMan action ["WeaponOnBack", _theMan];
	};
};

/*
//things break if player dies before load in finished
//NOTE: This might be breaking in very rare occasions but unsure, added check in round init to catch failures.
player allowDamage false;
addMissionEventHandler ["PreloadFinished", {
	player allowDamage true;
	removeMissionEventHandler ["PreloadFinished", _thisEventHandler];
}];
*/

//Prevent respawn showing up on old unit for split second.
//Might be inconsistent if bad network conditions (theory)
addMissionEventHandler ["EntityCreated", 
{
	params["_entity"];
	if (!(_entity isKindOf "Man") || local _entity) exitWith {};
	_entity hideObject true;
	[{ (_this select 0) hideObject false }, [_entity], 0.5] call CBA_fnc_waitAndExecute; //.2 was too short sometimes
}];
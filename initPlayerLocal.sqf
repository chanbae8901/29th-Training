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
// ==============================================================================
[] spawn 
{
  waitUntil {!isNil "artilleryComputer"};
  if (artilleryComputer == 0) then {
    enableEngineArtillery false;
  };
};

[] spawn 
{
  waitUntil {!isNil "disabledTI"};
  if (disabledTI == 0) then {
    ["visionMode", {
      [] spawn Hill_fnc_noThermals;
    }] call CBA_fnc_addPlayerEventHandler;
  };
};

// ==============================================================================
if(_didJIP) then 
{
  [_theClient] spawn 
  {
    params ["_theClient"];
    waitUntil { sleep 1; !isNull _theClient }; //most reliable way to call script early without it breaking
    [_theClient] execVM "scripts\checkCuratorAssignment.sqf";
  };
};
//[_theClient] spawn Hill_fnc_handleInitialInventory; //redundant as long as init.sqf has set up parade inventories
[_theClient] execVM "scripts\player_arsenal_handlers.sqf";

//maintains a neutral rating in the event of "accidental" team kills
_theClient addEventHandler ["HandleRating", {0}];

//If the respawn menu button is active
if (!isNumber (missionConfigFile >> "respawnButton") || {getNumber (missionConfigFile >> "respawnButton") > 0}) then {
  _respawnMenu = [] spawn {
    waitUntil {!isNull (uiNamespace getVariable ["RscDisplayMPInterrupt", displayNull])};
    uiNamespace getVariable "RscDisplayMPInterrupt" displayCtrl 1010 ctrlAddEventHandler ["ButtonClick", {
      missionNamespace setVariable ["menuRespawn", true];
		}];
	};
};

//Add actions to spectator terminals, garbage cans, and ammo boxes
execVM "scripts\baseObjectsInit.sqf";

// ==============================================================================

//Draw little skulls each time a player dies.  Seen only by Zeus.
_theClient call BIS_fnc_drawCuratorDeaths;

// Runs the in-game VOIP restriction script
_null = [] execVM "scripts\voice_control\voiceControl.sqf";

//Works with curatorObjectPlaced EH in scripts\init_curators.sqf

[_theClient] spawn {
  private ["_theMan"];
  _theMan = _this select 0;
  waitUntil {currentWeapon _theMan != ""};
  sleep 3;
  if (!(weaponLowered _theMan)) then {
    _theMan action ["WeaponOnBack", _theMan];
   };
 };

//[_theClient] execVM "scripts\TFAR_eventHandlers.sqf";
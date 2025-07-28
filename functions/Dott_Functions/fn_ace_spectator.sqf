/* Written by "Rellikplug" a.k.a "Hill [29th ID]"
// Filename: fn_ace_spectator.sqf
/*
While spectating in first-person the keys 'a', 's', 'd', and 'w' will move the spectating player around so
we force the player to sit and keep him sitting to prevent unintended movement.
*/
/*
For overriding the spectate button->?
Make something that triggers once (findDisplay 49) exists (the menu)
Then look up the IDC of the spectate button and add from there
*/

if (isDedicated || !hasInterface) exitWith {["Player must be not be dedicated server or HC."] call BIS_fnc_error; false}; // do not run on dedicated server or headlessclient
//[spectator state, force interface, hide player]
//force interface to keep similar escape as fn_spectator.sqf (Reload)
// Keep using fn_spectator.sqf to manually hide player as ACE_spectator will mute the player if used
[true, true, false] call ACE_spectator_fnc_setSpectator;  // Start Spectator


player action ["SITDOWN", player]; // make player sit down.
cutText ["SPECTATOR\n----------\nPress RELOAD to exit","PLAIN DOWN"]; // Tell player they are spectating
hintSilent "SPECTATOR\n----------\nPress RELOAD to exit";  // Tell player they are spectating

[player, true] remoteExec ["hideObjectGlobal", 0];
uiSleep 1;
player enableSimulation false;

["exitSpect", "onEachFrame", {
	if (inputAction "ReloadMagazine" > 0) exitWith { // Check if "Reload" key is pressed
		[false, true, false] call ACE_spectator_fnc_setSpectator; //  End Spectator
		[player, false] remoteExec ["hideObjectGlobal", 0];
		cutText ["","PLAIN DOWN"]; // Clear cutText
		hintSilent ""; // Clear Hint
		player allowDammage true; // Make player vulnerable again
		//player switchCamera "internal"; // Make sure the camera is returned to the player
		player enableSimulation true;
		["exitSpect", "onEachFrame"] call BIS_fnc_removeStackedEventHandler; //  Remove the stackedEventHandler as we no longer need it
	};
}] call BIS_fnc_addStackedEventHandler;

sleep 30;

if (!isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}) then { // Check if spectator is active
	[] spawn {
		while {!isNil {missionNamespace getVariable "BIS_EGSpectator_initialized"}} do { // While spectator is active show messages
			cutText ["SPECTATOR\n----------\nPress RELOAD to exit","PLAIN DOWN"];
		sleep 30; 
		};
	};
};
true
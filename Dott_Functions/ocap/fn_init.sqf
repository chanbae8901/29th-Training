/*
 * Name:	DOTT_ocap_fnc_init
 * Date:	02/04/2026
 * Version: 1.1
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initializes OCAP event handlers that work with the round system.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_ocap_fnc_init;
 * 
 */

//NOTE: OCAP settings defined in cba_settings.sqf

if (isServer) then 
{
	if !(isClass (configFile >> "CfgPatches" >> "OCAP_recorder")) exitWith {};

	DOTT_ocap_roundNum = 1;


	[
		"DOTT_round_safeStartBegin", 
		{
			["ocap_customEvent", ["generalEvent", "Safe start began!"]] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_safeStartAborted", 
		{
			["ocap_customEvent", ["generalEvent", "Safe start aborted!"]] call CBA_fnc_serverEvent;
		}
	] call CBA_fnc_addEventHandler;

	[
		"DOTT_round_started", 
		{
			["ocap_customEvent", ["generalEvent", format ["Round %1 started!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;			
		}
	] call CBA_fnc_addEventHandler;	

	[
		"DOTT_round_ended", 
		{
			["ocap_customEvent", ["generalEvent", format ["Round %1 ended!", DOTT_ocap_roundNum]]] call CBA_fnc_serverEvent;
			DOTT_ocap_roundNum = DOTT_ocap_roundNum + 1;
		}
	] call CBA_fnc_addEventHandler;	
};



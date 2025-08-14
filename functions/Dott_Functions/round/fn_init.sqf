/*
 * Name:	fnc_init
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] modified from Dott [29th ID]
 *
 * Description:
 * Sets up the initial state of the round management system.
 * Server side function.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * true
 *
 * Example:
 * call DOTT_round_fnc_init;
 * 
 */

if (!isServer) exitWith {};
bluReady = false;
opfReady = false;	
grnReady = false;
timerLength = 20*60; 
overtimeEnabled = false; 
overtimePeriod = 5*60; 

publicVariable "bluReady";
publicVariable "opfReady";	
publicVariable "grnReady";
publicVariable "timerLength";
publicVariable "overtimeEnabled";
publicVariable "overtimePeriod";

true
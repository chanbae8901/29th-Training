/**
 * Function: TN_ocap_fnc_initClient
 * Author:   Bae [29th ID]
 *
 * Purpose:
 *   Client-side OCAP initialization. 
 *   Handles JIP player registration.
 *
 *
 * Parameter(s):
 *   0: BOOL - Whether OCAP autoStart is enabled
 *
 * Returns: Nothing
 */

params ["_autoStart"];

if !(hasInterface) exitWith {};

//do OCAP initalization on players outside of capture loop so we can save proper marker info
if !(_autoStart) then
{
    [] spawn
    {
        waitUntil {!isNull player};
        
        [player] remoteExecCall
            ["TN_ocap_fnc_initializePlayer", 2];
    };
};

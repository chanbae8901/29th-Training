/*
 * Name:	DOTT_common_fnc_diag_log
 * Date:	8/20/2025
 * Version:	1.0
 * Author:	Bae [29th ID]
 *
 * Description:
 * Helper/wrapper function for diag_log intended to be remoteExec'd. 
 * Removes quotations from the log file that would exist if diag_log was used directly.
 *
 * Parameter(s):
 *	_str (String): String to log.
 *
 * Returns:
 * true
 *
 * Example:
 * "Something Happened" remoteExec ["DOTT_common_fnc_diag_log", 2];
 * 
 */

params["_str"];
diag_log text _str;

true
/**
 * Function: TN_common_fnc_diag_log
 * Author:   Bae [29th ID]
 *
 * Wrapper for diag_log intended to be remoteExec'd.
 * Uses `text` to strip the extra quotation marks that diag_log
 * adds when logging a raw string directly.
 *
 * Parameters:
 *     _str - STRING - message to write to the RPT log
 *
 * Returns:
 *     true
 *
 * Example:
 *     "Something Happened"
 *         remoteExec ["TN_common_fnc_diag_log", 2];
 */

params ["_str"];

diag_log text _str;

true

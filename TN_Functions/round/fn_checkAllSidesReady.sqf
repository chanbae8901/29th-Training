/*
 * Author: Bae [29th ID]
 * Checks if all sides with active players are ready. Sides with zero
 * players are treated as implicitly ready.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * true if all populated sides are ready <BOOL>
 *
 * Example:
 * call TN_round_fnc_checkAllSidesReady;
 */

private _bluCount = west countSide allPlayers;
private _opfCount = east countSide allPlayers;
private _grnCount = resistance countSide allPlayers;

TN_round_sideReady params ["_opfReady", "_bluReady", "_grnReady"];

// A side passes if it is ready OR has no players.
(_bluReady || _bluCount == 0)
&& (_opfReady || _opfCount == 0)
&& (_grnReady || _grnCount == 0)

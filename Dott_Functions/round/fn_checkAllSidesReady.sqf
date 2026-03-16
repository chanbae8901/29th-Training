/**
 * Function: TN_round_fnc_checkAllSidesReady
 * Author:   Bae [29th ID]
 *
 * Checks if all sides with active players are ready. Sides with zero
 * players are treated as implicitly ready.
 *
 * Parameters:
 *     None
 *
 * Returns:
 *     Boolean - true if all populated sides are ready.
 *
 * Example:
 *     call TN_round_fnc_checkAllSidesReady;
 */

private _bluCount = west countSide allPlayers;
private _opfCount = east countSide allPlayers;
private _grnCount = resistance countSide allPlayers;

private _opfReady = TN_round_sideReady select 0;
private _bluReady = TN_round_sideReady select 1;
private _grnReady = TN_round_sideReady select 2;

// A side passes if it is ready OR has no players.
(_bluReady || _bluCount == 0)
&& (_opfReady || _opfCount == 0)
&& (_grnReady || _grnCount == 0)

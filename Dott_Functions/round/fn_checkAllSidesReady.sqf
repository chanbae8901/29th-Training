/**
 * @description Checks if all sides with active players are ready.
 *     Sides with zero players are treated as implicitly ready.
 * @return {Boolean} true if all populated sides are ready.
 * @example call DOTT_round_fnc_checkAllSidesReady;
 */

private _bluCount = west countSide allPlayers;
private _opfCount = east countSide allPlayers;
private _grnCount = resistance countSide allPlayers;

private _opfReady = DOTT_round_sideReady select 0;
private _bluReady = DOTT_round_sideReady select 1;
private _grnReady = DOTT_round_sideReady select 2;

// A side passes if it is ready OR has no players.
(_bluReady || _bluCount == 0)
&& (_opfReady || _opfCount == 0)
&& (_grnReady || _grnCount == 0)

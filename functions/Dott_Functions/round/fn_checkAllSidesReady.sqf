/*
 * Name:	fnc_checkAllSidesReady
 * Date:	8/14/2025
 * Version: 1.0
 * Author:  Bae [29th ID] 
 *
 * Description:
 * Check if all sides are ready for the round to start.
 *
 * Parameter(s): 
 * none
 *
 * Returns:
 * true if all sides are ready, false otherwise
 *
 * Example:
 * call DOTT_round_fnc_checkAllSidesReady;
 * 
 */

private _bluCount = west countSide allPlayers;
private _opfCount = east countSide allPlayers;
private _grnCount = resistance countSide allPlayers;

//All sides are ready or have no players
(bluReady || _bluCount == 0) &&
(opfReady || _opfCount == 0) &&
(grnReady || _grnCount == 0)
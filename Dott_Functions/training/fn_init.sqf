/*
 * Name:	DOTT_training_fnc_init
 * Date:	12/30/2025
 * Version: 1.0
 * Author:  Bae [29th ID]
 *
 * Description:
 * Initalizes training variation of mission template.
 * Should be initialized after round.
 *
 * Parameter(s): 
 * None
 *
 * Returns:
 * n/a
 *
 * Example:
 * call DOTT_training_fnc_init;
 * 
 */

//for curator module, make sure training init is put before curator
//maybe not the cleanest way, but won't break anything if curator module isn't used
//all lower case
DOTT_curator_units = 
[
	"#adminlogged",
    "blu_co", "blu_xo", "blu_cs", "blu_snco", "ltc", "maj", "msgt", "blu_plt1_pl", "blu_plt1_ps1", "blu_plt1_ps2", "blu_plt2_pl", "blu_plt2_ps1", "blu_plt2_ps2",
    "red_plt", "red_plt_1", "red_plt_2",
    "grn_plt", "grn_plt_1", "grn_plt_2"
];

if (hasInterface) then
{
	[] spawn DOTT_training_fnc_initDefaultLoadouts;
};

if (isServer) then
{
	INDEPENDENT setFriend [WEST, 0];

	//set-up default date and weather
	private _forcedDate     = [2018, 3, 30, 12, 0]; 
	private _forcedOvercast = 0.1;
	private _forcedFog      = [0.1, 0.01, 0];
	[_forcedDate, _forcedOvercast, _forcedFog] call DOTT_training_fnc_initDateAndWeather;
};

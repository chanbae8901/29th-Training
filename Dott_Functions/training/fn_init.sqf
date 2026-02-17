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

	/* Center Arsenal zone in middle of base instead of at arsenal box for base module */
	private _findCenterObjs = [[base_res_red, base_action_arsenal_red], [base_res_blu, base_action_arsenal_blu], [base_res_grn, base_action_arsenal_grn]];
	DOTT_arsenal_centers = [];

	{
		private _respawnPos = getPosATL (_x select 0);
		private _arsenalPos = getPosATL (_x select 1);
		
		private _centerPos = [(_respawnPos#0 + _arsenalPos#0)/2, (_respawnPos#1 + _arsenalPos#1)/2, (_respawnPos#2 + _arsenalPos#2)/2];
		DOTT_arsenal_centers pushBack _centerPos;
	} forEach _findCenterObjs;

	/* Draw base locations on map for curator, do on enter and exit in case curator logic changes (admin swap)*/
	["DOTT_enteredZeus",
	{
		private _locationColors = [[1,0,0,0.5], [0.5, 0.7, 1.0, 0.5], [0,1,0,0.5]];

		DOTT_training_curatorBaseIcons = [];
		DOTT_training_curatorBaseLogic = getAssignedCuratorLogic player;

		{
			DOTT_training_curatorBaseIcons pushBack
			([ 
				DOTT_training_curatorBaseLogic, 
				[ 
				"\A3\ui_f\data\map\markers\nato\b_unknown.paa", 
				_locationColors select _forEachIndex, 
				_x, 
				1, 
				1, 
				0, 
				"", 
				2, 
				0.05 
				], 
				true, 
				false 
			] call bis_fnc_addcuratoricon);
		} forEach DOTT_arsenal_centers;
	}
	] call CBA_fnc_addEventHandler;

	["DOTT_exitedZeus",
	{
		{
			[DOTT_training_curatorBaseLogic, _x] call bis_fnc_removecuratoricon;
		} forEach DOTT_training_curatorBaseIcons;

		DOTT_training_curatorBaseIcons = nil;
		DOTT_training_curatorBaseLogic = nil;
	}
	] call CBA_fnc_addEventHandler;
	/* ---------------------------------- */

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

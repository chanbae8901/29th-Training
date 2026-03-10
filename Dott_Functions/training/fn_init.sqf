/*
 * Name:	DOTT_training_fnc_init
 * Date:	03/06/2026
 * Version: 1.2
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
    "blu_reg_o_1", "blu_reg_o_2", "blu_reg_snco_1", "blu_reg_snco_2", "blu_chq_co", "blu_chq_xo", "blu_chq_cs", "blu_chq_snco", "blu_plt1_pl", "blu_plt1_ps1", "blu_plt1_ps2", "blu_plt2_pl", "blu_plt2_ps1", "blu_plt2_ps2",
    "red_plt", "red_plt_1", "red_plt_2",
    "grn_plt", "grn_plt_1", "grn_plt_2"
];

/* Center Arsenal zone in middle of base instead of at arsenal box for base module */
private _findCenterObjs = [[base_res_red, base_action_arsenal_red], [base_res_blu, base_action_arsenal_blu], [base_res_grn, base_action_arsenal_grn]];
DOTT_arsenal_centers = [];

{
	private _respawnPos = getPosASL (_x select 0);
	private _arsenalPos = getPosASL (_x select 1);
	
	private _centerPos = [(_respawnPos#0 + _arsenalPos#0)/2, (_respawnPos#1 + _arsenalPos#1)/2, (_respawnPos#2 + _arsenalPos#2)/2];
	DOTT_arsenal_centers pushBack _centerPos;
} forEach _findCenterObjs;

if (hasInterface) then
{
	/* Draw base locations on map for curator */
	DOTT_training_curatorBaseLogic = objNull;

	["DOTT_enteredZeus",
	{
		//check if curator module changes (admin swap), if so we need to do this to new module
		if (DOTT_training_curatorBaseLogic isEqualTo getAssignedCuratorLogic player) exitWith {};

		DOTT_training_curatorBaseLogic = getAssignedCuratorLogic player;

		private _locationColors = [[1,0,0,0.5], [0.5, 0.7, 1.0, 0.5], [0,1,0,0.5]];

		{
			[ 
				DOTT_training_curatorBaseLogic, 
				[ 
				"\A3\ui_f\data\map\markers\nato\b_unknown.paa", 
				_locationColors select _forEachIndex, 
				ASLtoAGL _x, 
				1, 
				1, 
				0, 
				"", 
				2, 
				0.05 
				], 
				true, 
				true
			] call bis_fnc_addcuratoricon;
		} forEach DOTT_arsenal_centers;
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

	//delete disconnecting bodies in base
	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit"];

		if (isNull _unit) exitWith {}; //shouldn't be null but just in case

		private _pos = getPosASL _unit;

		{
			if ( _pos distance _x < 75) exitWith 
			{
				deleteVehicle _unit;
			};
		}
		forEach DOTT_arsenal_centers;

		false //make sure true isn't the return, would make the units AI controlled
	}];
};

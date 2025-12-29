//Add actions to spectator terminals
private _terminals = [];
private _ammo_boxes = [];
DOTT_garbages = []; //global variable for cleaner function

{ //forEach object placed in editor
	//get variable name in string format, if empty then skip to next object
	private _vicString = vehicleVarName _x;
	if (_vicString isEqualTo "") then { continue };
	
	//make all lower case to reduce user errors
	_vicString = toLowerANSI _vicString;
	
	//create array of tags split with an underscore (E.G. "base_action_terminal_0" becomes ["base","action","terminal","0"] )
	private _tags = _vicString splitString "_";
	
	//if less then 3 tags, object isn't named for this convention, skip object
	private _tagCount = count _tags;
	if (_tagCount < 3) then { continue };
	
	//if the second tag isn't "action", skip object, continue to next object in vehicles array
	private _actionObject = _tags select 1;
	if (_actionObject isNotEqualTo "action") then { continue };
	
	//third tag is action type, sort variable into assosiated array
	private _actionType = _tags select 2;
	switch (_actionType) do
	{
		case "arsenal": { _ammo_boxes pushBack _x; };
		case "terminal": { _terminals pushBack _x; };
		case "garbage": { DOTT_garbages pushBack _x; };
	};
		//if var name doesn't include "base", skip object, continue to next object in vehicles array
		//private _baseObject = ["base", _vicString] call BIS_fnc_inString;
		//if (!_baseObject) then { continue };
	
	//if (["arsenal", _vicString] call BIS_fnc_inString) then //arsenal vars
	//{
	//	_arsenalArr pushBack _x;
	//};
	//
	//if (["terminal", _vicString] call BIS_fnc_inString) then //spectator terminal vars
	//{
	//	_terminalArr pushBack _x;
	//};
	//
	//if (["garbage", _vicString] call BIS_fnc_inString) then //garbage can vars
	//{
	//	_garbageArr pushBack _x;
	//};
}
forEach allMissionObjects "All";

{
  _x addAction ["<img image='\A3\Ui_f\data\GUI\Rsc\RscDisplayEGSpectator\Follow.paa'/><t color='#00ff00'>  Spectator</t>", "[] spawn DOTT_spectator_fnc_enter", nil, 6, false, true, "", "true", 4];

	//create trigger for animating the spectator box and set it up
	private _trg = createTrigger ["EmptyDetector", getPos _x];
	_trg setTriggerArea [0, 0, 0, false];
	_trg setTriggerActivation ["NONE", "NONE", true];
	private _condition = format ["player distance %1 < 3", _x];
	private _activate = format ["[%1,3] call BIS_fnc_dataTerminalAnimate;", _x];
	private _deActivate = format ["[%1,0] call BIS_fnc_dataTerminalAnimate;", _x];
	_trg setTriggerStatements [_condition, _activate, _deActivate];
} forEach _terminals;

//------- ACE Arsenal -------//
private _centers = [];
arsenalActionId = -1;

for "_i" from 0 to ((count _ammo_boxes) - 1) do 
{
  private _ammo = _ammo_boxes select _i;

  private _p1 = getPosATL _ammo;

  _centers pushBack _p1;
};

[_centers] spawn 
{
  params ["_centers"];

  private _radius = DOTT_event_arsenalRadius;
  private _radiusSquared = _radius*_radius;

  while {true} do 
  {
    private _inZone = false;
    {
      private _distSquared = player distanceSqr _x;
      if(_distSquared <= _radiusSquared) exitWith {_inZone = true};
    } forEach _centers;

    if (_inZone) then 
    {
        if (arsenalActionId == -1) then 
        {
			if (isClass (configFile >> "CfgPatches" >> "ace_main")) then 
			{ 
				arsenalActionId = player addAction [
					"<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Ace Arsenal</t>",
					{ [_this select 1, _this select 1, true] call ace_arsenal_fnc_openBox; },
					nil, 1.5, true, true, "", "true"
				];
			} else
			{
				arsenalActionId = player addAction [
					"<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Virtual Arsenal</t>",
					{["Open", true] spawn BIS_fnc_arsenal;},
					nil, 1.5, true, true, "", "true"
				];
			};
        };
    } else 
    {
        if (arsenalActionId != -1) then 
        {
            player removeAction arsenalActionId;
            arsenalActionId = -1;
        };
    };
    sleep 1; 
  };
};

player addEventHandler ["Respawn", { arsenalActionId = -1; }];
//-----------------------------//

{
  _x addAction ["<img image='\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'/><t color='#FF0080'>  Clean-Up</t>", "call DOTT_event_fnc_cleaner", nil, 1, false, true, "", "true", 2];
} forEach DOTT_garbages;
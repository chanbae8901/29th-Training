//Add actions to spectator terminals
private _terminals = [terminal, terminal_1, terminal_2];
private _ammo_boxes = [blu_ammo,red_ammo,grn_ammo];
private _garbages = [blu_garbage,red_garbage,green_garbage];
private _respawns = [res_blu, res_red, res_grn];
{
  _x addAction ["<img image='\A3\Ui_f\data\GUI\Rsc\RscDisplayEGSpectator\Follow.paa'/><t color='#00ff00'>  Spectator</t>", "[] spawn Hill_fnc_enter_spectator", nil, 6, false, true, "", "true", 4];
} forEach _terminals;

//------- ACE Arsenal -------//
private _radius = 75;
private _centers = [];
arsenalActionId = -1;

for "_i" from 0 to ((count _ammo_boxes) - 1) do 
{
  private _resp = _respawns select _i;
  private _ammo = _ammo_boxes select _i;

  private _p1 = getPosATL _resp;
  private _p2 = getPosATL _ammo;

  _centers pushBack [ (_p1#0 + _p2#0) / 2, (_p1#1 + _p2#1) / 2];
};

[_centers] spawn 
{
  params ["_centers"];

  private _radius = 75;
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
            arsenalActionId = player addAction [
                "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#bf3eff'>  Ace Arsenal</t>",
                { [_this select 1, _this select 1, true] call ace_arsenal_fnc_openBox; },
                nil, 1.5, true, true, "", "true"
            ];
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

blu_ammo addAction [
    "<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t color='#3f8eff'>  Force Parade</t>", 
    {
        params ["_target"];
        [_target, 125] call DOTT_fnc_forceParadeAll;
    }, 
    nil, 
    1.4, 
    true, 
    true, 
    "", 
    "serverCommandAvailable '#lock'", 
    3
];

{
  _x addAction ["<img image='\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'/><t color='#FF0080'>  Clean-Up</t>", "call Hill_fnc_cleaner", nil, 1, false, true, "", "true", 2];
} forEach _garbages;
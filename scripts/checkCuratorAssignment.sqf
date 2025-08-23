//spawn Hill_fnc_assignCurator with the right parameters determined by the player joining
private _unitName = str (_this select 0);

private _curatorMap = createHashMapFromArray [
    ["blu_co",       "zeus_co"],
    ["blu_cs",       "zeus_cs"],
    ["blu_snco",     "zeus_snco"],
    ["ltc",          "zeus_ltc"],
    ["maj",          "zeus_maj"],
    ["msgt",         "zeus_msgt"],
    ["blu_plt1_pl",  "zeus_plt1_pl"],
    ["blu_plt1_ps1", "zeus_plt1_ps1"],
    ["blu_plt1_ps2", "zeus_plt1_ps2"],
    ["blu_plt2_pl",  "zeus_plt2_pl"],
    ["blu_plt2_ps",  "zeus_plt2_ps"],
    ["red_plt",      "zeus_red_plt"],
    ["red_1_plt",    "zeus_red_1_plt"],
    ["grn_plt",      "zeus_grn_plt"],
    ["grn_1_plt",    "zeus_grn_1_plt"]
];

private _logicName = _curatorMap getOrDefault [_unitName, ""];

if (_logicName == "") exitWith {};

private _unit = missionNamespace getVariable _unitName;
private _logic = missionNamespace getVariable _logicName;

[_unit, _logic] spawn Hill_fnc_assignCurator;
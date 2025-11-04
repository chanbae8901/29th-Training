//Prevent tickets/countdown from ending mission
BIS_fnc_endMission = compileFinal "";

//Alters sector module behavior
BIS_fnc_moduleSector = compileFinal preprocessFileLineNumbers "scripts\BIS_fnc_moduleSectorAlt.sqf";
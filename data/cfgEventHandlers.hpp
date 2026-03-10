class Extended_PreInit_EventHandlers
{
    class DOTT_MissionSettings
    {
        init = "call compile preprocessFileLineNumbers ""XEH_preInit.sqf""";
    };
};

class Extended_DisplayLoad_EventHandlers
{
    class RscDisplayCurator
    {
        DOTT_round = "[""DOTT_enteredZeus"", []] call CBA_fnc_localEvent";
    };
};

class Extended_DisplayUnload_EventHandlers
{
    class RscDisplayCurator
    {
        DOTT_round = "[""DOTT_exitedZeus"", []] call CBA_fnc_localEvent";
    };

    class RscDisplayMPInterrupt
    {
        DOTT = "[""DOTT_exitedPauseMenu"", []] call CBA_fnc_localEvent";
    };
};

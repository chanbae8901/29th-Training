class Extended_PreInit_EventHandlers
{
    class TN_MissionSettings
    {
        init = "call compile preprocessFileLineNumbers ""XEH_preInit.sqf""";
    };
};

class Extended_DisplayLoad_EventHandlers
{
    class RscDisplayCurator
    {
        TN_round = "[""TN_enteredZeus"", []] call CBA_fnc_localEvent";
    };
};

class Extended_DisplayUnload_EventHandlers
{
    class RscDisplayCurator
    {
        TN_round = "[""TN_exitedZeus"", []] call CBA_fnc_localEvent";
    };

    class RscDisplayMPInterrupt
    {
        DOTT = "[""TN_exitedPauseMenu"", []] call CBA_fnc_localEvent";
    };
};

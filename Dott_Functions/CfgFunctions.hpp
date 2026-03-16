//no #include defines needed, inherited from description.ext
class TN_Loadout
{
    tag = "TN_loadout";
    class LoadoutFunctions
    {
        file = "Dott_Functions\loadout";
        class init {};
        class fullSetUnitLoadout {};
        class resetWeaponState {};
        class onArsenalClosed {};
        class setInsignia {};
        class flexibleReset {};
    };
};

class TN_Common
{
    tag = "TN_common";
    class CommonFunctions
    {
        file = "Dott_Functions\common";
        class addDiaryRecord {};
        class diag_log {};
        class displayMsg {};
};
};

class TN_Round
{
    tag = "TN_round";
    class RoundFunctions
    {
        file = "Dott_Functions\round";
        class init {};
        class manageReady {};
        class checkAllSidesReady {};
        class initSafeStart {};
        class initSafeStartHelper {};
        class changeForcedSafeStart {};
        class start {};
        class end {};
        class isRoundActive {};
        class addTime {};
        class getTime {};
        class setTimer {};
        class setOvertimeEnabled {};
        class setOverTimePeriod {};
        class timeWarning {};
        class roundEvents {};
        class formatTime {};
        class collectSilentWeapons {};
        class initReadyUI {};
    };
};

class TN_Radio
{
    tag = "TN_radio";
    class RadioFunctions
    {
        file = "Dott_Functions\radio";
        class init {};
        class initTransferSettings {};
        class add {};
        class remove {};
    };
};

class TN_Thermals
{
    tag = "TN_thermals";
    class ThermalFunctions
    {
        file = "Dott_Functions\thermals";
        class init {};
        class disablePIP {};
        class blackScreen {};
    };
};

class TN_Ticket
{
    tag = "TN_ticket";
    class TicketFunctions
    {
        file = "Dott_Functions\ticket";
        class init {};
        class add {};
        class count {};
    };
};

class TN_Spectator
{
    tag = "TN_spectator";
    class SpectatorFunctions
    {
        file = "Dott_Functions\spectator";
        class init {};
        class enter {};
        class exit {};
    };
};

class TN_Curator
{
    tag = "TN_curator";
    class CuratorFunctions
    {
        file = "Dott_Functions\curator";
        class init {};
        class excludeObjects {};
        class addEditable {};
        class createModule {};
    };
};

class TN_Vehicle
{
    tag = "TN_vehicle";
    class VehicleFunctions
    {
        file = "Dott_Functions\vehicle";
        class init {};
    };
};

class TN_OCAP
{
    tag = "TN_ocap";
    class OCAPFunctions
    {
        file = "Dott_Functions\ocap";
        class init {};
        class initClient {};
    };
};

class TN_Commands
{
    tag = "TN_commands";
    class CommandFunctions
    {
        file = "Dott_Functions\commands";
        class init {};
        class execute {};
        class addModule {};
    };
};

class TN_Training
{
    tag = "TN_training";
    class TrainingFunctions
    {
        file = "Dott_Functions\training";
        class init {};
        class initDateAndWeather {};
        class initDefaultLoadouts {};
    };
    class Override
    {
        class overrideFunctions
        {
            file = "Dott_Functions\training\overrideFunctions.sqf";
            preInit = 1;
        };
    };
};

class TN_Tracker
{
    tag = "TN_tracker";
    class TrackerFunctions
    {
        file = "Dott_Functions\tracker";
        class init {};
        class recordKill {};
        class saveEvent {};
        class recordSectorCapture {};
        class eventToString {};
        class killCountsToString {};
        class recordACEConscious {};
        class getName {};
        class nameToNum {};
        class weaponToNum {};
        class createDiaryEntries {};
        class colorNameWithSide {};
        class getSideAtTime {};
        class copyToClipboard {};
        class copyRecordToClipboard {};
        class getKillCounts {};
        class findPlayerEvents {};
        class getWeapon {};
        class sendAll {};
        class receiveAll {};
        class addEventHandlersClient {};
        class hit {};
        class sendHit {};
    };
};

class TN_Settings
{
    tag = "TN_settings";
    class SettingsFunctions
    {
        file = "Dott_Functions\settings";
        class init {};
        class initDisplayMissionOptions {};
    };
};

class TN_Parade
{
    tag = "TN_parade";
    class ParadeFunctions
    {
        file = "Dott_Functions\parade";
        class init {};
        class handleInitialInventory {};
        class forceAll {};
        class load {};
        class checkNonCombatLoadout {};
    };
};

class TN_Event
{
    tag = "TN_event";
    class EventFunctions
    {
        file = "Dott_Functions\event";
        class init {};
        class game {};
        class aliveCheck {};
        class respawn {};
        class flagActions {};
        class checkWinCondition {};
        class gui_setSafeStartTime {};
        class gui_flagMenu {};
        class markEditorPlacedObjects {};
    };
};

class TN_Base
{
    tag = "TN_base";
    class BaseFunctions
    {
        file = "Dott_Functions\base";
        class init {};
        class cleaner {};
    };
};

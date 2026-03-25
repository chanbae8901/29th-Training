//no #include defines needed, inherited from description.ext
class TN_Loadout
{
    tag = "TN_loadout";
    class LoadoutFunctions
    {
        file = "TN_Functions\loadout";
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
        file = "TN_Functions\common";
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
        file = "TN_Functions\round";
        class init {};
        class manageReady {};
        class checkAllSidesReady {};
        class initSafeStart {};
        class initSafeStartHelper {};
        class changeForcedSafeStart {};
        class start {};
        class end {};
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
    class ReadyUI
    {
        file = "TN_Functions\round\readyui";
        class createReadyUIControls {};
        class stopReadyUIPFH {};
        class updateReadyUI {};
        class flashReadyUI {};
    };
};

class TN_Radio
{
    tag = "TN_radio";
    class RadioFunctions
    {
        file = "TN_Functions\radio";
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
        file = "TN_Functions\thermals";
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
        file = "TN_Functions\ticket";
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
        file = "TN_Functions\spectator";
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
        file = "TN_Functions\curator";
        class init {};
        class excludeObjects {};
        class addEditable {};
        class createModule {};
        class handleAdminStateChanged {};
    };
};

class TN_Vehicle
{
    tag = "TN_vehicle";
    class VehicleFunctions
    {
        file = "TN_Functions\vehicle";
        class init {};
    };

    class ACELockFixFunctions
    {
        file = "TN_Functions\vehicle\ACELockFix";
        class lockFixInit {};
        class saveUnconsciousSeat {};
        class unlockUnconsciousSeat {};
    };
};

class TN_OCAP
{
    tag = "TN_ocap";
    class OCAPFunctions
    {
        file = "TN_Functions\ocap";
        class init {};
        class initClient {};
    };
};

class TN_Commands
{
    tag = "TN_commands";
    class CommandFunctions
    {
        file = "TN_Functions\commands";
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
        file = "TN_Functions\training";
        class init {};
        class initDateAndWeather {};
        class initDefaultLoadouts {};
    };
    class Override
    {
        class overrideFunctions
        {
            file = "TN_Functions\training\overrideFunctions.sqf";
            preInit = 1;
        };
    };
};

class TN_Tracker
{
    tag = "TN_tracker";
    class TrackerFunctions
    {
        file = "TN_Functions\tracker";
        class init {};
        class recordKill {};
        class saveEvent {};
        class recordSectorCapture {};
        class recordACEConscious {};
        class getName {};
        class nameToNum {};
        class weaponToNum {};
        class getSideAtTime {};
        class getWeapon {};
        class addEventHandlersClient {};
        class handleFired {};
        class handleVehicleKilled {};
        class hit {};
        class sendHit {};
        class findIncendiaryGrenade {};
    };
    class DiaryFunctions
    {
        file = "TN_Functions\tracker\diary";
        class createDiaryEntries {};
        class eventToString {};
        class killCountsToString {};
        class colorNameWithSide {};
        class findPlayerEvents {};
        class getKillCounts {};
        class copyRecordToClipboard {};
        class copyToClipboard {};
        class sendAll {};
        class receiveAll {};
    };
};

class TN_Settings
{
    tag = "TN_settings";
    class SettingsFunctions
    {
        file = "TN_Functions\settings";
        class init {};
        class initDisplayMissionOptions {};
    };
};

class TN_Parade
{
    tag = "TN_parade";
    class ParadeFunctions
    {
        file = "TN_Functions\parade";
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
        file = "TN_Functions\event";
        class init {};
        class game {};
        class aliveCheck {};
        class respawn {};
        class flagActions {};
        class checkWinCondition {};
        class gui_setSafeStartTime {};
        class gui_flagMenu {};
        class markEditorPlacedObjects {};
        class handleAdminEventMenu {};
    };
};

class TN_Base
{
    tag = "TN_base";
    class BaseFunctions
    {
        file = "TN_Functions\base";
        class init {};
        class cleaner {};
        class arsenalZoneCheck {};
    };
};

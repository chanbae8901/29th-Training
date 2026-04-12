//no #include defines needed, inherited from description.ext
class TN_Base {
    tag = "TN_base";
    class BaseFunctions {
        file = "TN_Functions\base";
        class arsenalZoneCheck {};
        class init {};
        class initPlayersInBase {};
    };
};

class TN_Commands {
    tag = "TN_commands";
    class CommandFunctions {
        file = "TN_Functions\commands";
        class addModule {};
        class execute {};
        class init {};
    };
};

class TN_Common {
    tag = "TN_common";
    class CommonFunctions {
        file = "TN_Functions\common";
        class addDiaryRecord {};
        class cleanup {};
        class convertSide {};
        class diag_log {};
        class displayMsg {};
        class init {};
        class notifyAdmin {};
        class timedHint {};
    };
    class InitFunctions {
        file = "TN_Functions\common\init";
        class initAdminStateChanged {};
    };
};

class TN_Curator {
    tag = "TN_curator";
    class CuratorFunctions {
        file = "TN_Functions\curator";
        class addEditable {};
        class createModule {};
        class excludeObjects {};
        class handleAdminStateChanged {};
        class init {};
    };
};

class TN_Event {
    tag = "TN_event";
    class EventFunctions {
        file = "TN_Functions\event";
        class checkWinConditions {};
        class initAliveCheck {};
        class initWinConditions {};
        class endMission {};
        class flagActions {};
        class gui_eventMenu {};
        class gui_setTime {};
        class handleAdminEventMenu {};
        class handleLivesOnKilled {};        
        class init {};
        class markEditorPlacedObjects {};
        class validateSettings {};
    };
};

class TN_Loadout {
    tag = "TN_loadout";
    class LoadoutFunctions {
        file = "TN_Functions\loadout";
        class flexibleReset {};
        class fullSetUnitLoadout {};
        class init {};
        class onArsenalClosed {};
    };
};

class TN_OCAP {
    tag = "TN_ocap";
    class OCAPFunctions {
        file = "TN_Functions\ocap";
        class init {};
        class initClient {};
    };
};

class TN_Parade {
    tag = "TN_parade";
    class ParadeFunctions {
        file = "TN_Functions\parade";
        class checkNonCombatLoadout {};
        class forceAll {};
        class handleInitialInventory {};
        class init {};
        class load {};
        class setInsignia {};
    };
};

class TN_Radio {
    tag = "TN_radio";
    class RadioFunctions {
        file = "TN_Functions\radio";
        class add {};
        class handleFrequencyChanged {};
        class handleLoadoutLr {};
        class init {};
        class initTransferSettings {};
        class remove {};
    };
};

class TN_Round {
    tag = "TN_round";
    class ReadyUI {
        file = "TN_Functions\round\readyui";
        class createReadyUIControls {};
        class flashReadyUI {};
        class handleReadyChange {};
        class stopReadyUIPFH {};
        class updateReadyUI {};
    };
    class RoundFunctions {
        file = "TN_Functions\round";
        class addTime {};
        class changeForcedSafeStart {};
        class checkAllSidesReady {};
        class collectSilentWeapons {};
        class end {};
        class formatTime {};
        class getTime {};
        class init {};
        class initReadyUI {};
        class initSafeStart {};
        class initSafeStartHelper {};
        class manageReady {};
        class roundEvents {};
        class setTimer {};
        class start {};
        class timeWarning {};
    };
};

class TN_Settings {
    tag = "TN_settings";
    class SettingsFunctions {
        file = "TN_Functions\settings";
        class init {};
        class initDisplayMissionOptions {};
    };
};

class TN_Spectator {
    tag = "TN_spectator";
    class SpectatorFunctions {
        file = "TN_Functions\spectator";
        class enter {};
        class exit {};
        class init {};
    };
};

class TN_Thermals {
    tag = "TN_thermals";
    class ThermalFunctions {
        file = "TN_Functions\thermals";
        class blackScreen {};
        class disablePIP {};
        class init {};
    };
};

class TN_Ticket {
    tag = "TN_ticket";
    class TicketFunctions {
        file = "TN_Functions\ticket";
        class add {};
        class count {};
        class init {};
    };
};

class TN_Tracker {
    tag = "TN_tracker";
    class DiaryFunctions {
        file = "TN_Functions\tracker\diary";
        class colorNameWithSide {};
        class copyRecordToClipboard {};
        class copyToClipboard {};
        class createDiaryEntries {};
        class eventToString {};
        class findPlayerEvents {};
        class getKillCounts {};
        class killCountsToString {};
        class receiveAll {};
        class sendAll {};
    };
    class EventHandlerFunctions {
        file = "TN_Functions\tracker\eventhandlers";
        class handleBurnSimulation {};
        class handleExplosivePlace {};
        class handleFired {};
        class handleHit {};
        class handleVehicleKilled {};
        class handleWoundReceived {};
    };
    class TrackerFunctions {
        file = "TN_Functions\tracker";
        class addEventHandlersClient {};
        class findIncendiaryGrenade {};
        class findSide {};
        class getName {};
        class getSideAtTime {};
        class getWeapon {};
        class init {};
        class nameToNum {};
        class recordACEConscious {};
        class recordKill {};
        class recordSectorCapture {};
        class saveEvent {};
        class sendHit {};
        class weaponToNum {};
    };
};

class TN_Training {
    tag = "TN_training";
    class Override {
        class overrideFunctions {
            file = "TN_Functions\training\overrideFunctions.sqf";
            preInit = 1;
        };
    };
    class TrainingFunctions {
        file = "TN_Functions\training";
        class init {};
        class initCommandsDiary {};
        class initDateAndWeather {};
        class initDefaultLoadouts {};
        class initNotifyAdminAllDead {};
    };
};

class TN_Vehicle {
    tag = "TN_vehicle";
    class ACELockFixFunctions {
        file = "TN_Functions\vehicle\ACELockFix";
        class lockFixInit {};
        class saveUnconsciousSeat {};
        class unlockUnconsciousSeat {};
    };
    class VehicleFunctions {
        file = "TN_Functions\vehicle";
        class init {};
    };
};

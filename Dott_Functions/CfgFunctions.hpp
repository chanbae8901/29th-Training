//no #include defines needed, inherited from description.ext
class Dott_Loadout
{
	tag = "DOTT_loadout";
	class DottsFunctions 
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

class Dott_Common
{
	tag = "DOTT_common";
	class CommonFunctions
	{
		file = "Dott_Functions\common";
		class addDiaryRecord {};
		class diag_log {};
		class displayMsg {};
		//class selectPosArea {};
	};
};

class Dott_Round
{
	tag = "DOTT_round";
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

class Dott_Radio
{
	tag = "DOTT_radio";
	class RadioFunctions
	{
		file = "Dott_Functions\radio";
		class init {};
		class initTransferSettings {};
		class add {};
		class remove {};
	};
};

class Dott_Thermals
{
	tag = "DOTT_thermals";
	class ThermalFunctions
	{
		file = "Dott_Functions\thermals";
		class init {};
		class disablePIP {};
		class blackScreen {};
	};
};

class Dott_Ticket
{
	tag = "DOTT_ticket";
	class TicketFunctions
	{
		file = "Dott_Functions\ticket";
		class init {};
		class add {};
		class count {};
	};
};

class Dott_Spectator
{
	tag = "DOTT_spectator";
	class SpectatorFunctions
	{
		file = "Dott_Functions\spectator";
		class init {};
		class enter {};
		class exit {};
	};
};

class DOTT_Curator
{
	tag = "DOTT_curator";
	class CuratorFunctions
	{
		file = "Dott_Functions\curator";
		class init {};
		class excludeObjects {};
		class addPlayerEditable {};
		class createModule {};
	};
};

class DOTT_Vehicle
{
	tag = "DOTT_vehicle";
	class VehicleFunctions
	{
		file = "Dott_Functions\vehicle";
		class init {};
	};
};

class DOTT_OCAP
{
	tag = "DOTT_ocap";
	class OCAPFunctions
	{
		file = "Dott_Functions\ocap";
		class init {};
		class initClient {};
	};
};

class DOTT_Commands
{
	tag = "DOTT_commands";
	class CommandFunctions
	{
		file = "Dott_Functions\commands";
		class init {};
		class execute {};
		class addModule {};
	};
};

class DOTT_Training
{
	tag = "DOTT_training";
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

class Dott_Tracker
{
	tag = "DOTT_tracker";
	class RoundFunctions
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
		class addEventHandlersClient {};
		class hit {};
		class sendHit {};
	};
};

class Dott_Settings
{
	tag = "DOTT_settings";
	class GUIFunctions
	{
		file = "Dott_Functions\settings";
		class init {};		
		class initDisplayMissionOptions {};
	};
};

class Dott_Parade
{
	tag = "DOTT_parade";
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

class Dott_Event
{
	tag = "DOTT_event";
	class RoundFunctions
	{
		file = "Dott_Functions\event";
		class init {};		
		class game {};
		class aliveCheck {};
		class respawn {};
		class flagActions {};
		class checkWinCondition {};
		class gui_setSafeStartTime {};
		class markEditorPlacedObjects {};
	};
};

class Dott_Base
{
	tag = "DOTT_base";
	class BaseFunctions
	{
		file = "Dott_Functions\base";
		class init {};
		class cleaner {};
	};
};

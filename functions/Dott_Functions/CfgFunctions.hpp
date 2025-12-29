//no #include defines needed, inherited from description.ext
class Dott_Functions
{
	tag = "DOTT";
	class DottsFunctions 
	{
		file = "functions\Dott_Functions";
		class displayMsg {};
		class fullSetUnitLoadout {};
		class resetWeaponState {};
		class diag_log {};
		class addDiaryRecord {};
		class disablePIPThermals {};


		#ifdef DOTT_TRAINING

		class initDefaultLoadouts {};
		class flexibleReset {};

		#endif
	};
};

class Dott_Round
{
	tag = "DOTT_round";
	class RoundFunctions
	{
		file = "functions\Dott_Functions\round";
		class init {};
		class manageReady {};
		class checkAllSidesReady {};
		class initSafeStart {};
		class initSafeStartHelper {};
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
	};
};

class Dott_Radio
{
	tag = "DOTT_radio";
	class RadioFunctions
	{
		file = "functions\Dott_Functions\radio";
		class initTransferSettings {};
		class addRadio {};
		class removeRadio {};
	};
};

class Dott_Ticket
{
	tag = "DOTT_ticket";
	class TicketFunctions
	{
		file = "functions\Dott_Functions\ticket";
		class add {};
		class count {};
	};
};

#ifdef DOTT_TRAINING

class Dott_Tracker
{
	tag = "DOTT_tracker";
	class RoundFunctions
	{
		file = "functions\Dott_Functions\tracker";
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
		file = "functions\Dott_Functions\settings";
		class initServer {};		
		class initDisplayMissionOptions {};
	};
};

class Dott_Parade
{
	tag = "DOTT_parade";
	class ParadeFunctions
	{
		file = "functions\Dott_Functions\parade";
    	class handleInitialInventory {};
		class forceAll {};
		class load {};
		class checkNonCombatLoadout {};
	};
};

#endif

#ifdef DOTT_EVENT

class Dott_Event
{
	tag = "DOTT_event";
	class RoundFunctions
	{
		file = "functions\Dott_Functions\event";
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

#endif
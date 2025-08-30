class Dott_Functions
{
	tag = "DOTT";
	class DottsFunctions 
	{
		file = "functions\Dott_Functions";
		class displayMsg {};
		class ticketAdd {};
		class ticketCount {};
		class flexibleReset {};
		class fullSetUnitLoadout {};
		class resetWeaponState {};
		class checkNonCombatLoadout {};
		class forceParade {};
		class forceParadeAll {};
		class initDefaultLoadouts {};
		class diag_log {};
		class addDiaryRecord {};
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
	};
};

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
		class addEventHandlersUnit {};
		class projectileHit {};
	};
};

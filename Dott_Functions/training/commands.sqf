[
	[
		[
			"cleanup",
			{
				call DOTT_training_fnc_cleaner;
				systemChat "Cleaning up!"
			}
		]
	],
	[
		["cleanup", "Cleans up bodies (trash can function)"]
	]
] call DOTT_commands_fnc_addModule;
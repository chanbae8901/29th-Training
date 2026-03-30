#include "script_component.hpp"

[
	[
		[
			"cleanup", {
				call FUNC(cleaner);
				systemChat "Cleaning up!"
			}
		]
	],
	[
		["cleanup", "Cleans up bodies (trash can function)"]
	]
] call EFUNC(commands,addModule);

#include "script_component.hpp"
[
    [
        [
            "parade", {
                // 125m hardcoded radius around the calling player.
                [player, 125] call FUNC(forceAll);
            }
        ]
    ],
    [
        [
            "parade",
            "Sets all players' loadout within 125m of your position to parade."
        ]
    ]
] call EFUNC(commands,addModule);

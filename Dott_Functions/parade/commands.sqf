[
    [
        [
            "parade",
            {
                // 125m hardcoded radius around the calling player.
                [player, 125] spawn DOTT_parade_fnc_forceAll;
            }
        ]
    ],
    [
        [
            "parade",
            "Sets all players' loadout within 125m of your position to parade."
        ]
    ]
] call DOTT_commands_fnc_addModule;

[
    [
        [
            "radio",
            {
                private _strs = [];

                // SW (short-range) radio info.
                private _activeSw = call TFAR_fnc_activeSwRadio;
                if !(isNil "_activeSw") then
                {
                    private _radioName = [
                        _activeSw, "tf_parent", "SR"
                    ] call TFAR_fnc_getWeaponConfigProperty;
                    private _swCode =
                        _activeSw call TFAR_fnc_getSWRadioCode;
                    _strs pushBack format [
                        "%1: %2", _radioName, _swCode
                    ];
                };

                // LR (long-range) backpack radio info.
                private _activeLr =
                    player call TFAR_fnc_backpackLR;
                if !(isNil "_activeLr") then
                {
                    private _radioName = [
                        typeOf (_activeLr select 0),
                        "displayName", "LR"
                    ] call TFAR_fnc_getVehicleConfigProperty;
                    private _lrCode =
                        _activeLr call TFAR_fnc_getLRRadioCode;
                    _strs pushBack format [
                        "%1: %2", _radioName, _lrCode
                    ];
                };

                // Vehicle LR radio info.
                private _vehicleLr =
                    player call TFAR_fnc_vehicleLr;
                if !(isNil "_vehicleLr") then
                {
                    private _radioName = [
                        typeOf (_vehicleLr select 0),
                        "displayName", "Vic"
                    ] call TFAR_fnc_getVehicleConfigProperty;
                    private _vehLrCode =
                        _vehicleLr call TFAR_fnc_getLRRadioCode;
                    _strs pushBack format [
                        "%1: %2", _radioName, _vehLrCode
                    ];
                };

                player sideChat (_strs joinString " | ");
            }
        ]
    ],
    [
        [
            "radio",
            "Checks radio encryption codes for TFAR radios."
        ]
    ]
] call TN_commands_fnc_addModule;

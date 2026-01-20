params ["_weaponHolder", "_observer"];

if (isNil "DOTT_round_clientSilentWeapons") then { DOTT_round_clientSilentWeapons = createHashMap };

if !(_weaponHolder in DOTT_round_clientSilentWeapons) then { DOTT_round_clientSilentWeapons set [_weaponHolder, []] };

private _observerArray = DOTT_round_clientSilentWeapons get _weaponHolder;

_observerArray pushBack _observer;
/**
 * @description Collects the name of a player detected with the silent
 *     weapon bug into a server-side hashmap. Called via remoteExecCall
 *     from each client after round start.
 * @param {String} _weaponHolder - Display name of the player holding
 *     the bugged weapon.
 * @param {String} _observer - Display name of the reporting player.
 * @return None
 * @example [_name, _observer] call DOTT_round_fnc_collectSilentWeapons;
 */

params ["_weaponHolder", "_observer"];

if (isNil "DOTT_round_clientSilentWeapons") then
{
    DOTT_round_clientSilentWeapons = createHashMap;
};

if !(_weaponHolder in DOTT_round_clientSilentWeapons) then
{
    DOTT_round_clientSilentWeapons set [_weaponHolder, []];
};

private _observerArray =
    DOTT_round_clientSilentWeapons get _weaponHolder;

_observerArray pushBack _observer;

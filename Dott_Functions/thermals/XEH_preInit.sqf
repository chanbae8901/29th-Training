/**
 * Thermals Module - CBA Pre-Init Settings
 *
 * Registers the TN_disableTI CBA setting and its on-change
 * callback, which live-updates thermal restrictions for both
 * clients and the server.
 *
 * Parameters:
 *     None (executed automatically by CBA XEH)
 *
 * Returns:
 *     Nothing
 */

#include "..\..\data\settingCategories.hpp"

[
    "TN_disableTI",
    "CHECKBOX",
    "Disable thermal imaging optics",
    [GENERAL_SETTINGS_CATEGORY, THERMALS_SUBCATEGORY],
    true,
    1,
    {
        if (hasInterface) then
        {
            // ACE Javelin needs this flag so lock-on still works
            // without thermals.
            if (isClass (
                configFile >> "CfgPatches" >> "ace_main"
            )) then
            {
                ace_javelin_ignoreVisionMode = _this;
            };

            [] spawn DOTT_thermals_fnc_blackScreen;

            if (!alive player
                || {isNull (objectParent player)}) exitWith {};

            if (_this) then
            {
                call DOTT_thermals_fnc_disablePIP;
            }
            else
            {
                systemChat
                    "Thermal imaging optics have been enabled."
                    + " You have to reenter vehicle to enable"
                    + " some PIP thermals.";
            };
        };

        if (isServer) then
        {
            {
                if !(_x isKindOf "Man") then
                {
                    _x disableTIEquipment _this;
                };
            } forEach allMissionObjects "AllVehicles";
        };
    }
] call CBA_fnc_addSetting;

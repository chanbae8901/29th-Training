/**
 * Function: DOTT_radio_fnc_add
 * Author:   Hill [29th ID]
 *
 * Description:
 *   Assigns the faction-correct TFAR SR radio to the player if
 *   they have no radio in the linked slot, or forces the correct
 *   one based on the TN_addRadio setting.
 *
 * Parameters:
 *   None
 *
 * Returns:
 *   true
 */

if (!hasInterface) exitWith {};

if (isClass (configFile >> "CfgPatches" >> "task_force_radio_items")) then
{
    // 0 = disabled, 1 = only when empty, 2 = force side radio.
    if (TN_addRadio == 0) exitWith { true };

    // Slot index 9, sub-index 2 is the linked radio item.
    private _hasNoRadio =
        (((getUnitLoadout player) select 9) select 2) == "";

    if (TN_addRadio == 2 || { _hasNoRadio }) then
    {
        switch (side (group player)) do
        {
            case WEST:
            {
                player linkItem "TFAR_anprc152";
            };
            case EAST:
            {
                player linkItem "TFAR_fadak";
            };
            case INDEPENDENT:
            {
                player linkItem "TFAR_anprc148jem";
            };
            default {};
        };
    };
};

true

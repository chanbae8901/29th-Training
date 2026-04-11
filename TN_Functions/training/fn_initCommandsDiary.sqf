#include "script_component.hpp"
/*
 * Author: Bae [29th ID]
 * Creates the "Useful Commands" diary entries on the local
 * player. Intended to be remoteExec'd to the admin client
 * when admin state changes. Waits for preload to finish if
 * called too early, and is not created if it already exists.
 *
 * NOTE: Diary content must be manually updated if commands
 * change.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * call TN_training_fnc_initCommandsDiary;
 */

if !(PRELOAD_FINISHED) exitWith {
    [{PRELOAD_FINISHED}, FUNC(initCommandsDiary)] call CBA_fnc_waitUntilAndExecute;
};

if (!isNil QGVAR(commandsDiaryCreated)) exitWith {};

player createDiarySubject ["usefulCommands", "Useful Commands"];

player createDiaryRecord [
    "usefulCommands",
    [
        "Misc",
        "<font color='#FF00FF'>!cleanup</font><br />" +
        "Deletes all bodies and ground items on the map.<br /><br />" +

        "<font color='#FF00FF'>!arsenal</font><br />" +
        "Creates an ACE arsenal in front of the player.<br /><br />" +

        "<font color='#FF00FF'>!goto <font color='#00FFFF'>[side]</font></font><br />" +
        "Teleports admin to side spawns (<font color='#00FFFF'>blufor</font>, <font color='#00FFFF'>opfor</font>, <font color='#00FFFF'>grnfor</font>).<br /><br />" +

        "<font color='#FF00FF'>!s</font><br />" +
        "Opens the GUI for global mission settings.<br /><br />" +

        "<font color='#FF00FF'>!measure <font color='#00FFFF'>[set]</font></font><br />" +
        "Measure distances on the map using shift + click markers.<br />" +
        "Use <font color='#00FF00'>!measure <font color='#00FFFF'>set</font></font> to save a reference point.<br />" +
        "Use <font color='#00FF00'>!measure</font> to get the distance from that reference to your shift + click marker."
    ]
];

player createDiaryRecord [
    "usefulCommands",
    [
        "Reset",
        "<font color='#FF00FF'>!reset <font color='#00FFFF'>[stay/side]</font></font><br />" +
        "Rearms, heals, and (optionally) teleports players to spawn.<br />" +
        "Use <font color='#00FF00'>!reset</font> to rearm, heal, and teleport.<br />" +
        "Use <font color='#00FF00'>!reset <font color='#00FFFF'>stay</font></font> to rearm and heal only.<br />" +
        "Use <font color='#00FF00'>!reset</font> (<font color='#00FFFF'>blufor</font>, <font color='#00FFFF'>opfor</font>, <font color='#00FFFF'>grnfor</font>) to target a specific side.<br /><br />" +

        "<font color='#FF00FF'>!heal <font color='#00FFFF'>[side]</font></font><br />" +
        "ACE Heals players and removes hearing deafness.<br />" +
        "Use <font color='#00FF00'>!heal</font> for all players, or <font color='#00FF00'>!heal <font color='#00FFFF'>[side]</font></font> to target a specific side.<br /><br />" +

        "<font color='#FF00FF'>!rearm <font color='#00FFFF'>[side]</font></font><br />" +
        "Rearms players.<br />" +
        "Use <font color='#00FF00'>!rearm</font> for all players, or <font color='#00FF00'>!rearm <font color='#00FFFF'>[side]</font></font> to target a specific side.<br /><br />" +

        "<font color='#FF00FF'>!debrief <font color='#00FFFF'>[here]</font></font><br />" +
        "ACE Heals and teleports players for debrief.<br />" +
        "Use <font color='#00FF00'>!debrief</font> to teleport all to Blufor base.<br />" +
        "Use <font color='#00FF00'>!debrief <font color='#00FFFF'>here</font></font> to teleport all to your current position."
    ]
];

player createDiaryRecord [
    "usefulCommands",
    [
        "Round System",
        "<font color='#FF00FF'>!timer <font color='#00FFFF'>[minutes]</font></font><br />" +
        "Sets length of next round.<br /><br />" +

        "<font color='#FF00FF'>!live</font><br />" +
        "Starts the round with length set by <font color='#00FF00'>!timer</font>.<br /><br />" +

        "<font color='#FF00FF'>!addtime <font color='#00FFFF'>[minutes]</font></font><br />" +
        "Adds or subtracts time from the current round timer. Can only be used when round is LIVE.<br /><br />" +

        "<font color='#FF00FF'>!quicktimer <font color='#00FFFF'>[minutes]</font></font><br />" +
        "Starts a round instantly with specified time length.<br /><br />" +

        "<font color='#FF00FF'>!game</font><br />" +
        "Ends the current round. Can be used to display game notification even if round is not running.<br /><br />" +

        "<font color='#FF00FF'>!safe <font color='#00FFFF'>[minutes]</font></font><br />" +
        "Immediately forces safe start with specified time, or ends forced safe start if given <font color='#00FFFF'>0</font>."
    ]
];

GVAR(commandsDiaryCreated) = true;

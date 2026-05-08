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
        "<font color='#FF00FF'>!cleanup</font><br/>" +
        "Deletes all bodies and ground items on the map.<br/><br/>" +

        "<font color='#FF00FF'>!arsenal</font><br/>" +
        "Creates an ACE arsenal in front of the player.<br/>" +
        "Disappears on round start.<br/><br/>" +

        "<font color='#FF00FF'>!goto <font color='#00FFFF'>[side]</font></font><br/>" +
        "Teleports admin to side spawns (<font color='#00FFFF'>blufor</font>, <font color='#00FFFF'>opfor</font>, <font color='#00FFFF'>grnfor</font>).<br/><br/>" +

        "<font color='#FF00FF'>!s</font><br/>" +
        "Opens the GUI for global mission settings.<br/><br/>" +

        "<font color='#FF00FF'>!measure <font color='#00FFFF'>[set]</font></font><br/>" +
        "Measure distances on the map using shift + click markers.<br/>" +
        "Use <font color='#00FF00'>!measure <font color='#00FFFF'>set</font></font> to save a reference point.<br/>" +
        "Use <font color='#00FF00'>!measure</font> to get the distance from that reference to your shift + click marker."
    ]
];

player createDiaryRecord [
    "usefulCommands",
    [
        "Tickets",
        "Each ticket represents an additional respawn/life for a side.<br/>" +
        "When a player respawns during a live round, their side loses a ticket.<br/>" +
        "Players are notified on respawn if they are allowed back in combat or must stay in spawn.<br/><br/>" +

        "When the round is not live, changes set the starting tickets which are restored at the start of each round.<br/>" +
        "When the round is live, changes apply to the current round only.<br/><br/>" +

        "<font color='#FF00FF'>!t enable</font> / <font color='#FF00FF'>!t disable</font><br/>" +
        "Enables or disables the ticket system.<br/>" +
        "Enabling resets all ticket counts to zero.<br/><br/>" +

        "<font color='#FF00FF'>!t</font><br/>" +
        "Shows current ticket counts for all sides.<br/><br/>" +

        "<font color='#FF00FF'>!t <font color='#00FFFF'>[side]</font> <font color='#00FFFF'>[amount]</font></font><br/>" +
        "Sets a side's tickets to an exact amount.<br/>" +
        "Example: <font color='#00FF00'>!t blufor 10</font><br/><br/>" +

        "<font color='#FF00FF'>!t <font color='#00FFFF'>[side]</font> <font color='#00FFFF'>[+/-amount]</font></font><br/>" +
        "Adds or subtracts from the current ticket count.<br/>" +
        "Example: <font color='#00FF00'>!t blufor +5</font> or <font color='#00FF00'>!t opfor -3</font><br/><br/>" +

        "<font color='#FF00FF'>!t reset</font><br/>" +
        "Clears all tickets, including the starting values restored each round."
    ]
];

player createDiaryRecord [
    "usefulCommands",
    [
        "Reset",
        "<font color='#FF00FF'>!reset <font color='#00FFFF'>[stay/side]</font></font><br/>" +
        "Rearms, heals, and (optionally) teleports players to spawn.<br/>" +
        "Use <font color='#00FF00'>!reset</font> to rearm, heal, and teleport.<br/>" +
        "Use <font color='#00FF00'>!reset <font color='#00FFFF'>stay</font></font> to rearm and heal only.<br/>" +
        "Use <font color='#00FF00'>!reset</font> (<font color='#00FFFF'>blufor</font>, <font color='#00FFFF'>opfor</font>, <font color='#00FFFF'>grnfor</font>) to target a specific side.<br/><br/>" +

        "<font color='#FF00FF'>!heal <font color='#00FFFF'>[side]</font></font><br/>" +
        "ACE Heals players and removes hearing deafness.<br/>" +
        "Use <font color='#00FF00'>!heal</font> for all players, or <font color='#00FF00'>!heal <font color='#00FFFF'>[side]</font></font> to target a specific side.<br/><br/>" +

        "<font color='#FF00FF'>!rearm <font color='#00FFFF'>[side]</font></font><br/>" +
        "Rearms players.<br/>" +
        "Use <font color='#00FF00'>!rearm</font> for all players, or <font color='#00FF00'>!rearm <font color='#00FFFF'>[side]</font></font> to target a specific side.<br/><br/>" +

        "<font color='#FF00FF'>!debrief <font color='#00FFFF'>[here]</font></font><br/>" +
        "ACE Heals and teleports players for debrief.<br/>" +
        "Use <font color='#00FF00'>!debrief</font> to teleport all to Blufor base.<br/>" +
        "Use <font color='#00FF00'>!debrief <font color='#00FFFF'>here</font></font> to teleport all to your current position."
    ]
];

player createDiaryRecord [
    "usefulCommands",
    [
        "Round System",
        "<font color='#FF00FF'>!timer <font color='#00FFFF'>[minutes]</font></font><br/>" +
        "Sets length of next round.<br/><br/>" +

        "<font color='#FF00FF'>!live</font><br/>" +
        "Starts the round with length set by <font color='#00FF00'>!timer</font>.<br/><br/>" +

        "<font color='#FF00FF'>!addtime <font color='#00FFFF'>[minutes]</font></font><br/>" +
        "Adds or subtracts time from the current round timer. Can only be used when round is LIVE.<br/><br/>" +

        "<font color='#FF00FF'>!quicktimer <font color='#00FFFF'>[minutes]</font></font><br/>" +
        "Starts a round instantly with specified time length.<br/><br/>" +

        "<font color='#FF00FF'>!game</font><br/>" +
        "Ends the current round. Can be used to display game notification even if round is not running.<br/><br/>" +

        "<font color='#FF00FF'>!safe <font color='#00FFFF'>[minutes]</font></font><br/>" +
        "Immediately forces safe start with specified time, or ends forced safe start if given <font color='#00FFFF'>0</font>."
    ]
];

GVAR(commandsDiaryCreated) = true;

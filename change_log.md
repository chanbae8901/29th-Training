---
Overall Future Goals
---
* "Citadel" game mode
	- Instead of regular cap zone, instead proximity to center adds more weight
	- Not really for training... but events
	- Could define area with polygon instead of circle or rectangle
* Check if player in zone (inPolygon? Also marker rectangle or circles)
* Random mortars in area defined by admin
* Teleport pole that teleports you inside a radius, or into an area, or along a circle edge (COULD USE POLY TOO)
	- Poly contained in circle, check random points in circle until you find one in poly?
* Wave system for team leaders to call in player waves
  - Could also use timer
* Deploy area. Allow a side to deploy within or outside of a designated circle.
* Fix Security Flaws
  - Limit remote exec functions
  - allowFunctionsRecompile = 1; is necessary for custom sector settings, can't think of a way to bypass this
  - This is a low priority since this mission file is intended to be used on private servers.
* CTF system via chat commands
  - Pole addactions to score?
  - Maybe no flag? Drop object on death that is the "flag"
* Possibly restricting chat commands to certain slots/players
  - Add ability to admin to add players to array?
  - Unit string indicators like sl, plt, etc...
  - Player profile string reading for Cpl, Sgt, etc?

---
v4.5.0
1 MAY 2026
---
* General
  - All "DOTT" tags in functions and variables converted to "TN", `Dott_Functions` folder
    renamed to `TN_Functions` per 1Lt. Ericksen request. Months of muscle memory wasted.
  - Swapped from Allman to K&R indentation style to match ACE 3 coding guidelines.
  - Convert raw variable/function references to CBA macros (`GVAR`, `FUNC`, `QGVAR`, etc.) across the entire codebase.
  - Add `SERVER_LOG` macro for logging messages to server RPT via `remoteExecCall`.
  - Use `IS_ADMIN` / `IS_ADMIN_LOGGED` CBA macros to replace `serverCommandAvailable "#lock"` checks across the codebase.
  - Add `USING_MODULE` macro to `script_macros.hpp`. Modules now check if dependent modules exist in
    the template before initializing their features.
  - Move `templates.hpp` include from individual files to `script_macros.hpp` so it's available globally.
  - Standardize CBA event names across all modules. Replace event names in `cfgEventHandlers`
    with `GVARMAIN` macro since they are called outside of function folders.
  - Convert any `remoteExec` that does not need a scheduled environment into `remoteExecCall`.
  - Expanded logging in `init.sqf` and `initPlayerLocal.sqf`. Each module now logs its run time during initialization.
  - Removed duplicate `cfgNotifications` include in `description.ext`.
  - Claude assisted codebase restructure:
    Fixed spelling mistakes, standardized indentation, and removed commented out code and unnecessary brackets.
    Deduplicated code and removed dead code. Reduced size of `gui.hpp` by using inheritance.
    Reformatted function headers to ACE standard.
  - HEMTT linting pass: remove redundant bool comparisons, use `in` over `find`, `isNotEqualTo` over negated `isEqualTo`,
    replace `==`/`!=` with `isEqualTo`/`isNotEqualTo`, `toLower` to `toLowerANSI` for non-user-input strings,
    remove redundant `_this` in call expressions, improve array emptiness checks, remove unnecessary short-circuit braces,
    use `parseNumber`/`configOf`, convert variable declarations to `params`.
  - Defined magic numbers and converted constant variables into `#define`.
  - Renamed global variables for consistency, added module name prefix to base global variables.
  - Moved code from oversized `addEventHandler` (incl. CBA) and `addMissionEventHandler` blocks into separate function files.
  - Moved logic from oversized files into subfolders (`readyui`, `tracker/diary`).
  - Replaced `findIf` with `in`, `switch` with `select` for static literal cases, and `entityCreated` event handlers with `addClassEventHandlers`.
  - Ensured all void functions explicitly return nil.
  - Fix BLUFOR Base right light unintentionally simulation disabled.
  - Renamed many event handler functions from `fn_handle*` to `fn_on*` prefix across all modules
    (e.g. `fn_handleHit` → `fn_onHit`, `fn_handleFrequencyChanged` → `fn_onFrequencyChanged`, etc.).
  - Replace `"Man"` with `"CAManBase"` for more precise unit class matching (excludes animals).
  - Attempt to fix rare bug where players are invisible
    
* Unscheduling Effort
  - Major pass to replace `spawn`/`waitUntil` patterns with unscheduled `call` and CBA alternatives (`perFrameHandler`, `waitAndExecute`).
    Scheduled environment is less predictable, so moving as much as possible to unscheduled.
  - Round init, round events (via `perFrameHandler`), `checkWinCondition`, `aliveCheck` all now unscheduled.
  - Spectator enter/exit no longer use scheduled environment.
  - Tracker and parade init unscheduled.
  - `setInsignia` and `fullSetUnitLoadout` now use `call` instead of `spawn`.
  - `flexibleReset` partially unscheduled (still needs scheduled for sleep).
  - `event/fn_respawn` refactored to be callable by moving the `spawn` into the calling code.
  - `excludeObjects` loop replaced with `perFrameHandler`.

* Base
  - Arsenal zone check refactored to fire CBA events (`enteredArsenalZone`/`exitedArsenalZone`) instead of containing inline logic.
  - Force parade action reworked: dynamically added/removed based on admin state via `adminStateChanged` event.
  - Environment sound muting logic moved from base to training module.
  - New `fn_initPlayersInBase` to track players in arsenal zones server-side, bridging client events to server for admin notification.

* Commands
  - Chat interception reverted back to waiting for display instead of event handler.
    More overhead, but needed due to security concerns as this method does not send the hidden chat over network.
    Modernized code by getting rid of conversion to array.
  - Rename `pvpfw_chatIntercept` prefix to `TN_commands`.
  - Move base `commands.sqf` initialization out of `XEH_preInit` into `fn_init` so it's no longer run on server.
  - Rewrote arsenal command and moved logic into separate subfolder.
    Arsenals created with this command are deleted automatically on round start.
  - Defer HashMap finalization of command registry until global `initFinished` event fires.
  - Executing a command as non-admin now sends admin a notification, with some exceptions.

* Common (New Module)
  - Deduplicate admin change event handlers by creating `TN_adminStateChanged` CBA event.
  - Add `convertSide` utility function, simplifying side string-to-side conversion in ticket and loadout commands.
  - Add `notifyAdmin` function for sending systemChat messages to the current admin, with `notifySelf` parameter.
  - Admins notified via systemChat when another player uses a command.
  - Created timedHint function to have a nice way to have hints time out quickly and prevent conflict between different callers of hint.
    Replaced most calls (except spectator stuff) to it.
  - Moved `fn_cleaner` from base to common as `fn_cleanup`. Ground item deletion made global.

* Curator
  - `fn_addPlayerEditable` generalized to `fn_addEditable`.
  - Remove `roleDescription` param from `createModule`.
  - No longer delete in `createModule` to reduce lag spikes, simply unassign and reassign.

* Event
  - Merged admin actions on flag into a single "Event Menu", which opens a GUI displaying actions that were formerly on the pole.
    Care taken to ensure new ready UI system is not hidden when GUI is opened.
  - Event Menu now attached to player's admin object instead of the flags. Creates `fn_handleAdminEventMenu.sqf`.
  - New "Forced Safe Start" system implemented, admin can start long safe start and teams can ready to reduce to shorter safe start.
  - Added changing round time remanining when round is live in Event Menu.
  - `fn_markEditorPlacedObjects`: fix wrong variable (`_x` -> `_obj`) in `boundingBox` call.
  - Rename `gameCalled` variable to `TN_event_missionEnded`.
  - Fix oversight where starting deaths were not tracked before round start.
  - Remove `_forceEnding` as a parameter from `fn_game`.
  - Add `private` declarations for local variables in `fn_markEditorPlacedObjects`.
  - Remove no longer used `endingObject` variable.
  - Rename `hasTimer` to `useRoundSystem` for clearer naming — it controls the entire round/ready system, not just a timer.
  - Expanded `useRoundSystem = false` support for PvE/non-competitive modes: time acceleration, win condition checks,
    and Event Menu endings all work without the round system.
  - Expanded documentation on how settings in eventSettings interact with each other.
  - Added `eventSettings.sqf` validation (`fn_validateSettings.sqf`) with descriptive error messages for invalid settings.
  - New lives system in `trackLives` subfolder: admin can adjust team lives mid-game via Event Menu GUI.
    Players out of lives cannot respawn. Admin faction excluded. 
  - New settings: `penalizeJIPLives`, `disableScoreboard`, `stopTimeUntilLive`.
  - Reworked `fn_aliveCheck` into event-based `fn_initAliveCheck`. Split win condition loop into `fn_initWinConditions`
    and `fn_checkWinConditions`. Both deduplicate notifications and add a delay before firing.
  - `fn_game` renamed to `fn_endMission`.
  - Removed `respawnDisarmPlayers`, `spectateArea`, `spectateAreaRadius`, and `endFlag` settings.

* Loadout
  - Add additional failsafe for `flexibleReset` teleport, if player is not within 75 meters of teleport point
    5 seconds after teleport attempts, all players will be notified in chat.
  - Remove `resetWeaponState` function. `fullSetUnitLoadout` now strips all gear, waits for weapon switch
    to finish, then reapplies loadout as an alternate silent weapon bug fix approach.
  - `setInsignia` moved from loadout module to parade module, since it requires the 29th mod.
  - `fullSetUnitLoadout` fires `afterSetLoadout` CBA event when done (used by parade for insignia).

* OCAP
  - Updated folder to remove marker related workarounds to be compatible with OCAP Addon 2.1.0.
  - Instead of replacing `startRecording` and `stopRecording`, hijack the PFHObject to run when an additional variable we create is true.
  - Add timeout and logging if OCAP variables fail to initialize.

* Radio
  - Notify player in systemChat when their vehicle's long-range radio is adjusted to match faction default.

* Parade
  - Fix custom parade uniform not being applied on join by making the respawn loadout the same as the forced parade loadout.
    This change has a side effect where this parade loadout is overwritten when leaving arsenal, but this should not be a problem.
  - Uniform message now states if loadout is not the default.
  - `checkNonCombatLoadout` now also recognizes Class A uniforms as non-combat.
  - Now waits until fullSetUnitLoadout finishes before applying.

* Round
  - All players notified in systemChat when a side readies or unreadies.
  - Add safe start time to the Round Ready UI.
  - Safe start timer now restores to the remaining forced duration when a team unreadies after all teams had readied up early,
    adjusted for time passed.
  - Replace `fn_isRoundActive` function and `TN_round_safeStartActive` variable with a single `TN_round_state` integer enum.
    New `data/roundState.hpp` provides `ROUND_IDLE`, `ROUND_SAFE`, `ROUND_LIVE` defines so code reads cleaner than comparing raw numbers.
  - Rename vague `data/defines.hpp` to `templates.hpp`.
  - Safe start helper now uses `perFrameHandler` instead of chained `waitAndExecute`.
  - Deleting disconnected bodies moved here from training, which means it also applies to event variation.
    Now simply deletes all disconnecting bodies unless round is live.
  - Add instructions to systemChat safe start notification.
  - Removed overtime support.
  - Add nil check for `disableRespawnScoreboard`.
  - Don't reduce team score when `disableScoreboard` event setting is not enabled.

* Settings
  - Add check to exclude non-global settings from GUI.

* Spectator
  - Swapped from BIS EGSpectator to ACE spectator (`ace_spectator_fnc_setSpectator`).
    Falls back to BIS EGSpectator if ACE spectator is not available.
  - New ACE medical overlay while in spectator mode. Shows ACE body part damage & blood of the
    currently focused unit. Press H to toggle visibility.

* Ticket
  - Cache current admin into `fn_init` to avoid repeated lookup in `fn_count`.
  - Refactor to use a single array to store tickets instead of 3 separate team variables.
  - Deeper round system integration: dual-mode ticket tracking with `startingCounts` (persisted across
    rounds) and `counts` (live round state). Starting counts restored each round start.
  - New `fn_set` for setting absolute ticket values and `fn_reset` for resetting/enabling/disabling.
    Removed `fn_add` — setting logic consolidated into `fn_set`.
  - Admin sees starting ticket counts at round start.
  - `!tickets` command shorthand changed to `!t`.

* Tracker
  - Optimize `sendHit` by not inadvertently creating a new HashMap even if it's not needed.
  - Fix hit not overwriting potentially saved hit time if projectile has hit other valid objects.
  - Batch vehicle and crew `sendHit` calls into a single `remoteExecCall` instead of one per unit by passing an array of objects.
  - Fix `burnSimulation` EH searching for incendiary grenades around player instead of the burning unit when instigator is null.
  - Move incendiary grenade find logic to separate function (`fn_findIncendiaryGrenade`).
  - Optimize `burnSimulation` EH by skipping all `nearObjects` searches if the burn instigator was cached within the last 5 seconds.
    The cache timestamp is reset whenever a new instigator is found, so the window stays fresh while the unit is actively burning.
    After 5 seconds the searches resume, allowing re-attribution if the unit walks into a new fire source.
  - Optimize `woundReceived` burn handler by removing a redundant `_fn_findSide` call in the null instigator path.
    The result was always immediately overwritten by the same call that runs unconditionally after the if/else block.
  - Temporary method of sending round history on join finally reworked, send all rounds in 1 `remoteExec` to new `receiveAll` function.
  - New subfolder `eventHandlers` that holds related code.
  - Removed params enabling or disabling system, move out disabling statistics diary entry to training and event.

* Training
  - Deleting bodies at base on disconnect no longer occurs during round live to reduce lag spikes caused by disconnecting.
  - Moved deleting disconnecting bodies to round.
  - Admin now has a "Useful Commands" entry in his map diary.
  - Now notify admin when all players on one side are all dead or in base.

* Vehicle
  - Added workaround for ACE bug that left vehicle seats locked when uncon -> dead players were moved out of the seat via ACE interaction.
    While ACE has a variable toggle to turn this feature off, doing so causes various bugs that can cause confusion to players, so a workaround
    was the best choice. Waits 0.5 seconds after ACE's potential failed attempt to unlock vehicle and tries it when (assume network race conditions)
    should no longer cause the bug.

---
v4.4.2
06 MAR 2026
---

* Curator
  - Revert moving logic server side from 4.4.0 since OnUserSelectedPlayer event fires on every respawn and not just initial join.
  - Check if object is not local-only before adding to excludeObjects list.

* Loadout
  - Fix fullSetUnitLoadout not correctly applying drab version of Insiginia.

* Radio
  - Radios from disconnecting bodies are now deleted as well.

* Round
  - Added !safe as a new command, which allows the admin to force safe start with a specified time in minutes, 
    or unforce safe start if given 0 (E.G. '!safe 1' forces a 1 minute safe start)".
    Teams can still ready up, and if all teams ready up during this forced safe start period, it will shorten to the default safe start period.
    Creates fn_changedForcedSafeStart.sqf along with public variable DOTT_round_ignoreReadiness.
  - Added HUD overlay showing team ready status during safe start. (Thanks PFC Wells.) Creates fn_initReadyUI.sqf

* Tracker
  - Hopefully finally fixed small issue where instigator is unknown by defaulting side of instigator to first entry in _unitSides instead
    of sideUnknown if _time is lower than all entries. Previous fix attempts in 4.4.0 and 4.4.1 likely could be reverted, but will leave in place.

* Training
  - Disconnecting bodies in base are now automatically deleted. 
    Logic maybe belongs in base module instead, but this was the easier route and don't know if we want event template to have this behavior.

* Increase hiding respawn body on old body time from 0.5 to 1 seconds in initPlayerLocal.

---
v4.4.1
25 FEB 2026
---
* Base
  - Make terminal animation trigger creation local instead of global. Oversight from 4.4.0 that was potentially a source of lag during mission.

* Tracker
  - Added one missing side civilian check in recordKill (from 4.4.0).

* Training
  - Removed BIS_fnc_endMission from overrideFunctions.sqf. Initial purpose was to stop missing ending on end of countdown timer, 
    but this behavior has not been reproduced in testing. (Famous last words.) (Might be due to respawn template settings in older versions.)
    Done as an initial step to troubleshooting OCAP not saving the map correctly sometimes, but likely will not fix.
    Otherwise useful to get rid of unneeded things in the mission file.

---
v4.4.0
19 FEB 2026
---
* mission.sqm changes
  - Renamed “Medic” to “Rifleman (Medic)” to maintain consistency of showing ACE roles in parentheses.
  - Removed ACE Advanced Engineer trait from Combat Engineer slot.
  - Renamed Engineer slot to Crewman and added 1x more (2 total) per squad.
  - Swapped all “Engineer” types to “Crewman” types. (Some squads had the former instead of the latter for Engineer (Repair) type.) 
    (Just makes it easier to search for all roles, not important otherwise.)
  - Remove redudant group name prefix from all roles, and remove the CBA @Group suffix from non-first in group units (only the first unit in a group needs it, 
    makes it easier to maintain/edit roles in future).
  - Guest squad composition uniform with non-guest squad.
  - Added 1 more Autorifleman and Combat Engineer slot to each squad.
  - Removed CP1S3.
  - Removed Platoon Sniper slot.
  - Added 1x SNCO slot in Battalion/Regiment.
  - Removed rifleman slots to make each squad have 16 members.
  - OPFOR and GRNFOR slot composition now matches 1 platoon of BLUFOR.

  - Renamed base object variables to unify training and event base scripts.
  - Disabled simulation, enabled simple object, and/or enabled local only on some objects in base for optimization.
    (Trash can needs no simple object, lights need simulation on, keep ammo box non-local so inventory is synced)
  - Removed Game Master modules from the sqm, create via script instead. 
  - Remove trigger from sqm animating terminals, they are added by script now (already existing from event version of initBaseObjects).
  - Remove deprecated TFAR module (hopefully didn't do anything anymore).

* Base Placement
  - Altis remains at airport per tradition, otherwise
  - ALWAYS put the base within map bounds/play area to ensure location scripts do not misbehave (ex. ZEN Teleporters)
  - Prioritize placing away from POIs, optimially in the sea bottom-left of the map (still in map bounds as stated above).

* New Base Module
  - Transfers/unifies initBaseObjects -> init and cleaner functions from training and event modules. Removed respective versions from said modules.
  - Possible due to renaming base object variables to follow more versatile event version.
  - NEW FEATURE: Environment sounds now disabled while in base (determined by ACE Arsenal radius) for less distracting (de)briefs.
  - centers array for arsenals now global (DOTT_arsenal_centers), can be edited before by other modules (ex. training) without being overwritten

* Curator
  - Add createModule, which creates Game Master modules when a player in an assigned slot loads in.
  - Remove checkAssignment, fixAssignment. createModule will simply delete and recreate if already existing, 
    which will alternatively fix the issue that these are fixing.
  - Moved some logic (setCuratorVisionModes, addPlayerEditable) so that it is no longer remoteexec'd from client to server.

* Loadout
  - Use ace_common_fnc_addToInventory to hopefully fix rare issue where equipped grenades are not throwable when resetWeaponState is used.

* OCAP
  - Swap center sector marker from shield to objective marker because it somewhat looks like a person when zoomed out in OCAP.

* Tracker
  - Also check if side is civllian to reduce cases where instigator side is unknown in recordKill and addEventHandlersClient.

* Training
  - Move array of Zues slots here from curator.
  - Team base locations now show up in curator.
  - Handle finding arsenal centers for base module to have it be between the arsenal and respawn for each base.
---
v4.3.8  
07 FEB 2026
---
* Loadout
  - Flexible reset no longer rearms player if in base (determined by ACE Arsenal action showing up). Until silent weapon bug is reasonably fixed, 
    reducing opportunities for it to happen.
  - Moved last experimental resetWeaponState implementation to only when closing arsenal, remove all other experimental loadout changes from 4.3.7.
  - EXPERIMENTAL: resetWeaponState now removes and reequips primary and handgun weapon after a delay, and ammunition afterwards. 
    Delays are naturally longer due to weapon swapping animations.
    Only using for flexibleReset and not onArsenalClosed due to being too intrusive for the latter.

* OCAP
  - Check if count _area = count _areaMarkers to avoid error caused by it being false in loop.
    Not entirely sure why they would be different at times, so just skipping (should be safe logic wise) to avoid error log.

---
v4.3.7  
04 FEB 2026
---
* Loadout
  - EXPERIMENTAL: Reimplemented resetWeaponState, instead of messing with binoculars will remove and reinsert magazine of primary weapon.
  - EXPERIMENTAL: Flexible reset now removes all magazines (including grenades) from player before resetting loadout, and now also calls resetWeaponState again.
  - FlexibleReset will now skip rearming players in spectator box. Until silent weapon bug is reasonably fixed, reducing opportunities for it to happen.
  - Removed experimental addition of setUnitLoadout in 4.3.5.

* OCAP
  - Fix not passing variable into sleep in 4.3.5 (...again).

* Parade
  - Force parade now always swaps to parade loadout (no checking if in non-combat uniform such as Class A).

---
v4.3.6  
02 FEB 2026
---

* Loadout
  - EXPERIMENTAL: Apply setUnitLoadout before CBA_fnc_setLoadout to attempt to replicate conditions where silent bug doesn't appear for players who haven't respawned.

* Round
  - Remove server side checking for silent weapon, mostly pointless since client side can cause the issue.
  - Client side check notification now condensed, excludes showing who views the issue.

* OCAP
  - Wait 10 seconds after sector is created to create marker to wait for any Zeus changes.
  - Remove 'fix' halfing sector marker size.

* Spectator
  - Reworked invulnerability to work around the fact that BIS spectator function implicitly does it already.

---
v4.3.5  
29 JAN 2026
---
* Curator
  - Fix _unit not being passed to spawned code in init

* Loadout
  - EXPERIMENTAL: Altered fullSetUnitLoadout to not use resetWeaponState and instead swap the player's weapon to some unlikely used vanilla weapon (CPW) before
    reapplying loadout to attempt to reduce silent weapon bug.

* OCAP
  - Add showing sectors on map w/ side changes
    NOTE: Reduced marker size in half while creating it since OCAP seems to make it twice the actual size, but it seems other markers do the exact opposite
    and become half the size?
  - Updates in OCAP recording (ex. sector moved or changed size) show up several seconds after when it actually happened/may not even be tracked, 
    but better than nothing I guess.

* Thermals
  - Fix disabling PIP Thermals not working due to mistakenly being executed server side instead of client.

---
v4.3.4  
20 JAN 2026
---
* Commands
  - !weaponstate added, which shows a list of players that currently have silent weapons for the player.

* Loadout
  - Remove enableSimulationGlobal from teleport script in attempt to fix silent weapon bug cause

* Spectator
  - Remove enableSimulation from enter/exit in attempt to fix silent weapon bug cause

---
v4.3.3  
19 JAN 2026
---
* Round
  - Replace incorrect exitWith with continue for round start checking weapon states.
  - Client side weapon state check waits 2.5 seconds for server side weapon state fix now.
  - Notification for client side weapon state check happens 5 seconds after round start (if any found).
  - Reworked client side weapon state notification to be less spammy.

---
v4.3.2  
11 JAN 2026
---

* Curator
  - Fix unassign/assign curator not executed in scheduled environment error.

* Event
  - Replace Ready All Sides flag function with initSafeStart.
  - Side ready flag action now has safe start begin event handler.

* OCAP
  - Fixed incorrect variable name in initializePlayer (ocap_nextId -> ocap_recorder_nextId)
  - remoteExecCall instead of remoteExec initalizePlayer (can't risk interruption midway)

* Round
  - Added check to see if safestart is running before initalizing safestart.
  - Log weaponstate of every player to server log at beginning of round (hopefully helps figure out silent bug issue).
  - Players will send notice to all players if they detect a known cause of silent weapon at beginning of round (hopefully helps figure out silent bug issue). 
  - initSafeStart now forces all sides as ready (for better event compatibility)
  - Replaced bluReady, opfReady, grnReady with DOTT_round_sideReady array to simplify code.
  - Rename event "DOTT_round_sideReadyChanged" -> "DOTT_round_manageReadyChange" so it's less misleading. (Side ready can change outside this event/function).

* Spectator
  - Moved loadout teleport check after sleep.

* Thermals
  - Fixed incorrect condition check breaking black no thermal screen.

* New Parade/Class-A Uniform Update
  - Default Respawn Parade Loadout Updated
  - Default Parade Loadout in ACE Arsenal (training/fn_initDefaultLoadouts.sqf) Updated
  - parade/fn_checkNonCombatLoadout.sqf updated
  - Remove Dress Blues in parade/fn_checkNonCombatLoadout.sqf

---
v4.3.1  
9 JAN 2026

---

* OCAP Integration
  - New folder "ocap" under DOTT_Functions.
  - Mission automatically starts recording on safestart/live and pauses recording on round end.
  - Safe start begin/abort and round start/end shown as events in OCAP recording.
  - Should upload automatically when mission ends.
  - Adds cba_settings.sqf and cba_settings_hasSettingsFile = 1 in description.ext.
  - Workarounds that
      Remove OCAP started recording notification
      Let markers created and removed between rounds be tracked
      Let ACE moved markers be tracked
      Prevent major but unlikely issue where if save has no markers, it is formatted improperly and breaks.
  - Issues:
      Sectors do not show up properly on map, capture event will be displayed however.
      Due to workarounds, created markers show up in recording 2 seconds after they were created.
      Editing a marker before 2 seconds after creation likely will cause incorrect tracking.
      Renaming markers is not tracked.
  - Not Tested:
    Team Swapping during/between rounds

* Continued Modularization
  - CBA settings split from single file in settings folder to XEH_preInit.sqf in relevant subfolders.
  - Categories renamed/reorganized to match modules more.
  - main init.sqf and XEH_preInit.sqf make use of DOTT_Modules defines in data\defines.hpp
    by checking if relevant module init functions or setting files exist.
  - Minimize the amount of #ifdefs in the code (many used for loading optimization) for maintainability.
  - Commands split from single file in commands folder to commands.sqf in relevant subfolders.

* Commands
  - Command usage is now case insensitive again. (Accidentally introduced sensitivity in 4.3.0).
  - Not logged commands, restricted, and admin command lists are now CBA settings. Will not be shown in mission settings GUI.
  - Added removedCommands CBA setting that blocks commands for everyone.

* Curator
  - Hopefully fix role-based Zeus not working on first life when JIP.
  - Fix error when admin logs out.

* Radio
  - Prevent arsenal closed from being called if Zeus is open.
  - Added BIS arsenal event handler.

* Loadout
  - Prevent arsenal closed from being called if Zeus is open.
  - Increase invulnerability time by 2 more seconds on teleport to reduce damage on teleport instances.
  - setInsignia no longer throws error if 29th Insignias are missing.

* Parade
  - Hopefully fix inconsistent case where Forced Parade is not applied on join.
  - Will not load if 29th Mod is not loaded.

* Spectator
  - Invulnerability extended to two seconds to reduce damage instances from leaving box.
  - Let teleport from loadout (flexibleReset) override allowDamage if player is teleporting.
  
- Renamed event "DOTT_exitedMainMenu" to "DOTT_exitedPauseMenu" for better accuracy.

---
v4.3.0  
27 DEC 2025

---
* Fixes
  - Fix case where attacker's side was not properly found in Round Events system.
  - Remembered to actually wait longer for unconscious report to prevent incorrect event.
  - Disabling scoreboard in settings GUI now also reenables scoreboard for anyone in respawn menu at the time.
  - Fix radio settings not properly transfering over for prototype radios. Now unified behavior with non-prototype radio setting transfer.
  - Workaround for inconsistent bug where chat is no longer displayed after leaving pause menu.

* Event Integration
  - Event variation of this file has been merged with this template.
  - To switch, enable only one of the proper define in data/defines.hpp and swap the mission.sqm to the proper version.
  - Sanity checked but not throughly tested to see if everything is working, will need to do so before any events.
    EDIT: Flag actions currently bit bugged, will need to fix later.
  - When possible, existing files were modified to smoothly accomodate both, but due to mission.sqm differences, some files/functions 
    simply have a event copy that is used instead. 
  
  Changes from 4.2.3 Event
  - Auto marking editor objects added (credit to FNF) w/ setting in eventSetting.
  - Admin can now alter safestart (cancel, change time, end) while it is in progress using the admin pole.
  - Notify final check now disabled.
  - New points system instead of numSectors for win conditions.

* Mission CBA Settings
  - Time added as an option for GUI settings
  - Safe start time added
  - Final Check Notification at beginning of round now a CBA setting 

* Total reorganization of functions
  - Practically every function now lives under a subfolder under the DOTT_Functions folder.
  - Code related to these subfolders living in init, initPlayerLocal, initPlayerServer, initServer, onPlayerKilled, onPlayerRespawn
    transferred to the init file in subfolder, which is called in the main.sqf.
  - 29th_Training folder is now gone.

- Round/safestart time display messages better support a wider range of times (display hour/minute/seconds) instead of just minute or second.
- Safestart now uses the countdown UI to display how much safestart time is remaining. Might potentially cause confusion with LIVE on very long safestart times.
- fn_manageready now has additional parameter to not display notification.
- Rewrite of Zeus related round code. No longer need to check every key press to check if entering/exiting Zeus.
- Rewrite of chat command code to use event handler instead of loops.
- Swap event handlers waiting for player to be nonnull with CBA equivalent to reduce unnecessary spawns.
- Replaced all CBA setting tags from DOTT to TN.
- Grenade throws now also cached for tracker system.
- Removed probably meaningless logic from autospectate.

---
v4.2.4  
10 DEC 2025

---
* Mission Settings Now Adjustable Mid-Mission (credit to CBA, modified their files)
  - Many mission parameters and the sector settings can now be adjusted mid-mission with !s or !settings by the admin.
    Settings changed in this GUI will NOT persist between missions, allowing worry-free adjustments of various parameters.
  - New defaults:
    - Radios on leaving arsenal now force the side radio regardless if a radio already is in the slot.
    - RHS Engine Warmup script is disabled by default to prevent teleport bug.
    - Vehicles with LR Radio now have their radio forcably set to the player's faction occupying the seat.
      Ex. A BLUFOR player occupying a OPFOR vehicle will have their vehicle radio use BLUFOR encryption.
  

* Commands
  - !cleanup now a restricted command
  - !showchat added, which can be used to forcibly show chat in cases where it disappears (ex. bug due to accessing menu).
  - !radio added, which can be used to determine if TFAR radio is bugged in cases where people on same frequency cannot hear each other.
  - Error now shows in chat if a command is not recognized.

- Removed voice_control script, overwritten by server setting anyways.
- Fix erronous roadkill in tracker, reduce cases of first shot uncon/kill not being counted.
- Made arsenal action higher priority to prevent the option being in the middle of teleport options.
- Fix for invulerability conditions changed to if player is visible instead of in spectator.
- Fix case where swapping kits in arsenal did not cause saved frequencies to be applied on next kit refresh.
- Removed spectator button from respawn menu.
- Fix for Enhanced Movement actions causing command teleports to fail. Also added multiple tries for teleport if it fails for any other unknown reason.
- Removed causes of errors when mission sqm contains vehicles (mainly useful for event version).
- Remove error log in setInsignia.

---
v4.2.3  
30 SEP 2025

---
- Leaving arsenal with a loadout with no primary will no longer put weapon away. (Partial revert change from 4.2.2)
  Modifies fn_arsenalClosed.sqf
* Force Parade Changes
  - !debrief now causes the Force Parade action at BLUFOR ammo box to be selectable from 50 meters away for 10 seconds.
    Modifies commands.sqf and baseObjectsInit.sqf
  - Now kicks players out of arsenal if force parade is done on them
    Modifies handleInitialInventory, forceParadeAll, forceParade is now loadParade.
- Replaced setUnitLoadout with CBA_fnc_setLoadout, getUnitLoadout with CBA_fnc_getLoadout for resetLoadout/fullSetUnitLoadout.
  Gets rid of an error related to setInsignia.
* When loadout reset or when respawning, if player did not save their radio settings by revisiting ACE Arsenal, 
  frequencies on newly given radio will be the same as right before reset/death.
  - Fixed likely cause of radios not working when swapping between faction different radios in arsenal. 
  - Fixed vehicle LR having wrong encryption code if player with wrong side backpack LR entered first.
  - Adds fn_initTransferRadioSettings.sqf.
* Added last line of defense checks for player invulnerability and silent weapon bug at beginning of round. 
  - If detected, a message will appear for all players and it will automatically (hopefully) fix the problem. 
  - This "shouldn't" be triggered at all if current checks or code are adequate/correct, so displaying a message might be useful to find and remove causes in the future. 
  - Commented out setting player invulnerable when they load in, seems more trouble than its worth
* Tracker Changes
  - Kills/unconscious 10 seconds after getting hit now show the last time the player was hit.
     Kind of a patch job, but don't really see the internals being expanded in the future so should be fine.
  - Fixed height from ground being used for tracker distance calculation instead of absolute (from sea level)
  - Now stores last hits from each player instead of just the last hit, and uses the killed event handler information if viable to determine killer.
    Hopefully fixes cases where tracker kills are credited incorrectly due to dying entity being alive on client but dead server side.
  - Consolidated hitExplosion and hitPart files into one hit file in tracker. Consolidated getWeaponVehicle back into getWeapon again.
  - Weapon string for tracker is now cached for future retrieval instead of repeatedly generating the same string (4x faster, but not much absolute cost anyways).
  - Better support for detecting roadkill uncon/kills.
  - Better support for fire/burning based deaths. (ACE/RHS AN-M14, Vehicle Fires)
  - Added support for vehicle explosions
  - Fix rare case in bad network conditions where unconscious event happens after kill event.
- Sector no longer shows up at the bottom left when starting mission. (Removed this logic causing this since the countdown/sector ui fix fixes this too)
- Fixed critical bug where having spectator box be above water (certain maps) caused the spectator function to break.
- Fixed bug that removed countdown/sector ui for players that exited zeus.
* Sector Objective Settings Now Adjustable
  - Admin can now change sector parameters by going into Menu -> Configure -> Addon Options -> 29th - Sector Settings.
    NOTE: Settings must be adjusted under the Server tab, not Client.
    NOTE: Changed settings will (probably) persist after mission reset, so remember to reset the values back to default if only changing for one drill.
  - Parameters include changing vehicle weights by type, capture speed, and counting crew inside vehicles.
  - By default these parameters are changed from vanilla:
    Vehicles now have a static weight by type, all counting as 1 infantry except for tracked vehicles (2), and air vehicles (0). 
    Crew inside are not added to the weight.
  - If settings don't allow player to capture in a certain vehicle, they will be warned if they are in that vehicle in a sector.
  - Note: This change means any sectors placed in Eden editor will not have their values used, and by extension, each sector cannot have unique values.
* Command changes
  - !debrief now also resets loadout.
  - !arsenal, !heal, and !rearm available for non-admin if currently not in a round.
  - Modifies flexibleReset, commands.sqf, executeCommand.sqf
  - Arsenal created by !arsenal now editable by Zeus.
- Players leaving box now have allowDamage = true set 1 second later to prevent damage from other players leaving box at similar time.

---
v4.2.2  
02 SEP 2025

---
* Reworked Tracker System
  - Should accurately get weapon names without hardcoding needed. (Except ACE Fragments still.)
  - Theoretical network load increase when units are hit, hope its not significant.
  - Kills from vehicle weapon now have the weapon used alongside the vehicle.
    Also will have the ammo used if certain conditions are met. Tries to always have it if multiple ammo options for weapon and at least 1 is explosive.
  - Kills from infantry weapons that use explosives now have the round used as well. (Except RHS disposables)
  - Manual player respawns without taking known damage will no longer be recorded. 
  - AI killing players will no longer be recorded.
  - Removes findInstigator, handleDamage, renames getInstigatorName to getName
  - Splits getWeapon into itself and getWeaponVehicle.
  - Adds addEventHandlersClient, hitExplosion and hitPart functions

* Fixes for things that broke between 4.2.0 and 4.2.1
  - Fix insignia not applying on join
  - Fix manual respawning not crediting last attacker with kill 

* EXPERIMENTAL: PIP Thermal Cameras should now be disabled (nothing renders). 
  Added exceptions to cameras that could have thermal that follow gunner sights but shouldn't since the gunner thermals are disabled.
  Keep an eye out false positives and negatives, although the only other alternative may be to remove that exception above (more false positives for less (zero?) false negatives).
  Notable Vehicles: US MRAPs w/ DVE Monitor (Driver), Humvee w/ LRAS, Stryker (Driver and LRAS), Speedboat

- Fix for when manually calling live during safe start countdown (when all teams are ready) caused Timer Aborted to appear on screen.
- Fix for when logging out of admin removed zeus even when in zeus slot. 
  Moves checkCuratorAssignment from scripts folder to 29th_Training.
- Fix for admin login not properly granting Zeus if mission started without an admin.
- Leaving arsenal/getting reset by admin to a loadout with no primary will now put weapon away. (Officers no longer have to put pistol away manually)
- Removed all remaining archive files.

---
v4.2.1  
26 AUG 2025

---
- Custom parade loadouts (mainly for officers) can be saved under ACE Arsenal as "Forced Parade". 
  Player will load into this when joining instead and when Force Parade is used. Adds fn_forceParadeAll.
- Weapon/vehicle used will now show up in Event Log. Names may be simplified and SOP GLs are explicitly shown as weapons.
  Adds fn_getWeapon and fn_weaponToNum. 
- Team scores should no longer show up on UI during round. (All sides have -9999 score added at beginning of round, reverted at end).
- Round histories are no longer lost when going back to lobby/disconnecting. Adds fn_sendAll.   
- Javelin can now lock on without thermal if thermals are disabled.
- Unconscious events close to death events will no longer be reported.
- Insignia now only overwritten for Clerk or Sniper if they don't have one
- Fixed incorrect xml check for Company and Battalion unit.
- Fix kill not being credited if the instigator died before the unit finally died (typically from bleeding out or respawning).
- Fix initial joiners sometimes not spawning in with parade kit. (Return of handleInitialInventory from archives)
- New method to find out last damage source. Should help credit explosive uncon/kills better.
- Fixed bug where !rearm would apply admin loadout to all players.
- Fix for countdown timer not showing up until a sector has been placed down.
- Fix weapon being pulled out after leaving arsenal after delay.
- To prevent things breaking, player now invincible until fully loaded in when joining.

---
v4.2.0  
21 AUG 2025

---

* Parade loadout
	- Combined PARADE_WEST, PARADE_EAST, and PARADE_INDEPENDENT roles into a single PARADE role in cfgRoles and cfgInventories
  - Deprecated radios in loadout swapped.
  - fn_handleInitalInventory.sqf fixed, but also no longer called due to redundancy. First time players should now join with parade
    and not naked.

* Improved loadout and arsenal handling
  - Replaced calls to BIS_fnc_loadInventory to prevent one source of inaudible weapon bug
	  with "functions\Dott_Functions\fn_fullSetUnitLoadout.sqf", which uses setUnitLoadout to prevent the issue
    where the server thinks your weapon is "Throw" or "Put". 
	- fn_flexibleReset now use fullSetUnitLoadout, modified fn_flexibleReset params to accomodate.
  - fn_resetWeaponState spawn added to fullSetUnitLoadout and arsenalClosed to ensure server currentWeapon is synced correctly.
  - Arsenal action is now area based inside base instead of looking at ammo box.

* Legacy cleanup
	- fn_addRadio deprecated radios swapped.
  - fn_assignCurator, checkCuratorAssignment rewritten, checkCuratorAssignment call moved to initPlayerLocal from initServer (might revisit this later)
    Now properly lets JIP Zeus slots access it without respawn.
    Known issue NOT related to this change: If mission is started without an admin, #adminLogged zeus module does not properly give zeus to admin when they log in after.
  - fn_cleaner now properly cleans up items in base, added description, returns boolean
  - fn_noThermals cleaned up with descriptions, defines, param change
  - fn_removeRadio now has description, moved _removeRadiosFromDead check to onPlayerKilled
  - fn_setInsignia rewritten with hashmap instead of switch case, different standard for non-combat kits. Cleaned up call to it from onPlayerRespawn.
  - Deleted attempt to prevent respawn showing on old body in onPlayerRespawn.sqf
    Probably mostly working attempt created in initPlayerLocal.sqf
  - fn_spectator separated into fn_enter_spectator and fn_exit_spectator. Player no longer sits down but will lower weapon upon exiting spectator (prevent accidental discharge).
    Players will also be forced out when manually teleported.
  - scripts/baseObjectsInit.sqf call moved from init.sqf to initPlayerLocal.sqf
  - Parade loadout setup moved from init.sqf to initServer.sqf
  - Unused functions randomizeRadioHz and removeAllRespawnInventories moved to archives folder and calls (TFAR_eventHandlers and init_curators respectively) commented out.
    Now unused file scripts/TFAR_eventHandlers.sqf deleted.
  - dateAndWeather function greatly simplified, moved completely server side. Call moved from init.sqf to initServer.sqf. 
    Numeric values moved from script to initServer, now passed as params.
  - excludeObjFromZeus now uses a flag to check for removal instead of comparing against all listed editor placed objects.
    initPlayerServer will now not add player to curator editable objects if they are a headless client.
  - Disabled most Headless Client "functionality" due to nonfunctional behavior.
    init_hc deleted.
    Headless Client-related code in init_curators has been commented out.
  - Deleted spectator.sqf from script folder, left over file after it was "moved" to fn_spectator.sqf in 29th_Training.
  - Removed functions\curator folder and files inside, removed include in description.ext
    Functions meant to make sure all placed zeus units are shared between all curators no longer called. ACE Zeus setting on server takes over this functionality.
  - init_curators.sqf 
    Call moved from init.sqf to initPlayerLocal.sqf
    Vehicle modifiers moved to new file init_vehicle_settings.sqf. 
    Deleted other unused event handlers.
  - init_vehicle_settings.sqf created
    Uses EntityCreated missionEventHandler instead of curatorObjectPlaced. 
    One consequence of this is that player created UAVs and static weapon will now also have disableTIEquipment called on it. 
    Vehicle modifiers also now called on vehicles in mission.sqm, if for some reason they exist.
    Now also will delete initial vehicle inventories (besides rope) if new mission param removeDefaultVehicleInventories == 1 (which is default).
  - description.ext
    showMap now equals 1
    respawnDelay = 5 from 15;

* Tweaked "fn_flexibleReset.sqf"
  - Teleport now waits up to 30 seconds for a dead player to respawn before attempting teleport to reduce need for manual teleporting in these situations.
  - Teleport now kicks player out of spectator box.
  - Heal now also resets ACE Hearing deafness.

* "fn_forceParade.sqf"
  - Script added as option for admin via !parade command or as an additional option at BLUFOR ACE Arsenal Box. Sets loadouts of players currently in combat loadout
    near admin or Arsenal box to parade loadout.
  - Adds checkNonCombatLoadout.sqf, modifies commands.sqf and baseObjectsInit.sqf

* "fn_initDefaultLoadouts.sqf"
  - SOP correct Rifleman kits for each faction and Parade are now in Default Loadouts in ACE Arsenal.

* Fixed mission parameters
  - artilleryComputer now properly disables artillery computers. Server side ACE option to block it must be disabled for this param to take full effect. 
  - disabledTI now properly spawns Hill_fnc_noThermals via EH. Infantry NVGs and launchers can no longer use thermals (important for Javelin).

* Round system
  - Moved as much logic as possible from commands.sqf to functions/Dott_Functions/round
  - Move was done to simplify possible future GUIing of round system
  - Replaced timerCheck with roundEvents, which is spawned on demand as needed and also handles time warning notifications.
  - Checking scoreboard is now disabled during round (unless in spectator or zeus). 
  - Moved publicVariable variables to fn_init

* Tracker system (Round Event Logging)
  - Tracks deaths (and if possible the killer), unconciousness (if possible who caused it) and sector capture (by team) changes during a round.
  - Also includes personal events tab that only tracks player related events.
  - Round scoreboard system that tracks (only) player kills and also credits unconscious as kills when possible.
  - Automatically sends the events to players into their map diary at round end. Will not persist across rejoins and player will only have records for rounds they
    were present at the end of.
  - Tracker init.sqf also removes Statistics in Map permanently, could not get it to be shown only between rounds.    
  - Can be disabled if problems arise in params.
  - Focus has been put on ACE 3 Medical Compatibility, minimizing network load when sending to players, and properly handling players switching side mid round.
  - When fighting AI, will not record AI infantry unconscious/deaths due to performance/technical considerations.
  - Possibly move out of diary in the future to have more features.
  - All files created in functions/Dott_Functions/tracker, and system initiated by calling tracker init file in init.sqf.

* Commands & Logging
  - Commands executed by players (except !commands and !help) as defined in pvpfw_chatIntercept_noLogCommands in commands.sqf are now logged server side.
  - Also logged client side under Log in Map Diary.
  - Modified commands.sqf, init.sqf, and executeCommand.sqf in module_chatIntercept folder.
  - Added fn_diag_log.sqf in Dott_Functions, which is also used to log who entered zeus.
  - Moved chatIntercept init call from init.sqf to initPlayerLocal.sqf
  - Moved admin check to executeCommand.sqf, which checks if a command is admin restricted from pvpfw_chatIntercept_adminCommands in commands.sqf

---
v4.1.1
14 OCT 2024

---

* Tweaked "onPlayerRespawn.sqf"
	- Commented out code that resulted in players respawning on their own body instead of on respawn points. Code seems to have been broken by Arma 3 V2.18, but was mostly irrelevant anyways
* Tweaked "scripts\voice_control\voiceControl.sqf"
	- Commented out line 129. Seems to have been broken by Arma 3 V2.18

---
v4.1.0
2 MAY 2024

---

* Added chat commands
	- Alters file "module_chatIntercept\commands.sqf"
	-'!heal': (ADMIN ONLY) ACE Heals players. '!heal' for all players, otherwise '!heal SIDE' (blufor, opfor, grnfor)
	-'!rearm': (ADMIN ONLY) Rearms players. '!rearm' for all players, otherwise '!rearm SIDE' (blufor, opfor, grnfor)
	-'!reset': (ADMIN ONLY) Rearms, heals, and (optionally) teleports players to spawn. !reset' will rearm, heal, and teleport players to spawn. '!reset stay' will rearm and heal them. May also specify side (blufor, opfor, grnfor)
	- !debrief: (ADMIN ONLY) ACE Heals and teleports players for debrief. '!debrief' to teleport all players to Blufor base, '!debrief here' to teleport all players to your position
	- !goto: (ADMIN ONLY) Teleports admin to side spawns. '!goto SIDE' (blufor, opfor, grnfor)
	- !arsenal: (ADMIN ONLY) Places an ACE arsenal in front of the admin
* Tweaked "data\cfgNotifications.hpp"
	- Included new class "Reset"
	- Included new class "Document"
	- Included new class "Health"
* Added new Dott Functions
	- "functions\Dott_Functions\fn_flexibleReset.sqf" (V1.0)
		- Handles any combination of rearming, teleporting, and ACE healing players (and notifications for these things)
* Added ACE Fortify Module
	- You're welcome, 1Lt. Nelson
	- Interact using ACE chat commands: https://ace3.acemod.org/wiki/framework/fortify-framework
* Changed BLUFOR units
	- Added second Platoon Sergeant roll to CP1 (Curator enabled)
	- Alters file "scripts\excludeObjFromZeus.sqf"
	- Alters file "scripts\checkCuratorAssignment.sqf"

---
v4.0.1
3 MAR 2024

---

* Tweaked DOTT_fnc_ticketCount (V1.1)
	- Fixed some incorrect variable names
	- Now informs admin when a team runs out of tickets via hint
* Tweaked "module_chatIntercept\commands.sqf"
	- '!game' will now show game message to all clients regardless of if there is an active timer

---
v4.0.0
13 FEB 2024

---

* Mission under new care
	- Dott [29th ID]
	- Comments and changelog from now on shall be a little more verbose
* Removed stats system
	- Buggy and broken... Time to go. If possible, will be reintroduced at a future date
	- Removed "scripts\init_stats.sqf"
	- Removed "functions\fn_checkStats.sqf"
	- Alters file "initPlayerLocal.sqf" to remove call for "scripts\init_stats.sqf"
* Changed BLUFOR units
	- Reused BLUFOR Charlie 2-3 squad to form guest slots (Bottom of BLUFOR slots)
	- Reduced squad sizes to 16 (too much scrolling down on slotting screen)
* Changed OPFOR/GRNFOR units
	- Made slots for squad and platoon leadership clearer
	- Altered some unit variable names to include tags such as 'plt' and 'sl'
		- Replaced corresponding variable names in scripts
* Changed slot descriptions for most units
	- Squad layouts and slot descriptions are now consistent
	- Changed HQ element labels to better fit the current 29th structure
	- Added Automatic Rifleman slot to squads
	- Combat Engineer and Engineer slots clarified
		- Combat engineer has ACE skills 'Adv. Engineer' and 'EOD'
		- Engineer has ACE skills 'Engineer'
* Added chat command system
	- Accessed via chat window. Commands start with '!' E.G. '!help'
	- Alters file "init.sqf" to include '[] execVM "module_chatIntercept\init.sqf"';
	- Added folder "module_chatIntercept"
	- Added file "module_chatIntercept\commands.sqf"
	- Added file "module_chatIntercept\config.sqf"
	- Added file "module_chatIntercept\executeCommand.sqf"
	- Added file "module_chatIntercept\init.sqf"
	- Features:
		- Timer system
			- Note: Timer UI doesn't spawn unless a control sector has been placed. It will work afterwards, even if control sector is deleted. Timer still runs regardless
		- Overtime system
		- Ready/unready system
		- Ticket system (Does not use BIS_fnc_respawnTickets)
			- Alters file "onPlayerRespawn.sqf" to include Dott ticket management
		- Map measuring tool for admin
		- Cleanup system (using Hill_fnc_cleaner)
	- Added file "scripts\readyCheck.sqf"
		- Checks ready status defined by chat commands in "module_chatIntercept\commands.sqf"
	- Added file "scripts\timerCheck.sqf"
        	- Checks for when timers should end, starts overtime, and calls game as necessary
* Added new Dott functions
	- Added folder "functions\Dott_Functions"
		- Added file "functions\Dott_Functions\fn_displayMSG.sqf" (V1.0)
		- Added file "functions\Dott_Functions\fn_ticketAdd.sqf" (V1.0)
		- Added file "functions\Dott_Functions\fn_ticketCount.sqf" (V1.0)
* Fixed possible syntax error in "onPlayerRespawn.sqf"
	- See comment in file RE: '!(isNull _oldUnit)'
* Tweaked HILL_fnc_cleaner
	- Commented out unnecessary variables _caller, _target, and _id
	- This was causing errors. Will reevaluate later
   
---
v3.8.1
16 SEP 2018

---

* Tweaked `onPlayerRespawn.sqf`
  - (hopefully) prevent briefly seeing the respawned player at the player's death location.

---
v3.8
10 SEP 2018

---

* Changed stats system
  - Save variables to `profileNamespace` instead of the player object in `scripts\init_stats.sqf`
    - **This will allow player stats to persist between team switching and game sessions.**
  - Moved `scripts\Stats\init_stats.sqf` from `\Stats` folder to `\scripts` folder
  - Changed `scripts\Stats\checkStats.sqf` to a registered function `Hill_fnc_checkStats`
    - Adds file `functions\29th_Training\fn_checkStats.sqf`
    - Alters file `functions\29th_Training\CfgFunctions.cfg`
    - Alters file `scripts\init_stats.sqf` to call the new function `Hill_fnc_checkStats` instead of the removed script file
    - Removed obsolete folder `\scripts\Stats`
  - Added an `addAction` option to reset statistics in `scripts\init_stats.sqf`
* Tweaked `onPlayerRespawn.sqf`
  - (hopefully) prevent briefly seeing the respawned player at the player's death location.
* Changed how the check for curator assignment is handled
  - Operation is now completely server side
  - Fixes an error that caused the function to fail
  - Re-wrote `functions\29th_Training\fn_assignCurator.sqf`
  - Moved script call `execVM "scripts\checkCuratorAssignment.sqf";` from `initPlayerServer.sqf` to `initServer.sqf`
* Removed obsolete function `Hill_fnc_transferVAtoAA`
  - Removes file `functions\29th_Training\fn_transferVAtoAA.sqf`
  - Alters file `functions\29th_Training\CfgFunctions.hpp`
  - Alters file `scripts\baseObjectInit.sqf`
* Added removal of radios from dead players
  - Adds mission parameter to toggle on or off at mission start
    - **Default setting is ON to remove radios from dead players**
  - Adds file `functions\29th_Training\fn_removeRadios.sqf`
  - Alters file `functions\29th_Training\CfgFunctions.hpp`
  - Alters file `data\params.hpp`
* Added an event handler to display a message in the server .rpt file when a player opens the curator interface
  - Alters file `scripts\init_curators.sqf`


---
v3.8
8 SEP 2018

---

* Fixed some group names not entered for some groups for some scenarios
* Fixed wrong version displayed in loading screen of some scenarios
* Changed `data\cfginventories.hpp` to use new 29th OCP items for BLUFOR parade loadout
* Removed reference to `scripts\recognise.sqf` from `initPlayerLocal.sqf`
  - Script didn't exist in folder and this is done server side now anyway
* Removed `functions\29th_Training\fn_activateAddons.sqf`
  - This failed attempt at wizardry is FUBAR so I'm throwing it out to forget about it
* Removed `functions\29th_Training\fn_playerAdmin.sqf`
  - This wizardry is obsolete
* Added curator assignment check to (hopefully) fix having to respawn for curator access
  - `scripts\checkCuratorAssignment.sqf` called from `initPlayerLocal.sqf`
  - `functions\29th_Training\fn_assignCurator.sqf` called by `scripts\checkCuratorAssignment.sqf`
* Added `hideObjectGlobal true` and `hideObjectGlobal false` to newly respawned unit in `onPlayerRespawn.sqf`
  - (hopefully) prevent briefly seeing the respawned player at the player's death location.
* Changed distance base arsenal is available as an action in `scripts\baseObjectsInit.sqf`
  - Increased distance from 50 metres to 75 metres
* Changed addAction for spectator terminals, arsenal ammo boxes, and garbage cans in `scripts\baseObjectsInit.sqf`
  - Removed the condition parameter check for caller's distance to object and replaced with radius parameter
* Removed obsolete argument variable from function `functions\29th_Training\fn_cleaner.sqf`
* Changed the way negative player ratings were handled
  - Added `handleRating` event handler in `playerInitLocal.sqf`
  - Removed `functions\29th_Training\fn_adjustRating.sqf`
* Changed `scripts\player_arsenal_handlers.sqf` from using in-line functions to registered functions
  - Added `functions\29th_Traning\fn_addRadio.sqf`
  - Added `functions\29th_Training\fn_arsenalClosed.sqf`
* Added `Require CBA` module because CBA is required...
* Added player stats tracking at spectate box.
  - shots fired
  - targets hit (men only; AI and Human)
  - Accuracy
  - deaths
  - `scripts\checkStats.sqf`
  - `scripts\stats.sqf`

---
v3.7
29 AUG 2018

---

* Changed BLUFOR Parade starting loadout in `data\cfgInventories.hpp`
  - Removed M4A1 (`rhs_weap_m4a1`) and associated M855A1 magazines (`rhs_mag_30Rnd_556x45_M855A1_Stanag`)
  - Added M1 Garand (`rhs_weap_m1garand_sa43`) with 4, 8 round magazines (`rhsgref_8Rnd_762x63_Tracer_M1T_M1rifle`)
* Changed addActions for base ammo boxes in `scripts\baseObjectsInit.sqf`
  - Removed action menu items for `Transfer VA to AA` and `Virtual Arsenal` if Ace is running

---
v3.6
19 JAN 2018

---

* No version name change
* Removed a `diag_log` call from `initPlayerLocal.sqf`
* Added option to enable or disable the artillery computer for _all_ artillery vehicles
  - Available in the lobby via `Parameters -> Artillery Computer
  - Default selection is `Off`
* Removed some old commented code from various places.
* Changed `scripts\excludeObjectsFromZeus.sqf`
  - Added missing opfor and grnfor curator game master modules
  - Changed loop time from 5 sec. to 3 sec.

---
v3.6
14 JAN 2018

---

* No version name change
* Fixed typo in `Hill_fnc_setInsignia` which incorrectly applied insiginas to two squads in CP2
* Removed check for team kills which will display a message in sideChat
  - Removes function `Hill_fnc_teamKill` and an MPKilled event handler from `initPlayerLocal.sqf`
* Added many parameters to the `description.ext`
  - Adding the parameters to the `description.ext` makes the settings less likely to be set incorrectly or changed by accident in the editor.

---
v3.6
12 JAN 2018

---

* No version name change
* Removed initial attempts at attendance system
* Added check for team kills which will display a message in sideChat
  - Adds function `Hill_fnc_teamKill` called by an MPKilled event handler applied from `initPlayerLocal.sqf`
* Added player rating adjustment to prevent players from not being able to get into vics occupied by a team killer
  - Adds function `Hill_fnc_adjustRating` called from the `initPlayerLocal.sqf` if a player's rating < or = -1000
  - Returns player's rating to default starting value of 350
* Refactor some scripts.
* Moved custom functions config from `description.ext` to `functions\29th_Training\29th_Training.hpp`
  - Configuration by `#include "functions\29th_Training\CfgFunctions.hpp"` in the `description.ext`

---
v3.6
11 JAN 2018

---

* No version name change
* Removed the furniture spawn script
* Removed `change_log.html`
* Adjusted `Hill_fnc_setInsignia` to make sure the drab and vibrant insignias were applied at the proper time
  - no primary weapon or has M4A1 PIP with no attachments = vibrant else drab
* Removed two unused scripts
* Adjusted `arsenalClosed` event handler in `scripts\player_arsenal_handlers.sqf`
  - When ace arsenal is closed if player has no radio add faction specific radio
* Completely reworked thermal imaging restriction
  - Added `["visionMode", {}] call CBA_fnc_addPlayerEventHandler` in `initPlayerLocal,sqf`
  - Added new function `Hill_fnc_noThermals`
  - Added public variable `disabledTI` to `initServer.sqf`
  - Added a `curatorObjectPlaced` event handler to `init_curators.sqf`
     - uses `disableTIEquipment` on all objects of type "Car", "Air", "Ship", "Tank", and "StaticWeapon"

---
v3.6
9 JAN 2018

---

* Added `diag_log` to furniture script to write to report file the name of the player selected
* Added new function `Hill_fnc_transferVAtoAA`
  - transfers player's saved Virtual Arsenal loadouts to the new Ace Arsenal
* Changed how base ammo boxes access the arsenal in light of the new(ish) Ace Arsenal
  - changes in `scripts\baseObjectsInit.sqf`
  - changed base ammo box arsenal addAction call back to `{["Open", true] spawn BIS_fnc_arsenal;}`
  - added `Ace Arsenal` addAction `{[_this select 1, _this select 1, true] call ace_arsenal_fnc_openBox;}` to open the Ace Arsenal
  - added `Transfer VA to AA` addAction `{[] spawn Hill_fnc_transferVAtoAA;}` to transfer existing Virtual Arsenal loadouts into the Ace Arsenal
* Added new file `scripts\player_arsenal_handlers.sqf` to house all event handlers related to opening and closing arsenals
  - Moved said event handlers from `initPlayerLocal.sqf`
* Added call of `Hill_fnc_setInsignia` to `onPlayerRespawn.sqf`
  - Hopefully this will fix players not having insignia set when joining

---
v3.5
7 JAN 2018

---
* Added an HTML version of the change log called `change_log.html`
* Added attendance counting to the `Log` entry accessed via the map screen
* Added simulation manager function module as this is handled natively and adjusted via Attributes -> Performance in the editor
* Added TFAR radios to each faction's "parade" loadout
* Added new function `Hill_fnc_setInsignia`
  - uses `squadParams` to automatically assign proper squad insignia on mission start and at the arsenal.
* Added call for `Hill_fnc_setIngignia` in `arsenalClosed` and `arsenalOpened` event handlers in `initPlayerLocal.sqf`
  - squad insignia now properly applied to the player when opening and closing the arsenal
* Added squad and platoon names and callsigns to lobby
* Added automatic furniture spawn
  - **NEEDS TESTING**
  - On by default but can be turned off in the parameters menu via the lobby *before the mission is started*
  - picks a random player to spawn furniture in houses in a 50 metre radius.
  - deletes furniture if selected player is > 25 metres from last checked position and no players are within 7 metres of the house.
* Adjusted BLUFOR "Parade" loadout in cfgInventories to match recent loadout changes.
* Adjusted `init_curators.sqf`
  - `curatorObjectPlaced` event handler which calls `ace_fastroping_fnc_equipFRIES` function on placed helis is now applied to curators **only** if ACE is running
* Changed the `No Thermal Optics` parameter to be on by default.
* Changed base ammo box arsenal call
  - removes options to change voice, insignia, and face.
  - significantly reduces the distance the `Arsenal` action is available.
* Changed respawn time to 15 seconds
* Changed the name on the change log file from `change_log.txt` to `change_log.md` and reformatted for markdown (fuck, that took a long time!)
* Changed curator vision mode in `init_curators.sqf` from "Shade of Red and Green, Bodies are white" to "White Hot Black Cold"

---
v3.0
20 NOV 2016

---
* No version name change
* Added TFAR force usage (settings) Module.
  - Sets TFAR channel to "Training Radio Network" with a password of "123".

---
v3.0
16 OCT 2016

---
* No version name change
* Removed action option from Admin to turn Auto Spectate on or off
  - Option still available via mission parameters prior to mission start
  - Default is disabled

---
v3.0
15 OCT 2016

---
* Added script command `enableChanel [true(chat),false(VoN)];` to `initPlayerLocal.sqf to diable VoN in all of the available channels
* Added parameter `disableChannels[]` to `description.ext` to force disable VoN in all channels
* Removed voiceControl script to limit talking over specific channels.
* Added "Spectator" option from `respawnTemplates[] = {};` in description.ext because it now works
  - it is a limited version of the spectate and does not function the same as the custom one available at the spectator terminals.
* Added function `Hill_fnc_applInsig` which automatically applies the appropriate squad insignia to the player based on the group they joined (BLUFOR only)
* Added forcing players to lower weapons on first join and after exiting the virtual arsenal
* Removed TFAR frequency modules to set default SR radio freq. as per Comms. card because it wasn't reliable.

---
v3.0
6 SEP 2016

---
* Added back automatic spectate option.
  - Disabled by default.
  - Added graphics to ON and OFF actions
  - Added systemChat message to confirm action
* Removed player stats system for a very, very slight performance gain. (I don't think anyone used this anyhow)
* Removed "Spectator" option from `respawnTemplates[] = {};` in `description.ext` because it doesn't work (arrg BI)
  - This is to access the BIS Spectaor (Activate the button) from the respawn menu.
  - Removed because it is a limited version of the spectate and does not function as we like.  
	- Players can still access the spectator from the terminal boxes or if the ADMIN turns on the auto-spectate.
* Added "Parade" loadout inventory
  - For all sides
  - Uses `BIS_fnc_setRespawnInventory` in `initPlayerLocal.sqf`
  - Set as default gear when first joining.
  - Available on respawn menu
* Added functionality for saved loadout (after leaving arsenal) to be added to respawn inventory and available from the respawn menu.
* Added Headless Client functionality.
  - Not tested yet.
* Changed spectator script to registered function in functions library.
  - `functions\fn_spectator.sqf`
  - Used via `<object> spawn Hill_fnc_spectator`
* Removed in-line function for admin checking from `initPlayerLocal.sqf` in favour of a registered function.
  - `functions\fn_playerAdmin.sqf`
  - `<object> call Hill_fnc_playerAdmin`
* Adjusted addAction calls set to spectator terminals.
  - Added graphic to action menu
* Moved init call for opening arsenal from individual ammo boxes (6 total) in editor to `init.sqf`
  - Added graphic to action menu
* Removed call BIS_fnc_drawCuratorLocations from `init_curators.sqf`
  - non functioning (script error)
  - RPT spam (a shit tonne; no, seriously I mean a lot of rpt spam)
* Fixed Civilian Journalist slots having Camera action only after respawn.
* Added simulation manager function module
  - removes simulation and hides objects more that are > 5000 m from playable units
  - does not include air units
* Changed cleaner script to a registered function.
  - `functions\fn_cleaner.sqf`
  - `call Hill_fnc_cleaner`

---
v2.30
28 JUN 2016

---
* Removed automatic spectate start on player respawn.
* Added "Spectator" option to `respawnTemplates[] = {}` in `description.ext.`
* Added mission parameter option to allow/disallow TI optics.  Default is on.
  - Adds `scripts\noThermals.sqf`
* Adjusted playable units
  - Fixed role description errors.
  - Organized variable names.
  - Added Grenadier to each squad.
  - Removed setGroupID command from all units' init.  Set via edited attributes via 3D editor instead.
  - Added callsign information to group names.
  - Added playable slots for BN Leadership.
* Added TFAR frequency modules to set default SR radio freq. as per Comms. card.

---
v2.28
21 APR 2016

---
* No version name change
* Removed faction restriction from spectator. Players can now spectate all sides.
* Added 'enableEnvironment false;' command to init.sqf to disable bees, butterflies, birds, rabbits, snakes and environmental sounds, crickets etc.

---
v2.28
10 APR 2016

---
* Added `scripts\excludeObjFromZeus.sqf`
  - automatic repetitive exclusion of base objects (ammo boxes, spectate table) from being added by zeus.
  - Checks every 5 seconds for all editable objects and removes the excluded if found to be editable.
* Changed initial respawn positions from markers (respawn_<side>) to respawn modules
* Increased squad size to 20 (including leadership).
* Increased size of GRNFOR and OPFOR sides to 33 slots each.
* Added third squad to each platoon.
* Added squad name to roll description in lobby (BLUFOR only).
* Added player weapon stats tracking at spectate box.
  - shots fired
  - targets hit (men only; AI and Human)
  - Accuracy
  - deaths
  - `scripts\checkStats.sqf`
  - `scripts\stats.sqf`
* Added attendance system (WIP - not finished).
  - scripts\attendance.sqf
  - init.sqf
* Added ACE 3 Fast Roaping (FRIES) system to all zeus placed helos.
* Added automatic spectate start on player respawn.
  - Can be set off or on in the mission parameters in the lobby before starting the mission.
  - Admin can turn auto spectate on and off during the mission via the action menu.
* Added init.sqf

---
v2.25
23 FEB 2016

---
* Converted mission from 2D editor to 3D editor (Eden)
* Removed scripted (BIS) module supports to Co. and Plt. units.  Virtual Supply drop and Virtual Air transport.
* Removed variable for possible future compatibility with TAW view distance
  - View distance is adjustable by via ACE 3

---
v2.20
21 JAN 2016

---
* Removed addAction from arsenal boxes for gear saving.
* Removed RP_loadout.sqf (gear saving)
* Removed generic (default) `respawnTemplates[] = {}` as it is not needed when specific factions are specified.
* Removed teleport.sqf - not needed
* Removed init.sqf as all initialization has been appropriately distributed to localized event scripts.
* Added `initPlayerLocal.sqf` with scripting
  - to save gear upon closing the arsenal GUI.
  - for curator functions (propagating placed objects between curators)
* Added `onPlayerRespawn.sqf` with scripting to
  - load gear after respawn
  - Automatically start the spectator upon respawn
  - re-add curator placed objects back to the respawned unit.
* Added `initPlayerServer.sqf` with scripting
  - for curator functions (propagating placed objects between curators)
* Added `initServer.sqf` with scripting to
  - add thermal vision to all curators (Zeus). White hot and dark red cool.  Not sure if I like it :(
* Added functions to make all curator placed objects editable by all curators.
  - See `cfgFunctions` in `description.ext` and functions\curator\
* Added scripted (BIS) module supports to Co. and Plt. units.  Virtual Supply drop and Virtual Air transport.
  - Access through the radio key '0' (zero) then select supports and follow the menu.
* Added voiceControl script to limit talking over specific channels.
  - Access to channels increase with importance...
* Added variable for possible future compatibility with TAW view distance
* Changed respawnDelay in description.ext from 3s to 10s
* Changed 3d task and task management to new method. See `CfgTaskEnhancements` in `description.ext`
* Fixed error in `RespawnTemplatesWest[] = {};`

---
v2.15
23 DEC 2015

---
* Removed MCC Dependency

---
v2.10
23 DEC 2015

---
* No version name change
* Adjusted Spectating script to force camera back to player on exit
* Changed `respawnOnStart` parameter in `description.ext` from 1 to 0 to prevent hang on loading screen when changing sides or joining after start
  - Problem caused by BIS after recent game update
* Added separate respawnTemplates for each faction 

---
v2.10
8 DEC 2015

---
* No version name change
* Removed legacy setSquadInsigniaNEW.sqf call from `init.sqf`
* Added spectating script.  `scripts\spectator.sqf`
  - Uses `BIS_fnc_EGspectator`
* Removed ACE Spectator settings module and "ace_spectator" template from `respawnTemplates[]= {}` in the `description.ext`
* Changed respawnDelay in `description.ext` from 10s to 3s

---
v2.10
28 NOV 2015

---
* Removed squad insignia system as it has be replaced with 29thID Mod (Yay!)
* Removed 29th Actions (Salute, Attention, etc.) replaced with 29thID Mod
* Removed `setTerrainGrid 50;` from `initPlayerLocal.sqf`
* Added ACE Spectator settings module and `ace_spectator` template to `respawnTemplates[]= {}` in the `description.ext`
* Changed `respawnDelay` in `description.ext` from 4s to 10s

---
v2.00
12 AUG 2015

---
* No version name change
* Removed Arsenal preload.
* Adjusted MCC Settings modules to turn off UI interface and cover/mounted actions.

---
v2.00
23 JUN 2015

---
* Added squad insignia system
  - Uses profileNamespace to save a variable to your profile to be called when a squad insignia is needed.
* Updated initPlayerLocal.sqf to call new setUnitInsignia.sqf
* Adjusted BIS_setUnitInsignia call from BIS_saveLoadInventory.sqf to call proper insignia based
on what is set in profileNamespace from setUnitInsignia.sqf (because the Arsenal removes the custom insignia)
* Added `EndMission,Spectator,Tickets` to `respawnTemplates[] = {}` in the `description.ext`
* Removed dependency on AGM including modules.  Dependency to TFAR and MCC remain.
* Removed `RP_VArsenalDrop.sqf` from 29thActions.
* Added preload arsenal function call to initServer.sqf
* Added `setTerrainGrid 50;` to `initPlayerLocal.sqf` to force grass level to "low".
* Added Time and Weather parameters to mission lobby.
* Added functionality for 2D task waypoints and 3D task markers in the description.ext

---
v1.03

---
* Added `MenuInventory` to `respawnTemplates[] = {}` in the `description.ext`
* Tweaks to TFAR module

---
v1.02
9 NOV 2014

---
* Added two mission observer slots which can use the BIS Splendid Camera.
* Removed BIS modules for setting custom group designation.
* Removed MCC set-up from the mission `init.sqf`.
* Removed removeAllActions script as it was incorporated into `29thActions.sqf`.
  - Also removed script call from `init.sqf`.
* Added MCC modules for mission settings and access rights (all).
* Adjusted the 29thActions scripts to remove the gen_action.sqf format.
* Changed the name of all 29thAction scripts to remove "gen_action_" from name.
* NOTE: RP_VArsenalDrop.sqf is still not removing the addAction from all players of the callers' side... WIP...

---
v1.01
21 OCT 2014

---
* Adjusted the gen_action_RP_VArsenalDrop.sqf to remove the "supply drop" action from all players
  - (per side of the caller) once the drop has been called and add the action back after the crate is recovered or destroyed.
* Adjusted the BIS_SaveLoadInventory.sqf to add the custom 29th ID unitInsignia on gear respawn.
* Adjusted and cleaned up the 29th Actions scripts.
* Added a killed event handler to 29thActions.sqf to remove actions (salute, push-ups, surrender, leave captivity, and supply drop)
from player's body upon death.

---
v1.00
17 OCT 2014

---
* Inception

---
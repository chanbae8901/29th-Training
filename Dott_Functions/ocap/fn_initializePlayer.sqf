//if recording, let natural loop do below instead
if (((missionNamespace getVariable ["ocap_recorder_recording", false]) && missionNamespace getVariable ["ocap_recorder_startTime", -1] > -1)) exitWith {};

params ["_player"]
if !(_player getVariable ["ocap_isInitialized", false]) then {
    _player setVariable ["ocap_id", ocap_nextId];
    [":NEW:UNIT:", [
        GVAR(captureFrameNo), //1
        GVAR(nextId), //2
        name _player, //3
        groupID (group _player), //4
        str side group _player, //5
        BOOL(isPlayer _player), //6
        roleDescription _player // 7
    ]] call ocap_extension_fnc_sendData;
    [_player] spawn ocap_recorder_addUnitEventHandlers;
    ocap_nextId = ocap_nextId + 1;
    _player setVariable ["ocap_isInitialized", true, true];
};
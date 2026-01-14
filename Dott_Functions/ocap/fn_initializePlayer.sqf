#define BOOL(_cond) ([0,1] select (_cond))

//if recording, let natural loop do below instead
if (((missionNamespace getVariable ["ocap_recorder_recording", false]) && missionNamespace getVariable ["ocap_recorder_startTime", -1] > -1)) exitWith {};

params ["_player"];

if !(_player getVariable ["ocap_isInitialized", false]) then {
    _player setVariable ["ocap_id", ocap_recorder_nextId];
    [":NEW:UNIT:", [
        ocap_recorder_captureFrameNo, //1
        ocap_recorder_nextId, //2
        name _player, //3
        groupID (group _player), //4
        str side group _player, //5
        BOOL(isPlayer _player), //6
        roleDescription _player // 7
    ]] call ocap_extension_fnc_sendData;
    [_player] spawn ocap_recorder_addUnitEventHandlers;
    ocap_recorder_nextId = ocap_recorder_nextId + 1;
    _player setVariable ["ocap_isInitialized", true, true];
};
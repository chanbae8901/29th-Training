#include "script_component.hpp"

if !(isServer) exitWith { _this remoteExecCall [QFUNC(notifyAdmin), 2] };

params ["_msg"];

if (GVAR(adminClient) IsEqualTo 2 && isDedicated) exitWith {};

_msg remoteExecCall ["systemChat", GVAR(adminClient)];
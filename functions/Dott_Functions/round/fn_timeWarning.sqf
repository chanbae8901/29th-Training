private _minutesLeft = round ((call DOTT_round_fnc_getTime) / 60);
["TimeWarning", [format ["%1 minutes remaining!", _minutesLeft]]] call BIS_fnc_showNotification;

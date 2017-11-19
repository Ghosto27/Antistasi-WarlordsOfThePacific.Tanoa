private ["_unit","_eny"];
_unit = _this select 0;
_eny = _this select 1;
if (time < _unit getVariable ["supressing",time - 1]) exitWith {};

_unit setVariable ["supressing",time + 60];

_unit doSuppressiveFire _eny;


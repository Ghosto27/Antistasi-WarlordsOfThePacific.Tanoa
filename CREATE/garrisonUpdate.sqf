private ["_tipo","_lado","_marcador","_modo","_garrison","_subTipo"];

_tipo = _this select 0;
if (_tipo isEqualType []) then
	{
	if ((_tipo select 0) isEqualType objNull) then
		{
		_subTipo = [];
		{
		_subTipo pushBack (typeOf _x);
		} forEach _tipo;
		_tipo = _subTipo;
		};
	};
_lado = _this select 1;
_marcador = _this select 2;
_modo = _this select 3;

waitUntil {sleep 0.2;!garrisonIsChanging};
garrisonIsChanging = true;
if ((_lado == malos) and (!(_marcador in mrkNATO))) exitWith {garrisonIsChanging = false};
if ((_lado == muyMalos) and (!(_marcador in mrkCSAT))) exitWith {garrisonIsChanging = false};
_garrison = garrison getVariable _marcador;
if (_modo == -1) then
	{
	for "_i" from 0 to (count _garrison -1) do
		{
		if (_tipo == (_garrison select _i)) exitWith {_garrison deleteAt _i};
		};
	}
else
	{
	if (_modo == 1) then {_garrison pushBack _tipo} else {_garrison append _tipo};
	};
garrison setVariable [_marcador,_garrison,true];
garrisonIsChanging = false;
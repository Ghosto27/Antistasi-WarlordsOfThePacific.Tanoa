private ["_posicion","_lado","_tipos","_grupo","_cuenta","_cuentaRangos","_lider","_override"];

_posicion = _this select 0;
_lado = _this select 1;
_tipos = _this select 2;
_override = if (count _this >3) then {_this select 3} else {false};
_grupo = createGroup _lado;

_cuenta = count _tipos;
_rangos = ["LIEUTENANT","SERGEANT","CORPORAL"];

if (_cuenta < 4) then
	{
	_rangos = _rangos - ["LIEUTENANT","SERGEANT"];
	}
else
	{
	if (_cuenta < 8) then {_rangos = _rangos - ["LIEUTENANT"]};
	};
_cuentaRangos = (count _rangos - 1);
for "_i" from 0 to (_cuenta - 1) do
	{
	if ((_i == 0) or (diag_fps > minimoFPS) or _override) then
		{
		_unit = _grupo createUnit [(_tipos select _i), _posicion, [], 0, "NONE"];
		if (_i <= _cuentaRangos) then
			{
			_unit setRank (_rangos select _i);
			if (_i == 0) then {_grupo selectLeader _unit};
			};
		sleep 0.5;
		};
	};
_grupo





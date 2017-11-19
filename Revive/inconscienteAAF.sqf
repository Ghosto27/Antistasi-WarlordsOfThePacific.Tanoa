private ["_unit","_grupo","_grupos","_isLeader","_dummyGroup","_bleedOut","_suicide","_saveVolume","_ayuda","_ayudado","_texto","_isPlayer","_camTarget","_saveVolumeVoice"];
_unit = _this select 0;
//if (_unit getVariable "inconsciente") exitWith {};
//if (damage _unit < 0.9) exitWith {};
//if (!local _unit) exitWith {};
//_unit setVariable ["inconsciente",true,true];
_bleedOut = if (surfaceIsWater (position _unit)) then {time + 60} else {time + 300};//300
_jugadores = false;

if ({if ((isPlayer _x) and (_x distance _unit < distanciaSPWN2)) exitWith {1}} count allUnits != 0) then
	{
	_jugadores = true;
	[_unit,"heal"] remoteExec ["flagaction",0,_unit];
	[_unit,true] remoteExec ["setCaptive"];
	_lado = _unit getVariable ["lado",sideUnknown];
	_unit setVariable ["lado",_lado,true];
	};

_unit setFatigue 1;

while {(time < _bleedOut) and (damage _unit > 0.25) and (alive _unit) /*and (lifeState _unit == "INCAPACITATED")*/} do
	{
	if (random 10 < 1) then {playSound3D [(injuredSounds call BIS_fnc_selectRandom),_unit,false, getPosASL _unit, 1, 1, 50];};
	_ayudado = _unit getVariable ["ayudado",objNull];
	if (isNull _ayudado) then {[_unit] call pedirAyuda;};
	sleep 3;
	};

_unit stop false;
if (_jugadores) then
	{
	[_unit,"remove"] remoteExec ["flagaction",0,_unit];
	};

if (_unit getVariable ["fatalWound",false]) then {_unit setVariable ["fatalWound",false,true]};

if (time > _bleedOut) exitWith
	{
	_side = _this select 1;
	_lado = _unit getVariable ["lado",sideUnknown];
	if (_side != sideUnknown) then
		{
		if (_side == buenos) then
			{
			if (_lado == malos) then
				{
				[0,0.25,getPos _unit] remoteExec ["citySupportChange",2];
				[0.1,0] remoteExec ["prestige",2];
				}
			else
				{
				[0,1,getPos _unit] remoteExec ["citySupportChange",2];
				[0,0.25] remoteExec ["prestige",2];
				};
			}
		else
			{
			if (_lado == malos) then
				{
				[-0.25,0,getPos _unit] remoteExec ["citySupportChange",2];
				}
			else
				{
				[0.25,0,getPos _unit] remoteExec ["citySupportChange",2];
				};
			};
		};
	_unit setDamage 1;
	};

if (alive _unit) then
	{
	_unit setUnconscious false;
	_unit playMoveNow "AmovPpneMstpSnonWnonDnon_healed";
	_unit setVariable ["overallDamage",damage _unit];
	if (captive _unit) then
		{
		if !(_unit getVariable ["surrendered",false]) then
			{
			[_unit,false] remoteExec ["setCaptive"];
			_unit disableAI "ANIM";
			sleep 120 + (random 120);
			if ((alive _unit) and (!captive _unit) and (lifeState _unit != "INCAPACITATED")) then {_unit enableAI "ANIM"};
			}
		else
			{
			[_unit] spawn surrenderAction
			};
		}
	else
		{
		_unit disableAI "ANIM";
		sleep 120 + (random 120);
		if ((alive _unit) and (!captive _unit) and (lifeState _unit != "INCAPACITATED")) then {_unit enableAI "ANIM"};
		};
	};

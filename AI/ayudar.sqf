private ["_unit","_medico","_timeOut","_curado","_isPlayer","_smoked","_enemy","_cobertura","_dummyGrp","_dummy"];
_unit = _this select 0;
if !(isNull (_unit getVariable ["ayudado",objNull])) exitWith {};
_medico = _this select 1;
if (_medico getVariable ["ayudando",false]) exitWith {};
_unit setVariable ["ayudado",_medico];
_medico setVariable ["ayudando",true];
_curado = false;
_isPlayer = if ({isPlayer _x} count units group _unit >0) then {true} else {false};
_smoked = false;

if (_medico != _unit) then
	{
	if (not (lifestate _unit == "INCAPACITATED")) then
		{
		if (_isPlayer) then {_unit groupChat format ["Comrades, this is %1. I'm hurt",name _unit]};
		playSound3D [(injuredSounds call BIS_fnc_selectRandom),_unit,false, getPosASL _unit, 1, 1, 50];
		};
	if (_isPlayer) then
		{
		[_medico,_unit] spawn
			{
			sleep 2;
			private ["_medico","_unit"];
			_medico = _this select 0;
			_unit = _this select 1;
			_medico groupChat format ["Wait a minute comrade %1, I will patch you up",name _unit]
			};
		};
	if (hasInterface) then {if (player == _unit) then {hint format ["%1 is on the way to help you",name _medico]}};
	_enemy = _medico findNearestEnemy _unit;
	_smoked = [_medico,_unit,_enemy] call cubrirConHumo;
	_medico stop false;
	_timeOut = time + 60;
	_medico doMove getPosATL _unit;
	while {true} do
		{
		if ((!alive _medico) or (!alive _unit) or (_medico distance _unit <= 3) or (_timeOut < time) or (lifestate _medico == "INCAPACITATED") or (_unit != vehicle _unit) or (_medico != vehicle _medico) or (_medico != _unit getVariable ["ayudado",objNull]) or (_unit getVariable ["llevado",false])) exitWith {};
		sleep 1;
		if (isPlayer _unit) then
			{
			if ((unitReady _medico) and (alive _medico) and (_medico distance _unit > 3) and (!(lifestate _medico == "INCAPACITATED")) and (_medico == _unit getVariable ["ayudado",objNull]) and !(_unit getVariable ["llevado",false])) then {_medico setPos position _unit};
			};
		};
	if ((_unit distance _medico <= 3) and (alive _unit) and (alive _medico) and !(lifestate _medico == "INCAPACITATED") and (_medico == vehicle _medico) and (_medico == _unit getVariable ["ayudado",objNull]) and !(_unit getVariable ["llevado",false])) then
		{
		if ((lifeState _unit == "INCAPACITATED") and (!isNull _enemy) and (_timeOut >= time) and (_medico != _unit)) then
			{
			_cobertura = [_unit,_enemy] call cobertura;
			{if ((alive _x) and (lifeState _x != "INCAPACITATED") and (_x distance _medico < 300) and !(_x getVariable ["ayudando",false]) and (!isPlayer _x)) then {[_x,_enemy] call fuegoSupresor}} forEach units (group _medico);
			if (count _cobertura == 3) then
				{
				if (_isPlayer) then {_unit setVariable ["llevado",true,true]};
				_medico setUnitPos "MIDDLE";
				_medico playAction "grabDrag";
				sleep 0.1;
				waitUntil { ((AnimationState _medico) == "AmovPercMstpSlowWrflDnon_AcinPknlMwlkSlowWrflDb_2") || ((AnimationState _medico) == "AmovPercMstpSnonWnonDnon_AcinPknlMwlkSnonWnonDb_2")};
				_unit switchMove "AinjPpneMrunSnonWnonDb";
				_medico disableAI "ANIM";
				//_medico playMoveNow "AcinPknlMstpSrasWrflDnon";
				_medico stop false;
				_dummyGrp = createGroup civilian;
				_dummy = _dummyGrp createUnit ["C_man_polo_1_F", [0,0,0], [], 0, "FORM"];
				_dummy setUnitPos "MIDDLE";
				_dummy forceWalk true;
				if (isMultiplayer) then {[_dummy,true] remoteExec ["hideObjectGlobal",2]} else {_dummy hideObject true};
				_dummy allowdammage false;
				_dummy setBehaviour "CARELESS";
				_dummy disableAI "FSM";
			    _dummy forceSpeed 0.2;
			    _dummy setPosATL (getPosATL _medico);
				_medico attachTo [_dummy, [0, -0.2, 0]];
				_medico setDir 180;
				//_unit attachTo [_dummy, [0, 1.1, 0.092]];
				_unit attachTo [_dummy, [0,-1.1, 0.092]];
				_unit setDir 0;
				_dummy doMove _cobertura;
				[_medico] spawn {sleep 4.5; (_this select 0) playMove "AcinPknlMwlkSrasWrflDb"};
				_timeOut = time + 30;
				while {true} do
					{
					sleep 1;
					if ((!alive _medico) or (!alive _unit) or (_medico distance _cobertura <= 2) or (_timeOut < time) or (lifestate _medico == "INCAPACITATED") or (_medico != vehicle _medico)) exitWith {};
					if (_unit distance _dummy > 3) then
						{
						_unit attachTo [_dummy, [0,-1.1, 0.092]];
						_unit setDir 0;
						};
					if (_medico distance _dummy > 3) then
						{
						_medico attachTo [_dummy, [0, -0.2, 0]];
						_medico setDir 180;
						};
					};
				detach _unit;
				detach _medico;
				detach _dummy;
				deleteVehicle _dummy;
				deleteGroup _dummyGrp;
				_medico enableAI "ANIM";
				if ((alive _unit) and (alive _medico) and !(lifestate _medico == "INCAPACITATED") and (_medico == vehicle _medico)) then
					{
					_medico playMove "amovpknlmstpsraswrfldnon";
					_medico stop true;
					//if (!_smoked) then {[_medico,_unit] call cubrirConHumo};
					_unit stop true;
					sleep 3;
					_medico action ["HealSoldier",_unit];
					_unit playMoveNow "";
					/*
					_unit setUnconscious false;
					waitUntil {sleep 0.1; lifeState _unit != "INCAPACITATED"};
					_unit setUnconscious true;
					*/
					sleep 10;
					_medico stop false;
					_unit stop false;
					_unit dofollow leader group _unit;
					_medico doFollow leader group _unit;
					_curado = true;
					if ((alive _medico) and (alive _unit) and (not((lifestate _medico == "INCAPACITATED")))) then
						{
						if (_medico != _unit) then {if (_isPlayer) then {_medico groupChat format ["You are ready %1",name _unit]}};
						};
					}
				else
					{
					_unit playMoveNow "";
					_unit setUnconscious false;
					waitUntil {sleep 0.1; lifeState _unit != "INCAPACITATED"};
					_unit setUnconscious true;
					};
				if (_isPlayer) then {_unit setVariable ["llevado",false,true]};
				}
			else
				{
				_medico stop true;
				//if (!_smoked) then {[_medico,_unit] call cubrirConHumo};
				_unit stop true;
				_medico action ["HealSoldier",_unit];
				sleep 10;
				_medico stop false;
				_unit stop false;
				_unit dofollow leader group _unit;
				_medico doFollow leader group _unit;
				_curado = true;
				if ((alive _medico) and (alive _unit) and (not((lifestate _medico == "INCAPACITATED")))) then
					{
					if (_medico != _unit) then {if (_isPlayer) then {_medico groupChat format ["You are ready %1",name _unit]}};
					};
				};
			}
		else
			{
			_medico stop true;
			//if (!_smoked) then {[_medico,_unit] call cubrirConHumo};
			_unit stop true;
			_medico action ["HealSoldier",_unit];
			sleep 10;
			_medico stop false;
			_unit stop false;
			_unit dofollow leader group _unit;
			_medico doFollow leader group _unit;
			_curado = true;
			if ((alive _medico) and (alive _unit) and (not((lifestate _medico == "INCAPACITATED")))) then
				{
				if (_medico != _unit) then {if (_isPlayer) then {_medico groupChat format ["You are ready %1",name _unit]}};
				};
			};
		};
	if (_medico == _unit getVariable ["ayudado",objNull]) then {_unit setVariable ["ayudado",objNull]};
	_medico setVariable ["ayudando",nil];
	_medico setUnitPos "AUTO";
	}
else
	{
	[_medico,_medico] call cubrirConHumo;
	if ((alive _medico) and !(lifeState _medico == "INCAPACITATED")) then
		{
		_medico action ["HealSoldierSelf",_medico];
		sleep 10;
		};
	_unit setVariable ["ayudado",objNull];
	_medico setVariable ["ayudando",nil];
	_curado = true;
	};
_curado
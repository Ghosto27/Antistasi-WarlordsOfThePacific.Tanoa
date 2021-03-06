if (!isServer and hasInterface) exitWith{};

_marcador = _this select 0;

_dificil = if (random 10 < tierWar) then {true} else {false};
_salir = false;
_contacto = objNull;
_grpContacto = grpNull;
_tsk = "";
if (_dificil) then
	{
	_posHQ = getMarkerPos "respawn_guerrila";
	_ciudades = ciudades select {getMarkerPos _x distance _posHQ < distanciaMiss};
	_ciudades = _ciudades - [_marcador];
	if (count _ciudades == 0) exitWith {_dificil = false};
	_ciudad = selectRandom _ciudades;

	_tam = [_ciudad] call sizeMarker;
	_posicion = getMarkerPos _ciudad;
	_casas = nearestObjects [_posicion, ["house"], _tam];
	_posCasa = [];
	_casa = objNull;
	while {count _posCasa == 0} do
		{
		_casa = selectRandom _casas;
		_posCasa = [_casa] call BIS_fnc_buildingPositions;
		_casas = _casas - [_casa];
		};
	_grpContacto = createGroup civilian;
	_contacto = _grpContacto createUnit [selectRandom arrayCivs, selectRandom _posCasa, [], 0, "NONE"];
	_contacto allowDamage false;
	_contacto setVariable ["statusAct",false,true];
	_contacto forceSpeed 0;
	_contacto setUnitPos "UP";
	[_contacto,"missionGiver"] remoteExec ["flagaction",[buenos,civilian],_contacto];

	_nombredest = [_ciudad] call localizar;
	_tiempolim = 15;//120
	_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
	_fechalimnum = dateToNumber _fechalim;

	_tsk = ["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"CREATED",5,true,true,"talk"] call BIS_fnc_setTask;
	misiones pushBack _tsk; publicVariable "misiones";

	waitUntil {sleep 1; (_contacto getVariable "statusAct") or (dateToNumber date > _fechalimnum)};
	if (dateToNumber date > _fechalimnum) then
		{
		_salir = true
		}
	else
		{
		if (_marcador in mrkSDK) then
			{
			_salir = true;
			{
			if (isPlayer _x) then {[_contacto,"globalChat","My information is useless now"] remoteExec ["commsMP",_x]}
			} forEach ([50,0,position _casa,"GREENFORSpawn"] call distanceUnits);
			};
		};
	[_contacto] spawn
		{
		_contacto = _this select 0;
		_grpContacto = group _contacto;
		sleep cleanTime;
		deleteVehicle _contacto;
		deleteGroup _grpContacto;
		};
	if (_salir) exitWith
		{
		if (_contacto getVariable "statusAct") then
			{
			[0,_tsk] spawn borrarTask;
			}
		else
			{
			_tsk = ["AS",[buenos,civilian],[format ["An informant is awaiting for you in %1. Go there before %2:%3. He will provide you some info on our next task",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Contact Informer",_ciudad],position _casa,"FAILED",5,true,true,"talk"] call BIS_fnc_setTask;
			[1200,_tsk] spawn borrarTask;
			};
		};
	};
if (_salir) exitWith {};

if (_dificil) then
	{
	[0,_tsk] spawn borrarTask;
	waitUntil {sleep 1; !(_tsk in misiones)};
	};
_posicion = getMarkerPos _marcador;

_tiempolim = if (_dificil) then {15} else {60};
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_tam = [_marcador] call sizeMarker;
_casas = nearestObjects [_posicion, ["house"], _tam];
_poscasa = [];
_casa = _casas select 0;
while {count _poscasa < 3} do
	{
	_casa = _casas call BIS_Fnc_selectRandom;
	_poscasa = [_casa] call BIS_fnc_buildingPositions;
	if (count _poscasa < 3) then {_casas = _casas - [_casa]};
	};

_max = (count _poscasa) - 1;
_rnd = floor random _max;
_postraidor = _poscasa select _rnd;
_posSol1 = _poscasa select (_rnd + 1);
_posSol2 = (_casa buildingExit 0);

_nombredest = [_marcador] call localizar;

_grptraidor = createGroup malos;

_arrayaeropuertos = aeropuertos - mrkSDK - mrkCSAT;
_base = [_arrayaeropuertos, _posicion] call BIS_Fnc_nearestPosition;
_posBase = getMarkerPos _base;

_traidor = _grptraidor createUnit [NATOOfficer2, _postraidor, [], 0, "NONE"];
_traidor allowDamage false;
_sol1 = _grptraidor createUnit [NATOBodyG, _posSol1, [], 0, "NONE"];
_sol2 = _grptraidor createUnit [NATOBodyG, _posSol2, [], 0, "NONE"];
_grptraidor selectLeader _traidor;

_posTsk = (position _casa) getPos [random 100, random 360];

_tsk = ["AS",[buenos,civilian],[format ["A traitor has scheduled a meeting with NATO in %1. Kill him before he provides enough intel to give us trouble. Do this before %2:%3. We don't where exactly this meeting will happen. You will recognise the building by the nearby Offroad and NATO presence.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Traitor",_marcador],_posTsk,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
_tsk1 = ["AS1",[malos],[format ["We arranged a meeting in %1 with a SDK contact who may have vital information about Syndikat Headquarters position. Protect him until %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Protect Contact",_marcador],getPos _casa,"CREATED",5,true,true,"Defend"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

{_nul = [_x,""] call NATOinit; _x allowFleeing 0} forEach units _grptraidor;
_posVeh = [];
_dirVeh = 0;
_roads = [];
_radius = 20;
while {count _roads == 0} do
	{
	_roads = (getPos _casa) nearRoads _radius;
	_radius = _radius + 10;
	};

_road = _roads select 0;
_posroad = getPos _road;
_roadcon = roadsConnectedto _road; if (count _roadCon == 0) then {diag_log format ["Antistasi Error: Esta carretera no tiene conexión: %1",position _road]};
if (count _roadCon > 0) then
	{
	_posrel = getPos (_roadcon select 0);
	_dirveh = [_posroad,_posrel] call BIS_fnc_DirTo;
	}
else
	{
	_dirVeh = getDir _road;
	};
_posVeh = [_posroad, 3, _dirveh + 90] call BIS_Fnc_relPos;
_veh = "B_G_Offroad_01_F" createVehicle _posVeh;
_veh allowDamage false;
_veh setDir _dirVeh;
sleep 15;
_veh allowDamage true;
_traidor allowDamage true;
_nul = [_veh] call AIVEHinit;
{_x disableAI "MOVE"; _x setUnitPos "UP"} forEach units _grptraidor;

_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], getPos _casa];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [50,50];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrk setMarkerAlphaLocal 0;

_grupo = [_posicion,malos, NATOSquad] call spawnGroup;
sleep 1;
if (random 10 < 2.5) then
	{
	_perro = _grupo createUnit ["Fin_random_F",_posicion,[],0,"FORM"];
	[_perro] spawn guardDog;
	};
_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
{[_x,""] call NATOinit} forEach units _grupo;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _traidor) or ({_traidor knowsAbout _x > 1.4} count ([500,0,_traidor,"GREENFORSpawn"] call distanceUnits) > 0)};

if ({_traidor knowsAbout _x > 1.4} count ([500,0,_traidor,"GREENFORSpawn"] call distanceUnits) > 0) then
	{
	//hint "You have been discovered. The traitor is fleeing to the nearest base. Go and kill him!";
	//_tsk = ["AS",[buenos,civilian],[format ["A traitor has scheduled a meeting with NATO in %1. Kill him before he provides enough intel to give us trouble. Do this before %2:%3. We don't where exactly this meeting will happen. You will recognise the building by the nearby Offroad and NATO presence.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Traitor",_marcador],_traidor,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
	{_x enableAI "MOVE"} forEach units _grptraidor;
	_traidor assignAsDriver _veh;
	[_traidor] orderGetin true;
	_wp0 = _grptraidor addWaypoint [_posVeh, 0];
	_wp0 setWaypointType "GETIN";
	_wp1 = _grptraidor addWaypoint [_posBase,1];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointBehaviour "CARELESS";
	_wp1 setWaypointSpeed "FULL";
	};

waitUntil  {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _traidor) or (_traidor distance _posBase < 20)};

if (not alive _traidor) then
	{
	_tsk = ["AS",[buenos,civilian],[format ["A traitor has scheduled a meeting with NATO in %1. Kill him before he provides enough intel to give us trouble. Do this before %2:%3. We don't where exactly this meeting will happen. You will recognise the building by the nearby Offroad and NATO presence.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Traitor",_marcador],_traidor,"SUCCEEDED",5,true,true,"Kill"] call BIS_fnc_setTask;
	_tsk1 = ["AS1",[malos],[format ["We arranged a meeting in %1 with a SDK contact who may have vital information about Syndikat Headquarters position. Protect him until %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Protect Contact",_marcador],getPos _casa,"FAILED",5,true,true,"Defend"] call BIS_fnc_setTask;
	if (_dificil) then
		{
		[4,0] remoteExec ["prestige",2];
		[0,600] remoteExec ["resourcesFIA",2];
		{
		if (!isPlayer _x) then
			{
			_skill = skill _x;
			_skill = _skill + 0.1;
			_x setSkill _skill;
			}
		else
			{
			[20,_x] call playerScoreAdd;
			};
		} forEach ([_tam,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[10,stavros] call playerScoreAdd;
		}
	else
		{
		[2,0] remoteExec ["prestige",2];
		[0,300] remoteExec ["resourcesFIA",2];
		{
		if (!isPlayer _x) then
			{
			_skill = skill _x;
			_skill = _skill + 0.1;
			_x setSkill _skill;
			}
		else
			{
			[10,_x] call playerScoreAdd;
			};
		} forEach ([_tam,0,_posicion,"GREENFORSpawn"] call distanceUnits);
		[5,stavros] call playerScoreAdd;
		};
	}
else
	{
	_tsk = ["AS",[buenos,civilian],[format ["A traitor has scheduled a meeting with NATO in %1. Kill him before he provides enough intel to give us trouble. Do this before %2:%3. We don't where exactly this meeting will happen. You will recognise the building by the nearby Offroad and NATO presence.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Traitor",_marcador],_traidor,"FAILED",5,true,true,"Kill"] call BIS_fnc_setTask;
	_tsk1 = ["AS1",[malos],[format ["We arranged a meeting in %1 with a SDK contact who may have vital information about Syndikat Headquarters position. Protect him until %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Protect Contact",_marcador],getPos _casa,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
	if (_dificil) then {[-10,stavros] call playerScoreAdd} else {[-10,stavros] call playerScoreAdd};
	if (dateToNumber date > _fechalimnum) then
		{
		_hrT = server getVariable "hr";
		_resourcesFIAT = server getVariable "resourcesFIA";
		[-1*(round(_hrT/3)),-1*(round(_resourcesFIAT/3))] remoteExec ["resourcesFIA",2];
		}
	else
		{
		if (isPlayer Stavros) then
			{
			if (!("DEF_HQ" in misiones)) then
				{
				[malos] remoteExec ["ataqueHQ",HCattack];
				};
			}
		else
			{
			_minasFIA = allmines - (detectedMines malos) - (detectedMines muyMalos);
			if (count _minasFIA > 0) then
				{
				{if (random 100 < 30) then {malos revealMine _x;}} forEach _minasFIA;
				};
			};
		};
	};

_nul = [1200,_tsk] spawn borrarTask;
_nul = [10,_tsk1] spawn borrarTask;
if (!([distanciaSPWN,1,_veh,"GREENFORSpawn"] call distanceUnits)) then {deleteVehicle _veh};

{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits)};
deleteVehicle _x
} forEach units _grptraidor;
deleteGroup _grptraidor;

{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"GREENFORSpawn"] call distanceUnits)};
deleteVehicle _x
} forEach units _grupo;
deleteGroup _grupo;
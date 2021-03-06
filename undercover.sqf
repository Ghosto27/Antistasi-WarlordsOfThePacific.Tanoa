private ["_player"];
if (player != player getVariable ["owner",player]) exitWith {hint "You cannot go Undercover while you are controlling AI"};
_player = player getVariable ["owner",player];
if (captive _player) exitWith {hint "You are in Undercover already"};

private ["_compromised","_cambiar","_aeropuertos","_arrayCivVeh","_player","_size","_base"];

_cambiar = "";
_aeropuertos = aeropuertos + puestos + (controles select {isOnRoad (getMarkerPos _x)});
_aeropuertos1 = aeropuertos;
_arrayCivVeh = arrayCivVeh + [civHeli] + civBoats;
_compromised = _player getVariable "compromised";

if (vehicle _player != _player) then
	{
	if (not(typeOf(vehicle _player) in _arrayCivVeh)) then
		{
		hint "You are not in a civilian vehicle";
		_cambiar = "Init"
		};
	if (vehicle _player in reportedVehs) then
		{
		hint "The vehicle you are in has been reported to the enemy. Change your vehicle or renew it in the Garage to become Undercover";
		_cambiar = "Init";
		};
	}
else
	{
	if ((primaryWeapon _player != "") or (secondaryWeapon _player != "") or (handgunWeapon _player != "") or (vest _player != "") or (headgear _player in cascos) or (hmd _player != "") or (not(uniform _player in civUniforms))) then
		{
		hint "You cannot become Undercover while showing:\n\nAny weapon in hand\nWearing Vest\nWearing Helmet\nWearing NV Googles\nWearing a Mil Uniform";
		_cambiar = "Init";
		};
	if (dateToNumber date < _compromised) then
		{
		hint "You have been reported in the last 30 minutes and you cannot become Undercover";
		_cambiar = "Init";
		};
	};

if (_cambiar != "") exitWith {};

if ({((side _x== muyMalos) or (side _x== malos)) and (((_x knowsAbout _player > 1.4) and (_x distance _player < 500)) or (_x distance _player < 350))} count allUnits > 0) exitWith
	{
	hint "You cannot become Undercover while some enemies are spotting you";
	if (vehicle _player != _player) then
		{
		{
		if ((isPlayer _x) and (captive _x)) then {[_x,false] remoteExec ["setCaptive"]; reportedVehs pushBackUnique (vehicle _player); publicVariable "reportedVehs"}
		} forEach ((crew (vehicle _player)) + (assignedCargo (vehicle _player)) - [_player]);
		};
	};

_base = [_aeropuertos,_player] call BIS_fnc_nearestPosition;
_size = [_base] call sizeMarker;
if ((_player distance getMarkerPos _base < _size*2) and (not(_base in mrkSDK))) exitWith {hint "You cannot become Undercover near Airports, Outposts or Roadblocks"};

["Undercover ON",0,0,4,0,0,4] spawn bis_fnc_dynamicText;

[_player,true] remoteExec ["setCaptive"];

if (_player == leader group _player) then
	{
	{if ((!isplayer _x) and (local _x) and (_x getVariable ["owner",_x] == _player)) then {[_x] spawn undercoverAI}} forEach units group _player;
	};

while {_cambiar == ""} do
	{
	sleep 1;
	if (!captive _player) then
		{
		_cambiar = "Reported";
		}
	else
		{
		_veh = vehicle _player;
		_tipo = typeOf _veh;
		if (_veh != _player) then
			{
			if (not(_tipo in _arrayCivVeh)) then
				{
				_cambiar = "VNoCivil"
				}
			else
				{
				if (_veh in reportedVehs) then
					{
					_cambiar = "VCompromised"
					}
				else
					{
					if ((_tipo != "C_Heli_Light_01_civil_F") and (!(_tipo in civBoats))) then
						{
						if !(isOnRoad position _veh) then
							{
							if (count (_veh nearRoads 50) == 0) then
								{
								if ({((side _x== muyMalos) or (side _x== malos)) and ((_x knowsAbout _player > 1.4) or (_x distance _player < 350))} count allUnits > 0) then {_cambiar = "Carretera"};
								};
							};
						if (hayACE) then
							{
			  				if (((position _player nearObjects ["DemoCharge_Remote_Ammo", 5]) select 0) mineDetectedBy malos) then
								{
								_cambiar = "SpotBombTruck";
								};
							if (((position _player nearObjects ["SatchelCharge_Remote_Ammo", 5]) select 0) mineDetectedBy malos) then
								{
								_cambiar = "SpotBombTruck";
								};
							};
						};
					};
				}
			}
		else
			{
			if ((primaryWeapon _player != "") or (secondaryWeapon _player != "") or (handgunWeapon _player != "") or (vest _player != "") or (headgear _player in cascos) or (hmd _player != "") or (not(uniform _player in civUniforms))) then
				{
				if ({((side _x== muyMalos) or (side _x== malos)) and ((_x knowsAbout _player > 1.4) or (_x distance _player < 350))} count allUnits > 0) then {_cambiar = "Vestido2"} else {_cambiar = "Vestido"};
				};
			if (dateToNumber date < _compromised) then
				{
				_cambiar = "Compromised";
				};
			};
		if (_cambiar == "") then
			{
			if ((_tipo != civHeli) and (!(_tipo in civBoats))) then
				{
				_base = [_aeropuertos,_player] call BIS_fnc_nearestPosition;
				_size = [_base] call sizeMarker;
				if ((_player distance getMarkerPos _base < _size) and ((_base in mrkNATO) or (_base in mrkCSAT))) then
					{
					_cambiar = "Distancia";
					};
				}
			else
				{
				if (_tipo == civHeli) then
					{
					_base = [_aeropuertos1,_player] call BIS_fnc_nearestPosition;
					_size = [_base] call sizeMarker;
					if ((_player distance2d getMarkerPos _base < _size*3) and ((_base in mrkNATO) or (_base in mrkCSAT))) then
						{
						_cambiar = "NoFly";
						};
					};
				};
			};
		};
	};

if (captive _player) then {[_player,false] remoteExec ["setCaptive"]};

if (vehicle _player != _player) then
	{
	{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive"]}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)) - [_player]);
	};

["Undercover OFF",0,0,4,0,0,4] spawn bis_fnc_dynamicText;
switch _cambiar do
	{
	case "Reported":
		{
		hint "You have been reported or spotted by the enemy";
		//_compromised = _player getVariable "compromised";
		if (vehicle _player != _player) then
			{
			//_player setVariable ["compromised",[_compromised select 0,vehicle _player]];
			reportedVehs pushBackUnique (vehicle _player); publicVariable "reportedVehs";
			}
		else
			{
			_player setVariable ["compromised",(dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
			};
		};
	case "VNoCivil": {hint "You entered in a non civilian vehicle"};
	case "VCompromised": {hint "You entered in a reported vehicle"};
	case "SpotBombTruck":
		{
		hint "Explosives have been spotted on your vehicle";
		reportedVehs pushBackUnique (vehicle _player); publicVariable "reportedVehs";
		};
	case "Carretera":
		{
		hint "You went far from roads and have been spotted";
		reportedVehs pushBackUnique (vehicle _player); publicVariable "reportedVehs";
		};
	case "Vestido": {hint "You cannot stay Undercover while showing:\n\nAny weapon in hand\nWearing Vest\nWearing Helmet\nWearing NV Googles\nWearing a Mil Uniform"};
	case "Vestido2":
		{
		hint "You cannot stay Undercover while showing:\n\nAny weapon in hand\nWearing Vest\nWearing Helmet\nWearing NV Googles\nWearing a Mil Uniform.\n\nThe enemy added you to the Wanted list";
		_player setVariable ["compromised",dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30]];
		};
	case "Compromised": {hint "You left your vehicle and you are still in the Wanted list"};
	case "Distancia":
		{
		hint "You have got too close to an enemy Base, Outpost or Roadblock";
		//_compromised = _player getVariable "compromised";
		if (vehicle _player != _player) then
			{
			//_player setVariable ["compromised",[_compromised select 0,vehicle _player]];
			reportedVehs pushBackUnique (vehicle _player); publicVariable "reportedVehs";
			}
		else
			{
			_player setVariable ["compromised",(dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
			};
		};
	case "NoFly":
		{
		hint "You have got too close to an enemy Airbase no-fly zone";
		//_compromised = _player getVariable "compromised";
		reportedVehs pushBackUnique (vehicle _player); publicVariable "reportedVehs";
		};
	};

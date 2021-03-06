waitUntil {!isNull player};
waitUntil {player == player};
player removeweaponGlobal "itemmap";
player removeweaponGlobal "itemgps";
if (isMultiplayer) then
	{
	[] execVM "briefing.sqf";
	if (!isServer) then
		{
		call compile preprocessFileLineNumbers "initVar.sqf";
		if (!hasInterface) then {call compile preprocessFileLineNumbers "roadsDB.sqf"};
		call compile preprocessFileLineNumbers "initFuncs.sqf";
		};
	};
if (!hasInterface) exitWith {};
_isJip = _this select 1;

if (isMultiplayer) then {waitUntil {!isNil "initVar"}; diag_log format ["Antistasi MP Client. initVar is public. Version %1",antistasiVersion];};

if (isMultiplayer) then
	{
	if (side player == buenos) then {player setVariable ["elegible",true,true]};
	musicON = false;
	//waitUntil {scriptdone _introshot};
	disableUserInput true;
	cutText ["Waiting for Players and Server Init","BLACK",0];
	diag_log "Antistasi MP Client. Waiting for serverInitDone";
	waitUntil {(!isNil "serverInitDone")};
	cutText ["Starting Mission","BLACK IN",0];
	diag_log "Antistasi MP Client. serverInitDone is public";
	diag_log format ["Antistasi MP Client: JIP?: %1",_isJip];
	caja addEventHandler ["ContainerOpened",
	    {
	    _jugador = _this select 1;
	    if (not([_jugador] call isMember)) then
	       {
	    	_jugador setPos position petros;
	        hint "You are not in the Member's List of this Server.\n\nAsk the Commander in order to be allowed to access the HQ Ammobox.\n\nIn the meantime you may use the other box to store equipment and share it with others.";
	        }
	    else
	    	{
	    	if ((side _jugador == malos) or (side _jugador == muyMalos)) then
	    		{
	    		_jugador setPos position petros;
	        	hint "Access reserved to Syndikat players.";
	    		};
	    	};
	    }
        ];
    player addEventHandler ["InventoryOpened",
	{
	_control = false;
	_jugador = _this select 0;
	if !([_jugador] call isMember) then
		{
		if ((_this select 1 == caja) or ((_this select 0) distance caja < 3)) then
			{
			_control = true;
			hint "You are not in the Member's List of this Server.\n\nAsk the Commander in order to be allowed to access the HQ Ammobox.\n\nIn the meantime you may use the other box to store equipment and share it with others.";
			}
		else
			{
			if (_this select 1 == caja) then
				{
				if ((side player == malos) or (side player == muyMalos)) then
		    		{
		    		player setPos position petros;
		        	hint "Access reserved to Syndikat players.";
		    		};
				};
			};
		};
	if (captive _jugador) then
		{
		_contenedor = _this select 1;
		if ((_contenedor isKindOf "Man") and (!alive _contenedor)) then
			{
			if ({if (((side _x== muyMalos) or (side _x== malos)) and (_x knowsAbout _jugador > 1.4)) exitWith {1}} count allUnits > 0) then
				{
				[_jugador,false] remoteExec ["setCaptive"];
				}
			else
				{
				_ciudad = [ciudades,_jugador] call BIS_fnc_nearestPosition;
				_size = [_ciudad] call sizeMarker;
				_datos = server getVariable _ciudad;
				if (random 100 < _datos select 2) then
					{
					if (_jugador distance getMarkerPos _ciudad < _size * 1.5) then
						{
						[_jugador,false] remoteExec ["setCaptive"];
						};
					};
				};
			};
		};
	_control
	}];
	if (side player == buenos) then
		{
		player addEventHandler ["Fired",
			{
			_tipo = _this select 1;
			if ((_tipo == "Put") or (_tipo == "Throw")) then
				{
				if (player distance petros < 50) then
					{
					deleteVehicle (_this select 6);
					if (_tipo == "Put") then
						{
						if (player distance petros < 10) then {[player,60] spawn castigo};
						};
					};
				};
			}];
		};
	if (!isNil "placementDone") then {_isJip = true};//workaround for BIS fail on JIP detection
	}
else
	{
	stavros = player;
	grupo = group player;
	grupo setGroupId ["Pulu","GroupColor4"];
	player setIdentity "protagonista";
	player setUnitRank "COLONEL";
	player hcSetGroup [group player];
	waitUntil {/*(scriptdone _introshot) and */(!isNil "serverInitDone")};
	_nul = addMissionEventHandler ["Loaded", {_nul = [] execVM "statistics.sqf";_nul = [] execVM "reinitY.sqf";}];
	player addEventHandler ["InventoryOpened",
		{
		_control = false;
		_jugador = _this select 0;
		if (captive _jugador) then
			{
			_contenedor = _this select 1;
			if ((_contenedor isKindOf "Man") and (!alive _contenedor)) then
				{
				if ({if (((side _x== muyMalos) or (side _x== malos)) and (_x knowsAbout _jugador > 1.4)) exitWith {1}} count allUnits > 0) then
					{
					[_jugador,false] remoteExec ["setCaptive"];
					}
				else
					{
					_ciudad = [ciudades,_jugador] call BIS_fnc_nearestPosition;
					_size = [_ciudad] call sizeMarker;
					_datos = server getVariable _ciudad;
					if (random 100 < _datos select 2) then
						{
						if (_jugador distance getMarkerPos _ciudad < _size * 1.5) then
							{
							[_jugador,false] remoteExec ["setCaptive"];
							};
						};
					};
				};
			};
		_control
		}];
	};

private ["_colorbuenos", "_colormuyMalos"];
_colorbuenos = buenos call BIS_fnc_sideColor;
_colormuyMalos = muyMalos call BIS_fnc_sideColor;
_posicion = if (side player == buenos) then {position petros} else {getMarkerPos "respawn_west"};
{
_x set [3, 0.33]
} forEach [_colorbuenos, _colormuyMalos];
_introShot =
	[
    _posicion, // Target position
    "Tanoa Island", // SITREP text
    50, //  altitude
    50, //  radius
    90, //  degrees viewing angle
    0, // clockwise movement
    [
    	["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colorbuenos, markerPos "insertMrk", 1, 1, 0, "Insertion Point", 0],
        ["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colormuyMalos, markerPos "towerBaseMrk", 1, 1, 0, "Radio Towers", 0]
    ]
    ] spawn BIS_fnc_establishingShot;

_titulo = ["Warlords of the Pacific","by Barbolani",antistasiVersion] spawn BIS_fnc_infoText;
disableUserInput false;
player addWeaponGlobal "itemmap";
player addWeaponGlobal "itemgps";
if (!hayACE) then
	{
	[player] execVM "Revive\initRevive.sqf";
	tags = [] execVM "tags.sqf";
	if ((cadetMode) and (isMultiplayer) and (side player == buenos)) then {_nul = [] execVM "playerMarkers.sqf"};
	}
else
	{
	if (hayACEhearing) then {player addItem "ACE_EarPlugs"};
	if (!hayACEMedical) then {[player] execVM "Revive\initRevive.sqf"}/* else {player setVariable ["inconsciente",false,true]}*/;
	};

if (side player != buenos) exitWith
	{
	moto = objNull;
	if (!_isJIP) then
		{
		["noPvP",false,1,false,false] call BIS_fnc_endMission
		}
	else
		{
		if (not([player] call isMember)) then
			{
			["noPvP",false,1,false,false] call BIS_fnc_endMission
			}
		else
			{
			if ({(side _x != buenos) and (side _x != civilian)} count playableUnits > {(side _x == buenos) or (side _x == civilian)} count playableUnits) then {["noPvP",false,1,false,false] call BIS_fnc_endMission}
			};
		};
	if (side player == malos) then {player setVariable ["BLUFORSpawn",true,true]} else {player setVariable ["OPFORSpawn",true,true]};
	"respawn_guerrila" setMarkerAlphaLocal 0;
	player addEventHandler ["GetInMan",
		{
		private ["_unit","_veh"];
		_unit = _this select 0;
		_veh = _this select 2;
		if (_veh != moto) then {moveOut player; hint "You are only allowed to use your Quadbike"};
		}];
	["TaskFailed", ["", format ["%1 joined NATO SpecOps",name player]]] remoteExec ["BIS_fnc_showNotification",[buenos,civilian]];
	if (!hayACEhearing) then
		{
		waituntil {!isnull (finddisplay 46)};
		gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",
			{
			_handled = FALSE;
			if (_this select 1 == 207) then
				{
				if (soundVolume <= 0.5) then
					{
					0.5 fadeSound 1;
					hintSilent "You've taken out your ear plugs.";
					}
				else
					{
					0.5 fadeSound 0.1;
					hintSilent "You've inserted your ear plugs.";
					};
				}
			else
				{
				if (_this select 1 == 21) then
					{
					closedialog 0;
					_nul = createDialog "NATO_player";
					};
				};
			_handled
			}];
		};
	};

player setVariable ["owner",player,true];
player setVariable ["punish",0,true];
player setVariable ["dinero",100,true];
player setVariable ["GREENFORSpawn",true,true];
player setVariable ["rango",rank player,true];
if (player!=stavros) then {player setVariable ["score", 0,true]} else {player setVariable ["score", 25,true]};
rezagados = creategroup buenos;
(group player) enableAttack false;
player setUnitTrait ["camouflageCoef",0.8];
player setUnitTrait ["audibleCoef",0.8];

if (activeGREF) then {_nul = [player] execVM "Municion\RHSdress.sqf"};
player setvariable ["compromised",0];
player addEventHandler ["FIRED",
	{
	_player = _this select 0;
	if (captive _player) then
		{
		//if ({((side _x== muyMalos) or (side _x== malos)) and (_x knowsAbout player > 1.4)} count allUnits > 0) then
		if ({if (((side _x == malos) or (side _x == muyMalos)) and (_x distance player < 300)) exitWith {1}} count allUnits > 0) then
			{
			[_player,false] remoteExec ["setCaptive"];
			}
		else
			{
			_ciudad = [ciudades,_player] call BIS_fnc_nearestPosition;
			_size = [_ciudad] call sizeMarker;
			_datos = server getVariable _ciudad;
			if (random 100 < _datos select 2) then
				{
				if (_player distance getMarkerPos _ciudad < _size * 1.5) then
					{
					[_player,false] remoteExec ["setCaptive"];
					if (vehicle _player != _player) then
						{
						{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive"]}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)) - [player]);
						};
					};
				};
			};
		}
	}
	];
player addEventHandler ["HandleHeal",
	{
	_player = _this select 0;
	if (captive _player) then
		{
		if ({((side _x== muyMalos) or (side _x== malos)) and (_x knowsAbout player > 1.4)} count allUnits > 0) then
			{
			[_player,false] remoteExec ["setCaptive"];
			}
		else
			{
			_ciudad = [ciudades,_player] call BIS_fnc_nearestPosition;
			_size = [_ciudad] call sizeMarker;
			_datos = server getVariable _ciudad;
			if (random 100 < _datos select 2) then
				{
				if (_player distance getMarkerPos _ciudad < _size * 1.5) then
					{
					[_player,false] remoteExec ["setCaptive"];
					};
				};
			};
		}
	}
	];
player addEventHandler ["WeaponAssembled",
	{
	private ["_veh"];
	_veh = _this select 1;
	if (_veh isKindOf "StaticWeapon") then
		{
		if (not(_veh in staticsToSave)) then
			{
			staticsToSave pushBack _veh;
			publicVariable "staticsToSave";
			[_veh] call AIVEHinit;
			};
		}
	else
		{
		_veh addEventHandler ["Killed",{[_this select 0] remoteExec ["postmortem",2]}];
		};
	}];
player addEventHandler ["WeaponDisassembled",
		{
		_bag1 = _this select 1;
		_bag2 = _this select 2;
		//_bag1 = objectParent (_this select 1);
		//_bag2 = objectParent (_this select 2);
		[_bag1] call AIVEHinit;
		[_bag2] call AIVEHinit;
		}
	];

player addEventHandler ["GetInMan",
	{
	private ["_unit","_veh"];
	_unit = _this select 0;
	_veh = _this select 2;
	_exit = false;
	if (isMultiplayer) then
		{
		_owner = _veh getVariable "duenyo";
		if (!isNil "_owner") then
			{
			if (_owner isEqualType "") then
				{
				if ({getPlayerUID _x == _owner} count (units group player) == 0) then
					{
					hint "You cannot board other player vehicle if you are not in the same group";
					moveOut _unit;
					_exit = true;
					};
				};
			};
		};
	if (!_exit) then
		{
		if (((typeOf _veh) in arrayCivVeh) or ((typeOf _veh) in civBoats)) then
			{
			if (!(_veh in reportedVehs)) then
				{
				[] spawn undercover;
				};
			};
		if (_veh isKindOf "Truck_F") then
			{
			if ((not (_veh isKindOf "C_Van_01_fuel_F")) and (not (_veh isKindOf "I_Truck_02_fuel_F")) and (not (_veh isKindOf "B_G_Van_01_fuel_F"))) then
				{
				if (_this select 1 == "driver") then {[_unit,"camion"] call flagaction};
				};
			};
		};
	}
	];
player addEventHandler ["GetOutMan",
	{
	_veh = _this select 2;
	if (_veh isKindOf "Truck_F") then
		{
		if ((not (_veh isKindOf "C_Van_01_fuel_F")) and (not (_veh isKindOf "I_Truck_02_fuel_F")) and (not (_veh isKindOf "B_G_Van_01_fuel_F"))) then
			{
			player removeAction accion;
			};
		};
	}];
if (isMultiplayer) then
	{
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;//Exec on client
	["InitializeGroup", [player,buenos,true]] call BIS_fnc_dynamicGroups;
	personalGarage = [];
	};
caja addEventHandler ["ContainerOpened",
	{
	_armas = weaponCargo caja;
	hint format ["Arsenal Unlocking Requirements\n\n\nWeapons: %1\nBackpacks: %5\nMagazines: %2\nOptics: %3\nVests: %3\nOther Items: %4\n\n\nWeapon Type Count:\n\nA. Rifles: %6\nLMGs: %7\nS.Rifles: %8\nHandguns: %9\nR. Launchers: %10\nM. Launchers: %11\n\nNV Googles: %12",minWeaps,minMags,minOptics,minItems,minPacks,{_x in arifles} count _armas,{_x in mguns} count _armas,{_x in srifles} count _armas,{_x in hguns} count _armas,{_x in rlaunchers} count _armas,{_x in mlaunchers} count _armas,{(_x == "NVGoggles") or (_x == "NVGoggles_OPFOR") or (_x == "NVGoggles_INDEP") or (_x == "NVGoggles_tna_F")} count itemCargo caja];
	}
    ];
waitUntil {scriptdone _introshot};
if (_isJip) then
	{
	_nul = [] execVM "modBlacklist.sqf";
	//player setVariable ["score",0,true];
	//player setVariable ["owner",player,true];
	player setVariable ["punish",0,true];
	player setUnitRank "PRIVATE";
	waitUntil {!isNil "posHQ"};
	player setPos posHQ;
	[true] execVM "reinitY.sqf";
	if (not([player] call isMember)) then
		{
		if (serverCommandAvailable "#logout") then
			{
			miembros pushBack (getPlayerUID player);
			publicVariable "miembros";
			hint "You are not in the member's list, but as you are Server Admin, you have been added up. Welcome!"
			}
		else
			{
			hint "Welcome Guest\n\nYou have joined this server as guest";
			if ((count playableUnits == maxPlayers) and (({[_x] call isMember} count playableUnits) < count miembros) and (serverName in servidoresOficiales)) then {["serverFull",false,1,false,false] call BIS_fnc_endMission};
			};
		}
	else
		{
		hint format ["Welcome back %1", name player];
		if (serverName in servidoresOficiales) then
			{
			if ((count playableUnits == maxPlayers) and (({[_x] call isMember} count playableUnits) < count miembros)) then
				{
				{
				if (not([_x] call isMember)) exitWith {["serverFull",false,1,false,false] remoteExec ["BIS_fnc_endMission",_x]};
				} forEach playableUnits;
				};
			};
		if ({[_x] call isMember} count playableUnits == 1) then
			{
			[player] call stavrosInit;
			[] remoteExec ["assignStavros",2];
			};
		};
	/*
	{
	if (_x isKindOf "FlagCarrier") then
		{
		_marcador = [marcadores,getPos _x] call BIS_fnc_nearestPosition;
		if (not(_marcador in controles)) then
			{
			if (not(_marcador in mrkSDK)) then
				{
				_x addAction ["Take the Flag", {[[_this select 0, _this select 1],"mrkWIN"] call BIS_fnc_MP;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side _this == buenos)"];
				}
			else
				{
				_x addAction ["Unit Recruitment", {nul=[] execVM "Dialogs\unit_recruit.sqf";;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
				_x addAction ["Buy Vehicle", {nul = createDialog "vehicle_option";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
				_x addAction ["Personal Garage", {nul = [true] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
				_x addAction ["SDK Garage", {nul = [false] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side _this == buenos)"];
				};
			};
		};
	} forEach vehicles - [bandera,fuego,caja,cajaVeh];
	{
	if (typeOf _x == "b_g_survivor_F") then
		{
		if (!isPlayer (leader group _x)) then
			{
			_x addAction ["Order Refugee to follow me", "AI\liberaterefugee.sqf",nil,0,false,true];
			};
		};
	} forEach allUnits;
	if (petros == leader group petros) then
		{
		removeAllActions petros;
		petros addAction ["Mission Request", {nul=CreateDialog "mission_menu";},nil,0,false,true];
		}
	else
		{
		removeAllActions petros;
		petros addAction ["Build HQ here", {[] spawn buildHQ},nil,0,false,true];
		};
	*/
	if ((player == stavros) and (isNil "placementDone") and (isMultiplayer)) then
		{
		_nul = [] execVM "Dialogs\initMenu.sqf";
		/*
		if (backpack player == "tf_rt1523g_sage") then
			{
			[caja,["tf_rt1523g_sage"],true] call BIS_fnc_addVirtualBackpackCargo;
			unlockedBackpacks pushBack "tf_rt1523g_sage";
	  		publicVariable "unlockedBackpacks";
	   		};
		*/
		}
	else
		{
		_nul = [true] execVM "Dialogs\firstLoad.sqf";
		};
	diag_log "Antistasi MP Client. JIP client finished";
	}
else
	{
	if (isNil "placementDone") then
		{
		waitUntil {!isNil "stavros"};
		if (player == stavros) then
		    {
		    if (isMultiplayer) then
		    	{
		    	HC_comandante synchronizeObjectsAdd [player];
				player synchronizeObjectsAdd [HC_comandante];
		    	_nul = [] execVM "Dialogs\initMenu.sqf";
		    	/*
		    	if (backpack player == "tf_rt1523g_sage") then
		    		{
		    		[caja,["tf_rt1523g_sage"],true] call BIS_fnc_addVirtualBackpackCargo;
		    		unlockedBackpacks pushBack "tf_rt1523g_sage";
		    		publicVariable "unlockedBackpacks";
		    		};
		    	*/
		    	diag_log "Antistasi MP Client. Client finished";
		    	}
		    else
		    	{
		    	miembros = [];
		    	 _nul = [] execVM "Dialogs\firstLoad.sqf";
		    	};
		    };
		};
	};
waitUntil {scriptDone _titulo};

_texto = [];

if ((hayTFAR) or (hayACRE)) then
	{
	_texto = ["TFAR or ACRE Detected\n\nAntistasi detects TFAR or ACRE in the server config.\nAll players will start with addon default radios.\nDefault revive system will shut down radios while players are inconscious.\n\n"];
	};
if (hayACE) then
	{

	_texto = _texto + ["ACE 3 Detected\n\nAntistasi detects ACE modules in the server config.\nACE items added to arsenal, ammoboxes, and NATO drops. Default AI control is disabled\nIf ACE Medical is used, default revive system will be disabled.\nIf ACE Hearing is used, default earplugs will be disabled."];
	};
if (hayRHS) then
	{
	_texto = _texto + ["RHS Detected\n\nAntistasi detects RHS in the server config.\nDepending on the modules will have the following effects.\n\nAFRF: Replaces CSAT by a mix of russian units\n\nUSAF: Replaces NATO by a mix of US units\n\nGREF: Recruited AI will count with RHS as basic weapons, replaces FIA with Chdk units. Adds some civilian trucks"];
	};

if (hayTFAR or hayACE or hayRHS or hayACRE) then
	{
	//hint format ["%1",_texto]
	[_texto] spawn
		{
		sleep 0.5;
		_texto = _this select 0;
		"Integrated Mods Detected" hintC _texto;
		hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
			0 = _this spawn {
				_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
				hintSilent "";
			};
			}];
		};
	};
waituntil {!isnull (finddisplay 46)};
gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",teclas];
statistics = [] execVM "statistics.sqf";
removeAllActions caja;

activeXLA = true;
if (activeXLA) then
	{
	["AmmoboxInit",[caja,false,{true},"Arsenal",true]] call xla_fnc_arsenal;
	caja addAction ["Arsenal", {["Open",[false,caja,player,true]] call xla_fnc_arsenal;},[],6,true,false,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull]) and (side _this != malos)",5];
	}
else
	{
	_action = caja addaction ["Arsenal",
		{
		_this call accionArsenal;
		},
		[],
		6,
		true,
		false,
		"",
		"
		_cargo = _target getvariable ['bis_addVirtualWeaponCargo_cargo',[[],[],[],[]]];
		if ({count _x > 0} count _cargo == 0) then
			{
			_target removeaction (_target getvariable ['bis_fnc_arsenal_action',-1]);
			_target setvariable ['bis_fnc_arsenal_action',nil];
			};
		_condition = _target getvariable ['bis_fnc_arsenal_condition',{true}];
		alive _target && {_target distance _this < 5} && {call _condition}
		"
		];
	caja setvariable ["bis_fnc_arsenal_action",_action];
	};
caja addAction ["Transfer Vehicle cargo to Ammobox", "[] call vaciar"];
caja addAction ["Move this asset", "moveHQObject.sqf",nil,0,false,true,"","(_this == stavros)"];

_nul = [player] execVM "OrgPlayers\unitTraits.sqf";

if (!isServer) exitWith {};
private ["_armas","_armasTrad","_addedWeapons","_lockedWeapon","_armasFinal","_precio","_arma","_armaTrad","_priceAdd","_updated","_magazines","_addedMagazines","_magazine","_magazinesFinal","_items","_addedItems","_item","_cuenta","_itemsFinal","_mochis","_mochisTrad","_addedMochis","_lockedMochi","_mochisFinal","_mochi","_mochiTrad","_armasConCosa","_armaConCosa"];

_updated = "";

_armas = weaponCargo caja;
_mochis = backpackCargo caja;
_magazines = magazineCargo caja;
_items = itemCargo caja;

_addedMagazines = [];

{
_magazine = _x;
if (not(_magazine in unlockedMagazines)) then
	{
	if ({_x == _magazine} count _magazines >= minMags) then
		{
		_addedMagazines pushBack _magazine;
		unlockedMagazines pushBack _magazine;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")];
		};
	};
} forEach allMagazines - primaryMagazines;

_armasTrad = [];

{
_armaTrad = [_x] call BIS_fnc_baseWeapon;
_armasTrad pushBack _armaTrad;

} forEach _armas;

_addedWeapons = [];

_ariflesC = _armasTrad select {_x in arifles};
_mgunsC = _armasTrad select {_x in mguns};
_sriflesC = _armasTrad select {_x in srifles};
_hgunsC = _armasTrad select {_x in hguns};
_mlaunchersC = _armasTrad select {_x in mlaunchers};
_rlaunchersC = _armasTrad select {_x in rlaunchers};
_armasFinal = [];
{
_arma = "";
_cuenta = 0;

if (count _x >= minWeaps) then
	{
	_arma = selectRandom _x;
	_magazine = (getArray (configFile / "CfgWeapons" / _arma / "magazines") select 0);
	if (!isNil "_magazine") then
		{
		if (not(_magazine in unlockedMagazines)) then
			{
			_addedMagazines pushBack _magazine;
			unlockedMagazines pushBack _magazine; //publicVariable "unlockedMagazines";
			_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")];
			};
		};
	_addedWeapons pushBack _arma;
	//unlockedWeapons pushBack _arma; publicVariable "unlockedWeapons";
	//lockedWeapons = lockedWeapons - [_arma];
	if (_arma in arifles) then {unlockedRifles pushBack _arma; publicVariable "unlockedRifles"};
	_cuenta = _cuenta + ({_x == _arma} count _x);
	_x = _x - [_arma];
	_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _arma >> "displayName")];
	};

if (_arma != "") then
	{
	while {_cuenta < minWeaps} do
		{
		_x deleteAt (floor(random(count _x)));
		_cuenta = _cuenta + 1;
		};
	};

_armasFinal = _armasFinal + _x;
} forEach [_ariflesC,_mgunsC,_sriflesC,_hgunsC,_mlaunchersC,_rlaunchersC];

/*
{
_lockedWeapon = _x;

if ({_x == _lockedWeapon} count _armasTrad >= minWeaps) then
	{
	_desbloquear = false;
	//_magazines = getArray (configFile / "CfgWeapons" / _x / "magazines");
	_magazine = (getArray (configFile / "CfgWeapons" / _x / "magazines") select 0);
	if (!isNil "_magazine") then
		{
		if (_magazine in unlockedMagazines) then
			{
			_desbloquear = true;
			}
		else
			{
			if ({_x == _magazine} count _magazines >= minMags) then
				{
				_desbloquear = true;
				_addedMagazines pushBack _magazine;
				unlockedMagazines pushBack _magazine;
				_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")];
				};
			};
		}
	else
		{
		_desbloquear = true;
		};
	if (_desbloquear) then
		{
		_addedWeapons pushBack _lockedWeapon;
		unlockedWeapons pushBack _lockedWeapon;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _lockedWeapon >> "displayName")];
		};
	};
} forEach lockedWeapons;
*/

if (count _addedMagazines > 0) then
	{
	[caja,_addedMagazines,true,false] call addVirtualMagazineCargo;
	publicVariable "unlockedMagazines";
	};

_magazinesFinal = [];

for "_i" from 0 to (count _magazines) - 1 do
	{
	_magazine = _magazines select _i;
	if (not(_magazine in unlockedMagazines)) then
		{
		_magazinesFinal pushBack _magazine;
		};
	};

if (count _addedWeapons > 0) then
	{
	lockedWeapons = lockedWeapons - _addedWeapons;
	//lockedWeapons = lockedWeapons - _addedWeapons;//verificar si tiene que ser pública
	[caja,_addedWeapons,true,false] call addVirtualWeaponCargo;
	unlockedWeapons = unlockedWeapons + _addedWeapons;
	publicVariable "unlockedWeapons";
	};

//_armasFinal = [];
_armasConCosa = weaponsItems caja;

for "_i" from 0 to (count _armas) - 1 do
	{
	_arma = _armas select _i;
	_armaTrad = _armasTrad select _i;
	if (not(_armaTrad in unlockedWeapons)) then
		{
		//_armasFinal pushBack _arma;
		}
	else
		{
		if (_arma != _armaTrad) then
			{
			_armaConCosa = _armasConCosa select _i;
			if ((_armaConCosa select 0) == _arma) then
				{
				{
				if (typeName _x != typeName []) then {_items pushBack _x};
				} forEach (_armaConCosa - [_arma]);
				};
			};
		};
	};

_mochisTrad = [];

{
_mochiTrad = _x call BIS_fnc_basicBackpack;
_mochisTrad pushBack _mochiTrad;
} forEach _mochis;

_addedMochis = [];
{
_lockedMochi = _x;
if ({_x == _lockedMochi} count _mochisTrad >= minPacks) then
	{
	_addedMochis pushBack _lockedMochi;
	_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgVehicles" >> _lockedMochi >> "displayName")];
	};
} forEach lockedMochis;

if (count _addedMochis > 0) then
	{
	lockedMochis = lockedMochis - _addedMochis;//verificar si tiene que ser pública
	[caja,_addedMochis,true,false] call addVirtualBackpackCargo;
	unlockedBackpacks = unlockedBackpacks + _addedMochis;
	//unlockedMochis = unlockedMochis + _addedMochis;
	publicVariable "unlockedBackpacks";
	};

_mochisFinal = [];

for "_i" from 0 to (count _mochis) - 1 do
	{
	_mochi = _mochis select _i;
	_mochiTrad = _mochisTrad select _i;
	if (not(_mochiTrad in unlockedBackpacks)) then
		{
		_mochisFinal pushBack _mochi;
		};
	};


_addedItems = [];

{
_item = _x;
if (not(_item in unlockedItems)) then
	{
	_cuenta = minOptics;
	if (_item in itemsAAF) then {_cuenta = minItems};
	if ({_x == _item} count _items >= _cuenta) then
		{
		_addedItems pushBack _item;
		unlockedItems pushBack _item;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> _item >> "displayName")];
		if (_item in opticasAAF) then {unlockedOptics pushBack _item; publicVariable "unlockedOptics"};
		};
	};
} forEach allItems + ["bipod_01_F_snd","bipod_01_F_blk","bipod_01_F_mtp","bipod_02_F_blk","bipod_02_F_tan","bipod_02_F_hex","bipod_03_F_blk"] - ["NVGoggles","Laserdesignator"];

if (not("NVGoggles" in unlockedItems)) then
	{
	if ({_x in NVGoggles} count itemCargo caja >= minItems) then
		{
		_addedItems = _addedItems + NVGoggles;
		unlockedItems = unlockedItems + NVGoggles;
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "NVGoggles" >> "displayName")];
		};
	};

if (not("Laserdesignator" in unlockedItems)) then
	{
	if ({(_x == "Laserdesignator") or (_x == "Laserdesignator_02") or (_x == "Laserdesignator_03")} count itemCargo caja >= minItems) then
		{
		_addedItems pushBack "Laserdesignator";
		unlockedItems pushBack "Laserdesignator";
		_updated = format ["%1%2<br/>",_updated,getText (configFile >> "CfgWeapons" >> "Laserdesignator" >> "displayName")];
		};
	};
if (count _addedItems >0) then
	{
	[caja,_addedItems,true,false] call addVirtualItemCargo;
	//unlockedItems = unlockedItems + _addedItems;
	publicVariable "unlockedItems";
	};

_itemsFinal = [];

for "_i" from 0 to (count _items) - 1 do
	{
	_item = _items select _i;
	if (not(_item in unlockedItems)) then
		{
		if ((_item == "NVGoggles_OPFOR") or (_item == "NVGoggles_INDEP")) then
			{
			if (not("NVGoggles" in unlockedItems)) then
				{
				_itemsFinal pushBack _item;
				};
			}
		else
			{
			if ((_item == "Laserdesignator_02") or (_item == "Laserdesignator_03")) then
				{
				if (not("Laserdesignator" in unlockedItems)) then
					{
					_itemsFinal pushBack _item;
					};
				}
			else
				{
				_itemsFinal pushBack _item;
				};
			};
		};
	};

//[0,_precio] remoteExec ["resourcesFIA",2];

if (count _armas != count _armasFinal) then
	{
	clearWeaponCargoGlobal caja;
	{caja addWeaponCargoGlobal [_x,1]} forEach _armasFinal;
	//unlockedRifles = unlockedweapons -  hguns -  mlaunchers - rlaunchers - ["Binocular","Laserdesignator","Rangefinder"] - srifles - mguns; publicVariable "unlockedRifles";
	};
if (count _mochis != count _mochisFinal) then
	{
	clearBackpackCargoGlobal caja;
	{caja addBackpackCargoGlobal [_x,1]} forEach _mochisFinal;
	};
if (count _magazines != count _magazinesFinal) then
	{
	clearMagazineCargoGlobal caja;
	{caja addMagazineCargoGlobal [_x,1]} forEach _magazinesFinal;
	};
if (count _items != count _itemsFinal) then
	{
	clearItemCargoGlobal caja;
	{caja addItemCargoGlobal [_x,1]} forEach _itemsFinal;
	};

_updated
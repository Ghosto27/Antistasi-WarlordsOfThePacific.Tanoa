if (!activeXLA) then {["AmmoboxInit",[caja,false,{true}]] call BIS_fnc_arsenal};

call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";

isBuildingPosition = compile preProcessFileLineNumbers "AI\Buildings\isBuildingPosition.sqf";
groupDespawner= compile preProcessFileLineNumbers "CREATE\groupDespawner.sqf";
patrolReinf= compile preProcessFileLineNumbers "CREATE\patrolReinf.sqf";
reinforcementsAI= compile preProcessFileLineNumbers "CREATE\reinforcementsAI.sqf";
garrisonUpdate= compile preProcessFileLineNumbers "CREATE\garrisonUpdate.sqf";
garrisonSize= compile preProcessFileLineNumbers "CREATE\garrisonSize.sqf";
inconscienteAAF = compile preProcessFileLineNumbers "Revive\inconscienteAAF.sqf";
cobertura = compile preProcessFileLineNumbers "AI\cobertura.sqf";
spawnGroup = compile preProcessFileLineNumbers "CREATE\spawnGroup.sqf";
fogCheck = compile preProcessFileLineNumbers "fogCheck.sqf";
tierCheck = compile preProcessFileLineNumbers "orgPlayers\tierCheck.sqf";
autoLoot = compile preProcessFileLineNumbers "AI\autoLoot.sqf";
NATOFT = compile preProcessFileLineNumbers "NATOFT.sqf";
NATOQuadbike = compile preProcessFileLineNumbers "REINF\NATOQuadbike.sqf";
fuegoSupresor = compile preProcessFileLineNumbers "AI\fuegoSupresor.sqf";
reDress = compile preProcessFileLineNumbers "REINF\reDress.sqf";
WPCreate = compile preProcessFileLineNumbers "CREATE\WPCreate.sqf";
vehicleMarkers = compile preProcessFileLineNumbers "AI\vehicleMarkers.sqf";
unlockVehicle = compile preProcessFileLineNumbers "unlockVehicle.sqf";
addBombRun = compile preProcessFileLineNumbers "REINF\addBombRun.sqf";
NATObomb = compile preProcessFileLineNumbers "REINF\NATObomb.sqf";
cargoSeats = compile preProcessFileLineNumbers "CREATE\cargoSeats.sqf";
vehAvailable = compile preProcessFileLineNumbers "CREATE\vehAvailable.sqf";
isTheSameIsland = compile preProcessFileLineNumbers "isTheSameIsland.sqf";
CSATCrate = compile preProcessFileLineNumbers "Municion\CSATCrate.sqf";
markerChange = compile preProcessFileLineNumbers "markerChange.sqf";
zoneCheck = compile preProcessFileLineNumbers "zoneCheck.sqf";
tempMoveMrk = compile preProcessFileLineNumbers "tempMoveMrk.sqf";
hasRadio = compile preProcessFileLineNumbers "AI\hasRadio.sqf";
accionArsenal = compile preProcessFileLineNumbers "Municion\accionArsenal.sqf";
revealToPlayer = compile preProcessFileLineNumbers "revealToPlayer.sqf";
mineSweep = compile preProcessFileLineNumbers "AI\mineSweep.sqf";
powerCheck = compile preProcessFileLineNumbers "powerCheck.sqf";
addTimeForIdle = compile preProcessFileLineNumbers "addTimeForIdle.sqf";
AAFKilledEH = compile preProcessFileLineNumbers "AI\AAFKilledEH.sqf";
handleDamageAAF = compile preProcessFileLineNumbers "Revive\handleDamageAAF.sqf";
AIVEHinit = compile preProcessFileLineNumbers "CREATE\AIVEHinit.sqf";
civVEHinit = compile preProcessFileLineNumbers "CREATE\civVEHinit.sqf";
smokeCoverAuto = compile preProcessFileLineNumbers "AI\smokeCoverAuto.sqf";
landThreatEval = compile preProcessFileLineNumbers "AI\landThreatEval.sqf";
mortarPos = compile preProcessFileLineNumbers "CREATE\mortarPos.sqf";
REP_Antena = compile preProcessFileLineNumbers "Missions\REP_Antena.sqf";
placementSelection = compile preProcessFileLineNumbers "placementselection.sqf";
isMember = compile preProcessFileLineNumbers "orgPlayers\isMember.sqf";
vaciar = compile preProcessFileLineNumbers "Municion\vaciar.sqf";
AS_specOP = compile preProcessFileLineNumbers "Missions\AS_specOP.sqf";
artySupport = compile preProcessFileLineNumbers "AI\artySupport.sqf";
teclas = compile preProcessFileLineNumbers "teclas.sqf";
distanceUnits = compile preProcessFileLineNumbers "distanceUnits.sqf";
munitionTransfer = compile preProcessFileLineNumbers "Municion\munitionTransfer.sqf";
fn_location = compile preProcessFileLineNumbers "fn_location.sqf";
borrarTask = compile preProcessFileLineNumbers "Missions\borrarTask.sqf";
undercover = compile preProcessFileLineNumbers "undercover.sqf";
puertasLand = compile preProcessFileLineNumbers "AI\puertasLand.sqf";
AAthreatEval = compile preProcessFileLineNumbers "AI\AAthreatEval.sqf";
mortyAI = compile preProcessFileLineNumbers "AI\mortyAI.sqf";
surrenderAction = compile preProcessFileLineNumbers "AI\surrenderAction.sqf";
guardDog = compile preProcessFileLineNumbers "AI\guardDog.sqf";
VEHdespawner = compile preProcessFileLineNumbers "CREATE\VEHdespawner.sqf";
napalmDamage = compile preProcessFileLineNumbers "AI\napalmDamage.sqf";
napalm = compile preProcessFileLineNumbers "AI\napalm.sqf";
rearmCall = compile preProcessFileLineNumbers "AI\rearmCall.sqf";
randomRifle = compile preProcessFileLineNumbers "Municion\randomRifle.sqf";
findSafeRoadToUnload = compile preProcessFileLineNumbers "AI\findSafeRoadToUnload.sqf";
garageVehicle = compile preProcessFileLineNumbers "garageVehicle.sqf";
garage = compile preProcessFileLineNumbers "garage.sqf";
captiveMP = compile preProcessFileLineNumbers "captiveMP.sqf";
ranksMP = compile preProcessFileLineNumbers "OrgPlayers\ranksMP.sqf";
//hayLOS = compile preProcessFileLineNumbers "AI\hayLOS.sqf";
arsenalManage = compile preProcessFileLineNumbers "Municion\arsenalManage.sqf";
undercoverAI = compile preProcessFileLineNumbers "AI\undercoverAI.sqf";
memberAdd = compile preProcessFileLineNumbers "OrgPlayers\memberAdd.sqf";
membersList = compile preProcessFileLineNumbers "OrgPlayers\membersList.sqf";
donateMoney = compile preProcessFileLineNumbers "OrgPlayers\donateMoney.sqf";
stavrosSteal = compile preProcessFileLineNumbers "OrgPlayers\stavrosSteal.sqf";
resourcesPlayer = compile preProcessFileLineNumbers "OrgPlayers\resourcesPlayer.sqf";
numericRank = compile preProcessFileLineNumbers "numericRank.sqf";
inconsciente = compile preProcessFileLineNumbers "Revive\inconsciente.sqf";
respawn = compile preProcessFileLineNumbers "Revive\respawn.sqf";
handleDamage = compile preProcessFileLineNumbers "Revive\handleDamage.sqf";
initRevive = compile preProcessFileLineNumbers "Revive\initRevive.sqf";
pedirAyuda = compile preProcessFileLineNumbers "AI\pedirAyuda.sqf";
ayudar = compile preProcessFileLineNumbers "AI\ayudar.sqf";
autoHealFnc = compile preProcessFileLineNumbers "AI\autoHealFnc.sqf";
cubrirConHumo = compile preProcessFileLineNumbers "AI\cubrirConHumo.sqf";
intelFound = compile preProcessFileLineNumbers "intelFound.sqf";
minefieldAAF = compile preProcessFileLineNumbers "CREATE\minefieldAAF.sqf";
staticAutoT = compile preProcessFileLineNumbers "AI\staticAutoT.sqf";
vehStats = compile preProcessFileLineNumbers "REINF\vehStats.sqf";
addSquadVeh = compile preProcessFileLineNumbers "REINF\addSquadVeh.sqf";
returnMuzzle = compile preProcessFileLineNumbers "returnMuzzle.sqf";
autoRearm = compile preProcessFileLineNumbers "AI\autoRearm.sqf";
rebuildAssets = compile preProcessFileLineNumbers "rebuildAssets.sqf";
garrisonInfo = compile preProcessFileLineNumbers "garrisonInfo.sqf";
groupComposition = compile preProcessFileLineNumbers "REINF\groupComposition.sqf";
vehiclePrice = compile preProcessFileLineNumbers "REINF\vehiclePrice.sqf";
VANTinfo = compile preProcessFileLineNumbers "AI\VANTinfo.sqf";
//attackDrill = compile preProcessFileLineNumbers "AI\attackDrill.sqf"; borrarlo si vemos que no lo necesitamos más
garrisonAdd = compile preProcessFileLineNumbers "REINF\garrisonAdd.sqf";
garrisonDialog = compile preProcessFileLineNumbers "REINF\garrisonDialog.sqf";
isFrontline = compile preProcessFileLineNumbers "isFrontline.sqf";
timingCA = compile preProcessFileLineNumbers "timingCA.sqf";
destroyCity = compile preProcessFileLineNumbers "destroyCity.sqf";
CSATpunish = compile preProcessFileLineNumbers "CREATE\CSATpunish.sqf";
FIAradio = compile preProcessFileLineNumbers "FIAradio.sqf";
deleteControles = compile preProcessFileLineNumbers "deleteControles.sqf";
cleanserVeh = compile preProcessFileLineNumbers "CREATE\cleanserVeh.sqf";
crearControles = compile preProcessFileLineNumbers "crearControles.sqf";
citiesToCivPatrol = compile preProcessFileLineNumbers "citiesToCivPatrol.sqf";
unlimitedAmmo = compile preProcessFileLineNumbers "AI\unlimitedAmmo.sqf";
NATOCrate = compile preProcessFileLineNumbers "Municion\NATOCrate.sqf";
puestoDialog = compile preProcessFileLineNumbers "puestoDialog.sqf";
mineDialog = compile preProcessFileLineNumbers "Dialogs\mineDialog.sqf";
onPlayerDisconnect = compile preProcessFileLineNumbers "onPlayerDisconnect.sqf";
playerScoreAdd = compile preProcessFileLineNumbers "orgPlayers\playerScoreAdd.sqf";
assignStavros = compile preProcessFileLineNumbers "orgPlayers\assignStavros.sqf";
stavrosInit = compile preProcessFileLineNumbers "orgPlayers\stavrosInit.sqf";
castigo = compile preProcessFileLineNumbers "castigo.sqf";
createFIApuestos2 = compile preProcessFileLineNumbers "CREATE\createFIApuestos2.sqf";
crearPuestosFIA = compile preProcessFileLineNumbers "crearPuestosFIA.sqf";
fpsChange = compile preProcessFileLineNumbers "fpsChange.sqf";
buildMinefield = compile preProcessFileLineNumbers "REINF\buildMinefield.sqf";
FIAinit = compile preProcessFileLineNumbers "REINF\FIAinit.sqf";
postmortem = compile preProcessFileLineNumbers "REINF\postmortem.sqf";
commsMP = compile preProcessFileLineNumbers "commsMP.sqf";
radioCheck = compile preProcessFileLineNumbers "radioCheck.sqf";
autoGarrison = compile preProcessFileLineNumbers "REINF\autoGarrison.sqf";
sellVehicle = compile preProcessFileLineNumbers "sellVehicle.sqf";
garbageCleaner = compile preProcessFileLineNumbers "garbageCleaner.sqf";
resourceCheckSkipTime = compile preProcessFileLineNumbers "resourcecheckSkipTime.sqf";
CONVOY = compile preProcessFileLineNumbers "Missions\CONVOY.sqf";
RES_Prisioneros = compile preProcessFileLineNumbers "Missions\RES_Prisioneros.sqf";
RES_Refugiados = compile preProcessFileLineNumbers "Missions\RES_Refugiados.sqf";
LOG_Bank = compile preProcessFileLineNumbers "Missions\LOG_Bank.sqf";
LOG_Suministros = compile preProcessFileLineNumbers "Missions\LOG_Suministros.sqf";
LOG_Ammo = compile preProcessFileLineNumbers "Missions\LOG_Ammo.sqf";
DES_Vehicle = compile preProcessFileLineNumbers "Missions\DES_Vehicle.sqf";
DES_Heli = compile preProcessFileLineNumbers "Missions\DES_Heli.sqf";
DES_Antena = compile preProcessFileLineNumbers "Missions\DES_Antena.sqf";
CON_Puestos = compile preProcessFileLineNumbers "Missions\CON_Puestos.sqf";
ataqueHQ = compile preProcessFileLineNumbers "Missions\ataqueHQ.sqf";
localizar = compile preProcessFileLineNumbers "localizar.sqf";
AS_Oficial = compile preProcessFileLineNumbers "Missions\AS_Oficial.sqf";
AS_Traidor = compile preProcessFileLineNumbers "Missions\AS_Traidor.sqf";
missionrequest = compile preProcessFileLineNumbers "Missions\missionrequest.sqf";
missionrequestAUTO = compile preProcessFileLineNumbers "Missions\missionrequestAUTO.sqf";
cajaAAF = compile preProcessFileLineNumbers "Municion\cajaAAF.sqf";
flagaction = compile preProcessFileLineNumbers "flagaction.sqf";
resourcesFIA = compile preProcessFileLineNumbers "resourcesFIA.sqf";
prestige = compile preProcessFileLineNumbers "prestige.sqf";
createCIV = compile preProcessFileLineNumbers "CREATE\createCIV.sqf";
createAIciudades = compile preProcessFileLineNumbers "CREATE\createAIciudades.sqf";
createAIcontroles = compile preProcessFileLineNumbers "CREATE\createAIcontroles.sqf";
createAIpuestos = compile preProcessFileLineNumbers "CREATE\createAIpuestos.sqf";
createAIrecursos = compile preProcessFileLineNumbers "CREATE\createAIrecursos.sqf";
createAIaerop = compile preProcessFileLineNumbers "CREATE\createAIaerop.sqf";
createSDKGarrisons = compile preProcessFileLineNumbers "CREATE\createSDKGarrisons.sqf";
AAFroadPatrol = compile preProcessFileLineNumbers "CREATE\AAFroadpatrol.sqf";
FIAinitBases = compile preProcessFileLineNumbers "CREATE\FIAinitBases.sqf";
reinfPlayer = compile preProcessFileLineNumbers "REINF\reinfplayer.sqf";
addFIAsquadHC = compile preProcessFileLineNumbers "REINF\addFIAsquadHC.sqf";
addFIAveh = compile preProcessFileLineNumbers "REINF\addFIAveh.sqf";
FIAskillAdd = compile preProcessFileLineNumbers "REINF\FIAskillAdd.sqf";
NATOinit = compile preProcessFileLineNumbers "CREATE\NATOinit.sqf";
CIVinit = compile preProcessFileLineNumbers "CREATE\CIVinit.sqf";
patrolCA = compile preProcessFileLineNumbers "CREATE\patrolCA.sqf";
wavedCA = compile preProcessFileLineNumbers "CREATE\wavedCA.sqf";
findBasesForCA = compile preProcessFileLineNumbers "findBasesForCA.sqf";
findBasesForConvoy = compile preProcessFileLineNumbers "findBasesForConvoy.sqf";
findAirportsForCA = compile preProcessFileLineNumbers "findAirportsForCA.sqf";
patrolDestinos = compile preProcessFileLineNumbers "patrolDestinos.sqf";
ataqueAAF = compile preProcessFileLineNumbers "ataqueAAF.sqf";
citySupportChange = compile preProcessFileLineNumbers "citySupportChange.sqf";
distancias4 = compile preProcessFileLineNumbers "distancias4.sqf";
inmuneConvoy = compile preProcessFileLineNumbers "AI\inmuneConvoy.sqf";
smokeCover = compile preProcessFileLineNumbers "AI\smokeCover.sqf";
fastrope = compile preProcessFileLineNumbers "AI\fastrope.sqf";
airdrop = compile preProcessFileLineNumbers "AI\airdrop.sqf";
airstrike = compile preProcessFileLineNumbers "AI\airstrike.sqf";
artilleria = compile preProcessFileLineNumbers "AI\artilleria.sqf";
dismountFIA = compile preProcessFileLineNumbers "AI\dismountFIA.sqf";
powerReorg = compile preProcessFileLineNumbers "powerReorg.sqf";
apagon = compile preProcessFileLineNumbers "apagon.sqf";
sizeMarker = compile preProcessFileLineNumbers "sizeMarker.sqf";
mrkWIN = compile preProcessFileLineNumbers "mrkWIN.sqf";
mrkUpdate = compile preProcessFileLineNumbers "mrkUpdate.sqf";
moveHQ = compile preProcessFileLineNumbers "moveHQ.sqf";
buildHQ = compile preProcessFileLineNumbers "buildHQ.sqf";
statistics = compile preProcessFileLineNumbers "statistics.sqf";
execVM "statSave\saveFuncs.sqf";

if ((isMultiplayer) and (isServer)) then {[[petros,"hint","Functions Init Completed"],"commsMP"] call BIS_fnc_MP};

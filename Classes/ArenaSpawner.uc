//-----------------------------------------------------------
// Spawns beach arena
//-----------------------------------------------------------
class ArenaSpawner extends Actor PlaceAble;


var() archetype ArenaPawn aPawn;
var() int TeamNumber;
var ArenaPawn SpawnerOwner;  // the pawn that spawned , in his spawn...
var() vector SpawnLocation;
var() bool ShouldUseSpawnLOcation;
var bool a;

function SpawnPawn()
{
 if(ShouldUseSpawnLOcation)
 {
 SpawnerOwner= spawn(class'ArenaPawn',,,Spawnlocation,,aPawn);
 }

  if(!ShouldUseSpawnLOcation)
 {

   if(!a)  {
 SpawnerOwner= spawn(class'ArenaPawn',,,location,,aPawn); a=true;


   }
 }

 SpawnerOwner.SpawnDefaultController();
 WorldInfo.Game.broadcast(self,SpawnerOwner.controllerClass);
//spawnActor on arenaSpawner

 WorldInfo.Game.broadcast(self,SpawnerOwner.controller);



        SpawnerOwner.StartFire(0);
}

DefaultProperties
{


aPawn=ArenaPawn'ArenaContent.Archetypes.TheSimpleArenaPawn'


SpawnLocation=(x=0,y=0,z=0);


}
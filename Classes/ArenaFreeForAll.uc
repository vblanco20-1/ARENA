//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ArenaFreeForAll extends ArenaGameInfo ;

//ArrayForTheSpawners
var array<ArenaSpawner> FreeForAllSpawner;

//function to comunicate with the spawners
Function Debuger()
{
FreeForAllSpawner[0].SpawnPawn();

WorldInfo.Game.broadcast(self,"Working");
}


//Before starting to play check the spawners
Simulated event PostBeginPlay()
{
 local ArenaSpawner AS;

 foreach DynamicActors(class'ArenaSpawner', AS)
 FreeForAllSpawner[FreeForAllSpawner.length] = AS;


 SetTimer(5,true,'debuger');
 HUDType=class'Arena.ArenaHud';
 super.PostBeginPlay();
}


DefaultProperties
{

}
class ArenaGameInfo extends SimpleGame;

//The Spawner That spawns enemys
var ArenaSpawner Spawner;


//random number
var Array<Int> Numbers;

//Add Sword And Pawn Archetype Variables
var() const archetype ArenaPawn PawnArchetype;

//function that spawns pawn at the starting
function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local Pawn SpawnedPawn;

    if (NewPlayer == none || StartSpot == none)
    {
        return none;
    }

    SpawnedPawn=Spawn(PawnArchetype.class,,, StartSpot.Location,, PawnArchetype);

    return SpawnedPawn;
}




//Get Random number for what? , for the Melee attack 4 ways .
function Int GetRandomNumber()
{
       local int Num;

       Num = Rand(4) % Numbers.Length;


       return Numbers[Num];
}



//Post begin To play Funct
simulated event postbeginplay()
{
  super.Postbeginplay();
  //works

}

DefaultProperties
{

     Numbers(0)=1
     Numbers(1)=2
     Numbers(2)=3
     Numbers(3)=4


    PawnArchetype=ArenaPawn'ArenaContent.Archetypes.TheSimpleArenaPawn'
    PlayerControllerClass=class'Arena.ArenaPlayerController'


}
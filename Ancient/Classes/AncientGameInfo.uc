class AncientGameInfo extends SimpleGame;


//Add Sword And Pawn Archetype Variables
var() const archetype AncientPawn PawnArchetype;
var() const archetype AncientMeleeWeapon SwordArchetype;

//random number
var Array<Int> Numbers;



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
event postbeginplay()
{

}

DefaultProperties
{

     Numbers(0)=1
     Numbers(1)=2
     Numbers(2)=3
     Numbers(3)=4
    SwordArchetype=AncientMeleeWeapon'AncientContent.Archetypes.AncientBarSword'
    PawnArchetype=AncientPawn'AncientContent.Archetypes.AncientsimplePawn'
    PlayerControllerClass=class'Ancient.AncientPlayerController'
    //HUDType=class'Ancient.AncientHud'

}
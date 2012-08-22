//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AncientAIController extends AIcontroller;

var Pawn player;
var Pawn Target;
var() float CombatDistance;
var Vector MovTarget; //for the "gotothisplace stuff"

function DoHeavyAttack()
{
    Pawn.StartFire(1);
    SetTimer(0.52,false,'HitHeavy');
    if(Target.Health<=0)
    {
        GotoState('Idle');
        Target=none;

    }
}
function HitHeavy()
{
	//needed for the timer
	 pawn.StopFire(1);
}
function bool isNear()
{
if(VSize(Target.Location-Pawn.Location)<= CombatDistance)
    {
        return true;
    }
    else
    {
        return false;
    }
}
function DoLightAttack()
{
    Pawn.StartFire(0);
    Pawn.StopFire(0);
    if(Target.Health<=0)
    {
        GotoState('Idle');
        Target=none;
    }
}
event Possess(Pawn inPawn, bool bVehicleTransition)
{
  super.Possess(inPawn, bVehicleTransition);
  //initialize Pawn Physics
  WorldInfo.Game.Broadcast(self,"BeenPossesed");
  inPawn.SetMovementPhysics();
}
auto state Idle
{
   event SeePlayer(Pawn Seen)
   {
      WorldInfo.Game.Broadcast(self,"ic");
     super.SeePlayer(Seen);
     Target = Seen;
     if(IsNear())
     {
        GotoState('Combat');
     }
     else
     {
        GotoState('charging');
     }

   }

}
state Chasing
{

   Begin:
      MoveToward(Target);

      if(IsNear())
     {
        GotoState('Combat');
     }

      goto 'Begin';
}

state Charging  //i want the AI to go running to the target and hit him in the face
{


     Begin:
        MoveToward(Target);

     if(VSize(Target.Location-Pawn.Location)<= CombatDistance+50)
     {
        DoHeavyAttack();
        GotoState('Combat');
     }

      goto 'Begin';
}
state Combat
{
    function GotorandomPosition()
    {
         MovTarget = Target.Location;
         MovTarget.x+=RandRange(-20.0,20.0);
         MovTarget.y+=RandRange(-20.0,20.0);

    }
    function BeginState(name PreviousStateName)
    {
        DoHeavyAttack();
        SetTimer(0.3,true,'checkdistance');
        SetTimer(0.7,true,'DoLightAttack');
        SetTimer(randRange(0.2,1.0),true,'gotorandomposition');
    }
    function EndState(name PreviousStateName)
    {
        ClearallTimers();
    }
    function checkdistance()
    {
        if(!IsNear())
        {
            GotoState('Chasing');
        }
    }
    Begin:
    if(MovTarget!=vect(0,0,0)){
    	MoveTo(MovTarget);
	}


}


DefaultProperties
{
    CombatDistance=200;


}
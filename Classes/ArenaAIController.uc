//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ArenaAIController extends AIcontroller;


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
function SetTarget(pawn Objetive)
{
	Target=Objetive;
	if(IsNear())
     {
        GotoState('Combat');
     }
     else
     {
        GotoState('charging');
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

   event SeeMonster(Pawn Seen)
   {
      WorldInfo.Game.Broadcast(self,"SEEMONSTORE");
     super.SeeMonster(Seen);
      SetTarget(Seen);
   }
   event SeePlayer(Pawn Seen)
   {
      //WorldInfo.Game.Broadcast(self,"ic");
     super.SeePlayer(Seen);
     SetTarget(Seen);
   }
	event HearNoise( float Loudness, Actor NoiseMaker, optional Name NoiseType )
	{

			SetTarget(Pawn(NoiseMaker));
            `log(NoiseType);
	}
	event BeginState(name PreviousStateName)
	{
		MakeNoise(100000,'ComeHere');
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
     }

     if (VSize(Target.Location-Pawn.Location)<= CombatDistance)
     {
        gotoState('combat');
     }
      goto 'Begin';
}
state Combat
{
    function GoToRandomPosition()
    {
         MovTarget = Target.Location;
         MovTarget.x+=RandRange(-50.0,50.0);
         MovTarget.y+=RandRange(-50.0,50.0);

         SetTimer(randRange(0.5,2),false,'gotorandomposition');
    }
    function BeginState(name PreviousStateName)
    {
        DoHeavyAttack();
        SetTimer(0.3,true,'checkdistance');
        SetTimer(1.5,true,'DoLightAttack');
        MovTarget=Target.location;

        ArenaPawn(pawn).Slowthepawn();//slows the pawn

        SetTimer(randRange(0.5,2),false,'gotorandomposition');
    }
    function EndState(name PreviousStateName)
    {
        ClearallTimers();

        ArenaPawn(pawn).RestoreSpeed();

    }
    function checkdistance()
    {
        if(!IsNear())
        {
            GotoState('Chasing');
        }
    }
    Begin:

    MoveToDirectNonPathPos(MovTarget,Target,5.0,false);
    sleep(0.1);
    goto('begin');


}


DefaultProperties
{
    CombatDistance=150;


}
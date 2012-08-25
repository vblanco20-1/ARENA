//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ArenaAIController extends AIcontroller;


var Pawn Target;
var() float CombatDistance;
var Vector MovTarget; //for the "gotothisplace stuff"
var() Vector TempDest;

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
	goToState('Follow');
	//if(IsNear())
//     {
//        GotoState('Combat');
//     }
//     else
//     {
//        GotoState('Follow');
//     }
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
		WorldInfo.Game.Broadcast(self,"seeya");
		super.SeePlayer(Seen);
		if(!ArenaPawn(pawn).IsSameTeam(Seen))
		{
			SetTarget(Seen);
		}

   }
	event HearNoise( float Loudness, Actor NoiseMaker, optional Name NoiseType )
	{

			//SetTarget(Pawn(NoiseMaker));
            `log(NoiseType);
	}
	event BeginState(name PreviousStateName)
	{
		MakeNoise(100000,'ComeHere');
	}

}
//state Chasing
//{
//	ignores Seeplayer;
//   Begin:
//      MoveToward(Target);
//
//      if(IsNear())
//     {
//        GotoState('Combat');
//     }
//
//      goto 'Begin';
//}

state Follow
{
    ignores SeePlayer;
    function bool FindNavMeshPath()
    {
        // Clear cache and constraints (ignore recycling for the moment)
        NavigationHandle.PathConstraintList = none;
        NavigationHandle.PathGoalList = none;

        // Create constraints
        class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,target );
        class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target,32 );

        // Find path
        return NavigationHandle.FindPath();
    }
Begin:
	 `log("followin");
    if( NavigationHandle.ActorReachable( target) )
    {
        FlushPersistentDebugLines();

        //Direct move
        MoveToward( target,target );
    }
    else if( FindNavMeshPath() )
    {
        NavigationHandle.SetFinalDestination(target.Location);
        FlushPersistentDebugLines();
        NavigationHandle.DrawPathCache(,true);

        // move to the first node on the path
        if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
        {
            DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
            DrawDebugSphere(TempDest,16,20,255,0,0,true);

            MoveTo( TempDest, target );
        }
    }
    else
    {
        //We can't follow, so get the hell out of this state, otherwise we'll enter an infinite loop.
        GotoState('Idle');
    }

 	if(IsNear())
    {
       GotoState('Combat');
    }

    goto 'Begin';
}
state Charging  //i want the AI to go running to the target and hit him in the face
{
ignores Seeplayer;
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
ignores Seeplayer;
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
            GotoState('Follow');
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
	bIsPlayer=true;

}
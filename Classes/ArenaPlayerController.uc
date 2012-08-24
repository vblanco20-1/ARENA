class ArenaPlayerController Extends PlayerController;

var int ActualHealth;
Var float Time;
Var string LastMouseInput;
var ArenaPawn ThePlayer;
Var bool bHasTarget;
var bool bUpdateHud;
//reference to the HUD for Cntrolling Purposes
var ArenaHud HUD;

function UpdateHud(float DeltaTime)
{
	if(bUpdateHud)
	{
		//Repair reference do event based Through PostBeginToPlay , repair PostBeginTOplay
		HUD=ArenaHud(myHUD);
		HUD.PlayerHealth=ArenaPawn(self.Pawn).health;
		HUD.PlayerVigour=ArenaPawn(self.Pawn).vigour;
		HUD.PlayerAmmo=ArenaPawn(self.Pawn).Ammo;

	}

}

//when you press i you enter in your inventory and you get mouse
State DoInventoryBussines
{
//NOTHING IN THIS MOMENT
}
State GotTarget extends PlayerWalking
{

	simulated event PlayerTick(float DeltaTime)
	{
		super.PlayerTick(DeltaTime);
		UpdateHud(DeltaTime);
		Locktarget();
	}
}


//HUd Variables on CHange
event PlayerTick( float DeltaTime )
{

    UpdateHud(DeltaTime);
    super.PlayerTick(DeltaTime);
}


//Caputuretime Function
exec function CaptureTime()
{
SetTimer(0.1,true,'AddNumberPerTime');
WorldInfo.game.broadcast(self,"YouPressedO");
}

 //Set Target , Rotates pawn to a location, and start state
exec Function SetTarget()
{
If(bHasTarget==false)
{
GotoState('GotTarget');
}
if(bHasTarget==True)
{
GotoState('PlayerWalking');
}
worldInfo.Game.Broadcast(self,bHasTarget);
}


//Clears the current Target And returns to state
exec Function ClearTarget()
{
If(bHasTarget==false){
bHasTarget=true;}
else
{
 bHasTarget=false;
}


WorldinFo.Game.Broadcast(self,bHasTarget);
}



 function LockTarget()
 {
local Rotator AimRotation;
local ArenaPawn ArenaPlayer;
local vector TargetLocation;
ArenaPlayer = ArenaPawn(self.Pawn);

TargetLocation.X=0;
TargetLocation.Y=0;
TargetLocation.Z=0;


AimRotation=rotator(TargetLocation - ArenaPlayer.Location);

ArenaPlayer.SetViewRotation(AimRotation);
ArenaPlayer.UpdatePawnRotation(AimRotation);

}



//Rotation Function
 function UpdateRotation(float DeltaTime)
{
    local ArenaPawn APawn;

    super.UpdateRotation(DeltaTime);

    APawn = ArenaPawn(self.Pawn);

    if (APawn != none)
    {
        APawn.CamPitch = Clamp(APawn.CamPitch + self.PlayerInput.aLookUp, -APawn.IsoCamAngle, APawn.IsoCamAngle);
    }
}

function SpawnersVariableDeclaration()
{
	WorldINfo.Game.Broadcast(self,"Hello");
}

Simulated event postbeginPlay()
{

	super.PostBeginPlay();
	if(ArenaFreeForAll(WorldInfo.Game)!= none)
	{
		ArenaFreeForAll(WorldInfo.Game).Debuger();
	}
	Settimer(1,false,'checkHud');
	settimer(1,false,'SpawnersVariableDeclaration');
}

function checkHud()
{
	if(myHUD.class == class'ArenaHud')
	{
		bUpdateHud=true;
		`log("has ArenaHud");
	}
}
defaultproperties
{
	bUpdateHud=false;
}
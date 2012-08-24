class ArenaPlayerController Extends PlayerController;

var int ActualHealth;
Var float Time;
Var string LastMouseInput;
var ArenaPawn ThePlayer;
Var bool bHasTarget;

//reference to the HUD for Cntrolling Purposes
var ArenaHud HUD;

//when you press i you enter in your inventory and you get mouse
State DoInventoryBussines
{


}

State GotTarget extends PlayerWalking
{
//
//  simulated event PlayerTick(float DeltaTime)
//   {
// local ArenaPawn APawn;
//    super.PlayerTick(DeltaTime);
//    APawn = ArenaPawn(self.Pawn);
//
//    //Repair reference do event based Through PostBeginToPlay , repair PostBeginTOplay
//    HUD=ArenaHud(myHUD);
//    HUD.PlayerHealth=Apawn.health;
//    HUD.PlayerVigour=Apawn.vigour;
//    HUD.PlayerAmmo=Apawn.Ammo;
//
//      Locktarget();
//   }
}


//HUd Variables on CHange
event PlayerTick( float DeltaTime )
{
    //local ArenaPawn Apawn;
//
//    APawn = ArenaPawn(self.Pawn);
//
//    HUD=ArenaHud(myHUD);
//    HUD.PlayerHealth=Apawn.health;
//    HUD.PlayerVigour=Apawn.vigour;
//    HUD.PlayerAmmo=Apawn.Ammo;
//

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
//
// Simulated event postbeginPlay()
// {
//  local ArenaFreeForAll FreeForAllGameMode;
//
//  super.PostBeginPlay();
//  FreeForAllGameMode=ArenaFreeForAll(WorldInfo.Game);
//  FreeForAllGameMode.Debuger();
//  settimer(1,false,'SpawnersVariableDeclaration');
// }


defaultproperties

{
}
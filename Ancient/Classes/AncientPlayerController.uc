class AncientPlayerController Extends SimplePC;
//reference to the HUD for Cntrolling Purposes
var AncientHud HUD;

//captureMouseInput
event PlayerTick( float DeltaTime )
{
    super.PlayerTick(DeltaTime);
}

//we override so we have 3 functions

function UpdateRotation(float DeltaTime)
{
    local AncientPawn APawn;

    super.UpdateRotation(DeltaTime);

    APawn = AncientPawn(self.Pawn);

    if (APawn != none)
    {
        APawn.CamPitch = Clamp(APawn.CamPitch + self.PlayerInput.aLookUp, -APawn.IsoCamAngle, APawn.IsoCamAngle);
    }
}

simulated event PostbeginPlay()
{
    AncientHud(myHUD).DrawHud();
    super.PostBeginPlay();
}

defaultproperties
{
}
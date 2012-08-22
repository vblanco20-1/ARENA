//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AncientWeapon extends UDKWeapon;

//In Construction
var bool bShouldstopFire;
var bool bMousePressed;

Simulated function StartFire(byte FireModeNum)
{
bMousePressed=true;
}



simulated function  StopFire(byte FireModeNum)
{
  super.StartFire(FireModeNum);

  bMousePressed=false;

  if (bShouldStopFire==true)
  {
   super.stopfire(fireModeNum);
  }
}

DefaultProperties
{
bShouldStopFire=false;
}
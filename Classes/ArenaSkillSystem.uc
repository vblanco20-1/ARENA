//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ArenaSkillSystem extends Actor;

//OHweaponvars
var int OneHandedWeaponSkilXp;
var int OneHandedWeaponSkilLevel;

//Raises The One Handed WeaponSkill
Function RaiseOneHandedWeaponSkill()
{
OneHandedWeaponSkilXp=OneHandedWeaponSkilXp+1;

if (OneHandedWeaponSkilXp==2)
{
 WorldInfo.game.broadcast(self,"youHaveLeveledup");
 OneHandedWeaponSkilLevel=OneHandedWeaponSkilLevel+1;
}
}


defaultproperties
{

}
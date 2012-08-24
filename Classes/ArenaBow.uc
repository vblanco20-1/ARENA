//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ArenaBow extends ArenaWeapon;

//overriding Training

 Simulated function StartFire(byte FireModeNum)
 {
  LoadBow();
 super.startfire(FireModeNum);

 }

  Simulated function StopFire(byte FireModeNum)
 {
 FireBow();
 super.stopfire(FireModeNum);
 GoToIdle();
 }

 Function LoadBow()
 {
 ArenaPawn(owner).halfBodyUp.PlayCustomAnim('LoadBow',1.0,0.1,0.1,false,true,,60);
 }

 function FireBow()
 {
 ArenaPawn(owner).halfBodyUp.PlayCustomAnim('FireBow',1.0,0.1,0.1,false,true,,1);
 }

 function GoToIdle()
 {
 ArenaPawn(Owner).AncientBlend.SetActiveChild( 0, 0.0 );
 }
//Equipped?
simulated function TimeWeaponEquipping()
{

AttachWeaponTo( Instigator.mesh,'Rhand');
super.TimeWeaponEquipping();

}

//attach the weapon
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )

{

  mesh.SetShadowParent(ArenaPawn(Owner).mesh);
  mesh.SetLightEnvironment(ArenaPawn(Owner).LightEnvironment);

 MeshCpnt.AttachComponentToSocket(mesh,SocketName);
}

 simulated function DetachWeapon()
 {

  mesh.DetachFromAny();

 }

simulated function TimeWeaponPutDown()
{

DetachWeapon();
super.TimeWeaponPutDown();

}
//Sets The Position of the Weapon
simulated event SetPosition(UDKPawn Holder)
{

 local SkeletalMeshComponent compo;
 local SkeletalMeshSocket socket;
 local Vector FinalLocation;

 compo = Holder.mesh;
 if (compo != none)

 {
   socket = compo.GetSocketByName('Rhand');
    if (socket != none)
   {
     FinalLocation = compo.GetBoneLocation(socket.BoneName);
   }
 }
  SetLocation(FinalLocation);
}





//gets the phisical loc for the weapon

simulated event vector GetPhysicalFireStartLoc(optional vector AimDir)
{

 local SkeletalMeshComponent compo;
 local SkeletalMeshSocket socket;
 compo = SkeletalMeshComponent(mesh);

 if (compo != none)
 {

 socket = compo.GetSocketByName('BowMiddle');
 if (socket != none)
 {
 return compo.GetBoneLocation(socket.BoneName);
 }
 }

}

DefaultProperties
{
//ArrowArchetype=ArenaArrow'AncientContent.Archetypes.ArrowArch'


Begin Object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
bEnabled=TRUE
End Object
Components.Add(MyLightEnvironment)


Begin Object   class=SkeletalMeshComponent name=BowMesh
SkeletalMesh=SkeletalMesh'AncientContent.Bow'
HiddenGame=false
HiddenEditor=FALSE
end object
mesh=BowMesh
Components.Add(BowMesh)

InstantHitDamage(0)=25
FiringStatesArray(0)=WeaponFiring
WeaponFireTypes(0)=EWFT_Projectile
FireInterval(0)=0.5
Spread(0)=0
WeaponProjectiles(0)=class 'Arena.ArenaArrow'

bShouldStopFire=true
}
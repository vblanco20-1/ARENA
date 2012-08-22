class AncientMeleeWeapon Extends Weapon Placeable;

//lastMovement s
var string LastMovement;
var string LastStance;

//game Vars
var bool bIsLoadAttack;
var bool bIsInstantAttack;
var bool bLMousePressed;
var bool bRMousePressed;
var bool bAmmofired;
var bool bCanAttack;
var bool bCanLoadAttack;


//LoadAttackbool
var bool bLoadAttack;

//TheSeockets for the trace
var() const name SwordHiltSocketName;
var() const name SwordTipSocketName;

//shield variable
var archetype AncientShield ShieldArchetype;
var bool bIsDefending;

//The Hit Actors Global Variable +
var Actor AttackedActor;

//train anim var
var() const name SwordAnimationName;


//Important Assets for variables
var array<Actor> SwingHitActors;
var array<int> Swings;
var const int MaxSwings;

//The sound variable
var() const SoundCue SwordClank;

//timer for the charged attack
var() float ChargeTime;
var bool bIsAttacking;

var bool bAttackCancel ;


//tick Funct

simulated event Tick(float DeltaTime)
{

}


//////////////////////input stuff/////////////////////////////
////////////////////////////////////////////////////////////////////////////



 //mouse left pressed
 Simulated Function StartFire(byte FireModeNum)
{


    if(FireModeNum==1)
    {
        Defend();
        bRMousePressed=true;
    }


    if(FireModeNum==0)
    {
        bLMousePressed=true;
        if(bIsAttacking==false)
        {
            StartCharge();
            `log("startfire");
            StopDefend();
        }
    }
    bIsAttacking=false;

 }

 //mouse  released
Simulated Function StopFire(byte FireModeNum)
{
    //rightButton
    if(FireModeNum==1)
    {
        StopDefend();
        bRMousePressed=false;
    }

    //LeftButton
    if(FireModeNum==0)
    {

        if(!bIsAttacking && bLMousePressed)
        {
            bAttackCancel=true;
            FastAttack();
        }
        bLMousePressed=false;
    }
}

//mouse right pressed
Simulated function Defend()
{
    if(bIsAttacking==false)
    {
    AncientPawn(Owner).AncientBlend.SetActiveChild( 3, 0.14 );
    bIsDefending=true;
    bIsAttacking=false;
    }


    //shield code here
}


//mouse right released
Simulated function StopDefend()
{
//shield code here
     bIsDefending=false;
     AncientPawn(Owner).AncientBlend.SetActiveChild( 0, 0.15 );
     AncientPawn(owner).defend(false);
}


////////Fight Logic And COmbos/////////////////////////
///////////////////////////////////////////////////////


//the fast light attack
function FastAttack()
{    `log("fastattack");
    super.StartFire(0);
    AncientPawn(owner).halfBodyUp.PlayCustomAnim('AttackThurst',1.0,0.1,0.1,false,true);
    AncientPawn(Owner).AncientBlend.SetActiveChild( 0, 0.15 );
    SetTimer(GetFireInterval(0), false, nameof(ResetSwings));
    SetTimer(GetFireInterval(0), false,nameof(EndAttack));
    bIsAttacking=true;
}
function EndAttack()
{
     bIsAttacking=false;
}
//the heavy Charged Attack
function HeavyAttack()
{   `log("HVATT");
    super.StartFire(1);
    AncientPawn(owner).halfBodyUp.PlayCustomAnim('AttackUp',1.0,0.1,0.1,false,true);
    AncientPawn(Owner).AncientBlend.SetActiveChild( 0, 0.15 );
    SetTimer(GetFireInterval(1), false, nameof(ResetSwings));
    SetTimer(GetFireInterval(1), false, nameof(EndAttack));
    bIsAttacking=true;
}



//timer stuff for the charged attack

function StartCharge()
{   `log("chargin");
    SetTimer(ChargeTime,false,'ChargeEnd');
    bAttackCancel=false;
    AncientPawn(Owner).AncientBlend.SetActiveChild( 1, 0.15 );

}



function ChargeEnd()
{    `log("chargin end");
    //in the case we have done a fast attack
    if(!bAttackCancel)
    {
        HeavyAttack();
    }
}

//////////////////////////////WeaponGivenFunctionality/////////////////////////////
//////////// ////////////////////////////////////////////////////////////////

//detects When the Weapon was equipped
simulated function TimeWeaponEquipping()
{

    AttachWeaponTo( Instigator.mesh,'Rhand');
    super.TimeWeaponEquipping();

}

//Attaches the Weapon to the Pawn
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
    mesh.SetShadowParent(AncientPawn(Owner).mesh);
    mesh.SetLightEnvironment(AncientPawn(Owner).LightEnvironment);
    MeshCpnt.AttachComponentToSocket(mesh,SocketName);
}

 //detach the weapon from the Pawn
simulated function DetachWeapon()
{
    mesh.DetachFromAny();
}

//Detects When Weapon it's putted down
simulated function TimeWeaponPutDown()
{
DetachWeapon();
super.TimeWeaponPutDown();
}



//////////////////////////////WeaponAttackFunctionality/////////////////////////////
////////////////////////////////////////////////////////////////////////////
function Vector GetSwordSocketLocation(Name SocketName)
{
   local Vector SocketLocation;
   local Rotator SwordRotation;
   local SkeletalMeshComponent SMC;

   SMC = SkeletalMeshComponent(Mesh);

   if (SMC != none && SMC.GetSocketByName(SocketName) != none)
   {
      SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
   }

   return SocketLocation;
}

//function that adds the actors to the swing
function bool AddToSwingHitActors(Actor HitActor)
{
   local int i;

   for (i = 0; i < SwingHitActors.Length; i++)
   {

      if (SwingHitActors[i] == HitActor)
      {
         return false;
      }
   }

   SwingHitActors.AddItem(HitActor);
   return true;
}


//the function that traces the swing
function TraceSwing()
{
   local Actor HitActor;
   local Vector HitLoc, HitNorm, SwordTip, SwordHilt, Momentum;
   local int DamageAmount;



   SwordTip = GetSwordSocketLocation(SwordTipSocketName);
   SwordHilt = GetSwordSocketLocation(SwordHiltSocketName);
   DamageAmount = FCeil(InstantHitDamage[CurrentFireMode]);

   foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, SwordTip, SwordHilt)
   {

      AttackedActor=HitActor;
      if (HitActor != self && AddToSwingHitActors(HitActor))
      {
         Momentum = Normal(SwordTip - SwordHilt) * InstantHitMomentum[CurrentFireMode];
         HitActor.TakeDamage(DamageAmount, Instigator.Controller, HitLoc, Momentum, class'DamageType');


        if(HitActor.class!=class'StaticMeshActor')
         {
         PlaySound(SwordClank);
         WorldInfo.Game.Broadcast(self,HitActor.class);}
      }
   }
}

//restores the ammo if its spent by consumeAmmo() )
function RestoreAmmo(int Amount, optional byte FireModeNum)
{
   Swings[FireModeNum] = Min(Amount, MaxSwings);

}

//Function Go to idle Again
function GoToIdleAgain()
{
 AncientPawn(Owner).AncientBlend.SetActiveChild( 0, 0.0 );

}
//Consumes Ammo , so swings gets reduced
function ConsumeAmmo(byte FireModeNum)
{
   if (HasAmmo(FireModeNum))
   {
      Swings[FireModeNum]--;
   }
}

//How Many ammo?
simulated function bool HasAmmo(byte FireModeNum, optional int Ammount)
{

   return Swings[FireModeNum] > Ammount;
}


//so player swings with a click
simulated function FireAmmunition()
{


}


// override state to get funct and do it weapoon firing
simulated state Swinging extends WeaponFiring
{
   simulated event Tick(float DeltaTime)
   {

      super.Tick(DeltaTime);
      TraceSwing();

   }

   simulated event EndState(Name NextStateName)
   {
      super.EndState(NextStateName);

   }
}




//resets the swings
function ResetSwings()
{
//WorldInfo.Game.Broadcast(self,"SwingReset");
   RestoreAmmo(MaxSwings);
   SwingHitActors.Remove(0,SwingHitActors.Length);
}

DefaultProperties
{

ShieldArchetype=AncientShield'Ancientcontent.Archetypes.SimpleShieldC'

 MaxSwings=2
 Swings(0)=2

  bCanAttack=false;
  bMeleeWeapon=true;
  bInstantHit=true;
  bCanThrow=false;

   FiringStatesArray(0)="Swinging"
   WeaponFireTypes(0)=EWFT_Custom
   InstantHitDamage(0)=50;
   InstantHitDamage(1)=100;

  bcanLoadAttack=true


    Begin Object class=SkeletalMeshComponent Name=SwordSkeletalMeshComponent

       CollideActors=true
       bCacheAnimSequenceNodes=false
       AlwaysLoadOnClient=true
       AlwaysLoadOnServer=true
       CastShadow=true
       BlockRigidBody=true
       bUpdateSkelWhenNotRendered=false
       bIgnoreControllersWhenNotRendered=true
       bUpdateKinematicBonesFromAnimation=true
       bCastDynamicShadow=true
       RBChannel=RBCC_Untitled3
       RBCollideWithChannels=(Untitled3=true)
       bOverrideAttachmentOwnerVisibility=true
       bAcceptsDynamicDecals=false
       bHasPhysicsAssetInstance=true
       TickGroup=TG_PreAsyncWork
       MinDistFactorForKinematicUpdate=0.2f
       bChartDistanceFactor=true
       RBDominanceGroup=20
       scale=1.f
       bAllowAmbientOcclusion=false
       bUseOnePassLightingOnTranslucency=true
       bPerBoneMotionBlur=true

    End Object
    AttackedActor=none



    bBlockActors=true
    bHidden=false
    CollisionComponent=SwordSkeletalMeshComponent
    Components.Add(SwordSkeletalMeshComponent)
    mesh=SwordSkeletalMeshComponent
}
class ArenaPawn extends Pawn PlaceAble;

//PawnLifevariables
var int vigour;
var int ActualHealth;
var int Ammo;

//Shield
var archetype ArenaShield ShieldArchetype;
var archetype ArenaOneHandedMeleeWeapon OneHandedWeaponArchetype;


//TeamNumber, defines what team he is , so he knows who attack and who to not default is 0
//1 = blue
//2 = Red     //Can add more
//3 = Green
//4 = purple
var int TeamNumber;

//PawnLastMouseMovement
var string LastPawnMovement;


//PC
var ArenaPlayerController PC;

//Blood variable
var EmitterSpawnable Blood;


//skill System
var ArenaSkillSystem Skills;

//Random Array
var Array<Int> Numbers;
var int AttackNumber;

 //Camera variables
var() const DynamicLightEnvironmentComponent LightEnvironment;
var() const int IsoCamAngle;
var() const float CamOffsetDistance;
var float CamPitch;




//Socket variable
var() const Name RightHandSocketName;
var() const Name LeftHandSocketName;


//Animations Variables

var AnimNodePlayCustomAnim SwingAnimRight;
var AnimNodeBlendList AncientBlend;
var AnimNodeSlot HalfBodyUp;
var AnimNodeSlot FullBody;

var bool bIsdefending;

//So can call other actions
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if(!bIsDefending)
    {
     SpawnBlood();
     SlowThePawn();
     SetTimer(2,false,'RestoreSpeed');
     halfBodyUp.PlayCustomAnim('GotHurt',1.0,0.1,0.1,false,true);
     super.takeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
    }
    else
      WorldInfo.Game.Broadcast(self,"BLOCKED");
    if(health<=0)
    {
        Died(InstigatedBy,DamageType,location);
        WorldInfo.Game.Broadcast(self,"KILLME");
        Controller.Detach(self);
    }
    WorldInfo.Game.Broadcast(self,Damage);


    if(ArenaAIController(Controller) != none)
    {
       ArenaAIController(Controller).SetTarget(InstigatedBy.Pawn);
    }
}

  //slows the pawn when taking damage
 function SlowThePawn()
 {
 GroundSpeed=100;
 }
 function defend(bool bdefend)
 {
      bIsdefending=bdefend;
 }
  function RestoreSpeed()
 {
 GroundSpeed=200;
 }

// state Hurt
 //{

// GroundSpeed=50;
// bCanJump=false;
// }

//function that spawns blood
function SpawnBlood()
{
    Blood = Spawn(class'EmitterSpawnable',,, Location, );
    Blood.bDestroyOnSystemFinish = false;
    Blood.Lifespan = 10;
    Blood.SetTemplate(ParticleSystem'Blood.BloodThere');
    Blood.SetHidden(false);
}



//shieldProtection
exec Function ShieldProtection()
 {
  WorldInfo.game.Broadcast(self,"ShieldInfront");
  AncientBlend.SetActiveChild( 5, 0.35 );
 }
 //shieldUnProtection
 exec Function NoShieldProtection()
 {
  WorldInfo.game.Broadcast(self,"ShieldNotInfront");
  AncientBlend.SetActiveChild( 0, 0.35 );
 }


//Enter In ragdoll , (IncludeRagdoll whle running also for Gore)
simulated function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
  if (Super.Died(Killer, DamageType, HitLocation))
  {
    Mesh.MinDistFactorForKinematicUpdate = 0.f;
    Mesh.SetRBChannel(RBCC_Pawn);
    Mesh.SetRBCollidesWithChannel(RBCC_Default, true);
    Mesh.SetRBCollidesWithChannel(RBCC_Pawn, false);
    Mesh.SetRBCollidesWithChannel(RBCC_Vehicle, false);
    Mesh.SetRBCollidesWithChannel(RBCC_Untitled3, false);
    Mesh.SetRBCollidesWithChannel(RBCC_BlockingVolume, true);
    mesh.ForceSkelUpdate();
    Mesh.SetTickGroup(TG_PostAsyncWork);
    CollisionComponent = Mesh;
    CylinderComponent.SetActorCollision(false, false);
    Mesh.SetActorCollision(true, false);
    Mesh.SetTraceBlocking(true, true);
    SetPhysics(PHYS_RigidBody);
    Mesh.PhysicsWeight = 1.0;

    if (Mesh.bNotUpdatingKinematicDueToDistance)
    {
      Mesh.UpdateRBBonesFromSpaceBases(true, true);
    }

    Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
    Mesh.bUpdateKinematicBonesFromAnimation = false;
    Mesh.SetRBLinearVelocity(Velocity, false);
    Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
    Mesh.SetNotifyRigidBodyCollision(true);
    Mesh.WakeRigidBody();

    return true;
  }

  return false;
}




//Add The default inventory to the pawn
function AddDefaultInventory()
{

  local ArenaInventorymanager AInventoryManager;
   AInventoryManager = ArenaInventorymanager(self.InvManager);


   AInventoryManager.CreateInventoryArchetype(OneHandedWeaponArchetype, false);
   //AInventoryManager.CreateInventory(class'Ancient.AncientOneHandedMeleeWeapon');
   //AInventoryManager.CreateInventory(class'Arena.ArenaBow');

}

//Start Anim tree
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    super.PostInitAnimTree(SkelComp);


    if (SkelComp == Mesh)
    {

        SwingAnimRight= AnimNodePlayCustomAnim(SkelComp.FindAnimNode('SwingAnimationRight'));

        FullBody=AnimNodeSlot(SkelComp.FindAnimNode('FullBody'));

        HalfBodyUp=AnimNodeSlot(SkelComp.FindAnimNode('HalfBodyUp'));



        AncientBlend= AnimNodeBlendList(SkelComp.FindAnimNode('AncientBlend'));


    }
}


//Camera Calculation
simulated function bool CalcCamera(float DeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
    local Vector HitLocation, HitNormal;

    out_CamLoc = Location;
    out_CamLoc.X -= Cos(Rotation.Yaw * UnrRotToRad) * Cos(CamPitch * UnrRotToRad) * CamOffsetDistance;
    out_CamLoc.Y -= Sin(Rotation.Yaw * UnrRotToRad) * Cos(CamPitch * UnrRotToRad) * CamOffsetDistance;
    out_CamLoc.Z -= Sin(CamPitch * UnrRotToRad) * CamOffsetDistance;

    out_CamRot.Yaw = Rotation.Yaw;
    out_CamRot.Pitch = CamPitch;
    out_CamRot.Roll = 0;

    if (Trace(HitLocation, HitNormal, out_CamLoc, Location, false, vect(12, 12, 12)) != none)
    {
        out_CamLoc = HitLocation;
    }

    return true;
}

//Add the deafault inv for the AI pawn
event PostBeginPlay()
{
 bIsdefending=false;
Skills=Spawn(class'Arena.ArenaSkillSystem');

PC = ArenaPlayerController(controller);


  super.PostBeginPlay();
  AddDefaultInventory();


}

//Function add Shield
function AddShield()
{
local Vector SocketLocation;
local Rotator SocketRotation;
local Actor ArenaShield;

   if (mesh != None)
{
  if (ShieldArchetype != None && mesh.GetSocketByName(LeftHandSocketName) != None)
  {
 mesh.GetSocketWorldLocationAndRotation(LeftHandSocketName, SocketLocation, SocketRotation);

    ArenaShield = Spawn(ShieldArchetype.class,,, SocketLocation, SocketRotation, shieldArchetype);

    if (ArenaShield != None)
    {
      ArenaShield.SetBase(self,, mesh, lefthandsocketname);
    }
  }
}

}



DefaultProperties
{




    InventoryManagerClass=class'ArenaInventoryManager'

     OneHandedWeaponArchetype=ArenaOneHandedMeleeWeapon'ArenaContent.Archetypes.StickSword'
    //ShieldArchetype=ArenaShield'AncientContent.Archetypes.SimpleShieldC'
    //BowArchetype=Arenabow'AncientContent.Archetypes.SimpleBow'


    Components.Remove(Sprite)

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
       bSynthesizeSHLight=true
       bIsCharacterLightEnvironment=true
       bUseBooleanEnvironmentShadowing=false
    End Object
    Components.Add(MyLightEnvironment)
    LightEnvironment=MyLightEnvironment

    Begin Object Class=SkeletalMeshComponent Name=MySkeletalMeshComponent
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
       LightEnvironment=MyLightEnvironment
       bOverrideAttachmentOwnerVisibility=true
       bAcceptsDynamicDecals=false
       bHasPhysicsAssetInstance=true
       TickGroup=TG_PreAsyncWork
       MinDistFactorForKinematicUpdate=0.2f
       bChartDistanceFactor=true
       RBDominanceGroup=20
       Scale=1.f
       bAllowAmbientOcclusion=false
       bUseOnePassLightingOnTranslucency=true
       bPerBoneMotionBlur=true
    End Object
    Mesh=MySkeletalMeshComponent
    Components.Add(MySkeletalMeshComponent)

   GroundSpeed=250
   controllerClass=class'Arena.ArenaAIController'
   bCanBeBaseForPawns=false

    Numbers(0)=1
    Numbers(1)=2
    Numbers(2)=3
    Numbers(3)=4

   //gameVars
   Vigour=100
}
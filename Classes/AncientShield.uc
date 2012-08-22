//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AncientShield extends Actor placeable;

DefaultProperties
{


  Begin Object class=SkeletalMeshComponent Name=ShieldSkeletalMeshComponent

  SkeletalMesh=SkeletalMesh'AncientContent.SimpleShield'

  End Object

  CollisionComponent=ShieldSkeletalMeshComponent
  Components.Add(ShieldSkeletalMeshComponent)


  bBlockActors=false



  bHidden=false

}
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AncientArrow extends UDKProjectile Placeable;




DefaultProperties
{



 Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
 bEnabled=TRUE
 End Object
 Components.Add(MyLightEnvironment)

 begin object class=StaticMeshComponent Name=BaseMesh
 LightEnvironment=MyLightEnvironment

 StaticMesh=StaticMesh'AncientContent.Arrow'
 end object


 Components.Add(BaseMesh)


speed=1000
}
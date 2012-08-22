//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AncientAIPacificController extends AIcontroller;

var Pawn player;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
  super.Possess(inPawn, bVehicleTransition);
  //initialize Pawn Physics
  inPawn.SetMovementPhysics();
}



DefaultProperties
{

}
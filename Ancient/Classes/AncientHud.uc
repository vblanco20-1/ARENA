//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AncientHud extends MobileHUD;


function DrawHud()

{



Canvas.SetPos(Canvas.ClipX/2,Canvas.ClipY/2);

Canvas.SetDrawColor(255,255,255,255);

Canvas.Font = class'Engine'.static.GetMediumFont();

Canvas.DrawText("X");
super.DrawHUD();

}
simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    DrawHud();
   WorldInfo.game.Broadcast(self,"DarwingHud");
}
event PostRender()
{
    super.PostRender();
     DrawHud();


}
DefaultProperties
{

}
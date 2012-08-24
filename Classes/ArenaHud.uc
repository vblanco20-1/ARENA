//-----------------------------------------------------------
//
//-----------------------------------------------------------

class ArenaHud extends HUD;

//Vigour
var int PlayerVigour;
Var int PlayerHealth;
var int PlayerAmmo;


function DrawHealth()
{
Canvas.SetPos(80,200);
Canvas.SetDrawColor(0,255,0,200);
Canvas.Font = class'Engine'.static.GetMediumFont();
Canvas.DrawText(PlayerHealth);
}


function DrawVigour()
{
Canvas.SetPos(80,170);
Canvas.SetDrawColor(0,0,255,255);
Canvas.Font = class'Engine'.static.GetMediumFont();
Canvas.DrawText(PlayerVigour);
}





event PostRender()
{
	super.PostRender();
    DrawHealth();
    DrawVigour();

}
DefaultProperties
{

}
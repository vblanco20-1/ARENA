//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GFxSCLCommunicationTest extends GFxMoviePlayer;

var GFxObject MainMenuTitle;

var string string1;
var GFxObject root;

function bool start (optional bool StartPaused = false)
{

super.start();
Advance(0);




MainMenuTitle= GetVariableObject("_root.textField");
MainMenuTitle.SetText("helloWorld");


root=GetVariableObject("_root");
string1 = root.GetString("MyString");

MainMenuTitle.SetText(string1);
return true;
}

DefaultProperties
{

}



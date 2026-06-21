import funkin.modding.module.Module;
import Std;
import funkin.ui.options.OptionsState;
import flixel.FlxG;
import funkin.play.PlayState;
import Type;
import funkin.util.ReflectUtil;
import funkin.util.Constants;
import funkin.play.character.CharacterDataParser;
import funkin.play.character.BaseCharacter;
import funkin.ui.PixelatedIcon;
import funkin.ui.freeplay.SongMenuItem;
import funkin.ui.freeplay.FreeplayState;
import funkin.PlayerSettings;
import flixel.util.FlxTimer;
import funkin.save.Save;

class CustomFreeplayOptions extends Module
{
	public var dynamicBG:Bool = true;
	var curSelected:Int;

	public function new(){
		super("CustomFreeplayOptions", 1);

		if (Save.instance.modOptions["dynamicBG"] == null) Save.instance.modOptions["dynamicBG"] = true;

		dynamicBG = Save.instance.modOptions["dynamicBG"];
	}

	public var inOptions:Bool = false;

	override function onStateChangeEnd(event){
		super.onStateChangeEnd(event);
		inOptions = false;
		if(Std.isOfType(event.targetState, OptionsState)){
			var prefs = event.targetState.optionsCodex.pages.get("preferences");
			inOptions = true;

            prefs.createPrefItemCheckbox("Dynamic Freeplay BG", "Toggles the dynamic freeplay backgrounds. (Not the colors)", function(value) {
                Save.instance.modOptions["dynamicBG"] = value;
                dynamicBG = value;
                Save.instance.flush();
            }, Save.instance.modOptions["dynamicBG"]);
		}
	}
}

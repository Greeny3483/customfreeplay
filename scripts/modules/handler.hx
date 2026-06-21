import funkin.modding.events.ScriptEvent;
import funkin.modding.module.Module;
import funkin.play.PlayState;
import funkin.modding.module.ModuleHandler;
import funkin.graphics.FunkinSprite;
import funkin.Paths;
import flixel.util.FlxTimer;
import funkin.Assets;

import funkin.modding.PolymodErrorHandler;
import funkin.modding.PolymodHandler;
import funkin.Conductor;
import funkin.graphics.video.FunkinVideoSprite;
import funkin.play.Countdown;
import funkin.data.event.SongEventRegistry;
import funkin.data.song.SongEventDataRaw;
import funkin.modding.events.SongEventScriptEvent;
import haxe.Json;
import flixel.FlxG;
import funkin.save.Save;
import funkin.Preferences;
import funkin.util.Constants;
import funkin.ui.freeplay.FreeplayState;

import flixel.util.FlxColor;

class Ahem extends Module {
    public var jsonPath; // looks for the json file in the data folder
    public var jsonData:Dynamic; // Shortcut for Json.parse(Assets.getText(jsonPath))
    var targetPink:FlxColor = 0xFFFFD863;
    var targetMoreWays:FlxColor = 0xFFFFFFFF;
    var targetFunnyScroll:FlxColor = 0xFFFFFFFF;
    var targetFunnyScroll2:FlxColor = 0xFFFFFFFF;
    var targetFunnyScroll3:FlxColor = 0xFFFFA806;
    var targetOrange:FlxColor = 0xFFFEDA00;
    var currentOrange:FlxColor = 0xFFFEDA00;

    public static var songColors:Map<String, FlxColor> = [
        "bopeebo" => 0xFFAF66CE,
        "fresh" => 0xFFAF66CE,
        "dadbattle" => 0xFFAF66CE,
        "spookeez" => 0xFFD57E00,
        "south" => 0xFFD57E00,
        "monster" => 0xFFB50012,
        "pico" => 0xFFB7D855,
        "philly-nice" => 0xFFB7D855,
        "blammed" => 0xFFB7D855,
        "satin-panties" => 0xFFD8558E,
        "high" => 0xFFD8558E,
        "milf" => 0xFFD8558E,
        "cocoa" => 0xFFA5004D,
        "eggnog" => 0xFFA5004D,
        "winter-horrorland" => 0xFFB50012,
        "senpai" => 0xFFFFAA6F,
        "roses" => 0xFFFFAA6F,
        "thorns" => 0xFFFF3C6E,
        "ugh" => 0xFFE1E1E1,
        "guns" => 0xFFE1E1E1,
        "stress" => 0xFFE1E1E1,
        "darnell" => 0xFF5A456C,
        "lit-up" => 0xFF5A456C,
        "2hot" => 0xFF5A456C,
        "blazin" => 0xFF5A456C
    ];

    /*
     * JSON file look:
     {
     "songs": [
        {
            "songName": "",
            "color": "",
            "image": ""
        }
     ]
     }
     */

    function new() {
        super("ScopedModule_MainmenuState", 30, {state: FreeplayState});
        jsonPath = Paths.json("ahem");
        if (Assets.exists(jsonPath)) {
            jsonData = Json.parse(Assets.getText(jsonPath));
        }
    }

    //function getConfigForCurrentSong():Dynamic {
    //    for (cfg in songsConfig) {
    //        if (cfg.songName == FreeplayState.FreeplaySongData.instance.currentChart.songName || cfg.songName == PlayState.instance.currentSong.id) {
    //            return cfg; // checks whether songName is the song's in-game name/title or the song's internal name
    //        }
    //    }
    //    return;
    //}

    //override function onStateChangeEnd() {

    //}

    override function onCapsuleSelected(event:CapsuleScriptEvent):Void {
        super.onCapsuleSelected(event);
        if (event.capsule == null || event.capsule.freeplayData == null) return;
        var songId = event.capsule.freeplayData.songId;
        var baseColor:FlxColor = 0xFFFFD863;

        for (song in jsonData.songs) {
            if (song.songName == event.capsule.freeplayData.songId || song.songName == event.capsule.freeplayData.songId) {
                baseColor = song.color;
                break;
            }
        }

        targetPink = baseColor;
        targetMoreWays = FlxColor.interpolate(baseColor, FlxColor.WHITE, 0.6);

        targetFunnyScroll = FlxColor.interpolate(baseColor, FlxColor.WHITE, 0.2);

        if (baseColor.lightness > 0.6) targetFunnyScroll2 = FlxColor.interpolate(baseColor, FlxColor.BLACK, 0.55);
        else targetFunnyScroll2 = FlxColor.interpolate(baseColor, FlxColor.WHITE, 0.6);

        targetFunnyScroll3 = FlxColor.interpolate(baseColor, FlxColor.BLACK, 0.4);
        targetOrange = FlxColor.interpolate(baseColor, FlxColor.BLACK, 0.2);
    }
}

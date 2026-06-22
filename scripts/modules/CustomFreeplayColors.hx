import funkin.modding.module.Module;
import funkin.graphics.FunkinSprite;

import funkin.modding.PolymodErrorHandler;
import haxe.Json;
import flixel.FlxG;
import funkin.ui.freeplay.FreeplayState;

import flixel.util.FlxColor;

class CustomFreeplayColors extends Module {
    static var jsonPath;
    static var jsonData:Dynamic;
    static var songsArray:Array;

    var targetPink:FlxColor = 0xFFFFD863;
    var targetMoreWays:FlxColor = 0xFFFFFFFF;
    var targetFunnyScroll:FlxColor = 0xFFFFFFFF;
    var targetFunnyScroll2:FlxColor = 0xFFFFFFFF;
    var targetFunnyScroll3:FlxColor = 0xFFFFA806;
    var targetOrange:FlxColor = 0xFFFEDA00;
    var currentOrange:FlxColor = 0xFFFEDA00;

    function new() {
        super("customFreeplayColors", 30, {state: FreeplayState});
        jsonPath = Paths.json("ahem");
        if (Assets.exists(jsonPath)) {
            jsonData = Json.parse(Assets.getText(jsonPath));
        }
    }

    override function onCapsuleSelected(event:CapsuleScriptEvent):Void {
        super.onCapsuleSelected(event);
        if (event.capsule == null || event.capsule.freeplayData == null) return;
        if (jsonData == null) return;

        var songId = event.capsule.freeplayData.songId;
        var songTitle = event.capsule.freeplayData.data.songName;
        var baseColor:FlxColor = FlxColor.fromString("#FFFFD863");

        for (songs in jsonData.songs) {
            songsArray = songs.songNames;
            for (curSong in songsArray) {
                if (songsArray.contains(songId) || songsArray.contains(songTitle)) {
                    // Song's title doesn't work so...
                    // TODO: Support variations
                    baseColor = FlxColor.fromString(songs.color);
                }
            }
        }

        targetPink = baseColor;
        targetMoreWays = FlxColor.interpolate(baseColor, FlxColor.WHITE, 0.6);

        targetFunnyScroll = FlxColor.interpolate(baseColor, FlxColor.WHITE, 0.2);

        if (baseColor?.lightness > 0.6) targetFunnyScroll2 = FlxColor.interpolate(baseColor, FlxColor.BLACK, 0.55);
        else targetFunnyScroll2 = FlxColor.interpolate(baseColor, FlxColor.WHITE, 0.6);

        targetFunnyScroll3 = FlxColor.interpolate(baseColor, FlxColor.BLACK, 0.4);
        targetOrange = FlxColor.interpolate(baseColor, FlxColor.BLACK, 0.2);
    }

    override function onUpdate(event:UpdateScriptEvent):Void {
        super.onUpdate(event);
        if (FlxG.state.subState == null || FlxG.state.subState.backingCard == null) return;

        var card = FlxG.state.subState.backingCard;
        var lerpSpeed:Float = event.elapsed * 6.0;

        try {
            if (card.pinkBack != null) {
                card.pinkBack.color = FlxColor.interpolate(card.pinkBack.color, targetPink, lerpSpeed);
            }
        } catch(e:Dynamic) {}

        try {
            if (card.moreWays != null) {
                var startColor = card.moreWays.funnyColor != null ? card.moreWays.funnyColor : FlxColor.WHITE;
                card.moreWays.funnyColor = FlxColor.interpolate(startColor, targetMoreWays, lerpSpeed);
            }
        } catch(e:Dynamic) {}

        try {
            if (card.moreWays2 != null) {
                var startColor2 = card.moreWays2.funnyColor != null ? card.moreWays2.funnyColor : FlxColor.WHITE;
                card.moreWays2.funnyColor = FlxColor.interpolate(startColor2, targetMoreWays, lerpSpeed);
            }
        } catch(e:Dynamic) {}

        try {
            if (card.funnyScroll != null) {
                var scrollStart = card.funnyScroll.funnyColor != null ? card.funnyScroll.funnyColor : FlxColor.WHITE;
                card.funnyScroll.funnyColor = FlxColor.interpolate(scrollStart, targetFunnyScroll, lerpSpeed);
            }
        } catch(e:Dynamic) {}

        try {
            if (card.funnyScroll2 != null) {
                var scrollStart2 = card.funnyScroll2.funnyColor != null ? card.funnyScroll2.funnyColor : FlxColor.WHITE;
                card.funnyScroll2.funnyColor = FlxColor.interpolate(scrollStart2, targetFunnyScroll2, lerpSpeed);
            }
        } catch(e:Dynamic) {}

        try {
            if (card.funnyScroll3 != null) {
                var scrollStart3 = card.funnyScroll3.funnyColor != null ? card.funnyScroll3.funnyColor : FlxColor.WHITE;
                card.funnyScroll3.funnyColor = FlxColor.interpolate(scrollStart3, targetFunnyScroll3, lerpSpeed);
            }
        } catch(e:Dynamic) {}

        try {
            if (currentOrange != targetOrange) {
                currentOrange = FlxColor.interpolate(currentOrange, targetOrange, lerpSpeed);
                if (card.orangeBackShit != null) {
                    var w = card.pinkBack != null ? Std.int(card.pinkBack.width) : 1280;
                    card.orangeBackShit.makeSolidColor(w, 75, currentOrange);
                }
                if (card.alsoOrangeLOL != null && card.orangeBackShit != null) {
                    card.alsoOrangeLOL.makeSolidColor(100, Std.int(card.orangeBackShit.height), currentOrange);
                }
            }
        } catch(e:Dynamic) {}
    }
}

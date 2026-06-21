import funkin.modding.events.ScriptEvent;
import funkin.modding.module.Module;
import funkin.play.PlayState;
import funkin.modding.module.ModuleHandler;
import funkin.graphics.FunkinSprite;
import flixel.util.FlxTimer;

import funkin.modding.PolymodErrorHandler;
import haxe.Json;
import flixel.FlxG;
import funkin.save.Save;
import funkin.Preferences;
import funkin.util.Constants;
import funkin.ui.freeplay.FreeplayState;
import flixel.FlxG;
import funkin.ui.freeplay.FreeplayState;
import funkin.modding.module.Module;
import openfl.utils.Assets;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import funkin.save.Save;

import flixel.util.FlxColor;

class CustomFreeplayBG extends Module {
    var currentBgName:String = "";
    var fadeSprite:FlxSprite = null;

    function new() {
        super("customFreeplayBG", 40, {state: FreeplayState});
        CustomFreeplayColors.jsonPath = Paths.json("freeplay-bg-color");
        if (Assets.exists(CustomFreeplayColors.jsonPath)) {
            CustomFreeplayColors.jsonData = Json.parse(Assets.getText(CustomFreeplayColors.jsonPath));
        }
    }

    override function onCapsuleSelected(event:CapsuleScriptEvent):Void {
        doDynamicBG = Save.instance.modOptions["dynamicBG"];
        if (!doDynamicBG || event.capsule == null || event.capsule.freeplayData == null || CustomFreeplayColors.jsonData == null) return;

        var songId = event.capsule.freeplayData.songId;
        var songTitle = event.capsule.freeplayData.data.songName;
        var targetBg = "freeplayBGweek1-bf";

        for (songs in CustomFreeplayColors.jsonData.songs) {
            CustomFreeplayColors.songsArray = songs.songNames;
            for (curSong in CustomFreeplayColors.songsArray) {
                if (CustomFreeplayColors.songsArray.contains(songId) || CustomFreeplayColors.songsArray.contains(songTitle)) {
                    targetBg = songs.image;
                    if (currentBgName != targetBg) {
                        var previousBg = currentBgName == "" ? "freeplayBGweek1-bf" : currentBgName;
                        currentBgName = targetBg;
                        updateBackground(targetBg, previousBg);
                        //new FlxTimer().start(2, function() {
                        //    updateBackground(targetBg, previousBg);
                        //});
                    }
                }
            }
        }
    }

    function updateBackground(newBg:String, oldBg:String):Void {
        var freeplayState = FlxG.state.subState;

        if (freeplayState == null || freeplayState.backingImage == null) return;

        if (fadeSprite != null) {
            FlxTween.cancelTweensOf(fadeSprite);
            freeplayState.remove(fadeSprite, true);
            fadeSprite.destroy();
        }

        fadeSprite = new FlxSprite(freeplayState.backingImage.x, freeplayState.backingImage.y);

        var oldPath = Paths.image('freeplay/' + oldBg);
        if (!Assets.exists(oldPath)) oldPath = Paths.image('freeplay/freeplayBGweek1-bf');
        fadeSprite.loadGraphic(oldPath);

        fadeSprite.scale.set(freeplayState.backingImage.scale.x, freeplayState.backingImage.scale.y);
        fadeSprite.updateHitbox();
        fadeSprite.scrollFactor.set(freeplayState.backingImage.scrollFactor.x, freeplayState.backingImage.scrollFactor.y);

        var bgIndex = freeplayState.members.indexOf(freeplayState.backingImage);
        if (bgIndex != -1) {
            freeplayState.insert(bgIndex + 1, fadeSprite);
        } else {
            freeplayState.add(fadeSprite);
        }

        FlxTween.tween(fadeSprite, {alpha: 0}, 0.35, {
            onComplete: function(twn:FlxTween) {
                if (fadeSprite != null) {
                    freeplayState.remove(fadeSprite, true);
                    fadeSprite.destroy();
                    fadeSprite = null;
                }
            }
        });

        var customPath = Paths.image('freeplay/' + newBg);
        if (Assets.exists(customPath)) {
            freeplayState.backingImage.loadGraphic(customPath);
        } else {
            var defaultPath = Paths.image('freeplay/freeplayBGweek1-bf');
            if (Assets.exists(defaultPath)) {
                freeplayState.backingImage.loadGraphic(defaultPath);
            }
        }
    }

}

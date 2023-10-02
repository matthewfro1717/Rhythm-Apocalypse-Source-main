package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;

using StringTools;

class ExtrasMenuState extends MusicBeatState
{
	public static var rhythmVersion:String = '1.5';
	public static var osEngineVersion:String = '1.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['credits', 'discord'];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Extras Menu... ", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('lololo'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
			{
				var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
				menuItem.scale.x = scale;
				menuItem.scale.y = scale;
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.x = -200;
				menuItems.add(menuItem);
				menuItem.scrollFactor.set();
				menuItem.antialiasing = ClientPrefs.globalAntialiasing;
				if (firstStart)
					FlxTween.tween(menuItem,{y: 60 + (i * 230)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{ 
							finishedFunnyMove = true; 
							changeItem();
						}});
				else
					menuItem.y = 60 + (i * 230);
			}
		
		var versionShit:FlxText = new FlxText(FlxG.width * 0.35, FlxG.height - 64, 0, "Apocalypse Engine v" + rhythmVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(FlxG.width * 0.35, FlxG.height - 44, 0, "OS Engine v" + osEngineVersion + " - Modded Psych Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(FlxG.width * 0.35, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var gradient:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('gradientwtf'));
		gradient.updateHitbox();
		gradient.alpha = 0.4;
		gradient.screenCenter();
		gradient.antialiasing = ClientPrefs.globalAntialiasing;
		add(gradient);

		firstStart = false;

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();
		
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
				{
					if (optionShit[curSelected] == 'discord')
					{
						CoolUtil.browserLoad('https://discord.gg/5REcWp9uaf');
					}
					
					if (optionShit[curSelected] == 'credits')
					{
						CoolUtil.browserLoad('https://docs.google.com/document/d/1dhzoaAr-h1OPn1VSWrE2LDbRm7NOS1QejnuGKItMAOM/edit?usp=sharing');
					}
				}
			}
			#if desktop
			if (FlxG.keys.justPressed.SEVEN)
			{
			  selectedSomethin = true;
			  MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
	
			super.update(elapsed);
	
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.screenCenter(X);
			});
		}
	function goToState()
		{
			var daChoice:String = optionShit[curSelected];
	
			switch (daChoice)
			{
				case 'awards':
					MusicBeatState.switchState(new AchievementsMenuState());
			}
		}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			spr.offset.y = 0;
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				spr.offset.x = 0.15 * (spr.frameWidth / 2 + 180);
				spr.offset.y = 0.15 * spr.frameHeight;
				FlxG.log.add(spr.frameWidth);
			}
		});
	}
}

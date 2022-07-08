#if debug
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// i freely update the sprite stuff as i offset more stuff
class OffsetState extends FlxState
{
	public var debugSprBG:CCSprite;
	public var debugSpr:CCSprite;

	// edit these; ghost is the bg, debug is the sprite you're offsetting
	public var ghostAnim:String = "idle1";
	public var debugIndex:Int = 1;

	public static var debugAnims:Array<String> = ['idle0-fred-alt','idle1-fred-alt','death-fred-alt'];

	public var debugAnim:String = debugAnims[1];

	public var debugPoint:FlxPoint;

	public var debugText:FlxText;

	public function getSpr(?x:Float = 0, ?y:Float = 0)
	{
		// feel free to edit the animations as you need
		var newSpr = new CCSprite(x, y, 'Characters');
		newSpr.addAnimIndices('idle0', 'Nicholas Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		newSpr.addAnimIndices('idle1', 'Nicholas Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		newSpr.addAnim('death', 'Nicholas zDead', false, new FlxPoint(7, 60));
		newSpr.addAnimIndices('idle0-alt', 'Phil Idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(0, 0));
		newSpr.addAnimIndices('idle1-alt', 'Phil Idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(0, 0));
		
		newSpr.addAnim('death-alt', 'Phil Vanishes', false, new FlxPoint(359, 61));

		newSpr.addAnimIndices('idle0-fred', 'fred idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(87, 17));
		newSpr.addAnimIndices('idle1-fred', 'fred idle', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(87, 17));
		
		newSpr.addAnimIndices('idle0-fred-alt', 'momazos diego', [0, 1, 2, 3, 4, 5, 6, 7, 8], false, new FlxPoint(40, -13));
		newSpr.addAnimIndices('idle1-fred-alt', 'momazos diego', [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], false, new FlxPoint(40, -13));

		newSpr.addAnim('death-fred-alt', 'momazos tween', false, new FlxPoint(15, -14));
		return newSpr;
	}

	override public function create()
	{
		super.create();

		// same bg i use in adobe animate
		FlxG.camera.bgColor = FlxColor.fromString("#999999");

		debugSprBG = getSpr();
		debugSprBG.screenCenter();
		debugSprBG.alpha = 0.5;

		debugSpr = getSpr(debugSprBG.x, debugSprBG.y);

		add(debugSprBG);
		add(debugSpr);

		debugSprBG.playAnim(ghostAnim, true);
		debugSpr.playAnim(debugAnim, true);

		debugPoint = debugSpr.animOffsets.get(debugAnim);

		debugText = new FlxText(20, 20, 0, '[?, ?]', 32, true);
		debugText.setFormat(Paths.font('FredokaOne-Regular'), 32, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		debugText.antialiasing = ClientSettings.antialiasing;
		add(debugText);
	}

	override public function update(e:Float)
	{
		super.update(e);

		var jp = FlxG.keys.justPressed;
		var amount = FlxG.keys.pressed.SHIFT ? 10 : 1;
		var ctrls = [jp.LEFT, jp.DOWN, jp.RIGHT, jp.UP, jp.SPACE, jp.ONE, jp.TWO, jp.THREE, jp.ESCAPE];
		for (i in 0...ctrls.length)
			if (ctrls[i])
				switch (i)
				{
					case 0:
						debugPoint.x += amount;
						debugSpr.offset.set(debugPoint.x, debugPoint.y);
					case 1:
						debugPoint.y -= amount;
						debugSpr.offset.set(debugPoint.x, debugPoint.y);
					case 2:
						debugPoint.x -= amount;
						debugSpr.offset.set(debugPoint.x, debugPoint.y);
					case 3:
						debugPoint.y += amount;
						debugSpr.offset.set(debugPoint.x, debugPoint.y);
					case 4:
						debugSpr.animOffsets.set(debugAnim, debugPoint);
						debugSpr.playAnim(debugAnim, true);
					case 5:
						debugSpr.animOffsets.set(debugAnim, debugPoint);
						debugIndex -= 1;
						if (debugIndex < 0)
							debugIndex = debugAnims.length - 1;
						debugAnim = debugAnims[debugIndex];
						debugPoint = debugSpr.animOffsets.get(debugAnim);
						debugSpr.playAnim(debugAnim, true);
					case 6:
						debugSpr.animOffsets.set(debugAnim, debugPoint);
						debugIndex += 1;
						if (debugIndex >= debugAnims.length)
							debugIndex = 0;
						debugAnim = debugAnims[debugIndex];
						debugPoint = debugSpr.animOffsets.get(debugAnim);
						debugSpr.playAnim(debugAnim, true);
					case 7 | 8:
						FlxG.switchState(new MenuState());
				}

		debugText.text = '$debugAnim: [${debugPoint.x}, ${debugPoint.y}]';
	}
}
#end

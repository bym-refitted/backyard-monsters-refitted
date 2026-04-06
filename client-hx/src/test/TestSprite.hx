package test;

import com.bymr.hxbridge.HaxeLib.LOGGER;
import openfl.text.TextField;
import openfl.display.Sprite;

class TestSprite extends Sprite {
    public function new() {
        super();
        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, 100, 100);
        graphics.endFill();
        
        LOGGER.Log("info", "TestSprite created!");

		var text = new TextField();
		text.text = "Hello from Haxe!";
		addChild( text );
    }
}
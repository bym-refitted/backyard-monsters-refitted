package;

import com.bymr.hx.HaxeLib;
import test.TestSprite;
import openfl.display.Sprite;

/**
 * This class is the dummy entrypoint and must remain in the project.
 * The project will not compile without it.
 * We actually trick openfl to generate a swc file instead of a swf, and this class is not used at all.
 * It is only here to make sure the project compiles and generates the swc file.
 * 
 */
class Main extends Sprite
{
	public function new()
	{
		super();

		// declare variables to tell the compiler to include these classes in the swc
		
		var testSprite:TestSprite;
		var haxeLib:HaxeLib;
	}
}

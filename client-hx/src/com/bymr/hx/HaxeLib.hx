package com.bymr.hx;

import com.bymr.hx.api.IKeys;
import com.bymr.hx.api.ILogger;
import com.bymr.hx.api.IGlobal;

class HaxeLib {
	// Proxy to AS3 GLOBAL class
	public static var GLOBAL:IGlobal;

	// Proxy to AS3 LOGGER class
	public static var LOGGER:ILogger;

	// Proxy to AS3 KEYS class
	public static var KEYS:IKeys;

	// Specifies if the library has been bootstrapped/initialized
	private static var bootstrapped:Bool = false;

	function new() {}

	/**
	 * Bootstraps the haxe library by providing decoupled access to the AS3 code though interfaces. 
	 * This allows the Haxe code to call methods on the AS3 code without directly depending on AS3 classes.
	 * 
	 * @param globalInstance 
	 * @param loggerInstance 
	 * @param keysInstance
	 */
	public static function bootstrap(globalInstance:IGlobal, loggerInstance:ILogger, keysInstance:IKeys):Void {
		if (bootstrapped) {
			return;
		}
		bootstrapped = true;

		if (globalInstance == null) {
			throw "Global instance cannot be null when bootstrapping HaxeLib.";
		}

		if (loggerInstance == null) {
			throw "Logger instance cannot be null when bootstrapping HaxeLib.";
		}
		
		if (keysInstance == null) {
			throw "Keys instance cannot be null when bootstrapping HaxeLib.";
		}

		GLOBAL = globalInstance;
		LOGGER = loggerInstance;
		KEYS = keysInstance;

		// ...and directly use that logger :-)
		LOGGER.Log("info", "HaxeLib bootstrapped successfully!");
	}
}

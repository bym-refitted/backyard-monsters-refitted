package com.bymr.hx.api;

/**
 * This interface defines methods that the Haxe Code can call on the GLOBAL class in AS3.
 */
interface IGlobal {
	/**
	 * Logs a message to the console. This allows Haxe code to log messages through the AS3 GLOBAL class.
	 * 
	 * This is just an example method. You can add more methods here that you want to be able to call from Haxe code on the GLOBAL class in AS3.
	 * 
	 * @param message The message to log.
	 */
	function log(message:String):Void;
}

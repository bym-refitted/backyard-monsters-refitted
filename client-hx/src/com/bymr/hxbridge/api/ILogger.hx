package com.bymr.hxbridge.api;

interface ILogger {
	/**
	 * Logs a message with a given log level. This allows Haxe code to log messages through the AS3 GLOBAL class with different log levels (e.g., "info", "warn", "error").
	 * @param level 
	 * @param message 
	 * @param param3 
	 */
	function Log(level:String, message:String, param3:Bool = false):Void;
}

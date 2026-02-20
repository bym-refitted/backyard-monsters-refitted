package com.bymr.hxbridge.api;

import openfl.net.URLVariables;
import openfl.display.Sprite;
import openfl.events.EventDispatcher;

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

	function ErrorMessage(message:String = "", errorType:Int = 0):Void;

	function RefreshScreen():Void;

	function ResizeLayer(layer:Sprite):Void;

	function gotoURL(param1:String, param2:URLVariables = null, param3:Bool = true, param4:Array<Dynamic> = null):Void;

	/**
	 * Returns the event dispatcher. This allows Haxe code to listen for events dispatched by the AS3 GLOBAL class.
	 * 
	 * @return EventDispatcher
	 * @as3ref eventDispatcher
	 */
	function getEventDispatcher():EventDispatcher;

	/**
	 * Returns the top layer sprite.
	 * 
	 * @return Sprite
	 * @as3ref _layerTop
	 */
	function getLayerTop():Sprite;

	/**
	 * Returns the URL of the server
	 * 
	 * @return String
	 * @as3ref serverUrl
	 */
	function getServerUrl():String;

	/**
	 * Returns the URL of the CDN
	 * 
	 * @return String
	 * @as3ref cdnUrl
	 */
	function getCdnUrl():String;

	/**
	 * Returns the initialization error message, if any.
	 * @return String
	 * @as3ref initError
	 */
	function getInitError():String;

	/**
	 * Returns whether the text content has been loaded.
	 * @return Bool
	 * @as3ref textContentLoaded
	 */
	function isTextContentLoaded():Bool;

	/**
	 * Returns whether the supported languages have been loaded.
	 * @return Bool
	 * @as3ref supportedLangsLoaded
	 */
	function isSupportedLangsLoaded():Bool;

	/**
	 * Returns whether there is a version mismatch.
	 * @return Bool
	 * @as3ref versionMismatch
	 */
	function isVersionMismatch():Bool;
}

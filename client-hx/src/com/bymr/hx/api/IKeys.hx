package com.bymr.hx.api;

interface IKeys {
	/**
	 * Returns the list of supported languages.
	 * 
	 * @return Array<String>
	 * @as3ref supportedLanguagesJson
	 */
	function getSupportedLanguages():Array<String>;

	/**
	 * Loads the language file for the specified language.
     * 
	 * @param language The language to load. Defaults to "english".
	 */
	function Setup(language:String = "english"):Void;

	/**
	 *  Processes the JSON language file from the server
	 *  Replaces #placeholders# within JSON with dynamic values
	 */
	function Get(jsonKeyPath:String, placeholders:Dynamic = null):String;
}

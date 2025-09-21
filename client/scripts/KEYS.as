package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;

   public class KEYS
   {

      public static var _setup:Boolean = false;

      public static var _storageURL:String = "";

      public static var languageFileJson:Object;

      public static var supportedLanguagesJson:Object;

      private static var dispatcher:EventDispatcher = new EventDispatcher();

      public static var LANGUAGE_FILE_LOADED:String = "languageFileLoaded";

      public function KEYS()
      {
         super();
      }

      public static function Setup(language:String = "english"):void
      {
         _setup = true;
         var languageFile:URLLoader = new URLLoader();
         languageFile.load(new URLRequest(_storageURL + language + ".json"));
         languageFile.addEventListener(Event.COMPLETE, handleLangFileSucc);
         languageFile.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void
            {
            });
      }

      public static function GetSupportedLanguages():void
      {
         var languages:URLLoader = new URLLoader();
         languages.load(new URLRequest(GLOBAL._apiURL + "supportedLangs"));
         languages.addEventListener(Event.COMPLETE, handleSupportedLangsSucc);
         languages.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {});
         languages.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void {});
      }

      private static function handleLangFileSucc(data:Event):void
      {
         var rawData:String = String(data.target.data);
         languageFileJson = JSON.decode(rawData);
         GLOBAL.textContentLoaded = true;
         GLOBAL.eventDispatcher.dispatchEvent(new Event(LANGUAGE_FILE_LOADED));
      }

      private static function handleSupportedLangsSucc(data:Event):void
      {
         var rawData:String = String(data.target.data);
         supportedLanguagesJson = JSON.decode(rawData);
         GLOBAL.supportedLangsLoaded = true;
      }
      
      // Processes the JSON language file from the server
      // Replaces #placeholders# within JSON with dynamic values
      public static function Get(jsonKeyPath:String, placeholders:Object = null):String
      {
         if (languageFileJson == null)
         {
            return jsonKeyPath;
         }
         var jsonValue:Object = languageFileJson;
         if (jsonValue.hasOwnProperty(jsonKeyPath))
         {
            var value:* = jsonValue[jsonKeyPath];
            if (value is String)
            {
               var jsonString:String = value as String;
               if (placeholders != null && jsonString != null)
               {
                  jsonString = replacePlaceholders(jsonString, placeholders);
               }
               return jsonString;
            }
            return String(value);
         }
         return jsonKeyPath;
      }

      private static function replacePlaceholders(input:String, placeholders:Object):String
      {
         for (var key in placeholders)
         {
            if (placeholders.hasOwnProperty(key))
            {
               var placeholder:String = "#" + key + "#";
               input = input.split(placeholder).join(placeholders[key]);
            }
         }
         return input;
      }
   }
}

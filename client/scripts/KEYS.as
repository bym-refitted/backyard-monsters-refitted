package
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;

   public class KEYS
   {

      public static var _setup:Boolean = false;

      public static var _logFunction:Function;

      public static var _storageURL:String = "";

      public static var _languageVersion:int = 8;

      public static var _language:String;

      public static var languageFileJson:Object;

      public static var supportedLanguagesJson:Object;

      public function KEYS()
      {
         super();
      }

      public static function Setup(language:String = "en"):void
      {
         _setup = true;
         var languageFile:URLLoader = new URLLoader();
         languageFile.load(new URLRequest(_storageURL + language + ".v" + _languageVersion + ".json"));
         languageFile.addEventListener(Event.COMPLETE, handleLangFileSuccessful);
         languageFile.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
      }

      private static function handleLangFileSuccessful(param1:Event):void
      {
         var rawData:String = param1.target.data;
         languageFileJson = JSON.decode(rawData);
         GLOBAL.textContentLoaded = true;
      }

      private static function handleLoadError(param1:IOErrorEvent):void
      {
         GLOBAL.Message("Failed to get content from the server.");
      }

      public static function GetAvailableLanguages()
      {
         var languages:URLLoader = new URLLoader();
         languages.load(new URLRequest(GLOBAL._apiURL + "availableLanguages"));
         languages.addEventListener(Event.COMPLETE, handleAvailableLangsSuccessful);
         languages.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
      }

      private static function handleAvailableLangsSuccessful(param1:Event):void
      {
         var rawData:String = param1.target.data;
         supportedLanguagesJson = JSON.decode(rawData);
         GLOBAL.supportedLangsLoaded = true;
      }

      // Processes the JSON language file from the server
      // Replaces #placeholders# within JSON with dynamic values
      public static function Get(jsonKeyPath:String, placeholders:Object = null):String
      {
         if (languageFileJson == null || languageFileJson.data == null)
            return jsonKeyPath;

         var jsonValue:Object = languageFileJson.data;

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
            else
            {
               return String(value);
            }
         }
         else
         {
            return jsonKeyPath;
         }
      }

      private static function replacePlaceholders(input:String, placeholders:Object):String
      {
         for (var key:String in placeholders)
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

package
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.EventDispatcher;

   public class KEYS
   {

      public static var _setup:Boolean = false;

      public static var _storageURL:String = "";

      public static var languageFileJson:Object;

      public static var supportedLanguagesJson:Object;

      public static var errorMessage:String = "";

      private static var dispatcher:EventDispatcher = new EventDispatcher();

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
         languageFile.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
         languageFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, noConnection);
      }

      public static function GetSupportedLanguages():void
      {
         var languages:URLLoader = new URLLoader();
         languages.load(new URLRequest(GLOBAL._apiURL + "supportedLangs"));
         languages.addEventListener(Event.COMPLETE, handleSupportedLangsSucc);
         languages.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
         languages.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent)
            {
            });
      }

      private static function handleLangFileSucc(data:Event):void
      {
         var rawData:String = data.target.data;
         languageFileJson = JSON.decode(rawData);
         GLOBAL.textContentLoaded = true;
      }

      private static function handleSupportedLangsSucc(data:Event):void
      {
         var rawData:String = data.target.data;
         supportedLanguagesJson = JSON.decode(rawData);
         GLOBAL.supportedLangsLoaded = true;
      }

      private static function handleLoadError(error:IOErrorEvent):void
      {
         errorMessage = "Failed to retrieve required content from the server.";
         dispatcher.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
      }

      public static function noConnection(error:SecurityErrorEvent):void
      {
         errorMessage = "We could not establish a connection with the server.";
         dispatcher.dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
      }

      public static function securityErrorListener(listener:Function):void
      {
         dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, listener);
      }

      public static function ioErrorListener(listener:Function):void
      {
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR, listener);
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

package
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;

   public class KEYS
   {

      public static var _keys:Object;

      public static var _delimiters:Object = [];

      public static var _gibberish:Boolean = false;

      public static var _setup:Boolean = false;

      private static var _ignore:Array = ["#fname#", "#collected#", "#mushroomspicked#", "#questname#", "#giftssent#", "#installsgenerated#"];

      private static var cbf:Function;

      public static var _logFunction:Function;

      public static var _storageURL:String = "";

      public static var _languageVersion:int;

      public static var _language:String = "en";

      public static var jsonData:Object;

      public function KEYS()
      {
         super();
      }

      public static function Setup(param1:Function):void
      {
         if (_setup)
         {
            return;
         }
         _setup = true;
         cbf = param1;
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.load(new URLRequest(_storageURL + _language + ".v" + _languageVersion + ".json"));
         _loc2_.addEventListener(Event.COMPLETE, handleSucc);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR, GLOBAL.handleLoadError);
      }

      private static function handleSucc(param1:Event):void
      {
         var rawData:String = param1.target.data;
         jsonData = JSON.decode(rawData);
         cbf();
      }

      // Processes the JSON language file from the server
      // Does not split the key if it is part of the exclusion list
      // Else splits the key for every occurrence of '_' to create child properties
      // Replaces placeholders within JSON with dynamic values e.g. {v1} with 20
      public static function Get(jsonKeyPath:String, placeholders:Object = null):String
      {
         var jsonValue:Object = jsonData.data;

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

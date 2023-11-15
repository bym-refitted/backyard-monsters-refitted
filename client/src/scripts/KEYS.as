package
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import com.brokenfunction.json.decodeJson;

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
         jsonData = decodeJson(rawData);
         cbf();
      }

      // Processes the JSON language file from the server
      // Does not split the key if it is part of the exclusion list
      // Else splits the key for every occurrence of '_' to create child properties
      // Replaces placeholders within JSON with dynamic values e.g. {v1} with 20
      public static function Get(jsonKeyPath:String, placeholders:Object = null):String
      {
         var jsonValue:Object = jsonData.data;
         var excludeList:Array = jsonData.exclusionList;

         if (excludeList && excludeList.indexOf(jsonKeyPath) !== -1)
         {
            // Exlucde
            var excludedValue:String = jsonValue.hasOwnProperty(jsonKeyPath) ? jsonValue[jsonKeyPath] as String : "";
            return replacePlaceholders(excludedValue, placeholders);
         }
         else
         {
            // Split
            var keyPath:Array = jsonKeyPath.split("_");
            jsonValue = createChildKeys(jsonValue, keyPath);
         }
         var jsonString:String = jsonValue as String;

         if (placeholders != null && jsonString != null)
         {
            // Replace
            jsonString = replacePlaceholders(jsonString, placeholders);
         }

         return jsonString != null ? jsonString : jsonKeyPath;
      }

      private static function createChildKeys(json:Object, keyPath:Array):Object
      {
         for each (var key:String in keyPath)
         {
            if (json.hasOwnProperty(key))
            {
               json = json[key];
            }
            else
            {
               return null;
            }
         }
         return json;
      }

      private static function replacePlaceholders(input:String, placeholders:Object):String
      {
         for (var key:String in placeholders)
         {
            if (placeholders.hasOwnProperty(key))
            {
               var placeholder:String = "{" + key + "}";
               input = input.split(placeholder).join(placeholders[key]);
            }
         }
         return input;
      }

      // ----------- OLD IMPLEMENTATION USING TXT FILE ----------- //

      // private static function handleSucc(param1:Event) : void
      // {
      // var _loc3_:String = null;
      // var _loc4_:String = null;
      // _keys = JSON.decode(param1.target.data);
      // var _loc2_:Number = 0;
      // for(_loc3_ in _keys)
      // {
      // for(_loc4_ in _keys[_loc3_])
      // {
      // while(_loc4_.length > 1 && _loc4_.charAt(0) == " ")
      // {
      // _loc4_ = _loc4_.substring(1,_loc4_.length);
      // }
      // while(_loc4_.length > 1 && _loc4_.charAt(_loc4_.length - 1) == " ")
      // {
      // _loc4_ = _loc4_.substring(0,_loc4_.length - 1);
      // }
      // _loc2_++;
      // }
      // }
      // cbf();
      // }

      // public static function Get(param1:String, param2:Object = null) : String
      // {
      // var tmp:String = null;
      // var k:String = null;
      // var tk:String = null;
      // var test:RegExp = null;
      // var matches:Array = null;
      // var i:String = null;
      // var replace:Boolean = false;
      // var ig:String = null;
      // var gib:Array = null;
      // var bits:Array = null;
      // var w:uint = 0;
      // var word:String = null;
      // var gibWord:String = null;
      // var l:uint = 0;
      // var key:String = param1;
      // var values:Object = param2;
      // try
      // {
      // if(!values)
      // {
      // tmp = getStringC(key);
      // if(!tmp)
      // {
      // tmp = getStringB(key);
      // if(!tmp)
      // {
      // if(key != "outpost_upgradedesc")
      // {
      // }
      // if(_logFunction != null)
      // {
      // _logFunction("log","missing key: " + key);
      // }
      // return "[[" + key + "]]";
      // }
      // }
      // }
      // else
      // {
      // tmp = String(_keys.game[key]);
      // if(!tmp)
      // {
      // if(_logFunction != null)
      // {
      // _logFunction("log","missing key: " + key);
      // }
      // return "[[" + key + "]]";
      // }
      // for(k in values)
      // {
      // tk = "#" + k + "#";
      // while(tmp.search(tk) != -1)
      // {
      // tmp = tmp.replace(tk,values[k]);
      // }
      // }
      // if(tmp.lastIndexOf("#") != -1)
      // {
      // test = /#[a-z]+_[a-z]+(_[a-z])*\#/g;
      // matches = tmp.match(test);
      // for each(i in matches)
      // {
      // replace = true;
      // for each(ig in _ignore)
      // {
      // if(ig == i)
      // {
      // replace = false;
      // }
      // if(replace)
      // {
      // tmp = tmp.replace(i,_keys.core[i]);
      // }
      // }
      // }
      // }
      // }
      // if(_gibberish)
      // {
      // gib = [];
      // bits = tmp.split(" ");
      // w = 0;
      // while(w < bits.length)
      // {
      // word = String(bits[w]);
      // gibWord = "";
      // l = 0;
      // while(l < word.length)
      // {
      // gibWord += "*";
      // l += 1;
      // }
      // gib.push(gibWord);
      // w += 1;
      // }
      // return gib.join(" ");
      // }
      // }
      // catch(e:Error)
      // {
      // LOGGER.Log("log","KEYS.Get " + key);
      // tmp = "KEYS Error";
      // }
      // if(tmp.lastIndexOf("&") != -1)
      // {
      // tmp = CleanDiacritics(tmp);
      // }
      // return tmp;
      // }

      // public static function CleanDiacritics(param1:String) : String
      // {
      // param1 = param1.split("&iexcl;").join("¡");
      // param1 = param1.split("&iquest;").join("¿");
      // param1 = param1.split("&quot;").join("\"");
      // param1 = param1.split("&ldquo;").join("\"");
      // param1 = param1.split("&rdquo;").join("\"");
      // param1 = param1.split("&aacute;").join("á");
      // param1 = param1.split("&Aacute;").join("Á");
      // param1 = param1.split("&agrave;").join("à");
      // param1 = param1.split("&Agrave;").join("À");
      // param1 = param1.split("&acirc;").join("â");
      // param1 = param1.split("&Acirc;").join("Â");
      // param1 = param1.split("&aring;").join("å");
      // param1 = param1.split("&Aring;").join("Å");
      // param1 = param1.split("&atilde;").join("ã");
      // param1 = param1.split("&Atilde;").join("Ã");
      // param1 = param1.split("&auml;").join("ä");
      // param1 = param1.split("&Auml;").join("Ä");
      // param1 = param1.split("&aelig;").join("æ");
      // param1 = param1.split("&aelig;").join("Æ");
      // param1 = param1.split("&ccedil;").join("ç");
      // param1 = param1.split("&Ccedil;").join("Ç");
      // param1 = param1.split("&eacute;").join("é");
      // param1 = param1.split("&Eacute;").join("É");
      // param1 = param1.split("&egrave;").join("è");
      // param1 = param1.split("&Egrave;").join("È");
      // param1 = param1.split("&ecirc;").join("ê");
      // param1 = param1.split("&Ecirc;").join("Ê");
      // param1 = param1.split("&euml;").join("ë");
      // param1 = param1.split("&Euml;").join("Ë");
      // param1 = param1.split("&iacute;").join("í");
      // param1 = param1.split("&Iacute;").join("Í");
      // param1 = param1.split("&igrave;").join("ì");
      // param1 = param1.split("&Igrave;").join("Ì");
      // param1 = param1.split("&icirc;").join("î");
      // param1 = param1.split("&Icirc;").join("Î");
      // param1 = param1.split("&iuml;").join("ï");
      // param1 = param1.split("&Iuml;").join("Ï");
      // param1 = param1.split("&ntilde;").join("ñ");
      // param1 = param1.split("&Ntilde;").join("Ñ");
      // param1 = param1.split("&oacute;").join("ó");
      // param1 = param1.split("&Oacute;").join("Ó");
      // param1 = param1.split("&ograve;").join("ò");
      // param1 = param1.split("&Ograve;").join("Ò");
      // param1 = param1.split("&ocirc;").join("ô");
      // param1 = param1.split("&Ocirc;").join("Ô");
      // param1 = param1.split("&oslash;").join("ø");
      // param1 = param1.split("&Oslash;").join("Ø");
      // param1 = param1.split("&otilde;").join("õ");
      // param1 = param1.split("&Otilde;").join("Õ");
      // param1 = param1.split("&ouml;").join("ö");
      // param1 = param1.split("&Ouml;").join("Ö");
      // param1 = param1.split("&szlig;").join("ß");
      // param1 = param1.split("&uacute;").join("ú");
      // param1 = param1.split("&Uacute;").join("Ú");
      // param1 = param1.split("&ugrave;").join("ù");
      // param1 = param1.split("&Ugrave;").join("Ù");
      // param1 = param1.split("&ucirc;").join("û");
      // param1 = param1.split("&Ucirc;").join("Û");
      // param1 = param1.split("&uuml;").join("ü");
      // param1 = param1.split("&Uuml;").join("Ü");
      // param1 = param1.split("&yuml;").join("ÿ");
      // return param1.split("&Yuml;").join("Ÿ");
      // }

      // public static function Dump() : String
      // {
      // return JSON.encode(_keys);
      // }

      // public static function getStringB(param1:String) : String
      // {
      // var _loc3_:RegExp = null;
      // var _loc4_:Array = null;
      // var _loc5_:String = null;
      // var _loc6_:Boolean = false;
      // var _loc7_:String = null;
      // var _loc2_:String = String(_keys.game[param1]);
      // if(!_loc2_)
      // {
      // _loc2_ = "";
      // }
      // else if(_loc2_.lastIndexOf("#") != -1)
      // {
      // _loc3_ = /#[a-z]+_[a-z]+(_[a-z])*\#/g;
      // _loc4_ = _loc2_.match(_loc3_);
      // for each(_loc5_ in _loc4_)
      // {
      // _loc6_ = true;
      // for each(_loc7_ in _ignore)
      // {
      // if(_loc7_ == _loc5_)
      // {
      // _loc6_ = false;
      // }
      // }
      // if(_loc6_)
      // {
      // _loc2_ = _loc2_.replace(_loc5_,_keys.core[_loc5_]);
      // }
      // }
      // }
      // return _loc2_;
      // }

      // public static function getStringC(param1:String) : String
      // {
      // var _loc2_:String = String(_keys.core[param1]);
      // if(!_loc2_)
      // {
      // return "";
      // }
      // return _loc2_;
      // }
   }
}

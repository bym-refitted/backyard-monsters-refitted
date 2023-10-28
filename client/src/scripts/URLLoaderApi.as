package
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequestHeader;
   import flash.net.SharedObject;
   
   public class URLLoaderApi
   {
      
      public static var _data:String = "";
      
      private static var _c:int = 0;
       
      
      public var _URL:String;
      
      private var _status:int;
      
      private var _url:String;
      
      private var _req:URLLoader;
      
      private var _onComplete:Function;
      
      private var _onError:Function;
      
      private var _baseUrl:String;

      public static var sharedObject:SharedObject = SharedObject.getLocal("BymRefittedAppData", "/");
      
      public function URLLoaderApi()
      {
         super();
      }
      
      private function getFbData() : Object
      {
         var _loc2_:* = undefined;
         var _loc1_:Object = GLOBAL._fbdata;
         for(_loc2_ in _loc1_)
         {
            if(_loc2_.substr(0,3) != "fb_" && _loc2_ != "fbid" && _loc2_ != "session" && _loc2_ != "signed_request" && _loc2_.substr(0,2) != "v_")
            {
               delete _loc1_[_loc2_];
            }
            if(_loc2_ == "fb_friends")
            {
               delete _loc1_[_loc2_];
            }
         }
         return _loc1_;
      }


      public function load(baseUrl:String, keyValuePairs:Array = null, onComplete:Function = null, onFail:Function = null) : void
      {
         var currentIndex:int = 0;
         var currentPair:Array = null;
         var token = sharedObject.data.token;

         this._onComplete = onComplete;
         this._onError = onFail;
         this._baseUrl = baseUrl;
         this._url = baseUrl;

         var urlBuilder:URLRequest = new URLRequest(baseUrl);
         var facebookString:String = "";
         var urlVariables:URLVariables = new URLVariables();

         if(keyValuePairs != null && keyValuePairs.length > 0)
         {
            currentIndex = 0;
            while(currentIndex < keyValuePairs.length)
            {
               currentPair = keyValuePairs[currentIndex];
               urlVariables[currentPair[0]] = currentPair[1];
               facebookString += currentPair[1];
               _data += keyValuePairs[currentIndex][0] + "=" + keyValuePairs[currentIndex][1] + "&";
               currentIndex++;
            }
         }
         // Attach the token to the request header if we have it
         if (token) {
            var authHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Bearer " + token);
            urlBuilder.requestHeaders.push(authHeader);
         }

            var ramdomNumber:int = int(Math.random() * 9999999);
            urlVariables.hn = ramdomNumber;
            var hash:String = this.getHash(facebookString,ramdomNumber);
            urlVariables.h = hash;
            urlBuilder.data = urlVariables;
            urlBuilder.method = URLRequestMethod.POST;
            this._req = new URLLoader(urlBuilder);
            this._req.addEventListener(Event.COMPLETE,this.fireComplete);
            this._req.addEventListener(IOErrorEvent.IO_ERROR,this.loadError);
            this._req.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.setStatus);
            this._req.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event: SecurityErrorEvent) {
               GLOBAL.ErrorMessage(event.text, GLOBAL.ERROR_ORANGE_BOX_ONLY);
            });
      }
      
      private function getHash(param1:String, param2:int) : String
      {
         return md5(this.getSalt() + param1 + this.getNum(param2));
      }
      
      private function getSalt() : String
      {
         return this.decodeSalt("84V37530976X4W7175W9Z02U3483Y6VW");
      }
      
      private function decodeSalt(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.substring(_loc3_,_loc3_ + 1);
            switch(_loc4_)
            {
               case "a":
                  _loc2_ += "Z";
                  break;
               case "b":
                  _loc2_ += "Y";
                  break;
               case "c":
                  _loc2_ += "X";
                  break;
               case "d":
                  _loc2_ += "W";
                  break;
               case "e":
                  _loc2_ += "V";
                  break;
               case "f":
                  _loc2_ += "U";
                  break;
               case "g":
                  _loc2_ += "T";
                  break;
               case "h":
                  _loc2_ += "S";
                  break;
               case "i":
                  _loc2_ += "R";
                  break;
               case "j":
                  _loc2_ += "Q";
                  break;
               case "k":
                  _loc2_ += "P";
                  break;
               case "l":
                  _loc2_ += "O";
                  break;
               case "m":
                  _loc2_ += "N";
                  break;
               case "n":
                  _loc2_ += "M";
                  break;
               case "o":
                  _loc2_ += "L";
                  break;
               case "p":
                  _loc2_ += "K";
                  break;
               case "q":
                  _loc2_ += "J";
                  break;
               case "r":
                  _loc2_ += "I";
                  break;
               case "s":
                  _loc2_ += "H";
                  break;
               case "t":
                  _loc2_ += "G";
                  break;
               case "u":
                  _loc2_ += "F";
                  break;
               case "v":
                  _loc2_ += "E";
                  break;
               case "w":
                  _loc2_ += "D";
                  break;
               case "x":
                  _loc2_ += "C";
                  break;
               case "y":
                  _loc2_ += "B";
                  break;
               case "z":
                  _loc2_ += "A";
                  break;
               case "A":
                  _loc2_ += "z";
                  break;
               case "B":
                  _loc2_ += "y";
                  break;
               case "C":
                  _loc2_ += "x";
                  break;
               case "D":
                  _loc2_ += "w";
                  break;
               case "E":
                  _loc2_ += "v";
                  break;
               case "F":
                  _loc2_ += "u";
                  break;
               case "G":
                  _loc2_ += "t";
                  break;
               case "H":
                  _loc2_ += "s";
                  break;
               case "I":
                  _loc2_ += "r";
                  break;
               case "J":
                  _loc2_ += "q";
                  break;
               case "K":
                  _loc2_ += "p";
                  break;
               case "L":
                  _loc2_ += "o";
                  break;
               case "M":
                  _loc2_ += "n";
                  break;
               case "N":
                  _loc2_ += "m";
                  break;
               case "O":
                  _loc2_ += "l";
                  break;
               case "P":
                  _loc2_ += "k";
                  break;
               case "Q":
                  _loc2_ += "j";
                  break;
               case "R":
                  _loc2_ += "i";
                  break;
               case "S":
                  _loc2_ += "h";
                  break;
               case "T":
                  _loc2_ += "g";
                  break;
               case "U":
                  _loc2_ += "f";
                  break;
               case "V":
                  _loc2_ += "e";
                  break;
               case "W":
                  _loc2_ += "d";
                  break;
               case "X":
                  _loc2_ += "c";
                  break;
               case "Y":
                  _loc2_ += "b";
                  break;
               case "Z":
                  _loc2_ += "a";
                  break;
               case "0":
                  _loc2_ += "9";
                  break;
               case "1":
                  _loc2_ += "8";
                  break;
               case "2":
                  _loc2_ += "7";
                  break;
               case "3":
                  _loc2_ += "6";
                  break;
               case "4":
                  _loc2_ += "5";
                  break;
               case "5":
                  _loc2_ += "4";
                  break;
               case "6":
                  _loc2_ += "3";
                  break;
               case "7":
                  _loc2_ += "2";
                  break;
               case "8":
                  _loc2_ += "1";
                  break;
               case "9":
                  _loc2_ += "0";
                  break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getNum(param1:int) : int
      {
         return param1 * (param1 % 11);
      }
      
      private function setStatus(param1:HTTPStatusEvent) : void
      {
         this._status = param1.status;
         switch(this._status)
         {
            case 404:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Not Found");
               break;
            case 401:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Unauthorized");
               break;
            case 403:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Forbidden");
               break;
            case 405:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Method Not Allowed");
               break;
            case 406:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Not Acceptable");
               break;
            case 407:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Proxy Authentication Required");
               break;
            case 408:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Request Timeout");
               break;
            case 500:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Internal Server Error");
               break;
            case 501:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Not Implemented");
               break;
            case 502:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Bad Gateway");
               break;
            case 503:
               LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Service Unavailable");
               break;
            default:
               if(this._status > 400)
               {
                  LOGGER.Log("err","URLLoaderApi HTTP status " + this._status + " Other status");
               }
         }
      }
      
      private function loadError(param1:IOErrorEvent) : void
      {
         LOGGER.Log("err","URLLoader Load Error " + this._url);
         if(this._onError === null)
         {
            return;
         }
         this._onError(param1);
      }
      
      public function Clear() : void
      {
         this._req.removeEventListener(Event.COMPLETE,this.fireComplete);
         this._req.removeEventListener(IOErrorEvent.IO_ERROR,this.loadError);
         this._req.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.setStatus);
         this._req = null;
      }
      
      private function fireComplete(param1:Event) : void
      {
         if(this._onComplete === null)
         {
            return;
         }
         var reqData:* = this._req.data;
         var hasKeyArray :Array = reqData.split(",\"h\":");
         var _loc4_:String = "{\"h\":" + hasKeyArray.pop();
         reqData = hasKeyArray.join(",\"h\":") + "}";
         var stringifiedReqData:String = reqData;
         var decodedReqData:* = JSON.decode(reqData);
         var _loc7_:* = JSON.decode(_loc4_);
         var _loc8_:Boolean;
         if(_loc8_ = false)
         {
            if(GLOBAL._reloadonerror)
            {
               GLOBAL.CallJS("reloadPage");
            }
            else
            {
               if(!_loc7_.h)
               {
               }
               LOGGER.Log("err",this._url + " -- " + stringifiedReqData + " -- " + this._status + " --");
               if(_loc7_.h)
               {
                  GLOBAL.ErrorMessage("URLLoaderAPI hash mismatch");
               }
               else
               {
                  GLOBAL.ErrorMessage("URLLoaderAPI no hash received: " + this._req.data);
               }
            }
         }
         else if(Boolean(this._onComplete))
         {
            if(decodedReqData)
            {
               this._onComplete(decodedReqData);
            }
            else
            {
               print("no jdata?!" + decodedReqData,true);
            }
         }
      }
   }
}

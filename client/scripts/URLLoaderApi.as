package
{

   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;

   public class URLLoaderApi
   {

      public static var _data:String = "";

      private var _status:int;

      private var _url:String;

      private var _req:URLLoader;

      private var _onComplete:Function;

      private var _onError:Function;

      private var _baseUrl:String;

      public function URLLoaderApi()
      {
         super();
      }

      /*
       * This function was created by the Refitted team to send data to the server in JSON format.
       * It provides a more expressive, structured way for parsing and handling data on the server.
       * 
       * @param {String} url - the URL to send data to.
       * @param {Object} data - the data to send in JSON format.
       * @param {String} method - the HTTP method to use (default is POST).
       * @param {Function} onComplete - a callback function to be called on successful completion of the request.
       * @return {void}
       */
      public function invokeApiRequest(url:String, data:Object, method:String = "POST", onComplete:Function = null): void {
         try {
            var request:URLRequest = new URLRequest(url);
            var loader:URLLoader = new URLLoader();
            var errMessage = "";

            request.method = method;
            request.contentType = "application/json";
            request.requestHeaders.push(new URLRequestHeader("Authorization", "Bearer " + LOGIN.token));

            if (data == null || data == undefined) data = {};
            if (method != URLRequestMethod.GET) request.data = JSON.encode(data);

            // Send the request
            loader.load(request);

            // On success, decode JSON and invoke callback
            loader.addEventListener(Event.COMPLETE, function(e:Event) : void {
               var response:Object = JSON.decode(loader.data);
               
               if (onComplete != null) onComplete(response);
            });

            loader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent) : void {
               errMessage = "IOError error event occurred while making the request"
               GLOBAL.ErrorMessage(errMessage, GLOBAL.ERROR_ORANGE_BOX_ONLY);
            });

         } catch (error:Error) {
            errMessage = "Error occurred while making the request: " + error.message;
            GLOBAL.ErrorMessage(errMessage, GLOBAL.ERROR_ORANGE_BOX_ONLY);
         }
      }

      /*
       * This is the original networking function that was used to load data from the server by Kixeye,
       * with some additons such as Bearer tokens in the header for authentication added by the Refitted team.
       * 
       * The majority of the client uses this to access and load data from the server.
       * It uses key-value pairs to send data in application/x-www-form-urlencoded format
       * e.g. keyValuePairs: [["key1", "value1"], ["key2", "value2"]].
       * 
       * @param {String} baseUrl - the URL to load data from.
       * @param {Array} keyValuePairs - an array of key-value pairs to send in the request.
       * @param {Function} onComplete - a callback function to be called on successful completion of the request.
       * @param {Function} onFail - a callback function to be called on failure of the request.
       * @return {void}
       */
      public function load(baseUrl:String, keyValuePairs:Array = null, onComplete:Function = null, onFail:Function = null):void
      {
         var urlBuilder:URLRequest;
         var urlVariables:URLVariables;
         var authHeader:URLRequestHeader;
         var currentIndex:int = 0;
         var currentPair:Array = null;
         var token:* = LOGIN.token;
         this._onComplete = onComplete;
         this._onError = onFail;
         this._baseUrl = baseUrl;
         this._url = baseUrl;
         urlBuilder = new URLRequest(baseUrl);
         urlVariables = new URLVariables();
         if (keyValuePairs != null && keyValuePairs.length > 0)
         {
            currentIndex = 0;
            while (currentIndex < keyValuePairs.length)
            {
               currentPair = keyValuePairs[currentIndex];
               urlVariables[currentPair[0]] = currentPair[1];
               _data += keyValuePairs[currentIndex][0] + "=" + keyValuePairs[currentIndex][1] + "&";
               currentIndex++;
            }
         }
         if (token)
         {
            authHeader = new URLRequestHeader("Authorization", "Bearer " + token);
            urlBuilder.requestHeaders.push(authHeader);
         }
         urlBuilder.data = urlVariables;
         urlBuilder.method = URLRequestMethod.POST;
         this._req = new URLLoader(urlBuilder);
         this._req.addEventListener(Event.COMPLETE, this.fireComplete);
         this._req.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
         this._req.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.setStatus);
         this._req.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):*
            {
               GLOBAL.ErrorMessage(event.text, GLOBAL.ERROR_ORANGE_BOX_ONLY);
            });
      }

      private function setStatus(param1:HTTPStatusEvent):void
      {
         this._status = param1.status;
         switch (this._status)
         {
            case 404:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Not Found");
               break;
            case 401:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Unauthorized");
               break;
            case 403:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Forbidden");
               break;
            case 405:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Method Not Allowed");
               break;
            case 406:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Not Acceptable");
               break;
            case 407:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Proxy Authentication Required");
               break;
            case 408:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Request Timeout");
               break;
            case 500:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Internal Server Error");
               break;
            case 501:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Not Implemented");
               break;
            case 502:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Bad Gateway");
               break;
            case 503:
               LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Service Unavailable");
               break;
            default:
               if (this._status > 400)
               {
                  LOGGER.Log("err", "URLLoaderApi HTTP status " + this._status + " Other status");
               }
         }
      }

      private function loadError(param1:IOErrorEvent):void
      {
         LOGGER.Log("err", "URLLoader Load Error " + this._url);
         if (this._onError === null)
         {
            return;
         }
         this._onError(param1);
      }

      public function Clear():void
      {
         this._req.removeEventListener(Event.COMPLETE, this.fireComplete);
         this._req.removeEventListener(IOErrorEvent.IO_ERROR, this.loadError);
         this._req.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.setStatus);
         this._req = null;
      }

      private function fireComplete(param1:Event):void
      {
         if (this._onComplete === null)
         {
            return;
         }
         var decodedReqData:Object = JSON.decode(this._req.data);
         if (Boolean(this._onComplete))
         {
            if (decodedReqData)
            {
               this._onComplete(decodedReqData);
            }
            else
            {
               print("no jdata?!" + decodedReqData, true);
            }
         }
      }
   }
}

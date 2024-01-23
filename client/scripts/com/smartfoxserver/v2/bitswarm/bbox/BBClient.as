package com.smartfoxserver.v2.bitswarm.bbox
{
   import com.hurlant.util.Base64;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class BBClient extends EventDispatcher
   {
       
      
      private const BB_DEFAULT_HOST:String = "localhost";
      
      private const BB_DEFAULT_PORT:int = 8080;
      
      private const BB_SERVLET:String = "BlueBox/BlueBox.do";
      
      private const BB_NULL:String = "null";
      
      private const CMD_CONNECT:String = "connect";
      
      private const CMD_POLL:String = "poll";
      
      private const CMD_DATA:String = "data";
      
      private const CMD_DISCONNECT:String = "disconnect";
      
      private const ERR_INVALID_SESSION:String = "err01";
      
      private const SFS_HTTP:String = "sfsHttp";
      
      private const SEP:String = "|";
      
      private const MIN_POLL_SPEED:int = 20;
      
      private const MAX_POLL_SPEED:int = 10000;
      
      private const DEFAULT_POLL_SPEED:int = 100;
      
      private var _isConnected:Boolean = false;
      
      private var _host:String = "localhost";
      
      private var _port:int = 8080;
      
      private var _bbUrl:String;
      
      private var _debug:Boolean;
      
      private var _sessId:String;
      
      private var _loader:URLLoader;
      
      private var _urlRequest:URLRequest;
      
      private var _pollSpeed:int = 100;
      
      public function BBClient(param1:String = "localhost", param2:int = 8080, param3:Boolean = false)
      {
         super();
         this._host = param1;
         this._port = param2;
         this._debug = param3;
      }
      
      public function get isConnected() : Boolean
      {
         return this._sessId != null;
      }
      
      public function get isDebug() : Boolean
      {
         return this._debug;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      public function get sessionId() : String
      {
         return this._sessId;
      }
      
      public function get pollSpeed() : int
      {
         return this._pollSpeed;
      }
      
      public function set pollSpeed(param1:int) : void
      {
         this._pollSpeed = param1;
      }
      
      public function set isDebug(param1:Boolean) : void
      {
         this._debug = param1;
      }
      
      public function connect(param1:String = "127.0.0.1", param2:int = 8080) : void
      {
         if(this.isConnected)
         {
            throw new IllegalOperationError("BlueBox session is already connected");
         }
         this._host = param1;
         this._port = param2;
         this._bbUrl = "http://" + this._host + ":" + param2 + "/" + this.BB_SERVLET;
         this.sendRequest(this.CMD_CONNECT);
      }
      
      public function send(param1:ByteArray) : void
      {
         if(!this.isConnected)
         {
            throw new IllegalOperationError("Can\'t send data, BlueBox connection is not active");
         }
         this.sendRequest(this.CMD_DATA,param1);
      }
      
      public function disconnect() : void
      {
         this.sendRequest(this.CMD_DISCONNECT);
      }
      
      public function close() : void
      {
         this.handleConnectionLost(false);
      }
      
      private function onHttpResponse(param1:Event) : void
      {
         var _loc7_:ByteArray = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:String = _loc2_.data as String;
         if(this._debug)
         {
            trace("[ BB-Receive ]: " + _loc3_);
         }
         var _loc4_:Array;
         var _loc5_:String = String((_loc4_ = _loc3_.split(this.SEP))[0]);
         var _loc6_:String = String(_loc4_[1]);
         if(_loc5_ == this.CMD_CONNECT)
         {
            this._sessId = _loc6_;
            this._isConnected = true;
            dispatchEvent(new BBEvent(BBEvent.CONNECT,{}));
            this.poll();
         }
         else if(_loc5_ == this.CMD_POLL)
         {
            _loc7_ = null;
            if(_loc6_ != this.BB_NULL)
            {
               _loc7_ = this.decodeResponse(_loc6_);
            }
            if(this._isConnected)
            {
               setTimeout(this.poll,this._pollSpeed);
            }
            dispatchEvent(new BBEvent(BBEvent.DATA,{"data":_loc7_}));
         }
         else if(_loc5_ == this.ERR_INVALID_SESSION)
         {
            this.handleConnectionLost();
         }
      }
      
      private function onHttpIOError(param1:IOErrorEvent) : void
      {
         var _loc2_:BBEvent = new BBEvent(BBEvent.IO_ERROR,{"message":param1.text});
         dispatchEvent(_loc2_);
      }
      
      private function poll() : void
      {
         this.sendRequest(this.CMD_POLL);
      }
      
      private function sendRequest(param1:String, param2:* = null) : void
      {
         this._urlRequest = new URLRequest(this._bbUrl);
         this._urlRequest.method = URLRequestMethod.POST;
         var _loc3_:URLVariables = new URLVariables();
         _loc3_[this.SFS_HTTP] = this.encodeRequest(param1,param2);
         this._urlRequest.data = _loc3_;
         if(this._debug)
         {
            trace("[ BB-Send ]: " + _loc3_[this.SFS_HTTP]);
         }
         var _loc4_:URLLoader;
         (_loc4_ = this.getLoader()).data = _loc3_;
         _loc4_.load(this._urlRequest);
      }
      
      private function getLoader() : URLLoader
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.dataFormat = URLLoaderDataFormat.TEXT;
         _loc1_.addEventListener(Event.COMPLETE,this.onHttpResponse);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onHttpIOError);
         _loc1_.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onHttpIOError);
         return _loc1_;
      }
      
      private function handleConnectionLost(param1:Boolean = true) : void
      {
         if(this._isConnected)
         {
            this._isConnected = false;
            this._sessId = null;
            if(param1)
            {
               dispatchEvent(new BBEvent(BBEvent.DISCONNECT,{}));
            }
         }
      }
      
      private function encodeRequest(param1:String, param2:* = null) : String
      {
         var _loc3_:String = "";
         if(param1 == null)
         {
            param1 = this.BB_NULL;
         }
         if(param2 == null)
         {
            param2 = this.BB_NULL;
         }
         else if(param2 is ByteArray)
         {
            param2 = Base64.encodeByteArray(param2);
         }
         return _loc3_ + ((this._sessId == null ? this.BB_NULL : this._sessId) + this.SEP + param1 + this.SEP + param2);
      }
      
      private function decodeResponse(param1:String) : ByteArray
      {
         return Base64.decodeToByteArray(param1);
      }
   }
}

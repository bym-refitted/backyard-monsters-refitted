package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.bitswarm.bbox.BBClient;
   import com.smartfoxserver.v2.bitswarm.bbox.BBEvent;
   import com.smartfoxserver.v2.controllers.ExtensionController;
   import com.smartfoxserver.v2.controllers.SystemController;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.util.ClientDisconnectionReason;
   import com.smartfoxserver.v2.util.ConnectionMode;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   
   public class BitSwarmClient extends EventDispatcher
   {
       
      
      private var _socket:Socket;
      
      private var _bbClient:BBClient;
      
      private var _ioHandler:com.smartfoxserver.v2.bitswarm.IoHandler;
      
      private var _controllers:Object;
      
      private var _compressionThreshold:int = 2000000;
      
      private var _maxMessageSize:int = 10000;
      
      private var _sfs:SmartFox;
      
      private var _connected:Boolean;
      
      private var _lastIpAddress:String;
      
      private var _lastTcpPort:int;
      
      private var _reconnectionDelayMillis:int = 1000;
      
      private var _reconnectionSeconds:int = 0;
      
      private var _attemptingReconnection:Boolean = false;
      
      private var _log:Logger;
      
      private var _sysController:SystemController;
      
      private var _extController:ExtensionController;
      
      private var _udpManager:com.smartfoxserver.v2.bitswarm.IUDPManager;
      
      private var _controllersInited:Boolean = false;
      
      private var _useBlueBox:Boolean = false;
      
      private var _connectionMode:String;
      
      public function BitSwarmClient(param1:SmartFox = null)
      {
         super();
         this._controllers = {};
         this._sfs = param1;
         this._connected = false;
         this._log = Logger.getInstance();
         this._udpManager = new DefaultUDPManager(param1);
      }
      
      public function get sfs() : SmartFox
      {
         return this._sfs;
      }
      
      public function get connected() : Boolean
      {
         return this._connected;
      }
      
      public function get connectionMode() : String
      {
         return this._connectionMode;
      }
      
      public function get ioHandler() : com.smartfoxserver.v2.bitswarm.IoHandler
      {
         return this._ioHandler;
      }
      
      public function set ioHandler(param1:com.smartfoxserver.v2.bitswarm.IoHandler) : void
      {
         if(this._ioHandler != null)
         {
            throw new SFSError("IOHandler is already set!");
         }
         this._ioHandler = param1;
      }
      
      public function get maxMessageSize() : int
      {
         return this._maxMessageSize;
      }
      
      public function set maxMessageSize(param1:int) : void
      {
         this._maxMessageSize = param1;
      }
      
      public function get compressionThreshold() : int
      {
         return this._compressionThreshold;
      }
      
      public function set compressionThreshold(param1:int) : void
      {
         if(param1 > 100)
         {
            this._compressionThreshold = param1;
            return;
         }
         throw new ArgumentError("Compression threshold cannot be < 100 bytes.");
      }
      
      public function get reconnectionDelayMillis() : int
      {
         return this._reconnectionDelayMillis;
      }
      
      public function get useBlueBox() : Boolean
      {
         return this._useBlueBox;
      }
      
      public function forceBlueBox(param1:Boolean) : void
      {
         if(!this.connected)
         {
            this._useBlueBox = param1;
            return;
         }
         throw new IllegalOperationError("You can\'t change the BlueBox mode while the connection is running");
      }
      
      public function set reconnectionDelayMillis(param1:int) : void
      {
         this._reconnectionDelayMillis = param1;
      }
      
      public function enableBBoxDebug(param1:Boolean) : void
      {
         this._bbClient.isDebug = param1;
      }
      
      public function init() : void
      {
         if(!this._controllersInited)
         {
            this.initControllers();
            this._controllersInited = true;
         }
         this._socket = new Socket();
         this._socket.addEventListener(Event.CONNECT,this.onSocketConnect);
         this._socket.addEventListener(Event.CLOSE,this.onSocketClose);
         this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketIOError);
         this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         this._bbClient = new BBClient();
         this._bbClient.addEventListener(BBEvent.CONNECT,this.onBBConnect);
         this._bbClient.addEventListener(BBEvent.DATA,this.onBBData);
         this._bbClient.addEventListener(BBEvent.DISCONNECT,this.onBBDisconnect);
         this._bbClient.addEventListener(BBEvent.IO_ERROR,this.onBBError);
         this._bbClient.addEventListener(BBEvent.SECURITY_ERROR,this.onBBError);
      }
      
      public function destroy() : void
      {
         this._socket.removeEventListener(Event.CONNECT,this.onSocketConnect);
         this._socket.removeEventListener(Event.CLOSE,this.onSocketClose);
         this._socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketIOError);
         this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         if(this._socket.connected)
         {
            this._socket.close();
         }
         this._socket = null;
      }
      
      public function getController(param1:int) : IController
      {
         return this._controllers[param1] as IController;
      }
      
      public function get systemController() : SystemController
      {
         return this._sysController;
      }
      
      public function get extensionController() : ExtensionController
      {
         return this._extController;
      }
      
      public function get isReconnecting() : Boolean
      {
         return this._attemptingReconnection;
      }
      
      public function set isReconnecting(param1:Boolean) : void
      {
         this._attemptingReconnection = param1;
      }
      
      public function getControllerById(param1:int) : IController
      {
         return this._controllers[param1];
      }
      
      public function get connectionIp() : String
      {
         if(!this.connected)
         {
            return "Not Connected";
         }
         return this._lastIpAddress;
      }
      
      public function get connectionPort() : int
      {
         if(!this.connected)
         {
            return -1;
         }
         return this._lastTcpPort;
      }
      
      private function addController(param1:int, param2:IController) : void
      {
         if(param2 == null)
         {
            throw new ArgumentError("Controller is null, it can\'t be added.");
         }
         if(this._controllers[param1] != null)
         {
            throw new ArgumentError("A controller with id: " + param1 + " already exists! Controller can\'t be added: " + param2);
         }
         this._controllers[param1] = param2;
      }
      
      public function addCustomController(param1:int, param2:Class) : void
      {
         var _loc3_:IController = param2(this);
         this.addController(param1,_loc3_);
      }
      
      public function connect(param1:String = "127.0.0.1", param2:int = 9933) : void
      {
         this._lastIpAddress = param1;
         this._lastTcpPort = param2;
         if(this._useBlueBox)
         {
            this._bbClient.connect(param1,param2);
            this._connectionMode = ConnectionMode.HTTP;
         }
         else
         {
            this._socket.connect(param1,param2);
            this._connectionMode = ConnectionMode.SOCKET;
         }
      }
      
      public function send(param1:IMessage) : void
      {
         this._ioHandler.codec.onPacketWrite(param1);
      }
      
      public function get socket() : Socket
      {
         return this._socket;
      }
      
      public function get httpSocket() : BBClient
      {
         return this._bbClient;
      }
      
      public function disconnect(param1:String = null) : void
      {
         if(this._useBlueBox)
         {
            this._bbClient.close();
         }
         else
         {
            this._socket.close();
         }
         this.onSocketClose(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":param1}));
      }
      
      public function nextUdpPacketId() : Number
      {
         return this._udpManager.nextUdpPacketId();
      }
      
      public function killConnection() : void
      {
         this._socket.close();
         this.onSocketClose(new Event(Event.CLOSE));
      }
      
      public function get udpManager() : com.smartfoxserver.v2.bitswarm.IUDPManager
      {
         return this._udpManager;
      }
      
      public function set udpManager(param1:com.smartfoxserver.v2.bitswarm.IUDPManager) : void
      {
         this._udpManager = param1;
      }
      
      private function initControllers() : void
      {
         this._sysController = new SystemController(this);
         this._extController = new ExtensionController(this);
         this.addController(0,this._sysController);
         this.addController(1,this._extController);
      }
      
      public function get reconnectionSeconds() : int
      {
         return this._reconnectionSeconds;
      }
      
      public function set reconnectionSeconds(param1:int) : void
      {
         if(param1 < 0)
         {
            this._reconnectionSeconds = 0;
         }
         else
         {
            this._reconnectionSeconds = param1;
         }
      }
      
      private function onSocketConnect(param1:Event) : void
      {
         this._connected = true;
         var _loc2_:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
         _loc2_.params = {
            "success":true,
            "_isReconnection":this._attemptingReconnection
         };
         dispatchEvent(_loc2_);
      }
      
      private function onSocketClose(param1:Event) : void
      {
         var isRegularDisconnection:Boolean;
         var isManualDisconnection:Boolean;
         var evt:Event = param1;
         this._connected = false;
         isRegularDisconnection = !this._attemptingReconnection && this.sfs.getReconnectionSeconds() == 0;
         isManualDisconnection = evt is BitSwarmEvent && (evt as BitSwarmEvent).params.reason == ClientDisconnectionReason.MANUAL;
         if(this._attemptingReconnection || isRegularDisconnection || isManualDisconnection)
         {
            this._udpManager.reset();
            if(evt is BitSwarmEvent)
            {
               dispatchEvent(evt);
            }
            else
            {
               dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":ClientDisconnectionReason.UNKNOWN}));
            }
            return;
         }
         this._attemptingReconnection = true;
         dispatchEvent(new BitSwarmEvent(BitSwarmEvent.RECONNECTION_TRY));
         setTimeout(function():void
         {
            connect(_lastIpAddress,_lastTcpPort);
         },this._reconnectionDelayMillis);
      }
      
      private function onSocketData(param1:ProgressEvent) : void
      {
         var buffer:ByteArray = null;
         var event:BitSwarmEvent = null;
         var evt:ProgressEvent = param1;
         try
         {
            buffer = new ByteArray();
            this._socket.readBytes(buffer);
            this._ioHandler.onDataRead(buffer);
         }
         catch(error:Error)
         {
            trace("## SocketDataError: " + evt.toString());
            event = new BitSwarmEvent(BitSwarmEvent.DATA_ERROR);
            event.params = {"message":evt.toString()};
            dispatchEvent(event);
         }
      }
      
      private function onSocketIOError(param1:IOErrorEvent) : void
      {
         if(this._attemptingReconnection)
         {
            dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":ClientDisconnectionReason.UNKNOWN}));
            return;
         }
         trace("## SocketError: " + param1.toString());
         var _loc2_:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
         _loc2_.params = {"message":param1.toString()};
         dispatchEvent(_loc2_);
      }
      
      private function onSocketSecurityError(param1:SecurityErrorEvent) : void
      {
         trace("## SecurityError: " + param1.toString());
         var _loc2_:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.SECURITY_ERROR);
         _loc2_.params = {"message":param1.text};
         dispatchEvent(_loc2_);
      }
      
      private function onBBConnect(param1:BBEvent) : void
      {
         this._connected = true;
         var _loc2_:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.CONNECT);
         _loc2_.params = {"success":true};
         dispatchEvent(_loc2_);
      }
      
      private function onBBData(param1:BBEvent) : void
      {
         var _loc2_:ByteArray = param1.params.data;
         if(_loc2_ != null)
         {
            this._ioHandler.onDataRead(_loc2_);
         }
      }
      
      private function onBBDisconnect(param1:BBEvent) : void
      {
         this._connected = false;
         dispatchEvent(new BitSwarmEvent(BitSwarmEvent.DISCONNECT,{"reason":ClientDisconnectionReason.UNKNOWN}));
      }
      
      private function onBBError(param1:BBEvent) : void
      {
         trace("## BlueBox Error: " + param1.params.message);
         var _loc2_:BitSwarmEvent = new BitSwarmEvent(BitSwarmEvent.IO_ERROR);
         _loc2_.params = {"message":param1.params.message};
         dispatchEvent(_loc2_);
      }
   }
}

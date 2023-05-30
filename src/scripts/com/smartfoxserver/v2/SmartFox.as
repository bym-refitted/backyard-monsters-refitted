package com.smartfoxserver.v2
{
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.BitSwarmEvent;
   import com.smartfoxserver.v2.bitswarm.DefaultUDPManager;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.bitswarm.IUDPManager;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.core.SFSIOHandler;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.managers.IBuddyManager;
   import com.smartfoxserver.v2.entities.managers.IRoomManager;
   import com.smartfoxserver.v2.entities.managers.IUserManager;
   import com.smartfoxserver.v2.entities.managers.SFSBuddyManager;
   import com.smartfoxserver.v2.entities.managers.SFSGlobalUserManager;
   import com.smartfoxserver.v2.entities.managers.SFSRoomManager;
   import com.smartfoxserver.v2.exceptions.SFSCodecError;
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   import com.smartfoxserver.v2.logging.Logger;
   import com.smartfoxserver.v2.requests.BaseRequest;
   import com.smartfoxserver.v2.requests.HandshakeRequest;
   import com.smartfoxserver.v2.requests.IRequest;
   import com.smartfoxserver.v2.requests.JoinRoomRequest;
   import com.smartfoxserver.v2.requests.ManualDisconnectionRequest;
   import com.smartfoxserver.v2.util.ClientDisconnectionReason;
   import com.smartfoxserver.v2.util.ConfigData;
   import com.smartfoxserver.v2.util.ConfigLoader;
   import com.smartfoxserver.v2.util.ConnectionMode;
   import com.smartfoxserver.v2.util.LagMonitor;
   import com.smartfoxserver.v2.util.SFSErrorCodes;
   import flash.events.EventDispatcher;
   import flash.system.Capabilities;
   import flash.utils.setTimeout;
   
   public class SmartFox extends EventDispatcher
   {
       
      
      private const DEFAULT_HTTP_PORT:int = 8080;
      
      private var _majVersion:int = 0;
      
      private var _minVersion:int = 9;
      
      private var _subVersion:int = 15;
      
      private var _bitSwarm:BitSwarmClient;
      
      private var _lagMonitor:LagMonitor;
      
      private var _useBlueBox:Boolean = true;
      
      private var _isConnected:Boolean = false;
      
      private var _isJoining:Boolean = false;
      
      private var _mySelf:User;
      
      private var _sessionToken:String;
      
      private var _lastJoinedRoom:Room;
      
      private var _log:Logger;
      
      private var _inited:Boolean = false;
      
      private var _debug:Boolean = false;
      
      private var _isConnecting:Boolean = false;
      
      private var _userManager:IUserManager;
      
      private var _roomManager:IRoomManager;
      
      private var _buddyManager:IBuddyManager;
      
      private var _config:ConfigData;
      
      private var _currentZone:String;
      
      private var _autoConnectOnConfig:Boolean = false;
      
      private var _lastIpAddress:String;
      
      public function SmartFox(param1:Boolean = false)
      {
         super();
         this._log = Logger.getInstance();
         this._log.enableEventDispatching = true;
         this._debug = param1;
         this.initialize();
      }
      
      private function initialize() : void
      {
         if(this._inited)
         {
            return;
         }
         this._bitSwarm = new BitSwarmClient(this);
         this._bitSwarm.ioHandler = new SFSIOHandler(this._bitSwarm);
         this._bitSwarm.init();
         this._bitSwarm.addEventListener(BitSwarmEvent.CONNECT,this.onSocketConnect);
         this._bitSwarm.addEventListener(BitSwarmEvent.DISCONNECT,this.onSocketClose);
         this._bitSwarm.addEventListener(BitSwarmEvent.RECONNECTION_TRY,this.onSocketReconnectionTry);
         this._bitSwarm.addEventListener(BitSwarmEvent.IO_ERROR,this.onSocketIOError);
         this._bitSwarm.addEventListener(BitSwarmEvent.SECURITY_ERROR,this.onSocketSecurityError);
         this._bitSwarm.addEventListener(BitSwarmEvent.DATA_ERROR,this.onSocketDataError);
         addEventListener(SFSEvent.HANDSHAKE,this.handleHandShake);
         addEventListener(SFSEvent.LOGIN,this.handleLogin);
         this._inited = true;
         this.reset();
      }
      
      private function reset() : void
      {
         this._userManager = new SFSGlobalUserManager(this);
         this._roomManager = new SFSRoomManager(this);
         this._buddyManager = new SFSBuddyManager(this);
         if(this._lagMonitor != null)
         {
            this._lagMonitor.destroy();
         }
         this._lagMonitor = new LagMonitor(this);
         this._isConnected = false;
         this._isJoining = false;
         this._currentZone = null;
         this._lastJoinedRoom = null;
         this._sessionToken = null;
         this._mySelf = null;
      }
      
      public function enableLagMonitor(param1:Boolean) : void
      {
         if(this._mySelf == null)
         {
            this.logger.warn("Lag Monitoring requires that you are logged in a Zone!");
            return;
         }
         if(param1)
         {
            this._lagMonitor.start();
         }
         else
         {
            this._lagMonitor.stop();
         }
      }
      
      kernel function get socketEngine() : BitSwarmClient
      {
         return this._bitSwarm;
      }
      
      kernel function get lagMonitor() : LagMonitor
      {
         return this._lagMonitor;
      }
      
      public function get isConnected() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._bitSwarm != null)
         {
            _loc1_ = this._bitSwarm.connected;
         }
         return _loc1_;
      }
      
      public function get connectionMode() : String
      {
         return this._bitSwarm.connectionMode;
      }
      
      public function get version() : String
      {
         return "" + this._majVersion + "." + this._minVersion + "." + this._subVersion;
      }
      
      public function get config() : ConfigData
      {
         return this._config;
      }
      
      public function get compressionThreshold() : int
      {
         return this._bitSwarm.compressionThreshold;
      }
      
      public function get maxMessageSize() : int
      {
         return this._bitSwarm.maxMessageSize;
      }
      
      public function getRoomById(param1:int) : Room
      {
         return this.roomManager.getRoomById(param1);
      }
      
      public function getRoomByName(param1:String) : Room
      {
         return this.roomManager.getRoomByName(param1);
      }
      
      public function getRoomListFromGroup(param1:String) : Array
      {
         return this.roomManager.getRoomListFromGroup(param1);
      }
      
      public function killConnection() : void
      {
         this._bitSwarm.killConnection();
      }
      
      public function connect(param1:String = null, param2:int = -1) : void
      {
         if(this.isConnected)
         {
            this._log.warn("Already connected");
            return;
         }
         if(this._isConnecting)
         {
            this._log.warn("A connection attempt is already in progress");
            return;
         }
         if(this.config != null)
         {
            if(param1 == null)
            {
               param1 = this.config.host;
            }
            if(param2 == -1)
            {
               param2 = this.config.port;
            }
         }
         if(param1 == null || param1.length == 0)
         {
            throw new ArgumentError("Invalid connection host/address");
         }
         if(param2 < 0 || param2 > 65535)
         {
            throw new ArgumentError("Invalid connection port");
         }
         this._lastIpAddress = param1;
         this._isConnecting = true;
         this._bitSwarm.connect(param1,param2);
      }
      
      public function disconnect() : void
      {
         if(this.isConnected)
         {
            if(this._bitSwarm.reconnectionSeconds > 0)
            {
               this.send(new ManualDisconnectionRequest());
            }
            setTimeout(function():void
            {
               _bitSwarm.disconnect(ClientDisconnectionReason.MANUAL);
            },100);
         }
         else
         {
            this._log.info("You are not connected");
         }
      }
      
      public function get debug() : Boolean
      {
         return this._debug;
      }
      
      public function set debug(param1:Boolean) : void
      {
         this._debug = param1;
      }
      
      public function get currentIp() : String
      {
         return this._bitSwarm.connectionIp;
      }
      
      public function get currentPort() : int
      {
         return this._bitSwarm.connectionPort;
      }
      
      public function get currentZone() : String
      {
         return this._currentZone;
      }
      
      public function get mySelf() : User
      {
         return this._mySelf;
      }
      
      public function set mySelf(param1:User) : void
      {
         this._mySelf = param1;
      }
      
      public function get useBlueBox() : Boolean
      {
         return this._useBlueBox;
      }
      
      public function set useBlueBox(param1:Boolean) : void
      {
         this._useBlueBox = param1;
      }
      
      public function get logger() : Logger
      {
         return this._log;
      }
      
      public function get lastJoinedRoom() : Room
      {
         return this._lastJoinedRoom;
      }
      
      public function set lastJoinedRoom(param1:Room) : void
      {
         this._lastJoinedRoom = param1;
      }
      
      public function get joinedRooms() : Array
      {
         return this.roomManager.getJoinedRooms();
      }
      
      public function get roomList() : Array
      {
         return this._roomManager.getRoomList();
      }
      
      public function get roomManager() : IRoomManager
      {
         return this._roomManager;
      }
      
      public function get userManager() : IUserManager
      {
         return this._userManager;
      }
      
      public function get buddyManager() : IBuddyManager
      {
         return this._buddyManager;
      }
      
      public function get udpAvailable() : Boolean
      {
         return this.isAirRuntime();
      }
      
      public function get udpInited() : Boolean
      {
         return this._bitSwarm.udpManager.inited;
      }
      
      public function initUDP(param1:IUDPManager, param2:String = null, param3:int = -1) : void
      {
         if(this.isAirRuntime())
         {
            if(!this.isConnected)
            {
               this._log.warn("Cannot initialize UDP protocol until the client is connected to SFS2X.");
               return;
            }
            if(this.config != null)
            {
               if(param2 == null)
               {
                  param2 = this.config.udpHost;
               }
               if(param3 == -1)
               {
                  param3 = this.config.udpPort;
               }
            }
            if(param2 == null || param2.length == 0)
            {
               throw new ArgumentError("Invalid UDP host/address");
            }
            if(param3 < 0 || param3 > 65535)
            {
               throw new ArgumentError("Invalid UDP port range");
            }
            if(!this._bitSwarm.udpManager.inited && this._bitSwarm.udpManager is DefaultUDPManager)
            {
               param1.sfs = this;
               this._bitSwarm.udpManager = param1;
            }
            this._bitSwarm.udpManager.initialize(param2,param3);
         }
         else
         {
            this._log.warn("UDP Failure: the protocol is available only for the AIR 2.0 runtime.");
         }
      }
      
      private function isAirRuntime() : Boolean
      {
         return Capabilities.playerType.toLowerCase() == "desktop";
      }
      
      public function get isJoining() : Boolean
      {
         return this._isJoining;
      }
      
      public function set isJoining(param1:Boolean) : void
      {
         this._isJoining = param1;
      }
      
      public function get sessionToken() : String
      {
         return this._sessionToken;
      }
      
      public function getReconnectionSeconds() : int
      {
         return this._bitSwarm.reconnectionSeconds;
      }
      
      public function setReconnectionSeconds(param1:int) : void
      {
         this._bitSwarm.reconnectionSeconds = param1;
      }
      
      public function send(param1:IRequest) : void
      {
         var errMsg:String = null;
         var errorItem:String = null;
         var request:IRequest = param1;
         if(!this.isConnected)
         {
            this._log.warn("You are not connected. Request cannot be sent: " + request);
            return;
         }
         try
         {
            if(request is JoinRoomRequest)
            {
               if(this._isJoining)
               {
                  return;
               }
               this._isJoining = true;
            }
            request.validate(this);
            request.execute(this);
            this._bitSwarm.send(request.getMessage());
         }
         catch(problem:SFSValidationError)
         {
            errMsg = String(problem.message);
            for each(errorItem in problem.errors)
            {
               errMsg += "\t" + errorItem + "\n";
            }
            _log.warn(errMsg);
         }
         catch(error:SFSCodecError)
         {
            _log.warn(error.message);
         }
      }
      
      public function loadConfig(param1:String = "sfs-config.xml", param2:Boolean = true) : void
      {
         var _loc3_:ConfigLoader = new ConfigLoader();
         _loc3_.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         _loc3_.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         this._autoConnectOnConfig = param2;
         _loc3_.loadConfig(param1);
      }
      
      public function addJoinedRoom(param1:Room) : void
      {
         if(!this.roomManager.containsRoom(param1.id))
         {
            this.roomManager.addRoom(param1);
            this._lastJoinedRoom = param1;
            return;
         }
         throw new SFSError("Unexpected: joined room already exists for this User: " + this.mySelf.name + ", Room: " + param1);
      }
      
      public function removeJoinedRoom(param1:Room) : void
      {
         this.roomManager.removeRoom(param1);
         if(this.joinedRooms.length > 0)
         {
            this._lastJoinedRoom = this.joinedRooms[this.joinedRooms.length - 1];
         }
      }
      
      private function onSocketConnect(param1:BitSwarmEvent) : void
      {
         if(param1.params.success)
         {
            this.sendHandshakeRequest(param1.params._isReconnection);
         }
         else
         {
            this._log.warn("Connection attempt failed");
            this.handleConnectionProblem(param1);
         }
      }
      
      private function onSocketClose(param1:BitSwarmEvent) : void
      {
         this.reset();
         dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_LOST,{"reason":param1.params.reason}));
      }
      
      private function onSocketReconnectionTry(param1:BitSwarmEvent) : void
      {
         dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RETRY,{}));
      }
      
      private function onSocketDataError(param1:BitSwarmEvent) : void
      {
         dispatchEvent(new SFSEvent(SFSEvent.SOCKET_ERROR,{"errorMessage":param1.params.message}));
      }
      
      private function onSocketIOError(param1:BitSwarmEvent) : void
      {
         if(this._isConnecting)
         {
            this.handleConnectionProblem(param1);
         }
      }
      
      private function onSocketSecurityError(param1:BitSwarmEvent) : void
      {
         if(this._isConnecting)
         {
            this.handleConnectionProblem(param1);
         }
      }
      
      private function onConfigLoadSuccess(param1:SFSEvent) : void
      {
         var _loc2_:ConfigLoader = param1.target as ConfigLoader;
         var _loc3_:ConfigData = param1.params.cfg as ConfigData;
         _loc2_.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         _loc2_.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         if(_loc3_.host == null || _loc3_.host.length == 0)
         {
            throw new ArgumentError("Invalid Host/IpAddress in external config file");
         }
         if(_loc3_.port < 0 || _loc3_.port > 65535)
         {
            throw new ArgumentError("Invalid TCP port in external config file");
         }
         if(_loc3_.zone == null || _loc3_.zone.length == 0)
         {
            throw new ArgumentError("Invalid Zone name in external config file");
         }
         this._debug = _loc3_.debug;
         this._useBlueBox = _loc3_.useBlueBox;
         this._config = _loc3_;
         var _loc4_:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS,{"config":_loc3_});
         dispatchEvent(_loc4_);
         if(this._autoConnectOnConfig)
         {
            this.connect(this._config.host,this._config.port);
         }
      }
      
      private function onConfigLoadFailure(param1:SFSEvent) : void
      {
         var _loc2_:ConfigLoader = param1.target as ConfigLoader;
         _loc2_.removeEventListener(SFSEvent.CONFIG_LOAD_SUCCESS,this.onConfigLoadSuccess);
         _loc2_.removeEventListener(SFSEvent.CONFIG_LOAD_FAILURE,this.onConfigLoadFailure);
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE,{});
         dispatchEvent(_loc3_);
      }
      
      private function handleHandShake(param1:SFSEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc2_:IMessage = param1.params.message;
         var _loc3_:ISFSObject = _loc2_.content;
         if(_loc3_.isNull(BaseRequest.KEY_ERROR_CODE))
         {
            this._sessionToken = _loc3_.getUtfString(HandshakeRequest.KEY_SESSION_TOKEN);
            this._bitSwarm.compressionThreshold = _loc3_.getInt(HandshakeRequest.KEY_COMPRESSION_THRESHOLD);
            this._bitSwarm.maxMessageSize = _loc3_.getInt(HandshakeRequest.KEY_MAX_MESSAGE_SIZE);
            if(this._bitSwarm.isReconnecting)
            {
               this._bitSwarm.isReconnecting = false;
               dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_RESUME,{}));
            }
            else
            {
               this._isConnecting = false;
               dispatchEvent(new SFSEvent(SFSEvent.CONNECTION,{"success":true}));
            }
         }
         else
         {
            _loc4_ = _loc3_.getShort(BaseRequest.KEY_ERROR_CODE);
            _loc5_ = SFSErrorCodes.getErrorMessage(_loc4_,_loc3_.getUtfStringArray(BaseRequest.KEY_ERROR_PARAMS));
            _loc6_ = {
               "success":false,
               "errorMessage":_loc5_,
               "errorCode":_loc4_
            };
            dispatchEvent(new SFSEvent(SFSEvent.CONNECTION,_loc6_));
         }
      }
      
      private function handleLogin(param1:SFSEvent) : void
      {
         this._currentZone = param1.params.zone;
      }
      
      public function handleClientDisconnection(param1:String) : void
      {
         this._bitSwarm.reconnectionSeconds = 0;
         this._bitSwarm.disconnect(param1);
         this.reset();
      }
      
      public function handleLogout() : void
      {
         this._userManager = new SFSGlobalUserManager(this);
         this._roomManager = new SFSRoomManager(this);
         this._isJoining = false;
         this._lastJoinedRoom = null;
         this._currentZone = null;
         this._mySelf = null;
      }
      
      private function handleConnectionProblem(param1:BitSwarmEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(this._bitSwarm.connectionMode == ConnectionMode.SOCKET && this._useBlueBox)
         {
            this._bitSwarm.forceBlueBox(true);
            _loc2_ = this.config != null ? this.config.httpPort : this.DEFAULT_HTTP_PORT;
            this._bitSwarm.connect(this._lastIpAddress,_loc2_);
            dispatchEvent(new SFSEvent(SFSEvent.CONNECTION_ATTEMPT_HTTP,{}));
         }
         else
         {
            _loc3_ = {
               "success":false,
               "errorMessage":param1.params.message
            };
            dispatchEvent(new SFSEvent(SFSEvent.CONNECTION,_loc3_));
            this._isConnecting = this._isConnected = false;
         }
      }
      
      private function sendHandshakeRequest(param1:Boolean = false) : void
      {
         var _loc2_:IRequest = new HandshakeRequest(this.version,param1 ? this._sessionToken : null);
         this.send(_loc2_);
      }
   }
}

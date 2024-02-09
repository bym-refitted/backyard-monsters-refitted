package
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.SecurityErrorEvent;
    import flash.utils.Dictionary;

    public class SOCKET_API
    {

        private var _socket:Socket;

        private var _host:String = "192.168.1.2";

        private var _port:int = 3002;

        private var _successCallbacks:Dictionary;

        private var _errorCallbacks:Dictionary;

        private var _eventListener:Dictionary;

        private var _sendQueue:Array;

        private var _instanceID:String;

        private var _userid:String;

        private const _socketTimeout:int = 4;

        private var _pingTimer:Timer;

        private var _isSending:Boolean = false;

        private var _reconnectAttempts:int = 0;

        private const MAX_RECONNECT_ATTEMPTS:int = 3;

        private var _connectCallback:Function;

        public function SOCKET_API()
        {
            this._successCallbacks = new Dictionary();
            this._errorCallbacks = new Dictionary();
            this._sendQueue = [];
            super();
            _socket = new Socket();
            _socket.timeout = _socketTimeout * 1000;
            _socket.addEventListener(Event.CONNECT, onConnect);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _socket.addEventListener(Event.CLOSE, onClose);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            _pingTimer = new Timer(5000);
            _pingTimer.addEventListener(TimerEvent.TIMER, sendPing);
            _instanceID = generateInstanceID(32);
        }

        public function connect(id:String, callback:Function = null):void
        {
            _userid = id;
            _socket.connect(_host, _port);
            _connectCallback = callback;
        }

        private function onConnect(event:Event):void
        {
            trace("Connected to server");
            PLEASEWAIT.Hide();
            if (_connectCallback !== null)
            {
                trace("calling connect callback");
                _connectCallback();
                _connectCallback = null;
            }
            send(1, {}, null, onLoginError);
            processSendQueue();
            _pingTimer.start();
            _reconnectAttempts = 0;
        }

        private function onLoginError(event:IOErrorEvent = null):void
        {
            cleanup();
            GLOBAL.ErrorMessage("SOCKET.LOGIN " + event.text);
        }

        public function cleanup()
        {
            _pingTimer.stop();
            _reconnectAttempts = MAX_RECONNECT_ATTEMPTS + 1;
            clearCallbacks();
            _sendQueue = [];
            if (_socket.connected)
            {
                _socket.close();
            }
        }

        public function send(opcode:int, data:Object, successCallback:Function = null, errorCallback:Function = null):void
        {
            if (_socket.connected)
            {
                trace("Sending data to server opcode:" + opcode);
                data["_instanceid"] = _instanceID;
                data["_userid"] = _userid;
                _sendQueue.push( {
                            "opcode": opcode,
                            "data": data,
                            "successCallback": successCallback,
                            "errorCallback": errorCallback
                        });

                processSendQueue();
            }
            else if (errorCallback != null)
            {
                var errorMessage:String = "Socket is closed";
                var ioErrorEvent:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, errorMessage);
                errorCallback(ioErrorEvent);
            }
        }

        private function processSendQueue():void
        {
            if (_sendQueue.length > 0 && !_isSending)
            {
                trace("Processing send queue");
                var sendData:Object = _sendQueue.shift();
                var opcode:int = int(sendData.opcode);
                var jsonData = JSON.encode(sendData.data);
                _successCallbacks[opcode] = sendData.successCallback;
                _errorCallbacks[opcode] = sendData.errorCallback;
                _socket.writeShort(opcode);
                _socket.writeInt(jsonData.length);
                _socket.writeUTFBytes(jsonData);
                _socket.flush();

                _socket.addEventListener(Event.COMPLETE, onSendComplete);
            }
        }

        private function onSendComplete(event:Event):void
        {
            // Remove event listener and reset flag indicating that sending is complete
            _socket.removeEventListener(Event.COMPLETE, onSendComplete);
            _isSending = false;
        }

        private function onSocketData(event:ProgressEvent):void
        {
            var opcode:int = _socket.readShort();

            // Extract length of the JSON data from the next two bytes
            var dataLength:int = _socket.readInt();
            trace("Receive data from server - opcode:" + opcode + " length " + dataLength + "bytes" + _socket.bytesAvailable + ":pending:");
            // Extract JSON data from the rest of the ByteArray
            var jsonData:String = _socket.readUTFBytes(dataLength);

            var responseData:Object = JSON.decode(jsonData);
            var successCallback:Function = _successCallbacks[opcode];
            var errorCallback:Function = _errorCallbacks[opcode];
            

            if (responseData.hasOwnProperty("__error"))
            {
                if (errorCallback !== null)
                {
                    var ioErrorEvent:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Request error");
                    errorCallback(ioErrorEvent);
                }
            }
            else
            {
                if(_eventListener.hasOwnProperty(opcode)){
                    var eventCallback = _eventListener(opcode)
                    eventCallback(responseData)
                }
                if (successCallback != null)
                {
                    trace("calling callback");
                    successCallback(responseData);
                }
            }
            clearCallbacks(opcode);
            processSendQueue();
        }

        private function clearCallbacks(opcode:int = -1):void
        {
            for (var code in _successCallbacks)
            {
                if (opcode !== -1 && opcode != code)
                {
                    continue;
                }
                delete _successCallbacks[code];
                delete _errorCallbacks[code];
            }
        }

        public function addEventListener(opcode:int, callback:Function):void
        {
            _eventListener[opcode] = callback;
        }

        public function removeEventListener(opcode:int):void
        {
            if (_eventListener.hasOwnProperty(opcode))
            {
                delete _eventListener[opcode];
            }
        }

        private function sendPing(event:TimerEvent):void
        {
            send(500, {});
        }

        private function generateInstanceID(length:uint):String
        {
            var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var result:String = "";
            var i:uint = 0;
            while (i < length)
            {
                var randomIndex:uint = Math.floor(Math.random() * chars.length);
                result += chars.charAt(randomIndex);
                i++;
            }
            return result;
        }

        private function onSecurityError(error:SecurityErrorEvent):void
        {
            trace("security error", error.text);
            reconnect();
        }

        private function onIOError(event:IOErrorEvent):void
        {
            trace("Socket error: " + event.text);
            reconnect();
        }

        private function onClose(event:Event):void
        {
            trace("Socket close: " + event.toString());
            reconnect();
        }

        private function reconnect():void
        {
            _pingTimer.stop();
            trace("reconnecting", _reconnectAttempts);
            if (_reconnectAttempts < MAX_RECONNECT_ATTEMPTS)
            {
                PLEASEWAIT.Show("Reconnecting to server.");
                _reconnectAttempts++;
                _socket.connect(_host, _port);
            }
            else
            {
                for each (var errorCallback:Function in _errorCallbacks)
                {
                    if (errorCallback !== null)
                    {
                        var errorMessage:String = "Cannot reconnect to server";
                        var ioErrorEvent:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, errorMessage);
                        errorCallback(ioErrorEvent);
                    }
                }
                clearCallbacks();
                PLEASEWAIT.Hide();
                PLEASEWAIT.Show();
                GLOBAL.ErrorMessage("Socket cannot reconnect, restart game");
            }
        }
    }
}

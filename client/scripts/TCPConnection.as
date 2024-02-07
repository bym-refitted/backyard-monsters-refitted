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

public class TCPConnection
{

    private var host:String = "127.0.0.1";

    private var port:int = 3002;

    private var socket:Socket;

    private var pingTimeout:int = 10000;
    private var connecting:Boolean = false;
    private var userID:String;
    private var instanceID:String;

    private var pingTimer:Timer;
    private var checkConnectionTimer:Timer;
    private var RETRY_COUNT:int = 0; // Current retry count
    private const MAX_RETRY:int = 3; // Maximum number of reconnection attempts
    private const SOCKET_TIMEOUT:int = 5 // 12 Seconds

    public function TCPConnection()
    {
        super();

        // host = GLOBAL.socketUrl;
        // port = GLOBAL.socketPort;

        socket = new Socket();
        socket.timeout = SOCKET_TIMEOUT * 1000;
        socket.addEventListener(Event.CONNECT, onConnect);
        socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
        socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
        socket.addEventListener(Event.CLOSE, onClose);
        socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        instanceID = generateRandomString(32);

        pingTimer = new Timer(pingTimeout);
        pingTimer.addEventListener(TimerEvent.TIMER, sendPing);

        checkConnectionTimer = new Timer(1000); // 5000 milliseconds = 5 seconds
        checkConnectionTimer.addEventListener(TimerEvent.TIMER, checkConnection);

    }

    public function startConnection(id: String):void
    {
        userID = id
        connectToServer();
        checkConnectionTimer.start();
    }

    public function disconnect(): void
    {
        RETRY_COUNT = MAX_RETRY;
        checkConnectionTimer.stop()
        pingTimer.stop();
        try {
            socket.close()
        } catch(error: Error) {
            trace("cannot close socket connection")
        }
    }

    private function connectToServer():void
    {
        trace("Connecting to server retry: " + RETRY_COUNT)
        if (RETRY_COUNT <= MAX_RETRY)
        {
            if(RETRY_COUNT != 0) {
                PLEASEWAIT.Show("Reconnecting to server");
            }
            try
            {
                connecting = true;
                socket.connect(host, port);
            }
            catch (error:Error)
            {
                connecting = false;
                trace("Error connecting to the server: " + error.message);
            }
        }
        else
        {
            trace("Reached maximum retry limit for reconnection");
            PLEASEWAIT.Show("Cannot reconnect, restart game.");
        }
    }

    private function onConnect(event:Event):void
    {
        trace("Connected to the server");
        connecting = false;
        sendMessage("login:" + userID + ":" + instanceID)
        RETRY_COUNT = 0; // Reset retry count
        pingTimer.start();
        PLEASEWAIT.Hide()
    }

    private function onData(event:ProgressEvent):void
    {
        var sameInstance:String = socket.readUTFBytes(socket.bytesAvailable);
        if(sameInstance === "false") {
            GLOBAL.ErrorMessage("Instance Error");
            disconnect();
        }

        trace("Received data from the server: " + sameInstance);
    }

    private function onError(event:IOErrorEvent):void
    {
        trace("Connection error: " + event.text);
        if(!connecting) {
            pingTimer.stop();
            RETRY_COUNT++;
            connectToServer();
        }
    }

    private function onClose(event:Event):void
    {
        trace("Connection closed by the server");
        if(!connecting) {
            pingTimer.stop();
            RETRY_COUNT++;
            connectToServer();
        }
    }

    private function onSecurityError(error:SecurityErrorEvent): void
    {
        trace("security error", error.text)
        connecting = false;
        if(RETRY_COUNT >= MAX_RETRY) {
            checkConnectionTimer.stop();
            PLEASEWAIT.Hide()
            PLEASEWAIT.Show("Cannot reconnect, restart game.");
        } else {
            RETRY_COUNT++;
            connectToServer();
        }
    }


    private function sendPing(event:TimerEvent):void
    {
        sendMessage("ping:" + userID + ":" + instanceID)
    }

    private function sendMessage(message: String): void
    {
        if(socket.connected && !connecting) {
            trace("Sending message to the server");
            var pingMessage:String = message;
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes(pingMessage);
            socket.writeBytes(bytes);
            socket.flush();
        }
    }

    private function checkConnection(event:TimerEvent):void
    {
        if (!socket.connected && !connecting)
        {
            trace("Socket is not connected, attempting to reconnect...");
            RETRY_COUNT++;
            connectToServer();
        }
    }

    function generateRandomString(length:uint):String {
        var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var result:String = "";

        for (var i:uint = 0; i < length; i++) {
            var randomIndex:uint = Math.floor(Math.random() * chars.length);
            result += chars.charAt(randomIndex);
        }

        return result;
    }
}
}
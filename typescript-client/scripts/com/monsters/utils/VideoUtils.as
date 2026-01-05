package com.monsters.utils
{
   import flash.events.AsyncErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   
   public class VideoUtils
   {
      
      private static var stream:NetStream;
      
      private static var _videoURL:String;
       
      
      public function VideoUtils()
      {
         super();
      }
      
      public static function getVideoStream(param1:Video, param2:String = null) : NetStream
      {
         var _loc3_:NetConnection = new NetConnection();
         _loc3_.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
         _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         _loc3_.connect(null);
         stream = new NetStream(_loc3_);
         stream.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
         stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
         stream.client = {"onMetaData":onMetaData};
         stream.bufferTime = 0;
         if(param2)
         {
            stream.play(param2);
            _videoURL = param2;
         }
         param1.attachNetStream(stream);
         return stream;
      }
      
      private static function onMetaData(param1:*) : void
      {
      }
      
      public static function loopStream(param1:NetStream) : void
      {
         param1.addEventListener(NetStatusEvent.NET_STATUS,loopNetStream);
      }
      
      private static function netStatusHandler(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.StreamNotFound":
         }
      }
      
      private static function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
      }
      
      private static function asyncErrorHandler(param1:AsyncErrorEvent) : void
      {
      }
      
      private static function loopNetStream(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetStream.Play.Stop")
         {
            NetStream(param1.target).pause();
            NetStream(param1.target).seek(0);
            NetStream(param1.target).resume();
         }
         if(param1.info.code == "NetStream.Buffer.Empty")
         {
            stream.play(_videoURL);
         }
      }
   }
}

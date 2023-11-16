package com.smartfoxserver.v2.util
{
   import com.smartfoxserver.v2.core.SFSEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ConfigLoader extends EventDispatcher
   {
       
      
      public function ConfigLoader()
      {
         super();
      }
      
      public function loadConfig(param1:String) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onConfigLoadSuccess);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onConfigLoadFailure);
         _loc2_.load(new URLRequest(param1));
      }
      
      private function onConfigLoadSuccess(param1:Event) : void
      {
         var _loc3_:XML = null;
         var _loc4_:ConfigData = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc3_ = new XML(_loc2_.data);
         (_loc4_ = new ConfigData()).host = _loc3_.ip;
         _loc4_.port = int(_loc3_.port);
         _loc4_.udpHost = _loc3_.udpIp;
         _loc4_.udpPort = int(_loc3_.udpPort);
         _loc4_.zone = _loc3_.zone;
         if(_loc3_.debug != undefined)
         {
            _loc4_.debug = _loc3_.debug.toLowerCase() == "true" ? true : false;
         }
         if(_loc3_.useBlueBox != undefined)
         {
            _loc4_.useBlueBox = _loc3_.useBlueBox.toLowerCase() == "true" ? true : false;
         }
         if(_loc3_.httpPort != undefined)
         {
            _loc4_.httpPort = int(_loc3_.httpPort);
         }
         if(_loc3_.blueBoxPollingRate != undefined)
         {
            _loc4_.blueBoxPollingRate = int(_loc3_.blueBoxPollingRate);
         }
         var _loc5_:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_SUCCESS,{"cfg":_loc4_});
         dispatchEvent(_loc5_);
      }
      
      private function onConfigLoadFailure(param1:IOErrorEvent) : void
      {
         var _loc2_:Object = {"message":param1.text};
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.CONFIG_LOAD_FAILURE,_loc2_);
         dispatchEvent(_loc3_);
      }
   }
}

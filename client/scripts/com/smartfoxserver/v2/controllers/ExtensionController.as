package com.smartfoxserver.v2.controllers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.bitswarm.BaseController;
   import com.smartfoxserver.v2.bitswarm.BitSwarmClient;
   import com.smartfoxserver.v2.bitswarm.IMessage;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class ExtensionController extends BaseController
   {
      
      public static const KEY_CMD:String = "c";
      
      public static const KEY_PARAMS:String = "p";
       
      
      private var sfs:SmartFox;
      
      private var bitSwarm:BitSwarmClient;
      
      public function ExtensionController(param1:BitSwarmClient)
      {
         super();
         this.bitSwarm = param1;
         this.sfs = param1.sfs;
      }
      
      override public function handleMessage(param1:IMessage) : void
      {
         if(this.sfs.debug)
         {
            log.info(param1);
         }
         var _loc2_:ISFSObject = param1.content;
         var _loc3_:Object = {};
         _loc3_.cmd = _loc2_.getUtfString(KEY_CMD);
         _loc3_.params = _loc2_.getSFSObject(KEY_PARAMS);
         if(param1.isUDP)
         {
            _loc3_.packetId = param1.packetId;
         }
         this.sfs.dispatchEvent(new SFSEvent(SFSEvent.EXTENSION_RESPONSE,_loc3_));
      }
   }
}

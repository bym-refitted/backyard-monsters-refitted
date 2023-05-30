package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class PublicMessageRequest extends GenericMessageRequest
   {
       
      
      public function PublicMessageRequest(param1:String, param2:ISFSObject = null, param3:Room = null)
      {
         super();
         _type = GenericMessageType.PUBLIC_MSG;
         _message = param1;
         _room = param3;
         _params = param2;
      }
   }
}

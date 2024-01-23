package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class PrivateMessageRequest extends GenericMessageRequest
   {
       
      
      public function PrivateMessageRequest(param1:String, param2:int, param3:ISFSObject = null)
      {
         super();
         _type = GenericMessageType.PRIVATE_MSG;
         _message = param1;
         _recipient = param2;
         _params = param3;
      }
   }
}

package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   
   public class AdminMessageRequest extends GenericMessageRequest
   {
       
      
      public function AdminMessageRequest(param1:String, param2:MessageRecipientMode, param3:ISFSObject = null)
      {
         super();
         if(param2 == null)
         {
            throw new ArgumentError("RecipientMode cannot be null!");
         }
         _type = GenericMessageType.ADMING_MSG;
         _message = param1;
         _params = param3;
         _recipient = param2.target;
         _sendMode = param2.mode;
      }
   }
}

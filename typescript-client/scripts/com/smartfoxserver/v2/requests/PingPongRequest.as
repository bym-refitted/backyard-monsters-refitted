package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   
   public class PingPongRequest extends BaseRequest
   {
       
      
      public function PingPongRequest()
      {
         super(BaseRequest.PingPong);
      }
      
      override public function execute(param1:SmartFox) : void
      {
      }
      
      override public function validate(param1:SmartFox) : void
      {
      }
   }
}

package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.exceptions.SFSError;
   import com.smartfoxserver.v2.logging.Logger;
   
   public class BaseController implements IController
   {
       
      
      protected var _id:int = -1;
      
      protected var log:Logger;
      
      public function BaseController()
      {
         super();
         this.log = Logger.getInstance();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         if(this._id == -1)
         {
            this._id = param1;
            return;
         }
         throw new SFSError("Controller ID is already set: " + this._id + ". Can\'t be changed at runtime!");
      }
      
      public function handleMessage(param1:IMessage) : void
      {
         trace("System controller got request: " + param1);
      }
   }
}

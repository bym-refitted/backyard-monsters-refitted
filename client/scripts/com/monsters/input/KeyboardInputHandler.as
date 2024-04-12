package com.monsters.input
{
   import com.cc.screenshot.screenshot;
   import config.singletonlock.SingletonLock;
   import flash.events.KeyboardEvent;
   
   public class KeyboardInputHandler
   {
      
      protected static var s_Instance:KeyboardInputHandler = null;
      
      private static var keyunlock:int = 0;
       
      
      public function KeyboardInputHandler(param1:SingletonLock)
      {
         super();
      }
      
      protected static function get singletonLock() : SingletonLock
      {
         return new SingletonLock();
      }
      
      public static function get instance() : KeyboardInputHandler
      {
         s_Instance ||= new KeyboardInputHandler(singletonLock);
         return s_Instance;
      }
      
      public function OnKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.shiftKey)
         {
            if(keyunlock == 0 && param1.keyCode == 38)
            {
               keyunlock = 1;
            }
            else if(keyunlock == 1 && param1.keyCode == 40)
            {
               keyunlock = 2;
            }
            else if(keyunlock == 2 && param1.keyCode == 37)
            {
               keyunlock = 3;
            }
            else if(keyunlock == 3 && param1.keyCode == 39)
            {
               screenshot.Show();
            }
            else
            {
               keyunlock = 0;
            }
         }
      }
   }
}

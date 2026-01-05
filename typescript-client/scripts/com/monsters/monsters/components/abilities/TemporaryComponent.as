package com.monsters.monsters.components.abilities
{
   import com.monsters.debug.Console;
   import com.monsters.monsters.components.Component;
   
   public class TemporaryComponent extends Component
   {
       
      
      private var m_temporaryComponent:Component;
      
      private var m_durationInSeconds:Number;
      
      private var m_timeToRemove:Number;
      
      private static var s_cachedTimestamp:Number = 0;
      
      private static var s_lastCacheFrame:int = -1;
      
      public function TemporaryComponent(param1:Component, param2:Number)
      {
         super();
         this.m_temporaryComponent = param1;
         this.m_durationInSeconds = param2;
         this.m_timeToRemove = GLOBAL.Timestamp() + param2;
         if(this.m_durationInSeconds <= 1)
         {
            Console.warning("You tried to add a component(" + param1 + ") that will be instatly removed... why would you do that?");
         }
      }
      
      override protected function onUnregister() : void
      {
         owner.removeComponent(this.m_temporaryComponent);
      }
      
      override protected function onRegister() : void
      {
         owner.addComponent(this.m_temporaryComponent);
      }
      
      override public function tick(param1:int = 1) : void
      {
         // Cache timestamp to avoid repeated GLOBAL.Timestamp() calls
         // Only update cache once per frame, reuse for all TemporaryComponent instances
         if(s_lastCacheFrame != GLOBAL._frameNumber)
         {
            s_cachedTimestamp = GLOBAL.Timestamp();
            s_lastCacheFrame = GLOBAL._frameNumber;
         }
         
         if(s_cachedTimestamp >= this.m_timeToRemove)
         {
            owner.removeComponent(this);
         }
      }
   }
}

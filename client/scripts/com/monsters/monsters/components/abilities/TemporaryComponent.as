package com.monsters.monsters.components.abilities
{
   import com.monsters.debug.Console;
   import com.monsters.monsters.components.Component;
   
   public class TemporaryComponent extends Component
   {
       
      
      private var m_temporaryComponent:Component;
      
      private var m_durationInSeconds:Number;
      
      private var m_timeToRemove:Number;
      
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
         if(GLOBAL.Timestamp() >= this.m_timeToRemove)
         {
            owner.removeComponent(this);
         }
      }
   }
}

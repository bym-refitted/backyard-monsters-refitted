package com.monsters.monsters.components
{
   import com.monsters.interfaces.ITickable;
   import com.monsters.monsters.MonsterBase;
   
   public class Component implements ITickable
   {
       
      
      public var owner:MonsterBase;
      
      public var name:String;
      
      public var priority:uint;
      
      public function Component()
      {
         super();
      }
      
      public function register(param1:MonsterBase, param2:String = null) : void
      {
         if(!this.owner)
         {
         }
         if(!param2 || param2 == "")
         {
            param2 = String(this);
         }
         this.name = param2;
         this.owner = param1;
         this.onRegister();
      }
      
      public function unregister() : void
      {
         if(!this.owner)
         {
            return;
         }
         this.onUnregister();
         this.owner = null;
         this.name = null;
      }
      
      protected function onUnregister() : void
      {
      }
      
      protected function onRegister() : void
      {
      }
      
      public function tick(param1:int = 1) : void
      {
      }
      
      public function destoy() : void
      {
      }
      
      public function clone() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.name = this.name;
         _loc1_.priority = this.priority;
         _loc1_.owner = this.owner;
         return _loc1_;
      }
   }
}

package com.monsters.configs
{
   public class BYMDevConfig extends BYMConfig
   {
       
      
      public function BYMDevConfig(param1:InstanceEnforcer)
      {
         super(enforcerInstance);
      }
      
      public static function get instance() : BYMConfig
      {
         BYMConfig._instance = BYMConfig._instance || new BYMDevConfig(new InstanceEnforcer());
         return _instance;
      }
   }
}

final class InstanceEnforcer
{
    
   
   public function InstanceEnforcer()
   {
      super();
   }
}

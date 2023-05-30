package com.monsters.configs
{
   public class BYMConfig
   {
      
      public static const k_sLOCAL_MODE_TRUNK:int = 1;
      
      public static const k_sLOCAL_MODE_KONG:int = 2;
      
      public static const k_sLOCAL_MODE_VIXTEST:int = 3;
      
      public static const k_sLOCAL_MODE_VIXSTAGE:int = 4;
      
      public static const k_sLOCAL_MODE_INF_TRUNK:int = 5;
      
      public static const k_sLOCAL_MODE_LIVE:int = 6;
      
      public static const k_sLOCAL_MODE_VIXLIVE:int = 7;
      
      public static const k_sLOCAL_MODE_ALEX:int = 8;
      
      public static const k_sLOCAL_MODE_NICK:int = 9;
      
      public static const k_sLOCAL_MODE_KONGDEV:int = 10;
      
      public static const k_sLOCAL_MODE_KONGSTAGE:int = 11;
      
      public static const k_sLOCAL_MODE_PREVIEW:int = 12;
      
      public static const k_sLOCAL_MODE_STAGE:int = 13;
      
      public static const k_sVICTORY_THRESHOLD:Number = 90;
      
      public static const k_sMAX_FORTIFICATION_LEVEL:int = 4;
      
      protected static var _instance:com.monsters.configs.BYMConfig;
       
      
      public function BYMConfig(param1:InstanceEnforcer)
      {
         super();
      }
      
      public static function get instance() : com.monsters.configs.BYMConfig
      {
         _instance = _instance || new com.monsters.configs.BYMConfig(new InstanceEnforcer());
         return _instance;
      }
      
      public function get RENDERER_ON() : Boolean
      {
         return false;
      }
      
      public function get OPTIMIZED_SHADOWS() : Boolean
      {
         return false;
      }
      
      public function get AUTOBANK_FIX() : Boolean
      {
         return true;
      }
      
      public function get USE_CLIENT_WITH_CALLBACK() : Boolean
      {
         return false;
      }
      
      public function get BRUKKARG_WAR_ON() : Boolean
      {
         return true;
      }
      
      public function get INVITE_BUTTON() : Boolean
      {
         return false;
      }
      
      public function get LOCAL_MODE() : int
      {
         return k_sLOCAL_MODE_TRUNK;
      }
      
      protected function get enforcerInstance() : InstanceEnforcer
      {
         return new InstanceEnforcer();
      }
      
      public function get fbData() : Object
      {
         return null;
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

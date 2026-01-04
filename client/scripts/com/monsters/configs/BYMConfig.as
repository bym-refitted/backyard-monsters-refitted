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
      
      protected static var _instance:BYMConfig;
       
      
      public function BYMConfig(param1:InstanceEnforcer)
      {
         super();
      }
      
      public static function get instance() : BYMConfig
      {
         _instance ||= new BYMConfig(new InstanceEnforcer());
         return _instance;
      }
      
      public function get RENDERER_ON() : Boolean
      {
         // Originally set to false
         // Apparently, it is more performant to have this enabled
         // RENDERER_ON true = graphics are rendered using a bitmap approach
         // RENDERER_ON false = graphics are rendered using a vector approach / display list approach
         return true;
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
         return true;
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

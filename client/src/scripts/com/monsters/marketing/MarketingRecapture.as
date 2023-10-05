package com.monsters.marketing
{
   public class MarketingRecapture
   {
      
      public static const k_POPUP_GORGO:uint = 1;
      
      public static const k_POPUP_DRULL:uint = 2;
      
      public static const k_POPUP_FOMOR:uint = 3;
      
      public static const k_POPUP_KORATH:uint = 4;
      
      protected static var s_instance:com.monsters.marketing.MarketingRecapture;
       
      
      protected var m_champPopup:uint;
      
      public function MarketingRecapture(param1:InstanceEnforcer)
      {
         super();
         if(!param1)
         {
            throw new Error("MarketingRecapture is a Singleton, use instance.");
         }
      }
      
      public static function get instance() : com.monsters.marketing.MarketingRecapture
      {
         s_instance = s_instance || new com.monsters.marketing.MarketingRecapture(new InstanceEnforcer());
         return s_instance;
      }
      
      public function get champPopup() : uint
      {
         return this.m_champPopup;
      }
      
      public function importData(param1:String) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:Object = JSON.decode(param1);
         if(_loc2_.champpopup)
         {
            this.m_champPopup = uint(_loc2_.champpopup);
         }
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

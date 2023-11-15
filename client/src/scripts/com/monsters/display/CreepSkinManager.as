package com.monsters.display
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class CreepSkinManager
   {
      
      private static var s_Instance:CreepSkinManager = null;
       
      
      private var m_CreepSkinPairs:Dictionary;
      
      public function CreepSkinManager(param1:SingletonLock)
      {
         super();
         s_Instance = this;
         this.m_CreepSkinPairs = new Dictionary();
      }
      
      public static function get instance() : CreepSkinManager
      {
         return !!s_Instance ? s_Instance : new CreepSkinManager(new SingletonLock());
      }
      
      public function SetupSkins(param1:String) : void
      {
         SPRITES.SetupSprite(param1);
         if(this.m_CreepSkinPairs[param1] != null)
         {
            SPRITES.SetupSprite(this.m_CreepSkinPairs[param1]);
         }
      }
      
      public function SetSkin(param1:String, param2:String) : void
      {
         if(param2 != null)
         {
            SPRITES.SetupSprite(param2);
         }
         this.m_CreepSkinPairs[param1] = param2;
      }
      
      public function GetSprite(param1:BitmapData, param2:String, param3:String, param4:int, param5:int = 0, param6:int = -1, param7:String = null) : int
      {
         var _loc8_:String = !!param7 ? param7 : (!!this.m_CreepSkinPairs[param2] ? String(this.m_CreepSkinPairs[param2]) : param2);
         return SPRITES.GetSprite(param1,_loc8_,param3,param4,param5,param6);
      }
   }
}

class SingletonLock
{
    
   
   public function SingletonLock()
   {
      super();
   }
}

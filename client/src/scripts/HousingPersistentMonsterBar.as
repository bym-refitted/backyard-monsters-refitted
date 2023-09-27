package
{
   public final class HousingPersistentMonsterBar extends HousingPersistentMonsterBar_CLIP
   {
      
      public static const k_monsterBarDisplayBarWidth:int = 175;
      
      public static const k_HealFrame:int = 2;
      
      public static const k_NormalFrame:int = 1;
       
      
      public var m_creatureID:String;
      
      public function HousingPersistentMonsterBar(param1:String)
      {
         super();
         this.m_creatureID = param1;
      }
      
      public function updateTimer() : void
      {
         if(bFinish)
         {
            bFinish.Setup(KEYS.Get("btn_housing_finish",{"v1":this.getTimeCost()}));
         }
         var _loc1_:int = this.calcTimeLeft();
         tHealStatusText.htmlText = "<b>" + GLOBAL.ToTime(_loc1_) + "</b>";
      }
      
      public function calcTimeLeft() : int
      {
         return GLOBAL.player.getHighestTimeHealingUsingNumberOfHousing(this.m_creatureID);
      }
      
      public function getTimeCost(param1:Boolean = false) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = GLOBAL.player.getSecsTillDoneByID(this.m_creatureID,param1);
         if(_loc3_ == 0)
         {
            return 0;
         }
         _loc2_ = STORE.GetTimeCost(_loc3_,false) * GLOBAL.ABTestHealingTimeShinyMod();
         return Math.max(_loc2_,1);
      }
      
      public function getResourceCostInShiny() : int
      {
         if(currentFrame == k_HealFrame || m_healthBar.mcBar.width == k_monsterBarDisplayBarWidth)
         {
            return 0;
         }
         return GLOBAL.player.getResourceCostInShinyByID(this.m_creatureID);
      }
   }
}

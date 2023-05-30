package com.monsters.replayableEvents.looting.wotc.rewards
{
   import com.cc.utils.SecNum;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.rewarding.Reward;
   
   public class KorathReward extends Reward
   {
      
      public static const k_REWARD_ID:String = "KorathReward";
      
      private static const k_KORATH_TYPE:String = "G4";
       
      
      public function KorathReward()
      {
         super();
      }
      
      override public function set value(param1:Number) : void
      {
         if(param1 < _value)
         {
            print("You are trying to lower your Korath powerlevel reward, you\'re not supposed to do that");
            return;
         }
         super.value = param1;
      }
      
      override protected function onApplication() : void
      {
         CHAMPIONCAGE._guardians[k_KORATH_TYPE].props.powerLevel = _value;
         var _loc1_:ChampionBase = CREATURES.getGuardian(4);
         if(_loc1_)
         {
            _loc1_._powerLevel.Set(_value);
         }
         var _loc2_:Object = CHAMPIONCAGE.GetGuardianData(4);
         if(_loc2_)
         {
            _loc2_.pl = new SecNum(_value);
         }
      }
      
      override public function removed() : void
      {
         CHAMPIONCAGE._guardians[k_KORATH_TYPE].props.powerLevel = 0;
         var _loc1_:CHAMPIONCAGE = GLOBAL._bCage;
         if(Boolean(_loc1_) && Boolean(CHAMPIONCAGE.GetGuardianData(4)))
         {
            _loc1_.RemoveGuardian(4);
         }
         var _loc2_:Object = CHAMPIONCAGE.GetGuardianData(4);
         if(_loc2_)
         {
            _loc2_.pl = new SecNum(0);
         }
      }
      
      override public function reset() : void
      {
      }
      
      override public function canBeApplied() : Boolean
      {
         return !(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || BASE.isInfernoMainYardOrOutpost);
      }
      
      override public function importData(param1:Object) : void
      {
         super.importData(param1);
      }
      
      override public function exportData() : Object
      {
         if(_value == 0)
         {
            print("you\'re trying to save a blank korath reward, why?");
         }
         return super.exportData();
      }
   }
}

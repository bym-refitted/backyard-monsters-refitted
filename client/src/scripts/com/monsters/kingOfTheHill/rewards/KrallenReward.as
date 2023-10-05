package com.monsters.kingOfTheHill.rewards
{
   import com.cc.utils.SecNum;
   import com.monsters.debug.Console;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.champions.Krallen;
   import com.monsters.rewarding.Reward;
   
   public class KrallenReward extends Reward
   {
      
      public static const ID:String = "krallenReward";
       
      
      public function KrallenReward()
      {
         super();
      }
      
      override protected function onApplication() : void
      {
         this.updateKrallenStatus(_value);
      }
      
      override public function removed() : void
      {
         var _loc1_:CHAMPIONCAGE = GLOBAL._bCage;
         if(Boolean(CHAMPIONCAGE.GetGuardianData(Krallen.TYPE)) && Boolean(_loc1_))
         {
            _loc1_.RemoveGuardian(Krallen.TYPE);
         }
      }
      
      override public function reset() : void
      {
      }
      
      override public function canBeApplied() : Boolean
      {
         return GLOBAL.isAtHome();
      }
      
      private function updateKrallenStatus(param1:uint) : void
      {
         var _loc3_:CHAMPIONCAGE = null;
         var _loc2_:ChampionBase = CREATURES.getGuardian(Krallen.TYPE);
         param1 = Math.min(param1,Krallen.MAX_POWERLEVEL);
         if(_loc2_)
         {
            _loc2_._powerLevel = new SecNum(param1);
         }
         else
         {
            _loc3_ = GLOBAL._bCage;
            if(_loc3_)
            {
               _loc3_.SpawnGuardian(1,0,0,Krallen.TYPE,CHAMPIONCAGE.GetGuardianProperty("G" + Krallen.TYPE,1,"health"),"",0,param1);
            }
            else
            {
               Console.warning("tried to create krallen but you dont have a champion cage");
            }
         }
      }
   }
}

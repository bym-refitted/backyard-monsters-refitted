package com.monsters.kingOfTheHill.rewards
{
   import com.monsters.debug.Console;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.champions.Krallen;
   import com.monsters.rewarding.Reward;
   
   public class KrallenBuffReward extends Reward
   {
      
      public static const ID:String = "krallenBuffReward";
       
      
      private const _MAX_BUFF_LEVEL:uint = 5;
      
      public function KrallenBuffReward()
      {
         super();
      }
      
      override public function set value(param1:Number) : void
      {
         param1 = Math.min(param1,this._MAX_BUFF_LEVEL);
         super.value = param1;
      }
      
      override protected function onApplication() : void
      {
         this.updateChampionBuff(_value);
      }
      
      override public function removed() : void
      {
         this.updateChampionBuff(0);
      }
      
      override public function canBeApplied() : Boolean
      {
         return GLOBAL.isAtHome();
      }
      
      private function updateChampionBuff(param1:uint) : void
      {
         var _loc2_:ChampionBase = CREATURES.getGuardian(Krallen.TYPE);
         if(_loc2_)
         {
            _loc2_.levelSet(param1);
            _loc2_.export();
         }
         else
         {
            Console.warning("You are trying to setup the Krallen buff but you dont own a Krallen");
         }
      }
   }
}

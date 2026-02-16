package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class AOEHealOnDeath extends AOEDamageOnDeath
   {
       
      
      protected var m_healAmount:Number;
      
      public function AOEHealOnDeath(radiusOuter:uint = 200, healAmount:Number = 100, maxTargets:uint = 4294967295)
      {
         super(radiusOuter,Targeting.k_TARGETS_ALL,maxTargets);
         this.m_healAmount = healAmount;
      }
      
      override protected function dealAOEDamage(param1:Number, initialTarget:IAttackable = null) : void
      {
         var radius1:Number = NaN;
         var radius2:Number = NaN;
         var fireballMc:MovieClip = null;
         var rand:Number = NaN;
         var _loc7_:Number = NaN;
         var rand2:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;

         // below code references an unknown property m_radius. Assuming it should be m_radiusOuter, but the fireballMc code is broken and does not influence the fireballMc in any way, so it is left as is.
         // radius1 = m_radius;
         // radius2 = m_radius;

         super.dealAOEDamage(this.m_healAmount, initialTarget);
         var i:int = 0;
         while(i < 10)
         {
            fireballMc = new FIREBALL_CLIP();
            MAP._FIREBALLS.addChild(fireballMc);
            fireballMc.gotoAndStop(2);
            fireballMc.x = owner._mc.x;
            fireballMc.y = owner._mc.y;

            // Below code is broken and does not influence the fireballMc.

            // rand = Math.random() * 2 - 1;
            // _loc7_ = fireballMc.x + rand * radius1;
            // rand2 = Math.random() * 2 - 1;
            // _loc9_ = rand * -1 * radius2;
            // _loc10_ = _loc9_ + radius2 * 1.5;
            i++;
         }
      }
      
      private function removeFireball(param1:DisplayObject) : void
      {
         MAP._FIREBALLS.removeChild(param1);
      }
   }
}

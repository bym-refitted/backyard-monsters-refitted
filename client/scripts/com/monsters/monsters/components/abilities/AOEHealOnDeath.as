package com.monsters.monsters.components.abilities
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class AOEHealOnDeath extends AOEDamageOnDeath
   {
       
      
      protected var m_healAmount:Number;
      
      public function AOEHealOnDeath(param1:uint = 200, param2:Number = 100, param3:uint = 4294967295)
      {
         super(param1,Targeting.k_TARGETS_ALL,param3);
         this.m_healAmount = param2;
      }
      
      override protected function dealAOEDamage(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:MovieClip = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc2_ = m_radius;
         _loc3_ = m_radius;
         super.dealAOEDamage(this.m_healAmount);
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _loc5_ = new FIREBALL_CLIP();
            MAP._FIREBALLS.addChild(_loc5_);
            _loc5_.gotoAndStop(2);
            _loc5_.x = owner._mc.x;
            _loc5_.y = owner._mc.y;
            _loc6_ = Math.random() * 2 - 1;
            _loc7_ = _loc5_.x + _loc6_ * _loc2_;
            _loc8_ = Math.random() * 2 - 1;
            _loc10_ = (_loc9_ = _loc6_ * -1 * _loc3_) + _loc3_ * 1.5;
            _loc4_++;
         }
      }
      
      private function removeFireball(param1:DisplayObject) : void
      {
         MAP._FIREBALLS.removeChild(param1);
      }
   }
}

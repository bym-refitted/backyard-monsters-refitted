package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.components.Component;
   import flash.geom.Point;
   
   public class Blink extends Component
   {
       
      
      protected var m_maxBlinkPoints:int;
      
      protected var m_blinkDistance:int;
      
      protected var m_blinkPoints:int;
      
      public function Blink(param1:int = 10)
      {
         super();
         this.m_maxBlinkPoints = param1;
      }
      
      private function isWithinBlinkRange() : Boolean
      {
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:Array = owner._waypoints;
         var _loc2_:uint = _loc1_.length;
         var _loc3_:int = owner.powerUpLevel();
         if(owner._hasPath && _loc2_ != 0 && _loc2_ < _loc3_ * 5)
         {
            _loc5_ = (_loc4_ = owner._tmpPoint.subtract(_loc1_[_loc2_ - 1])).x * _loc4_.x + _loc4_.y * _loc4_.y;
            _loc6_ = _loc3_ * 150;
            _loc6_ *= _loc6_;
            if(_loc5_ <= _loc6_)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Point = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         if(!owner._atTarget && this.isWithinBlinkRange())
         {
            _loc2_ = owner._waypoints;
            _loc3_ = new Point(owner.x,owner.y);
            _loc4_ = owner._hasPath;
            if(this.m_blinkPoints)
            {
               if(this.m_blinkPoints > 0 && _loc4_)
               {
                  if(_loc2_.length > 0)
                  {
                     _loc5_ = int(_loc2_.length - 1);
                     _loc6_ = _loc3_.subtract(_loc2_[_loc2_.length - 1]).length;
                     owner._tmpPoint = Point.interpolate(_loc3_,_loc2_[_loc5_],1 - this.m_blinkDistance / _loc6_);
                     --this.m_blinkPoints;
                     if(this.m_blinkPoints <= 0)
                     {
                        this.stopBlink();
                        _loc2_ = [];
                     }
                  }
                  else
                  {
                     this.stopBlink();
                  }
               }
               else
               {
                  this.stopBlink();
               }
            }
            else if(_loc4_ && _loc2_.length > 0)
            {
               this.startBlink(_loc3_.subtract(_loc2_[_loc2_.length - 1]).length / 10);
            }
         }
         else if(this.m_blinkPoints)
         {
            this.stopBlink();
         }
      }
      
      private function startBlink(param1:Number) : void
      {
         this.m_blinkPoints = this.m_maxBlinkPoints;
         this.m_blinkDistance = param1;
         owner.graphic.alpha = 0.3;
         ++owner.targetableStatus;
         print("starting blink");
      }
      
      private function stopBlink() : void
      {
         owner._atTarget = true;
         owner.graphic.alpha = 1;
         this.m_blinkPoints = 0;
         --owner.targetableStatus;
         print("stopping blink");
      }
   }
}

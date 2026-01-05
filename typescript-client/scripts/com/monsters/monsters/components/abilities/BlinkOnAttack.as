package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.IAttackingComponent;
   import flash.geom.Point;
   
   public class BlinkOnAttack extends Component implements IAttackingComponent
   {
       
      
      protected var m_attacksToBlink:uint;
      
      protected var m_maxBlinkDistance:uint;
      
      protected var m_maxBlinkPoints:int;
      
      protected var m_attacks:uint;
      
      protected var m_blinkTarget:ITargetable;
      
      protected var m_blinkDistance:int;
      
      protected var m_blinkPoints:int;
      
      public function BlinkOnAttack(param1:uint = 3, param2:uint = 200, param3:int = 10)
      {
         super();
         this.m_maxBlinkPoints = param3;
         this.m_attacksToBlink = param1;
         this.m_maxBlinkDistance = param2;
      }
      
      override public function tick(param1:int = 1) : void
      {
         if(this.isBlinking())
         {
            this.tickBlink();
         }
      }
      
      private function tickBlink() : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc1_:Array = owner._waypoints;
         var _loc2_:Point = new Point(owner.x,owner.y);
         var _loc3_:Boolean = owner._hasPath;
         if(this.m_blinkPoints)
         {
            if(_loc3_ && Boolean(_loc1_.length))
            {
               _loc4_ = int(_loc1_.length - 1);
               _loc5_ = _loc2_.subtract(_loc1_[_loc1_.length - 1]).length;
               owner._tmpPoint = Point.interpolate(_loc2_,_loc1_[_loc4_],1 - this.m_blinkDistance / _loc5_);
               --this.m_blinkPoints;
               if(this.m_blinkPoints <= 0)
               {
                  this.stopBlink();
                  _loc1_ = [];
               }
            }
            else
            {
               this.stopBlink();
            }
         }
         else if(_loc3_ && _loc1_.length > 0)
         {
            this.startBlink(_loc2_.subtract(_loc1_[_loc1_.length - 1]).length / 10);
         }
      }
      
      private function startBlink(param1:Object) : void
      {
         this.m_blinkDistance = param1.dist;
         this.m_blinkTarget = param1.creep;
         owner.WaypointTo(new Point(this.m_blinkTarget.x,this.m_blinkTarget.y),this.m_blinkTarget is BFOUNDATION ? this.m_blinkTarget as BFOUNDATION : null);
         this.m_blinkPoints = this.m_maxBlinkPoints;
         owner.graphic.alpha = 0.3;
         ++owner.targetableStatus;
         this.m_attacks = 0;
      }
      
      private function stopBlink() : void
      {
         owner._atTarget = true;
         owner.graphic.alpha = 1;
         this.m_blinkPoints = 0;
         this.m_blinkDistance = 0;
         this.m_blinkTarget = null;
         --owner.targetableStatus;
      }
      
      public function onAttack(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         ++this.m_attacks;
         if(this.m_attacks >= this.m_attacksToBlink)
         {
            this.attemptBlink();
         }
         return param2;
      }
      
      private function attemptBlink() : void
      {
         var _loc1_:Object = null;
         if(!this.isBlinking())
         {
            _loc1_ = this.getNewBlinkTarget();
            if(_loc1_)
            {
               this.startBlink(_loc1_);
            }
         }
      }
      
      private function getNewBlinkTarget() : Object
      {
         var _loc3_:int = 0;
         var _loc1_:Array = Targeting.getBuildingsInRange(this.m_maxBlinkDistance,new Point(owner.x,owner.y));
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].creep == owner._targetBuilding)
            {
               _loc1_.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(_loc1_.length > 0)
         {
            _loc3_ = Math.floor(Math.random() * (_loc1_.length - 1));
            return _loc1_[_loc3_];
         }
         return null;
      }
      
      public function isBlinking() : Boolean
      {
         return this.m_blinkPoints != 0;
      }
   }
}

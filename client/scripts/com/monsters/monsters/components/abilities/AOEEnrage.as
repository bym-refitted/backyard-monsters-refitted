package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import flash.geom.Point;
   
   public class AOEEnrage extends Component
   {
       
      
      private var m_radius:uint;
      
      private var m_duration:Number;
      
      private var m_speedMultiplier:Number;
      
      private var m_armorMultiplier:Number;
      
      private var m_enragedFriends:Vector.<MonsterBase>;
      
      private var m_targetFlags:int;
      
      private var m_rangeCheckCounter:int = 0;
      
      private static const RANGE_CHECK_INTERVAL:int = 30;
      
      public function AOEEnrage(param1:uint, param2:Number, param3:Number, param4:Number = 0)
      {
         super();
         this.m_radius = param1;
         this.m_duration = param4;
         this.m_speedMultiplier = param2;
         this.m_armorMultiplier = param3;
         this.m_enragedFriends = new Vector.<MonsterBase>();
      }
      
      override protected function onRegister() : void
      {
         this.m_targetFlags = Targeting.getFriendlyFlag(owner) | Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_FLYING | Targeting.k_TARGETS_INVISIBLE;
      }
      
      override protected function onUnregister() : void
      {
         this.removeEnrageFromOutOfRangeFriendlies();
      }
      
      private function getFriendliesInRange() : Vector.<MonsterBase>
      {
         var _loc4_:* = undefined;
         var _loc1_:Array = Targeting.getTargetsInRange(this.m_radius,new Point(owner.x,owner.y),this.m_targetFlags);
         var _loc2_:Vector.<MonsterBase> = new Vector.<MonsterBase>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if((_loc4_ = _loc1_[_loc3_].creep) is MonsterBase && _loc4_ != owner)
            {
               _loc2_.push(_loc4_ as MonsterBase);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function tick(param1:int = 1) : void
      {
         // Only check range every 30 ticks instead of every tick
         // This reduces expensive range calculations from 60fps to 2fps with no gameplay impact
         this.m_rangeCheckCounter += param1;
         
         if(this.m_rangeCheckCounter >= RANGE_CHECK_INTERVAL)
         {
            this.m_rangeCheckCounter = 0;
            
            var _loc2_:Vector.<MonsterBase> = this.getFriendliesInRange();
            if(owner.inBattleState)
            {
               this.addEnrageToFriendliesInRange(_loc2_);
               this.removeEnrageFromOutOfRangeFriendlies(_loc2_);
            }
            else
            {
               this.removeEnrageFromOutOfRangeFriendlies();
            }
         }
      }
      
      private function addEnrageToFriendliesInRange(param1:Vector.<MonsterBase>) : void
      {
         var _loc3_:MonsterBase = null;
         var _loc4_:Component = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(!(_loc4_ = _loc3_.getComponentByName(name)))
            {
               _loc3_.addComponent(new Enrage(this.m_speedMultiplier,this.m_armorMultiplier),name);
               this.m_enragedFriends.push(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function removeEnrageFromOutOfRangeFriendlies(param1:Vector.<MonsterBase> = null) : void
      {
         var _loc3_:MonsterBase = null;
         var _loc4_:Component = null;
         if(!param1)
         {
            param1 = new Vector.<MonsterBase>();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.m_enragedFriends.length)
         {
            _loc3_ = this.m_enragedFriends[_loc2_];
            if((Boolean(_loc4_ = _loc3_.getComponentByName(name))) && param1.indexOf(_loc3_) < 0)
            {
               _loc3_.removeComponent(_loc4_);
               this.m_enragedFriends.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
   }
}

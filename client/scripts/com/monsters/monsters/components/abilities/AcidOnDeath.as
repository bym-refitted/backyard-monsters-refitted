package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import flash.events.Event;
   
   public class AcidOnDeath extends Component
   {
       
      
      private var m_radius:uint;
      
      private var m_damage:Number;
      
      private var m_duration:uint;
      
      private var m_acidPool:AcidPool;
      
      public function AcidOnDeath(param1:uint, param2:Number, param3:uint)
      {
         super();
         this.m_radius = param1;
         this.m_damage = param2;
         this.m_duration = param3;
      }
      
      public function set damage(param1:Number) : void
      {
         this.m_damage = param1;
         if(this.m_acidPool)
         {
            this.m_acidPool.damage = param1;
         }
      }
      
      override protected function onRegister() : void
      {
         owner.addEventListener(MonsterBase.k_DEATH_EVENT,this.onDeath);
      }
      
      override protected function onUnregister() : void
      {
         owner.removeEventListener(MonsterBase.k_DEATH_EVENT,this.onDeath);
      }
      
      protected function onDeath(param1:Event = null) : void
      {
         this.addAcidPool();
      }
      
      private function addAcidPool() : void
      {
         this.m_acidPool = new AcidPool(owner.x,owner.y,this.m_damage,this.m_radius);
         this.m_acidPool.timeActivated = GLOBAL.Timestamp();
         MAP._CREEPSMC.addChild(this.m_acidPool.graphic);
         GLOBAL.addTickable(this);
      }
      
      private function removeAcidPool() : void
      {
         MAP._CREEPSMC.removeChild(this.m_acidPool.graphic);
         this.m_acidPool = null;
         GLOBAL.removeTickable(this);
      }
      
      override public function tick(param1:int = 1) : void
      {
         if(this.m_acidPool)
         {
            this.m_acidPool.tick(param1);
            if(GLOBAL.Timestamp() - this.m_acidPool.timeActivated >= this.m_duration)
            {
               this.removeAcidPool();
            }
         }
      }
   }
}

import com.monsters.interfaces.IAttackable;
import com.monsters.interfaces.ITargetable;
import com.monsters.interfaces.ITickable;
import com.monsters.monsters.IComponentOwner;
import com.monsters.monsters.MonsterBase;
import com.monsters.monsters.components.statusEffects.AcidStatusEffect;
import flash.display.Shape;
import flash.geom.Point;

class AcidPool implements ITickable, ITargetable
{
    
   
   public var timeActivated:uint;
   
   private var m_radius:uint;
   
   private var m_damage:Number;
   
   private var m_y:Number;
   
   private var m_x:Number;
   
   private var m_graphic:Shape;
   
   public function AcidPool(param1:Number, param2:Number, param3:Number, param4:uint)
   {
      super();
      this.m_radius = param4;
      this.m_damage = param3;
      this.m_y = param2;
      this.m_x = param1;
      this.m_graphic = new Shape();
      this.m_graphic.x = this.m_x;
      this.m_graphic.y = this.m_y;
      this.m_graphic.graphics.beginFill(65280,0.5);
      this.m_graphic.graphics.drawCircle(0,0,this.m_radius);
      this.m_graphic.graphics.endFill();
   }
   
   public function tick(param1:int = 1) : void
   {
      var _loc4_:IAttackable = null;
      var _loc5_:IComponentOwner = null;
      var _loc2_:Array = Targeting.getAllBUTTargetsInRange(this.m_radius,new Point(this.m_x,this.m_y),Targeting.k_TARGETS_FLYING);
      var _loc3_:int = 0;
      while(_loc3_ < _loc2_.length)
      {
         (_loc4_ = _loc2_[_loc3_].creep).modifyHealth(this.m_damage,this);
         if(_loc4_ is IComponentOwner)
         {
            if(!(_loc5_ = _loc4_ as IComponentOwner).getComponentByType(AcidStatusEffect))
            {
               _loc5_.addComponent(new AcidStatusEffect(_loc4_ as MonsterBase,this.m_damage));
            }
         }
         _loc3_++;
      }
   }
   
   public function get defenseFlags() : int
   {
      return 0;
   }
   
   public function get graphic() : Shape
   {
      return this.m_graphic;
   }
   
   public function get x() : Number
   {
      return this.m_x;
   }
   
   public function get y() : Number
   {
      return this.m_y;
   }
   
   public function set damage(param1:Number) : void
   {
      this.m_damage = param1;
   }
}

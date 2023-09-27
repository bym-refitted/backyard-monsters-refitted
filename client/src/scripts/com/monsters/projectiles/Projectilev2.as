package com.monsters.projectiles
{
   import com.monsters.GameObject;
   import com.monsters.events.ProjectileEvent;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.interfaces.ITickable;
   import com.monsters.monsters.DummyTarget;
   import com.monsters.monsters.creeps.CreepBase;
   import com.monsters.projectiles.projectileComponents.ProjectileComponent;
   import com.monsters.rendering.RasterData;
   import flash.display.BitmapData;
   import flash.display.IBitmapDrawable;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class Projectilev2 extends EventDispatcher implements IAttackable, ITickable
   {
      
      private static const k_DO_PROJECTILES_HAVE_RANDOM_OFFSET:Boolean = true;
       
      
      public var targetOffset:Point;
      
      protected var m_x:Number;
      
      protected var m_y:Number;
      
      protected var m_target:ITargetable;
      
      protected var m_speed:Number;
      
      protected var m_damage:Number;
      
      protected var m_source:IAttackable;
      
      protected var m_components:Vector.<ProjectileComponent>;
      
      protected var m_rasterData:RasterData;
      
      protected var m_angleToTargetPoint:Number;
      
      protected var m_distanceToTarget:Number;
      
      public function Projectilev2()
      {
         this.m_components = new Vector.<ProjectileComponent>();
         super();
      }
      
      public function get rasterData() : RasterData
      {
         return this.m_rasterData;
      }
      
      public function set graphic(param1:IBitmapDrawable) : void
      {
      }
      
      public function get angleToTargetPoint() : Number
      {
         return this.m_angleToTargetPoint;
      }
      
      public function get damage() : Number
      {
         return this.m_damage;
      }
      
      public function set damage(param1:Number) : void
      {
         this.m_damage = param1;
      }
      
      public function setup(param1:IBitmapDrawable, param2:Number, param3:Number, param4:ITargetable, param5:Number, param6:Number = 0, param7:IAttackable = null, ... rest) : void
      {
         this.m_rasterData = new RasterData(param1,new Point(param2,param3),int.MAX_VALUE);
         this.m_x = param2 - BitmapData(this.m_rasterData.data).width * 0.5;
         this.m_y = param3 - BitmapData(this.m_rasterData.data).height * 0.5;
         this.m_target = param4;
         this.m_speed = param5;
         this.m_damage = param6;
         this.m_source = param7;
         GLOBAL.addFastTickable(this);
         if(param4 is GameObject && k_DO_PROJECTILES_HAVE_RANDOM_OFFSET)
         {
            this.targetOffset = GameObject(param4).getRandomPointOnGraphic();
         }
         var _loc9_:int = 0;
         while(_loc9_ < rest.length)
         {
            if(rest[_loc9_] is ProjectileComponent)
            {
               this.addComponent(rest[_loc9_]);
            }
            _loc9_++;
         }
      }
      
      public function addComponent(param1:ProjectileComponent) : void
      {
         this.m_components.push(param1);
      }
      
      public function get x() : Number
      {
         return this.m_x;
      }
      
      public function get y() : Number
      {
         return this.m_y;
      }
      
      public function get targetPoint() : Point
      {
         var _loc1_:Point = new Point(this.m_target.x,this.m_target.y);
         if(this.targetOffset)
         {
            _loc1_ = _loc1_.add(this.targetOffset);
         }
         return _loc1_;
      }
      
      public function tick(param1:int = 1) : void
      {
         this.validateTarget();
         this.move();
         var _loc2_:int = 0;
         while(_loc2_ < this.m_components.length)
         {
            this.m_components[_loc2_].tick(param1);
            _loc2_++;
         }
         if(this.m_distanceToTarget - this.m_speed <= 0)
         {
            this.hit();
         }
         if(this.m_target)
         {
            this.render();
         }
         else
         {
            this.destroy();
         }
      }
      
      protected function move() : void
      {
         var _loc1_:Point = null;
         _loc1_ = this.targetPoint;
         var _loc2_:Number = _loc1_.x - this.m_x;
         var _loc3_:Number = _loc1_.y - this.m_y;
         this.m_distanceToTarget = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
         this.m_angleToTargetPoint = Math.atan2(_loc3_,_loc2_);
         this.m_x += Math.cos(this.m_angleToTargetPoint) * this.m_speed;
         this.m_y += Math.sin(this.m_angleToTargetPoint) * this.m_speed;
      }
      
      private function validateTarget() : void
      {
         if(this.m_target is GameObject && !GameObject(this.m_target).isTargetable || this.m_target is CreepBase && CreepBase(this.m_target).invisible)
         {
            this.m_target = new DummyTarget(this.m_target.x,this.m_target.y);
         }
      }
      
      protected function render() : void
      {
         var _loc1_:Point = MAP.instance.offset;
         this.m_rasterData.pt = new Point(this.m_x - _loc1_.x,this.m_y - _loc1_.y);
      }
      
      private function hit() : void
      {
         var _loc2_:IAttackable = null;
         var _loc3_:int = 0;
         dispatchEvent(new ProjectileEvent(ProjectileEvent.k_hit,this.m_target));
         var _loc1_:ITargetable = this.m_target;
         if(this.m_target is IAttackable)
         {
            _loc2_ = IAttackable(this.m_target);
            _loc2_.modifyHealth(this.m_damage,this);
            _loc3_ = 0;
            while(_loc3_ < this.m_components.length)
            {
               this.m_damage = this.m_components[_loc3_].onAttack(_loc2_,this.m_damage,this);
               _loc3_++;
            }
         }
         if(_loc1_ == this.m_target)
         {
            this.m_target = null;
         }
      }
      
      protected function destroy() : void
      {
         this.m_damage = 0;
         this.m_speed = 0;
         this.m_x = 0;
         this.m_y = 0;
         this.m_source = null;
         this.m_target = null;
         this.m_rasterData.clear();
         this.m_rasterData = null;
         this.targetOffset = null;
         GLOBAL.removeFastTickable(this);
         this.m_components = new Vector.<ProjectileComponent>();
      }
      
      public function get target() : ITargetable
      {
         return this.m_target;
      }
      
      public function set target(param1:ITargetable) : void
      {
         this.m_target = param1;
      }
      
      public function get defenseFlags() : int
      {
         return 0;
      }
      
      public function get attackFlags() : int
      {
         return 0;
      }
      
      public function get attackPriorityFlags() : Vector.<int>
      {
         return null;
      }
      
      public function get health() : Number
      {
         return 0;
      }
      
      public function get maxHealth() : Number
      {
         return 0;
      }
      
      public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         return 0;
      }
      
      public function copy(param1:Projectilev2 = null) : Projectilev2
      {
         if(!param1)
         {
            param1 = new Projectilev2();
         }
         param1.setup(this.m_rasterData.data as BitmapData,this.m_x,this.m_y,this.m_target,this.m_speed,this.m_damage,this.m_source);
         param1.targetOffset = this.targetOffset;
         return param1;
      }
   }
}

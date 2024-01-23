package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.IDefendingComponent;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class AbsorbProjectiles extends Component implements IDefendingComponent
   {
       
      
      private var m_absorbedProjectiles:Vector.<PROJECTILE>;
      
      private var m_blastRadius:uint;
      
      private var m_damageAbsorbed:uint;
      
      public function AbsorbProjectiles(param1:uint = 300)
      {
         super();
         this.m_blastRadius = param1;
         this.m_absorbedProjectiles = new Vector.<PROJECTILE>();
      }
      
      override protected function onRegister() : void
      {
         owner.addEventListener(MonsterBase.k_DEATH_EVENT,this.onDeath);
      }
      
      override protected function onUnregister() : void
      {
         owner.removeEventListener(MonsterBase.k_DEATH_EVENT,this.onDeath);
      }
      
      private function onDeath(param1:Event) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:IAttackable = null;
         var _loc7_:PROJECTILE = null;
         var _loc2_:Point = new Point(owner.x,owner.y);
         var _loc3_:Array = Targeting.getTargetsInRange(this.m_blastRadius,_loc2_,Targeting.getEnemyFlag(owner) | Targeting.k_TARGETS_FLYING | Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_BUILDINGS);
         var _loc4_:int = 0;
         while(_loc4_ < this.m_absorbedProjectiles.length)
         {
            _loc5_ = Math.random() * (_loc3_.length - 1);
            _loc6_ = _loc3_[_loc5_].creep;
            _loc7_ = this.m_absorbedProjectiles[_loc4_];
            PROJECTILES.Spawn(_loc2_,new Point(_loc6_.x,_loc6_.y),_loc6_,_loc7_._maxSpeed,-_loc7_._damage,_loc7_._rocket,_loc7_._splash,_loc7_._splashTargetFlags);
            _loc4_++;
         }
         this.setOwnerScale(1);
         this.m_absorbedProjectiles = null;
      }
      
      public function onDefend(param1:IAttackable, param2:Number, param3:ITargetable = null) : Number
      {
         var _loc4_:PROJECTILE = null;
         var _loc5_:Number = NaN;
         if(param3 is PROJECTILE && Boolean(this.m_absorbedProjectiles))
         {
            _loc4_ = PROJECTILE(param3);
            this.m_absorbedProjectiles.push(_loc4_);
            this.m_damageAbsorbed += _loc4_._damage;
            _loc5_ = 1 + this.m_damageAbsorbed / owner.maxHealth;
            this.setOwnerScale(_loc5_);
         }
         return param2;
      }
      
      private function setOwnerScale(param1:Number) : void
      {
         owner._mc.scaleX = param1;
         owner._mc.scaleY = param1;
      }
   }
}

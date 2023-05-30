package com.monsters.monsters.components.abilities
{
   import com.monsters.events.ProjectileEvent;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.projectiles.Projectilev2;
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.easing.Sine;
   
   public class RezghulResurrectAttack extends RangedAttack
   {
      
      private static const k_UNRESURRECTABLE_CREATURES:Vector.<String> = Vector.<String>(["C16","C15","C19","C18"]);
       
      
      private var m_zombiefy:com.monsters.monsters.components.abilities.Zombiefy;
      
      private var m_resurrectRange:uint;
      
      public function RezghulResurrectAttack(param1:uint, param2:int, param3:int, param4:uint, param5:Projectilev2, param6:com.monsters.monsters.components.abilities.Zombiefy)
      {
         super(param1,param2,param3,param5);
         this.m_zombiefy = param6;
         this.m_resurrectRange = param4;
      }
      
      override protected function getValidTargetsInRange(param1:uint, param2:Point, param3:int) : Vector.<ITargetable>
      {
         var _loc4_:Vector.<ITargetable> = null;
         var _loc7_:ITargetable = null;
         var _loc5_:Array = Targeting.getDeadCreeps(param2,param1,param3);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(!_loc4_)
            {
               _loc4_ = new Vector.<ITargetable>();
            }
            if((_loc7_ = _loc5_[_loc6_].creep) is MonsterBase && k_UNRESURRECTABLE_CREATURES.indexOf(MonsterBase(_loc7_)._creatureID) == -1)
            {
               _loc4_.push(_loc7_);
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      override protected function fireAt(param1:ITargetable) : Projectilev2
      {
         var _loc2_:Projectilev2 = super.fireAt(param1);
         _loc2_.addEventListener(ProjectileEvent.k_hit,this.onProjectileHit,false,0,true);
         return _loc2_;
      }
      
      protected function onProjectileHit(param1:ProjectileEvent) : void
      {
         var _loc2_:Projectilev2 = param1.target as Projectilev2;
         _loc2_.removeEventListener(ProjectileEvent.k_hit,this.onProjectileHit);
         this.resurrectAlliesInArea(_loc2_);
      }
      
      private function resurrectAlliesInArea(param1:Projectilev2) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ITargetable = null;
         var _loc2_:Vector.<ITargetable> = this.getValidTargetsInRange(this.m_resurrectRange,new Point(param1.x,param1.y),m_targetFlags);
         if(_loc2_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if((_loc4_ = _loc2_[_loc3_]) is MonsterBase && k_UNRESURRECTABLE_CREATURES.indexOf(MonsterBase(_loc4_)._creatureID) == -1)
               {
                  this.resurrect(_loc4_ as MonsterBase);
               }
               _loc3_++;
            }
         }
      }
      
      private function resurrect(param1:MonsterBase) : void
      {
         var _loc2_:MonsterBase = null;
         if(owner._friendly)
         {
            _loc2_ = CREATURES.Spawn(param1._creatureID,MAP._BUILDINGTOPS,param1._behaviour,new Point(param1.x,param1.y),param1._targetRotation,null,param1._house);
         }
         else
         {
            _loc2_ = CREEPS.Spawn(param1._creatureID,MAP._BUILDINGTOPS,param1._behaviour,new Point(param1.x,param1.y),param1._targetRotation,1,false,true);
         }
         EFFECTS.Dig(int(_loc2_.x),int(_loc2_.y + 20));
         TweenLite.from(_loc2_._graphicMC,0.8,{
            "y":_loc2_._graphicMC.y + 20,
            "ease":Sine.easeOut,
            "overwrite":false,
            "onComplete":_loc2_.findTarget
         });
         GIBLETS.Create(new Point(_loc2_.x,_loc2_.y + 20),1,50,20,10);
         _loc2_.addComponent(this.m_zombiefy.clone());
         param1.corpseDeath();
      }
   }
}

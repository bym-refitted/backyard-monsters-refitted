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
       
      
      private var m_zombiefy:Zombiefy;
      
      private var m_resurrectRange:uint;
      
      public function RezghulResurrectAttack(projRange:uint, rechargeTime:int, targetFlags:int, resAreaRange:uint, proj:Projectilev2, zombieComponent:Zombiefy)
      {
         super(projRange,rechargeTime,targetFlags,proj);
         this.m_zombiefy = zombieComponent;
         this.m_resurrectRange = resAreaRange;
      }
      
      override protected function getValidTargetsInRange(param1:uint, param2:Point, param3:int) : Vector.<ITargetable>
      {
         var targets:Vector.<ITargetable> = null;
         var currentCreep:ITargetable = null;
         var allDeadCreeps:Array = Targeting.getDeadCreeps(param2,param1,param3);
         var idx:int = 0;
         while(idx < allDeadCreeps.length)
         {
            if(!targets)
            {
               targets = new Vector.<ITargetable>();
            }
            if((currentCreep = allDeadCreeps[idx].creep) is MonsterBase && k_UNRESURRECTABLE_CREATURES.indexOf(MonsterBase(currentCreep)._creatureID) == -1)
            {
               targets.push(currentCreep);
            }
            idx++;
         }
         return targets;
      }
      
      override protected function fireAt(target:ITargetable) : Projectilev2
      {
         var proj:Projectilev2 = super.fireAt(target);
         proj.addEventListener(ProjectileEvent.k_hit,this.onProjectileHit,false,0,true);
         return proj;
      }
      
      protected function onProjectileHit(event:ProjectileEvent) : void
      {
         var proj:Projectilev2 = event.target as Projectilev2;
         proj.removeEventListener(ProjectileEvent.k_hit,this.onProjectileHit);
         this.resurrectAlliesInArea(proj);
      }
      
      private function resurrectAlliesInArea(proj:Projectilev2) : void
      {
         var idx:int = 0;
         var currentCreep:ITargetable = null;
         var deadCreepsInRange:Vector.<ITargetable> = this.getValidTargetsInRange(this.m_resurrectRange,new Point(proj.x,proj.y),m_targetFlags);
         if(deadCreepsInRange)
         {
            idx = 0;
            while(idx < deadCreepsInRange.length)
            {
               if((currentCreep = deadCreepsInRange[idx]) is MonsterBase && k_UNRESURRECTABLE_CREATURES.indexOf(MonsterBase(currentCreep)._creatureID) == -1)
               {
                  this.resurrect(currentCreep as MonsterBase);
               }
               idx++;
            }
         }
      }
      
      private function resurrect(monsterToRes:MonsterBase) : void
      {
         var newMonster:MonsterBase = null;
         if(owner._friendly)
         {
            newMonster = CREATURES.Spawn(monsterToRes._creatureID,MAP._BUILDINGTOPS,monsterToRes._behaviour,new Point(monsterToRes.x,monsterToRes.y),monsterToRes._targetRotation,null,monsterToRes._house);
         }
         else
         {
            newMonster = CREEPS.Spawn(monsterToRes._creatureID,MAP._BUILDINGTOPS,monsterToRes._behaviour,new Point(monsterToRes.x,monsterToRes.y),monsterToRes._targetRotation,1,false,true);
         }
         EFFECTS.Dig(int(newMonster.x),int(newMonster.y + 20));
         TweenLite.from(newMonster._graphicMC,0.8,{
            "y":newMonster._graphicMC.y + 20,
            "ease":Sine.easeOut,
            "overwrite":false,
            "onComplete":newMonster.findTarget
         });
         GIBLETS.Create(new Point(newMonster.x,newMonster.y + 20),1,50,20,10);
         newMonster.addComponent(this.m_zombiefy.clone());
         monsterToRes.corpseDeath();
      }
   }
}

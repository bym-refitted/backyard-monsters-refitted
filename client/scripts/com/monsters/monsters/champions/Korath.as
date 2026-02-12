package com.monsters.monsters.champions
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.events.ProjectileEvent;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.statusEffects.FlameEffect;
   import com.monsters.pathing.PATHING;
   import flash.geom.Point;
   
   public class Korath extends ChampionBase
   {
      
      public static const KORATH_POWER_NORMAL:int = 1;
      
      public static const KORATH_POWER_FIREBALL:int = 2;
      
      public static const KORATH_POWER_STOMP:int = 3;
       
      
      public var _attackNum:int;
      
      public var _quaking:Boolean;

      /*
      param1 -> behaviour
      param2 -> targetPosition
      param3 -> targetRotation
      param4 -> targetCenter
      param5 -> friendly
      param6 -> house
      param7 -> level
      param8 -> feeds
      param9 -> feedTime
      param10 -> creatureID
      param11 -> health
      param12 -> foodBonus
      param13 -> powerLevel

      also switch statement changed for a cleaner if statement
      */
      
      public function Korath(behaviour:String, targetPosition:Point, targetRotation:Number, targetCenter:Point = null, friendly:Boolean = false, house:BFOUNDATION = null, level:int = 1, feeds:int = 0, feedTime:int = 0, creatureID:int = 1, health:int = 20000, foodBonus:int = 0, powerLevel:int = 1)
      {
         super(behaviour,targetPosition,targetRotation,targetCenter,friendly,house,level,feeds,feedTime,creatureID,health,foodBonus,powerLevel);
         this._attackNum = 0;
         this._quaking = false;
         if(level > 2 && level < 7)
         {
            attackDelayProperty.value = 80;
         }
         else
         {
            attackDelayProperty.value = 72;
         }
      }
      
      override protected function changeMode() : void
      {
         super.changeMode();
         this._quaking = false;
      }
      
      override protected function tickBAttack() : void
      {
         if(health > 0 && this.doQuakeCheck())
         {
            return;
         }
         super.tickBAttack();
      }
      
      override protected function tickBDefend() : void
      {
         if(health > 0)
         {
            if(this.doQuakeCheck())
            {
               return;
            }
         }
         super.tickBDefend();
      }
      
      //_loc1_ its a damage multiplier but its always 1, so removed due to no making any sense
      override protected function doAttackDamage() : void
      {
         if(_targetCreep && _targetCreep._movement == "fly" && _powerLevel.Get() >= KORATH_POWER_FIREBALL && _level.Get() > 3)
         {
            if(_targetCreep.health > 0)
            {
               this.shootFireball(_targetCreep);
            }
         }
         else
         {
            ++this._attackNum;
            if(Boolean(_targetBuilding) && _targetBuilding._fortification.Get() > 0)
            {
               ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage * (100 - (_targetBuilding._fortification.Get() * 10 + 10)) / 100,_mc.visible);
            }
            else
            {
               ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage,_mc.visible);
            }
            if(_targetCreep)
            {
               _targetCreep.modifyHealth(-(damage));
               this.addFlameDOT(_targetCreep);
            }
            else if(_targetBuilding)
            {
               _targetBuilding.modifyHealth(damage,this);
            }
            else
            {
               findTarget();
            }
         }
      }
      
      override protected function doDefenseDamage() : void
      {
         if(_powerLevel.Get() >= KORATH_POWER_FIREBALL && _level.Get() > 3 && _targetCreep._movement == "fly")
         {
            this.shootFireball(_targetCreep);
         }
         else
         {
            ++this._attackNum;
            ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage,_mc.visible);
            _targetCreep.modifyHealth(-damage);
            this.addFlameDOT(_targetCreep);
         }
      }
      /*
      _loc4_ -> fireball
      _loc2_ -> its always 50 so removed and replace by just the number
      _loc3_ -> startingPoint
      param1 -> target, its never used but kept for consistency
      */
      private function shootFireball(target:MonsterBase) : void
      {
         var startingPoint:Point = Point.interpolate(_tmpPoint.add(new Point(0,-50)),_targetCreep._tmpPoint,0.8);
         var fireball:FIREBALL;
         (fireball = FIREBALLS.Spawn2(startingPoint,_targetCreep._tmpPoint,_targetCreep,8,damage / 4,0,FIREBALLS.TYPE_MAGMA,1,this)).addEventListener(FIREBALL.COLLIDED,this.addFlameDOTEvent,false,0,true);
      }
      
      override protected function getTargetCreeps() : void
      {
         if(_powerLevel.Get() >= KORATH_POWER_FIREBALL && _level.Get() > 3)
         {
            _targetCreeps = Targeting.getCreepsInRange(800,_tmpPoint,Targeting.getOldStyleTargets(1));
         }
         else
         {
            _targetCreeps = Targeting.getCreepsInRange(800,_tmpPoint,Targeting.getOldStyleTargets(0));
         }
      }
      
      //_loc1_ -> distance
      override public function canShootCreep() : Boolean
      {
         if(_targetCreep == null)
         {
            return false;
         }
         if(_targetCreep._movement == "fly")
         {
            if(_powerLevel.Get() < KORATH_POWER_FIREBALL || _level.Get() < 4)
            {
               return false;
            }
         }
         var distance:Number = GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint);
         if(distance > m_range)
         {
            return false;
         }
         if(PATHING.LineOfSight(_tmpPoint.x,_tmpPoint.y,_targetCreep._tmpPoint.x,_targetCreep._tmpPoint.y))
         {
            return true;
         }
         return false;
      }
      
      override protected function getNextSprite() : void
      {
         super.getNextSprite();
         if(this._quaking)
         {
            SPRITES.GetSprite(_graphic,_spriteID,"stomp",m_rotation - 45,_frameNumber);
         }
      }
      
      private function drawFrame() : void
      {
      }
      
      //param1 -> projectileEvent
      private function addFlameDOTEvent(projectileEvent:ProjectileEvent) : void
      {
         (projectileEvent.target as FIREBALL).removeEventListener(FIREBALL.COLLIDED,this.addFlameDOTEvent);
         if(projectileEvent.m_targetCreep is MonsterBase)
         {
            this.addFlameDOT(MonsterBase(projectileEvent.m_targetCreep));
         }
      }
      
      // param1 -> target
      private function addFlameDOT(target:MonsterBase) : Boolean
      {
         target.addStatusEffect(new FlameEffect(target,damage * 0.1));
         return true;
      }
      
      //_loc1_ its a damage multiplier but its always 1, so removed due to no making any sense 
      private function doQuakeCheck() : Boolean
      {
         if(_creatureID != "G4")
         {
            return false;
         }
         if(this._quaking)
         {
            if(_frameNumber / 8 % 10 + 20 == 26)
            {
               this._attackNum = 0;
               SOUNDS.Play("quake",0.4);
               this.quake(damage);
            }
            else if(_frameNumber / 8 % 10 + 20 == 29)
            {
               this._quaking = false;
            }
         }
         else if(attackCooldown <= 0)
         {
            if(_powerLevel.Get() >= KORATH_POWER_STOMP && _level.Get() > 4 && this._attackNum >= 3)
            {
               this._quaking = true;
               _frameNumber = 0;
            }
         }
         return this._quaking;
      }
      
      /*
      param1 -> never used, kept for consistency
      _loc2_ -> ownPosition
      _loc3_ -> targets
      _loc4_ -> its a delta y for the graphics but its always 0, so removed due to no making any sense
      _loc5_ -> targetingFlags
      _loc6_ -> quakeGraphic
      */
      private function quake(param1:int) : void
      {
         var targets:Array = null;
         var ownPosition:Point = new Point(_mc.x,_mc.y);
         var targetingFlags:* = Targeting.getEnemyFlag(this) | Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_INVISIBLE;
         if(!_friendly)
         {
            targetingFlags |= Targeting.k_TARGETS_BUILDINGS;
         }
         targets = Targeting.getTargetsInRange(m_range * 2.5,new Point(_mc.x,_mc.y),targetingFlags);
         if(targets)
         {
            Targeting.DealLinearAEDamage(ownPosition,m_range * 2.5,damage,targets,m_range * 1.5);
         }
         var quakeGraphic:G4QuakeGraphic;
         (quakeGraphic = new G4QuakeGraphic(20,m_range * 2.5,BYMConfig.instance.RENDERER_ON ? new Point(_rasterPt.x,_rasterPt.y + _graphic.height * 0.6) : null)).graphic.y = quakeGraphic.graphic.y;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            _mc.addChildAt(quakeGraphic.graphic,Math.max(graphic.getChildIndex(_graphicMC) - 1,0));
         }
      }
   }
}

import com.monsters.configs.BYMConfig;
import com.monsters.rendering.RasterData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;
import gs.TweenLite;

class G4QuakeGraphic
{
    
   
   public var graphic:Shape;
   
   protected var m_rasterData:RasterData;
   
   protected var m_rasterPt:Point;
   

   /*
   param1 -> ellipseRadious
   param2 -> width
   para3 -> startingPoint

   _loc4_ -> glowFilter
   _loc5_ -> sprite
   */
   public function G4QuakeGraphic(ellipseRadious:uint, width:uint, startingPoint:Point = null)
   {
      var sprite:Sprite = null;
      super();
      this.graphic = new Shape();
      this.graphic.graphics.lineStyle(0.3,15893760,0.5);
      this.graphic.graphics.drawEllipse(-ellipseRadious,-ellipseRadious / 2,ellipseRadious * 2,ellipseRadious);
      this.graphic.graphics.drawEllipse(-ellipseRadious * 0.8,-ellipseRadious / 2.5,ellipseRadious * 1.6,ellipseRadious * 0.8);
      this.graphic.graphics.drawEllipse(-ellipseRadious * 0.6,-ellipseRadious / 3.333333,ellipseRadious * 1.2,ellipseRadious * 0.6);
      var glowFilter:GlowFilter = new GlowFilter(16737792,1,20,20,5 + Math.random() * 5,1,false,false);
      this.graphic.filters = [glowFilter];
      TweenLite.to(this.graphic,1,{
         "width":width * 2,
         "height":width,
         "alpha":0,
         "onComplete":this.onComplete
      });
      if(BYMConfig.instance.RENDERER_ON && Boolean(startingPoint))
      {
         (sprite = new Sprite()).addChild(this.graphic);
         this.m_rasterPt = new Point(startingPoint.x + sprite.width,startingPoint.y + sprite.height);
         this.m_rasterData = new RasterData(sprite,this.m_rasterPt,MAP.DEPTH_SHADOW + 1);
      }
   }
   
   private function onComplete() : void
   {
      this.graphic.parent.removeChild(this.graphic);
      this.graphic.filters = [];
      this.graphic = null;
      if(this.m_rasterData)
      {
         this.m_rasterData.clear();
      }
      this.m_rasterData = null;
      this.m_rasterPt = null;
   }
}

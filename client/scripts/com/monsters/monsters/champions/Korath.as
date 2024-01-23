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
      
      public function Korath(param1:String, param2:Point, param3:Number, param4:Point = null, param5:Boolean = false, param6:BFOUNDATION = null, param7:int = 1, param8:int = 0, param9:int = 0, param10:int = 1, param11:int = 20000, param12:int = 0, param13:int = 1)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
         this._attackNum = 0;
         this._quaking = false;
         switch(param7)
         {
            case 1:
               attackDelayProperty.value = 72;
               break;
            case 2:
               attackDelayProperty.value = 72;
               break;
            case 3:
               attackDelayProperty.value = 80;
               break;
            case 4:
               attackDelayProperty.value = 80;
               break;
            case 5:
               attackDelayProperty.value = 80;
               break;
            case 6:
               attackDelayProperty.value = 80;
               break;
            default:
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
      
      override protected function doAttackDamage() : void
      {
         var _loc1_:Number = 1;
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
               ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage * _loc1_ * (100 - (_targetBuilding._fortification.Get() * 10 + 10)) / 100,_mc.visible);
            }
            else
            {
               ATTACK.Damage(_tmpPoint.x,_tmpPoint.y - 5,damage * _loc1_,_mc.visible);
            }
            if(_targetCreep)
            {
               _targetCreep.modifyHealth(-(damage * _loc1_));
               this.addFlameDOT(_targetCreep);
            }
            else if(_targetBuilding)
            {
               _targetBuilding.modifyHealth(damage * _loc1_,this);
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
      
      private function shootFireball(param1:MonsterBase) : void
      {
         var _loc2_:int = 50;
         var _loc3_:Point = Point.interpolate(_tmpPoint.add(new Point(0,-_loc2_)),_targetCreep._tmpPoint,0.8);
         var _loc4_:FIREBALL;
         (_loc4_ = FIREBALLS.Spawn2(_loc3_,_targetCreep._tmpPoint,_targetCreep,8,damage / 4,0,FIREBALLS.TYPE_MAGMA,1,this)).addEventListener(FIREBALL.COLLIDED,this.addFlameDOTEvent,false,0,true);
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
         var _loc1_:Number = GLOBAL.QuickDistance(_targetCreep._tmpPoint,_tmpPoint);
         if(_loc1_ > m_range)
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
      
      private function addFlameDOTEvent(param1:ProjectileEvent) : void
      {
         (param1.target as FIREBALL).removeEventListener(FIREBALL.COLLIDED,this.addFlameDOTEvent);
         if(param1.m_targetCreep is MonsterBase)
         {
            this.addFlameDOT(MonsterBase(param1.m_targetCreep));
         }
      }
      
      private function addFlameDOT(param1:MonsterBase) : Boolean
      {
         param1.addStatusEffect(new FlameEffect(param1,damage * 0.1));
         return true;
      }
      
      private function doQuakeCheck() : Boolean
      {
         var _loc1_:Number = NaN;
         if(_creatureID != "G4")
         {
            return false;
         }
         if(this._quaking)
         {
            if(_frameNumber / 8 % 10 + 20 == 26)
            {
               _loc1_ = 1;
               this._attackNum = 0;
               SOUNDS.Play("quake",0.4);
               this.quake(damage * _loc1_);
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
      
      private function quake(param1:int) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Point = new Point(_mc.x,_mc.y);
         var _loc4_:int = 0;
         var _loc5_:* = Targeting.getEnemyFlag(this) | Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_INVISIBLE;
         if(!_friendly)
         {
            _loc5_ |= Targeting.k_TARGETS_BUILDINGS;
         }
         _loc3_ = Targeting.getTargetsInRange(m_range * 2.5,new Point(_mc.x,_mc.y),_loc5_);
         if(_loc3_)
         {
            Targeting.DealLinearAEDamage(_loc2_,m_range * 2.5,damage,_loc3_,m_range * 1.5);
         }
         var _loc6_:G4QuakeGraphic;
         (_loc6_ = new G4QuakeGraphic(20,m_range * 2.5,BYMConfig.instance.RENDERER_ON ? new Point(_rasterPt.x,_rasterPt.y + _graphic.height * 0.6) : null)).graphic.y = _loc6_.graphic.y + _loc4_;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            _mc.addChildAt(_loc6_.graphic,Math.max(graphic.getChildIndex(_graphicMC) - 1,0));
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
   
   public function G4QuakeGraphic(param1:uint, param2:uint, param3:Point = null)
   {
      var _loc5_:Sprite = null;
      super();
      this.graphic = new Shape();
      this.graphic.graphics.lineStyle(0.3,15893760,0.5);
      this.graphic.graphics.drawEllipse(-param1,-param1 / 2,param1 * 2,param1);
      this.graphic.graphics.drawEllipse(-param1 * 0.8,-param1 / 2.5,param1 * 1.6,param1 * 0.8);
      this.graphic.graphics.drawEllipse(-param1 * 0.6,-param1 / 3.333333,param1 * 1.2,param1 * 0.6);
      var _loc4_:GlowFilter = new GlowFilter(16737792,1,20,20,5 + Math.random() * 5,1,false,false);
      this.graphic.filters = [_loc4_];
      TweenLite.to(this.graphic,1,{
         "width":param2 * 2,
         "height":param2,
         "alpha":0,
         "onComplete":this.onComplete
      });
      if(BYMConfig.instance.RENDERER_ON && Boolean(param3))
      {
         (_loc5_ = new Sprite()).addChild(this.graphic);
         this.m_rasterPt = new Point(param3.x + _loc5_.width,param3.y + _loc5_.height);
         this.m_rasterData = new RasterData(_loc5_,this.m_rasterPt,MAP.DEPTH_SHADOW + 1);
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

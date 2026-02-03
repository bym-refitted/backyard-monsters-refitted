package
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.rendering.RasterData;
   import com.monsters.utils.ObjectPool;
   import flash.events.*;
   import flash.geom.Point;
   
   public class BTRAP extends BFOUNDATION
   {
       
      
      private var creeps:Array;
      
      private var maxDist:int;
      
      private var minDist:int;
      
      public var _hasTargets:Boolean;
      
      public var _targetCreeps:Array;
      
      public var _retarget:int;
      
      public function BTRAP()
      {
         super();
         _fired = false;
         this._retarget = 0;
         _range = 20;
         attackFlags = Targeting.getOldStyleTargets(-1);
      }
      
      override public function SetProps() : void
      {
         var _loc1_:RasterData = null;
         super.SetProps();
         damageProperty.value = _buildingProps.damage[0];
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            _mc.visible = false;
            _mcBase.visible = false;
         }
      }
      
      override protected function updateRasterData() : void
      {
         if(GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD)
         {
            _mc.visible = false;
            _mcBase.visible = false;
         }
         super.updateRasterData();
      }
      
      override public function TickAttack() : void
      {
         if(_countdownBuild.Get() == 0 && !_fired)
         {
            if(!this._hasTargets)
            {
               if(this._retarget == 0)
               {
                  this.FindTargets();
                  this._retarget = 20;
               }
               --this._retarget;
            }
            else
            {
               this.Explode();
            }
         }
      }
      
      public function FindTargets() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MonsterBase = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         this.creeps = Targeting.getCreepsInRange(_range,_position,attackFlags);
         this._hasTargets = false;
         this._targetCreeps = [];
         var _loc7_:int = 0;
         var _loc8_:* = this.creeps;
         for(_loc3_ in _loc8_)
         {
            _loc1_ = this.creeps[_loc3_];
            _loc2_ = _loc1_.creep;
            _loc4_ = Number(_loc1_.dist);
            _loc5_ = _loc1_.pos;
            this._targetCreeps.push({
               "creep":_loc2_,
               "dist":_loc4_,
               "position":_loc5_
            });
            this._hasTargets = true;
         }
      }
      
      public function Explode() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MonsterBase = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:RasterData = null;
         var _loc7_:Array = Targeting.getCreepsInRange(_size, ObjectPool.getPoint(_mc.x, _mc.y), attackFlags);
         // Note: Can't return point immediately as it's used in getCreepsInRange
         for(_loc3_ in _loc7_)
         {
            _loc1_ = _loc7_[_loc3_];
            _loc2_ = _loc1_.creep;
            if(_loc2_.health > 0)
            {
               _loc8_++;
               _loc4_ = Number(_loc1_.dist);
               _loc5_ = _loc1_.pos;
               _loc2_.modifyHealth(-(damage / _buildingProps.size * (_buildingProps.size - _loc4_ * 0.5)));
               if(_loc2_.health <= 0)
               {
                  _loc9_++;
                  var gibletsPoint:Point = ObjectPool.getPoint(_mc.x, _mc.y + 3);
                  GIBLETS.Create(gibletsPoint, 0.8, 75, 2);
                  ObjectPool.returnPoint(gibletsPoint);
               }
            }
         }
         if(_loc8_ > 0)
         {
            _fired = true;
            if(_loc9_ == _loc8_)
            {
               ATTACK.Log("trap" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_trapkilled",{
                  "v1":KEYS.Get(_buildingProps.name),
                  "v2":_loc9_
               }) + "</font>");
            }
            else if(_loc9_ > 0)
            {
               ATTACK.Log("trap" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_trapdamagedkilled",{
                  "v1":KEYS.Get(_buildingProps.name),
                  "v2":_loc8_,
                  "v3":_loc9_
               }) + "</font>");
            }
            else
            {
               ATTACK.Log("trap" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_trapdamaged",{
                  "v1":KEYS.Get(_buildingProps.name),
                  "v2":_loc8_
               }) + "</font>");
            }
            var scorchPoint:Point = ObjectPool.getPoint(_mc.x, _mc.y + 5);
            EFFECTS.Scorch(scorchPoint);
            ObjectPool.returnPoint(scorchPoint);
         }
         this._hasTargets = false;
         _mc.visible = true;
         _mcBase.visible = true;
         if(BYMConfig.instance.RENDERER_ON)
         {
            for each(_loc10_ in _rasterData)
            {
               if(_loc10_)
               {
                  _loc10_.visible = true;
               }
            }
         }
         setHealth(0);
         SOUNDS.Play("trap");
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            RecycleC();
         }
      }
   }
}

package com.monsters.ai
{
   import com.monsters.managers.InstanceManager;
   import com.monsters.pathing.PATHING;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PROCESS5 implements IPROCESS
   {
       
      
      public var _solutions:Vector.<Solution>;
      
      private var solsProcessed:uint = 0;
      
      public var _inProgress:Boolean;
      
      public var _intelligence:Number;
      
      private var processStepResolution:int = 3;
      
      public function PROCESS5()
      {
         super();
      }
      
      public function Trigger(param1:Number = 1) : void
      {
         this._intelligence = param1;
         this._inProgress = true;
         this._solutions = new Vector.<Solution>();
         var _loc2_:Number = GLOBAL._mapWidth;
         var _loc3_:Number = GLOBAL._mapHeight;
         var _loc4_:int = 0;
         while(_loc4_ < WMATTACK._attackResolution)
         {
            this._solutions.push(new Solution(360 / WMATTACK._attackResolution * _loc4_,_loc2_,_loc3_));
            _loc4_ += 1;
         }
         this.solsProcessed = 0;
         this.Process(this._solutions[0],this.onProcess);
      }
      
      public function Process(param1:Solution, param2:Function) : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:Point = null;
         var _loc6_:Number = NaN;
         var _loc5_:Array = [];
         var _loc7_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc3_ in _loc7_)
         {
            if((_loc3_ is BRESOURCE || _loc3_ is BUILDING6 || _loc3_ in BUILDING14) && _loc3_.health > 0 && !_loc3_._looted)
            {
               _loc4_ = GRID.FromISO(_loc3_.x,_loc3_.y);
               _loc6_ = Point.distance(param1.entryPoint,_loc4_);
               _loc5_.push({
                  "building":_loc3_,
                  "distance":_loc6_
               });
            }
         }
         if(_loc5_.length > 0)
         {
            _loc5_.sortOn("distance",Array.NUMERIC);
            param1.targetBuilding = _loc5_[0].building;
            if(param1.targetBuilding._type == 6 || param1.targetBuilding._type == 14)
            {
               param1.resourcesGained = 0.04 * BASE._resources.r1.Get();
            }
            else
            {
               param1.resourcesGained = 0.1 * param1.targetBuilding._stored.Get();
            }
            if(param1.resourcesGained > 10000)
            {
               param1.resourcesGained = 10000;
            }
            param1.wayPoints = PATHING.GetPath(GRID.ToISO(param1.entryPoint.x,param1.entryPoint.y,0),new Rectangle(param1.targetBuilding.x,param1.targetBuilding.y,param1.targetBuilding._footprint[0].width,param1.targetBuilding._footprint[0].height),param2);
         }
      }
      
      public function onProcess(param1:Array, param2:BFOUNDATION = null, param3:int = 0, param4:Boolean = false, param5:BFOUNDATION = null) : void
      {
         this._solutions[this.solsProcessed].wayPoints = param1;
         this._solutions[this.solsProcessed].distanceToTarget = param1.length;
         this.solsProcessed += 1;
         if(this.solsProcessed < WMATTACK._attackResolution)
         {
            this.Process(this._solutions[this.solsProcessed],this.onProcess);
         }
         else
         {
            this.beginProcessB();
         }
      }
      
      public function beginProcessB() : void
      {
         var _loc2_:Solution = null;
         var _loc3_:int = 0;
         var _loc1_:Array = [].concat();
         for each(_loc2_ in this._solutions)
         {
            this.ProcessB(_loc2_);
            _loc1_.push(_loc2_);
         }
         _loc1_.sortOn(["damageTaken","distanceToTarget","resourcesGained"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         _loc3_ = int((_loc1_.length - 1) * this._intelligence);
         this.ProcessC(_loc1_[_loc3_]);
         this._inProgress = false;
         WMATTACK.Queue(_loc1_[_loc3_]);
      }
      
      public function ProcessB(param1:Solution) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.wayPoints.length)
         {
            param1.damageTaken += WMATTACK._damageBias * this.processStepResolution * WMATTACK.dpsAtPoint(param1,param1.wayPoints[_loc2_]);
            _loc2_ += this.processStepResolution;
         }
      }
      
      public function ProcessC(param1:Solution) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:BFOUNDATION = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc26_:String = null;
         var _loc2_:Object = {};
         var _loc3_:int = 0;
         while(_loc3_ < WMATTACK._monsterKeys.length)
         {
            _loc2_[WMATTACK._monsterKeys[_loc3_]] = 0;
            _loc3_ += 1;
         }
         var _loc4_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc5_:Number = 0;
         for each(_loc7_ in _loc4_)
         {
            if(_loc7_._class == "special" || _loc7_ is BTOWER || _loc7_ is BTRAP || _loc7_ is BWALL || _loc7_ is BRESOURCE)
            {
               _loc6_ = _loc7_ is BWALL || _loc7_ is BTRAP ? 0.01 : 0.3;
               _loc5_ += _loc6_ * WMATTACK._attackVolumeAmplifier;
            }
         }
         _loc8_ = this._intelligence * 0.5 + 0.5;
         _loc5_ = int(_loc5_ * _loc8_);
         _loc9_ = 0.3;
         _loc10_ = 0.2;
         if(param1.damageTaken > 0)
         {
            _loc11_ = _loc10_ * _loc5_;
            _loc13_ = (_loc12_ = (_loc5_ - _loc11_) / (_loc9_ + 1)) / _loc9_;
         }
         else
         {
            _loc11_ = 0;
            _loc12_ = 0;
            if((_loc13_ = _loc5_) < 1)
            {
               _loc13_++;
            }
         }
         _loc11_ = Math.ceil(_loc11_);
         _loc12_ = Math.ceil(_loc12_);
         if((_loc13_ = Math.ceil(_loc13_)) > 5)
         {
            _loc11_ += _loc13_ - 5;
            _loc13_ = 5;
         }
         var _loc14_:Number;
         if((_loc14_ = BASE.BaseLevel().level / 40) < 0)
         {
            _loc14_ = 0;
         }
         if(_loc14_ > 1)
         {
            _loc14_ = 1;
         }
         var _loc15_:String = String(WMATTACK._looters[int((WMATTACK._looters.length - 2) * _loc14_)]);
         var _loc16_:String = String(WMATTACK._tanks[int((WMATTACK._tanks.length - 1) * _loc14_)]);
         var _loc17_:String = String(WMATTACK._kamikaze[int((WMATTACK._kamikaze.length - 1) * _loc14_)]);
         var _loc18_:Number = 0;
         var _loc19_:Object = {};
         var _loc20_:Number = GLOBAL._mapWidth * 0.25;
         var _loc21_:Number = 100;
         var _loc22_:Number;
         if((_loc22_ = Point.distance(param1.entryPoint,new Point(param1.targetBuilding.x,param1.targetBuilding.y))) < _loc21_)
         {
            _loc20_ += _loc21_ - _loc22_;
         }
         if(_loc12_ >= 1)
         {
            if(_loc18_ == 0)
            {
               _loc18_ = _loc20_ / CREATURELOCKER._creatures[_loc16_].props.speed[0];
            }
            _loc19_[_loc16_] = _loc18_ * CREATURELOCKER._creatures[_loc16_].props.speed[0];
         }
         if(_loc13_ >= 1)
         {
            if(_loc18_ == 0)
            {
               _loc18_ = _loc20_ / CREATURELOCKER._creatures[_loc17_].props.speed[0];
            }
            _loc19_[_loc17_] = 40 + _loc18_ * CREATURELOCKER._creatures[_loc17_].props.speed[0];
         }
         if(_loc11_ >= 1)
         {
            if(_loc18_ == 0)
            {
               _loc18_ = _loc20_ / CREATURELOCKER._creatures[_loc15_].props.speed[0];
            }
            _loc19_[_loc15_] = 80 + _loc18_ * CREATURELOCKER._creatures[_loc15_].props.speed[0];
         }
         if(_loc16_ == "C12")
         {
            _loc12_ = Math.ceil(_loc12_ / 2);
         }
         _loc2_[_loc15_] = int(_loc11_);
         _loc2_[_loc16_] = int(_loc12_);
         _loc2_[_loc17_] = int(_loc13_);
         var _loc23_:Object;
         (_loc23_ = {})[_loc16_] = int(_loc12_);
         var _loc24_:Object;
         (_loc24_ = {})[_loc17_] = int(_loc13_);
         var _loc25_:Object;
         (_loc25_ = {})[_loc15_] = int(_loc11_);
         for(_loc26_ in _loc2_)
         {
            if(_loc2_[_loc26_] == 0)
            {
               delete _loc2_[_loc26_];
            }
         }
         param1.attack = _loc2_;
         param1.looters = _loc25_;
         param1.tanks = _loc23_;
         param1.dps = _loc24_;
         param1.distances = _loc19_;
      }
   }
}

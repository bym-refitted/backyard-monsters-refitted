package com.monsters.monsters.champions
{
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.interfaces.ILootable;
   import com.monsters.managers.InstanceManager;
   import com.monsters.pathing.PATHING;
   import com.monsters.rendering.RasterData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class Krallen extends ChampionBase
   {
      
      public static const MAX_POWERLEVEL:int = 2;
      
      public static const TYPE:uint = 5;
       
      
      public var _lootMults:Dictionary;
      
      public function Krallen(param1:String, param2:Point, param3:Number, param4:Point = null, param5:Boolean = false, param6:BFOUNDATION = null, param7:int = 1, param8:int = 0, param9:int = 0, param10:int = 1, param11:int = 20000, param12:int = 0, param13:int = 1)
      {
         var _loc14_:Array = null;
         var _loc17_:uint = 0;
         var _loc18_:Class = null;
         param13 = Math.min(param13,MAX_POWERLEVEL);
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
         _loc14_ = CHAMPIONCAGE.GetGuardianProperties(_creatureID,"abilities");
         var _loc15_:Number = _powerLevel.Get();
         var _loc16_:uint = _loc14_.length;
         this._lootMults = new Dictionary();
         this._lootMults[BRESOURCE] = new SecNum(2);
         this._lootMults[BSTORAGE] = new SecNum(3);
         _buff = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_level.Get(),"buffs");
         while(_loc17_ < _loc16_)
         {
            if(_loc15_ < _loc17_)
            {
               break;
            }
            if(_loc18_ = _loc14_[_loc17_] as Class)
            {
               addComponent(new _loc18_());
            }
            _loc17_++;
         }
      }
      
      override protected function setupSprite() : void
      {
         _frameNumber = Math.random() * 7;
         _spriteID = _creatureID + "_" + _powerLevel.Get();
         SPRITES.SetupSprite(_spriteID);
         var _loc1_:Object = SPRITES.GetSpriteDescriptor(_spriteID);
         _graphic = new BitmapData(_loc1_.width,_loc1_.height,true,16777215);
         _graphicMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_graphic) : graphic.addChild(new Bitmap(_graphic)) as Bitmap;
         _graphicMC.x = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_powerLevel.Get(),"offset_x");
         _graphicMC.y = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_powerLevel.Get(),"offset_y");
         if(BYMConfig.instance.RENDERER_ON)
         {
            _rasterData = new RasterData(_graphicMC,_rasterPt,int.MAX_VALUE);
         }
      }
      
      override public function findTarget(param1:int = 0) : void
      {
         var _loc6_:Object = null;
         var _loc7_:BFOUNDATION = null;
         var _loc8_:BFOUNDATION = null;
         var _loc9_:Point = null;
         var _loc10_:Boolean = false;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:String = null;
         var _loc17_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:Point = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:Number = NaN;
         var _loc25_:int = 0;
         var _loc26_:Point = null;
         var _loc2_:Object = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc3_:Vector.<Object> = InstanceManager.getInstancesByClass(BTOWER);
         var _loc4_:Vector.<Object> = InstanceManager.getInstancesByClass(Bunker);
         var _loc5_:Vector.<Object> = InstanceManager.getInstancesByClass(MONSTERBUNKER);
         var _loc14_:Array = [];
         var _loc18_:Dictionary = new Dictionary();
         _looking = true;
         _loc11_ = PATHING.FromISO(_tmpPoint);
         for each(_loc7_ in _loc2_)
         {
            if(_loc7_.health > 0 && _loc7_ is ILootable)
            {
               if(!_loc7_._looted)
               {
                  _loc12_ = GRID.FromISO(_loc7_._mc.x,_loc7_._mc.y + _loc7_._middle);
                  _loc13_ = GLOBAL.QuickDistance(_loc11_,_loc12_) - _loc7_._middle;
                  _loc14_.push({
                     "building":_loc7_,
                     "distance":_loc13_
                  });
                  _loc17_ = true;
               }
               else
               {
                  _loc18_[_loc7_] = true;
               }
            }
         }
         if(!_loc17_)
         {
            for each(_loc7_ in _loc3_)
            {
               if(_loc7_.health > 0 && !(_loc7_ as BTOWER).isJard)
               {
                  _loc12_ = GRID.FromISO(_loc7_._mc.x,_loc7_._mc.y + _loc7_._middle);
                  _loc13_ = GLOBAL.QuickDistance(_loc11_,_loc12_) - _loc7_._middle;
                  _loc14_.push({
                     "building":_loc7_,
                     "distance":_loc13_,
                     "expand":false
                  });
                  _loc17_ = true;
               }
            }
         }
         if(!_loc17_)
         {
            for each(_loc7_ in _loc4_)
            {
               if((_loc15_ = _loc7_).health > 0 && (_loc15_._used > 0 || _loc15_._monstersDispatchedTotal > 0))
               {
                  _loc12_ = GRID.FromISO(_loc7_._mc.x,_loc7_._mc.y + _loc7_._middle);
                  _loc13_ = GLOBAL.QuickDistance(_loc11_,_loc12_) - _loc7_._middle;
                  _loc14_.push({
                     "building":_loc7_,
                     "distance":_loc13_,
                     "expand":false
                  });
               }
            }
         }
         if(!_loc17_)
         {
            for(_loc16_ in _loc18_)
            {
               if(_loc7_ = _loc18_[_loc16_] as BFOUNDATION)
               {
                  _loc12_ = GRID.FromISO(_loc7_._mc.x,_loc7_._mc.y + _loc7_._middle);
                  _loc13_ = GLOBAL.QuickDistance(_loc11_,_loc12_) - _loc7_._middle;
                  _loc14_.push({
                     "building":_loc7_,
                     "distance":_loc13_,
                     "expand":true
                  });
                  _loc17_ = true;
               }
            }
         }
         if(_loc14_.length == 0)
         {
            for each(_loc7_ in BASE._buildingsMain)
            {
               if(_loc7_._class != "decoration" && _loc7_._class != "immovable" && _loc7_.health > 0 && _loc7_._class != "enemy")
               {
                  if(_loc7_._class == "tower" && !MONSTERBUNKER.isBunkerBuilding(_loc7_._type))
                  {
                     if((_loc7_ as BTOWER).isJard)
                     {
                        continue;
                     }
                  }
                  _loc12_ = GRID.FromISO(_loc7_._mc.x,_loc7_._mc.y + _loc7_._middle);
                  _loc13_ = GLOBAL.QuickDistance(_loc11_,_loc12_) - _loc7_._middle;
                  _loc14_.push({
                     "building":_loc7_,
                     "distance":_loc13_,
                     "expand":true
                  });
               }
            }
         }
         if(_loc14_.length == 0)
         {
            changeModeRetreat();
         }
         else
         {
            _loc14_.sortOn("distance",Array.NUMERIC);
            _loc19_ = 0;
            if(_movement == "burrow")
            {
               _hasTarget = true;
               _hasPath = true;
               _loc20_ = GRID.FromISO(_loc14_[_loc19_].building._mc.x,_loc14_[_loc19_].building._mc.y);
               _loc21_ = int(Math.random() * 4);
               _loc22_ = int(_loc14_[_loc19_].building._footprint[0].height);
               _loc23_ = int(_loc14_[_loc19_].building._footprint[0].width);
               if(_loc21_ == 0)
               {
                  _loc20_.x += Math.random() * _loc22_;
                  _loc20_.y += _loc23_;
               }
               else if(_loc21_ == 1)
               {
                  _loc20_.x += _loc22_;
                  _loc20_.y += _loc23_;
               }
               else if(_loc21_ == 2)
               {
                  _loc20_.x += _loc22_ - Math.random() * _loc22_ / 2;
                  _loc20_.y -= _loc23_ / 4;
               }
               else if(_loc21_ == 3)
               {
                  _loc20_.x -= _loc22_ / 4;
                  _loc20_.y += _loc23_ - Math.random() * _loc23_ / 2;
               }
               _waypoints = [GRID.ToISO(_loc20_.x,_loc20_.y,0)];
               _targetPosition = _waypoints[0];
               _targetBuilding = _loc14_[_loc19_].building;
            }
            else if(_movement == "fly")
            {
               _hasTarget = true;
               _hasPath = true;
               _targetBuilding = _loc14_[_loc19_].building;
               _targetCenter = _targetBuilding._position;
               if(GLOBAL.QuickDistance(_tmpPoint,_targetCenter) < 170)
               {
                  _atTarget = true;
                  _hasPath = true;
                  _targetPosition = _targetCenter;
               }
               else
               {
                  _loc24_ = (_loc24_ = (_loc24_ = Math.atan2(_tmpPoint.y - _targetCenter.y,_tmpPoint.x - _targetCenter.x) * 57.2957795) + (Math.random() * 40 - 20)) / (180 / Math.PI);
                  _loc25_ = 120 + Math.random() * 10;
                  _loc26_ = new Point(_targetCenter.x + Math.cos(_loc24_) * _loc25_ * 1.7,_targetCenter.y + Math.sin(_loc24_) * _loc25_);
                  _waypoints = [_loc26_];
                  _targetPosition = _waypoints[0];
               }
            }
            else if(GLOBAL._catchup)
            {
               WaypointTo(new Point(_loc14_[0].building._mc.x,_loc14_[0].building._mc.y),_loc14_[0].building);
            }
            else
            {
               _loc19_ = 0;
               while(_loc19_ < 2)
               {
                  if(_loc14_.length > _loc19_)
                  {
                     WaypointTo(new Point(_loc14_[_loc19_].building._mc.x,_loc14_[_loc19_].building._mc.y),_loc14_[_loc19_].building);
                  }
                  _loc19_++;
               }
            }
         }
      }
      
      override public function clear() : void
      {
         this._lootMults = null;
         super.clear();
      }
   }
}

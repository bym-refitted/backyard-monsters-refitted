package com.monsters.pathing
{
   import com.monsters.managers.InstanceManager;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class PATHING
   {
      private static var _poolPathing:Vector.<PATHINGobject>;
      
      private static var _poolPathingB:Vector.<PATHINGobject>;
      
      private static var _poolPathingLength:int;
      
      public static var floodDisplay:DisplayObject;
      
      public static var floodBMD:BitmapData;
      
      public static var costDisplay:DisplayObject;
      
      public static var costBMD:BitmapData;
      
      public static var pathmc:DisplayObject;
      
      private static const PI:Number = Math.PI;
      
      private static const c180PI:Number = 180 / PI;
      
      private static const cPI180:Number = PI / 180;
      
      private static var _gridWidth:int = 164;
      
      private static var _gridHeight:int = 132;
      
      private static var _floods:Object = {};
      
      private static var _costs:Object = {};
      
      private static var _framenumber:int = 0;
      
      private static var _clicked:Boolean = false;
      
      private static var _resetRequested:Boolean = false;
      
      public function PATHING()
      {
         super();
      }
      
      public static function Setup() : void
      {
         var _loc2_:PATHINGobject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = getTimer();
         _loc4_ = 0;
         while(_loc4_ < _gridWidth)
         {
            _loc5_ = 0;
            while(_loc5_ < _gridHeight)
            {
               _loc3_ = _loc4_ * 1000 + _loc5_;
               _loc2_ = new PATHINGobject();
               _loc2_.pointX = _loc4_;
               _loc2_.pointY = _loc5_;
               _loc2_.cost = 10;
               _costs[_loc3_] = _loc2_;
               _loc5_ += 1;
            }
            _loc4_ += 1;
         }
         _poolPathing = new Vector.<PATHINGobject>();
         _poolPathingB = new Vector.<PATHINGobject>();
         _poolPathingLength = 0;
      }
      
      public static function Cost(param1:Point, param2:Rectangle, param3:int) : Rectangle
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Rectangle = null;
         var _loc10_:int = 0;
         _loc4_ = FromISO(param1);
         _loc4_.x += param2.x;
         _loc4_.y += param2.y;
         _loc5_ = GlobalLocal(_loc4_);
         _loc9_ = new Rectangle(_loc5_.x,_loc5_.y,param2.width * 0.1,param2.height * 0.1);
         _loc7_ = _loc9_.x;
         while(_loc7_ < _loc9_.x + _loc9_.width)
         {
            _loc8_ = _loc9_.y;
            while(_loc8_ < _loc9_.y + _loc9_.height)
            {
               _loc6_ = _loc7_ * 1000 + _loc8_;
               if(_costs[_loc6_])
               {
                  _loc10_ = int(_costs[_loc6_].cost);
                  _costs[_loc6_].cost += param3;
                  if(_costs[_loc6_].cost < 2)
                  {
                     _costs[_loc6_].cost = 2;
                  }
               }
               _loc8_ += 1;
            }
            _loc7_ += 1;
         }
         return _loc9_;
      }
      
      public static function RegisterBuilding(param1:Rectangle, param2:BFOUNDATION, param3:Boolean) : void
      {
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = GlobalLocal(FromISO(new Point(param1.x,param1.y)));
         param1.width *= 0.1;
         param1.height *= 0.1;
         _loc6_ = _loc4_.x;
         while(_loc6_ < _loc4_.x + param1.width)
         {
            _loc7_ = _loc4_.y;
            while(_loc7_ < _loc4_.y + param1.height)
            {
               _loc5_ = _loc6_ * 1000 + _loc7_;
               if(_costs[_loc5_])
               {
                  if(param3)
                  {
                     _costs[_loc5_].building = param2;
                  }
                  else
                  {
                     delete _costs[_loc5_].building;
                  }
               }
               _loc7_ += 1;
            }
            _loc6_ += 1;
         }
      }
      
      public static function Tick() : void
      {
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:BFOUNDATION = null;
         var _loc9_:Array = null;
         var _loc10_:Vector.<Object> = null;
         var _loc1_:int = getTimer();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(_resetRequested)
         {
            _resetRequested = false;
            _loc5_ = new Point(0,0);
            Clear();
            _loc6_ = 0;
            while(_loc6_ < _gridWidth)
            {
               _loc7_ = 0;
               while(_loc7_ < _gridHeight)
               {
                  _costs[_loc6_ * 1000 + _loc7_].cost = 10;
                  _loc7_ += 1;
               }
               _loc6_ += 1;
            }
            _loc2_ = getTimer() - _loc1_;
            _loc10_ = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each(_loc8_ in _loc10_)
            {
               if(Boolean(_loc8_._gridCost) && (_loc8_.health > 0 || _loc8_ is BMUSHROOM))
               {
                  for each(_loc9_ in _loc8_._gridCost)
                  {
                     _loc5_.x = _loc8_.x;
                     _loc5_.y = _loc8_.y;
                     PATHING.Cost(_loc5_,_loc9_[0],_loc9_[1]);
                  }
               }
            }
            _loc3_ = getTimer() - _loc1_;
            _loc4_ = getTimer() - _loc1_;
         }
         ProcessFlood();
      }
      
      public static function GetPath(param1:Point, param2:Rectangle, param3:Function = null, param4:Boolean = false, param5:BFOUNDATION = null) : Array
      {
         var _loc6_:Point = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         _loc9_ = param1;
         _loc10_ = new Point(param2.x,param2.y);
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         param2.x = int(param2.x);
         param2.y = int(param2.y);
         _loc6_ = FromISO(param1);
         _loc8_ = FromISO(new Point(param2.x,param2.y));
         _loc7_ = param2;
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
         _loc6_ = GlobalLocal(_loc6_);
         _loc8_ = GlobalLocal(new Point(_loc7_.x,_loc7_.y));
         _loc7_.x = int(_loc8_.x);
         _loc7_.y = int(_loc8_.y);
         _loc7_.width *= 0.1;
         _loc7_.height *= 0.1;
         GetPathB(_loc6_,_loc7_,_loc9_,_loc10_,param3,param4,param5);
         return [];
      }
      
      public static function GetPathB(param1:Point, param2:Rectangle, param3:Point, param4:Point, param5:Function = null, param6:Boolean = false, param7:BFOUNDATION = null) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:int = 0;
         var _loc18_:PATHINGfloodobject = null;
         var _loc23_:int = 0;
         var _loc24_:PATHINGobject = null;
         var _loc25_:PATHINGobject = null;
         var _loc26_:PATHINGobject = null;
         RenderCosts();
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         param2.x = int(param2.x);
         param2.y = int(param2.y);
         _loc9_ = param1.x * 1000 + param1.y;
         _loc8_ = param2.x * 1000 + param2.y;
         if(!_costs[_loc9_] && !_costs[_loc8_])
         {
            param5([param3,param4],param7);
            RenderPath([param3,param4]);
            return;
         }
         if(!_costs[_loc9_])
         {
            _loc10_ = 90 - Math.atan2(param2.y - param1.y,param2.x - param1.x) * 57.2957795;
            _loc11_ = Math.sin(_loc10_ * 0.0174532925) * 5;
            _loc12_ = Math.cos(_loc10_ * 0.0174532925) * 5;
            _loc13_ = 0;
            while(!_costs[_loc9_] && _loc13_ < 2000)
            {
               _loc13_ += 1;
               param1.x += _loc11_;
               param1.y += _loc12_;
               _loc9_ = int(param1.x) * 1000 + int(param1.y);
            }
            param1.x = int(param1.x);
            param1.y = int(param1.y);
         }
         if(!_costs[_loc8_])
         {
            param5([param3,param4],param7);
            RenderPath([param3,param4]);
            return;
         }
         if(param6)
         {
            _loc8_ += 1000000;
         }
         if(!_floods[_loc8_])
         {
            _loc14_ = {};
            _loc15_ = {};
            _loc16_ = {};
            _loc17_ = 0;
            while(_loc17_ < param2.width)
            {
               _loc23_ = 0;
               while(_loc23_ < param2.height)
               {
                  _loc24_ = new PATHINGobject();
                  _loc24_.pointX = param2.x + _loc17_;
                  _loc24_.pointY = param2.y + _loc23_;
                  _loc24_.depth = 0;
                  _loc14_[param2.x + _loc17_ * 1000 + param2.y + _loc23_] = _loc24_;
                  _loc25_ = new PATHINGobject();
                  _loc25_.pointX = param2.x + _loc17_;
                  _loc25_.pointY = param2.y + _loc23_;
                  _loc25_.depth = 0;
                  _loc15_[param2.x + _loc17_ * 1000 + param2.y + _loc23_] = _loc25_;
                  _loc26_ = new PATHINGobject();
                  _loc26_.pointX = param2.x + _loc17_;
                  _loc26_.pointY = param2.y + _loc23_;
                  _loc26_.depth = 0;
                  _loc16_[param2.x + _loc17_ * 1000 + param2.y + _loc23_] = _loc26_;
                  _loc23_ += 1;
               }
               _loc17_ += 1;
            }
            _loc18_ = new PATHINGfloodobject();
            _loc18_.flood = _loc15_;
            _loc18_.edge = _loc14_;
            _loc18_.start = _loc16_;
            _loc18_.ignoreWalls = param6;
            _floods[_loc8_] = _loc18_;
         }
         if(!_floods[_loc8_].startpoints[_loc9_])
         {
            _floods[_loc8_].startpoints[_loc9_] = {
               "startID":_loc9_,
               "callbackfunctions":[],
               "startPoint":param1
            };
         }
         _floods[_loc8_].startpoints[_loc9_].callbackfunctions.push([param5,param6,param7,param4]);
         _floods[_loc8_].pending += 1;
      }
      
      private static function ProcessFlood(param1:Event = null) : void
      {
         var _loc4_:PATHINGobject = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PATHINGobject = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:PATHINGfloodobject = null;
         var _loc2_:int = getTimer();
         var _loc3_:int = getTimer();
         for each(_loc18_ in _floods)
         {
            if(_loc18_.pending)
            {
               _loc16_ += 1;
            }
         }
         _loc15_ = 25 / _loc16_;
         if(_loc15_ < 5)
         {
            _loc15_ = 5;
         }
         for each(_loc18_ in _floods)
         {
            if(_loc18_.pending)
            {
               _loc3_ = getTimer();
               _loc11_ = 0;
               _loc14_ = 0;
               while(getTimer() - _loc3_ < _loc15_ && _loc18_.pending > 0)
               {
                  _loc12_ = {};
                  _loc13_ = 9999999;
                  _loc18_.edgeLength = 0;
                  for each(_loc4_ in _loc18_.edge)
                  {
                     if(_loc4_.depth <= _loc18_.minDepth)
                     {
                        _loc5_ = _loc4_.pointX;
                        _loc6_ = _loc4_.pointY;
                        _loc9_ = _loc5_ - 1;
                        while(_loc9_ < _loc5_ + 2)
                        {
                           _loc10_ = _loc6_ - 1;
                           while(_loc10_ < _loc6_ + 2)
                           {
                              if(!(_loc9_ == _loc5_ && _loc10_ == _loc6_))
                              {
                                 _loc8_ = _loc9_ * 1000 + _loc10_;
                                 if(!_loc18_.flood[_loc8_])
                                 {
                                    if(!_loc12_[_loc8_])
                                    {
                                       if(_costs[_loc8_])
                                       {
                                          _loc11_ += 1;
                                          _loc7_ = new PATHINGobject();
                                          _loc7_.pointX = _loc9_;
                                          _loc7_.pointY = _loc10_;
                                          _loc17_ = int(_costs[_loc8_].cost);
                                          if(_loc18_.ignoreWalls)
                                          {
                                             if(_costs[_loc8_].building)
                                             {
                                                _loc17_ = 20;
                                             }
                                          }
                                          if(_loc9_ != _loc4_.pointX && _loc10_ != _loc4_.pointY)
                                          {
                                             _loc17_ *= 1.5;
                                          }
                                          _loc7_.depth = _loc4_.depth + _loc17_;
                                          if(_loc7_.depth < _loc13_)
                                          {
                                             _loc13_ = _loc7_.depth;
                                          }
                                          _loc12_[_loc8_] = _loc7_;
                                          _loc18_.flood[_loc8_] = _loc7_;
                                          _loc18_.edgeLength += 1;
                                          _loc14_ += 1;
                                       }
                                    }
                                 }
                              }
                              _loc10_ += 1;
                           }
                           _loc9_ += 1;
                        }
                     }
                     else
                     {
                        _loc12_[_loc4_.pointID] = _loc4_;
                        _loc18_.edgeLength += 1;
                        if(_loc4_.depth < _loc13_)
                        {
                           _loc13_ = _loc4_.depth;
                        }
                     }
                  }
                  _loc18_.edge = _loc12_;
                  _loc18_.minDepth = _loc13_;
                  CheckStartReached(_loc18_);
               }
            }
         }
      }
      
      private static function CheckStartReached(param1:PATHINGfloodobject) : int
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.startpoints)
         {
            if(Boolean(_loc3_) && Boolean(param1.flood[_loc3_.startID]))
            {
               for each(_loc4_ in _loc3_.callbackfunctions)
               {
                  Path(param1.flood,_loc3_.startID,_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
                  --param1.pending;
                  _loc2_ += 1;
               }
               _loc3_.callbackfunctions = [];
               delete param1.startpoints[_loc3_.startID];
            }
         }
         return _loc2_;
      }
      
      public static function Path(param1:Object, param2:int, param3:Function, param4:Boolean = false, param5:BFOUNDATION = null, param6:Point = null) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Point = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Boolean = false;
         var _loc18_:BFOUNDATION = null;
         var _loc19_:Boolean = false;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:Point = null;
         var _loc28_:int = 0;
         var _loc7_:int = getTimer();
         var _loc10_:Array = [];
         var _loc11_:int = 0;
         if(param1[param2])
         {
            _loc8_ = int(param1[param2].pointX);
            _loc9_ = int(param1[param2].pointY);
            _loc14_ = int(param1[param2].depth);
            _loc10_[_loc11_] = ToISO(LocalGlobal(new Point(_loc8_,_loc9_)),0);
            _loc11_ += 1;
            _loc19_ = true;
         }
         _loc13_ = new Point(0,0);
         while(_loc19_)
         {
            _loc19_ = false;
            _loc20_ = -1;
            while(_loc20_ < 2)
            {
               _loc21_ = -1;
               while(_loc21_ < 2)
               {
                  if(!(_loc20_ == 0 && _loc21_ == 0))
                  {
                     _loc13_.x = _loc8_ + _loc20_;
                     _loc13_.y = _loc9_ + _loc21_;
                     _loc12_ = _loc13_.x * 1000 + _loc13_.y;
                     if(param1[_loc12_] && param1[_loc12_].depth < _loc14_ && param1[_loc12_].depth > 0)
                     {
                        _loc15_ = _loc13_.x;
                        _loc16_ = _loc13_.y;
                        _loc17_ = true;
                        _loc14_ = int(param1[_loc12_].depth);
                        _loc19_ = true;
                        if(!param4 && _loc11_ > 1)
                        {
                           if(_costs[_loc12_])
                           {
                              _loc18_ = _costs[_loc12_].building;
                              if(_loc18_)
                              {
                                 if(_loc18_.health > 0)
                                 {
                                    _loc22_ = (_loc18_._lvl.Get() ^ 2) + 1;
                                    _loc23_ = 0;
                                    while(_loc23_ < _loc22_)
                                    {
                                       _loc10_.push(_loc10_[_loc10_.length - 1]);
                                       _loc23_++;
                                    }
                                    param3(_loc10_,_loc18_);
                                    RenderPath(_loc10_);
                                    return;
                                 }
                              }
                           }
                        }
                        if(!param4 && _loc14_ < 20)
                        {
                           if(Math.random() < 0.6)
                           {
                              _loc24_ = new Array();
                              _loc23_ = -3;
                              while(_loc23_ < 4)
                              {
                                 _loc25_ = -3;
                                 while(_loc25_ < 4)
                                 {
                                    if(Boolean(_loc23_) && Boolean(_loc25_))
                                    {
                                       _loc26_ = (_loc15_ + _loc23_) * 1000 + _loc16_ + _loc25_;
                                       if(param1[_loc26_])
                                       {
                                          if(param1[_loc26_].depth < 20 && param1[_loc26_].depth > 0)
                                          {
                                             _loc27_ = new Point(_loc15_ + _loc23_,_loc16_ + _loc25_);
                                             _loc24_.push(_loc27_);
                                          }
                                       }
                                    }
                                    _loc25_++;
                                 }
                                 _loc23_++;
                              }
                              if(_loc24_.length > 0)
                              {
                                 _loc28_ = int(Math.random() * _loc24_.length);
                                 _loc15_ = int(_loc24_[_loc28_].x);
                                 _loc16_ = int(_loc24_[_loc28_].y);
                              }
                           }
                        }
                     }
                  }
                  _loc21_ += 1;
               }
               _loc20_ += 1;
            }
            if(_loc17_)
            {
               _loc8_ = _loc15_;
               _loc9_ = _loc16_;
               _loc10_[_loc11_] = ToISO(LocalGlobal(Jiggle(_loc15_,_loc16_)),0);
               _loc11_ += 1;
            }
         }
         if(param6)
         {
            _loc13_ = GlobalLocal(FromISO(param6));
            if(!param5 || !_costs[_loc13_.x * 1000 + _loc13_.y])
            {
               _loc10_[_loc11_] = param6;
            }
         }
         RenderFlood();
         RenderPath(_loc10_);
         param3(_loc10_,param5);
      }
      
      private static function Jiggle(param1:int, param2:int) : Point
      {
         return new Point(param1 + (Math.random() - 0.5) * 0.4,param2 + (Math.random() - 0.5) * 0.4);
      }
      
      public static function GetBuildingFromISO(param1:Point) : BFOUNDATION
      {
         var _loc2_:Point = FromISO(param1);
         var _loc3_:Point = GlobalLocal(_loc2_);
         var _loc4_:int = 1000 * int(_loc3_.x) + int(_loc3_.y);
         if(_costs[_loc4_])
         {
            return _costs[_loc4_].building;
         }
         return null;
      }
      
      public static function Clear() : void
      {
         var _loc3_:PATHINGfloodobject = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = getTimer();
         for each(_loc3_ in _floods)
         {
            for each(_loc5_ in _loc3_.startpoints)
            {
               if(_loc5_.callbackfunctions)
               {
                  _loc6_ = _loc5_.callbackfunctions;
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.length)
                  {
                     _loc1_.push(_loc6_[_loc7_][0]);
                     _loc7_++;
                  }
               }
            }
         }
         _floods = {};
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc1_[_loc4_]([],null,true);
            _loc4_++;
         }
      }
      
      public static function Cleanup() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in _costs)
         {
            delete _costs[_loc1_];
         }
         _costs = {};
         _floods = {};
      }
      
      public static function LineOfSight(param1:int, param2:int, param3:int, param4:int, param5:BFOUNDATION = null, param6:Boolean = false) : Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BFOUNDATION = null;
         var _loc16_:int = 0;
         var _loc18_:int = 0;
         var _loc10_:Point = GlobalLocal(FromISO(new Point(param1,param2)));
         var _loc11_:Point = GlobalLocal(FromISO(new Point(param3,param4)));
         param1 = _loc10_.x;
         param2 = _loc10_.y;
         param3 = _loc11_.x;
         param4 = _loc11_.y;
         var _loc12_:Number = param3 - param1;
         var _loc13_:Number = param4 - param2;
         var _loc14_:Number = Math.atan2(_loc13_,_loc12_) * c180PI;
         var _loc15_:Number = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_);
         _loc7_ = 0;
         while(_loc7_ < _loc15_)
         {
            _loc16_ = param1 + Math.cos(_loc14_ * cPI180) * _loc7_;
            _loc18_ = param2 + Math.sin(_loc14_ * cPI180) * _loc7_;
            _loc8_ = _loc16_ * 1000 + _loc18_;
            if(!_costs[_loc8_])
            {
               return true;
            }
            _loc9_ = _costs[_loc8_].building;
            if(Boolean(_loc9_) && _loc9_.health > 0)
            {
               if(!(Boolean(param5) && _loc9_ == param5))
               {
                  if(_loc9_._type == 17 || param6)
                  {
                     return false;
                  }
               }
            }
            _loc7_++;
         }
         return true;
      }
      
      public static function ResetCosts() : void
      {
         _resetRequested = true;
      }
      
      public static function Wander(param1:Point, param2:int = 50, param3:Function = null) : void
      {
         var _loc7_:Point = null;
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         var _loc4_:Array = [];
         var _loc5_:int = 0 - param2;
         while(_loc5_ < param2)
         {
            if(!GRID.Blocked(param1.add(new Point(_loc5_,0 - param2))))
            {
               _loc4_.push(param1.add(new Point(_loc5_,0 - param2)));
            }
            if(!GRID.Blocked(param1.add(new Point(_loc5_,param2))))
            {
               _loc4_.push(param1.add(new Point(_loc5_,param2)));
            }
            if(!GRID.Blocked(param1.add(new Point(0 - param2,_loc5_))))
            {
               _loc4_.push(param1.add(new Point(0 - param2,_loc5_)));
            }
            if(!GRID.Blocked(param1.add(new Point(param2,_loc5_))))
            {
               _loc4_.push(param1.add(new Point(param2,_loc5_)));
            }
            _loc5_ += 10;
         }
         var _loc6_:Point = param1;
         if(_loc4_.length > 0)
         {
            _loc7_ = _loc4_[int(Math.random() * _loc4_.length)];
            GetPath(param1,new Rectangle(_loc7_.x,_loc7_.y,10,10),param3);
         }
      }
      
      public static function RenderFlood() : void
      {
         if(GLOBAL._catchup)
         {
         }
      }
      
      public static function RenderCosts() : void
      {
      }
      
      public static function RenderPath(param1:Array, param2:Boolean = false) : void
      {
      }
      
      public static function getNumberAsHexString(param1:uint, param2:uint = 1, param3:Boolean = true) : String
      {
         var _loc4_:String = param1.toString(16).toUpperCase();
         while(param2 > _loc4_.length)
         {
            _loc4_ = "0" + _loc4_;
         }
         if(param3)
         {
            _loc4_ = "0x" + _loc4_;
         }
         return _loc4_;
      }
      
      private static function GlobalLocal(param1:Point) : Point
      {
         param1.x *= 0.1;
         param1.y *= 0.1;
         param1.x += _gridWidth >> 1;
         param1.y += _gridHeight >> 1;
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         return param1;
      }
      
      public static function LocalGlobal(param1:Point) : Point
      {
         param1.x -= _gridWidth >> 1;
         param1.y -= _gridHeight >> 1;
         param1.x *= 10;
         param1.y *= 10;
         return param1;
      }
      
      public static function ToISO(param1:Point, param2:int) : Point
      {
         var _loc3_:int = (param1.x + param1.y) * 0.5 - param2;
         var _loc5_:int = param1.x - param1.y;
         return new Point(_loc5_,_loc3_);
      }
      
      public static function FromISO(param1:Point) : Point
      {
         var _loc2_:int = param1.y - param1.x * 0.5;
         var _loc3_:int = param1.x * 0.5 + param1.y;
         return new Point(_loc3_,_loc2_);
      }
      
      public static function PlotRandom(param1:MouseEvent) : void
      {
         var Done:Function = null;
         var e:MouseEvent = param1;
         Done = function(param1:Array):void
         {
         };
         var p:Point = ToISO(new Point(260,260),0);
         GetPath(ToISO(new Point(-2000,-2000),0),new Rectangle(p.x,p.y,10,10),Done);
      }
   }
}


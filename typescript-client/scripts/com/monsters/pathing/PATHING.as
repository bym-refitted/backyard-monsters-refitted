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

      public static function Setup():void
      {
         var _loc2_:PATHINGobject = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = getTimer();
         _loc4_ = 0;
         while (_loc4_ < _gridWidth)
         {
            _loc5_ = 0;
            while (_loc5_ < _gridHeight)
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

      public static function Cost(param1:Point, param2:Rectangle, param3:int):Rectangle
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
         _loc9_ = new Rectangle(_loc5_.x, _loc5_.y, param2.width * 0.1, param2.height * 0.1);
         _loc7_ = _loc9_.x;
         while (_loc7_ < _loc9_.x + _loc9_.width)
         {
            _loc8_ = _loc9_.y;
            while (_loc8_ < _loc9_.y + _loc9_.height)
            {
               _loc6_ = _loc7_ * 1000 + _loc8_;
               if (_costs[_loc6_])
               {
                  _loc10_ = int(_costs[_loc6_].cost);
                  _costs[_loc6_].cost += param3;
                  if (_costs[_loc6_].cost < 2)
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

      public static function RegisterBuilding(param1:Rectangle, param2:BFOUNDATION, param3:Boolean):void
      {
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = GlobalLocal(FromISO(new Point(param1.x, param1.y)));
         param1.width *= 0.1;
         param1.height *= 0.1;
         _loc6_ = _loc4_.x;
         while (_loc6_ < _loc4_.x + param1.width)
         {
            _loc7_ = _loc4_.y;
            while (_loc7_ < _loc4_.y + param1.height)
            {
               _loc5_ = _loc6_ * 1000 + _loc7_;
               if (_costs[_loc5_])
               {
                  if (param3)
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

      public static function Tick():void
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
         if (_resetRequested)
         {
            _resetRequested = false;
            _loc5_ = new Point(0, 0);
            Clear();
            _loc6_ = 0;
            while (_loc6_ < _gridWidth)
            {
               _loc7_ = 0;
               while (_loc7_ < _gridHeight)
               {
                  _costs[_loc6_ * 1000 + _loc7_].cost = 10;
                  _loc7_ += 1;
               }
               _loc6_ += 1;
            }
            _loc2_ = getTimer() - _loc1_;
            _loc10_ = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each (_loc8_ in _loc10_)
            {
               if (Boolean(_loc8_._gridCost) && (_loc8_.health > 0 || _loc8_ is BMUSHROOM))
               {
                  for each (_loc9_ in _loc8_._gridCost)
                  {
                     _loc5_.x = _loc8_.x;
                     _loc5_.y = _loc8_.y;
                     PATHING.Cost(_loc5_, _loc9_[0], _loc9_[1]);
                  }
               }
            }
            _loc3_ = getTimer() - _loc1_;
            _loc4_ = getTimer() - _loc1_;
         }
         ProcessFlood();
      }

      public static function GetPath(param1:Point, param2:Rectangle, param3:Function = null, param4:Boolean = false, param5:BFOUNDATION = null):Array
      {
         var _loc6_:Point = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         _loc9_ = param1;
         _loc10_ = new Point(param2.x, param2.y);
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         param2.x = int(param2.x);
         param2.y = int(param2.y);
         _loc6_ = FromISO(param1);
         _loc8_ = FromISO(new Point(param2.x, param2.y));
         _loc7_ = param2;
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
         _loc6_ = GlobalLocal(_loc6_);
         _loc8_ = GlobalLocal(new Point(_loc7_.x, _loc7_.y));
         _loc7_.x = int(_loc8_.x);
         _loc7_.y = int(_loc8_.y);
         _loc7_.width *= 0.1;
         _loc7_.height *= 0.1;
         GetPathB(_loc6_, _loc7_, _loc9_, _loc10_, param3, param4, param5);
         return [];
      }

      public static function GetPathB(param1:Point, param2:Rectangle, param3:Point, param4:Point, param5:Function = null, param6:Boolean = false, param7:BFOUNDATION = null):void
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
         if (!_costs[_loc9_] && !_costs[_loc8_])
         {
            param5([param3, param4], param7);
            RenderPath([param3, param4]);
            return;
         }
         if (!_costs[_loc9_])
         {
            _loc10_ = 90 - Math.atan2(param2.y - param1.y, param2.x - param1.x) * 57.2957795;
            _loc11_ = Math.sin(_loc10_ * 0.0174532925) * 5;
            _loc12_ = Math.cos(_loc10_ * 0.0174532925) * 5;
            _loc13_ = 0;
            while (!_costs[_loc9_] && _loc13_ < 2000)
            {
               _loc13_ += 1;
               param1.x += _loc11_;
               param1.y += _loc12_;
               _loc9_ = int(param1.x) * 1000 + int(param1.y);
            }
            param1.x = int(param1.x);
            param1.y = int(param1.y);
         }
         if (!_costs[_loc8_])
         {
            param5([param3, param4], param7);
            RenderPath([param3, param4]);
            return;
         }
         if (param6)
         {
            _loc8_ += 1000000;
         }
         if (!_floods[_loc8_])
         {
            _loc14_ = {};
            _loc15_ = {};
            _loc16_ = {};
            _loc17_ = 0;
            while (_loc17_ < param2.width)
            {
               _loc23_ = 0;
               while (_loc23_ < param2.height)
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
         if (!_floods[_loc8_].startpoints[_loc9_])
         {
            _floods[_loc8_].startpoints[_loc9_] = {
                  "startID": _loc9_,
                  "callbackfunctions": [],
                  "startPoint": param1
               };
         }
         _floods[_loc8_].startpoints[_loc9_].callbackfunctions.push([param5, param6, param7, param4]);
         _floods[_loc8_].pending += 1;
      }

      /**
       * Processes the flood fill pathfinding for all pending flood objects.
       *
       * Purpose:
       * _______________________________________________________________
       *
       * - The `ProcessFlood` function iterates through all flood fill objects in `_floods`.
       * - It performs pathfinding calculations on those marked as "pending," expanding the flood area step by step.
       * - The function adjusts processing time based on the number of pending floods to maintain a balance in performance.
       *
       * Steps:
       * _______________________________________________________________
       *
       * 1. Determine the number of pending flood objects and calculate the time slice (`timeSliceLimit`) allocated for processing each one.
       *    - Ensures a minimum processing time to prevent resource starvation.
       *
       * 2. Iterate over each flood fill object (`currentFloodObject`) marked as pending.
       *
       * 3. For each pending flood object:
       *    - Initialize processing variables such as `expandedPointsCount`, `pointsAddedCount`, and `newEdge`.
       *    - Begin expanding the flood fill area by iterating over the current "edge" of the flood (`currentFloodObject.edge`).
       *    - Evaluate neighboring points (`neighborX`, `neighborY`) for potential expansion.
       *    - If a neighboring point (`neighborKey`) is not already part of the flood (`currentFloodObject.flood`):
       *        - Calculate its movement cost (`movementCost`), considering factors like diagonal movement and wall ignoring.
       *        - Create a new flood point (`newFloodPoint`) and update its depth based on the current point's depth and movement cost.
       *        - Add the new flood point to the flood (`currentFloodObject.flood`) and include it in the edge for further expansion.
       *        - Track the total number of points added (`pointsAddedCount`) and update `minDepth` if necessary.
       *    - Update the flood's edge (`newEdge`) and adjust the minimum depth (`minDepth`).
       *
       * 4. Set the updated edge back to `currentFloodObject.edge` and check if the start point has been reached using `CheckStartReached`.
       */

      private static function ProcessFlood(param1:Event = null):void
      {
         var currentEdgePoint:PATHINGobject = null;
         var currentX:int = 0;
         var currentY:int = 0;
         var newFloodPoint:PATHINGobject = null;
         var neighborX:int = 0;
         var neighborY:int = 0;
         var neighborKey:int = 0;
         var expandedPointsCount:int = 0;
         var newEdge:Object = null;
         var minDepth:int = 0;
         var pointsAddedCount:int = 0;
         var timeSliceLimit:int = 0;
         var pendingFloodCount:int = 0;
         var movementCost:int = 0;
         var currentFloodObject:PATHINGfloodobject = null;
         var startTimer:int = getTimer();
         var timeSliceStart:int = getTimer();

         // Count the number of pending flood objects
         for each (currentFloodObject in _floods)
         {
            if (currentFloodObject.pending)
            {
               pendingFloodCount += 1;
            }
         }

         // Determine the time slice limit based on the number of pending flood fills
         timeSliceLimit = 25 / pendingFloodCount;
         if (timeSliceLimit < 5)
         {
            timeSliceLimit = 5;
         }

         // Process each flood object
         for each (currentFloodObject in _floods)
         {
            if (currentFloodObject.pending)
            {
               timeSliceStart = getTimer();
               expandedPointsCount = 0;
               pointsAddedCount = 0;

               // Continue processing within the allowed time slice
               while (getTimer() - timeSliceStart < timeSliceLimit && currentFloodObject.pending > 0)
               {
                  newEdge = {};
                  minDepth = 9999999;
                  currentFloodObject.edgeLength = 0;

                  // Expand the current edge of the flood fill
                  for each (currentEdgePoint in currentFloodObject.edge)
                  {
                     if (currentEdgePoint.depth <= currentFloodObject.minDepth)
                     {
                        currentX = currentEdgePoint.pointX;
                        currentY = currentEdgePoint.pointY;
                        neighborY = currentX - 1;

                        // Check all neighboring points
                        while (neighborY < currentX + 2)
                        {
                           neighborKey = currentY - 1;
                           while (neighborKey < currentY + 2)
                           {
                              // Skip the current point itself
                              if (!(neighborY == currentX && neighborKey == currentY))
                              {
                                 neighborX = neighborY * 1000 + neighborKey;

                                 // Check if the neighbor is already part of the flood
                                 if (!currentFloodObject.flood[neighborX])
                                 {

                                    // If the neighbor hasn't been added yet, evaluate it
                                    if (!newEdge[neighborX])
                                    {
                                       if (_costs[neighborX])
                                       {
                                          expandedPointsCount += 1;
                                          newFloodPoint = new PATHINGobject();
                                          newFloodPoint.pointX = neighborY;
                                          newFloodPoint.pointY = neighborKey;

                                          // Calculate movement cost
                                          movementCost = int(_costs[neighborX].cost);
                                          if (currentFloodObject.ignoreWalls)
                                          {
                                             if (_costs[neighborX].building)
                                             {
                                                movementCost = 20;
                                             }
                                          }

                                          // Increase cost for diagonal movement
                                          if (neighborY != currentEdgePoint.pointX && neighborKey != currentEdgePoint.pointY)
                                          {
                                             movementCost *= 1.5;
                                          }

                                          // Set the depth for the new flood point
                                          newFloodPoint.depth = currentEdgePoint.depth + movementCost;
                                          if (newFloodPoint.depth < minDepth)
                                          {
                                             minDepth = newFloodPoint.depth;
                                          }

                                          // Add the new point to the flood and edge
                                          newEdge[neighborX] = newFloodPoint;
                                          currentFloodObject.flood[neighborX] = newFloodPoint;
                                          currentFloodObject.edgeLength += 1;
                                          pointsAddedCount += 1;
                                       }
                                    }
                                 }
                              }
                              neighborKey += 1;
                           }
                           neighborY += 1;
                        }
                     }
                     else
                     {
                        newEdge[currentEdgePoint.pointID] = currentEdgePoint;
                        currentFloodObject.edgeLength += 1;
                        if (currentEdgePoint.depth < minDepth)
                        {
                           minDepth = currentEdgePoint.depth;
                        }
                     }
                  }
                  // Update the current edge and minimum depth
                  currentFloodObject.edge = newEdge;
                  currentFloodObject.minDepth = minDepth;

                  // Check if the flood fill has reached the start point
                  CheckStartReached(currentFloodObject);
               }
            }
         }
      }

      private static function CheckStartReached(param1:PATHINGfloodobject):int
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc2_:int = 0;
         for each (_loc3_ in param1.startpoints)
         {
            if (Boolean(_loc3_) && Boolean(param1.flood[_loc3_.startID]))
            {
               for each (_loc4_ in _loc3_.callbackfunctions)
               {
                  Path(param1.flood, _loc3_.startID, _loc4_[0], _loc4_[1], _loc4_[2], _loc4_[3]);
                  --param1.pending;
                  _loc2_ += 1;
               }
               _loc3_.callbackfunctions = [];
               delete param1.startpoints[_loc3_.startID];
            }
         }
         return _loc2_;
      }

      public static function Path(param1:Object, param2:int, param3:Function, param4:Boolean = false, param5:BFOUNDATION = null, param6:Point = null):void
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
         if (param1[param2])
         {
            _loc8_ = int(param1[param2].pointX);
            _loc9_ = int(param1[param2].pointY);
            _loc14_ = int(param1[param2].depth);
            _loc10_[_loc11_] = ToISO(LocalGlobal(new Point(_loc8_, _loc9_)), 0);
            _loc11_ += 1;
            _loc19_ = true;
         }
         _loc13_ = new Point(0, 0);
         while (_loc19_)
         {
            _loc19_ = false;
            _loc20_ = -1;
            while (_loc20_ < 2)
            {
               _loc21_ = -1;
               while (_loc21_ < 2)
               {
                  if (!(_loc20_ == 0 && _loc21_ == 0))
                  {
                     _loc13_.x = _loc8_ + _loc20_;
                     _loc13_.y = _loc9_ + _loc21_;
                     _loc12_ = _loc13_.x * 1000 + _loc13_.y;
                     if (param1[_loc12_] && param1[_loc12_].depth < _loc14_ && param1[_loc12_].depth > 0)
                     {
                        _loc15_ = _loc13_.x;
                        _loc16_ = _loc13_.y;
                        _loc17_ = true;
                        _loc14_ = int(param1[_loc12_].depth);
                        _loc19_ = true;
                        if (!param4 && _loc11_ > 1)
                        {
                           if (_costs[_loc12_])
                           {
                              _loc18_ = _costs[_loc12_].building;
                              if (_loc18_)
                              {
                                 if (_loc18_.health > 0)
                                 {
                                    _loc22_ = (_loc18_._lvl.Get() ^ 2) + 1;
                                    _loc23_ = 0;
                                    while (_loc23_ < _loc22_)
                                    {
                                       _loc10_.push(_loc10_[_loc10_.length - 1]);
                                       _loc23_++;
                                    }
                                    param3(_loc10_, _loc18_);
                                    RenderPath(_loc10_);
                                    return;
                                 }
                              }
                           }
                        }
                        if (!param4 && _loc14_ < 20)
                        {
                           if (Math.random() < 0.6)
                           {
                              _loc24_ = new Array();
                              _loc23_ = -3;
                              while (_loc23_ < 4)
                              {
                                 _loc25_ = -3;
                                 while (_loc25_ < 4)
                                 {
                                    if (Boolean(_loc23_) && Boolean(_loc25_))
                                    {
                                       _loc26_ = (_loc15_ + _loc23_) * 1000 + _loc16_ + _loc25_;
                                       if (param1[_loc26_])
                                       {
                                          if (param1[_loc26_].depth < 20 && param1[_loc26_].depth > 0)
                                          {
                                             _loc27_ = new Point(_loc15_ + _loc23_, _loc16_ + _loc25_);
                                             _loc24_.push(_loc27_);
                                          }
                                       }
                                    }
                                    _loc25_++;
                                 }
                                 _loc23_++;
                              }
                              if (_loc24_.length > 0)
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
            if (_loc17_)
            {
               _loc8_ = _loc15_;
               _loc9_ = _loc16_;
               _loc10_[_loc11_] = ToISO(LocalGlobal(Jiggle(_loc15_, _loc16_)), 0);
               _loc11_ += 1;
            }
         }
         if (param6)
         {
            _loc13_ = GlobalLocal(FromISO(param6));
            if (!param5 || !_costs[_loc13_.x * 1000 + _loc13_.y])
            {
               _loc10_[_loc11_] = param6;
            }
         }
         RenderFlood();
         RenderPath(_loc10_);
         param3(_loc10_, param5);
      }

      private static function Jiggle(param1:int, param2:int):Point
      {
         return new Point(param1 + (Math.random() - 0.5) * 0.4, param2 + (Math.random() - 0.5) * 0.4);
      }

      public static function GetBuildingFromISO(param1:Point):BFOUNDATION
      {
         var _loc2_:Point = FromISO(param1);
         var _loc3_:Point = GlobalLocal(_loc2_);
         var _loc4_:int = 1000 * int(_loc3_.x) + int(_loc3_.y);
         if (_costs[_loc4_])
         {
            return _costs[_loc4_].building;
         }
         return null;
      }

      /*
      * Clears all existing flood fill pathfinding data and invokes any collected callback functions.
      * 
      * Purpose:
      * _______________________________________________________________
      *
      * - The `Clear` function is responsible for resetting the flood fill objects stored in the `_floods` collection.
      * - It collects any callback functions that were registered for flood fill pathfinding tasks.
      * - These callback functions are then invoked with an empty path and `null` as the building parameter, indicating a reset or cancellation.
      * 
      * Steps:
      * _______________________________________________________________
      * 
      * 1. Iterates through each flood fill object in the `_floods` collection.
      *
      * 2. For each flood fill object, it goes through its `startpoints` to gather any associated callback functions.
      *
      * 3. Collects all the callback functions into an array (`collectedCallbacks`).
      *
      * 4. Clears the `_floods` collection to remove all existing flood fill data.
      *
      * 5. Invokes each collected callback function with an empty path (`[]`), `null` for the building parameter, 
      *    and a `true` flag to indicate the process has been cleared or cancelled.
      * 
      * Note:
      * - This function is typically called when a reset or cleanup of flood fill pathfinding data is needed
      */
      public static function Clear():void
      {
         var floodObject:PATHINGfloodobject = null;
         var callbackIndex:int = 0;
         var startPoint:Object = null;
         var callbackFunctions:Array = null;
         var functionIndex:int = 0;
         var collectedCallbacks:Array = [];
         var startTime:int = getTimer();

         // Iterate over each flood fill object in the _floods object
         for each (floodObject in _floods)
         {

            // Iterate over the start points in the flood fill object
            for each (startPoint in floodObject.startpoints)
            {
               // Check if there are callback functions associated with the start point
               if (startPoint.callbackfunctions)
               {
                  callbackFunctions = startPoint.callbackfunctions;
                  functionIndex = 0;
                  // Add each callback function to the collectedCallbacks array
                  while (functionIndex < callbackFunctions.length)
                  {
                     collectedCallbacks.push(callbackFunctions[functionIndex][0]);
                     functionIndex++;
                  }
               }
            }
         }
         _floods = {};

         // Invoke each callback function with an empty path and null as the building parameter
         callbackIndex = 0;
         while (callbackIndex < collectedCallbacks.length)
         {
            collectedCallbacks[callbackIndex]([], null, true);
            callbackIndex++;
         }
      }

      public static function Cleanup():void
      {
         var _loc1_:* = undefined;
         for each (_loc1_ in _costs)
         {
            delete _costs[_loc1_];
         }
         _costs = {};
         _floods = {};
      }

      public static function LineOfSight(param1:int, param2:int, param3:int, param4:int, param5:BFOUNDATION = null, param6:Boolean = false):Boolean
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BFOUNDATION = null;
         var _loc16_:int = 0;
         var _loc18_:int = 0;
         var _loc10_:Point = GlobalLocal(FromISO(new Point(param1, param2)));
         var _loc11_:Point = GlobalLocal(FromISO(new Point(param3, param4)));
         param1 = _loc10_.x;
         param2 = _loc10_.y;
         param3 = _loc11_.x;
         param4 = _loc11_.y;
         var _loc12_:Number = param3 - param1;
         var _loc13_:Number = param4 - param2;
         var _loc14_:Number = Math.atan2(_loc13_, _loc12_) * c180PI;
         var _loc15_:Number = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_);
         _loc7_ = 0;
         while (_loc7_ < _loc15_)
         {
            _loc16_ = param1 + Math.cos(_loc14_ * cPI180) * _loc7_;
            _loc18_ = param2 + Math.sin(_loc14_ * cPI180) * _loc7_;
            _loc8_ = _loc16_ * 1000 + _loc18_;
            if (!_costs[_loc8_])
            {
               return true;
            }
            _loc9_ = _costs[_loc8_].building;
            if (Boolean(_loc9_) && _loc9_.health > 0)
            {
               if (!(Boolean(param5) && _loc9_ == param5))
               {
                  if (_loc9_._type == 17 || param6)
                  {
                     return false;
                  }
               }
            }
            _loc7_++;
         }
         return true;
      }

      public static function ResetCosts():void
      {
         _resetRequested = true;
      }

      public static function Wander(param1:Point, param2:int = 50, param3:Function = null):void
      {
         var _loc7_:Point = null;
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         var _loc4_:Array = [];
         var _loc5_:int = 0 - param2;
         while (_loc5_ < param2)
         {
            if (!GRID.Blocked(param1.add(new Point(_loc5_, 0 - param2))))
            {
               _loc4_.push(param1.add(new Point(_loc5_, 0 - param2)));
            }
            if (!GRID.Blocked(param1.add(new Point(_loc5_, param2))))
            {
               _loc4_.push(param1.add(new Point(_loc5_, param2)));
            }
            if (!GRID.Blocked(param1.add(new Point(0 - param2, _loc5_))))
            {
               _loc4_.push(param1.add(new Point(0 - param2, _loc5_)));
            }
            if (!GRID.Blocked(param1.add(new Point(param2, _loc5_))))
            {
               _loc4_.push(param1.add(new Point(param2, _loc5_)));
            }
            _loc5_ += 10;
         }
         var _loc6_:Point = param1;
         if (_loc4_.length > 0)
         {
            _loc7_ = _loc4_[int(Math.random() * _loc4_.length)];
            GetPath(param1, new Rectangle(_loc7_.x, _loc7_.y, 10, 10), param3);
         }
      }

      public static function RenderFlood():void
      {
         if (GLOBAL._catchup)
         {
         }
      }

      public static function RenderCosts():void
      {
      }

      public static function RenderPath(param1:Array, param2:Boolean = false):void
      {
      }

      public static function getNumberAsHexString(param1:uint, param2:uint = 1, param3:Boolean = true):String
      {
         var _loc4_:String = param1.toString(16).toUpperCase();
         while (param2 > _loc4_.length)
         {
            _loc4_ = "0" + _loc4_;
         }
         if (param3)
         {
            _loc4_ = "0x" + _loc4_;
         }
         return _loc4_;
      }

      private static function GlobalLocal(param1:Point):Point
      {
         param1.x *= 0.1;
         param1.y *= 0.1;
         param1.x += _gridWidth >> 1;
         param1.y += _gridHeight >> 1;
         param1.x = int(param1.x);
         param1.y = int(param1.y);
         return param1;
      }

      public static function LocalGlobal(param1:Point):Point
      {
         param1.x -= _gridWidth >> 1;
         param1.y -= _gridHeight >> 1;
         param1.x *= 10;
         param1.y *= 10;
         return param1;
      }

      public static function ToISO(param1:Point, param2:int):Point
      {
         var _loc3_:int = (param1.x + param1.y) * 0.5 - param2;
         var _loc5_:int = param1.x - param1.y;
         return new Point(_loc5_, _loc3_);
      }

      public static function FromISO(param1:Point):Point
      {
         var _loc2_:int = param1.y - param1.x * 0.5;
         var _loc3_:int = param1.x * 0.5 + param1.y;
         return new Point(_loc3_, _loc2_);
      }

      public static function PlotRandom(param1:MouseEvent):void
      {
         var Done:Function = null;
         var e:MouseEvent = param1;
         Done = function(param1:Array):void
         {
         };
         var p:Point = ToISO(new Point(260, 260), 0);
         GetPath(ToISO(new Point(-2000, -2000), 0), new Rectangle(p.x, p.y, 10, 10), Done);
      }
   }
}

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
         for (var widthIdx:int = 0; widthIdx < _gridWidth; widthIdx++)
         {
            for (var heightIdx:int = 0; heightIdx < _gridHeight; heightIdx++)
            {
               var gridKey:int = widthIdx * 1000 + heightIdx;
               var gridSpace:PATHINGobject = new PATHINGobject();
               gridSpace.pointX = widthIdx;
               gridSpace.pointY = heightIdx;
               gridSpace.cost = 10;
               _costs[gridKey] = gridSpace;
            }
         }
         _poolPathing = new Vector.<PATHINGobject>();
         _poolPathingB = new Vector.<PATHINGobject>();
         _poolPathingLength = 0;
      }

      public static function Cost(buildingPoint:Point, buildingRegion:Rectangle, regionCost:int):Rectangle
      {
         var convertPoint:Point = FromISO(buildingPoint);
         convertPoint.x += buildingRegion.x;
         convertPoint.y += buildingRegion.y;
         var gridPoint:Point = GlobalLocal(convertPoint);
         var gridRegion:Rectangle = new Rectangle(gridPoint.x, gridPoint.y, buildingRegion.width * 0.1, buildingRegion.height * 0.1);
         for (var xIdx:int = gridRegion.x; xIdx < gridRegion.x + gridRegion.width; xIdx++)
         {
            for (var yIdx:int = gridRegion.y; yIdx < gridRegion.y + gridRegion.height; yIdx++)
            {
               var gridKey:int = xIdx * 1000 + yIdx;
               if (_costs[gridKey])
               {
                  _costs[gridKey].cost += regionCost;
                  if (_costs[gridKey].cost < 2)
                  {
                     _costs[gridKey].cost = 2;
                  }
               }
            }
         }
         return gridRegion;
      }

      public static function RegisterBuilding(region:Rectangle, building:BFOUNDATION, register:Boolean):void
      {
         var gridEndPoint:Point = GlobalLocal(FromISO(new Point(region.x, region.y)));
         region.width *= 0.1;
         region.height *= 0.1;
         for (var xIdx:int = gridEndPoint.x; xIdx < gridEndPoint.x + region.width; xIdx++)
         {
            for (var yIdx:int = gridEndPoint.y; yIdx < gridEndPoint.y + region.height; yIdx++)
            {
               var gridKey:int = xIdx * 1000 + yIdx;
               if (_costs[gridKey])
               {
                  if (register)
                  {
                     _costs[gridKey].building = building;
                  }
                  else
                  {
                     delete _costs[gridKey].building;
                  }
               }
            }
         }
      }

      public static function Tick():void
      {
         if (_resetRequested)
         {
            _resetRequested = false;
            Clear();
            for (var widthIdx:int = 0; widthIdx < _gridWidth; widthIdx++)
            {
               for (var heightIdx:int = 0; heightIdx < _gridHeight; heightIdx++)
               {
                  _costs[widthIdx * 1000 + heightIdx].cost = 10;
               }
            }
            var allBuildings:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
            var buildingPoint:Point = new Point(0, 0);
            for each (var building:BFOUNDATION in allBuildings)
            {
               if (Boolean(building._gridCost) && (building.health > 0 || building is BMUSHROOM))
               {
                  for each (var regionCostArray:Array in building._gridCost)
                  {
                     buildingPoint.x = building.x;
                     buildingPoint.y = building.y;
                     PATHING.Cost(buildingPoint, regionCostArray[0], regionCostArray[1]);
                  }
               }
            }
         }
         ProcessFlood();
      }

      public static function GetPath(startPoint:Point, targetRect:Rectangle, callback:Function = null, ignoreWalls:Boolean = false, targetBuilding:BFOUNDATION = null):Array
      {
         var originalStart:Point = startPoint;
         var originalTarget:Point = new Point(targetRect.x, targetRect.y);
         startPoint.x = int(startPoint.x);
         startPoint.y = int(startPoint.y);
         var gridStart:Point = GlobalLocal(FromISO(startPoint));
         targetRect.x = int(targetRect.x);
         targetRect.y = int(targetRect.y);
         var gridTargetPoint:Point = GlobalLocal(FromISO(new Point(targetRect.x, targetRect.y)));
         var gridTargetRect:Rectangle = targetRect;
         gridTargetRect.x = gridTargetPoint.x;
         gridTargetRect.y = gridTargetPoint.y;
         gridTargetRect.width *= 0.1;
         gridTargetRect.height *= 0.1;
         GetPathB(gridStart, gridTargetRect, originalStart, originalTarget, callback, ignoreWalls, targetBuilding);
         return [];
      }

      public static function GetPathB(gridStart:Point, gridTargetRect:Rectangle, originalStart:Point, originalTarget:Point, callback:Function = null, ignoreWalls:Boolean = false, targetBuilding:BFOUNDATION = null):void
      {
         RenderCosts();
         var gridKeyStart:int = gridStart.x * 1000 + gridStart.y;
         var gridKeyTarget:int = gridTargetRect.x * 1000 + gridTargetRect.y;
         if (!_costs[gridKeyStart] && !_costs[gridKeyTarget])
         {
            callback([originalStart, originalTarget], targetBuilding);
            RenderPath([originalStart, originalTarget]);
            return;
         }
         if (!_costs[gridKeyStart])
         {
            // Starting point is out of bounds, nudge it towards the target to move it in bounds.
            var angle:Number = 90 - Math.atan2(gridTargetRect.y - gridStart.y, gridTargetRect.x - gridStart.x) * 57.2957795;
            var moveX:Number = Math.sin(angle * 0.0174532925) * 5;
            var moveY:Number = Math.cos(angle * 0.0174532925) * 5;
            var attempts:int = 0;
            while (!_costs[gridKeyStart] && attempts < 2000)
            {
               attempts += 1;
               gridStart.x += moveX;
               gridStart.y += moveY;
               gridKeyStart = int(gridStart.x) * 1000 + int(gridStart.y);
            }
            gridStart.x = int(gridStart.x);
            gridStart.y = int(gridStart.y);
         }
         if (!_costs[gridKeyTarget])
         {
            callback([originalStart, originalTarget], targetBuilding);
            RenderPath([originalStart, originalTarget]);
            return;
         }
         if (ignoreWalls)
         {
            // Separate floods that calculate walls differently
            gridKeyTarget += 1000000;
         }
         // Does no other monster have this target position?
         if (!_floods[gridKeyTarget])
         {
            var edgeArr:Object = {};
            var floodFillArr:Object = {};
            for (var widthIdx:int = 0; widthIdx < gridTargetRect.width; widthIdx++)
            {
               for (var heightIdx:int = 0; heightIdx < gridTargetRect.height; heightIdx++)
               {
                  var initEdgeSpace:PATHINGobject = new PATHINGobject();
                  initEdgeSpace.pointX = gridTargetRect.x + widthIdx;
                  initEdgeSpace.pointY = gridTargetRect.y + heightIdx;
                  initEdgeSpace.depth = 0;
                  edgeArr[gridTargetRect.x + widthIdx * 1000 + gridTargetRect.y + heightIdx] = initEdgeSpace;
                  var initFillSpace:PATHINGobject = new PATHINGobject();
                  initFillSpace.pointX = gridTargetRect.x + widthIdx;
                  initFillSpace.pointY = gridTargetRect.y + heightIdx;
                  initFillSpace.depth = 0;
                  floodFillArr[gridTargetRect.x + widthIdx * 1000 + gridTargetRect.y + heightIdx] = initFillSpace;
               }
            }
            var newFlood:PATHINGfloodobject = new PATHINGfloodobject();
            newFlood.flood = floodFillArr;
            newFlood.edge = edgeArr;
            newFlood.ignoreWalls = ignoreWalls;
            _floods[gridKeyTarget] = newFlood;
         }
         // Does no other monster have this starting position?
         if (!_floods[gridKeyTarget].startpoints[gridKeyStart])
         {
            _floods[gridKeyTarget].startpoints[gridKeyStart] = {
                  "startID": gridKeyStart,
                  "callbackfunctions": [],
                  "startPoint": gridStart
               };
         }
         // Prevent duplicate callback registration
         var callbacks:Array = _floods[gridKeyTarget].startpoints[gridKeyStart].callbackfunctions;
         var alreadyAdded:Boolean = false;
         for (var idx:int = 0; idx < callbacks.length; idx++)
         {
            if (callbacks[idx][0] === callback)
            {
               alreadyAdded = true;
               break;
            }
         }
         if (!alreadyAdded)
         {
            callbacks.push([callback, ignoreWalls, targetBuilding, originalTarget]);
            _floods[gridKeyTarget].pending += 1;
         }
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
         var timeSliceLimit:int = 0;
         var pendingFloodCount:int = 0;
         var currentFloodObject:PATHINGfloodobject = null;

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
         if (timeSliceLimit < 15)
         {
            timeSliceLimit = 15;
         }

         // Process each flood object
         for each (currentFloodObject in _floods)
         {
            if (!currentFloodObject.pending) continue;

            // Continue processing within the allowed time slice
            var timeSliceStart:int = getTimer();
            while (getTimer() - timeSliceStart < timeSliceLimit && currentFloodObject.pending > 0)
            {
               var newEdge:Object = {};
               var minDepth:int = 9999999;

               // Expand the current edge of the flood fill
               for each (var currentEdgePoint:PATHINGobject in currentFloodObject.edge)
               {
                  if (currentEdgePoint.depth <= currentFloodObject.minDepth)
                  {
                     var currentX:int = currentEdgePoint.pointX;
                     var currentY:int = currentEdgePoint.pointY;

                     // Check all neighboring points
                     for (var neighborX:int = currentX - 1; neighborX < currentX + 2; neighborX++)
                     {
                        for (var neighborY:int = currentY - 1; neighborY < currentY + 2; neighborY++)
                        {
                           // Skip the current point itself
                           if (neighborX == currentX && neighborY == currentY) continue;

                           var neighborKey:int = neighborX * 1000 + neighborY;

                           // Check if the neighbor is already part of the flood
                           if (!currentFloodObject.flood[neighborKey] && _costs[neighborKey])
                           {
                              var newFloodPoint:PATHINGobject = new PATHINGobject();
                              newFloodPoint.pointX = neighborX;
                              newFloodPoint.pointY = neighborY;

                              // Calculate movement cost
                              var movementCost:int = _costs[neighborKey].cost;
                              if (currentFloodObject.ignoreWalls && _costs[neighborKey].building)
                              {
                                 movementCost = 20;
                              }

                              // Increase cost for diagonal movement
                              if (neighborX != currentEdgePoint.pointX && neighborY != currentEdgePoint.pointY)
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
                              newEdge[neighborKey] = newFloodPoint;
                              currentFloodObject.flood[neighborKey] = newFloodPoint;
                           }
                        }
                     }
                  }
                  else
                  {
                     newEdge[currentEdgePoint.pointID] = currentEdgePoint;
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

      private static function CheckStartReached(floodFill:PATHINGfloodobject):int
      {
         var pathingStart:Object = null;
         var callback:Array = null;
         var found:int = 0;
         for each (pathingStart in floodFill.startpoints)
         {
            if (Boolean(pathingStart) && Boolean(floodFill.flood[pathingStart.startID]))
            {
               for each (callback in pathingStart.callbackfunctions)
               {
                  Path(floodFill.flood, pathingStart.startID, callback[0], callback[1], callback[2], callback[3]);
                  --floodFill.pending;
                  found += 1;
               }
               pathingStart.callbackfunctions = [];
               delete floodFill.startpoints[pathingStart.startID];
            }
         }
         return found;
      }

      public static function Path(floodFill:Object, startId:int, callback:Function, ignoreWalls:Boolean = false, targetBuilding:BFOUNDATION = null, originalTarget:Point = null):void
      {
         var startX:int = 0;
         var startY:int = 0;
         var gridPoint:Point = new Point(0, 0);
         var currentDepth:int = 0;
         var currentX:int = 0;
         var currentY:int = 0;
         var foundLowerDepth:Boolean = false;
         var buildPath:Boolean = false;
         var path:Array = [];
         if (floodFill[startId])
         {
            startX = floodFill[startId].pointX;
            startY = floodFill[startId].pointY;
            currentDepth = floodFill[startId].depth;
            path.push(ToISO(LocalGlobal(new Point(startX, startY)), 0));
            buildPath = true;
         }
         while (buildPath)
         {
            buildPath = false;
            for (var offsetX:int = -1; offsetX < 2; offsetX++)
            {
               for (var offsetY:int = -1; offsetY < 2; offsetY++)
               {
                  if (offsetX == 0 && offsetY == 0) continue;

                  gridPoint.x = startX + offsetX;
                  gridPoint.y = startY + offsetY;
                  var gridKey:int = gridPoint.x * 1000 + gridPoint.y;
                  if (floodFill[gridKey] && floodFill[gridKey].depth < currentDepth && floodFill[gridKey].depth > 0)
                  {
                     currentX = gridPoint.x;
                     currentY = gridPoint.y;
                     foundLowerDepth = true;
                     currentDepth = floodFill[gridKey].depth;
                     buildPath = true;
                     if (!ignoreWalls && path.length > 1 && _costs[gridKey])
                     {
                        var wall:BFOUNDATION = _costs[gridKey].building;
                        if (wall && wall.health > 0)
                        {
                           callback(path, wall);
                           RenderPath(path);
                           return;
                        }
                     }
                     if (!ignoreWalls && currentDepth < 20)
                     {
                        if (Math.random() < 0.6)
                        {
                           var nearbyGridSpaces:Array = new Array();
                           for (var nearbyOffsetX:int = -3; nearbyOffsetX < 4; nearbyOffsetX++)
                           {
                              for (var nearbyOffsetY:int = -3; nearbyOffsetY < 4; nearbyOffsetY++)
                              {
                                 // Monsters scatter towards diagonal positions
                                 if (nearbyOffsetX == 0 || nearbyOffsetY == 0) continue;

                                 var nearbyGridKey:int = (currentX + nearbyOffsetX) * 1000 + currentY + nearbyOffsetY;
                                 if (floodFill[nearbyGridKey] && floodFill[nearbyGridKey].depth < 20 && floodFill[nearbyGridKey].depth > 0)
                                 {
                                    nearbyGridSpaces.push(new Point(currentX + nearbyOffsetX, currentY + nearbyOffsetY));
                                 }
                              }
                           }
                           if (nearbyGridSpaces.length > 0)
                           {
                              var randIdx:int = int(Math.random() * nearbyGridSpaces.length);
                              currentX = int(nearbyGridSpaces[randIdx].x);
                              currentY = int(nearbyGridSpaces[randIdx].y);
                           }
                        }
                     }
                  }
               }
            }
            if (foundLowerDepth)
            {
               startX = currentX;
               startY = currentY;
               path.push(ToISO(LocalGlobal(Jiggle(currentX, currentY)), 0));
            }
         }
         if (originalTarget)
         {
            gridPoint = GlobalLocal(FromISO(originalTarget));
            if (!targetBuilding || !_costs[gridPoint.x * 1000 + gridPoint.y])
            {
               path.push(originalTarget);
            }
         }
         RenderFlood();
         RenderPath(path);
         callback(path, targetBuilding);
      }

      private static function Jiggle(x:int, y:int):Point
      {
         return new Point(x + (Math.random() - 0.5) * 0.4, y + (Math.random() - 0.5) * 0.4);
      }

      public static function GetBuildingFromISO(isoPoint:Point):BFOUNDATION
      {
         var gridPoint:Point = GlobalLocal(FromISO(isoPoint));
         var gridKey:int = 1000 * gridPoint.x + gridPoint.y;
         if (_costs[gridKey])
         {
            return _costs[gridKey].building;
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
         var startPoint:Object = null;
         var collectedCallbacks:Array = [];

         // Iterate over each flood fill object in the _floods object
         for each (floodObject in _floods)
         {

            // Iterate over the start points in the flood fill object
            for each (startPoint in floodObject.startpoints)
            {
               // Check if there are callback functions associated with the start point
               if (startPoint.callbackfunctions)
               {
                  var callbackFunctions:Array = startPoint.callbackfunctions;
                  // Add each callback function to the collectedCallbacks array
                  for (var functionIndex:int = 0; functionIndex < callbackFunctions.length; functionIndex++)
                  {
                     collectedCallbacks.push(callbackFunctions[functionIndex][0]);
                  }
               }
            }
         }
         _floods = {};

         // Invoke each callback function with an empty path and null as the building parameter
         for (var callbackIndex:int = 0; callbackIndex < collectedCallbacks.length; callbackIndex++)
         {
            collectedCallbacks[callbackIndex]([], null, true);
         }
      }

      public static function Cleanup():void
      {
         var gridSpace:* = undefined;
         for each (gridSpace in _costs)
         {
            delete _costs[gridSpace];
         }
         _costs = {};
         _floods = {};
      }

      public static function LineOfSight(startX:int, startY:int, targetX:int, targetY:int, targetBuilding:BFOUNDATION = null, includeAllBuildings:Boolean = false):Boolean
      {
         var gridStart:Point = GlobalLocal(FromISO(new Point(startX, startY)));
         var gridTarget:Point = GlobalLocal(FromISO(new Point(targetX, targetY)));
         var difX:Number = gridTarget.x - gridStart.x;
         var difY:Number = gridTarget.y - gridStart.y;
         var angle:Number = Math.atan2(difY, difX) * c180PI;
         var totalDistance:Number = Math.sqrt(difX * difX + difY * difY);
         for (var currentDistance:int = 0; currentDistance < totalDistance; currentDistance++)
         {
            var gridX:int = gridStart.x + Math.cos(angle * cPI180) * currentDistance;
            var gridY:int = gridStart.y + Math.sin(angle * cPI180) * currentDistance;
            var gridKey:int = gridX * 1000 + gridY;
            if (!_costs[gridKey])
            {
               return true;
            }
            var wall:BFOUNDATION = _costs[gridKey].building;
            if (Boolean(wall) && wall.health > 0)
            {
               if (!(Boolean(targetBuilding) && wall == targetBuilding))
               {
                  if (wall._type == 17 || includeAllBuildings)
                  {
                     return false;
                  }
               }
            }
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

      private static function GlobalLocal(toGridPoint:Point):Point
      {
         toGridPoint.x *= 0.1;
         toGridPoint.y *= 0.1;
         toGridPoint.x += _gridWidth >> 1;
         toGridPoint.y += _gridHeight >> 1;
         toGridPoint.x = int(toGridPoint.x);
         toGridPoint.y = int(toGridPoint.y);
         return toGridPoint;
      }

      public static function LocalGlobal(toCartPoint:Point):Point
      {
         toCartPoint.x -= _gridWidth >> 1;
         toCartPoint.y -= _gridHeight >> 1;
         toCartPoint.x *= 10;
         toCartPoint.y *= 10;
         return toCartPoint;
      }

      public static function ToISO(cartPoint:Point, offset:int):Point
      {
         var isoY:int = (cartPoint.x + cartPoint.y) * 0.5 - offset;
         var isoX:int = cartPoint.x - cartPoint.y;
         return new Point(isoX, isoY);
      }

      public static function FromISO(isoPoint:Point):Point
      {
         var cartY:int = isoPoint.y - isoPoint.x * 0.5;
         var cartX:int = isoPoint.x * 0.5 + isoPoint.y;
         return new Point(cartX, cartY);
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

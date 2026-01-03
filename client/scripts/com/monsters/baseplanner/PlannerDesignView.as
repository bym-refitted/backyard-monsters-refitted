package com.monsters.baseplanner
{
   import com.monsters.baseplanner.components.BuildingItem;
   import com.monsters.baseplanner.components.DashedLine;
   import com.monsters.baseplanner.components.HitTestBitmap;
   import com.monsters.baseplanner.events.BasePlannerNodeEvent;
   import com.monsters.baseplanner.popups.BasePlannerPopup;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;

   public class PlannerDesignView extends Sprite
   {

      public static var zoomValue:Number = 0.5;

      public static const CHECKBOX_GROUND:uint = 0;

      public static const CHECKBOX_AIR:uint = 1;

      public static const CHECKBOX_TRAP:uint = 2;

      private static const SIDEBAR_WIDTH:int = 140;

      private static const BOTTOMBAR_HEIGHT:int = 50;

      private static const SCROLL_ACTIVATION_PIXEL_THRESHOLD:int = 20;

      public static var SHOULD_SHOW_MOREINFO:Boolean = true;

      public static var SHOULD_SHOW_FORTIFICATION:Boolean = false;

      public static const BUILDING_CLICK:String = "building_clicked";

      public static const BUILDING_OVER:String = "building_over";

      public static const BUILDING_OUT:String = "building_out";

      public static const BUILDING_PLACED:String = "building_placed";

      public static const CANVAS_CLICK:String = "view_clicked";

      public static const STATE_CHANGE:String = "design_statechange";

      private static const ADD_INVENTORY_PAINTMODE:Boolean = true;

      public static const TOOL_SELECTMOVE:String = "selectmove";

      public static const TOOL_STORE:String = "storebuilding";

      public static const MOUSE_POSITION_SNAP_THRESHHOLD:int = 5;

      private var _canvas:Sprite;

      private var _layerSelectBuildings:Sprite;

      private var _layerSelectRanges:Sprite;

      private var _layerShroud:Sprite;

      private var _layerSetBuildings:Sprite;

      private var _layerSetRanges:Sprite;

      private var _layerGround:Sprite;

      private var displayData:Vector.<PlannerNode>;

      private var displayInventory:Vector.<BuildingItem>;

      private var fontSize:Point;

      public var xSpot:MovieClip;

      public const zoomMax:Number = 2;

      public const zoomMin:Number = 0.25;

      public const zoomStep:Number = 0.25;

      private var rangeCheckboxesFlags:uint = 0;

      private var _isAddingBuilding:Boolean = false;

      public var _dragging:Boolean = false;

      public var _dragged:Boolean = false;

      private var _dragOffset:Point;

      public var _dragPoint:Point;

      public var _windowRect:Rectangle;

      private const GRASSCOLOR:uint = 6723891;

      private const BOUNDS_LINE_COLOR:uint = 16777215;

      private const BOUNDS_DASHEDLINE_COLOR:uint = 15658734;

      private const BOUNDS_LINE_WEIGHT:uint = 2;

      private const MAX_YARD_DIMENSIONS:Point = new Point(3240, 2600);

      private const YARD_EXPANSIONS:Array = [new Point(1000, 800), new Point(1100, 880), new Point(1220, 980), new Point(1340, 1080), new Point(1480, 1180), new Point(1620, 1300), new Point(1780, 1420)];

      public var currentTool:String = "selectmove";

      public var toolTarget:Object;

      public var _selectMoveDragging:Boolean = false;

      public var _selectMoveTarget:BuildingItem;

      public var _selectMoveInventoryBuilding:Boolean = false;

      public var _selectMoveDragPoint:Point;

      public function PlannerDesignView(param1:Vector.<PlannerNode>)
      {
         this.fontSize = new Point(14, 12);
         this._windowRect = new Rectangle(35, 65, 565, 425);
         super();
         this.displayData = param1;
      }

      public function setup():void
      {
         this.clearAllLayers();
         if (this._canvas)
         {
            this.clearLayer(this._canvas);
         }
         this._canvas = new Sprite();
         this.addChild(this._canvas);
         addEventListener(MouseEvent.MOUSE_DOWN, this.canvasDragStart);
         addEventListener(MouseEvent.CLICK, this.onCanvasClick);
         this._canvas.addChild(this._layerGround);
         this._canvas.addChild(this._layerSetBuildings);
         this._canvas.addChild(this._layerSetRanges);
         this._canvas.addChild(this._layerShroud);
         this._canvas.addChild(this._layerSelectRanges);
         this._canvas.addChild(this._layerSelectBuildings);
         this.setZoom(zoomValue);
         this.centerView();
         this.displayInventory = new Vector.<BuildingItem>();
         this.fillGrass(this._layerGround);
         this.drawYardBounds();
         this.populateBuildingItems(this.displayData);
         this.drawRanges();
         this.recenter();
      }

      public function centerView():void
      {
         this._canvas.x = 260;
         this._canvas.y = 290;
      }

      public function populateBuildingItems(param1:Vector.<PlannerNode>):void
      {
         var _loc4_:BuildingItem = null;
         var _loc2_:int = 1;
         var _loc3_:int = 0;
         while (_loc3_ < param1.length)
         {
            (_loc4_ = new BuildingItem(param1[_loc3_])).addEventListener(BUILDING_CLICK, this.onBuildingClick);
            _loc4_.addEventListener(BUILDING_OVER, this.onBuildingOver);
            _loc4_.addEventListener(BUILDING_OUT, this.onBuildingOut);
            this._layerSetBuildings.addChild(_loc4_);
            this.displayInventory.push(_loc4_);
            _loc3_++;
         }
      }

      private function drawYardBounds():void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc8_:Sprite = null;
         var _loc9_:DashedLine = null;
         var _loc1_:int = 1;
         if (STORE._storeData.ENL)
         {
            _loc1_ = STORE._storeData.ENL.q + 1;
         }
         var _loc2_:int = 0;
         if (STORE._storeData.ENL)
         {
            _loc2_ = int(STORE._storeData.ENL.q);
         }
         var _loc3_:Point = new Point();
         var _loc4_:Point = new Point();
         _loc3_ = this.YARD_EXPANSIONS[_loc2_];
         _loc4_ = this.YARD_EXPANSIONS[Math.min(_loc2_ + 1, this.YARD_EXPANSIONS.length - 1)];
         _loc5_ = new Rectangle(-_loc3_.x / 2, -_loc3_.y / 2, _loc3_.x, _loc3_.y);
         if (Math.min(_loc2_ + 1, this.YARD_EXPANSIONS.length - 1) > _loc2_)
         {
            _loc6_ = new Rectangle(-_loc4_.x / 2, -_loc4_.y / 2, _loc4_.x, _loc4_.y);
         }
         if (Boolean(_loc6_) && !BASE.isOutpost)
         {
            (_loc8_ = new Sprite()).graphics.beginFill(16777215, 0.25);
            _loc8_.graphics.drawRect(_loc6_.x, _loc6_.y, _loc6_.width, _loc6_.height);
            _loc8_.graphics.endFill();
            this._layerGround.addChild(_loc8_);
            (_loc9_ = new DashedLine(this.BOUNDS_LINE_WEIGHT, this.BOUNDS_DASHEDLINE_COLOR, new Array(8, 4, 2, 4))).moveTo(_loc6_.x, _loc6_.y);
            _loc9_.lineTo(_loc6_.x + _loc6_.width, _loc6_.y);
            _loc9_.lineTo(_loc6_.x + _loc6_.width, _loc6_.y + _loc6_.height);
            _loc9_.lineTo(_loc6_.x, _loc6_.y + _loc6_.height);
            _loc9_.lineTo(_loc6_.x, _loc6_.y);
            this._layerGround.addChild(_loc9_);
         }
         var _loc7_:Sprite;
         (_loc7_ = new Sprite()).graphics.lineStyle(this.BOUNDS_LINE_WEIGHT, this.BOUNDS_LINE_COLOR, 1);
         _loc7_.graphics.beginFill(16777215, 0.25);
         _loc7_.graphics.drawRect(_loc5_.x, _loc5_.y, _loc5_.width, _loc5_.height);
         _loc7_.graphics.endFill();
         this._layerGround.addChild(_loc7_);
      }

      public function setZoom(param1:Number):void
      {
         if (param1 > 0 && param1 < 10)
         {
            zoomValue = param1;
            this._canvas.scaleX = this._canvas.scaleY = zoomValue;
            this.dealWithZoomReposition();
         }
      }

      private function dealWithZoomReposition():void
      {
         this._dragOffset = new Point(this._canvas.x - mouseX, this._canvas.y - mouseY);
         this.checkDragBounds();
      }

      public function fillGrass(param1:Sprite):void
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(this.GRASSCOLOR, 1);
         _loc2_.graphics.drawRect(0, 0, this.MAX_YARD_DIMENSIONS.x, this.MAX_YARD_DIMENSIONS.y);
         _loc2_.graphics.endFill();
         _loc2_.x = -(_loc2_.width / 2);
         _loc2_.y = -(_loc2_.height / 2);
         this.xSpot = new BasePlannerPopup_xSpot();
         this.xSpot.x = _loc2_.width / 2;
         this.xSpot.y = _loc2_.height / 2;
         this.xSpot.rotation = 45;
         _loc2_.addChild(this.xSpot);
         param1.addChild(_loc2_);
      }

      public function onCanvasClick(param1:MouseEvent = null):void
      {
         if (this.currentTool == TOOL_SELECTMOVE)
         {
            if (this._selectMoveDragging)
            {
            }
         }
      }

      public function canvasDragStart(param1:MouseEvent = null):void
      {
         this._dragging = true;
         this._dragged = false;
         this._dragOffset = new Point(this._canvas.x - mouseX, this._canvas.y - mouseY);
         this._dragPoint = new Point(this._canvas.x, this._canvas.y);
         GAME._instance.addEventListener(MouseEvent.MOUSE_MOVE, this.canvasDrag);
         GAME._instance.addEventListener(MouseEvent.MOUSE_UP, this.canvasDragStop);
         GAME._instance.addEventListener(MouseEvent.ROLL_OUT, this.canvasDragStop);
      }

      public function canvasDragStop(param1:MouseEvent = null):void
      {
         this._dragging = false;
         GAME._instance.removeEventListener(MouseEvent.MOUSE_MOVE, this.canvasDrag);
         GAME._instance.removeEventListener(MouseEvent.MOUSE_UP, this.canvasDragStop);
         GAME._instance.removeEventListener(MouseEvent.ROLL_OUT, this.canvasDragStop);
      }

      public function canvasDrag(param1:Event = null):void
      {
         if (this._dragged)
         {
            this.checkDragBounds();
            return;
         }
         var _loc2_:Number = this._canvas.x - (mouseX + this._dragOffset.x);
         var _loc3_:Number = this._canvas.y - (mouseY + this._dragOffset.y);
         if (Math.abs(_loc2_) > SCROLL_ACTIVATION_PIXEL_THRESHOLD || Math.abs(_loc3_) > SCROLL_ACTIVATION_PIXEL_THRESHOLD)
         {
            this._dragOffset.x += _loc2_;
            this._dragOffset.y += _loc3_;
            this.checkDragBounds();
         }
      }

      private function checkDragBounds():void
      {
         var _loc1_:Number = mouseX + this._dragOffset.x;
         if (_loc1_ > this._canvas.width / 2)
         {
            _loc1_ = this._canvas.width / 2;
         }
         else if (_loc1_ < GLOBAL._SCREEN.width - this._canvas.width / 2 - SIDEBAR_WIDTH)
         {
            _loc1_ = GLOBAL._SCREEN.width - this._canvas.width / 2 - SIDEBAR_WIDTH;
         }
         if (this._canvas.width < GLOBAL._SCREEN.width)
         {
            _loc1_ = GLOBAL._SCREEN.width / 2 - SIDEBAR_WIDTH;
         }
         this._canvas.x = _loc1_;
         _loc1_ = mouseY + this._dragOffset.y;
         if (_loc1_ > this._canvas.height / 2)
         {
            _loc1_ = this._canvas.height / 2;
         }
         else if (_loc1_ < GLOBAL._SCREEN.height - this._canvas.height / 2 - BOTTOMBAR_HEIGHT)
         {
            _loc1_ = GLOBAL._SCREEN.height - this._canvas.height / 2 - BOTTOMBAR_HEIGHT;
         }
         if (this._canvas.height < GLOBAL._SCREEN.height)
         {
            _loc1_ = GLOBAL._SCREEN.height / 2 - BOTTOMBAR_HEIGHT;
         }
         this._canvas.y = _loc1_;
         this._dragged = true;
      }

      public function recenter():void
      {
         this._canvas.x = GLOBAL._SCREEN.width / 2 - SIDEBAR_WIDTH;
         this._canvas.y = GLOBAL._SCREEN.height / 2 - BOTTOMBAR_HEIGHT;
      }

      public function addInventoryItem(param1:PlannerNode):void
      {
         var _loc2_:BuildingItem = null;
         var _loc3_:Point = null;
         var _loc4_:* = false;
         if (!this._isAddingBuilding)
         {
            this._isAddingBuilding = true;
            _loc2_ = new BuildingItem(param1);
            _loc2_.addEventListener(BUILDING_CLICK, this.onBuildingClick);
            _loc2_.addEventListener(BUILDING_OVER, this.onBuildingOver);
            _loc2_.addEventListener(BUILDING_OUT, this.onBuildingOut);
            _loc2_.x = 0;
            _loc2_.y = 0;
            _loc3_ = new Point(0, 0);
            if (this._dragPoint)
            {
               _loc3_ = this._dragPoint;
            }
            _loc2_.x = -(_loc2_.mc.width / 2);
            _loc2_.y = -(_loc2_.mc.height / 2);
            _loc2_.x += int((mouseX - this._canvas.x) / this._canvas.scaleX);
            _loc2_.y += int((mouseY - this._canvas.y) / this._canvas.scaleY);
            this._layerSetBuildings.addChild(_loc2_);
            this.displayInventory.push(_loc2_);
            this.addMode(_loc2_);
         }
         else
         {
            _loc4_ = param1.type == this._selectMoveTarget.node.type;
            if (this._selectMoveDragging)
            {
               this.cancelAddInventory(this._selectMoveTarget);
               if (!_loc4_)
               {
                  this.addInventoryItem(param1);
               }
            }
         }
      }

      public function cancelAddInventory(param1:BuildingItem):void
      {
         this._selectMoveDragging = false;
         this._isAddingBuilding = false;
         this._selectMoveInventoryBuilding = false;
         this.currentTool = TOOL_SELECTMOVE;
         this.removeBuildingItem(param1);
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.DESIGN_BUILDING_INVALID, param1.node));
         removeEventListener(MouseEvent.MOUSE_MOVE, this.dragBuildingTick);
      }

      public function addMode(param1:BuildingItem):void
      {
         this.currentTool = TOOL_SELECTMOVE;
         this.toolTarget = param1;
         this.dragBuilding(param1, true);
      }

      public function setTool(param1:String):void
      {
         if (this.currentTool == param1)
         {
            return;
         }
         this.currentTool = param1;
         dispatchEvent(new Event(BasePlannerPopup.DESIGN_TOOL_UPDATE));
         if (param1)
         {
            this.removeSelection();
         }
      }

      public function removeSelection():void
      {
         if (this._selectMoveTarget)
         {
            this.cancelDragBuilding(this._selectMoveTarget);
         }
      }

      public function onBuildingClick(param1:BasePlannerNodeEvent):void
      {
         var _loc2_:BuildingItem = null;
         var _loc3_:PlannerNode = null;
         this.toolTarget = param1.target as Object;
         if (!param1.target is BuildingItem)
         {
            return;
         }
         _loc2_ = param1.target as BuildingItem;
         if (_loc2_.props.type == "enemy")
         {
            return;
         }
         if (this.currentTool == TOOL_SELECTMOVE || this._selectMoveDragging)
         {
            this.dragBuilding(_loc2_);
         }
         else if (this.currentTool == TOOL_STORE)
         {
            this.storeBuilding(_loc2_);
            this.redrawRanges();
         }
      }

      public function onBuildingOver(param1:BasePlannerNodeEvent):void
      {
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.PLANNER_HINT, param1.node));
      }

      public function onBuildingOut(param1:BasePlannerNodeEvent):void
      {
         if (!this._selectMoveDragging)
         {
            dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.PLANNER_HINT_HIDE, param1.node));
         }
      }

      public function storeBuilding(param1:BuildingItem):void
      {
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.DESIGN_BUILDING_STORE, param1.node));
         dispatchEvent(new Event(STATE_CHANGE));
         this.removeBuildingItem(param1);
      }

      public function spliceDisplayData(param1:PlannerNode):void
      {
         this.displayData.splice(this.displayData.indexOf(param1), 1);
      }

      public function removeBuildingItem(param1:BuildingItem):void
      {
         var _loc2_:int = 0;
         while (_loc2_ < this.displayInventory.length)
         {
            if (param1 == this.displayInventory[_loc2_])
            {
               this.displayInventory[_loc2_].parent.removeChild(this.displayInventory[_loc2_]);
               this.displayInventory.splice(_loc2_, 1);
               param1 = null;
               return;
            }
            _loc2_++;
         }
      }

      public function dragBuilding(param1:BuildingItem, param2:Boolean = false):void
      {
         if (this._selectMoveDragging && this._selectMoveTarget != param1)
         {
            return; // a different building is already being dragged.
         }
         this._selectMoveTarget = param1;
         if (param2)
         {
            this._selectMoveInventoryBuilding = true;
            if (this.currentTool)
            {
               this.setTool("");
            }
         }
         if (!this._selectMoveDragging)
         {
            this.startDragBuilding(param1);
         }
         else
         {
            this.stopDragBuilding(param1);
         }
      }

      public function startDragBuilding(param1:BuildingItem):void
      {
         var _loc2_:Boolean = false;
         if (this._selectMoveDragging)
         {
            return;
         }
         this._selectMoveDragging = true;
         this.sortBuildingOrder(param1, "front");
         param1.setPositionReference();
         if (_loc2_)
         {
            this._selectMoveDragPoint = new Point(param1.x - (this.mouseX - this._canvas.x) / this._canvas.scaleX, param1.y - (this.mouseY - this._canvas.y) / this._canvas.scaleY);
         }
         else
         {
            this._selectMoveDragPoint = new Point(0 - param1.widthsize / 2 * param1.scale, 0 - param1.widthsize / 2 * param1.scale);
         }
         addEventListener(MouseEvent.MOUSE_MOVE, this.dragBuildingTick);
      }

      public function stepDragBuilding(param1:BuildingItem):void
      {
      }

      public function dragBuildingTick(param1:Event):void
      {
         this._selectMoveTarget.toggleInvalid(!this.validateBuilding(this._selectMoveTarget));
         this._selectMoveTarget.x = int(((this.mouseX - this._canvas.x) / this._canvas.scaleX + this._selectMoveDragPoint.x) / MOUSE_POSITION_SNAP_THRESHHOLD) * MOUSE_POSITION_SNAP_THRESHHOLD;
         this._selectMoveTarget.y = int(((this.mouseY - this._canvas.y) / this._canvas.scaleY + this._selectMoveDragPoint.y) / MOUSE_POSITION_SNAP_THRESHHOLD) * MOUSE_POSITION_SNAP_THRESHHOLD;
         this.redrawRanges();
      }

      public function stopDragBuilding(param1:BuildingItem, param2:Boolean = false):void
      {
         this._selectMoveDragging = false;
         this._isAddingBuilding = false;
         if (this.validateBuilding(param1))
         {
            param1.toggleInvalid(false);
            param1.setPositionReference();
            this.updateNodeReference(param1);
            if (this._selectMoveInventoryBuilding)
            {
               this.displayData.push(param1.node);
               dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.DESIGN_BUILDING_PLACE, param1.node));
            }
            dispatchEvent(new Event(STATE_CHANGE));
         }
         else
         {
            if (this._selectMoveInventoryBuilding)
            {
               if (ADD_INVENTORY_PAINTMODE && !param2)
               {
                  this._selectMoveDragging = true;
                  this._isAddingBuilding = true;
                  return;
               }
               this.removeBuildingItem(param1);
               dispatchEvent(new Event(BasePlannerPopup.DESIGN_CLEAR_EXPLORER));
            }
            param1.resetPositionReference();
            dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.DESIGN_BUILDING_INVALID, param1.node));
         }
         if (!this._selectMoveDragging)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE, this.dragBuildingTick);
            param1.toggleInvalid(false);
            this._selectMoveInventoryBuilding = false;
            this.setTool(TOOL_SELECTMOVE);
         }
      }

      public function cancelDragBuilding(param1:BuildingItem):void
      {
         this._selectMoveDragging = false;
         this._isAddingBuilding = false;
         if (this._selectMoveInventoryBuilding)
         {
            this.removeBuildingItem(param1);
            dispatchEvent(new Event(BasePlannerPopup.DESIGN_CLEAR_EXPLORER));
         }
         param1.resetPositionReference();
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.DESIGN_BUILDING_INVALID, param1.node));
         if (!this._selectMoveDragging)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE, this.dragBuildingTick);
            param1.toggleInvalid(false);
            this._selectMoveInventoryBuilding = false;
            this._selectMoveTarget = null;
         }
      }

      public function updateNodeReference(param1:BuildingItem):void
      {
         var _loc2_:int = 0;
         while (_loc2_ < this.displayData.length)
         {
            if (this.displayData[_loc2_] == param1.node)
            {
               this.displayData[_loc2_].x = param1.node.x;
               this.displayData[_loc2_].y = param1.node.y;
               return;
            }
            _loc2_++;
         }
      }

      public function sortBuildingOrder(param1:BuildingItem, param2:String = "front"):void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Sprite = param1.parent as Sprite;
         if (!_loc3_)
         {
            return;
         }
         switch (param2)
         {
            case "back":
            case "bottom":
               _loc3_.setChildIndex(param1, 0);
               break;
            case "front":
            case "top":
            default:
               _loc3_.addChild(param1);
         }
      }

      public function validateBuilding(param1:BuildingItem):Boolean
      {
         var _loc2_:int = 0;
         while (_loc2_ < this.displayInventory.length)
         {
            if (this.displayInventory[_loc2_] != param1)
            {
               if (HitTestBitmap.complexHitTestObject(param1.mc, this.displayInventory[_loc2_].mc))
               {
                  return false;
               }
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         if (STORE._storeData.ENL)
         {
            _loc3_ = int(STORE._storeData.ENL.q);
         }
         var _loc4_:Point = this.YARD_EXPANSIONS[_loc3_];
         if (param1.category != BuildingItem.TYPE_DECORATION)
         {
            if (param1.x < -_loc4_.x / 2 || param1.y < -_loc4_.y / 2 || param1.x > _loc4_.x / 2 - param1.widthsize || param1.y > _loc4_.y / 2 - param1.widthsize)
            {
               return false;
            }
         }
         else if (param1.x < -this.MAX_YARD_DIMENSIONS.x / 2 || param1.y < -this.MAX_YARD_DIMENSIONS.y / 2 || param1.x > this.MAX_YARD_DIMENSIONS.x / 2 - param1.widthsize || param1.y > this.MAX_YARD_DIMENSIONS.y / 2 - param1.widthsize)
         {
            return false;
         }
         return true;
      }

      public function Bounds():void
      {
      }

      public function clearAllLayers():void
      {
         if (this._layerSelectBuildings)
         {
            this.clearLayer(this._layerSelectBuildings);
         }
         this._layerSelectBuildings = new Sprite();
         this._layerSelectBuildings.mouseEnabled = false;
         if (this._layerSelectRanges)
         {
            this.clearLayer(this._layerSelectRanges);
         }
         this._layerSelectRanges = new Sprite();
         this._layerSelectRanges.mouseEnabled = false;
         if (this._layerShroud)
         {
            this.clearLayer(this._layerShroud);
         }
         this._layerShroud = new Sprite();
         this._layerShroud.mouseEnabled = false;
         if (this._layerSetBuildings)
         {
            this.clearLayer(this._layerSetBuildings);
         }
         this._layerSetBuildings = new Sprite();
         this._layerSetBuildings.mouseEnabled = false;
         if (this._layerSetRanges)
         {
            this.clearLayer(this._layerSetRanges);
         }
         this._layerSetRanges = new Sprite();
         this._layerSetRanges.mouseEnabled = false;
         if (this._layerGround)
         {
            this.clearLayer(this._layerGround);
         }
         this._layerGround = new Sprite();
         this._layerGround.mouseEnabled = false;
      }

      public function clearLayer(param1:Sprite):void
      {
         while (param1.numChildren)
         {
            if ("remove" in param1.getChildAt(0))
            {
               (param1.getChildAt(0) as Object).remove();
            }
            param1.removeChildAt(0);
         }
      }

      public function remove():void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN, this.canvasDragStart);
         removeEventListener(MouseEvent.CLICK, this.onCanvasClick);
         GAME._instance.removeEventListener(MouseEvent.MOUSE_MOVE, this.canvasDrag);
         GAME._instance.removeEventListener(MouseEvent.MOUSE_UP, this.canvasDragStop);
         GAME._instance.removeEventListener(MouseEvent.ROLL_OUT, this.canvasDragStop);
         this.clearAllLayers();
      }

      public function redraw(param1:Vector.<PlannerNode> = null):void
      {
         this.setup();
      }

      public function toggleView(param1:Checkbox):void
      {
         switch (param1.name)
         {
            case "check1":
               this.rangeCheckboxesFlags ^= 1 << CHECKBOX_GROUND;
               break;
            case "check2":
               this.rangeCheckboxesFlags ^= 1 << CHECKBOX_AIR;
               break;
            case "check3":
               this.rangeCheckboxesFlags ^= 1 << CHECKBOX_TRAP;
               break;
            case "check4":
               this.toggleMoreInfo(param1.Checked);
         }
         this.redrawRanges();
      }

      private function toggleMoreInfo(param1:Boolean = false):void
      {
         if (!SHOULD_SHOW_MOREINFO)
         {
            return;
         }
         var _loc2_:int = 0;
         while (_loc2_ < this.displayInventory.length)
         {
            this.displayInventory[_loc2_].toggleMoreInfo(param1, SHOULD_SHOW_FORTIFICATION);
            _loc2_++;
         }
      }

      public function redrawRanges():void
      {
         this.clearRanges();
         this.drawRanges();
      }

      private function clearRanges():void
      {
         while (this._layerSetRanges.numChildren)
         {
            this._layerSetRanges.removeChildAt(0);
         }
      }

      private function drawRanges():void
      {
         var _loc2_:BuildingItem = null;
         var _loc3_:Boolean = false;
         var _loc1_:Sprite = new Sprite();
         var _loc4_:int = 0;
         while (_loc4_ < this._layerSetBuildings.numChildren)
         {
            _loc3_ = false;
            _loc2_ = this._layerSetBuildings.getChildAt(_loc4_) as BuildingItem;
            if (Boolean(this.rangeCheckboxesFlags & 1 << CHECKBOX_TRAP) && _loc2_.category == BuildingItem.TYPE_TRAP)
            {
               _loc3_ = true;
            }
            else if (_loc2_.rangeCategory())
            {
               switch (_loc2_.rangeCategory())
               {
                  case 1:
                  case 2:
                     _loc3_ = Boolean(this.rangeCheckboxesFlags & 1 << _loc2_.rangeCategory() - 1);
                     break;
                  case 3:
                     _loc3_ = Boolean(this.rangeCheckboxesFlags & 1 << CHECKBOX_GROUND || this.rangeCheckboxesFlags & 1 << CHECKBOX_AIR);
               }
            }
            if (_loc3_)
            {
               _loc1_.mouseEnabled = false;
               _loc1_.graphics.lineStyle(3, 16777215, 0.25);
               _loc1_.graphics.beginFill(16711680, 0.1);
               _loc1_.graphics.drawCircle(_loc2_.x + _loc2_.widthsize / 2, _loc2_.y + _loc2_.widthsize / 2, _loc2_.node.range * _loc2_.scale);
               this._layerSetRanges.addChild(_loc1_);
               _loc1_.graphics.endFill();
            }
            _loc4_++;
         }
      }
   }
}

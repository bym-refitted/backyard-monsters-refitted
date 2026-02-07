package com.monsters.maproom3
{
   import com.cc.ui.ArrowKeyState;
   import com.monsters.maproom3.data.MapRoom3Data;
   import com.monsters.maproom3.tiles.MapRoom3TileSetManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import gs.TweenLite;
   import gs.easing.Quad;
   
   public class MapRoom3Window extends Sprite
   {
      
      private static const RANGE_LAYER_ALPHA:Number = 0.2;
      
      private static const RANGE_GLOW_BLUR_X:Number = 50;
      
      private static const RANGE_GLOW_BLUR_Y:Number = 50;
      
      private static const RANGE_GLOW_BLUR_STRENGTH:Number = 2;
      
      private static const RANGE_GLOW_COLOUR:uint = 3381708;
      
      private static const MOUSEOVER_RANGE_GLOW_COLOUR:uint = 16711680;
      
      private static const KEY_SCROLL_START_VELOCITY:Number = 8;
      
      private static const KEY_SCROLL_MAX_VELOCITY:Number = 18;
      
      private static const KEY_SCROLL_ACCELERATION:Number = 0.25;
      
      private static const k_MAX_FILTER_TOTAL_SIZE:Number = 16777215;
      
      private static const k_MAX_FILTER_SIZE:Number = 8191;
      
      private var RANGE_GLOW_FILTER:GlowFilter = new GlowFilter(RANGE_GLOW_COLOUR,0.5,RANGE_GLOW_BLUR_X,RANGE_GLOW_BLUR_Y,RANGE_GLOW_BLUR_STRENGTH,1,true,true);
      
      private var MOUSEOVER_RANGE_GLOW_FILTER:GlowFilter = new GlowFilter(MOUSEOVER_RANGE_GLOW_COLOUR,0.5,RANGE_GLOW_BLUR_X,RANGE_GLOW_BLUR_Y,RANGE_GLOW_BLUR_STRENGTH,1,true,true);
      
      private var m_MapData:MapRoom3Data;
      
      private var m_TileBuffer:Vector.<MapRoom3CellGraphic> = new Vector.<MapRoom3CellGraphic>();
      
      private var m_TileLookup:Array = new Array();
      
      private var m_BackgroundImage:BitmapData;
      
      private var m_ScrollingCanvas:Sprite;
      
      private var m_BaseLayer:Sprite;
      
      private var m_RangeAlphaLayer:Sprite;
      
      private var m_RangeLayer:Sprite;
      
      private var m_RangeGlowLayer:Sprite;
      
      private var m_MouseoverRangeAlphaLayer:Sprite;
      
      private var m_MouseoverRangeLayer:Sprite;
      
      private var m_MouseoverRangeGlowLayer:Sprite;
      
      private var m_CellOverlayLayer:Sprite;
      
      private var m_TileLayer:Sprite;
      
      private var m_InfoLayer:Sprite;
      
      private var m_MouseoverInfo:MapRoom3CellMouseover = new MapRoom3CellMouseover();
      
      private var m_MousedoverCellGraphic:MapRoom3CellGraphic = null;
      
      private var m_SelectedCellGraphic:MapRoom3CellGraphic = null;
      
      private var m_CenterPoint:Point = new Point();
      
      private var m_CenterPointForLoading:Point = new Point();
      
      private var m_CenterPointForLoadingLocked:Boolean = false;
      
      private var m_TempStartDragPoint:Point;
      
      private var m_StartDragPoint:Point;
      
      private var m_StopDragPoint:Point;
      
      private var m_DragTimer:Timer;
      
      private var m_Dragging:Boolean = false;
      
      private var m_KeyScrollVelocity:Number = 8;

      private var m_RangeGlowBitmap:Bitmap;

      private var m_RangeGlowCacheDirty:Boolean = true;

      private var m_MouseoverRangeGlowBitmap:Bitmap;

      private var m_MouseoverRangeGlowCacheDirty:Boolean = true;

      private var m_GlowCacheMatrix:Matrix = new Matrix();

      private var m_GlowCachePoint:Point = new Point(0,0);

      public function MapRoom3Window(param1:MapRoom3Data)
      {
         super();
         this.m_MapData = param1;
         this.m_ScrollingCanvas = new Sprite();
         this.m_ScrollingCanvas.mouseEnabled = false;
         addChild(this.m_ScrollingCanvas);
         this.m_BaseLayer = new Sprite();
         this.m_BaseLayer.mouseEnabled = false;
         this.m_ScrollingCanvas.addChild(this.m_BaseLayer);
         this.m_RangeAlphaLayer = new Sprite();
         this.m_RangeAlphaLayer.mouseEnabled = false;
         this.m_RangeAlphaLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_RangeAlphaLayer);
         this.m_RangeLayer = new Sprite();
         this.m_RangeLayer.mouseEnabled = false;
         this.m_RangeLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_RangeLayer);
         this.m_RangeAlphaLayer.mask = this.m_RangeLayer;
         this.m_RangeGlowLayer = new Sprite();
         this.m_RangeGlowLayer.mouseEnabled = false;
         this.m_RangeGlowLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_RangeGlowLayer);
         this.m_RangeGlowLayer.visible = false;
         this.m_RangeGlowBitmap = new Bitmap();
         this.m_ScrollingCanvas.addChild(this.m_RangeGlowBitmap);
         this.m_MouseoverRangeAlphaLayer = new Sprite();
         this.m_MouseoverRangeAlphaLayer.mouseEnabled = false;
         this.m_MouseoverRangeAlphaLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_MouseoverRangeAlphaLayer);
         this.m_MouseoverRangeLayer = new Sprite();
         this.m_MouseoverRangeLayer.mouseEnabled = false;
         this.m_MouseoverRangeLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_MouseoverRangeLayer);
         this.m_MouseoverRangeAlphaLayer.mask = this.m_MouseoverRangeLayer;
         this.m_MouseoverRangeGlowLayer = new Sprite();
         this.m_MouseoverRangeGlowLayer.mouseEnabled = false;
         this.m_MouseoverRangeGlowLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_MouseoverRangeGlowLayer);
         this.m_MouseoverRangeGlowLayer.visible = false;
         this.m_MouseoverRangeGlowBitmap = new Bitmap();
         this.m_ScrollingCanvas.addChild(this.m_MouseoverRangeGlowBitmap);
         this.m_CellOverlayLayer = new Sprite();
         this.m_CellOverlayLayer.mouseEnabled = false;
         this.m_ScrollingCanvas.addChild(this.m_CellOverlayLayer);
         this.m_TileLayer = new Sprite();
         this.m_TileLayer.mouseEnabled = false;
         this.m_ScrollingCanvas.addChild(this.m_TileLayer);
         this.m_InfoLayer = new Sprite();
         this.m_InfoLayer.mouseEnabled = false;
         this.m_InfoLayer.mouseChildren = false;
         this.m_ScrollingCanvas.addChild(this.m_InfoLayer);
         this.m_DragTimer = new Timer(100,1);
         this.m_DragTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.OnDragTimerComplete);
         addEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMoved,false,0,true);
         addEventListener(MouseEvent.CLICK,this.OnMouseClicked,true,0,true);
         this.m_MouseoverInfo.visible = false;
         addChild(this.m_MouseoverInfo);
         this.m_BackgroundImage = MapRoom3TileSetManager.instance.currentBackground;
         this.DrawBackground();
      }
      
      public function get scrollingCanvas() : Sprite
      {
         return this.m_ScrollingCanvas;
      }
      
      public function get baseLayer() : Sprite
      {
         return this.m_BaseLayer;
      }
      
      public function get rangeAlphaLayer() : Sprite
      {
         return this.m_RangeAlphaLayer;
      }
      
      public function get rangeLayer() : Sprite
      {
         return this.m_RangeLayer;
      }
      
      public function get rangeGlowLayer() : Sprite
      {
         return this.m_RangeGlowLayer;
      }
      
      public function get mouseoverRangeAlphaLayer() : Sprite
      {
         return this.m_MouseoverRangeAlphaLayer;
      }
      
      public function get mouseoverRangeLayer() : Sprite
      {
         return this.m_MouseoverRangeLayer;
      }
      
      public function get mouseoverRangeGlowLayer() : Sprite
      {
         return this.m_MouseoverRangeGlowLayer;
      }
      
      public function get cellOverlayLayer() : Sprite
      {
         return this.m_CellOverlayLayer;
      }
      
      public function get infoLayer() : Sprite
      {
         return this.m_InfoLayer;
      }
      
      public function get centerPoint() : Point
      {
         return this.m_CenterPoint;
      }
      
      public function get centerPointForLoading() : Point
      {
         return this.m_CenterPointForLoading;
      }
      
      public function get mouseoverInfo() : MapRoom3CellMouseover
      {
         return this.m_MouseoverInfo;
      }
      
      public function Init(param1:Point) : void
      {
         if(param1 != null)
         {
            this.m_CenterPoint.x = param1.x;
            this.m_CenterPoint.y = param1.y;
         }
         this.CenterOn(this.m_CenterPoint);
      }
      
      public function TickFast() : void
      {
         var _loc1_:uint = this.m_TileBuffer.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this.m_TileBuffer[_loc2_].TickFast();
            _loc2_++;
         }
         this.KeyScroll();
      }
      
      private function AdjustCenterPoint() : void
      {
         this.m_CenterPoint.x = int(-(this.m_ScrollingCanvas.x - (GLOBAL.StageX + GLOBAL.StageWidth * 0.5) + (!!(this.m_CenterPoint.y % 2) ? MapRoom3CellGraphic.HEX_WIDTH * 0.5 : 0)) / MapRoom3CellGraphic.HEX_WIDTH);
         this.m_CenterPoint.y = int(-(this.m_ScrollingCanvas.y - (GLOBAL.StageY + GLOBAL.StageHeight * 0.5)) / MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP);
         this.m_CenterPoint.x /= this.m_ScrollingCanvas.scaleX;
         this.m_CenterPoint.y /= this.m_ScrollingCanvas.scaleY;
         if(!this.m_CenterPointForLoadingLocked)
         {
            this.m_CenterPointForLoading.x = this.m_CenterPoint.x;
            this.m_CenterPointForLoading.y = this.m_CenterPoint.y;
         }
      }
      
      private function OnDragTimerComplete(param1:TimerEvent) : void
      {
         this.m_StartDragPoint = this.m_TempStartDragPoint.clone();
      }
      
      private function OnMouseDown(param1:MouseEvent) : void
      {
         this.m_StartDragPoint = null;
         this.m_TempStartDragPoint = new Point(param1.stageX,param1.stageY);
         this.m_DragTimer.start();
         this.m_Dragging = true;
      }
      
      private function OnMouseUp(param1:MouseEvent) : void
      {
         this.m_KeyScrollVelocity = KEY_SCROLL_START_VELOCITY;
         this.m_Dragging = false;
         this.m_DragTimer.stop();
         this.m_StopDragPoint = new Point(param1.stageX,param1.stageY);
         if(this.m_StartDragPoint != null)
         {
            this.x = Math.round(this.x);
            this.y = Math.round(this.y);
         }
         this.FlushGlowCaches();
      }

      private function OnMouseClicked(param1:MouseEvent) : void
      {
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(this.m_StartDragPoint != null)
         {
            _loc2_ = Math.abs(this.m_StopDragPoint.x - this.m_StartDragPoint.x);
            _loc3_ = Math.abs(this.m_StopDragPoint.y - this.m_StartDragPoint.y);
         }
         if(_loc2_ > 1 || _loc3_ > 1)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function OnMouseMoved(param1:MouseEvent) : void
      {
         if(this.m_Dragging == false)
         {
            return;
         }
         if(param1.buttonDown == false)
         {
            this.OnMouseUp(param1);
            return;
         }
         if(!MapRoom3Tutorial.instance.allowScrolling)
         {
            return;
         }
         var _loc2_:int = param1.stageX - this.m_TempStartDragPoint.x;
         var _loc3_:int = param1.stageY - this.m_TempStartDragPoint.y;
         if(_loc2_ == 0 && _loc3_ == 0)
         {
            return;
         }
         this.SetMousedoverCellGraphic(null);
         this.SetSelectedCellGraphic(null);
         this.m_ScrollingCanvas.x = this.AdjustHorizontalBounds(this.m_ScrollingCanvas.x + _loc2_);
         this.m_ScrollingCanvas.y = this.AdjustVerticalBounds(this.m_ScrollingCanvas.y + _loc3_);
         this.m_TempStartDragPoint.x += _loc2_;
         this.m_TempStartDragPoint.y += _loc3_;
         this.UpdateMap();
         this.m_CenterPointForLoadingLocked = false;
      }
      
      private function KeyScroll() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.m_Dragging)
         {
            return;
         }
         if(ArrowKeyState.ArrowKeyPressed)
         {
            _loc1_ = this.m_KeyScrollVelocity * ArrowKeyState.xDir;
            _loc2_ = this.m_KeyScrollVelocity * ArrowKeyState.yDir;
            if(this.m_KeyScrollVelocity < KEY_SCROLL_MAX_VELOCITY)
            {
               this.m_KeyScrollVelocity += KEY_SCROLL_ACCELERATION;
            }
            else
            {
               this.m_KeyScrollVelocity = KEY_SCROLL_MAX_VELOCITY;
            }
            this.SetMousedoverCellGraphic(null);
            this.SetSelectedCellGraphic(null);
            this.m_ScrollingCanvas.x = this.AdjustHorizontalBounds(this.m_ScrollingCanvas.x + _loc1_);
            this.m_ScrollingCanvas.y = this.AdjustVerticalBounds(this.m_ScrollingCanvas.y + _loc2_);
            this.UpdateMap();
         }
         else
         {
            this.m_KeyScrollVelocity = KEY_SCROLL_START_VELOCITY;
            this.FlushGlowCaches();
         }
      }

      public function Clear() : void
      {
         var _loc1_:MapRoom3CellGraphic = null;
         TweenLite.killTweensOf(this.m_ScrollingCanvas,true);
         this.m_CenterPointForLoadingLocked = false;
         removeEventListener(MouseEvent.MOUSE_DOWN,this.OnMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.OnMouseUp);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMoved);
         removeEventListener(MouseEvent.CLICK,this.OnMouseClicked,true);
         this.m_DragTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.OnDragTimerComplete);
         this.m_DragTimer = null;
         this.m_CenterPoint = null;
         this.m_CenterPointForLoading = null;
         this.m_TempStartDragPoint = null;
         this.m_StartDragPoint = null;
         this.m_StopDragPoint = null;
         this.m_MousedoverCellGraphic = null;
         this.m_SelectedCellGraphic = null;
         this.m_MouseoverInfo.Clear();
         removeChild(this.m_MouseoverInfo);
         this.m_MouseoverInfo = null;
         for each(_loc1_ in this.m_TileBuffer)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.OnCellGraphicClicked);
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.OnCellGraphicRollOver);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.OnCellGraphicRollOut);
            _loc1_.Clear();
            this.m_TileLayer.removeChild(_loc1_);
            _loc1_ = null;
         }
         this.m_TileBuffer.length = 0;
         this.m_TileLookup.length = 0;
         this.m_ScrollingCanvas.removeChild(this.m_InfoLayer);
         this.m_ScrollingCanvas.removeChild(this.m_TileLayer);
         this.m_ScrollingCanvas.removeChild(this.m_CellOverlayLayer);
         this.m_ScrollingCanvas.removeChild(this.m_MouseoverRangeGlowLayer);
         if(this.m_MouseoverRangeGlowBitmap.bitmapData != null)
         {
            this.m_MouseoverRangeGlowBitmap.bitmapData.dispose();
         }
         this.m_ScrollingCanvas.removeChild(this.m_MouseoverRangeGlowBitmap);
         this.m_ScrollingCanvas.removeChild(this.m_MouseoverRangeLayer);
         this.m_ScrollingCanvas.removeChild(this.m_MouseoverRangeAlphaLayer);
         this.m_ScrollingCanvas.removeChild(this.m_RangeGlowLayer);
         if(this.m_RangeGlowBitmap.bitmapData != null)
         {
            this.m_RangeGlowBitmap.bitmapData.dispose();
         }
         this.m_ScrollingCanvas.removeChild(this.m_RangeGlowBitmap);
         this.m_ScrollingCanvas.removeChild(this.m_RangeLayer);
         this.m_ScrollingCanvas.removeChild(this.m_RangeAlphaLayer);
         this.m_ScrollingCanvas.removeChild(this.m_BaseLayer);
         removeChild(this.m_ScrollingCanvas);
         this.m_BackgroundImage = null;
         this.m_ScrollingCanvas = null;
         this.m_BaseLayer = null;
         this.m_MouseoverRangeAlphaLayer = null;
         this.m_MouseoverRangeLayer = null;
         this.m_MouseoverRangeGlowLayer = null;
         this.m_MouseoverRangeGlowBitmap = null;
         this.m_RangeAlphaLayer = null;
         this.m_RangeLayer = null;
         this.m_RangeGlowLayer = null;
         this.m_RangeGlowBitmap = null;
         this.m_CellOverlayLayer = null;
         this.m_TileLayer = null;
         this.m_InfoLayer = null;
         this.m_MapData = null;
      }
      
      public function NavigateToCell(param1:MapRoom3Cell) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Point = new Point(param1.cellX,param1.cellY);
         this.NavigateToIndex(_loc2_);
      }
      
      public function NavigateToIndex(param1:Point) : void
      {
         this.m_CenterPointForLoading.x = param1.x;
         this.m_CenterPointForLoading.y = param1.y;
         this.m_CenterPointForLoadingLocked = true;
         TweenLite.killTweensOf(this.m_ScrollingCanvas,true);
         var _loc2_:int = this.AdjustHorizontalBounds(this.m_ScrollingCanvas.x - (param1.x - this.m_CenterPoint.x) * (MapRoom3CellGraphic.HEX_WIDTH * this.m_ScrollingCanvas.scaleX));
         var _loc3_:int = this.AdjustVerticalBounds(this.m_ScrollingCanvas.y - (param1.y - this.m_CenterPoint.y) * (MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP * this.m_ScrollingCanvas.scaleY));
         TweenLite.to(this.m_ScrollingCanvas,1,{
            "x":_loc2_,
            "y":_loc3_,
            "ease":Quad.easeInOut,
            "onUpdate":this.UpdateMap,
            "onComplete":this.OnNavigationComplete
         });
         this.SetMousedoverCellGraphic(null);
         this.SetSelectedCellGraphic(null);
      }
      
      private function OnNavigationComplete() : void
      {
         this.m_CenterPointForLoadingLocked = false;
      }
      
      private function CenterOn(param1:Point) : void
      {
         this.m_ScrollingCanvas.x = this.AdjustHorizontalBounds(-(this.m_CenterPoint.x * MapRoom3CellGraphic.HEX_WIDTH + (!!(this.m_CenterPoint.y % 2) ? MapRoom3CellGraphic.HEX_WIDTH * 0.5 : 0)) + (GLOBAL.StageX + GLOBAL.StageWidth * 0.5) - MapRoom3CellGraphic.HEX_WIDTH * 0.5);
         this.m_ScrollingCanvas.y = this.AdjustVerticalBounds(-this.m_CenterPoint.y * MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP + (GLOBAL.StageY + GLOBAL.StageHeight * 0.5) - MapRoom3CellGraphic.HEX_HEIGHT * 0.5);
         this.UpdateMap(true);
      }
      
      private function GetBufferWidth() : int
      {
         return int(GLOBAL.StageWidth / (MapRoom3CellGraphic.HEX_WIDTH * this.m_ScrollingCanvas.scaleX)) + 5;
      }
      
      private function GetBufferHeight() : int
      {
         return int(GLOBAL.StageHeight / (MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP * this.m_ScrollingCanvas.scaleY)) + 4;
      }
      
      public function Refresh() : void
      {
         var _loc1_:MapRoom3Cell = null;
         var _loc2_:MapRoom3Cell = null;
         if(this.m_MousedoverCellGraphic != null)
         {
            _loc1_ = this.m_MousedoverCellGraphic.cell;
            this.SetMousedoverCellGraphic(null);
         }
         if(this.m_SelectedCellGraphic != null)
         {
            _loc2_ = this.m_SelectedCellGraphic.cell;
            this.SetSelectedCellGraphic(null);
         }
         this.UpdateMap(true);
         if(_loc2_ != null)
         {
            this.SetSelectedCellGraphic(_loc2_.cellGraphic);
         }
         else if(_loc1_ != null)
         {
            this.SetMousedoverCellGraphic(_loc1_.cellGraphic);
         }
      }
      
      private function UpdateMap(forceUpdate: Boolean = false) : void
      {
         this.AdjustCenterPoint();
         this.DrawBackground();
         this.DrawRangeAlphaLayer(this.m_RangeAlphaLayer);
         this.DrawRangeAlphaLayer(this.m_MouseoverRangeAlphaLayer);

         var bufferWidth:int = this.GetBufferWidth();
         var bufferHeight:int = this.GetBufferHeight();
         var totalBufferCells:int = bufferWidth * bufferHeight;

         var topLeftX:int = this.m_CenterPoint.x - int(bufferWidth * 0.5);
         var topLeftY:int = this.m_CenterPoint.y - int(bufferHeight * 0.5);

         var newTileBuffer:Vector.<MapRoom3CellGraphic> = new Vector.<MapRoom3CellGraphic>();
         var unusedTiles:Vector.<MapRoom3CellGraphic> = new Vector.<MapRoom3CellGraphic>();

         var _rangeGlowCount:int = this.m_RangeGlowLayer.numChildren;
         var _mouseoverGlowCount:int = this.m_MouseoverRangeGlowLayer.numChildren;

         var bufferIndex:int = 0;
         var bufferOffsetX:int = 0;
         var bufferOffsetY:int = 0;
         var mapX:int = 0;
         var mapY:int = 0;
         var cellIndex:int = 0;
         var attackRangeIndex:int = 0;
         var cell:MapRoom3Cell = null;
         var tileGraphic:MapRoom3CellGraphic = null;
         var attackRangeCells:Vector.<MapRoom3Cell> = null;
         var insertIndex:int = 0;
         var numChildren:int = 0;
         var midIndex:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;

         for each(tileGraphic in this.m_TileBuffer)
         {
            cell = tileGraphic.cell;
            bufferOffsetX = int(tileGraphic.x / MapRoom3CellGraphic.HEX_WIDTH) - topLeftX;
            bufferOffsetY = int(tileGraphic.y / MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP) - topLeftY;
            if(forceUpdate || bufferOffsetX < 0 || bufferOffsetY < 0 || bufferOffsetX >= bufferWidth || bufferOffsetY >= bufferHeight)
            {
               this.m_TileLayer.removeChild(tileGraphic);
               unusedTiles.push(tileGraphic);
               this.m_TileLookup[tileGraphic.cellIndex] = null;
               tileGraphic.x = 0;
               tileGraphic.y = 0;
            }
            else
            {
               newTileBuffer.push(tileGraphic);
            }
         }
         this.m_TileBuffer.length = 0;
         this.m_TileBuffer = newTileBuffer;
         bufferIndex = 0;
         while(bufferIndex < totalBufferCells)
         {
            bufferOffsetX = bufferIndex % bufferWidth;
            bufferOffsetY = int(bufferIndex / bufferWidth);
            mapX = bufferOffsetX + topLeftX;
            mapY = bufferOffsetY + topLeftY;
            cell = this.m_MapData.GetMapRoom3Cell(mapX,mapY);
            attackRangeCells = cell.inAttackRangeOfCells;
            attackRangeIndex = 0;
            while(cell != null)
            {
               if(cell.isBorder)
               {
                  cellIndex = (mapY + this.m_MapData.mapHeight) % this.m_MapData.mapHeight * this.m_MapData.mapWidth + (mapX + this.m_MapData.mapWidth) % this.m_MapData.mapWidth;
               }
               else
               {
                  cellIndex = cell.cellY * this.m_MapData.mapWidth + cell.cellX;
               }
               if(this.m_TileLookup[cellIndex] == null)
               {
                  if(unusedTiles.length > 0)
                  {
                     tileGraphic = unusedTiles.pop();
                  }
                  else
                  {
                     tileGraphic = new MapRoom3CellGraphic();
                     tileGraphic.addEventListener(MouseEvent.CLICK,this.OnCellGraphicClicked);
                     tileGraphic.addEventListener(MouseEvent.ROLL_OVER,this.OnCellGraphicRollOver);
                     tileGraphic.addEventListener(MouseEvent.ROLL_OUT,this.OnCellGraphicRollOut);
                  }
                  this.m_TileBuffer.push(tileGraphic);
                  tileGraphic.cellIndex = cellIndex;
                  this.m_TileLookup[cellIndex] = tileGraphic;
                  tileGraphic.x = mapX * MapRoom3CellGraphic.HEX_WIDTH + (!!(mapY % 2) ? MapRoom3CellGraphic.HEX_WIDTH * 0.5 : 0);
                  tileGraphic.y = mapY * MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP;
                  tileGraphic.setMapCell(cell);
                  insertIndex = 0;
                  numChildren = this.m_TileLayer.numChildren;
                  while(insertIndex < numChildren)
                  {
                     midIndex = (insertIndex + numChildren) * 0.5;
                     dx = tileGraphic.x - this.m_TileLayer.getChildAt(midIndex).x;
                     dy = tileGraphic.y - this.m_TileLayer.getChildAt(midIndex).y;
                     if(dy < 0 || dy == 0 && dx <= 0)
                     {
                        numChildren = midIndex;
                     }
                     else
                     {
                        insertIndex = midIndex + 1;
                     }
                  }
                  this.m_TileLayer.addChildAt(tileGraphic,insertIndex);
               }
               cell = null;
               if(attackRangeCells != null && attackRangeIndex < attackRangeCells.length)
               {
                  cell = attackRangeCells[attackRangeIndex++];
                  mapX = cell.cellX;
                  mapY = cell.cellY;
               }
            }
            bufferIndex++;
         }
         for each(tileGraphic in unusedTiles)
         {
            tileGraphic.removeEventListener(MouseEvent.CLICK,this.OnCellGraphicClicked);
            tileGraphic.removeEventListener(MouseEvent.ROLL_OVER,this.OnCellGraphicRollOver);
            tileGraphic.removeEventListener(MouseEvent.ROLL_OUT,this.OnCellGraphicRollOut);
            tileGraphic.Clear();
            tileGraphic = null;
         }
         unusedTiles.length = 0;
         if(this.m_RangeGlowLayer.numChildren != _rangeGlowCount || forceUpdate)
         {
            this.m_RangeGlowCacheDirty = true;
         }
         if(this.m_MouseoverRangeGlowLayer.numChildren != _mouseoverGlowCount || forceUpdate)
         {
            this.m_MouseoverRangeGlowCacheDirty = true;
         }
         if(!this.m_Dragging && !ArrowKeyState.ArrowKeyPressed)
         {
            this.FlushGlowCaches();
         }
      }
      
      private function OnCellGraphicClicked(param1:MouseEvent) : void
      {
         var _loc2_:MapRoom3CellGraphic = param1.currentTarget as MapRoom3CellGraphic;
         if(_loc2_ == null)
         {
            return;
         }
         if(!MapRoom3Tutorial.instance.isClickableCell(_loc2_.cell))
         {
            return;
         }
         this.SetSelectedCellGraphic(_loc2_);
      }
      
      private function OnCellGraphicRollOver(param1:MouseEvent) : void
      {
         var _loc2_:MapRoom3CellGraphic = param1.currentTarget as MapRoom3CellGraphic;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_ == this.m_SelectedCellGraphic)
         {
            return;
         }
         if(this.m_SelectedCellGraphic != null && _loc2_.cell == this.m_SelectedCellGraphic.cell)
         {
            return;
         }
         this.SetSelectedCellGraphic(null);
         this.SetMousedoverCellGraphic(_loc2_);
         MapRoom3.mapRoom3WindowHUD.DisplayCoordinatesOfCell(_loc2_.cell);
      }
      
      private function OnCellGraphicRollOut(param1:MouseEvent) : void
      {
         var _loc2_:MapRoom3CellGraphic = param1.currentTarget as MapRoom3CellGraphic;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_ != this.m_MousedoverCellGraphic)
         {
            return;
         }
         if(_loc2_ == this.m_SelectedCellGraphic)
         {
            return;
         }
         if(this.m_SelectedCellGraphic != null && _loc2_.cell == this.m_SelectedCellGraphic.cell)
         {
            return;
         }
         this.SetSelectedCellGraphic(null);
         this.SetMousedoverCellGraphic(null);
      }
      
      private function SetMousedoverCellGraphic(param1:MapRoom3CellGraphic) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.m_MousedoverCellGraphic == param1)
         {
            return;
         }
         this.m_MouseoverRangeGlowCacheDirty = true;
         if(this.m_MousedoverCellGraphic != null)
         {
            this.m_MouseoverInfo.Hide();
            this.m_MousedoverCellGraphic.mousedover = false;
            this.m_MousedoverCellGraphic = null;
         }
         if(param1 != null && param1.cell != null && param1.cell.DoesContainDisplayableBase())
         {
            this.m_MousedoverCellGraphic = param1;
            this.m_MousedoverCellGraphic.mousedover = true;
            if(param1.cell.DoesContainDisplayableBase())
            {
               _loc2_ = this.m_ScrollingCanvas.x + this.m_MousedoverCellGraphic.x * this.m_ScrollingCanvas.scaleX + MapRoom3CellGraphic.HEX_WIDTH * this.m_ScrollingCanvas.scaleX * 0.5;
               _loc3_ = this.m_ScrollingCanvas.y + this.m_MousedoverCellGraphic.y * this.m_ScrollingCanvas.scaleY + MapRoom3CellGraphic.HEX_HEIGHT * this.m_ScrollingCanvas.scaleY * 0.5;
               this.m_MouseoverInfo.Show(this.m_MousedoverCellGraphic.cell,_loc2_,_loc3_,false);
            }
         }
         this.FlushGlowCaches();
      }

      private function SetSelectedCellGraphic(param1:MapRoom3CellGraphic) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.m_SelectedCellGraphic == param1)
         {
            return;
         }
         if(this.m_SelectedCellGraphic != null)
         {
            this.m_MouseoverInfo.Hide();
            this.m_SelectedCellGraphic.selected = false;
            this.m_SelectedCellGraphic = null;
         }
         if(param1 != null && param1.cell != null && param1.cell.DoesContainDisplayableBase())
         {
            this.m_SelectedCellGraphic = param1;
            this.m_SelectedCellGraphic.selected = true;
            _loc2_ = this.m_ScrollingCanvas.x + this.m_SelectedCellGraphic.x * this.m_ScrollingCanvas.scaleX + MapRoom3CellGraphic.HEX_WIDTH * this.m_ScrollingCanvas.scaleX * 0.5;
            _loc3_ = this.m_ScrollingCanvas.y + this.m_SelectedCellGraphic.y * this.m_ScrollingCanvas.scaleY + MapRoom3CellGraphic.HEX_HEIGHT * this.m_ScrollingCanvas.scaleY * 0.5;
            this.m_MouseoverInfo.Show(this.m_SelectedCellGraphic.cell,_loc2_,_loc3_,true);
         }
      }
      
      internal function IsZoomedOut() : Boolean
      {
         return this.m_ScrollingCanvas.scaleX < 1;
      }
      
      internal function Zoom(param1:Number, param2:Number = 0) : void
      {
         if(this.m_ScrollingCanvas.scaleX == param1)
         {
            return;
         }
         if(param2 != 0)
         {
            TweenLite.to(this.m_ScrollingCanvas,param2,{
               "scaleX":param1,
               "ease":Quad.easeInOut,
               "onUpdate":this.OnZoomUpdate
            });
         }
         else
         {
            this.m_ScrollingCanvas.scaleX = param1;
            this.OnZoomUpdate();
         }
      }
      
      private function OnZoomUpdate() : void
      {
         var _loc1_:Number = this.m_ScrollingCanvas.scaleX / this.m_ScrollingCanvas.scaleY;
         var _loc2_:int = GLOBAL.StageX + GLOBAL.StageWidth * 0.5;
         var _loc3_:int = GLOBAL.StageY + GLOBAL.StageHeight * 0.5;
         this.m_ScrollingCanvas.x -= _loc2_;
         this.m_ScrollingCanvas.y -= _loc3_;
         this.m_ScrollingCanvas.scaleX = this.m_ScrollingCanvas.scaleX;
         this.m_ScrollingCanvas.scaleY = this.m_ScrollingCanvas.scaleX;
         this.m_ScrollingCanvas.x *= _loc1_;
         this.m_ScrollingCanvas.y *= _loc1_;
         this.m_ScrollingCanvas.x += _loc2_;
         this.m_ScrollingCanvas.y += _loc3_;
         this.RANGE_GLOW_FILTER.blurX = RANGE_GLOW_BLUR_X * this.m_ScrollingCanvas.scaleX;
         this.RANGE_GLOW_FILTER.blurY = RANGE_GLOW_BLUR_Y * this.m_ScrollingCanvas.scaleY;
         this.MOUSEOVER_RANGE_GLOW_FILTER.blurX = RANGE_GLOW_BLUR_X * this.m_ScrollingCanvas.scaleX;
         this.MOUSEOVER_RANGE_GLOW_FILTER.blurY = RANGE_GLOW_BLUR_Y * this.m_ScrollingCanvas.scaleY;
         this.m_RangeGlowCacheDirty = true;
         this.m_MouseoverRangeGlowCacheDirty = true;
         this.Resize();
      }
      
      public function Resize() : void
      {
         this.m_ScrollingCanvas.x = this.AdjustHorizontalBounds(this.m_ScrollingCanvas.x);
         this.m_ScrollingCanvas.y = this.AdjustVerticalBounds(this.m_ScrollingCanvas.y);
         this.AdjustCenterPoint();
         this.SetMousedoverCellGraphic(null);
         this.SetSelectedCellGraphic(null);
         this.UpdateMap(true);
      }
      
      private function AdjustHorizontalBounds(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = MapRoom3CellGraphic.HEX_WIDTH * this.m_ScrollingCanvas.scaleX;
         var _loc3_:int = GLOBAL.StageX + _loc2_ * 1.5;
         var _loc4_:int = GLOBAL.StageX + GLOBAL.StageWidth - this.m_MapData.mapWidth * _loc2_ - _loc2_ * 2;
         if(param1 > _loc3_)
         {
            param1 = _loc3_;
         }
         if(param1 < _loc4_)
         {
            param1 = _loc4_;
         }
         return param1;
      }
      
      private function AdjustVerticalBounds(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = MapRoom3CellGraphic.HEX_HEIGHT * this.m_ScrollingCanvas.scaleY;
         _loc3_ = MapRoom3CellGraphic.HEX_HEIGHT_OVERLAP * this.m_ScrollingCanvas.scaleY;
         var _loc4_:int = GLOBAL.StageY + _loc2_ * 2;
         var _loc5_:int = GLOBAL.StageY + GLOBAL.StageHeight - this.m_MapData.mapHeight * _loc3_ - _loc2_ * 3 + _loc3_;
         if(param1 > _loc4_)
         {
            param1 = _loc4_;
         }
         if(param1 < _loc5_)
         {
            param1 = _loc5_;
         }
         return param1;
      }
      
      /**
       * Flushes any dirty glow caches by re-rendering the glow filter
       * to a BitmapData snapshot. Only performs work when dirty flags are set.
       */
      private function FlushGlowCaches() : void {
         if (this.m_RangeGlowCacheDirty) {
            this.RenderGlowToCache(this.m_RangeGlowLayer, this.RANGE_GLOW_FILTER, this.m_RangeGlowBitmap);
            this.m_RangeGlowCacheDirty = false;
         }
         
         if (this.m_MouseoverRangeGlowCacheDirty) {
            this.RenderGlowToCache(this.m_MouseoverRangeGlowLayer, this.MOUSEOVER_RANGE_GLOW_FILTER, this.m_MouseoverRangeGlowBitmap);
            this.m_MouseoverRangeGlowCacheDirty = false;
         }
      }

      /**
       * Snapshots a glow layer's vector shapes into a flat BitmapData with the
       * GlowFilter baked in. The result is displayed via the output Bitmap,
       * avoiding Flash's per-frame filter re-rasterization.
       * 
       * TLDR: Take a hidden vector Sprite, render it to a bitmap, apply a glow, 
       * cache the result so we don’t recompute every frame.
       * 
       * @param glowLayer Hidden Sprite containing the range glow shapes
       * @param glowFilter The GlowFilter to bake into the snapshot
       * @param outputBitmap The Bitmap that displays the cached result
       */
      private function RenderGlowToCache(glowLayer:Sprite, glowFilter:GlowFilter, outputBitmap:Bitmap) : void {
         // Dispose previous cached bitmap
         if (outputBitmap.bitmapData != null) {
            outputBitmap.bitmapData.dispose();
            outputBitmap.bitmapData = null;
         }

         // Nothing to render
         if (glowLayer.numChildren == 0) return;

         // Temporarily show the hidden layer so getBounds/draw work
         glowLayer.visible = true;

         // Calculate the snapshot area with padding for the filter bleed
         var bounds:Rectangle = glowLayer.getBounds(glowLayer);
         var padding:Number = glowFilter.inner ? 2 : Math.max(glowFilter.blurX,glowFilter.blurY) * 2;
         
         bounds.inflate(padding,padding);

         var bmdWidth:int = Math.ceil(bounds.width);
         var bmdHeight:int = Math.ceil(bounds.height);

         // Skip if degenerate or exceeds Flash's BitmapData limits
         if (bmdWidth <= 0 || bmdHeight <= 0 || bmdWidth > k_MAX_FILTER_SIZE || bmdHeight > k_MAX_FILTER_SIZE) {
            glowLayer.visible = false;
            return;
         }

         // Render the vector shapes to a BitmapData
         var sourceBmd:BitmapData = new BitmapData(bmdWidth, bmdHeight, true, 0);

         this.m_GlowCacheMatrix.identity();
         this.m_GlowCacheMatrix.translate(-bounds.x, -bounds.y);
         sourceBmd.draw(glowLayer, this.m_GlowCacheMatrix);
         glowLayer.visible = false;

         // Apply the GlowFilter onto a fresh BitmapData, then discard the source
         var filteredBmd:BitmapData = new BitmapData(bmdWidth, bmdHeight, true, 0);
         filteredBmd.applyFilter(sourceBmd, sourceBmd.rect, this.m_GlowCachePoint, glowFilter);
         sourceBmd.dispose();

         // Display the result
         outputBitmap.bitmapData = filteredBmd;
         outputBitmap.x = bounds.x;
         outputBitmap.y = bounds.y;
      }

      private function DrawBackground() : void
      {
         if(this.m_BackgroundImage == null)
         {
            return;
         }
         var _loc1_:Matrix = new Matrix();
         _loc1_.translate(this.m_ScrollingCanvas.x / this.m_ScrollingCanvas.scaleX % this.m_BackgroundImage.width,this.m_ScrollingCanvas.y / this.m_ScrollingCanvas.scaleY % this.m_BackgroundImage.height);
         _loc1_.scale(this.m_ScrollingCanvas.scaleX,this.m_ScrollingCanvas.scaleY);
         graphics.clear();
         graphics.beginBitmapFill(this.m_BackgroundImage,_loc1_,true);
         graphics.drawRect(GLOBAL.StageX,GLOBAL.StageY,GLOBAL.StageWidth,GLOBAL.StageHeight);
         graphics.endFill();
      }
      
      private function DrawRangeAlphaLayer(param1:Sprite) : void
      {
         param1.graphics.clear();
         param1.graphics.beginFill(16777215,RANGE_LAYER_ALPHA);
         param1.graphics.drawRect((GLOBAL.StageX - this.m_ScrollingCanvas.x) / this.m_ScrollingCanvas.scaleX,(GLOBAL.StageY - this.m_ScrollingCanvas.y) / this.m_ScrollingCanvas.scaleY,GLOBAL.StageWidth / this.m_ScrollingCanvas.scaleX,GLOBAL.StageHeight / this.m_ScrollingCanvas.scaleY);
         param1.graphics.endFill();
      }
   }
}

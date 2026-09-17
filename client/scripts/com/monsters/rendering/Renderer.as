package com.monsters.rendering
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   use namespace renderer_friend;
   
   public class Renderer
   {
      
      renderer_friend static var _debug:Boolean;
      
      private static var _debugShape:Shape;
       
      
      renderer_friend var _canvas:BitmapData;
      
      renderer_friend var _viewRect:Rectangle;
      
      private const _matrix:Matrix = new Matrix();
      
      private const _pt:Point = new Point();
      
      private const _bm:Bitmap = new Bitmap();

      private const _drawBounds:Rectangle = new Rectangle();
      
      private var _curCopyIndex:uint;
      
      private var _curDrawIndex:uint;
      
      public function Renderer(param1:BitmapData, param2:Rectangle)
      {
         super();
         this.renderer_friend::_canvas = param1;
         this.renderer_friend::_viewRect = param2;
      }
      
      public static function get debug() : Boolean
      {
         return renderer_friend::_debug;
      }
      
      public static function set debug(param1:Boolean) : void
      {
         renderer_friend::_debug = param1;
         if(renderer_friend::_debug)
         {
            _debugShape = _debugShape || new Shape();
            RasterData.renderer_friend::showDebug();
         }
         else
         {
            _debugShape = null;
            RasterData.renderer_friend::hideDebug();
         }
      }
      
      public function set canvas(param1:BitmapData) : void
      {
         this.renderer_friend::_canvas = param1;
      }
      
      public function render() : void
      {
         var _loc1_:Vector.<RasterData> = RasterData.renderer_friend::s_visibleData;
         this._curCopyIndex = this._curDrawIndex = 0;
         if(RasterData.renderer_friend::s_needsSort)
         {
            _loc1_.sort(this.sortRasterData);
            RasterData.renderer_friend::s_needsSort = false;
         }
         this.renderer_friend::_canvas.lock();
         this.rasterize(RasterData.renderer_friend::s_unsortedData.concat(_loc1_));
         this.renderer_friend::_canvas.unlock();
      }
      
      private function cull(param1:Vector.<RasterData>) : void
      {
         var _loc3_:RasterData = null;
         var _loc4_:Rectangle = null;
         var _loc2_:Vector.<RasterData> = param1;
         for each(_loc3_ in _loc2_)
         {
            (_loc4_ = _loc3_.renderer_friend::_rect).x = _loc3_.renderer_friend::_pt.x;
            _loc4_.y = _loc3_.renderer_friend::_pt.y;
            if(this.renderer_friend::_viewRect.intersects(_loc4_))
            {
               _loc2_[_loc2_.length] = _loc3_;
            }
            else {
                _debugShape = null;
                RasterData.renderer_friend::hideDebug();
            }
        }

        public function set canvas(param1:BitmapData):void {
            this.renderer_friend::_canvas = param1;
        }

        public function render():void {
            var _loc1_:Vector.<RasterData> = RasterData.renderer_friend::s_visibleData;
            this._curCopyIndex = this._curDrawIndex = 0;
            if (RasterData.renderer_friend::s_needsSort) {
                _loc1_.sort(this.sortRasterData);
                RasterData.renderer_friend::s_needsSort = false;
            }
            this.renderer_friend::_canvas.lock();
            this.rasterize(RasterData.renderer_friend::s_unsortedData.concat(_loc1_));
            this.renderer_friend::_canvas.unlock();
        }

        private function cull(param1:Vector.<RasterData>):void {
            var _loc3_:RasterData = null;
            var _loc4_:Rectangle = null;
            var _loc2_:Vector.<RasterData> = param1;
            for each (_loc3_ in _loc2_) {
                (_loc4_ = _loc3_.renderer_friend::_rect).x = _loc3_.renderer_friend::_pt.x;
                _loc4_.y = _loc3_.renderer_friend::_pt.y;
                if (this.renderer_friend::_viewRect.intersects(_loc4_)) {
                    _loc2_[_loc2_.length] = _loc3_;
                }
            }
            else
            {
               this._matrix.createBox(entry.renderer_friend::_scaleX * 0.01,entry.renderer_friend::_scaleY * 0.01,0,this._pt.x,this._pt.y);
               if(Boolean(entry.renderer_friend::_filter) && Boolean(entryBmd))
               {
                  this._bm.bitmapData = entryBmd;
                  this._bm.filters = [entry.renderer_friend::_filter];
                  this.renderer_friend::_canvas.draw(this._bm,this._matrix,null,entry.renderer_friend::_blendMode);
               }
               else
               {
                  if(entryBmd)
                  {
                     var right:Number = this._pt.x + entryBmd.width * this._matrix.a;
                     var bottom:Number = this._pt.y + entryBmd.height * this._matrix.d;
                     this._drawBounds.x = Math.floor(Math.min(this._pt.x,right)) - 1;
                     this._drawBounds.y = Math.floor(Math.min(this._pt.y,bottom)) - 1;
                     this._drawBounds.width = Math.ceil(Math.max(this._pt.x,right)) + 1 - this._drawBounds.x;
                     this._drawBounds.height = Math.ceil(Math.max(this._pt.y,bottom)) + 1 - this._drawBounds.y;
                     this.renderer_friend::_canvas.draw(entryBmd,this._matrix,null,entry.renderer_friend::_blendMode,this._drawBounds);
                  }
                  else
                  {
                     this.renderer_friend::_canvas.draw(entry.renderer_friend::_data,this._matrix,null,entry.renderer_friend::_blendMode);
                  }
               }
            }
        }
    }
}

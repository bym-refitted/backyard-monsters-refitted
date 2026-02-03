package com.monsters.rendering
{
   import com.monsters.utils.ObjectPool;
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
         }
      }
      
      private function sortRasterData(param1:RasterData, param2:RasterData) : Number
      {
         return param1.renderer_friend::_depth - param2.renderer_friend::_depth;
      }
      
      private function rasterize(param1:Vector.<RasterData>) : void
      {
         var _loc2_:Vector.<RasterData> = null;
         var _loc4_:RasterData = null;
         var _loc5_:BitmapData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         _loc2_ = param1;
         var _loc3_:int = int(_loc2_.length);
         while(_loc7_ < _loc3_)
         {
            _loc5_ = (_loc4_ = _loc2_[_loc7_]).renderer_friend::_data as BitmapData;
            this._pt.x = _loc4_.renderer_friend::_pt.x;
            this._pt.y = _loc4_.renderer_friend::_pt.y;
            if(_loc5_ && !_loc4_.renderer_friend::_blendMode && !_loc4_.renderer_friend::_filter && (_loc4_.renderer_friend::_scaleX & _loc4_.renderer_friend::_scaleY) === 100)
            {
               if(_loc4_.renderer_friend::_alpha !== 4278190080)
               {
                  // Use pooled BitmapData instead of creating new one each frame
                  _loc6_ = ObjectPool.getBitmapData(_loc5_.width, _loc5_.height, true, _loc4_.renderer_friend::_alpha);
               }
               this.renderer_friend::_canvas.copyPixels(_loc5_,_loc5_.rect,this._pt,_loc6_);
               if(_loc6_)
               {
                  // Return to pool instead of disposing
                  ObjectPool.returnBitmapData(_loc6_);
                  _loc6_ = null;
               }
            }
            else
            {
               this._matrix.createBox(_loc4_.renderer_friend::_scaleX * 0.01,_loc4_.renderer_friend::_scaleY * 0.01,0,this._pt.x,this._pt.y);
               if(Boolean(_loc4_.renderer_friend::_filter) && Boolean(_loc5_))
               {
                  this._bm.bitmapData = _loc5_;
                  this._bm.filters = [_loc4_.renderer_friend::_filter];
                  this.renderer_friend::_canvas.draw(this._bm,this._matrix,null,_loc4_.renderer_friend::_blendMode);
               }
               else
               {
                  this.renderer_friend::_canvas.draw(_loc4_.renderer_friend::_data,this._matrix,null,_loc4_.renderer_friend::_blendMode);
               }
            }
            _loc7_++;
         }
      }
   }
}

package com.monsters.rendering
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Renderer
   {
      
      internal static var _debug:Boolean;
      
      private static var _debugShape:Shape;
       
      
      internal var _canvas:BitmapData;
      
      internal var _viewRect:Rectangle;
      
      private const _matrix:Matrix = new Matrix();
      
      private const _pt:Point = new Point();
      
      private const _bm:Bitmap = new Bitmap();
      
      private var _curCopyIndex:uint;
      
      private var _curDrawIndex:uint;
      
      public function Renderer(param1:BitmapData, param2:Rectangle)
      {
         super();
         this._canvas = param1;
         this._viewRect = param2;
      }
      
      public static function get debug() : Boolean
      {
         return _debug;
      }
      
      public static function set debug(param1:Boolean) : void
      {
         _debug = param1;
         if(_debug)
         {
            _debugShape = _debugShape || new Shape();
            RasterData.showDebug();
         }
         else
         {
            _debugShape = null;
            RasterData.hideDebug();
         }
      }
      
      public function set canvas(param1:BitmapData) : void
      {
         this._canvas = param1;
      }
      
      public function render() : void
      {
         var _loc1_:Vector.<RasterData> = RasterData.s_visibleData;
         this._curCopyIndex = this._curDrawIndex = 0;
         if(RasterData.s_needsSort)
         {
            _loc1_.sort(this.sortRasterData);
            RasterData.s_needsSort = false;
         }
         this._canvas.lock();
         this.rasterize(RasterData.s_unsortedData.concat(_loc1_));
         this._canvas.unlock();
      }
      
      private function cull(param1:Vector.<RasterData>) : void
      {
         var _loc3_:RasterData = null;
         var _loc4_:Rectangle = null;
         var _loc2_:Vector.<RasterData> = param1;
         for each(_loc3_ in _loc2_)
         {
            (_loc4_ = _loc3_._rect).x = _loc3_._pt.x;
            _loc4_.y = _loc3_._pt.y;
            if(this._viewRect.intersects(_loc4_))
            {
               _loc2_[_loc2_.length] = _loc3_;
            }
         }
      }
      
      private function sortRasterData(param1:RasterData, param2:RasterData) : Number
      {
         return param1._depth - param2._depth;
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
            _loc5_ = (_loc4_ = _loc2_[_loc7_])._data as BitmapData;
            this._pt.x = _loc4_._pt.x;
            this._pt.y = _loc4_._pt.y;
            if(_loc5_ && !_loc4_._blendMode && !_loc4_._filter && (_loc4_._scaleX & _loc4_._scaleY) === 100)
            {
               if(_loc4_._alpha !== 4278190080)
               {
                  _loc6_ = new BitmapData(_loc5_.width,_loc5_.height,true,_loc4_._alpha);
               }
               this._canvas.copyPixels(_loc5_,_loc5_.rect,this._pt,_loc6_);
               if(_loc6_)
               {
                  _loc6_.dispose();
                  _loc6_ = null;
               }
            }
            else
            {
               this._matrix.createBox(_loc4_._scaleX * 0.01,_loc4_._scaleY * 0.01,0,this._pt.x,this._pt.y);
               if(Boolean(_loc4_._filter) && Boolean(_loc5_))
               {
                  this._bm.bitmapData = _loc5_;
                  this._bm.filters = [_loc4_._filter];
                  this._canvas.draw(this._bm,this._matrix,null,_loc4_._blendMode);
               }
               else
               {
                  this._canvas.draw(_loc4_._data,this._matrix,null,_loc4_._blendMode);
               }
            }
            _loc7_++;
         }
      }
   }
}

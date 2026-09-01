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
         try {
            this.rasterize(RasterData.s_unsortedData.concat(_loc1_));
         } catch(e:Error) {
            LOGGER.Log("error", "Renderer.render() error: " + e.message + " stack: " + e.getStackTrace());
         } finally {
            // Ensure the canvas is unlocked even if an error occurs
            this._canvas.unlock();
         }
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
         var entries:Vector.<RasterData> = null;
         var entry:RasterData = null;
         var entryBmd:BitmapData = null;
         var alphaMask:BitmapData = null;
         var i:int = 0;
         
         entries = param1;
         var len:int = int(entries.length);

         while(i < len)
         {
            entry = entries[i];
            if(!entry || entry._cleared || !entry._pt)
            {
               i++;
               continue;
            }
            entryBmd = entry._data as BitmapData;
            this._pt.x = entry._pt.x;
            this._pt.y = entry._pt.y;
            if(entryBmd && !entry._blendMode && !entry._filter && (entry._scaleX & entry._scaleY) === 100)
            {
               if(entry._alpha !== 0xFF000000)
               {
                  alphaMask = new BitmapData(entryBmd.width,entryBmd.height,true,entry._alpha);
               }
               this._canvas.copyPixels(entryBmd,entryBmd.rect,this._pt,alphaMask);
               if(alphaMask)
               {
                  alphaMask.dispose();
                  alphaMask = null;
               }
            }
            else
            {
               this._matrix.createBox(entry._scaleX * 0.01,entry._scaleY * 0.01,0,this._pt.x,this._pt.y);
               if(Boolean(entry._filter) && Boolean(entryBmd))
               {
                  this._bm.bitmapData = entryBmd;
                  this._bm.filters = [entry._filter];
                  this._canvas.draw(this._bm,this._matrix,null,entry._blendMode);
               }
               else
               {
                  this._canvas.draw(entry._data,this._matrix,null,entry._blendMode);
               }
            }
            i++;
         }
      }
   }
}

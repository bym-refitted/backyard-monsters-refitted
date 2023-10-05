package com.monsters.rendering
{
   import flash.display.BitmapData;
   import flash.display.IBitmapDrawable;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.filters.BitmapFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class RasterData
   {
      
      renderer_friend static const s_rasterData:Vector.<com.monsters.rendering.RasterData> = new Vector.<com.monsters.rendering.RasterData>();
      
      renderer_friend static const s_visibleData:Vector.<com.monsters.rendering.RasterData> = new Vector.<com.monsters.rendering.RasterData>();
      
      renderer_friend static const s_unsortedData:Vector.<com.monsters.rendering.RasterData> = new Vector.<com.monsters.rendering.RasterData>();
      
      renderer_friend static const s_debugData:Vector.<com.monsters.rendering.RasterData> = new Vector.<com.monsters.rendering.RasterData>();
      
      renderer_friend static var s_needsSort:Boolean;
      
      private static var s_id:uint;
       
      
      renderer_friend const _id:uint = s_id++;
      
      renderer_friend var _data:IBitmapDrawable;
      
      renderer_friend var _pt:Point;
      
      renderer_friend var _depth:Number;
      
      renderer_friend var _rect:Rectangle;
      
      renderer_friend var _blendMode:String;
      
      renderer_friend var _filter:BitmapFilter;
      
      renderer_friend var _scaleX:int;
      
      renderer_friend var _scaleY:int;
      
      renderer_friend var _alpha:uint;
      
      renderer_friend var _visible:Boolean;
      
      renderer_friend var _unSorted:Boolean;
      
      renderer_friend var _cleared:Boolean;
      
      public function RasterData(param1:IBitmapDrawable, param2:Point, param3:Number, param4:String = null, param5:Boolean = false)
      {
         super();
         this.data = param1;
         this.renderer_friend::_pt = param2;
         this.renderer_friend::_depth = param3;
         this.renderer_friend::_blendMode = param4;
         this.renderer_friend::_scaleX = this.renderer_friend::_scaleY = 100;
         this.renderer_friend::_alpha = 4278190080;
         this.renderer_friend::_visible = true;
         this.renderer_friend::_unSorted = param5;
         renderer_friend::s_needsSort = this.renderer_friend::_unSorted ? renderer_friend::s_needsSort : true;
         if(this.renderer_friend::_unSorted)
         {
            renderer_friend::s_rasterData[renderer_friend::s_rasterData.length] = this;
            renderer_friend::s_unsortedData[renderer_friend::s_unsortedData.length] = this;
         }
         else
         {
            renderer_friend::s_rasterData[renderer_friend::s_rasterData.length] = this;
            renderer_friend::s_visibleData[renderer_friend::s_visibleData.length] = this;
         }
      }
      
      public static function get rasterData() : Vector.<com.monsters.rendering.RasterData>
      {
         return renderer_friend::s_rasterData;
      }
      
      public static function get visibleData() : Vector.<com.monsters.rendering.RasterData>
      {
         return renderer_friend::s_visibleData;
      }
      
      public static function get totalMemory() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:com.monsters.rendering.RasterData = null;
         var _loc3_:BitmapData = null;
         for each(_loc2_ in renderer_friend::s_rasterData)
         {
            _loc3_ = _loc2_.renderer_friend::_data as BitmapData;
            if(_loc3_)
            {
               _loc1_ += _loc3_.getPixels(_loc3_.rect).length;
            }
         }
         return _loc1_;
      }
      
      renderer_friend static function showDebug() : void
      {
         var _loc1_:com.monsters.rendering.RasterData = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Shape = null;
         for each(_loc1_ in renderer_friend::s_rasterData)
         {
            _loc2_ = _loc1_.renderer_friend::_data as BitmapData;
            if(_loc2_)
            {
               _loc3_ = new Shape();
               _loc3_.graphics.lineStyle(1,16711680);
               _loc3_.graphics.beginFill(10027008,0.4);
               _loc3_.graphics.drawRect(0,0,_loc2_.width,_loc2_.height);
               renderer_friend::s_debugData[renderer_friend::s_debugData.length] = new com.monsters.rendering.RasterData(_loc3_,_loc1_.renderer_friend::_pt,_loc1_.renderer_friend::_depth);
            }
         }
      }
      
      renderer_friend static function hideDebug() : void
      {
         var _loc1_:com.monsters.rendering.RasterData = null;
         for each(_loc1_ in renderer_friend::s_debugData)
         {
            _loc1_.clear(true);
         }
         renderer_friend::s_debugData.length = 0;
      }
      
      public static function clear(param1:Boolean = false) : void
      {
         var _loc2_:com.monsters.rendering.RasterData = null;
         for each(_loc2_ in renderer_friend::s_rasterData)
         {
            _loc2_.clear(param1);
         }
         renderer_friend::s_unsortedData.length = renderer_friend::s_visibleData.length = renderer_friend::s_rasterData.length = renderer_friend::s_debugData.length = 0;
      }
      
      public function get id() : uint
      {
         return this.renderer_friend::_id;
      }
      
      public function get data() : IBitmapDrawable
      {
         return this.renderer_friend::_data;
      }
      
      public function set data(param1:IBitmapDrawable) : void
      {
         this.renderer_friend::_data = param1;
         switch(true)
         {
            case this.renderer_friend::_data is BitmapData:
               this.renderer_friend::_rect = (this.renderer_friend::_data as BitmapData).rect;
               break;
            case this.renderer_friend::_data is MovieClip:
               this.renderer_friend::_rect = (this.renderer_friend::_data as MovieClip).getRect(this.renderer_friend::_data as MovieClip);
               break;
            default:
               this.renderer_friend::_rect = new Rectangle();
         }
      }
      
      public function set pt(param1:Point) : void
      {
         this.renderer_friend::_pt = param1;
      }
      
      public function get rect() : Rectangle
      {
         return this.renderer_friend::_rect;
      }
      
      public function get depth() : Number
      {
         return this.renderer_friend::_depth;
      }
      
      public function set depth(param1:Number) : void
      {
         if(this.renderer_friend::_depth !== param1)
         {
            renderer_friend::s_needsSort = true;
            this.renderer_friend::_depth = param1;
         }
      }
      
      public function set blendMode(param1:String) : void
      {
         this.renderer_friend::_blendMode = param1;
      }
      
      public function set filter(param1:BitmapFilter) : void
      {
         this.renderer_friend::_filter = param1;
      }
      
      public function set scaleX(param1:Number) : void
      {
         this.renderer_friend::_scaleX = param1 * 100 >> 0;
      }
      
      public function set scaleY(param1:Number) : void
      {
         this.renderer_friend::_scaleY = param1 * 100 >> 0;
      }
      
      public function set alpha(param1:Number) : void
      {
         this.renderer_friend::_alpha = Math.ceil(param1 * 255) << 24;
      }
      
      public function get visible() : Boolean
      {
         return this.renderer_friend::_visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(!this.renderer_friend::_visible && param1)
         {
            if(this.renderer_friend::_unSorted)
            {
               renderer_friend::s_unsortedData[renderer_friend::s_unsortedData.length] = this;
            }
            else
            {
               renderer_friend::s_visibleData[renderer_friend::s_visibleData.length] = this;
            }
            renderer_friend::s_needsSort = true;
         }
         else if(this.renderer_friend::_visible && !param1)
         {
            if(this.renderer_friend::_unSorted)
            {
               renderer_friend::s_unsortedData.splice(renderer_friend::s_unsortedData.indexOf(this),1);
            }
            else
            {
               renderer_friend::s_visibleData.splice(renderer_friend::s_visibleData.indexOf(this),1);
            }
            renderer_friend::s_needsSort = true;
         }
         this.renderer_friend::_visible = param1;
      }
      
      public function clone() : com.monsters.rendering.RasterData
      {
         return new com.monsters.rendering.RasterData(this.renderer_friend::_data,this.renderer_friend::_pt,this.renderer_friend::_depth);
      }
      
      public function clear(param1:Boolean = false) : void
      {
         if(this.renderer_friend::_cleared)
         {
            return;
         }
         renderer_friend::s_rasterData.splice(renderer_friend::s_rasterData.indexOf(this),1);
         if(this.renderer_friend::_visible)
         {
            if(this.renderer_friend::_unSorted)
            {
               renderer_friend::s_unsortedData.splice(renderer_friend::s_unsortedData.indexOf(this),1);
            }
            else
            {
               renderer_friend::s_visibleData.splice(renderer_friend::s_visibleData.indexOf(this),1);
            }
         }
         if(param1 && this.renderer_friend::_data is BitmapData)
         {
            (this.renderer_friend::_data as BitmapData).dispose();
         }
         this.renderer_friend::_data = null;
         this.renderer_friend::_pt = null;
         this.renderer_friend::_rect = null;
         this.renderer_friend::_blendMode = null;
         this.renderer_friend::_cleared = true;
      }
   }
}

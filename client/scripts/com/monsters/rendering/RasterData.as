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
      
      internal static const s_rasterData:Vector.<RasterData> = new Vector.<RasterData>();
      
      internal static const s_visibleData:Vector.<RasterData> = new Vector.<RasterData>();
      
      internal static const s_unsortedData:Vector.<RasterData> = new Vector.<RasterData>();
      
      internal static const s_debugData:Vector.<RasterData> = new Vector.<RasterData>();
      
      internal static var s_needsSort:Boolean;
      
      private static var s_id:uint;
       
      
      internal const _id:uint = s_id++;
      
      internal var _data:IBitmapDrawable;
      
      internal var _pt:Point;
      
      internal var _depth:Number;
      
      internal var _rect:Rectangle;
      
      internal var _blendMode:String;
      
      internal var _filter:BitmapFilter;
      
      internal var _scaleX:int;
      
      internal var _scaleY:int;
      
      internal var _alpha:uint;
      
      internal var _visible:Boolean;
      
      internal var _unSorted:Boolean;
      
      internal var _cleared:Boolean;
      
      public function RasterData(data:IBitmapDrawable, pt:Point, depth:Number, blendMode:String = null, unSorted:Boolean = false)
      {
         super();
         this.data = data;
         this._pt = pt;
         this._depth = depth;
         this._blendMode = blendMode;
         this._scaleX = this._scaleY = 100;
         this._alpha = 4278190080;
         this._visible = true;
         this._unSorted = unSorted;
         s_needsSort = this._unSorted ? s_needsSort : true;
         if(this._unSorted)
         {
            s_rasterData[s_rasterData.length] = this;
            s_unsortedData[s_unsortedData.length] = this;
         }
         else
         {
            s_rasterData[s_rasterData.length] = this;
            s_visibleData[s_visibleData.length] = this;
         }
      }
      
      public static function get rasterData() : Vector.<RasterData>
      {
         return s_rasterData;
      }
      
      public static function get visibleData() : Vector.<RasterData>
      {
         return s_visibleData;
      }
      
      public static function get totalMemory() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:RasterData = null;
         var _loc3_:BitmapData = null;
         for each(_loc2_ in s_rasterData)
         {
            _loc3_ = _loc2_._data as BitmapData;
            if(_loc3_)
            {
               _loc1_ += _loc3_.getPixels(_loc3_.rect).length;
            }
         }
         return _loc1_;
      }
      
      internal static function showDebug() : void
      {
         var _loc1_:RasterData = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Shape = null;
         for each(_loc1_ in s_rasterData)
         {
            _loc2_ = _loc1_._data as BitmapData;
            if(_loc2_)
            {
               _loc3_ = new Shape();
               _loc3_.graphics.lineStyle(1,16711680);
               _loc3_.graphics.beginFill(10027008,0.4);
               _loc3_.graphics.drawRect(0,0,_loc2_.width,_loc2_.height);
               s_debugData[s_debugData.length] = new RasterData(_loc3_,_loc1_._pt,_loc1_._depth);
            }
         }
      }
      
      internal static function hideDebug() : void
      {
         var _loc1_:RasterData = null;
         for each(_loc1_ in s_debugData)
         {
            _loc1_.clear(true);
         }
         s_debugData.length = 0;
      }
      
      public static function clear(param1:Boolean = false) : void
      {
         var _loc2_:RasterData = null;
         for each(_loc2_ in s_rasterData)
         {
            _loc2_.clear(param1);
         }
         s_unsortedData.length = s_visibleData.length = s_rasterData.length = s_debugData.length = 0;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get data() : IBitmapDrawable
      {
         return this._data;
      }
      
      public function set data(newData:IBitmapDrawable) : void
      {
         this._data = newData;
         switch(true)
         {
            case this._data is BitmapData:
               this._rect = (this._data as BitmapData).rect;
               break;
            case this._data is MovieClip:
               this._rect = (this._data as MovieClip).getRect(this._data as MovieClip);
               break;
            default:
               this._rect = new Rectangle();
         }
      }
      
      public function set pt(newPt:Point) : void
      {
         this._pt = newPt;
      }
      
      public function get rect() : Rectangle
      {
         return this._rect;
      }
      
      public function get depth() : Number
      {
         return this._depth;
      }
      
      public function set depth(newDepth:Number) : void
      {
         if(this._depth !== newDepth)
         {
            s_needsSort = true;
            this._depth = newDepth;
         }
      }
      
      public function set blendMode(newBlendMode:String) : void
      {
         this._blendMode = newBlendMode;
      }
      
      public function set filter(newFilter:BitmapFilter) : void
      {
         this._filter = newFilter;
      }
      
      public function set scaleX(newScaleX:Number) : void
      {
         this._scaleX = newScaleX * 100 >> 0;
      }
      
      public function set scaleY(newScaleY:Number) : void
      {
         this._scaleY = newScaleY * 100 >> 0;
      }
      
      public function set alpha(newAlpha:Number) : void
      {
         this._alpha = Math.ceil(newAlpha * 255) << 24;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(newVisible:Boolean) : void
      {
         if(!this._visible && newVisible)
         {
            if(this._unSorted)
            {
               s_unsortedData[s_unsortedData.length] = this;
            }
            else
            {
               s_visibleData[s_visibleData.length] = this;
            }
            s_needsSort = true;
         }
         else if(this._visible && !newVisible)
         {
            if(this._unSorted)
            {
               s_unsortedData.splice(s_unsortedData.indexOf(this),1);
            }
            else
            {
               s_visibleData.splice(s_visibleData.indexOf(this),1);
            }
            s_needsSort = true;
         }
         this._visible = newVisible;
      }
      
      public function clone() : RasterData
      {
         return new RasterData(this._data,this._pt,this._depth);
      }
      
      public function clear(dispose:Boolean = false) : void
      {
         if(this._cleared)
         {
            return;
         }
         s_rasterData.splice(s_rasterData.indexOf(this),1);
         if(this._visible)
         {
            if(this._unSorted)
            {
               s_unsortedData.splice(s_unsortedData.indexOf(this),1);
            }
            else
            {
               s_visibleData.splice(s_visibleData.indexOf(this),1);
            }
         }
         if(dispose && this._data is BitmapData)
         {
            (this._data as BitmapData).dispose();
         }
         this._data = null;
         this._pt = null;
         this._rect = null;
         this._blendMode = null;
         this._cleared = true;
      }
   }
}

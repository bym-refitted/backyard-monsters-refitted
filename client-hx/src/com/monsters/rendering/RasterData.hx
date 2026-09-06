package com.monsters.rendering;

import openfl.display.BitmapData;
import openfl.display.IBitmapDrawable;
import openfl.display.MovieClip;
import openfl.display.Shape;
import openfl.filters.BitmapFilter;
import openfl.geom.Point;
import openfl.geom.Rectangle;

public class RasterData
{
   
   /* renderer_friend */ static final s_rasterData:Vector<RasterData> = new Vector<RasterData>();
   
   /* renderer_friend */ static final s_visibleData:Vector<RasterData> = new Vector<RasterData>();
   
   /* renderer_friend */ static final s_unsortedData:Vector<RasterData> = new Vector<RasterData>();
   
   /* renderer_friend */ static final s_debugData:Vector<RasterData> = new Vector<RasterData>();
   
   /* renderer_friend */ static var s_needsSort:Boolean;
   
   private static var s_id:UInt;
      
   
   /* renderer_friend */ final _id:UInt = s_id++;
   
   /* renderer_friend */ var _data:IBitmapDrawable;
   
   /* renderer_friend */ var _pt:Point;
   
   /* renderer_friend */ var _depth:Number;
   
   /* renderer_friend */ var _rect:Rectangle;
   
   /* renderer_friend */ var _blendMode:String;
   
   /* renderer_friend */ var _filter:BitmapFilter;
   
   /* renderer_friend */ var _scaleX:Int;
   
   /* renderer_friend */ var _scaleY:Int;
   
   /* renderer_friend */ var _alpha:UInt;
   
   /* renderer_friend */ var _visible:Boolean;
   
   /* renderer_friend */ var _unSorted:Boolean;
   
   /* renderer_friend */ var _cleared:Boolean;
   
   public function new(param1:IBitmapDrawable, param2:Point, param3:Number, param4:String = null, param5:Boolean = false)
   {
      super();
      this.data = param1;
      /* renderer_friend:: */ this._pt = param2;
      /* renderer_friend:: */ this._depth = param3;
      /* renderer_friend:: */ this._blendMode = param4;
      /* renderer_friend:: */ this._scaleX = /* renderer_friend:: */ this._scaleY = 100;
      /* renderer_friend:: */ this._alpha = 0xFF000000;
      /* renderer_friend:: */ this._visible = true;
      /* renderer_friend:: */ this._unSorted = param5;
      /* renderer_friend:: */ s_needsSort = /* renderer_friend:: */ this._unSorted ? /* renderer_friend:: */ s_needsSort : true;
      if(/* renderer_friend:: */ this._unSorted)
      {
         /* renderer_friend:: */ s_rasterData[/* renderer_friend:: */ s_rasterData.length] = this;
         /* renderer_friend:: */ s_unsortedData[/* renderer_friend:: */ s_unsortedData.length] = this;
      }
      else
      {
         /* renderer_friend:: */ s_rasterData[/* renderer_friend:: */ s_rasterData.length] = this;
         /* renderer_friend:: */ s_visibleData[/* renderer_friend:: */ s_visibleData.length] = this;
      }
   }
   
   public static function get rasterData() : Vector<RasterData>
   {
      return /* renderer_friend:: */ s_rasterData;
   }
   
   public static function get visibleData() : Vector<RasterData>
   {
      return /* renderer_friend:: */ s_visibleData;
   }
   
   public static function get totalMemory() : uint
   {
      var _loc1_:UInt = 0;
      var _loc2_:RasterData = null;
      var _loc3_:BitmapData = null;
      for each(_loc2_ in /* renderer_friend:: */ s_rasterData)
      {
         _loc3_ = _loc2_.renderer_friend::_data as BitmapData;
         if(_loc3_)
         {
            _loc1_ += _loc3_.getPixels(_loc3_.rect).length;
         }
      }
      return _loc1_;
   }
   
   /* renderer_friend */ static function showDebug() : void
   {
      var _loc1_:RasterData = null;
      var _loc2_:BitmapData = null;
      var _loc3_:Shape = null;
      for each(_loc1_ in /* renderer_friend:: */ s_rasterData)
      {
         _loc2_ = _loc1_.renderer_friend::_data as BitmapData;
         if(_loc2_)
         {
            _loc3_ = new Shape();
            _loc3_.graphics.lineStyle(1,16711680);
            _loc3_.graphics.beginFill(10027008,0.4);
            _loc3_.graphics.drawRect(0,0,_loc2_.width,_loc2_.height);
            /* renderer_friend:: */ s_debugData[/* renderer_friend:: */ s_debugData.length] = new RasterData(_loc3_,_loc1_.renderer_friend::_pt,_loc1_.renderer_friend::_depth);
         }
      }
   }
   
   /* renderer_friend */ static function hideDebug() : void
   {
      var _loc1_:RasterData = null;
      for each(_loc1_ in /* renderer_friend:: */ s_debugData)
      {
         _loc1_.clear(true);
      }
      /* renderer_friend:: */ s_debugData.length = 0;
   }
   
   public static function clearAll(param1:Boolean = false) : void
   {
      var _loc2_:RasterData = null;
      for each(_loc2_ in /* renderer_friend:: */ s_rasterData)
      {
         _loc2_.clear(param1);
      }
      /* renderer_friend:: */ s_unsortedData.length = /* renderer_friend:: */ s_visibleData.length = /* renderer_friend:: */ s_rasterData.length = /* renderer_friend:: */ s_debugData.length = 0;
   }
   
   public function get id() : uint
   {
      return /* renderer_friend:: */ this._id;
   }
   
   public function get data() : IBitmapDrawable
   {
      return /* renderer_friend:: */ this._data;
   }
   
   public function set data(param1:IBitmapDrawable) : void
   {
      /* renderer_friend:: */ this._data = param1;
      switch(true)
      {
         case /* renderer_friend:: */ this._data is BitmapData:
            /* renderer_friend:: */ this._rect = (/* renderer_friend:: */ this._data as BitmapData).rect;
            break;
         case /* renderer_friend:: */ this._data is MovieClip:
            /* renderer_friend:: */ this._rect = (/* renderer_friend:: */ this._data as MovieClip).getRect(/* renderer_friend:: */ this._data as MovieClip);
            break;
         default:
            /* renderer_friend:: */ this._rect = new Rectangle();
      }
   }
   
   public function set pt(param1:Point) : void
   {
      /* renderer_friend:: */ this._pt = param1;
   }
   
   public function get rect() : Rectangle
   {
      return /* renderer_friend:: */ this._rect;
   }
   
   public function get depth() : Number
   {
      return /* renderer_friend:: */ this._depth;
   }
   
   public function set depth(param1:Number) : void
   {
      if(/* renderer_friend:: */ this._depth !== param1)
      {
         /* renderer_friend:: */ s_needsSort = true;
         /* renderer_friend:: */ this._depth = param1;
      }
   }
   
   public function set blendMode(param1:String) : void
   {
      /* renderer_friend:: */ this._blendMode = param1;
   }
   
   public function set filter(param1:BitmapFilter) : void
   {
      /* renderer_friend:: */ this._filter = param1;
   }
   
   public function set scaleX(param1:Number) : void
   {
      /* renderer_friend:: */ this._scaleX = param1 * 100 >> 0;
   }
   
   public function set scaleY(param1:Number) : void
   {
      /* renderer_friend:: */ this._scaleY = param1 * 100 >> 0;
   }
   
   public function set alpha(param1:Number) : void
   {
      /* renderer_friend:: */ this._alpha = Math.ceil(param1 * 255) << 24;
   }
   
   public function get visible() : Boolean
   {
      return /* renderer_friend:: */ this._visible;
   }
   
   public function set visible(param1:Boolean) : void
   {
      if (/* renderer_friend:: */ this._cleared) return;

      var idx:Int = 0;
      
      if(/* renderer_friend:: */ !this._visible && param1)
      {
         if(/* renderer_friend:: */ this._unSorted)
         {
            /* renderer_friend:: */ s_unsortedData[/* renderer_friend:: */ s_unsortedData.length] = this;
         }
         else
         {
            /* renderer_friend:: */ s_visibleData[/* renderer_friend:: */ s_visibleData.length] = this;
         }
         /* renderer_friend:: */ s_needsSort = true;
      }
      else if(/* renderer_friend:: */ this._visible && !param1)
      {
         if(/* renderer_friend:: */ this._unSorted)
         {
            idx = /* renderer_friend:: */ s_unsortedData.indexOf(this);

            if(idx >= 0)
            {
               /* renderer_friend:: */ s_unsortedData.splice(idx,1);
            }
         }
         else
         {
            idx = /* renderer_friend:: */ s_visibleData.indexOf(this);

            if(idx >= 0)
            {
               /* renderer_friend:: */ s_visibleData.splice(idx,1);
            }
         }
         /* renderer_friend:: */ s_needsSort = true;
      }
      /* renderer_friend:: */ this._visible = param1;
   }
   
   public function clone() : RasterData
   {
      return new RasterData(/* renderer_friend:: */ this._data,/* renderer_friend:: */ this._pt,/* renderer_friend:: */ this._depth);
   }
   
   public function clear(param1:Boolean = false) : void
   {
      if(/* renderer_friend:: */ this._cleared)
      {
         return;
      }
      var idx:Int = /* renderer_friend:: */ s_rasterData.indexOf(this);

      if(idx >= 0)
      {
         /* renderer_friend:: */ s_rasterData.splice(idx,1);
      }
      if(/* renderer_friend:: */ this._visible)
      {
         if(/* renderer_friend:: */ this._unSorted)
         {
            idx = /* renderer_friend:: */ s_unsortedData.indexOf(this);

            if(idx >= 0)
            {
               /* renderer_friend:: */ s_unsortedData.splice(idx,1);
            }
         }
         else
         {
            idx = /* renderer_friend:: */ s_visibleData.indexOf(this);

            if(idx >= 0)
            {
               /* renderer_friend:: */ s_visibleData.splice(idx,1);
            }
         }
      }
      if(param1 && /* renderer_friend:: */ this._data is BitmapData)
      {
         (/* renderer_friend:: */ this._data as BitmapData).dispose();
      }
      /* renderer_friend:: */ this._data = null;
      /* renderer_friend:: */ this._pt = null;
      /* renderer_friend:: */ this._rect = null;
      /* renderer_friend:: */ this._blendMode = null;
      /* renderer_friend:: */ this._cleared = true;
   }
}

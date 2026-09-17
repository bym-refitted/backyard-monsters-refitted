package com.monsters.rendering
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;

   use namespace renderer_friend;

   internal class GroundRasterCache
   {
      private static const TILE:int = 256;
      private var bitmap:BitmapData;
      private var states:Dictionary = new Dictionary();
      private var dirty:Vector.<Boolean>;
      private var columns:int;
      private var rows:int;
      private var generation:uint;
      private const origin:Point = new Point();
      private const tile:Rectangle = new Rectangle();
      private const view:Rectangle = new Rectangle();
      private const batch:Vector.<RasterData> = new Vector.<RasterData>();

      public function dispose() : void
      {
         if(bitmap) bitmap.dispose();
         bitmap = null;
         states = new Dictionary();
         dirty = null;
         batch.length = 0;
      }

      public function render(entries:Vector.<RasterData>, renderer:Renderer, target:BitmapData, offset:Point) : int
      {
         var first:RasterData = entries.length ? entries[0] : null;
         var base:BitmapData = first ? first._data as BitmapData : null;
         if(!first || !base || base.transparent || !first.cacheable || first._cleared ||
            !first._pt || first._pt.x != 0 || first._pt.y != 0 || first._filter ||
            first._blendMode || first._alpha != 4278190080 || first._scaleX != 100 ||
            first._scaleY != 100 || offset.x < 0 || offset.y < 0 ||
            offset.x + target.width > base.width || offset.y + target.height > base.height)
         {
            dispose();
            return 0;
         }

         var count:int = 0;
         var entry:RasterData;
         var data:BitmapData;
         for each(entry in entries)
         {
            if(!entry || entry._cleared || !entry._pt || entry._filter) break;
            data = entry._data as BitmapData;
            if(!data && !(entry._data is DisplayObject)) break;
            if(data && !entry._blendMode && (entry._scaleX & entry._scaleY) === 100 &&
               (entry._pt.x != int(entry._pt.x) || entry._pt.y != int(entry._pt.y))) break;
            count++;
         }
         if(count < 2)
         {
            dispose();
            return 0;
         }
         if(!bitmap || bitmap.width != base.width || bitmap.height != base.height)
         {
            dispose();
            bitmap = new BitmapData(base.width,base.height,false,0);
            columns = Math.ceil(bitmap.width / TILE);
            rows = Math.ceil(bitmap.height / TILE);
            dirty = new Vector.<Boolean>(columns * rows,true);
            markAll();
         }

         ++generation;
         var i:int;
         var state:Object;
         var previousIndex:int = -1;
         var source:Rectangle;
         var right:Number;
         var bottom:Number;
         for(i = 0; i < count; i++)
         {
            entry = entries[i];
            state = states[entry];
            if(state && state.index < previousIndex) markAll();
            if(state) previousIndex = state.index;
            if(!entry.cacheable || !state || state.data !== entry._data || state.revision != entry._revision ||
               state.x != entry._pt.x || state.y != entry._pt.y || state.sx != entry._scaleX ||
               state.sy != entry._scaleY || state.alpha != entry._alpha || state.blend != entry._blendMode)
            {
               if(state) mark(state.bounds);
               data = entry._data as BitmapData;
               source = data ? data.rect : DisplayObject(entry._data).getBounds(DisplayObject(entry._data));
               var left:Number = entry._pt.x + source.x * entry._scaleX * 0.01;
               var top:Number = entry._pt.y + source.y * entry._scaleY * 0.01;
               right = left + source.width * entry._scaleX * 0.01;
               bottom = top + source.height * entry._scaleY * 0.01;
               var bounds:Rectangle = new Rectangle(Math.floor(Math.min(left,right)) - 2,
                  Math.floor(Math.min(top,bottom)) - 2,0,0);
               bounds.width = Math.ceil(Math.max(left,right)) + 2 - bounds.x;
               bounds.height = Math.ceil(Math.max(top,bottom)) + 2 - bounds.y;
               state = {data:entry._data,revision:entry._revision,x:entry._pt.x,y:entry._pt.y,
                  sx:entry._scaleX,sy:entry._scaleY,alpha:entry._alpha,blend:entry._blendMode,bounds:bounds};
               states[entry] = state;
               mark(bounds);
            }
            state.index = i;
            state.seen = generation;
         }
         for(var key:Object in states)
         {
            state = states[key];
            if(state.seen != generation)
            {
               mark(state.bounds);
               delete states[key];
            }
         }

         bitmap.lock();
         for(var index:int = 0; index < dirty.length; index++)
         {
            if(!dirty[index]) continue;
            tile.setTo(index % columns * TILE,int(index / columns) * TILE,TILE,TILE);
            tile.width = Math.min(TILE,bitmap.width - tile.x);
            tile.height = Math.min(TILE,bitmap.height - tile.y);
            batch.length = 0;
            for(i = 0; i < count; i++)
            {
               entry = entries[i];
               if(Rectangle(states[entry].bounds).intersects(tile)) batch.push(entry);
            }
            renderer.rasterize(batch,tile,0,bitmap);
            dirty[index] = false;
         }
         bitmap.unlock();
         view.setTo(offset.x,offset.y,target.width,target.height);
         target.copyPixels(bitmap,view,origin);
         return count;
      }

      private function markAll() : void
      {
         for(var i:int = 0; i < dirty.length; i++) dirty[i] = true;
      }

      private function mark(bounds:Rectangle) : void
      {
         var left:int = Math.max(0,Math.floor(bounds.x / TILE));
         var top:int = Math.max(0,Math.floor(bounds.y / TILE));
         var right:int = Math.min(columns - 1,Math.floor((bounds.right - 1) / TILE));
         var bottom:int = Math.min(rows - 1,Math.floor((bounds.bottom - 1) / TILE));
         for(var y:int = top; y <= bottom; y++)
            for(var x:int = left; x <= right; x++) dirty[y * columns + x] = true;
      }
   }
}

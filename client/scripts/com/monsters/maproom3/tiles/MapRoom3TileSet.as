package com.monsters.maproom3.tiles
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom3.MapRoom3Cell;

   internal class MapRoom3TileSet
   {

      private var m_TileSetInfo:Array;

      private var m_TileSetRanges:Array;

      private var m_URLLookup:Object;

      /*
       * Initializes the tile set for Map Room 3 based on altitude-based segmentation.
       *
       * The constructor takes in a tile set definition array, extracts unique altitude cutoffs
       * from the min/max altitudes of the tiles, organizes the tile set into altitude ranges,
       * and associates each range with the applicable tile indices. It also triggers the image
       * loading for the tiles and sets up lookup maps.
       *
       * @param tileSet An array of tile metadata objects, each containing:
       *                - min_alt: Minimum altitude for which this tile is used.
       *                - max_alt: Maximum altitude for which this tile is used.
       *                - src: The image source path for the tile.
       */
      public function MapRoom3TileSet(tileSet:Array)
      {
         super();

         var currentRange:MapRoom3TileSetRange = null;
         var heightCutoffs:Array = new Array();
         var tileImageSources:Array = new Array();
         var tileIndex:int = 0;
         var rangeIndex:int = 0;

         this.m_TileSetInfo = tileSet;
         this.m_TileSetRanges = new Array();
         this.m_URLLookup = new Object();

         tileIndex = 0;
         while (tileIndex < this.m_TileSetInfo.length)
         {
            if (heightCutoffs.indexOf(int(this.m_TileSetInfo[tileIndex].min_alt)) == -1)
            {
               heightCutoffs.push(int(this.m_TileSetInfo[tileIndex].min_alt));
            }
            if (heightCutoffs.indexOf(int(this.m_TileSetInfo[tileIndex].max_alt)) == -1)
            {
               heightCutoffs.push(int(this.m_TileSetInfo[tileIndex].max_alt));
            }
            tileImageSources.push(this.m_TileSetInfo[tileIndex].src);
            this.m_URLLookup[this.m_TileSetInfo[tileIndex].src] = tileIndex;
            tileIndex++;
         }
         heightCutoffs.sort(Array.NUMERIC);
         ImageCache.GetImageGroupWithCallBack("map_tiles", tileImageSources, this.OnImagesLoaded);
         tileIndex = 0;
         while (tileIndex < heightCutoffs.length - 1)
         {
            currentRange = new MapRoom3TileSetRange(heightCutoffs[tileIndex], heightCutoffs[tileIndex + 1]);
            this.m_TileSetRanges.push(currentRange);
            tileIndex++;
         }
         tileIndex = 0;
         while (tileIndex < this.m_TileSetInfo.length)
         {
            rangeIndex = 0;
            currentRange = this.m_TileSetRanges[rangeIndex];
            while (rangeIndex < this.m_TileSetRanges.length && currentRange.end <= this.m_TileSetInfo[tileIndex].min_alt)
            {
               rangeIndex++;
               currentRange = this.m_TileSetRanges[rangeIndex];
            }
            while (rangeIndex < this.m_TileSetRanges.length && currentRange.end <= this.m_TileSetInfo[tileIndex].max_alt)
            {
               currentRange.options.push(tileIndex);
               rangeIndex++;
               currentRange = this.m_TileSetRanges[rangeIndex];
            }
            tileIndex++;
         }
      }

      private function OnImagesLoaded(param1:Array, param2:String):void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while (_loc3_ < param1.length)
         {
            _loc4_ = int(this.m_URLLookup[param1[_loc3_][0]]);
            this.m_TileSetInfo[_loc4_].bmd = param1[_loc3_][1];
            _loc3_++;
         }
      }

      internal function GetTileToDrawForCell(param1:MapRoom3Cell, param2:int):Object
      {
         var _loc4_:MapRoom3TileSetRange = null;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc3_:Object = null;
         if (param1.cellHeight < this.m_TileSetRanges[0].start)
         {
            return _loc3_;
         }
         var _loc5_:int = 0;
         while (_loc5_ < this.m_TileSetRanges.length && this.m_TileSetRanges[_loc5_].end < param1.cellHeight)
         {
            _loc5_++;
         }
         if (_loc5_ < this.m_TileSetRanges.length)
         {
            _loc4_ = this.m_TileSetRanges[_loc5_];
            _loc6_ = param2;
            _loc6_ ^= _loc6_ << 21;
            _loc6_ ^= _loc6_ >>> 35;
            _loc6_ ^= _loc6_ << 4;
            _loc7_ = (_loc6_ = Math.abs(_loc6_)) % _loc4_.options.length;
            _loc7_ = int(_loc4_.options[_loc7_]);
            return this.m_TileSetInfo[_loc7_];
         }
         return _loc3_;
      }
   }
}

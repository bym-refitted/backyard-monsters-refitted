package com.monsters.maproom3.tiles
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom3.MapRoom3Cell;
   
   internal class MapRoom3TileSet
   {
       
      
      private var m_TileSetInfo:Array;
      
      private var m_TileSetRanges:Array;
      
      private var m_URLLookup:Object;
      
      public function MapRoom3TileSet(param1:Array)
      {
         var _loc2_:int = 0;
         var _loc5_:MapRoom3TileSetRange = null;
         var _loc6_:int = 0;
         super();
         this.m_TileSetInfo = param1;
         this.m_TileSetRanges = new Array();
         this.m_URLLookup = new Object();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.m_TileSetInfo.length)
         {
            if(_loc3_.indexOf(int(this.m_TileSetInfo[_loc2_].min_alt)) == -1)
            {
               _loc3_.push(int(this.m_TileSetInfo[_loc2_].min_alt));
            }
            if(_loc3_.indexOf(int(this.m_TileSetInfo[_loc2_].max_alt)) == -1)
            {
               _loc3_.push(int(this.m_TileSetInfo[_loc2_].max_alt));
            }
            _loc4_.push(this.m_TileSetInfo[_loc2_].src);
            this.m_URLLookup[this.m_TileSetInfo[_loc2_].src] = _loc2_;
            _loc2_++;
         }
         _loc3_.sort(Array.NUMERIC);
         ImageCache.GetImageGroupWithCallBack("map_tiles",_loc4_,this.OnImagesLoaded);
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length - 1)
         {
            _loc5_ = new MapRoom3TileSetRange(_loc3_[_loc2_],_loc3_[_loc2_ + 1]);
            this.m_TileSetRanges.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m_TileSetInfo.length)
         {
            _loc6_ = 0;
            _loc5_ = this.m_TileSetRanges[_loc6_];
            while(_loc6_ < this.m_TileSetRanges.length && _loc5_.end <= this.m_TileSetInfo[_loc2_].min_alt)
            {
               _loc6_++;
               _loc5_ = this.m_TileSetRanges[_loc6_];
            }
            while(_loc6_ < this.m_TileSetRanges.length && _loc5_.end <= this.m_TileSetInfo[_loc2_].max_alt)
            {
               _loc5_.options.push(_loc2_);
               _loc6_++;
               _loc5_ = this.m_TileSetRanges[_loc6_];
            }
            _loc2_++;
         }
      }
      
      private function OnImagesLoaded(param1:Array, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = int(this.m_URLLookup[param1[_loc3_][0]]);
            this.m_TileSetInfo[_loc4_].bmd = param1[_loc3_][1];
            _loc3_++;
         }
      }
      
      internal function GetTileToDrawForCell(param1:MapRoom3Cell, param2:int) : Object
      {
         var _loc4_:MapRoom3TileSetRange = null;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc3_:Object = null;
         if(param1.cellHeight < this.m_TileSetRanges[0].start)
         {
            return _loc3_;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.m_TileSetRanges.length && this.m_TileSetRanges[_loc5_].end < param1.cellHeight)
         {
            _loc5_++;
         }
         if(_loc5_ < this.m_TileSetRanges.length)
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

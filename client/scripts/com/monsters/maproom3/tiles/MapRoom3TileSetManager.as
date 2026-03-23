package com.monsters.maproom3.tiles
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom3.MapRoom3Cell;
   import config.singletonlock.SingletonLock;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class MapRoom3TileSetManager
   {
      
      private static var s_Instance:MapRoom3TileSetManager = null;
      
      public static const BLOCKED_CELL_STARTING_HEIGHT:int = 51;
      
      public static const BORDER_CELL_HEIGHT:int = 100;
      
      public static const DEFAULT_BACKGROUND:String = "worldmap/background.jpg";
      
      public static var DEFAULT_TILE_SET:Array = [{
         "src":"worldmap/tiles/clover01.png",
         "x":0,
         "y":0,
         "min_alt":32,
         "max_alt":35
      },{
         "src":"worldmap/tiles/clover02.png",
         "x":0,
         "y":0,
         "min_alt":35,
         "max_alt":38
      },{
         "src":"worldmap/tiles/clover03.png",
         "x":0,
         "y":0,
         "min_alt":38,
         "max_alt":41
      },{
         "src":"worldmap/tiles/clover04.png",
         "x":0,
         "y":0,
         "min_alt":41,
         "max_alt":44
      },{
         "src":"worldmap/tiles/clover05.png",
         "x":0,
         "y":0,
         "min_alt":44,
         "max_alt":47
      },{
         "src":"worldmap/tiles/clover06.png",
         "x":0,
         "y":0,
         "min_alt":47,
         "max_alt":50
      },{
         "src":"worldmap/tiles/brownplant01.png",
         "x":0,
         "y":0,
         "min_alt":50,
         "max_alt":52
      },{
         "src":"worldmap/tiles/brownplant02.png",
         "x":0,
         "y":0,
         "min_alt":52,
         "max_alt":54
      },{
         "src":"worldmap/tiles/brownplant03.png",
         "x":0,
         "y":0,
         "min_alt":54,
         "max_alt":56
      },{
         "src":"worldmap/tiles/brownplant04.png",
         "x":0,
         "y":0,
         "min_alt":56,
         "max_alt":58
      },{
         "src":"worldmap/tiles/brownplant05.png",
         "x":0,
         "y":0,
         "min_alt":58,
         "max_alt":60
      },{
         "src":"worldmap/tiles/greenplant01.png",
         "x":0,
         "y":0,
         "min_alt":60,
         "max_alt":62
      },{
         "src":"worldmap/tiles/greenplant02.png",
         "x":0,
         "y":0,
         "min_alt":62,
         "max_alt":64
      },{
         "src":"worldmap/tiles/greenplant03.png",
         "x":0,
         "y":0,
         "min_alt":64,
         "max_alt":66
      },{
         "src":"worldmap/tiles/greenplant04.png",
         "x":0,
         "y":0,
         "min_alt":66,
         "max_alt":68
      },{
         "src":"worldmap/tiles/greenplant05.png",
         "x":0,
         "y":0,
         "min_alt":68,
         "max_alt":70
      },{
         "src":"worldmap/tiles/spiky01.png",
         "x":0,
         "y":0,
         "min_alt":70,
         "max_alt":71
      },{
         "src":"worldmap/tiles/spiky02.png",
         "x":0,
         "y":0,
         "min_alt":71,
         "max_alt":72
      },{
         "src":"worldmap/tiles/spiky03.png",
         "x":0,
         "y":0,
         "min_alt":72,
         "max_alt":73
      },{
         "src":"worldmap/tiles/spiky04.png",
         "x":0,
         "y":0,
         "min_alt":73,
         "max_alt":75
      },{
         "src":"worldmap/tiles/spiky05.png",
         "x":0,
         "y":0,
         "min_alt":75,
         "max_alt":77
      },{
         "src":"worldmap/tiles/spiky06.png",
         "x":0,
         "y":0,
         "min_alt":77,
         "max_alt":79
      },{
         "src":"worldmap/tiles/spiky07.png",
         "x":0,
         "y":0,
         "min_alt":78,
         "max_alt":80
      },{
         "src":"worldmap/tiles/borderplant01.png",
         "x":0,
         "y":0,
         "min_alt":BORDER_CELL_HEIGHT - 1,
         "max_alt":BORDER_CELL_HEIGHT
      },{
         "src":"worldmap/tiles/borderplant02.png",
         "x":0,
         "y":0,
         "min_alt":BORDER_CELL_HEIGHT - 1,
         "max_alt":BORDER_CELL_HEIGHT
      },{
         "src":"worldmap/tiles/borderplant03.png",
         "x":0,
         "y":0,
         "min_alt":BORDER_CELL_HEIGHT - 1,
         "max_alt":BORDER_CELL_HEIGHT
      },{
         "src":"worldmap/tiles/borderplant04.png",
         "x":0,
         "y":0,
         "min_alt":BORDER_CELL_HEIGHT - 1,
         "max_alt":BORDER_CELL_HEIGHT
      },{
         "src":"worldmap/tiles/borderplant05.png",
         "x":0,
         "y":0,
         "min_alt":BORDER_CELL_HEIGHT - 1,
         "max_alt":BORDER_CELL_HEIGHT
      }];
      
      public static var INFERNO_TILE_SET:Array = [{
         "src":"worldmap/tiles/tests/lava.png",
         "x":0,
         "y":0,
         "min_alt":BORDER_CELL_HEIGHT - 1,
         "max_alt":BORDER_CELL_HEIGHT
      }];
       
      
      private var m_TileSetsInUse:Dictionary;
      
      private var m_CurrentTileSet:MapRoom3TileSet = null;
      
      private var m_CurrentBackground:BitmapData = null;
      
      public function MapRoom3TileSetManager(param1:SingletonLock)
      {
         this.m_TileSetsInUse = new Dictionary();
         super();
      }
      
      public static function get instance() : MapRoom3TileSetManager
      {
         return s_Instance = s_Instance || new MapRoom3TileSetManager(new SingletonLock());
      }
      
      public function get currentBackground() : BitmapData
      {
         return this.m_CurrentBackground;
      }
      
      public function get isCurrentTileSetAndBackgroundLoaded() : Boolean
      {
         return Boolean(this.m_CurrentTileSet) && Boolean(this.m_CurrentBackground);
      }
      
      public function SetCurrentTileSet(tileSet:Array, mapBg:String = "worldmap/background.jpg") : void
      {
         if(tileSet != DEFAULT_TILE_SET && tileSet != INFERNO_TILE_SET)
         {
            return;
         }
         if(this.m_TileSetsInUse[tileSet] == null)
         {
            this.m_CurrentTileSet = new MapRoom3TileSet(tileSet);
            this.m_TileSetsInUse[tileSet] = this.m_CurrentTileSet;
         }
         else
         {
            this.m_CurrentTileSet = this.m_TileSetsInUse[tileSet] as MapRoom3TileSet;
         }
         ImageCache.GetImageWithCallBack(mapBg,this.OnBackgroundImageLoaded,true,1);
      }
      
      private function OnBackgroundImageLoaded(param1:String, param2:BitmapData) : void
      {
         this.m_CurrentBackground = param2;
      }
      
      public function GetTileToDrawForCell(param1:MapRoom3Cell, param2:int) : Object
      {
         return !!this.m_CurrentTileSet ? this.m_CurrentTileSet.GetTileToDrawForCell(param1,param2) : null;
      }
   }
}

package com.monsters.maproom3
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.SpriteData;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class MapRoom3AssetCache
   {
      
      private static var s_Instance:com.monsters.maproom3.MapRoom3AssetCache = null;
      
      internal static const CELL_ICON_DAMAGE_PROTECTION:String = "worldmap/icons/damage_protection.png";
      
      internal static const CELL_ICON_PLAYER_BASE:String = "worldmap/icons/player_base.png";
      
      internal static const CELL_ICON_RESOURCE_CELL:String = "worldmap/icons/resource_cell.png";
      
      internal static const CELL_ICON_STRONGHOLD:String = "worldmap/icons/guard_tower.png";
      
      internal static const CELL_ICON_STRONGHOLD_BUFF_EFFECT_NEUTRAL:String = "worldmap/icons/guard_tower_buff_effect.v2.png";
      
      internal static const CELL_ICON_STRONGHOLD_BUFF_EFFECT_ENEMY:String = "worldmap/icons/guard_tower_buff_effect_enemy.v3.png";
      
      internal static const CELL_ICON_STRONGHOLD_BUFF_EFFECT_PLAYER:String = "worldmap/icons/guard_tower_buff_effect_player.v3.png";
      
      internal static const CELL_ICON_STRONGHOLD_BUFF_EFFECT_MIXED:String = "worldmap/icons/guard_tower_buff_effect_mixed.v3.png";
      
      internal static const CELL_ICON_WILD_MONSTER_BASE:String = "worldmap/icons/wild_monster_base_v2.png";
      
      internal static const CELL_ICON_HELLRAISER_EVENT_BASE:String = "worldmap/icons/hellraiser_event_base.png";
      
      internal static const CELL_ICON_HELLRAISER_EVENT_BASE_TILE:String = "worldmap/icons/hellraiser_event_base_tile.png";
      
      internal static const CELL_ICON_FORTIFICATION:String = "worldmap/icons/fortification_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_EAST:String = "worldmap/icons/fortification_east_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_WEST:String = "worldmap/icons/fortification_west_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_NORTH_EAST:String = "worldmap/icons/fortification_north_east_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_NORTH_WEST:String = "worldmap/icons/fortification_north_west_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_SOUTH_EAST:String = "worldmap/icons/fortification_south_east_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_SOUTH_WEST:String = "worldmap/icons/fortification_south_west_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_LIGHT_BLUE:String = "worldmap/icons/fortification_light_blue_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_LIGHT_GREEN:String = "worldmap/icons/fortification_light_green_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_LIGHT_RED:String = "worldmap/icons/fortification_light_red_v2.png";
      
      internal static const CELL_ICON_FORTIFICATION_LIGHT_YELLOW:String = "worldmap/icons/fortification_light_yellow_v2.png";
      
      internal static const CELL_ICON_FULLY_FORTIFIED_BACK:String = "worldmap/icons/fully_fortified_back.png";
      
      internal static const CELL_ICON_FULLY_FORTIFIED_FRONT:String = "worldmap/icons/fully_fortified_front.png";
      
      internal static const CELL_OVERLAY_GLOW_RED:String = "worldmap/overlays/glow_red.png";
      
      internal static const CELL_OVERLAY_GLOW_BLUE:String = "worldmap/overlays/glow_blue.png";
      
      internal static const CELL_OVERLAY_GLOW_GREEN:String = "worldmap/overlays/glow_green.png";
      
      internal static const CELL_OVERLAY_GLOW_YELLOW:String = "worldmap/overlays/glow_yellow.png";
      
      internal static const HUD_BOOKMARK_THUMBNAIL_RESOURCE:String = "worldmap/hud/bookmark_thumbnail_resource.png";
      
      internal static const HUD_BOOKMARK_THUMBNAIL_STRONGHOLD:String = "worldmap/hud/bookmark_thumbnail_stronghold.png";
      
      internal static const HUD_BUTTON_FULL_SCREEN:String = "worldmap/hud/options/button_full_screen.png";
      
      internal static const HUD_BUTTON_ZOOM_IN:String = "worldmap/hud/options/button_zoom_in.png";
      
      internal static const HUD_BUTTON_ZOOM_OUT:String = "worldmap/hud/options/button_zoom_out.png";
      
      internal static const HUD_BUTTONS_BAR_BACKGROUND:String = "worldmap/hud/buttons_background.png";
      
      internal static const HUD_COORDINATES_BACKGROUND:String = "worldmap/hud/coordinates_background.png";
      
      internal static const MOUSEOVER_BACKGROUND:String = "worldmap/rollover/background.png";
      
      internal static const MOUSEOVER_BUTTON_BACKGROUND:String = "worldmap/rollover/button_background.png";
      
      internal static const MOUSEOVER_BUTTON_ENTER:String = "worldmap/rollover/button_enter.png";
      
      internal static const MOUSEOVER_BUTTON_ENTER_ROLLOVER:String = "worldmap/rollover/button_enter_rollover.png";
      
      internal static const MOUSEOVER_BUTTON_SCOUT_ATTACK:String = "worldmap/rollover/button_scout_attack.png";
      
      internal static const MOUSEOVER_BUTTON_SCOUT_ATTACK_ROLLOVER:String = "worldmap/rollover/button_scout_attack_rollover.png";
      
      internal static const MOUSEOVER_BUTTON_BOOKMARK_ADD:String = "worldmap/rollover/button_bookmark_add.png";
      
      internal static const MOUSEOVER_BUTTON_BOOKMARK_ADD_ROLLOVER:String = "worldmap/rollover/button_bookmark_add_rollover.png";
      
      internal static const MOUSEOVER_BUTTON_BOOKMARK_REMOVE:String = "worldmap/rollover/button_bookmark_remove.png";
      
      internal static const MOUSEOVER_BUTTON_BOOKMARK_REMOVE_ROLLOVER:String = "worldmap/rollover/button_bookmark_remove_rollover.png";
      
      internal static const MOUSEOVER_BUTTON_SEND_MESSAGE:String = "worldmap/rollover/button_message.png";
      
      internal static const MOUSEOVER_BUTTON_SEND_MESSAGE_ROLLOVER:String = "worldmap/rollover/button_message_rollover.png";
      
      internal static const MOUSEOVER_BUTTON_INVITE_TO_ALLIANCE:String = "worldmap/rollover/button_alliance.png";
      
      internal static const MOUSEOVER_BUTTON_INVITE_TO_ALLIANCE_ROLLOVER:String = "worldmap/rollover/button_alliance_rollover.png";
      
      internal static const MOUSEOVER_BUTTON_REQUEST_TRUCE:String = "worldmap/rollover/button_truce.png";
      
      internal static const MOUSEOVER_BUTTON_REQUEST_TRUCE_ROLLOVER:String = "worldmap/rollover/button_truce_rollover.png";
      
      internal static const MOUSEOVER_ICON_TRUCE:String = "worldmap/rollover/icon_truce.png";
      
      private static const DAMAGE_BAR:String = "worldmap/cell_health_bar.png";
      
      private static const DAMAGE_BAR_WIDTH:uint = 41;
      
      private static const DAMAGE_BAR_TOTAL_HEIGHT:uint = 68;
      
      private static const DAMAGE_BAR_SEGMENT_HEIGHT:uint = 4;
      
      private static const DAMAGE_BAR_NUM_SEGMENTS:uint = DAMAGE_BAR_TOTAL_HEIGHT / DAMAGE_BAR_SEGMENT_HEIGHT;
      
      internal static const STRONGHOLD_BUFF_EFFECT_TOTAL_FRAMES:int = 40;
      
      internal static const STRONGHOLD_BUFF_EFFECT_OFFSET_Y:int = -20;
      
      private static const IMAGES_TO_LOAD:Array = [CELL_ICON_DAMAGE_PROTECTION,CELL_ICON_PLAYER_BASE,CELL_ICON_RESOURCE_CELL,CELL_ICON_STRONGHOLD,CELL_ICON_STRONGHOLD_BUFF_EFFECT_NEUTRAL,CELL_ICON_STRONGHOLD_BUFF_EFFECT_ENEMY,CELL_ICON_STRONGHOLD_BUFF_EFFECT_PLAYER,CELL_ICON_STRONGHOLD_BUFF_EFFECT_MIXED,CELL_ICON_WILD_MONSTER_BASE,CELL_ICON_HELLRAISER_EVENT_BASE,CELL_ICON_HELLRAISER_EVENT_BASE_TILE,CELL_ICON_FORTIFICATION,CELL_ICON_FORTIFICATION_EAST,CELL_ICON_FORTIFICATION_WEST,CELL_ICON_FORTIFICATION_NORTH_EAST,CELL_ICON_FORTIFICATION_NORTH_WEST,CELL_ICON_FORTIFICATION_SOUTH_EAST,CELL_ICON_FORTIFICATION_SOUTH_WEST,CELL_ICON_FORTIFICATION_LIGHT_BLUE,CELL_ICON_FORTIFICATION_LIGHT_GREEN,CELL_ICON_FORTIFICATION_LIGHT_RED,CELL_ICON_FORTIFICATION_LIGHT_YELLOW,CELL_ICON_FULLY_FORTIFIED_BACK,CELL_ICON_FULLY_FORTIFIED_FRONT,CELL_OVERLAY_GLOW_RED,CELL_OVERLAY_GLOW_BLUE,CELL_OVERLAY_GLOW_GREEN,CELL_OVERLAY_GLOW_YELLOW,HUD_BOOKMARK_THUMBNAIL_RESOURCE,HUD_BOOKMARK_THUMBNAIL_STRONGHOLD,HUD_BUTTON_FULL_SCREEN,HUD_BUTTON_ZOOM_IN,HUD_BUTTON_ZOOM_OUT,HUD_BUTTONS_BAR_BACKGROUND,HUD_COORDINATES_BACKGROUND,MOUSEOVER_BACKGROUND,MOUSEOVER_BUTTON_BACKGROUND,MOUSEOVER_BUTTON_ENTER,MOUSEOVER_BUTTON_ENTER_ROLLOVER,MOUSEOVER_BUTTON_SCOUT_ATTACK,MOUSEOVER_BUTTON_SCOUT_ATTACK_ROLLOVER,MOUSEOVER_BUTTON_BOOKMARK_ADD,MOUSEOVER_BUTTON_BOOKMARK_ADD_ROLLOVER,MOUSEOVER_BUTTON_BOOKMARK_REMOVE,MOUSEOVER_BUTTON_BOOKMARK_REMOVE_ROLLOVER,MOUSEOVER_BUTTON_SEND_MESSAGE,MOUSEOVER_BUTTON_SEND_MESSAGE_ROLLOVER,MOUSEOVER_BUTTON_INVITE_TO_ALLIANCE,MOUSEOVER_BUTTON_INVITE_TO_ALLIANCE_ROLLOVER,MOUSEOVER_BUTTON_REQUEST_TRUCE,MOUSEOVER_BUTTON_REQUEST_TRUCE_ROLLOVER,MOUSEOVER_ICON_TRUCE,DAMAGE_BAR];
       
      
      private var m_LoadedAssets:Dictionary = null;
      
      private var m_DamageBarSegments:Vector.<BitmapData> = null;
      
      private var m_StrongholdBuffEffectNeutralSpriteData:SpriteData = null;
      
      private var m_StrongholdBuffEffectEnemySpriteData:SpriteData = null;
      
      private var m_StrongholdBuffEffectPlayerSpriteData:SpriteData = null;
      
      private var m_StrongholdBuffEffectMixedSpriteData:SpriteData = null;
      
      private var m_AreAssetsLoaded:Boolean = false;
      
      public function MapRoom3AssetCache(param1:SingletonLock)
      {
         super();
      }
      
      public static function get instance() : com.monsters.maproom3.MapRoom3AssetCache
      {
         return s_Instance = s_Instance || new com.monsters.maproom3.MapRoom3AssetCache(new SingletonLock());
      }
      
      public function get areAssetsLoaded() : Boolean
      {
         return this.m_AreAssetsLoaded;
      }
      
      public function Load() : void
      {
         if(this.m_LoadedAssets != null)
         {
            return;
         }
         this.m_LoadedAssets = new Dictionary();
         ImageCache.GetImageGroupWithCallBack("map_room_3_assets",IMAGES_TO_LOAD,this.OnAssetsLoaded);
      }
      
      private function OnAssetsLoaded(param1:Array, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:BitmapData = null;
         var _loc5_:uint = param1.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = String(param1[_loc6_][0]);
            _loc4_ = param1[_loc6_][1];
            this.m_LoadedAssets[_loc3_] = _loc4_;
            _loc6_++;
         }
         this.CacheDamageBarSegments();
         this.m_AreAssetsLoaded = true;
      }
      
      private function CacheDamageBarSegments() : void
      {
         var _loc2_:BitmapData = null;
         var _loc1_:BitmapData = this.GetAsset(DAMAGE_BAR);
         if(_loc1_ == null)
         {
            return;
         }
         this.m_DamageBarSegments = new Vector.<BitmapData>(DAMAGE_BAR_NUM_SEGMENTS);
         var _loc3_:Rectangle = new Rectangle(0,0,DAMAGE_BAR_WIDTH,DAMAGE_BAR_SEGMENT_HEIGHT);
         var _loc4_:Point = new Point();
         var _loc5_:uint = 0;
         while(_loc5_ < DAMAGE_BAR_NUM_SEGMENTS)
         {
            _loc2_ = new BitmapData(DAMAGE_BAR_WIDTH,DAMAGE_BAR_SEGMENT_HEIGHT,false);
            _loc2_.copyPixels(_loc1_,_loc3_,_loc4_);
            _loc3_.y += DAMAGE_BAR_SEGMENT_HEIGHT;
            this.m_DamageBarSegments[_loc5_] = _loc2_;
            _loc5_++;
         }
      }
      
      internal function GetAsset(param1:String) : BitmapData
      {
         return this.m_LoadedAssets[param1] as BitmapData;
      }
      
      internal function GetStrongholdBuffEffectNeutral() : SpriteData
      {
         if(this.m_StrongholdBuffEffectNeutralSpriteData == null)
         {
            this.m_StrongholdBuffEffectNeutralSpriteData = this.CreateStrongholdBuffEffect(CELL_ICON_STRONGHOLD_BUFF_EFFECT_NEUTRAL);
         }
         return this.m_StrongholdBuffEffectNeutralSpriteData;
      }
      
      internal function GetStrongholdBuffEffectEnemy() : SpriteData
      {
         if(this.m_StrongholdBuffEffectEnemySpriteData == null)
         {
            this.m_StrongholdBuffEffectEnemySpriteData = this.CreateStrongholdBuffEffect(CELL_ICON_STRONGHOLD_BUFF_EFFECT_ENEMY);
         }
         return this.m_StrongholdBuffEffectEnemySpriteData;
      }
      
      internal function GetStrongholdBuffEffectPlayer() : SpriteData
      {
         if(this.m_StrongholdBuffEffectPlayerSpriteData == null)
         {
            this.m_StrongholdBuffEffectPlayerSpriteData = this.CreateStrongholdBuffEffect(CELL_ICON_STRONGHOLD_BUFF_EFFECT_PLAYER);
         }
         return this.m_StrongholdBuffEffectPlayerSpriteData;
      }
      
      internal function GetStrongholdBuffEffectMixed() : SpriteData
      {
         if(this.m_StrongholdBuffEffectMixedSpriteData == null)
         {
            this.m_StrongholdBuffEffectMixedSpriteData = this.CreateStrongholdBuffEffect(CELL_ICON_STRONGHOLD_BUFF_EFFECT_MIXED);
         }
         return this.m_StrongholdBuffEffectMixedSpriteData;
      }
      
      internal function CreateStrongholdBuffEffect(param1:String) : SpriteData
      {
         var _loc2_:BitmapData = null;
         _loc2_ = this.GetAsset(param1);
         var _loc3_:int = _loc2_.width / STRONGHOLD_BUFF_EFFECT_TOTAL_FRAMES;
         var _loc4_:int = _loc2_.height;
         var _loc5_:int = SpriteData.FUBAR_X;
         var _loc6_:int = SpriteData.FUBAR_Y;
         var _loc7_:SpriteData;
         (_loc7_ = new SpriteData(param1,_loc3_,_loc4_,_loc5_,_loc6_)).image = _loc2_;
         return _loc7_;
      }
      
      public function GetDamageBarSegmentAsset(param1:Number) : BitmapData
      {
         if(this.m_DamageBarSegments == null || this.m_DamageBarSegments.length == 0)
         {
            return null;
         }
         param1 = Math.min(Math.max(0,param1),0.99);
         var _loc2_:int = Math.min(Math.floor(DAMAGE_BAR_NUM_SEGMENTS * param1),this.m_DamageBarSegments.length - 1);
         return this.m_DamageBarSegments[_loc2_];
      }
   }
}

class SingletonLock
{
    
   
   public function SingletonLock()
   {
      super();
   }
}

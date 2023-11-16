package com.monsters.maproom3.bookmarks
{
   import com.brokenfunction.json.encodeJson;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.MapRoom3Cell;
   import com.monsters.maproom3.data.MapRoom3Data;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.IOErrorEvent;
   
   public class BookmarksManager
   {
      
      private static var s_Instance:BookmarksManager = null;
      
      private static const BOOKMARKS_VERSION_SAVE_DATA_VALUE:String = "mr3";
      
      private static const BOOKMARKS_VERSION_SAVE_DATA_FIELD:String = "v";
      
      private static const BOOKMARKS_CUSTOM_SAVE_DATA_FIELD:String = "c";
      
      private static const BOOKMARKS_ENEMIES_SAVE_DATA_FIELD:String = "e";
      
      private static const BOOKMARKS_FRIENDS_SAVE_DATA_FIELD:String = "f";
      
      private static const MAX_AUTO_BOOKMARKS:int = 16000;
      
      private static const MAX_CUSTOM_BOOKMARKS:int = 50;
      
      public static const TYPE_CUSTOM:int = 0;
      
      public static const TYPE_ENEMIES:int = 1;
      
      public static const TYPE_FRIENDS:int = 2;
      
      public static const TYPE_PLAYER_RESOURCES:int = 3;
      
      public static const TYPE_PLAYER_STRONGHOLDS:int = 4;
       
      
      private var m_CustomBookmarks:Vector.<Bookmark>;
      
      private var m_EnemyBookmarks:Vector.<Bookmark>;
      
      private var m_FriendBookmarks:Vector.<Bookmark>;
      
      private var m_PlayerResourceBookmarks:Vector.<Bookmark>;
      
      private var m_PlayerStrongholdBookmarks:Vector.<Bookmark>;
      
      public function BookmarksManager(param1:SingletonLock)
      {
         this.m_CustomBookmarks = new Vector.<Bookmark>();
         this.m_EnemyBookmarks = new Vector.<Bookmark>();
         this.m_FriendBookmarks = new Vector.<Bookmark>();
         this.m_PlayerResourceBookmarks = new Vector.<Bookmark>();
         this.m_PlayerStrongholdBookmarks = new Vector.<Bookmark>();
         super();
      }
      
      public static function get instance() : BookmarksManager
      {
         return s_Instance = s_Instance || new BookmarksManager(new SingletonLock());
      }
      
      public function Setup(param1:Object, param2:MapRoom3Data) : void
      {
         var _loc3_:MapRoom3Cell = null;
         var _loc4_:uint = param2.playerOwnedCells.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param2.playerOwnedCells[_loc5_] as MapRoom3Cell;
            switch(_loc3_.cellType)
            {
               case EnumYardType.RESOURCE:
                  this.AddBookmark(_loc3_,TYPE_PLAYER_RESOURCES,false);
                  break;
               case EnumYardType.STRONGHOLD:
                  this.AddBookmark(_loc3_,TYPE_PLAYER_STRONGHOLDS,false);
                  break;
            }
            _loc5_++;
         }
         if(param1.hasOwnProperty(BOOKMARKS_VERSION_SAVE_DATA_FIELD) == false || param1[BOOKMARKS_VERSION_SAVE_DATA_FIELD] != BOOKMARKS_VERSION_SAVE_DATA_VALUE)
         {
            return;
         }
         if(param1.hasOwnProperty(BOOKMARKS_CUSTOM_SAVE_DATA_FIELD) == true)
         {
            this.LoadBookmarksOfType(param1[BOOKMARKS_CUSTOM_SAVE_DATA_FIELD],param2,TYPE_CUSTOM);
         }
         if(param1.hasOwnProperty(BOOKMARKS_ENEMIES_SAVE_DATA_FIELD) == true)
         {
            this.LoadBookmarksOfType(param1[BOOKMARKS_ENEMIES_SAVE_DATA_FIELD],param2,TYPE_ENEMIES);
         }
         if(param1.hasOwnProperty(BOOKMARKS_FRIENDS_SAVE_DATA_FIELD) == true)
         {
            this.LoadBookmarksOfType(param1[BOOKMARKS_FRIENDS_SAVE_DATA_FIELD],param2,TYPE_FRIENDS);
         }
      }
      
      public function SaveBookmarks() : void
      {
         var _loc1_:Object = null;
         _loc1_ = {};
         _loc1_[BOOKMARKS_VERSION_SAVE_DATA_FIELD] = BOOKMARKS_VERSION_SAVE_DATA_VALUE;
         _loc1_[BOOKMARKS_CUSTOM_SAVE_DATA_FIELD] = this.SaveBookmarksOfType(TYPE_CUSTOM);
         _loc1_[BOOKMARKS_ENEMIES_SAVE_DATA_FIELD] = this.SaveBookmarksOfType(TYPE_ENEMIES);
         _loc1_[BOOKMARKS_FRIENDS_SAVE_DATA_FIELD] = this.SaveBookmarksOfType(TYPE_FRIENDS);
         MapRoomManager.instance.bookmarkData = _loc1_;
         var _loc2_:* = GLOBAL._apiURL + "player/savebookmarks";
         var _loc3_:Array = [["bookmarks",encodeJson(_loc1_)]];
         new URLLoaderApi().load(_loc2_,_loc3_,this.OnBookmarksSaved,this.OnBookmarksSavedError);
      }
      
      private function OnBookmarksSaved(param1:Object) : void
      {
         if(param1.error != 0)
         {
            LOGGER.Log("err","BookmarksManager.SaveBookmarks",param1.error);
         }
      }
      
      private function OnBookmarksSavedError(param1:IOErrorEvent) : void
      {
         LOGGER.Log("err","BookmarksManager.SaveBookmarks HTTP");
      }
      
      private function SaveBookmarksOfType(param1:int) : Array
      {
         var _loc3_:Bookmark = null;
         var _loc4_:Object = null;
         var _loc2_:Vector.<Bookmark> = this.GetBookmarksOfType(param1);
         if(_loc2_ == null)
         {
            return [];
         }
         var _loc5_:Array = [];
         var _loc6_:uint = _loc2_.length;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = _loc2_[_loc7_];
            if(!(_loc3_ == null || _loc3_.mapCell == null))
            {
               _loc4_ = {
                  "x":_loc3_.mapCell.cellX,
                  "y":_loc3_.mapCell.cellY,
                  "n":_loc3_.userDefinedName
               };
               _loc5_.push(_loc4_);
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function LoadBookmarksOfType(param1:Array, param2:MapRoom3Data, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Bookmark = null;
         var _loc9_:Object = null;
         var _loc10_:MapRoom3Cell = null;
         var _loc4_:Vector.<Bookmark>;
         if((_loc4_ = this.GetBookmarksOfType(param3)) == null)
         {
            return;
         }
         var _loc11_:uint = param1.length;
         var _loc12_:uint = 0;
         while(_loc12_ < _loc11_)
         {
            if((_loc9_ = param1[_loc12_]) != null)
            {
               _loc5_ = int(_loc9_.x);
               _loc6_ = int(_loc9_.y);
               if((_loc10_ = param2.GetMapRoom3Cell(_loc5_,_loc6_)) != null)
               {
                  _loc7_ = String(_loc9_.n);
                  _loc8_ = new Bookmark(_loc10_,_loc7_);
                  _loc4_.push(_loc8_);
               }
            }
            _loc12_++;
         }
      }
      
      public function Cleanup() : void
      {
         this.ClearBookmarks(TYPE_CUSTOM);
         this.ClearBookmarks(TYPE_ENEMIES);
         this.ClearBookmarks(TYPE_FRIENDS);
         this.ClearBookmarks(TYPE_PLAYER_RESOURCES);
         this.ClearBookmarks(TYPE_PLAYER_STRONGHOLDS);
      }
      
      public function AddBookmark(param1:MapRoom3Cell, param2:int = 0, param3:Boolean = true) : void
      {
         var _loc4_:Vector.<Bookmark>;
         if((_loc4_ = this.GetBookmarksOfType(param2)) == null)
         {
            return;
         }
         if(this.IsBookmarked(param1,param2) == true)
         {
            return;
         }
         var _loc5_:int = param2 == TYPE_CUSTOM ? MAX_CUSTOM_BOOKMARKS : MAX_AUTO_BOOKMARKS;
         if(_loc4_.length >= _loc5_)
         {
            GLOBAL.Message(KEYS.Get("mr3_bookmarks_full_message",{"v1":_loc5_}));
            return;
         }
         var _loc6_:Bookmark = new Bookmark(param1);
         _loc4_.unshift(_loc6_);
         if(param3)
         {
            this.SaveBookmarks();
         }
         if(param1.cellGraphic != null)
         {
            param1.cellGraphic.redrawTile();
         }
      }
      
      public function RemoveBookmark(param1:MapRoom3Cell, param2:int = 0, param3:Boolean = true) : void
      {
         var _loc4_:Vector.<Bookmark>;
         if((_loc4_ = this.GetBookmarksOfType(param2)) == null)
         {
            return;
         }
         var _loc5_:Bookmark;
         if((_loc5_ = this.FindBookmark(param1,param2)) == null)
         {
            return;
         }
         var _loc6_:int;
         if((_loc6_ = _loc4_.indexOf(_loc5_)) < 0)
         {
            return;
         }
         _loc4_.splice(_loc6_,1);
         if(param3)
         {
            this.SaveBookmarks();
         }
         if(param1.cellGraphic != null)
         {
            param1.cellGraphic.redrawTile();
         }
      }
      
      public function ClearBookmarks(param1:int = 0, param2:Boolean = false) : void
      {
         var _loc3_:Vector.<Bookmark> = this.GetBookmarksOfType(param1);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_[_loc5_].Clear();
            _loc5_++;
         }
         _loc3_.length = 0;
         if(param2 == true)
         {
            this.SaveBookmarks();
         }
      }
      
      public function IsBookmarked(param1:MapRoom3Cell, param2:int = 0) : Boolean
      {
         return this.FindBookmark(param1,param2) != null;
      }
      
      private function FindBookmark(param1:MapRoom3Cell, param2:int = 0) : Bookmark
      {
         var _loc4_:Bookmark = null;
         var _loc3_:Vector.<Bookmark> = this.GetBookmarksOfType(param2);
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc5_:uint = _loc3_.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            if((_loc4_ = _loc3_[_loc6_]) != null && _loc4_.mapCell == param1)
            {
               return _loc4_;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function GetBookmarksOfType(param1:int) : Vector.<Bookmark>
      {
         switch(param1)
         {
            case TYPE_CUSTOM:
               return this.m_CustomBookmarks;
            case TYPE_ENEMIES:
               return this.m_EnemyBookmarks;
            case TYPE_FRIENDS:
               return this.m_FriendBookmarks;
            case TYPE_PLAYER_RESOURCES:
               return this.m_PlayerResourceBookmarks;
            case TYPE_PLAYER_STRONGHOLDS:
               return this.m_PlayerStrongholdBookmarks;
            default:
               return null;
         }
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

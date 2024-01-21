package com.monsters.maproom_advanced
{
   
   import com.monsters.display.ImageCache;
   import com.monsters.enums.EnumYardType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class PopupInfoViewOnly extends PopupInfoViewOnly_CLIP
   {
       
      
      private var _cell:MapRoomCell;
      
      private var _profilePic:Loader;
      
      private var _profileBmp:Bitmap;
      
      public function PopupInfoViewOnly()
      {
         super();
         x = 760 / 2 + 75;
         y = 520 / 2;
         this.bView.SetupKey("map_view_btn");
         this.bView.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("view");
         });
         this.bView.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            View();
         });
         (mcFrame as frame).Setup();
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         if(Boolean(this._profilePic) && Boolean(this._profilePic.parent))
         {
            this._profilePic.parent.removeChild(this._profilePic);
            this._profilePic = null;
         }
         if(Boolean(this._profileBmp) && Boolean(this._profileBmp.parent))
         {
            this._profileBmp.parent.removeChild(this._profileBmp);
            this._profileBmp = null;
         }
         MapRoom._mc.HideInfoViewOnly();
      }
      
      public function Setup(param1:MapRoomCell, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         this._cell = param1;
         tLabel1.htmlText = "<b>" + KEYS.Get("popup_label_namelocheight") + "</b>";
         tLabel2.htmlText = "<b>" + KEYS.Get("popup_label_thisyardhas") + "</b>";
         if(this._cell._base == 3)
         {
            if(this._cell._baseID == MapRoom._inviteBaseID)
            {
               tName.htmlText = "<b>" + KEYS.Get("map_outpostowner",{"v1":this._cell._name}) + " (" + KEYS.Get("map_target") + ")</b>";
            }
            else if(!this._cell._destroyed)
            {
               tName.htmlText = "<b>" + KEYS.Get("map_outpostowner",{"v1":this._cell._name}) + "</b>";
            }
            else
            {
               tName.htmlText = "<b>" + KEYS.Get("map_outpostowner",{"v1":this._cell._name}) + " (" + KEYS.Get("newmap_inf_destroyed") + ")</b>";
            }
            this.ProfilePic();
         }
         else if(this._cell._base == 2)
         {
            tName.htmlText = "<b>" + KEYS.Get("map_yardowner",{"v1":this._cell._name}) + "</b>";
            this.ProfilePic();
         }
         else if(this._cell._base == 1)
         {
            if(!this._cell._destroyed)
            {
               tName.htmlText = "<b>" + KEYS.Get("ai_tribe",{"v1":this._cell._name}) + "</b>";
            }
            else
            {
               tName.htmlText = "<b>" + KEYS.Get("ai_tribe",{"v1":this._cell._name}) + " (" + KEYS.Get("newmap_inf_destroyed") + ")</b>";
            }
            this.ProfilePic();
         }
         tLocation.htmlText = this._cell.X + "x" + this._cell.Y;
         tHeight.htmlText = this._cell._height - 100 + "m";
         if(this._cell._base == 2)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = this._cell._height * 100 / GLOBAL._averageAltitude.Get() - 100;
         }
         if(this._cell._base == 2)
         {
            _loc4_ = 0;
         }
         else
         {
            _loc4_ = 100 * GLOBAL._averageAltitude.Get() / this._cell._height - 100;
         }
         if(_loc3_ >= 0)
         {
            _loc5_ = "<font color=\"#003300\">+" + KEYS.Get("newmap_h1",{"v1":_loc3_}) + "</font>";
         }
         else
         {
            _loc5_ = "<font color=\"#330000\">- " + KEYS.Get("newmap_h1",{"v1":Math.abs(_loc3_)}) + "</font>";
         }
         if(_loc4_ >= 0)
         {
            _loc6_ = "<font color=\"#003300\">+" + KEYS.Get("newmap_h2",{"v1":_loc4_}) + "</font>";
         }
         else
         {
            _loc6_ = "<font color=\"#330000\">- " + KEYS.Get("newmap_h2",{"v1":Math.abs(_loc4_)}) + "</font>";
         }
         tBonus.htmlText = _loc5_ + "<br>" + _loc6_;
         this.ButtonInfo("view");
         this.Update();
      }
      
      private function ProfilePic() : void
      {
         var onImageLoad:Function = null;
         var imageComplete:Function = null;
         var LoadImageError:Function = null;
         onImageLoad = function(param1:Event):void
         {
            _profilePic.width = _profilePic.height = 50;
            _profilePic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false);
            _profilePic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);
         };
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            _profileBmp = new Bitmap(param2);
            mcProfilePic.mcBG.addChild(_profileBmp);
         };
         LoadImageError = function(param1:IOErrorEvent):void
         {
            _profilePic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false);
            _profilePic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);
         };
         if(!this._cell._facebookID && this._cell._base != 1 && !this._cell._pic_square)
         {
            return;
         }
         if(this._cell._base > 1)
         {
            if(GLOBAL._flags.viximo)
            {
               this._profilePic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
               this._profilePic.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoad);
               if(this._cell._pic_square)
               {
                  this._profilePic.load(new URLRequest(this._cell._pic_square));
               }
            }
            else
            {
               this._profilePic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
               this._profilePic.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoad);
               this._profilePic.load(new URLRequest("http://graph.facebook.com/" + this._cell._facebookID + "/picture"));
            }
         }
         else
         {
            switch(this._cell._name)
            {
               case "Dreadnought":
               case "Dreadnaut":
                  ImageCache.GetImageWithCallBack("monsters/tribe_dreadnaut_50.v2.jpg",imageComplete);
                  break;
               case "Kozu":
                  ImageCache.GetImageWithCallBack("monsters/tribe_kozu_50.v2.jpg",imageComplete);
                  break;
               case "Legionnaire":
                  ImageCache.GetImageWithCallBack("monsters/tribe_legionnaire_50.v2.jpg",imageComplete);
                  break;
               case "Abunakki":
                  ImageCache.GetImageWithCallBack("monsters/tribe_abunakki_50.v2.jpg",imageComplete);
            }
         }
      }
      
      public function Cleanup() : void
      {
         this.bView.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("view");
         });
         this.bView.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            View();
         });
         if(mcFrame)
         {
            mcFrame.Clear();
            mcFrame = null;
         }
      }
      
      public function View() : void
      {
         var _loc1_:int = 0;
         MapRoom.HideFromViewOnly();
         if(MapRoom._mc)
         {
            GLOBAL._attackerCellsInRange = MapRoom._mc.GetCellsInRange(this._cell.X,this._cell.Y,10);
         }
         GLOBAL._currentCell = this._cell;
         if(this._cell._base == 1)
         {
            BASE.LoadBase(null,0,this._cell._baseID,"wmview",false,EnumYardType.MAIN_YARD);
         }
         else
         {
            _loc1_ = this._cell._base == 3 ? int(EnumYardType.OUTPOST) : int(EnumYardType.MAIN_YARD);
            BASE.LoadBase(null,0,this._cell._baseID,"view",false,_loc1_);
         }
      }
      
      public function ButtonInfo(param1:String) : void
      {
         txtButtonInfo.htmlText = KEYS.Get("newmap_view",{"v1":this._cell._name});
         mcArrow.x = bView.x + bView.width / 2 - 5;
      }
      
      public function Update() : void
      {
         var _loc1_:String = "";
         _loc1_ = "X:" + this._cell.X + " Y:" + this._cell.Y + "<br>_base:" + this._cell._base + "<br>_height:" + this._cell._height + "<br>_water:" + this._cell._water + "<br>_mine:" + this._cell._mine + "<br>_flinger:" + this._cell._flingerRange.Get() + "<br>_catapult:" + this._cell._catapult + "<br>_userID:" + this._cell._userID + "<br>_truce:" + this._cell._truce + "<br>_name:" + this._cell._name + "<br>_protected:" + this._cell._protected + "<br>_resources:" + JSON.encode(this._cell._resources) + "<br>_ticks:" + JSON.encode(this._cell._ticks) + "<br>_monsters:" + JSON.encode(this._cell._monsters);
         if(this._cell._monsterData)
         {
            _loc1_ += "<br>_monsterData:" + JSON.encode(this._cell._monsterData);
            _loc1_ += "<br>_monsterData.saved:" + JSON.encode(this._cell._monsterData.saved);
            _loc1_ += "<br>_monsterData.h:" + JSON.encode(this._cell._monsterData.h);
            _loc1_ += "<br>_monsterData.hcount:" + this._cell._monsterData.hcount;
         }
      }
   }
}

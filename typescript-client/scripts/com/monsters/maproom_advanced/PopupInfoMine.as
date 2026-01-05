package com.monsters.maproom_advanced
{
   import com.monsters.display.ScrollSet;
   import com.monsters.enums.EnumYardType;
   import com.monsters.mailbox.Message;
   import com.monsters.mailbox.model.Contact;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   internal class PopupInfoMine extends PopupInfoMine_CLIP
   {
       
      
      private var _cell:MapRoomCell;
      
      private var _mcMonsters:MovieClip;
      
      private var _message:Message;
      
      private var _hasMonsters:Boolean = false;
      
      private var _bookmarked:Boolean = false;
      
      private var _scroller:ScrollSet;
      
      public function PopupInfoMine()
      {
         super();
         x = 760 / 2 + 75;
         y = 520 / 2;
         mMonsters.mask = mMonstersMask;
         this._scroller = new ScrollSet();
         this._scroller.isHiddenWhileUnnecessary = true;
         this._scroller.AutoHideEnabled = false;
         this._scroller.width = scroll.width;
         this._scroller.x = scroll.x;
         this._scroller.y = scroll.y;
         addChild(this._scroller);
         this._scroller.Init(mMonsters,mMonstersMask,0,scroll.y,scroll.height);
         this.bOpen.SetupKey("btn_open");
         this.bOpen.Highlight = true;
         this.bOpen.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("open");
         });
         this.bOpen.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Open();
         });
         this.bMonsters.SetupKey("newmap_tr_from");
         this.bMonsters.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("monsters");
         });
         this.bMonsters.addEventListener(MouseEvent.CLICK,this.StartTransferM);
         this.bRelocate.SetupKey("btn_movemainyardhere");
         this.bRelocate.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("relocateme");
         });
         this.bRelocate.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            MapRoom._mc.ShowRelocateMePopup(_cell);
         });
         this.bInviteMigrate.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("invitemigrate");
         });
         this.bInviteMigrate.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            ShowInviteMigrate();
         });
         this.bBookmark.SetupKey("newmap_bookmark_btn");
         this.bBookmark.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("bookmark");
         });
         this.bBookmark.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(!_bookmarked)
            {
               MapRoom._mc.ShowBookmarkAddPopup(_cell);
            }
            else
            {
               GLOBAL.Message(KEYS.Get("newmap_bm_done"));
            }
         });
         (mcFrame as frame).Setup();
      }
      
      private function StartTransferM(param1:MouseEvent) : void
      {
         if(this.bMonsters.Enabled && !MapRoom._monsterTransferInProgress && !MapRoom._resourceTransferInProgress && GLOBAL._mapOutpost.length > 0 && this._hasMonsters)
         {
            MapRoom._mc.ShowMonstersA(this._cell);
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         MapRoom._mc.HideInfoMine();
      }
      
      public function Setup(param1:MapRoomCell) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         this._cell = param1;
         tLabel1.htmlText = "<b>" + KEYS.Get("popup_label_name") + "</b>";
         tLabel2.htmlText = "<b>" + KEYS.Get("popup_label_thisyardhas") + "</b>";
         tLabel3.htmlText = "<b>" + KEYS.Get("popup_label_locationheight") + "</b>";
         tLabel4.htmlText = "<b>" + KEYS.Get("popup_label_monstershoused") + "</b>";
         var _loc2_:Number = 0;
         if(POWERUPS.CheckPowers(POWERUPS.ALLIANCE_DECLAREWAR,"NORMAL"))
         {
            _loc2_ = POWERUPS.Apply(POWERUPS.ALLIANCE_DECLAREWAR,[0]);
         }
         GLOBAL._attackerCellsInRange = MapRoom._mc.GetCellsInRange(this._cell.X,this._cell.Y,10 + _loc2_);
         if(this._cell._base == 3)
         {
            tName.htmlText = KEYS.Get("map_outpostowner",{"v1":this._cell._name});
         }
         else
         {
            tName.htmlText = KEYS.Get("map_yardowner",{"v1":this._cell._name});
         }
         tLocation.htmlText = param1.X + "x" + param1.Y;
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
         if(GLOBAL._mapOutpost.length > 0)
         {
            this.bMonsters.Enabled = true;
         }
         else
         {
            this.bMonsters.Enabled = false;
         }
         this.ButtonInfo("open");
         this.bBookmark.Enabled = true;
         if(MapRoom._bookmarks)
         {
            _loc7_ = 0;
            while(_loc7_ < MapRoom._bookmarks.length)
            {
               if(MapRoom._bookmarks[_loc7_].location.x == this._cell.X && MapRoom._bookmarks[_loc7_].location.y == this._cell.Y)
               {
                  this._bookmarked = true;
                  break;
               }
               _loc7_++;
            }
            if(this._bookmarked)
            {
               this.bBookmark.Enabled = false;
            }
            else
            {
               this.bBookmark.Enabled = true;
            }
         }
         if(this._cell._base == 3)
         {
            this.bRelocate.visible = true;
            this.bInviteMigrate.visible = true;
         }
         else
         {
            this.bRelocate.visible = false;
            this.bInviteMigrate.visible = false;
         }
         if(this._cell._invitePendingID == 0)
         {
            this.bInviteMigrate.SetupKey("btn_invitetomove");
         }
         else
         {
            this.bInviteMigrate.SetupKey("btn_revokeinvitation");
         }
         this.Update();
      }
      
      public function Cleanup() : void
      {
         this.bOpen.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("open");
         });
         this.bOpen.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Open();
         });
         this.bMonsters.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("monsters");
         });
         this.bMonsters.removeEventListener(MouseEvent.CLICK,this.StartTransferM);
         this.bRelocate.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("relocateme");
         });
         this.bRelocate.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            MapRoom._mc.ShowRelocateMePopup(_cell);
         });
         this.bInviteMigrate.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("invitemigrate");
         });
         this.bInviteMigrate.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            ShowInviteMigrate();
         });
         this.bBookmark.removeEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            ButtonInfo("bookmark");
         });
         this.bBookmark.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(!_bookmarked)
            {
               MapRoom._mc.ShowBookmarkAddPopup(_cell);
            }
            else
            {
               GLOBAL.Message(KEYS.Get("newmap_bm_done"));
            }
         });
         if(mcFrame)
         {
            mcFrame.Clear();
            mcFrame = null;
         }
      }
      
      private function Open() : void
      {
         var _loc1_:int = 0;
         if(!this._cell._locked || this._cell._locked == LOGIN._playerID)
         {
            GLOBAL._currentCell = this._cell;
            MapRoom._mc.HideInfoMine();
            MapRoomManager.instance.Hide();
            MapRoom.ClearCells();
            GLOBAL._attackerCellsInRange = new Vector.<CellData>(0,true);
            _loc1_ = this._cell._base == 3 ? int(EnumYardType.OUTPOST) : int(EnumYardType.MAIN_YARD);
            BASE.LoadBase(null,0,this._cell._baseID,GLOBAL.e_BASE_MODE.BUILD,false,_loc1_);
         }
         else
         {
            GLOBAL.Message(KEYS.Get("newmap_attacked"));
         }
      }
      
      public function PendingInvite() : void
      {
         this._cell._invitePendingID = 1;
         this._cell.mc.mcPlayer.mcInvite.visible = true;
         this._cell._updated = false;
         MapRoom.GetCell(this._cell.X,this._cell.Y,true);
      }
      
      private function RevokeInvitation() : void
      {
         var body:String;
         var subject:String;
         var vars:Array;
         var r:URLLoaderApi;
         var onMigrateRevokeSuccess:Function = null;
         var onFail:Function = null;
         onMigrateRevokeSuccess = function(param1:Object):void
         {
            Hide();
            if(param1.error != 0)
            {
               GLOBAL.Message(KEYS.Get("msg_err_revoke") + param1.error);
               return;
            }
            _cell._invitePendingID = 0;
            _cell.mc.mcPlayer.mcInvite.visible = false;
            _cell._updated = false;
            if(MapRoom._open)
            {
               MapRoom.GetCell(_cell.X,_cell.Y,true);
            }
            GLOBAL.Message(KEYS.Get("msg_revoke_success"));
         };
         onFail = function(param1:Error):void
         {
            Hide();
            GLOBAL.Message(KEYS.Get("msg_err_revoke") + param1.message);
            LOGGER.Log("err","PopupInfoMine.RevokeInvitation HTTP ",param1.message);
         };
         if(!this._cell._updated)
         {
            return;
         }
         SOUNDS.Play("click1");
         body = KEYS.Get("invite_revoke");
         subject = KEYS.Get("invite_subject");
         vars = [["threadid",this._cell._invitePendingID],["targetid",LOGIN._playerID],["targetbaseid",0],["type","migraterevoke"],["subject",subject],["message",body]];
         r = new URLLoaderApi();
         r.load(GLOBAL._apiURL + "player/sendmessage",vars,onMigrateRevokeSuccess,onFail);
      }
      
      private function ButtonInfo(param1:String) : void
      {
         if(param1 == "open")
         {
            txtButtonInfo.htmlText = KEYS.Get("newmap_inf_open");
            mcArrow.x = bOpen.x + bOpen.width / 2 - 5;
         }
         else if(param1 == "monsters")
         {
            txtButtonInfo.htmlText = KEYS.Get("newmap_inf_tr");
            mcArrow.x = bMonsters.x + bMonsters.width / 2 - 5;
         }
         else if(param1 == "bookmark")
         {
            txtButtonInfo.htmlText = KEYS.Get("newmap_bookmark");
            mcArrow.x = bBookmark.x + bBookmark.width / 2 - 5;
         }
         else if(param1 == "relocateme")
         {
            txtButtonInfo.htmlText = KEYS.Get("newmap_relocate_exp");
            mcArrow.x = bRelocate.x + bRelocate.width / 2 - 5;
         }
         else if(param1 == "invitemigrate")
         {
            if(this._cell._invitePendingID)
            {
               txtButtonInfo.htmlText = KEYS.Get("newmap_revokepending");
            }
            else
            {
               txtButtonInfo.htmlText = KEYS.Get("newmap_invite_exp");
            }
            mcArrow.x = bInviteMigrate.x + bInviteMigrate.width / 2 - 5;
         }
         TweenLite.to(mcArrow,0.6,{
            "x":mcArrow.x + 5,
            "ease":Elastic.easeOut
         });
      }
      
      private function ShowInviteMigrate() : void
      {
         if(this._cell._base < 2)
         {
            GLOBAL.Message(KEYS.Get("newmap_wmtruce",{"v1":this._cell._name}));
            return;
         }
         if(!this._cell._updated)
         {
            return;
         }
         if(this._cell._invitePendingID)
         {
            this.RevokeInvitation();
            return;
         }
         if(Boolean(this._message) && Boolean(this._message.parent))
         {
            this._message.parent.removeChild(this._message);
            this._message = null;
         }
         var _loc1_:Contact = new Contact(String(this._cell._userID),{
            "first_name":this._cell._name,
            "last_name":"",
            "pic_square":this._cell._pic_square
         });
         this._message = new Message("map2friends");
         this._message.requestType = "migraterequest";
         this._message.subject_txt.htmlText = KEYS.Get("invite_subject");
         this._message.body_txt.htmlText = KEYS.Get("invite_body");
         this._message.x = 0;
         this._message.y = -450;
         this._message.baseID = this._cell._baseID;
         GLOBAL.BlockerAdd(this.parent as MovieClip);
         MapRoom._mc.addChild(this._message);
         this.bInviteMigrate.Enabled = false;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:PopupInfoMonster = null;
         if(this._cell._updated)
         {
            this.bInviteMigrate.Enabled = true;
         }
         else
         {
            this.bInviteMigrate.Enabled = false;
         }
         if(Boolean(this._mcMonsters) && Boolean(this._mcMonsters.parent))
         {
            this._mcMonsters.parent.removeChild(this._mcMonsters);
            this._mcMonsters = null;
         }
         this._hasMonsters = false;
         if(this._cell._monsters)
         {
            this._mcMonsters = new MovieClip();
            this._mcMonsters.x = 5;
            this._mcMonsters.y = 5;
            _loc1_ = 0;
            _loc2_ = 0;
            for(_loc3_ in this._cell._monsters)
            {
               if(this._cell._monsters[_loc3_].Get() > 0)
               {
                  (_loc4_ = new PopupInfoMonster()).Setup(_loc1_ * 130,_loc2_ * 35,_loc3_,this._cell._monsters[_loc3_].Get());
                  _loc1_ += 1;
                  this._mcMonsters.addChild(_loc4_);
                  if(_loc1_ == 2)
                  {
                     _loc1_ = 0;
                     _loc2_ += 1;
                  }
                  this._hasMonsters = true;
               }
            }
            mMonsters.addChild(this._mcMonsters);
         }
         if(this._hasMonsters && GLOBAL._mapOutpost.length > 0)
         {
            this.bMonsters.Enabled = true;
         }
         else
         {
            this.bMonsters.Enabled = false;
         }
         if(this._scroller)
         {
            this._scroller.Update();
         }
      }
   }
}

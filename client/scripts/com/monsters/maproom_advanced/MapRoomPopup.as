package com.monsters.maproom_advanced
{
   import com.monsters.alliances.AllyInfo;
   import com.monsters.display.ImageCache;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   internal class MapRoomPopup extends MapRoomPopup_CLIP
   {
       
      
      private var mapOffset:Point;
      
      private var _cellContainer:MovieClip;
      
      private var _cells:Array;
      
      private var _mouseClickPoint:Point;
      
      private var _containerClickPoint:Point;
      
      private var _containerStartPoint:Point;
      
      private var _sortArray:Array;
      
      private var _cellCountX:int;
      
      private var _cellCountY:int;
      
      private var _bubble:bubblepopup3;
      
      private var _cellWidth:int = 150;
      
      private var _cellHeight:int = 75;
      
      private var _popupBookmarkAdd:PopupNewBookmark;
      
      private var _popupRelocateMe:PopupRelocateMe;
      
      public var _popupInfoMine:PopupInfoMine;
      
      private var _popupInfoEnemy:PopupInfoEnemy;
      
      private var _popupMonsters:PopupMonstersA;
      
      private var _popupInfoViewOnly:PopupInfoViewOnly;
      
      private var _popupBuff:bubblepopupBuff;
      
      private var _popupBookmarkMenu:Array;
      
      private var _menuShown:Boolean = false;
      
      private var _fullScreen:Boolean = false;
      
      private var _fallbackHomeCell:MapRoomCell;
      
      private var _popupAttackA:PopupAttackA;
      
      public var _dragged:Boolean;
      
      private var _popupMonstersB:PopupMonstersB;
      
      public function MapRoomPopup()
      {
         var w:int;
         var h:int;
         var r:Rectangle;
         var i:int;
         this._sortArray = [];
         super();
         w = GLOBAL._ROOT.stage.stageWidth;
         h = GLOBAL.GetGameHeight();
         if(w > 1024)
         {
            w = 1024;
         }
         if(h > 768)
         {
            h = 768;
         }
         r = new Rectangle(0 - (w - 760) / 2,0 - (h - 720) / 2,w,h);
         if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            this._fullScreen = true;
            mcFrame.x = r.x + 175;
            mcFrame.y = r.y + 20;
            mcFrame.width = w - 195;
            mcFrame.height = h - 40;
            mcMask.x = r.x + 175;
            mcMask.y = r.y + 20;
            mcMask.mcMask.width = w - 195;
            mcMask.mcMask.height = h - 40;
            mcFrame2.x = r.x;
            mcFrame2.y = r.y + 20;
            mcBuffHolder.x = mcMask.width + mcMask.x - 70;
            mcBuffHolder.y = mcMask.y + 28;
         }
         else
         {
            this._fullScreen = false;
            mcFrame.x = 190;
            mcFrame.y = 20;
            mcFrame.width = 760 - 20 - 190;
            mcFrame.height = 520 - 40;
            mcMask.x = mcFrame.x;
            mcMask.y = mcFrame.y;
            mcMask.mcMask.width = mcFrame.width;
            mcMask.mcMask.height = mcFrame.height;
            mcFrame2.x = 20;
            mcFrame2.y = 20;
            mcBuffHolder.x = mcMask.width + mcMask.x - 70;
            mcBuffHolder.y = mcMask.y + 30;
         }
         mcInfo.x = mcFrame2.x + 20;
         mcInfo.y = mcFrame2.y + 270;
         mcInfo.visible = false;
         // (mcFrame as frame1).Setup(true,true,true,0,0);
         // (mcFrame2 as frame).Setup(false);
         mcFrame.Setup(true,true,true,0,0);
         mcFrame2.Setup(false);
         mcMask.mcMask.mouseEnabled = false;
         this._bubble = new bubblepopup3();
         this._popupInfoMine = new PopupInfoMine();
         this._popupInfoEnemy = new PopupInfoEnemy();
         this._popupMonsters = new PopupMonstersA();
         this._popupMonstersB = new PopupMonstersB();
         this._popupAttackA = new PopupAttackA();
         this._popupAttackA.x = 380;
         this._popupAttackA.y = 260;
         this._popupBookmarkAdd = new PopupNewBookmark();
         this._popupBookmarkAdd.x = 380;
         this._popupBookmarkAdd.y = 260;
         this._popupRelocateMe = new PopupRelocateMe();
         this._popupBookmarkMenu = new Array();
         this._popupBookmarkMenu.x = 380;
         this._popupBookmarkMenu.y = 260;
         this._popupBookmarkAdd.mcFrame.Setup(true,this.HideBookmarkAddPopup);
         this._popupInfoViewOnly = new PopupInfoViewOnly();
         if(!MapRoom._viewOnly)
         {
            this.bHome.SetupKey("btn_home");
            this.bHome.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               HideBookmarkMenu();
               MapRoom.JumpTo(GLOBAL._mapHome);
            });
            this.bHome.buttonMode = true;
            this.bHome.x = mcFrame2.x + 20;
            this.bHome.y = mcFrame2.y + 200;
            this.bJump.SetupKey("btn_jump");
            this.bJump.addEventListener(MouseEvent.CLICK,this.JumpPopupShow);
            this.bJump.buttonMode = true;
            this.bJump.x = mcFrame2.x + 80;
            this.bJump.y = mcFrame2.y + 200;
            this.bBookmarks.SetupKey("btn_bookmarks");
            this.bBookmarks.addEventListener(MouseEvent.CLICK,this.ShowBookmarkMenu);
            this.bBookmarks.buttonMode = true;
            this.bBookmarks.x = mcFrame2.x + 20;
            this.bBookmarks.y = mcFrame2.y + 235;
            this.UpdateResourceDisplay();
         }
         else
         {
            this.bBookmarks.SetupKey("btn_home");
            this.bBookmarks.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               MapRoom.JumpTo(MapRoom._inviteLocation);
            });
            this.bBookmarks.buttonMode = true;
            this.bBookmarks.Enabled = true;
            this.bBookmarks.x = mcFrame2.x + 20;
            this.bBookmarks.y = mcFrame2.y + 235;
            this.bHome.visible = false;
            this.bJump.visible = false;
            this.HideResourceDisplay();
         }
         mcInfo.labelOwner.htmlText = "<b>" + KEYS.Get("label_owner") + "</b>";
         if(Boolean(GLOBAL._flags.viximo) || Boolean(GLOBAL._flags.kongregate))
         {
            mcInfo.labelAlliance.htmlText = "<b>" + KEYS.Get("label_type") + "</b>";
         }
         else
         {
            mcInfo.labelAlliance.htmlText = "<b>" + KEYS.Get("label_alliance") + "</b>";
         }
         mcInfo.labelStatus.htmlText = "<b>" + KEYS.Get("label_status") + "</b>";
         mcInfo.labelLocation.htmlText = "<b>" + KEYS.Get("label_location") + "</b>";
         this.GenerateCells(MapRoom._homePoint);
         this._sortArray.sortOn("depth",Array.NUMERIC);
         i = 0;
         while(i < this._sortArray.length)
         {
            if(this._cellContainer.getChildIndex(this._sortArray[i]) != i)
            {
               this._cellContainer.setChildIndex(this._sortArray[i],i);
            }
            i++;
         }
         this._cellContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.ContainerClick);
         GLOBAL._ROOT.stage.addEventListener(MouseEvent.MOUSE_UP,this.ContainerRelease);
         this.mcMask.mcBG.addChild(this._cellContainer);
      }
      
      private function JumpPopupShow(param1:MouseEvent = null) : void
      {
         var popupMC:MapRoomPopupJump = null;
         var Jump:Function = null;
         var JumpPopupHide:Function = null;
         var e:MouseEvent = param1;
         Jump = function(param1:MouseEvent = null):void
         {
            var _loc2_:String = JumpToCoordinate(popupMC.tX.text,popupMC.tY.text);
            if(_loc2_)
            {
               GLOBAL.Message(_loc2_);
            }
            else
            {
               JumpPopupHide();
            }
         };
         JumpPopupHide = function(param1:MouseEvent = null):void
         {
            GLOBAL.BlockerRemove();
            popupMC.bJump.removeEventListener(MouseEvent.CLICK,Jump);
            popupMC.mcFrame = null;
            popupMC.parent.removeChild(popupMC);
            popupMC = null;
         };
         this.HideBookmarkMenu();
         popupMC = new MapRoomPopupJump();
         popupMC.tMessage.htmlText = KEYS.Get("label_jumptolocation");
         popupMC.tX.htmlText = "";
         popupMC.tY.htmlText = "";
         popupMC.bJump.SetupKey("btn_jump");
         popupMC.bJump.addEventListener(MouseEvent.CLICK,Jump);
         popupMC.x = 450;
         popupMC.y = 250;
         popupMC.mcFrame.Setup(true,JumpPopupHide);
         GLOBAL.BlockerAdd(this);
         this.addChild(popupMC);
      }
      
      private function HideResourceDisplay() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this["mcR" + _loc1_].visible = false;
            _loc1_++;
         }
         mcOutposts.visible = false;
      }
      
      private function UpdateResourceDisplay() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 1;
         while(_loc1_ < 5)
         {
            this["mcR" + _loc1_].x = mcFrame2.x + 20;
            this["mcR" + _loc1_].y = mcFrame2.y + 18 + (_loc1_ - 1) * 36;
            this["mcR" + _loc1_].tR.htmlText = GLOBAL.FormatNumber(GLOBAL._resources["r" + _loc1_].Get());
            _loc2_ = int(100 / GLOBAL._resources["r" + _loc1_ + "max"] * GLOBAL._resources["r" + _loc1_].Get());
            if(_loc2_ > 90)
            {
               _loc2_ = 90;
            }
            this["mcR" + _loc1_].mcBar.width = _loc2_;
            _loc1_++;
         }
         mcOutposts.x = mcFrame2.x + 20;
         mcOutposts.y = mcFrame2.y + 162;
         mcOutposts.tR.htmlText = GLOBAL._mapOutpost.length + " " + KEYS.Get("newmap_outposts");
      }
      
      public function ShowInfo(param1:MapRoomCell) : void
      {
         if(!param1._updated)
         {
            return;
         }
         var _loc2_:int = int(mcInfo.mcProfilePic.mcImage.numChildren);
         while(_loc2_--)
         {
            mcInfo.mcProfilePic.mcImage.removeChildAt(_loc2_);
         }
         _loc2_ = int(mcInfo.mcAlliancePic.mcImage.numChildren);
         while(_loc2_--)
         {
            mcInfo.mcAlliancePic.mcImage.removeChildAt(_loc2_);
         }
         mcInfo.mcAlliancePic.visible = false;
         if(GLOBAL._flags.viximo)
         {
            if(param1._base > 1 && Boolean(param1._pic_square))
            {
               this.ProfilePicVix(param1._pic_square);
               if(Boolean(param1._alliance) && Boolean(param1._alliance.image))
               {
                  this.AlliancePic(AllyInfo._picURLs.sizeM,param1._alliance);
                  mcInfo.mcAlliancePic.visible = true;
               }
            }
         }
         else if(param1._base > 1 && Boolean(param1._facebookID))
         {
            this.ProfilePic(param1._facebookID);
            if(Boolean(param1._alliance) && Boolean(param1._alliance.image))
            {
               this.AlliancePic(AllyInfo._picURLs.sizeM,param1._alliance);
               mcInfo.mcAlliancePic.visible = true;
            }
         }
         if(param1._base == 1 && Boolean(param1._name))
         {
            this.TribePic(param1._name);
         }
         if(param1._water)
         {
            mcInfo.tAlliance.htmlText = "";
            mcInfo.tStatus.htmlText = KEYS.Get("status_water");
            mcInfo.tOwner.htmlText = "";
            mcInfo.tUserId.visible = false;
         }
         else
         {
            if(param1._alliance)
            {
               if(param1._base == 0)
               {
                  mcInfo.tAlliance.htmlText = "";
               }
               if(param1._base == 1)
               {
                  mcInfo.tAlliance.htmlText = KEYS.Get("newmap_wm");
               }
               if(param1._base == 2 && Boolean(param1._mine))
               {
                  mcInfo.tAlliance.htmlText = param1._alliance.name;
               }
               if(param1._base == 2 && !param1._mine)
               {
                  mcInfo.tAlliance.htmlText = param1._alliance.name;
               }
               if(param1._base == 3 && Boolean(param1._mine))
               {
                  mcInfo.tAlliance.htmlText = param1._alliance.name;
               }
               if(param1._base == 3 && !param1._mine)
               {
                  mcInfo.tAlliance.htmlText = param1._alliance.name;
               }
            }
            else
            {
               if(param1._base == 0)
               {
                  mcInfo.tAlliance.htmlText = "";
               }
               if(param1._base == 1)
               {
                  mcInfo.tAlliance.htmlText = KEYS.Get("newmap_wm");
               }
               if(param1._base == 2 && Boolean(param1._mine))
               {
                  mcInfo.tAlliance.htmlText = KEYS.Get("newmap_my");
               }
               if(param1._base == 2 && !param1._mine)
               {
                  mcInfo.tAlliance.htmlText = KEYS.Get("newmap_ey");
               }
               if(param1._base == 3 && Boolean(param1._mine))
               {
                  mcInfo.tAlliance.htmlText = KEYS.Get("newmap_outposts");
               }
               if(param1._base == 3 && !param1._mine)
               {
                  mcInfo.tAlliance.htmlText = KEYS.Get("newmap_eo");
               }
            }
            if(param1._damage)
            {
               mcInfo.tStatus.htmlText = "<font color=\"#FF0000\">" + KEYS.Get("newmap_inf_damaged",{"v1":int(param1._damage)}) + "</font>";
            }
            if(!param1._damage)
            {
               mcInfo.tStatus.htmlText = "Fine";
            }
            if(!param1._damage && param1._base < 1)
            {
               mcInfo.tStatus.htmlText = KEYS.Get("newmap_re");
            }
            mcInfo.tOwner.htmlText = param1._name;
            mcInfo.tUserId.text = KEYS.Get("label_userid",{"v1":param1._userID});
            mcInfo.tUserId.visible = true;
         }
         mcInfo.tLocation.htmlText = param1.X + " x " + param1.Y;
         mcInfo.visible = true;
      }
      
      private function ProfilePic(param1:Number) : void
      {
         var profilePic:Loader = null;
         var onImageLoad:Function = null;
         var LoadImageError:Function = null;
         var fbid:Number = param1;
         onImageLoad = function(param1:Event):void
         {
            profilePic.width = profilePic.height = 50;
            mcInfo.mcProfilePic.mcImage.addChild(profilePic);
            profilePic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false);
            profilePic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);
         };
         LoadImageError = function(param1:IOErrorEvent):void
         {
            profilePic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false);
            profilePic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);
         };
         profilePic = new Loader();
         profilePic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
         profilePic.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoad);
         profilePic.load(new URLRequest("http://graph.facebook.com/" + fbid + "/picture"));
      }
      
      private function ProfilePicVix(param1:String) : void
      {
         var profilePic:Loader = null;
         var onImageLoad:Function = null;
         var LoadImageError:Function = null;
         var imgURL:String = param1;
         onImageLoad = function(param1:Event):void
         {
            profilePic.width = profilePic.height = 50;
            mcInfo.mcProfilePic.mcImage.addChild(profilePic);
            profilePic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false);
            profilePic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);
         };
         LoadImageError = function(param1:IOErrorEvent):void
         {
            profilePic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false);
            profilePic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onImageLoad);
         };
         profilePic = new Loader();
         profilePic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
         profilePic.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoad);
         profilePic.load(new URLRequest(imgURL));
      }
      
      private function TribePic(param1:String) : void
      {
         var imageComplete:Function = null;
         var tribe:String = param1;
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            mcInfo.mcProfilePic.mcImage.addChild(_loc3_);
         };
         switch(tribe)
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
      
      private function AlliancePic(param1:String, param2:AllyInfo) : void
      {
         param2.AlliancePic(param1,mcInfo.mcAlliancePic.mcImage,mcInfo.mcAlliancePic.mcBG,true);
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         GLOBAL._attackerCellsInRange = new Vector.<CellData>(0,true);
         if(BASE._loadedFriendlyBaseID)
         {
            BASE.yardType = BASE._loadedYardType;
            BASE.LoadBase(null,0,BASE._loadedFriendlyBaseID,GLOBAL.e_BASE_MODE.BUILD,false,BASE._loadedYardType);
         }
         else
         {
            BASE.yardType = EnumYardType.MAIN_YARD;
            BASE.LoadBase(null,0,GLOBAL._homeBaseID,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.MAIN_YARD);
         }
         SOUNDS.Play("close");
         this.Cleanup();
         MapRoomManager.instance.Hide();
      }
      
      public function Cleanup() : void
      {
         var i:int = 0;
         this._bubble = null;
         if(this._popupInfoMine)
         {
            this._popupInfoMine.Cleanup();
            this._popupInfoMine = null;
         }
         if(this._popupInfoEnemy)
         {
            this._popupInfoEnemy.Cleanup();
            this._popupInfoEnemy = null;
         }
         if(this._popupMonsters)
         {
            this._popupMonsters.Cleanup();
            this._popupMonsters = null;
         }
         if(this._popupMonstersB)
         {
            this._popupMonstersB.Cleanup();
            this._popupMonstersB = null;
         }
         if(this._popupAttackA)
         {
            this._popupAttackA.Cleanup();
            this._popupAttackA = null;
         }
         if(this._popupBookmarkAdd)
         {
            this._popupBookmarkAdd.mcFrame = null;
            this._popupBookmarkAdd = null;
         }
         if(this._popupRelocateMe)
         {
            this._popupRelocateMe.Cleanup();
            this._popupRelocateMe = null;
         }
         this._popupBookmarkMenu = null;
         if(this._popupInfoViewOnly)
         {
            this._popupInfoViewOnly.Cleanup();
            this._popupInfoViewOnly = null;
         }
         if(this._popupBuff)
         {
            if(this._popupBuff.parent)
            {
               this._popupBuff.parent.removeChild(this._popupBuff);
            }
            this._popupBuff.Cleanup();
            this._popupBuff = null;
         }
         if(mcFrame)
         {
            mcFrame.Clear();
            mcFrame = null;
         }
         if(mcFrame2)
         {
            mcFrame2.Clear();
            mcFrame2 = null;
         }
         if(this._cellContainer)
         {
            while(this._cellContainer.numChildren > 0)
            {
               this._cellContainer.removeChildAt(0);
            }
            this._cellContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.ContainerClick);
            GLOBAL._ROOT.stage.removeEventListener(MouseEvent.MOUSE_UP,this.ContainerRelease);
            if(this._cellContainer.parent)
            {
               this._cellContainer.parent.removeChild(this._cellContainer);
            }
            this._cellContainer = null;
         }
         if(this._cells)
         {
            i = int(this._cells.length - 1);
            while(i >= 0)
            {
               this._cells[i].Cleanup();
               delete this._cells[i];
               i--;
            }
            this._cells = [];
         }
         if(!MapRoom._viewOnly)
         {
            this.bHome.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               HideBookmarkMenu();
               MapRoom.JumpTo(GLOBAL._mapHome);
            });
            this.bJump.removeEventListener(MouseEvent.CLICK,this.JumpPopupShow);
            this.bBookmarks.removeEventListener(MouseEvent.CLICK,this.ShowBookmarkMenu);
         }
         else
         {
            this.bBookmarks.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               MapRoom.JumpTo(MapRoom._inviteLocation);
            });
         }
      }
      
      public function Setup() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc1_:int = MapRoom.BookmarkDataGet("mbms");
         if(_loc1_ > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = MapRoom.BookmarkDataGet("mbm" + _loc2_);
               _loc4_ = int(_loc3_ / 10000);
               _loc5_ = _loc3_ - _loc4_ * 10000;
               _loc6_ = MapRoom.BookmarkDataGetStr("mbmn" + _loc2_);
               MapRoom._currentPosition = new Point(_loc4_,_loc5_);
               MapRoom.AddBookmark(_loc6_,false);
               _loc2_++;
            }
         }
         else
         {
            MapRoomManager.instance.BookmarksClear();
         }
         if(MapRoom._bookmarks.length > 0 || MapRoom._viewOnly)
         {
            this.bBookmarks.Enabled = true;
         }
         else
         {
            this.bBookmarks.Enabled = false;
         }
      }
      
      public function JumpTo(param1:Point) : void
      {
         this.mcMask.mcBG.removeChild(this._cellContainer);
         this.GenerateCells(param1);
         this._sortArray.sortOn("depth",Array.NUMERIC);
         var _loc2_:int = 0;
         while(_loc2_ < this._sortArray.length)
         {
            if(this._cellContainer.getChildIndex(this._sortArray[_loc2_]) != _loc2_)
            {
               this._cellContainer.setChildIndex(this._sortArray[_loc2_],_loc2_);
            }
            _loc2_++;
         }
         this._cellContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.ContainerClick);
         GLOBAL._ROOT.stage.addEventListener(MouseEvent.MOUSE_UP,this.ContainerRelease);
         this.mcMask.mcBG.addChild(this._cellContainer);
         this.Update();
      }
      
      private function GenerateCells(param1:Point) : void
      {
         var cellIndex:int = 0;
         var rowIndex:int = 0;
         var mapRoomCell:MapRoomCell = null;
         var stageWidth:int = GLOBAL._ROOT.stage.stageWidth;
         var stageHeight:int = GLOBAL.GetGameHeight();
         LOGGER.Log("log","val of param1: " + param1);
         if(stageWidth > 1024)
         {
            stageWidth = 1024;
         }
         if(stageHeight > 768)
         {
            stageHeight = 768;
         }
         var _loc5_:Rectangle = new Rectangle(0 - (stageWidth - 760) / 2,0 - (stageHeight - 520) / 2,stageWidth,stageHeight);
         if(this._cellContainer)
         {
            while(this._cellContainer.numChildren > 0)
            {
               this._cellContainer.removeChildAt(0);
            }
            this._cellContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.ContainerClick);
            GLOBAL._ROOT.stage.removeEventListener(MouseEvent.MOUSE_UP,this.ContainerRelease);
            if(this._cellContainer.parent)
            {
               this._cellContainer.parent.removeChild(this._cellContainer);
            }
            this._cellContainer = null;
         }
         if(this._cells)
         {
            cellIndex = int(this._cells.length - 1);
            cellIndex = int(this._cells.length - 1);
            while(cellIndex >= 0)
            {
               delete this._cells[cellIndex];
               cellIndex--;
            }
         }
         this._cells = [];
         this._cellContainer = new MovieClip();
         this._sortArray = [];
         if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            this._cellCountX = 18;
            this._cellCountY = 15;
         }
         else
         {
            this._cellCountX = 16;
            this._cellCountY = 14;
         }
         stageHeight = 0;
         while(stageHeight < this._cellCountX)
         {
            rowIndex = 0;
            while(rowIndex < this._cellCountY)
            {
               (mapRoomCell = new MapRoomCell()).x = int(stageHeight * (this._cellWidth * 0.75) - this._cellWidth * 0.75 * 4);
               mapRoomCell.y = int(rowIndex * this._cellHeight - this._cellHeight * 5);
               mapRoomCell.X = stageHeight;
               mapRoomCell.Y = rowIndex;
               mapRoomCell.cacheAsBitmap = true;
               mapRoomCell.mc.gotoAndStop(1);
               mapRoomCell.mc.mcPlayer.visible = false;
               if(stageHeight % 2 == 0)
               {
                  mapRoomCell.y += this._cellHeight * 0.5;
               }
               this._cells.push(mapRoomCell);
               mapRoomCell.depth = mapRoomCell.y * 1000 + mapRoomCell.x;
               this._sortArray.push(mapRoomCell);
               this._cellContainer.addChild(mapRoomCell);
               if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
               {
                  mapRoomCell.Y += param1.y - 8;
                  if(param1.x % 2)
                  {
                     mapRoomCell.X += param1.x - 8;
                     this._cellContainer.x = -125;
                     this._cellContainer.y = 18;
                  }
                  else
                  {
                     mapRoomCell.X += param1.x - 7;
                     this._cellContainer.x = -9;
                     this._cellContainer.y = 54;
                  }
               }
               else
               {
                  mapRoomCell.Y += param1.y - 7;
                  if(param1.x % 2)
                  {
                     mapRoomCell.X += param1.x - 4;
                     this._cellContainer.x = 209;
                     this._cellContainer.y = 7;
                  }
                  else
                  {
                     mapRoomCell.X += param1.x - 5;
                     this._cellContainer.x = 101;
                     this._cellContainer.y = 40;
                  }
               }
               rowIndex++;
            }
            stageHeight++;
         }
         this._fallbackHomeCell = new MapRoomCell();
         this._fallbackHomeCell.X = GLOBAL._mapHome.x;
         this._fallbackHomeCell.Y = GLOBAL._mapHome.y;
         this._cellContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.ContainerClick);
         GLOBAL._ROOT.stage.addEventListener(MouseEvent.MOUSE_UP,this.ContainerRelease);
         this.mcMask.mcBG.addChild(this._cellContainer);
      }
      
      private function ContainerClick(param1:MouseEvent) : void
      {
         this._dragged = false;
         this._containerClickPoint = new Point(this._cellContainer.x,this._cellContainer.y);
         this._mouseClickPoint = new Point(mouseX,mouseY);
         this._containerStartPoint = new Point(this._cellContainer.x,this._cellContainer.y);
         this._cellContainer.addEventListener(MouseEvent.MOUSE_MOVE,this.ContainerMove);
      }
      
      private function ContainerMove(param1:MouseEvent = null) : void
      {
         var _loc2_:Point = new Point(int(this._containerClickPoint.x - this._mouseClickPoint.x + this.mouseX),int(this._containerClickPoint.y - this._mouseClickPoint.y + this.mouseY));
         if(this._cellContainer.x != _loc2_.x || this._cellContainer.y != _loc2_.y)
         {
            this._cellContainer.x = _loc2_.x;
            this._cellContainer.y = _loc2_.y;
         }
         if(Point.distance(this._containerStartPoint,new Point(this._cellContainer.x,this._cellContainer.y)) > 10)
         {
            this._dragged = true;
            this.HideBubble();
         }
         this.Update();
      }
      
      private function ContainerRelease(param1:MouseEvent) : void
      {
         if(this._cellContainer)
         {
            this._cellContainer.removeEventListener(MouseEvent.MOUSE_MOVE,this.ContainerMove);
         }
         this._dragged = false;
      }
      
      public function Tick() : void
      {
         var _loc1_:MapRoomCell = null;
         this.UpdateResourceDisplay();
         for each(_loc1_ in this._cells)
         {
            _loc1_.Tick();
         }
         this.Update();
      }
      
      public function Check() : void
      {
         var _loc1_:MapRoomCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.Check();
         }
      }
      
      public function Update(param1:Boolean = false) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:MapRoomCell = null;
         var _loc7_:int = 0;
         var _loc8_:MapRoomCell = null;
         var _loc9_:Boolean = false;
         var _loc10_:MapRoomCell = null;
         var _loc11_:Number = NaN;
         var _loc2_:int = getTimer();
         if(this._fullScreen && GLOBAL._ROOT.stage.displayState == StageDisplayState.NORMAL)
         {
            MapRoomManager.instance.ResizeHandler();
            this._fullScreen = false;
            return;
         }
         if((!this._fallbackHomeCell._updated || param1) && this._fallbackHomeCell._dataAge <= 0)
         {
            if(_loc5_ = MapRoom.GetCell(this._fallbackHomeCell.X,this._fallbackHomeCell.Y))
            {
               this._fallbackHomeCell.Setup(_loc5_);
            }
         }
         this._sortArray = [];
         for each(_loc6_ in this._cells)
         {
            _loc3_ = false;
            if(this._cellContainer.x + _loc6_.x > this._cellCountX * (this._cellWidth * 0.75) - this._cellWidth * 0.75 * 5)
            {
               _loc6_.x -= this._cellCountX * (this._cellWidth * 0.75);
               _loc6_.X -= this._cellCountX;
               if(_loc6_.X < 0)
               {
                  _loc6_.X += MapRoom._mapWidth;
               }
               _loc3_ = true;
            }
            if(this._cellContainer.y + _loc6_.y > this._cellCountY * this._cellHeight - this._cellHeight * 5)
            {
               _loc6_.y -= this._cellCountY * this._cellHeight;
               _loc6_.Y -= this._cellCountY;
               if(_loc6_.Y < 0)
               {
                  _loc6_.Y += MapRoom._mapHeight;
               }
               _loc3_ = true;
            }
            if(this._cellContainer.x + _loc6_.x < -(this._cellWidth * 0.75 * 5))
            {
               _loc6_.x += this._cellCountX * (this._cellWidth * 0.75);
               _loc6_.X += this._cellCountX;
               if(_loc6_.X > MapRoom._mapWidth - 1)
               {
                  _loc6_.X -= MapRoom._mapWidth;
               }
               _loc3_ = true;
            }
            if(this._cellContainer.y + _loc6_.y < -(this._cellHeight * 5))
            {
               _loc6_.y += this._cellCountY * this._cellHeight;
               _loc6_.Y += this._cellCountY;
               if(_loc6_.Y > MapRoom._mapHeight - 1)
               {
                  _loc6_.Y -= MapRoom._mapHeight;
               }
               _loc3_ = true;
            }
            if(_loc6_.X < 0)
            {
               _loc6_.X += MapRoom._mapWidth;
               _loc3_ = true;
            }
            if(_loc6_.Y < 0)
            {
               _loc6_.Y += MapRoom._mapHeight;
               _loc3_ = true;
            }
            if(_loc6_.X >= MapRoom._mapWidth)
            {
               _loc6_.X -= MapRoom._mapWidth;
               _loc3_ = true;
            }
            if(_loc6_.Y >= MapRoom._mapHeight)
            {
               _loc6_.Y -= MapRoom._mapHeight;
               _loc3_ = true;
            }
            if(_loc3_)
            {
               _loc6_.mc.gotoAndStop(1);
               _loc6_.mc.y = 18;
               _loc6_.mc.mcPlayer.visible = false;
               _loc6_._updated = false;
               _loc6_._dataAge = 0;
               _loc4_ = true;
            }
            if((!_loc6_._updated || param1) && _loc6_._dataAge <= 0)
            {
               if(_loc5_ = MapRoom.GetCell(_loc6_.X,_loc6_.Y))
               {
                  _loc6_.Setup(_loc5_);
               }
            }
            _loc6_.depth = _loc6_.y * 1000 + _loc6_.x;
            this._sortArray.push(_loc6_);
         }
         if(_loc4_)
         {
            this._sortArray.sortOn("depth",Array.NUMERIC);
            _loc7_ = 0;
            while(_loc7_ < this._sortArray.length)
            {
               if(this._cellContainer.getChildIndex(this._sortArray[_loc7_]) != _loc7_)
               {
                  this._cellContainer.setChildIndex(this._sortArray[_loc7_],_loc7_);
               }
               _loc7_++;
            }
         }
         if(Boolean(this._popupInfoMine) && Boolean(this._popupInfoMine.parent))
         {
            this._popupInfoMine.Update();
         }
         if(Boolean(this._popupAttackA) && Boolean(this._popupAttackA.parent))
         {
            this._popupAttackA.Update();
         }
         if(!this._dragged)
         {
            for each(_loc8_ in this._cells)
            {
               if(!_loc8_._over)
               {
                  _loc8_.mc.mcGlow.alpha = 0;
               }
               else
               {
                  _loc8_.mc.mcGlow.alpha = 0.5;
               }
               _loc8_._inRange = false;
            }
         }
         if(!MapRoom._viewOnly)
         {
            _loc9_ = false;
            for each(_loc10_ in this._cells)
            {
               if(_loc10_._mine && _loc10_._flingerRange.Get() > 0 && _loc10_._base > 0)
               {
                  _loc11_ = POWERUPS.Apply(POWERUPS.ALLIANCE_DECLAREWAR,[_loc10_._flingerRange.Get()]);
                  this.ShowRange(_loc10_,_loc11_);
                  if(_loc10_.X == GLOBAL._mapHome.x && _loc10_.y == GLOBAL._mapHome.y)
                  {
                     _loc9_ = true;
                  }
               }
            }
            if(!_loc9_ && this._fallbackHomeCell._mine && this._fallbackHomeCell._base > 0)
            {
               this.ShowRange(this._fallbackHomeCell,POWERUPS.Apply(POWERUPS.ALLIANCE_DECLAREWAR,[this._fallbackHomeCell._flingerRange.Get()]));
            }
         }
         if(MapRoom._bookmarks.length > 0 || MapRoom._viewOnly)
         {
            this.bBookmarks.Enabled = true;
         }
         else
         {
            this.bBookmarks.Enabled = false;
         }
         this.DisplayBuffs();
      }
      
      public function ShowBubble(param1:MapRoomCell) : void
      {
      }
      
      public function HideBubble() : void
      {
         if(this._bubble.parent)
         {
            this._bubble.parent.removeChild(this._bubble);
         }
      }
      
      public function ShowRange(param1:MapRoomCell, param2:int) : void
      {
         var _loc3_:CellData = null;
         var _loc4_:Vector.<CellData> = null;
         var _loc5_:MapRoomCell = null;
         if(!this._dragged)
         {
            if(param1._water == 0)
            {
               if(!param1._over)
               {
                  param1.mc.mcGlow.alpha = 0.5;
               }
               param1._inRange = true;
               _loc4_ = this.GetCellsInRange(param1.X,param1.Y,param2);
               for each(_loc3_ in _loc4_)
               {
                  if(Boolean(_loc5_ = _loc3_.cell as MapRoomCell) && !_loc5_._water)
                  {
                     if(!_loc5_._over)
                     {
                        if(_loc3_.range <= 10)
                        {
                           _loc5_.mc.mcGlow.alpha = 0.5;
                        }
                        else
                        {
                           _loc5_.mc.mcGlow.alpha = Math.max(_loc5_.mc.mcGlow.alpha,0.35);
                        }
                     }
                     _loc5_._inRange = true;
                  }
               }
            }
         }
      }
      
      public function GetCellsInRange(param1:int, param2:int, param3:int) : Vector.<CellData>
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:Vector.<CellData> = new Vector.<CellData>(3 * param3 * (param3 + 1),true);
         var _loc5_:int = 0;
         if(param1 % 2 != 0)
         {
            if(param3 >= 1)
            {
               _loc4_[0] = new CellData(this.GetCell(param1 - 1,param2),1);
               _loc4_[1] = new CellData(this.GetCell(param1,param2 - 1),1);
               _loc4_[2] = new CellData(this.GetCell(param1 + 1,param2 + 1),1);
               _loc4_[3] = new CellData(this.GetCell(param1 - 1,param2 + 1),1);
               _loc4_[4] = new CellData(this.GetCell(param1,param2 + 1),1);
               _loc4_[5] = new CellData(this.GetCell(param1 + 1,param2),1);
            }
            if(param3 >= 2)
            {
               _loc4_[6] = new CellData(this.GetCell(param1,param2 - 2),2);
               _loc4_[7] = new CellData(this.GetCell(param1 + 1,param2 - 1),2);
               _loc4_[8] = new CellData(this.GetCell(param1 + 2,param2 - 1),2);
               _loc4_[9] = new CellData(this.GetCell(param1 + 2,param2),2);
               _loc4_[10] = new CellData(this.GetCell(param1 + 2,param2 + 1),2);
               _loc4_[11] = new CellData(this.GetCell(param1 + 1,param2 + 2),2);
               _loc4_[12] = new CellData(this.GetCell(param1,param2 + 2),2);
               _loc4_[13] = new CellData(this.GetCell(param1 - 1,param2 + 2),2);
               _loc4_[14] = new CellData(this.GetCell(param1 - 2,param2 + 1),2);
               _loc4_[15] = new CellData(this.GetCell(param1 - 2,param2),2);
               _loc4_[16] = new CellData(this.GetCell(param1 - 2,param2 - 1),2);
               _loc4_[17] = new CellData(this.GetCell(param1 - 1,param2 - 1),2);
            }
            if(param3 >= 3)
            {
               _loc4_[18] = new CellData(this.GetCell(param1,param2 - 3),3);
               _loc4_[19] = new CellData(this.GetCell(param1 + 1,param2 - 2),3);
               _loc4_[20] = new CellData(this.GetCell(param1 + 2,param2 - 2),3);
               _loc4_[21] = new CellData(this.GetCell(param1 + 3,param2 - 1),3);
               _loc4_[22] = new CellData(this.GetCell(param1 + 3,param2),3);
               _loc4_[23] = new CellData(this.GetCell(param1 + 3,param2 + 1),3);
               _loc4_[24] = new CellData(this.GetCell(param1 + 3,param2 + 2),3);
               _loc4_[25] = new CellData(this.GetCell(param1 + 2,param2 + 2),3);
               _loc4_[26] = new CellData(this.GetCell(param1 + 1,param2 + 3),3);
               _loc4_[27] = new CellData(this.GetCell(param1,param2 + 3),3);
               _loc4_[28] = new CellData(this.GetCell(param1 - 1,param2 + 3),3);
               _loc4_[29] = new CellData(this.GetCell(param1 - 2,param2 + 2),3);
               _loc4_[30] = new CellData(this.GetCell(param1 - 3,param2 + 2),3);
               _loc4_[31] = new CellData(this.GetCell(param1 - 3,param2 + 1),3);
               _loc4_[32] = new CellData(this.GetCell(param1 - 3,param2),3);
               _loc4_[33] = new CellData(this.GetCell(param1 - 3,param2 - 1),3);
               _loc4_[34] = new CellData(this.GetCell(param1 - 2,param2 - 2),3);
               _loc4_[35] = new CellData(this.GetCell(param1 - 1,param2 - 2),3);
            }
            if(param3 >= 4)
            {
               _loc4_[36] = new CellData(this.GetCell(param1,param2 - 4),4);
               _loc4_[37] = new CellData(this.GetCell(param1 - 1,param2 - 3),4);
               _loc4_[38] = new CellData(this.GetCell(param1 - 2,param2 - 3),4);
               _loc4_[39] = new CellData(this.GetCell(param1 - 3,param2 - 2),4);
               _loc4_[40] = new CellData(this.GetCell(param1 - 4,param2 - 2),4);
               _loc4_[41] = new CellData(this.GetCell(param1 - 4,param2 - 1),4);
               _loc4_[42] = new CellData(this.GetCell(param1 - 4,param2),4);
               _loc4_[43] = new CellData(this.GetCell(param1 - 4,param2 + 1),4);
               _loc4_[44] = new CellData(this.GetCell(param1 - 4,param2 + 2),4);
               _loc4_[45] = new CellData(this.GetCell(param1 - 3,param2 + 3),4);
               _loc4_[46] = new CellData(this.GetCell(param1 - 2,param2 + 3),4);
               _loc4_[47] = new CellData(this.GetCell(param1 - 1,param2 + 4),4);
               _loc4_[48] = new CellData(this.GetCell(param1,param2 + 4),4);
               _loc4_[49] = new CellData(this.GetCell(param1 + 1,param2 + 4),4);
               _loc4_[50] = new CellData(this.GetCell(param1 + 2,param2 + 3),4);
               _loc4_[51] = new CellData(this.GetCell(param1 + 3,param2 + 3),4);
               _loc4_[52] = new CellData(this.GetCell(param1 + 4,param2 + 2),4);
               _loc4_[53] = new CellData(this.GetCell(param1 + 4,param2 + 1),4);
               _loc4_[54] = new CellData(this.GetCell(param1 + 4,param2),4);
               _loc4_[55] = new CellData(this.GetCell(param1 + 4,param2 - 1),4);
               _loc4_[56] = new CellData(this.GetCell(param1 + 4,param2 - 2),4);
               _loc4_[57] = new CellData(this.GetCell(param1 + 3,param2 - 2),4);
               _loc4_[58] = new CellData(this.GetCell(param1 + 2,param2 - 3),4);
               _loc4_[59] = new CellData(this.GetCell(param1 + 1,param2 - 3),4);
            }
            if(param3 >= 5)
            {
               _loc4_[60] = new CellData(this.GetCell(param1 + 0,param2 - 5),5);
               _loc4_[61] = new CellData(this.GetCell(param1 - 1,param2 - 4),5);
               _loc4_[62] = new CellData(this.GetCell(param1 - 2,param2 - 4),5);
               _loc4_[63] = new CellData(this.GetCell(param1 - 3,param2 - 3),5);
               _loc4_[64] = new CellData(this.GetCell(param1 - 4,param2 - 3),5);
               _loc4_[65] = new CellData(this.GetCell(param1 - 5,param2 - 2),5);
               _loc4_[66] = new CellData(this.GetCell(param1 - 5,param2 - 1),5);
               _loc4_[67] = new CellData(this.GetCell(param1 - 5,param2 + 0),5);
               _loc4_[68] = new CellData(this.GetCell(param1 - 5,param2 + 1),5);
               _loc4_[69] = new CellData(this.GetCell(param1 - 5,param2 + 2),5);
               _loc4_[70] = new CellData(this.GetCell(param1 - 5,param2 + 3),5);
               _loc4_[71] = new CellData(this.GetCell(param1 - 4,param2 + 3),5);
               _loc4_[72] = new CellData(this.GetCell(param1 - 3,param2 + 4),5);
               _loc4_[73] = new CellData(this.GetCell(param1 - 2,param2 + 4),5);
               _loc4_[74] = new CellData(this.GetCell(param1 - 1,param2 + 5),5);
               _loc4_[75] = new CellData(this.GetCell(param1 + 0,param2 + 5),5);
               _loc4_[76] = new CellData(this.GetCell(param1 + 1,param2 + 5),5);
               _loc4_[77] = new CellData(this.GetCell(param1 + 2,param2 + 4),5);
               _loc4_[78] = new CellData(this.GetCell(param1 + 3,param2 + 4),5);
               _loc4_[79] = new CellData(this.GetCell(param1 + 4,param2 + 3),5);
               _loc4_[80] = new CellData(this.GetCell(param1 + 5,param2 + 3),5);
               _loc4_[81] = new CellData(this.GetCell(param1 + 5,param2 + 2),5);
               _loc4_[82] = new CellData(this.GetCell(param1 + 5,param2 + 1),5);
               _loc4_[83] = new CellData(this.GetCell(param1 + 5,param2 + 0),5);
               _loc4_[84] = new CellData(this.GetCell(param1 + 5,param2 - 1),5);
               _loc4_[85] = new CellData(this.GetCell(param1 + 5,param2 - 2),5);
               _loc4_[86] = new CellData(this.GetCell(param1 + 4,param2 - 3),5);
               _loc4_[87] = new CellData(this.GetCell(param1 + 3,param2 - 3),5);
               _loc4_[88] = new CellData(this.GetCell(param1 + 2,param2 - 4),5);
               _loc4_[89] = new CellData(this.GetCell(param1 + 1,param2 - 4),5);
            }
            if(param3 >= 6)
            {
               _loc4_[90] = new CellData(this.GetCell(param1 + 0,param2 - 6),6);
               _loc4_[91] = new CellData(this.GetCell(param1 - 1,param2 - 5),6);
               _loc4_[92] = new CellData(this.GetCell(param1 - 2,param2 - 5),6);
               _loc4_[93] = new CellData(this.GetCell(param1 - 3,param2 - 4),6);
               _loc4_[94] = new CellData(this.GetCell(param1 - 4,param2 - 4),6);
               _loc4_[95] = new CellData(this.GetCell(param1 - 5,param2 - 3),6);
               _loc4_[96] = new CellData(this.GetCell(param1 - 6,param2 - 3),6);
               _loc4_[97] = new CellData(this.GetCell(param1 - 6,param2 - 2),6);
               _loc4_[98] = new CellData(this.GetCell(param1 - 6,param2 - 1),6);
               _loc4_[99] = new CellData(this.GetCell(param1 - 6,param2 + 0),6);
               _loc4_[100] = new CellData(this.GetCell(param1 - 6,param2 + 1),6);
               _loc4_[101] = new CellData(this.GetCell(param1 - 6,param2 + 2),6);
               _loc4_[102] = new CellData(this.GetCell(param1 - 6,param2 + 3),6);
               _loc4_[103] = new CellData(this.GetCell(param1 - 5,param2 + 4),6);
               _loc4_[104] = new CellData(this.GetCell(param1 - 4,param2 + 4),6);
               _loc4_[105] = new CellData(this.GetCell(param1 - 3,param2 + 5),6);
               _loc4_[106] = new CellData(this.GetCell(param1 - 2,param2 + 5),6);
               _loc4_[107] = new CellData(this.GetCell(param1 - 1,param2 + 6),6);
               _loc4_[108] = new CellData(this.GetCell(param1 + 0,param2 + 6),6);
               _loc4_[109] = new CellData(this.GetCell(param1 + 1,param2 + 6),6);
               _loc4_[110] = new CellData(this.GetCell(param1 + 2,param2 + 5),6);
               _loc4_[111] = new CellData(this.GetCell(param1 + 3,param2 + 5),6);
               _loc4_[112] = new CellData(this.GetCell(param1 + 4,param2 + 4),6);
               _loc4_[113] = new CellData(this.GetCell(param1 + 5,param2 + 4),6);
               _loc4_[114] = new CellData(this.GetCell(param1 + 6,param2 + 3),6);
               _loc4_[115] = new CellData(this.GetCell(param1 + 6,param2 + 2),6);
               _loc4_[116] = new CellData(this.GetCell(param1 + 6,param2 + 1),6);
               _loc4_[117] = new CellData(this.GetCell(param1 + 6,param2 + 0),6);
               _loc4_[118] = new CellData(this.GetCell(param1 + 6,param2 - 1),6);
               _loc4_[119] = new CellData(this.GetCell(param1 + 6,param2 - 2),6);
               _loc4_[120] = new CellData(this.GetCell(param1 + 6,param2 - 3),6);
               _loc4_[121] = new CellData(this.GetCell(param1 + 5,param2 - 3),6);
               _loc4_[122] = new CellData(this.GetCell(param1 + 4,param2 - 4),6);
               _loc4_[123] = new CellData(this.GetCell(param1 + 3,param2 - 4),6);
               _loc4_[124] = new CellData(this.GetCell(param1 + 2,param2 - 5),6);
               _loc4_[125] = new CellData(this.GetCell(param1 + 1,param2 - 5),6);
            }
            _loc6_ = 7;
            _loc5_ = 126;
            while(_loc6_ <= param3)
            {
               _loc8_ = (_loc7_ = param2 + Math.ceil(-_loc6_ / 2)) + _loc6_;
               while(_loc7_ < _loc8_)
               {
                  var _loc9_:*;
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 + _loc6_,_loc7_),_loc6_);
                  _loc7_++;
               }
               _loc8_ = (_loc7_ = param2 + Math.ceil(_loc6_ / 2)) - _loc6_;
               while(_loc7_ > _loc8_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 - _loc6_,_loc7_),_loc6_);
                  _loc7_--;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 - _loc6_ + _loc7_,param2 + Math.ceil(-(_loc6_ + _loc7_) / 2)),_loc6_);
                  _loc7_++;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 + _loc7_,param2 - _loc6_ + Math.ceil(_loc7_ / 2)),_loc6_);
                  _loc7_++;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 + _loc6_ - _loc7_,param2 + Math.ceil((_loc6_ + _loc7_) / 2)),_loc6_);
                  _loc7_++;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 - _loc7_,param2 + _loc6_ + Math.ceil(-_loc7_ / 2)),_loc6_);
                  _loc7_++;
               }
               _loc6_++;
            }
         }
         else
         {
            if(param3 >= 1)
            {
               _loc4_[0] = new CellData(this.GetCell(param1 - 1,param2 - 1),1);
               _loc4_[1] = new CellData(this.GetCell(param1,param2 - 1),1);
               _loc4_[2] = new CellData(this.GetCell(param1 + 1,param2 - 1),1);
               _loc4_[3] = new CellData(this.GetCell(param1 - 1,param2),1);
               _loc4_[4] = new CellData(this.GetCell(param1,param2 + 1),1);
               _loc4_[5] = new CellData(this.GetCell(param1 + 1,param2),1);
            }
            if(param3 >= 2)
            {
               _loc4_[6] = new CellData(this.GetCell(param1,param2 - 2),2);
               _loc4_[7] = new CellData(this.GetCell(param1 + 1,param2 - 2),2);
               _loc4_[8] = new CellData(this.GetCell(param1 + 2,param2 - 1),2);
               _loc4_[9] = new CellData(this.GetCell(param1 + 2,param2),2);
               _loc4_[10] = new CellData(this.GetCell(param1 + 2,param2 + 1),2);
               _loc4_[11] = new CellData(this.GetCell(param1 + 1,param2 + 1),2);
               _loc4_[12] = new CellData(this.GetCell(param1,param2 + 2),2);
               _loc4_[13] = new CellData(this.GetCell(param1 - 1,param2 + 1),2);
               _loc4_[14] = new CellData(this.GetCell(param1 - 2,param2 + 1),2);
               _loc4_[15] = new CellData(this.GetCell(param1 - 2,param2),2);
               _loc4_[16] = new CellData(this.GetCell(param1 - 2,param2 - 1),2);
               _loc4_[17] = new CellData(this.GetCell(param1 - 1,param2 - 2),2);
            }
            if(param3 >= 3)
            {
               _loc4_[18] = new CellData(this.GetCell(param1,param2 - 3),3);
               _loc4_[19] = new CellData(this.GetCell(param1 + 1,param2 - 3),3);
               _loc4_[20] = new CellData(this.GetCell(param1 + 2,param2 - 2),3);
               _loc4_[21] = new CellData(this.GetCell(param1 + 3,param2 - 2),3);
               _loc4_[22] = new CellData(this.GetCell(param1 + 3,param2 - 1),3);
               _loc4_[23] = new CellData(this.GetCell(param1 + 3,param2),3);
               _loc4_[24] = new CellData(this.GetCell(param1 + 3,param2 + 1),3);
               _loc4_[25] = new CellData(this.GetCell(param1 + 2,param2 + 2),3);
               _loc4_[26] = new CellData(this.GetCell(param1 + 1,param2 + 2),3);
               _loc4_[27] = new CellData(this.GetCell(param1,param2 + 3),3);
               _loc4_[28] = new CellData(this.GetCell(param1 - 1,param2 + 2),3);
               _loc4_[29] = new CellData(this.GetCell(param1 - 2,param2 + 2),3);
               _loc4_[30] = new CellData(this.GetCell(param1 - 3,param2 + 1),3);
               _loc4_[31] = new CellData(this.GetCell(param1 - 3,param2),3);
               _loc4_[32] = new CellData(this.GetCell(param1 - 3,param2 - 1),3);
               _loc4_[33] = new CellData(this.GetCell(param1 - 3,param2 - 2),3);
               _loc4_[34] = new CellData(this.GetCell(param1 - 2,param2 - 2),3);
               _loc4_[35] = new CellData(this.GetCell(param1 - 1,param2 - 3),3);
            }
            if(param3 >= 4)
            {
               _loc4_[36] = new CellData(this.GetCell(param1,param2 - 4),4);
               _loc4_[37] = new CellData(this.GetCell(param1 - 1,param2 - 4),4);
               _loc4_[38] = new CellData(this.GetCell(param1 - 2,param2 - 3),4);
               _loc4_[39] = new CellData(this.GetCell(param1 - 3,param2 - 3),4);
               _loc4_[40] = new CellData(this.GetCell(param1 - 4,param2 - 2),4);
               _loc4_[41] = new CellData(this.GetCell(param1 - 4,param2 - 1),4);
               _loc4_[42] = new CellData(this.GetCell(param1 - 4,param2 - 0),4);
               _loc4_[43] = new CellData(this.GetCell(param1 - 4,param2 + 1),4);
               _loc4_[44] = new CellData(this.GetCell(param1 - 4,param2 + 2),4);
               _loc4_[45] = new CellData(this.GetCell(param1 - 3,param2 + 2),4);
               _loc4_[46] = new CellData(this.GetCell(param1 - 2,param2 + 3),4);
               _loc4_[47] = new CellData(this.GetCell(param1 - 1,param2 + 3),4);
               _loc4_[48] = new CellData(this.GetCell(param1,param2 + 4),4);
               _loc4_[49] = new CellData(this.GetCell(param1 + 1,param2 + 3),4);
               _loc4_[50] = new CellData(this.GetCell(param1 + 2,param2 + 3),4);
               _loc4_[51] = new CellData(this.GetCell(param1 + 3,param2 + 2),4);
               _loc4_[52] = new CellData(this.GetCell(param1 + 4,param2 + 2),4);
               _loc4_[53] = new CellData(this.GetCell(param1 + 4,param2 + 1),4);
               _loc4_[54] = new CellData(this.GetCell(param1 + 4,param2),4);
               _loc4_[55] = new CellData(this.GetCell(param1 + 4,param2 - 1),4);
               _loc4_[56] = new CellData(this.GetCell(param1 + 4,param2 - 2),4);
               _loc4_[57] = new CellData(this.GetCell(param1 + 3,param2 - 3),4);
               _loc4_[58] = new CellData(this.GetCell(param1 + 2,param2 - 3),4);
               _loc4_[59] = new CellData(this.GetCell(param1 + 1,param2 - 4),4);
            }
            if(param3 >= 5)
            {
               _loc4_[60] = new CellData(this.GetCell(param1 + 0,param2 - 5),5);
               _loc4_[61] = new CellData(this.GetCell(param1 - 1,param2 - 5),5);
               _loc4_[62] = new CellData(this.GetCell(param1 - 2,param2 - 4),5);
               _loc4_[63] = new CellData(this.GetCell(param1 - 3,param2 - 4),5);
               _loc4_[64] = new CellData(this.GetCell(param1 - 4,param2 - 3),5);
               _loc4_[65] = new CellData(this.GetCell(param1 - 5,param2 - 3),5);
               _loc4_[66] = new CellData(this.GetCell(param1 - 5,param2 - 2),5);
               _loc4_[67] = new CellData(this.GetCell(param1 - 5,param2 - 1),5);
               _loc4_[68] = new CellData(this.GetCell(param1 - 5,param2 + 0),5);
               _loc4_[69] = new CellData(this.GetCell(param1 - 5,param2 + 1),5);
               _loc4_[70] = new CellData(this.GetCell(param1 - 5,param2 + 2),5);
               _loc4_[71] = new CellData(this.GetCell(param1 - 4,param2 + 3),5);
               _loc4_[72] = new CellData(this.GetCell(param1 - 3,param2 + 3),5);
               _loc4_[73] = new CellData(this.GetCell(param1 - 2,param2 + 4),5);
               _loc4_[74] = new CellData(this.GetCell(param1 - 1,param2 + 4),5);
               _loc4_[75] = new CellData(this.GetCell(param1 + 0,param2 + 5),5);
               _loc4_[76] = new CellData(this.GetCell(param1 + 1,param2 + 4),5);
               _loc4_[77] = new CellData(this.GetCell(param1 + 2,param2 + 4),5);
               _loc4_[78] = new CellData(this.GetCell(param1 + 3,param2 + 3),5);
               _loc4_[79] = new CellData(this.GetCell(param1 + 4,param2 + 3),5);
               _loc4_[80] = new CellData(this.GetCell(param1 + 5,param2 + 2),5);
               _loc4_[81] = new CellData(this.GetCell(param1 + 5,param2 + 1),5);
               _loc4_[82] = new CellData(this.GetCell(param1 + 5,param2 + 0),5);
               _loc4_[83] = new CellData(this.GetCell(param1 + 5,param2 - 1),5);
               _loc4_[84] = new CellData(this.GetCell(param1 + 5,param2 - 2),5);
               _loc4_[85] = new CellData(this.GetCell(param1 + 5,param2 - 3),5);
               _loc4_[86] = new CellData(this.GetCell(param1 + 4,param2 - 3),5);
               _loc4_[87] = new CellData(this.GetCell(param1 + 3,param2 - 4),5);
               _loc4_[88] = new CellData(this.GetCell(param1 + 2,param2 - 4),5);
               _loc4_[89] = new CellData(this.GetCell(param1 + 1,param2 - 5),5);
            }
            if(param3 >= 6)
            {
               _loc4_[90] = new CellData(this.GetCell(param1 + 0,param2 - 6),6);
               _loc4_[91] = new CellData(this.GetCell(param1 - 1,param2 - 6),6);
               _loc4_[92] = new CellData(this.GetCell(param1 - 2,param2 - 5),6);
               _loc4_[93] = new CellData(this.GetCell(param1 - 3,param2 - 5),6);
               _loc4_[94] = new CellData(this.GetCell(param1 - 4,param2 - 4),6);
               _loc4_[95] = new CellData(this.GetCell(param1 - 5,param2 - 4),6);
               _loc4_[96] = new CellData(this.GetCell(param1 - 6,param2 - 3),6);
               _loc4_[97] = new CellData(this.GetCell(param1 - 6,param2 - 2),6);
               _loc4_[98] = new CellData(this.GetCell(param1 - 6,param2 - 1),6);
               _loc4_[99] = new CellData(this.GetCell(param1 - 6,param2 + 0),6);
               _loc4_[100] = new CellData(this.GetCell(param1 - 6,param2 + 1),6);
               _loc4_[101] = new CellData(this.GetCell(param1 - 6,param2 + 2),6);
               _loc4_[102] = new CellData(this.GetCell(param1 - 6,param2 + 3),6);
               _loc4_[103] = new CellData(this.GetCell(param1 - 5,param2 + 3),6);
               _loc4_[104] = new CellData(this.GetCell(param1 - 4,param2 + 4),6);
               _loc4_[105] = new CellData(this.GetCell(param1 - 3,param2 + 4),6);
               _loc4_[106] = new CellData(this.GetCell(param1 - 2,param2 + 5),6);
               _loc4_[107] = new CellData(this.GetCell(param1 - 1,param2 + 5),6);
               _loc4_[108] = new CellData(this.GetCell(param1 + 0,param2 + 6),6);
               _loc4_[109] = new CellData(this.GetCell(param1 + 1,param2 + 5),6);
               _loc4_[110] = new CellData(this.GetCell(param1 + 2,param2 + 5),6);
               _loc4_[111] = new CellData(this.GetCell(param1 + 3,param2 + 4),6);
               _loc4_[112] = new CellData(this.GetCell(param1 + 4,param2 + 4),6);
               _loc4_[113] = new CellData(this.GetCell(param1 + 5,param2 + 3),6);
               _loc4_[114] = new CellData(this.GetCell(param1 + 6,param2 + 3),6);
               _loc4_[115] = new CellData(this.GetCell(param1 + 6,param2 + 2),6);
               _loc4_[116] = new CellData(this.GetCell(param1 + 6,param2 + 1),6);
               _loc4_[117] = new CellData(this.GetCell(param1 + 6,param2 + 0),6);
               _loc4_[118] = new CellData(this.GetCell(param1 + 6,param2 - 1),6);
               _loc4_[119] = new CellData(this.GetCell(param1 + 6,param2 - 2),6);
               _loc4_[120] = new CellData(this.GetCell(param1 + 6,param2 - 3),6);
               _loc4_[121] = new CellData(this.GetCell(param1 + 5,param2 - 4),6);
               _loc4_[122] = new CellData(this.GetCell(param1 + 4,param2 - 4),6);
               _loc4_[123] = new CellData(this.GetCell(param1 + 3,param2 - 5),6);
               _loc4_[124] = new CellData(this.GetCell(param1 + 2,param2 - 5),6);
               _loc4_[125] = new CellData(this.GetCell(param1 + 1,param2 - 6),6);
            }
            _loc6_ = 7;
            _loc5_ = 126;
            while(_loc6_ <= param3)
            {
               _loc8_ = (_loc7_ = param2 + Math.floor(-_loc6_ / 2)) + _loc6_;
               while(_loc7_ < _loc8_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 + _loc6_,_loc7_),_loc6_);
                  _loc7_++;
               }
               _loc8_ = (_loc7_ = param2 + Math.floor(_loc6_ / 2)) - _loc6_;
               while(_loc7_ > _loc8_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 - _loc6_,_loc7_),_loc6_);
                  _loc7_--;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 - _loc6_ + _loc7_,param2 + Math.floor(-(_loc6_ + _loc7_) / 2)),_loc6_);
                  _loc7_++;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 + _loc7_,param2 - _loc6_ + Math.floor(_loc7_ / 2)),_loc6_);
                  _loc7_++;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 + _loc6_ - _loc7_,param2 + Math.floor((_loc6_ + _loc7_) / 2)),_loc6_);
                  _loc7_++;
               }
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_[_loc9_ = _loc5_++] = new CellData(this.GetCell(param1 - _loc7_,param2 + _loc6_ + Math.floor(-_loc7_ / 2)),_loc6_);
                  _loc7_++;
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      private function GetCell(param1:int, param2:int) : MapRoomCell
      {
         var _loc3_:MapRoomCell = null;
         if(param1 >= MapRoom._mapWidth)
         {
            param1 -= MapRoom._mapWidth;
         }
         else if(param1 < 0)
         {
            param1 = MapRoom._mapWidth + param1;
         }
         if(param2 >= MapRoom._mapHeight)
         {
            param2 -= MapRoom._mapHeight;
         }
         else if(param2 < 0)
         {
            param2 = MapRoom._mapHeight + param2;
         }
         for each(_loc3_ in this._cells)
         {
            if(_loc3_.X == param1 && _loc3_.Y == param2)
            {
               return _loc3_;
            }
         }
         if(this._fallbackHomeCell.X == param1 && this._fallbackHomeCell.Y == param2)
         {
            return this._fallbackHomeCell;
         }
         return null;
      }
      
      public function ShowInfoMine(param1:MapRoomCell) : void
      {
         this.HideBookmarkMenu();
         if(!this._dragged)
         {
            SOUNDS.Play("click1");
            this.HideBubble();
            this._popupInfoMine.Setup(param1);
            GLOBAL.BlockerAdd(this);
            this.addChild(this._popupInfoMine);
         }
         this._dragged = false;
      }
      
      public function HideInfoMine() : void
      {
         GLOBAL.BlockerRemove();
         if(this._popupInfoMine.parent)
         {
            this._popupInfoMine.parent.removeChild(this._popupInfoMine);
         }
         SOUNDS.Play("close");
      }
      
      public function ShowInfoEnemy(param1:MapRoomCell, param2:Boolean = false) : void
      {
         this.HideBookmarkMenu();
         if(!this._dragged)
         {
            SOUNDS.Play("click1");
            this.HideBubble();
            this._popupInfoEnemy.Setup(param1,param2);
            GLOBAL.BlockerAdd(this);
            this.addChild(this._popupInfoEnemy);
         }
         this._dragged = false;
      }
      
      public function HideInfoEnemy() : void
      {
         GLOBAL.BlockerRemove();
         if(this._popupInfoEnemy.parent)
         {
            this._popupInfoEnemy.parent.removeChild(this._popupInfoEnemy);
         }
         SOUNDS.Play("close");
      }
      
      public function ShowInfoViewOnly(param1:MapRoomCell, param2:Boolean = false) : void
      {
         if(!this._dragged)
         {
            SOUNDS.Play("click1");
            this._popupInfoViewOnly.Setup(param1,param2);
            GLOBAL.BlockerAdd(this);
            this.addChild(this._popupInfoViewOnly);
         }
         this._dragged = false;
      }
      
      public function HideInfoViewOnly() : void
      {
         GLOBAL.BlockerRemove();
         if(this._popupInfoViewOnly.parent)
         {
            this._popupInfoViewOnly.parent.removeChild(this._popupInfoViewOnly);
         }
         SOUNDS.Play("close");
      }
      
      public function ShowInfoDestroyed(param1:MapRoomCell) : void
      {
         this.HideBookmarkMenu();
         if(!this._dragged)
         {
            SOUNDS.Play("click1");
            this.HideBubble();
            param1._destroyed = 1;
            this._popupInfoEnemy.Setup(param1);
            GLOBAL.BlockerAdd(this);
            this.addChild(this._popupInfoEnemy);
         }
         this._dragged = false;
      }
      
      public function HideTransferB() : void
      {
      }
      
      public function ShowMonstersA(param1:MapRoomCell, param2:Boolean = false) : void
      {
         SOUNDS.Play("click1");
         this.HideBookmarkMenu();
         this.HideInfoMine();
         this._popupMonsters.Setup(param1,param2);
         GLOBAL.BlockerAdd(this);
         this.addChild(this._popupMonsters);
      }
      
      public function HideMonstersA() : void
      {
         if(this._popupMonsters.parent)
         {
            this._popupMonsters.parent.removeChild(this._popupMonsters);
         }
         GLOBAL.BlockerRemove();
         SOUNDS.Play("close");
      }
      
      public function ShowMonstersB(param1:Object, param2:MapRoomCell) : void
      {
         SOUNDS.Play("click1");
         this.HideBookmarkMenu();
         this._popupMonstersB.Setup(param1,param2);
         GLOBAL.BlockerAdd(this);
         this.addChild(this._popupMonstersB);
      }
      
      public function HideMonstersB() : void
      {
         GLOBAL.BlockerRemove();
         if(Boolean(this._popupMonstersB) && Boolean(this._popupMonstersB.parent))
         {
            this._popupMonstersB.parent.removeChild(this._popupMonstersB);
         }
         SOUNDS.Play("close");
      }
      
      public function ShowAttack(param1:MapRoomCell) : void
      {
         SOUNDS.Play("click1");
         this.HideBookmarkMenu();
         if(param1 && !param1._protected && !(param1._truce && param1._truce > GLOBAL.Timestamp()))
         {
            this._popupAttackA.Setup(param1);
            GLOBAL.BlockerAdd(this);
            this.addChild(this._popupAttackA);
         }
         else if(param1._protected)
         {
            GLOBAL.Message(KEYS.Get("newmap_dp"));
         }
         else if(Boolean(param1._truce) && param1._truce > GLOBAL.Timestamp())
         {
            GLOBAL.Message(KEYS.Get("newmap_truce"));
         }
      }
      
      public function HideAttack() : void
      {
         GLOBAL.BlockerRemove();
         if(this._popupAttackA.parent)
         {
            this._popupAttackA.parent.removeChild(this._popupAttackA);
         }
         SOUNDS.Play("close");
      }
      
      public function ShowBookmarkMenu(param1:MouseEvent) : void
      {
         var length:int = 0;
         var newY:int = 0;
         var menuItem:MapRoomBookmark = null;
         var i:int = 0;
         var InBookmarkRemove:Function = null;
         var inBookmarkSelect:Function = null;
         var e:MouseEvent = param1;
         SOUNDS.Play("click1");
         if(!this._menuShown && MapRoom._bookmarks.length > 0)
         {
            length = int(MapRoom._bookmarks.length);
            newY = bBookmarks.y;
            i = 0;
            while(i < length)
            {
               InBookmarkRemove = function(param1:MouseEvent):void
               {
                  BookmarkRemove(param1.target.index);
                  menuItem.bDelete.removeEventListener(MouseEvent.CLICK,InBookmarkRemove);
               };
               inBookmarkSelect = function(param1:MouseEvent):void
               {
                  BookmarkSelect(param1.target.index);
                  menuItem.mcBG.removeEventListener(MouseEvent.CLICK,inBookmarkSelect);
               };
               menuItem = new MapRoomBookmark();
               menuItem.mcBG.index = i;
               menuItem.x = bBookmarks.x + 115;
               menuItem.y = newY;
               newY += menuItem.height;
               menuItem.tName.mouseEnabled = false;
               menuItem.bDelete.index = i;
               menuItem.bDelete.addEventListener(MouseEvent.CLICK,InBookmarkRemove);
               menuItem.bDelete.buttonMode = true;
               menuItem.mcBG.addEventListener(MouseEvent.CLICK,inBookmarkSelect);
               menuItem.tName.htmlText = MapRoom._bookmarks[i].name;
               menuItem.visible = true;
               this._popupBookmarkMenu[i] = menuItem;
               this.addChild(this._popupBookmarkMenu[i]);
               i++;
            }
            this._menuShown = true;
         }
         else
         {
            this.HideBookmarkMenu();
         }
      }
      
      public function HideBookmarkMenu() : void
      {
         var _loc1_:int = 0;
         if(this._menuShown)
         {
            _loc1_ = 0;
            while(_loc1_ < this._popupBookmarkMenu.length)
            {
               if(this._popupBookmarkMenu[_loc1_].parent)
               {
                  this._popupBookmarkMenu[_loc1_].parent.removeChild(this._popupBookmarkMenu[_loc1_]);
               }
               _loc1_++;
            }
            this._menuShown = false;
            SOUNDS.Play("close");
         }
      }
      
      public function JumpToCoordinate(param1:String, param2:String) : String
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Number = Number(param1);
         var _loc4_:Number = Number(param2);
         if(!isNaN(_loc3_) && !isNaN(_loc4_))
         {
            _loc5_ = int(_loc3_);
            _loc6_ = int(_loc4_);
            if(_loc5_ >= 0 && _loc5_ < MapRoom._mapWidth && _loc6_ >= 0 && _loc6_ <= MapRoom._mapHeight)
            {
               MapRoom._homePoint = new Point(_loc5_,_loc6_);
               MapRoom.JumpTo(MapRoom._homePoint);
               return "";
            }
            return KEYS.Get("map_coordinateoffmap");
         }
         return KEYS.Get("map_notanumber");
      }
      
      public function BookmarkSelect(param1:int) : void
      {
         this.HideBookmarkMenu();
         if(MapRoom._bookmarks.length > param1)
         {
            MapRoom.JumpTo(MapRoom._bookmarks[param1].location);
         }
      }
      
      public function BookmarkRemove(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         MapRoom._bookmarks.splice(param1,1);
         if(this._popupBookmarkMenu[param1].parent)
         {
            this._popupBookmarkMenu[param1].parent.removeChild(this._popupBookmarkMenu[param1]);
         }
         this._popupBookmarkMenu.splice(param1,1);
         if(MapRoom._bookmarks.length > 0)
         {
            _loc2_ = int(MapRoom._bookmarks.length);
            _loc3_ = param1;
            while(_loc3_ < _loc2_)
            {
               --this._popupBookmarkMenu[_loc3_].mcBG.index;
               this._popupBookmarkMenu[_loc3_].y -= this._popupBookmarkMenu[_loc3_].height;
               MapRoom.BookmarkDataSet("mbm" + _loc3_,MapRoom._bookmarks[_loc3_].location.x * 10000 + MapRoom._bookmarks[_loc3_].location.y,false);
               MapRoom.BookmarkDataSetStr("mbmn" + _loc3_,MapRoom._bookmarks[_loc3_].name,false);
               _loc3_++;
            }
            MapRoom.BookmarkDataSet("mbms",_loc2_);
         }
         else
         {
            MapRoomManager.instance.BookmarksClear();
            this._menuShown = false;
         }
      }
      
      public function ShowBookmarkAddPopup(param1:MapRoomCell) : void
      {
         SOUNDS.Play("click1");
         MapRoom._currentPosition = new Point(param1.X,param1.Y);
         this._popupBookmarkAdd.tName.htmlText = KEYS.Get("map_yardowner",{"v1":param1._name});
         this._popupBookmarkAdd.tMessage.htmlText = KEYS.Get("newmap_bm_add");
         this._popupBookmarkAdd.bSave.SetupKey("btn_save");
         this._popupBookmarkAdd.bSave.addEventListener(MouseEvent.CLICK,this.HideBookmarkAddPopupWithAdd);
         GLOBAL.BlockerAdd(this);
         this.addChild(this._popupBookmarkAdd);
      }
      
      public function ShowRelocateMePopup(param1:MapRoomCell) : void
      {
         SOUNDS.Play("click1");
         this._popupRelocateMe.Setup(param1);
         GLOBAL.BlockerAdd(this);
         this.addChild(this._popupRelocateMe);
      }
      
      public function HideBookmarkAddPopup(param1:MouseEvent = null) : void
      {
         if(this._popupBookmarkAdd.parent)
         {
            this._popupBookmarkAdd.parent.removeChild(this._popupBookmarkAdd);
         }
         GLOBAL.BlockerRemove();
      }
      
      public function HideBookmarkAddPopupWithAdd(param1:MouseEvent) : void
      {
         GLOBAL.BlockerRemove();
         var _loc2_:Object = MapRoom.AddBookmark(this._popupBookmarkAdd.tName.htmlText);
         if(_loc2_.hide && this._popupBookmarkAdd && Boolean(this._popupBookmarkAdd.parent))
         {
            this._popupBookmarkAdd.parent.removeChild(this._popupBookmarkAdd);
         }
         if(_loc2_.message != "SUCCESS")
         {
            GLOBAL.Message(_loc2_.message);
         }
         SOUNDS.Play("close");
      }
      
      public function DisplayBuffs() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:MovieClip = null;
         var _loc1_:Number = POWERUPS.CheckPowers(null,"NORMAL");
         var _loc2_:int = this.mcBuffHolder.numChildren;
         while(_loc2_--)
         {
            this.mcBuffHolder.getChildAt(_loc2_).removeEventListener(MouseEvent.ROLL_OVER,this.BuffShow);
            this.mcBuffHolder.getChildAt(_loc2_).removeEventListener(MouseEvent.ROLL_OUT,this.BuffHide);
            this.mcBuffHolder.removeChildAt(_loc2_);
         }
         if(_loc1_ > 0)
         {
            _loc3_ = 3;
            _loc4_ = 2;
            _loc5_ = -1 * (32 + 4);
            _loc6_ = 32 + 4;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = POWERUPS.GetPowerups("NORMAL");
            for(_loc12_ in _loc11_)
            {
               if(POWERUPS._expireRealTime)
               {
                  if(_loc11_[_loc12_].endtime.Get() < GLOBAL.Timestamp())
                  {
                     this.BuffHide(null);
                     continue;
                  }
               }
               (_loc13_ = new ui_buffIcon_CLIP()).gotoAndStop(_loc12_);
               _loc13_.name = _loc12_;
               _loc13_.x = _loc9_ * _loc5_;
               _loc13_.y = _loc10_ * _loc6_;
               _loc9_++;
               if(_loc9_ >= _loc3_)
               {
                  _loc9_ = 0;
                  _loc10_++;
               }
               _loc13_.addEventListener(MouseEvent.ROLL_OVER,this.BuffShow);
               _loc13_.addEventListener(MouseEvent.ROLL_OUT,this.BuffHide);
               this.mcBuffHolder.addChild(_loc13_);
            }
         }
         else
         {
            this.BuffHide(null);
         }
      }
      
      public function BuffShow(param1:MouseEvent) : void
      {
         var _loc7_:bubblepopupBuff = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:String = "";
         var _loc4_:* = "";
         var _loc5_:* = _loc2_.name + "_desc";
         var _loc6_:String = "buff_duration";
         _loc3_ = KEYS.Get(_loc5_);
         _loc4_ = "<b>" + KEYS.Get(_loc6_) + "</b>";
         if(POWERUPS._expireRealTime)
         {
            if(POWERUPS.Timeleft(_loc2_.name) > 0)
            {
               _loc4_ += GLOBAL.ToTime(POWERUPS.Timeleft(_loc2_.name),true);
            }
            else
            {
               _loc4_ = "";
            }
         }
         else if(POWERUPS.Timeleft(_loc2_.name) > 0)
         {
            _loc4_ += GLOBAL.ToTime(POWERUPS.Timeleft(_loc2_.name),true);
         }
         else
         {
            _loc4_ = "";
         }
         if(!this._popupBuff)
         {
            _loc7_ = new bubblepopupBuff();
            this._popupBuff = addChild(_loc7_) as bubblepopupBuff;
            _loc7_.Setup(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height + 4,_loc3_,_loc4_);
            _loc7_.x = this.mcBuffHolder.x + (_loc2_.x + _loc2_.width / 2);
            if(_loc7_.x >= this.mcBuffHolder.x)
            {
               _loc7_.x = this.mcBuffHolder.x + (_loc2_.x + _loc2_.width / 2) - 60;
               _loc7_.mcArrow.x = 60;
            }
            _loc7_.y = this.mcBuffHolder.y + (_loc2_.y + _loc2_.height + 4);
         }
         else
         {
            bubblepopupBuff(this._popupBuff).Update(_loc3_,_loc4_);
         }
      }
      
      public function BuffHide(param1:MouseEvent) : void
      {
         if(this._popupBuff)
         {
            removeChild(this._popupBuff);
            bubblepopupBuff(this._popupBuff).Cleanup();
            this._popupBuff = null;
         }
      }
      
      public function BuffOff(param1:MouseEvent) : void
      {
         POWERUPS._testToggleOffPowers = true;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         POWERUPS.Remove(_loc2_.name);
         this.BuffHide(null);
      }
      
      public function Help() : void
      {
         Tutorial.ForceShowAll();
      }
      
      public function FullScreen() : void
      {
         if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            this._fullScreen = true;
         }
         else
         {
            this._fullScreen = false;
         }
         MapRoomManager.instance.ResizeHandler();
      }
      
      public function Resize() : void
      {
         var _loc1_:Boolean = false;
         if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            if(this._fullScreen != true)
            {
               _loc1_ = true;
            }
         }
         else if(this._fullScreen != false)
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            MapRoomManager.instance.ResizeHandler();
         }
      }
   }
}

package com.monsters.siege
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.AsyncErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class SiegeBuildingPopup extends SIEGEBUILDINGPOPUP_CLIP
   {
       
      
      private var _scrollSet:ScrollSet;
      
      private var _scrollSetContainer:Sprite;
      
      private var _statLabels:Vector.<TextField>;
      
      private var _statBarTexts:Vector.<TextField>;
      
      private var _statBars:Vector.<creatureBarAdv>;
      
      private var _siegeWeaponRows:Vector.<SiegeBuildingPopup_ListItem_CLIP>;
      
      private var _resourceCosts:Vector.<icon_costs>;
      
      private var _tab:String;
      
      private var _currentWeapon:SiegeWeapon;
      
      private var _maxStatBarWidth:Number;
      
      private var _maxTimeBarWidth:Number;
      
      private var _currentPreviewUrl:String;
      
      private var _timer:Timer;
      
      private var _videoStream:NetStream;
      
      private var _currentVideoURL:String;
      
      private const _PREVIEW_WIDTH:int = 400;
      
      private const _PREVIEW_HEIGHT:int = 175;
      
      private const _DOES_PLAY_VIDEO:Boolean = true;
      
      public function SiegeBuildingPopup(param1:String, param2:String = null)
      {
         this._timer = new Timer(1000);
         super();
         if(param2)
         {
            this._currentWeapon = SiegeWeapons.getWeapon(param2);
         }
         this._tab = param1;
         this._siegeWeaponRows = new Vector.<SiegeBuildingPopup_ListItem_CLIP>();
         this._scrollSet = new ScrollSet();
         this._scrollSet.x = scroller.x;
         this._scrollSet.y = scroller.y;
         this._scrollSet.width = scroller.width;
         this._scrollSet.Init(weaponContainer_mc,weaponContainer_mask,ScrollSet.BROWN,weaponContainer_mask.y,weaponContainer_mask.height);
         this._scrollSet.AutoHideEnabled = false;
         this._scrollSet.isHiddenWhileUnnecessary = true;
         this._scrollSetContainer = new Sprite();
         this._scrollSetContainer.addChild(this._scrollSet);
         addChild(this._scrollSetContainer);
         scroller.visible = false;
         mcTime.mcBar2.visible = false;
         tab_siegelab.addEventListener(MouseEvent.CLICK,this.SwitchToLab);
         tab_siegelab.Setup();
         title_siegelab.htmlText = KEYS.Get("b_siegeworks_title");
         title_siegelab.mouseEnabled = false;
         tab_siegefactory.addEventListener(MouseEvent.CLICK,this.SwitchToFactory);
         tab_siegefactory.Setup();
         title_siegefactory.htmlText = KEYS.Get("b_siegefactory_title");
         title_siegefactory.mouseEnabled = false;
         this._statLabels = new Vector.<TextField>(3,true);
         this._statLabels[0] = stat1_label;
         this._statLabels[1] = stat2_label;
         this._statLabels[2] = stat3_label;
         this._statBarTexts = new Vector.<TextField>(3,true);
         this._statBarTexts[0] = stat1_bartxt;
         this._statBarTexts[1] = stat2_bartxt;
         this._statBarTexts[2] = stat3_bartxt;
         this._statBars = new Vector.<creatureBarAdv>(3,true);
         this._statBars[0] = stat1_bar;
         this._statBars[1] = stat2_bar;
         this._statBars[2] = stat3_bar;
         this._resourceCosts = new Vector.<icon_costs>(4,true);
         this._resourceCosts[0] = mcResources.mcR1;
         this._resourceCosts[1] = mcResources.mcR2;
         this._resourceCosts[2] = mcResources.mcR3;
         this._resourceCosts[3] = mcResources.mcTime;
         var _loc3_:int = 0;
         while(_loc3_ < this._statBars.length)
         {
            this._statBars[_loc3_].mcBar2.gotoAndStop(3);
            _loc3_++;
         }
         mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.DoInstant,false,0,true);
         mcInstant.gCoin.mouseEnabled = false;
         mcInstant.bAction.Highlight = true;
         mcResources.bAction.addEventListener(MouseEvent.CLICK,this.DoResources);
         bCancel.addEventListener(MouseEvent.CLICK,this.CancelAction);
         bCancel.SetupKey("btn_cancel");
         bMap.addEventListener(MouseEvent.CLICK,this.OpenMap);
         bMap.SetupKey("btn_openmap");
         this._maxStatBarWidth = stat1_bar.width / stat1_bar.scaleX;
         this._maxTimeBarWidth = mcTime.width / mcTime.scaleX;
         this._timer.addEventListener(TimerEvent.TIMER,this.onTick);
         this._timer.start();
         var _loc4_:Video = new Video(this._PREVIEW_WIDTH,this._PREVIEW_HEIGHT);
         this._videoStream = this.LoadVideo(_loc4_);
         videoCanvas_mc.container.addChild(_loc4_);
         this.Update();
      }
      
      private function LoadVideo(param1:Video, param2:String = null) : NetStream
      {
         var _loc3_:NetConnection = new NetConnection();
         _loc3_.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onErrorLoadingVideo);
         _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorLoadingVideo);
         _loc3_.connect(null);
         var _loc4_:NetStream;
         (_loc4_ = new NetStream(_loc3_)).addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onErrorLoadingVideo);
         _loc4_.addEventListener(NetStatusEvent.NET_STATUS,this.onStreamNetStatus);
         _loc4_.client = {"onMetaData":this.onErrorLoadingVideo};
         if(param2)
         {
            _loc4_.play(param2);
         }
         param1.attachNetStream(_loc4_);
         return _loc4_;
      }
      
      protected function onErrorLoadingVideo(param1:*) : void
      {
      }
      
      private function onStreamNetStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetStream.Play.Stop")
         {
            this._videoStream.seek(0);
         }
      }
      
      public function Update() : void
      {
         var i:int = 0;
         var newlen:int = 0;
         var resetCurrentWeapon:Boolean = false;
         var weapon:SiegeWeapon = null;
         var allWeapons:Vector.<SiegeWeapon> = new Vector.<SiegeWeapon>();
         SiegeWeapons.addCurrentWeapons(allWeapons);
         if(this._tab == "factory")
         {
            i = 0;
            newlen = int(allWeapons.length);
            while(i < newlen)
            {
               if(allWeapons[i].level <= 0)
               {
                  allWeapons[i] = allWeapons[newlen - 1];
                  newlen--;
               }
               else
               {
                  i++;
               }
            }
            allWeapons.length = newlen;
         }
         allWeapons.fixed = true;
         allWeapons.sort(function(param1:SiegeWeapon, param2:SiegeWeapon):int
         {
            return param1.weaponID < param2.weaponID ? -1 : 1;
         });
         this.HideAll();
         tab_siegelab.Highlight = this._tab == "lab";
         tab_siegefactory.Highlight = this._tab == "factory";
         window.gotoAndStop(this._tab == "lab" ? 1 : 2);
         if(this._tab == "lab" && (!GLOBAL._bSiegeLab || GLOBAL._bSiegeLab.isBuilding))
         {
            tNotice.htmlText = KEYS.Get("msg_siegeworks_notbuilt");
            tNotice.visible = true;
         }
         else if(this._tab == "factory" && (!GLOBAL._bSiegeFactory || GLOBAL._bSiegeFactory.isBuilding))
         {
            tNotice.htmlText = KEYS.Get("msg_siegefactory_notbuilt");
            tNotice.visible = true;
         }
         else if(this._tab == "lab" && GLOBAL._bSiegeLab.isUpgrading)
         {
            tNotice.htmlText = KEYS.Get("msg_sworks_upgrading");
            tNotice.visible = true;
         }
         else if(this._tab == "factory" && GLOBAL._bSiegeFactory.isUpgrading)
         {
            tNotice.htmlText = KEYS.Get("msg_sfactory_upgrading");
            tNotice.visible = true;
         }
         else if(this._tab == "lab" && (GLOBAL._bSiegeLab && GLOBAL._bSiegeLab.health < GLOBAL._bSiegeLab.maxHealth * 0.5))
         {
            tNotice.htmlText = KEYS.Get("msg_sworks_damaged",{"v1":GLOBAL._bSiegeLab.name});
            tNotice.visible = true;
         }
         else if(this._tab == "factory" && (GLOBAL._bSiegeFactory && GLOBAL._bSiegeFactory.health < GLOBAL._bSiegeFactory.maxHealth * 0.5))
         {
            tNotice.htmlText = KEYS.Get("msg_sfactory_damaged",{"v1":GLOBAL._bSiegeFactory.name});
            tNotice.visible = true;
         }
         else if(allWeapons.length <= 0)
         {
            tNotice.htmlText = KEYS.Get("msg_siegefactory_noweapon");
            tNotice.visible = true;
         }
         else
         {
            resetCurrentWeapon = true;
            for each(weapon in allWeapons)
            {
               if(weapon == this._currentWeapon)
               {
                  resetCurrentWeapon = false;
               }
            }
            if(!this._currentWeapon || resetCurrentWeapon)
            {
               this._currentWeapon = allWeapons[0];
            }
            if(this._DOES_PLAY_VIDEO)
            {
               if(this._currentVideoURL != this._currentWeapon.video)
               {
                  this._videoStream.close();
                  this._currentVideoURL = this._currentWeapon.video;
                  // this._videoStream.play(this._currentWeapon.video);

                  // Comment: Added this so the game looks for the video hosted on the server instead of locally
                  this._videoStream.play(GLOBAL._storageURL + this._currentWeapon.video);
               }
            }
            else if(this._currentPreviewUrl != this._currentWeapon.videopreview)
            {
               this._currentPreviewUrl = this._currentWeapon.videopreview;
               videoCanvas_mc.container.visible = false;
               ImageCache.GetImageWithCallBack(this._currentWeapon.videopreview,this.onPreviewImageLoaded,true,1,"",[videoCanvas_mc.container]);
            }
            this.UpdateShowList(allWeapons);
            this.UpdateShowCurrentWeapon();
         }
         if(!mcInstant.bAction.mouseEnabled && !BASE._saving)
         {
            mcInstant.bAction.Enabled = true;
            mcInstant.bAction.mouseEnabled = true;
         }
      }
      
      private function HideAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._statLabels[_loc1_].visible = false;
            this._statBarTexts[_loc1_].visible = false;
            this._statBars[_loc1_].visible = false;
            _loc1_++;
         }
         mcInstant.visible = false;
         mcResources.visible = false;
         mcTimeTxt.visible = false;
         mcTime.visible = false;
         bCancel.visible = false;
         tTitle.visible = false;
         tTitleReady.visible = false;
         tDesc.visible = false;
         tWarning.visible = false;
         tNotice.visible = false;
         weaponContainer_mc.visible = false;
         weaponContainer_frame.visible = false;
         weaponContainer_mask.visible = false;
         this._scrollSetContainer.visible = false;
         videoCanvas_mc.visible = false;
         bMap.visible = false;
      }
      
      private function UpdateShowList(param1:Vector.<SiegeWeapon>) : void
      {
         var _loc2_:int = 0;
         var _loc5_:SiegeBuildingPopup_ListItem_CLIP = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc4_ >= this._siegeWeaponRows.length)
            {
               this._siegeWeaponRows.push(new SiegeBuildingPopup_ListItem_CLIP());
               weaponContainer_mc.addChild(this._siegeWeaponRows[_loc4_]);
               this._siegeWeaponRows[_loc4_].y = this._siegeWeaponRows[0].height * _loc4_;
               this._siegeWeaponRows[_loc4_].addEventListener(MouseEvent.CLICK,this.onClickListItem);
               this._siegeWeaponRows[_loc4_].mouseChildren = false;
               this._siegeWeaponRows[_loc4_].buttonMode = true;
               this._siegeWeaponRows[_loc4_].enableHandCursor = true;
            }
            (_loc5_ = this._siegeWeaponRows[_loc4_]).tLabel.htmlText = "<b>" + param1[_loc3_].name + "</b>";
            _loc5_.gotoAndStop(this._currentWeapon == param1[_loc3_] ? 2 : 1);
            _loc5_.siegeWeapon = param1[_loc3_];
            ImageCache.GetImageWithCallBack(_loc5_.siegeWeapon.icon,this.onIconImageLoaded,true,1,"",[_loc5_.mcImage]);
            if(this._tab == "lab" && GLOBAL._bSiegeLab && GLOBAL._bSiegeLab.IsUpgrading(param1[_loc3_]))
            {
               if(param1[_loc3_].level <= 0)
               {
                  _loc5_.tDescription.htmlText = KEYS.Get("msg_unlocking");
                  _loc5_.tDescription.visible = true;
               }
               else
               {
                  _loc5_.tDescription.visible = false;
               }
               _loc6_ = GLOBAL._bSiegeLab.UpgradeTimeLeft(param1[_loc3_]);
               _loc7_ = GLOBAL._bSiegeLab.UpgradeTimeTotal(param1[_loc3_]);
               _loc5_.mcTime.mcBar.width = (1 - _loc6_ / _loc7_) * (_loc5_.mcTime.width / _loc5_.mcTime.scaleX);
               _loc5_.tTime.htmlText = GLOBAL.ToTime(_loc6_);
               _loc5_.mcTime.visible = true;
               _loc5_.tTime.visible = true;
            }
            else if(this._tab == "factory" && GLOBAL._bSiegeFactory && GLOBAL._bSiegeFactory.IsUpgrading(param1[_loc3_]))
            {
               _loc5_.tDescription.visible = false;
               _loc6_ = GLOBAL._bSiegeFactory.UpgradeTimeLeft(param1[_loc3_]);
               _loc7_ = GLOBAL._bSiegeFactory.UpgradeTimeTotal(param1[_loc3_]);
               _loc5_.mcTime.mcBar.width = (1 - _loc6_ / _loc7_) * (_loc5_.mcTime.width / _loc5_.mcTime.scaleX);
               _loc5_.tTime.htmlText = GLOBAL.ToTime(_loc6_);
               _loc5_.mcTime.visible = true;
               _loc5_.tTime.visible = true;
            }
            else
            {
               if(this._tab == "lab" && _loc5_.siegeWeapon.level <= 0)
               {
                  _loc5_.tDescription.htmlText = KEYS.Get("msg_locked");
                  _loc5_.tDescription.visible = true;
               }
               else
               {
                  _loc5_.tDescription.visible = false;
               }
               _loc5_.mcTime.visible = false;
               _loc5_.tTime.visible = false;
            }
            if(this._tab == "factory" && _loc5_.siegeWeapon.quantity > 0)
            {
               _loc5_.tReady.htmlText = KEYS.Get("msg_ready");
               _loc5_.tReady.visible = true;
            }
            else
            {
               _loc5_.tReady.visible = false;
            }
            if(this._tab == "lab" && _loc5_.siegeWeapon.level >= SiegeWeapon.MAX_LEVEL)
            {
               _loc5_.tReady.htmlText = "<b>" + KEYS.Get("msg_fullyupgraded") + "</b>";
               _loc5_.tReady.visible = true;
            }
            if(_loc5_.tDescription.visible)
            {
               _loc2_ = 0;
               while(_loc2_ < SiegeWeapon.MAX_LEVEL)
               {
                  (_loc5_["star" + (_loc2_ + 1)] as MovieClip).visible = false;
                  _loc2_++;
               }
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < SiegeWeapon.MAX_LEVEL)
               {
                  (_loc8_ = _loc5_["star" + (_loc2_ + 1)]).gotoAndStop(_loc2_ < param1[_loc3_].level ? "on" : "off");
                  _loc8_.visible = true;
                  _loc2_++;
               }
            }
            _loc4_++;
            _loc3_++;
         }
         this._scrollSet.ContainerHeight = this._siegeWeaponRows[0].height * _loc4_;
         while(_loc4_ < this._siegeWeaponRows.length)
         {
            weaponContainer_mc.removeChild(this._siegeWeaponRows.pop());
         }
         weaponContainer_mc.visible = true;
         weaponContainer_frame.visible = true;
         weaponContainer_mask.visible = true;
         this._scrollSetContainer.visible = true;
         this._scrollSet.Update();
      }
      
      private function onClickListItem(param1:MouseEvent) : void
      {
         var _loc2_:SiegeBuildingPopup_ListItem_CLIP = param1.currentTarget as SiegeBuildingPopup_ListItem_CLIP;
         this._currentWeapon = _loc2_.siegeWeapon;
         this.Update();
      }
      
      private function onPreviewImageLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc5_:Bitmap = null;
         if(param1 != this._currentPreviewUrl)
         {
            return;
         }
         var _loc4_:MovieClip;
         _loc4_ = param3[0];
         if(_loc4_)
         {
            while(_loc4_.numChildren > 0)
            {
               _loc4_.removeChildAt(0);
            }
            (_loc5_ = new Bitmap(param2)).width = this._PREVIEW_WIDTH;
            _loc5_.height = this._PREVIEW_HEIGHT;
            _loc4_.addChild(_loc5_);
            _loc4_.visible = true;
         }
      }
      
      private function onIconImageLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc5_:Bitmap = null;
         var _loc4_:MovieClip;
         _loc4_ = param3[0];
         if(_loc4_)
         {
            while(_loc4_.numChildren > 0)
            {
               _loc4_.removeChildAt(0);
            }
            _loc5_ = new Bitmap(param2);
            _loc5_.width = _loc5_.height = 50;
            _loc4_.addChild(_loc5_);
            _loc4_.visible = true;
         }
      }
      
      private function UpdateShowCurrentWeapon() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         tTitle.htmlText = "<b>" + this._currentWeapon.name + "</b>";
         if(this._currentWeapon.quantity > 0 && this._tab == "factory")
         {
            tTitleReady.htmlText = KEYS.Get("msg_ready");
            tTitleReady.visible = true;
         }
         else
         {
            tTitleReady.visible = false;
         }
         tDesc.htmlText = this._currentWeapon.description;
         videoCanvas_mc.visible = true;
         tTitle.visible = true;
         tDesc.visible = true;
         var _loc1_:Vector.<SiegeWeaponProperty> = this._currentWeapon.getProperties();
         var _loc2_:int = 0;
         while(_loc2_ < 3 && _loc2_ < _loc1_.length)
         {
            this._statLabels[_loc2_].htmlText = "<b>" + _loc1_[_loc2_].label + "</b>";
            this._statLabels[_loc2_].visible = true;
            if(this._currentWeapon.level == 0)
            {
               this._statBarTexts[_loc2_].htmlText = GLOBAL.FormatNumber(_loc1_[_loc2_].getValueForLevel(this._currentWeapon.level + 1));
               this._statBars[_loc2_].mcBar.width = 0;
               this._statBars[_loc2_].mcBar2.width = _loc1_[_loc2_].getProgressForLevel(this._currentWeapon.level + 1) * this._maxStatBarWidth;
            }
            else if(this._tab == "lab")
            {
               if(this._currentWeapon.level >= SiegeWeapon.MAX_LEVEL)
               {
                  this._statBars[_loc2_].mcBar.width = _loc1_[_loc2_].getProgressForLevel(SiegeWeapon.MAX_LEVEL) * this._maxStatBarWidth;
                  this._statBarTexts[_loc2_].htmlText = GLOBAL.FormatNumber(_loc1_[_loc2_].getValueForLevel(SiegeWeapon.MAX_LEVEL));
                  this._statBars[_loc2_].mcBar2.width = 0;
               }
               else
               {
                  this._statBars[_loc2_].mcBar.width = _loc1_[_loc2_].getProgressForLevel(this._currentWeapon.level) * this._maxStatBarWidth;
                  _loc3_ = _loc1_[_loc2_].getValueForLevel(this._currentWeapon.level);
                  if((_loc4_ = _loc1_[_loc2_].getValueForLevel(this._currentWeapon.level + 1) - _loc3_) < 0)
                  {
                     this._statBarTexts[_loc2_].htmlText = GLOBAL.FormatNumber(_loc3_) + " (" + GLOBAL.FormatNumber(_loc4_) + ")";
                  }
                  else if(_loc4_ > 0)
                  {
                     this._statBarTexts[_loc2_].htmlText = GLOBAL.FormatNumber(_loc3_) + " (+" + GLOBAL.FormatNumber(_loc4_) + ")";
                  }
                  else
                  {
                     this._statBarTexts[_loc2_].htmlText = GLOBAL.FormatNumber(_loc3_);
                  }
                  this._statBars[_loc2_].mcBar2.width = _loc1_[_loc2_].getProgressForLevel(this._currentWeapon.level + 1) * this._maxStatBarWidth;
               }
            }
            else
            {
               this._statBars[_loc2_].mcBar.width = _loc1_[_loc2_].getProgressForLevel(this._currentWeapon.level) * this._maxStatBarWidth;
               this._statBarTexts[_loc2_].htmlText = GLOBAL.FormatNumber(_loc1_[_loc2_].getValueForLevel(this._currentWeapon.level));
               this._statBars[_loc2_].mcBar2.width = 0;
            }
            this._statBarTexts[_loc2_].visible = true;
            this._statBars[_loc2_].visible = true;
            _loc2_++;
         }
         if(this._tab == "lab")
         {
            this.UpdateShowCurrentWeaponLab();
         }
         else if(this._tab == "factory")
         {
            this.UpdateShowCurrentWeaponFactory();
         }
      }
      
      private function UpdateShowCurrentWeaponLab() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(GLOBAL._bSiegeLab.IsUpgrading(this._currentWeapon))
         {
            _loc1_ = GLOBAL._bSiegeLab.UpgradeTimeLeft(this._currentWeapon);
            _loc2_ = GLOBAL._bSiegeLab.UpgradeTimeTotal(this._currentWeapon);
            _loc3_ = 1 - _loc1_ / _loc2_;
            _loc4_ = GLOBAL._bSiegeLab.getInstantUpgradeCost(this._currentWeapon.weaponID);
            mcInstant.bAction.Setup(KEYS.Get("btn_finishnow"));
            mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("siege_shiny",{"v1":_loc4_}) + "</b>";
            mcTimeTxt.htmlText = "<b>" + GLOBAL.ToTime(_loc1_,true,false) + "</b>";
            mcTime.mcBar.width = this._maxTimeBarWidth * _loc3_;
            mcTimeTxt.visible = true;
            mcTime.visible = true;
            bCancel.visible = true;
            mcInstant.visible = true;
         }
         else if(this._currentWeapon.level < SiegeWeapon.MAX_LEVEL)
         {
            if(GLOBAL._bSiegeLab.upgradingWeapon)
            {
               tWarning.htmlText = KEYS.Get("msg_oneweaponupgrade",{"v1":GLOBAL._bSiegeLab.upgradingWeapon.name});
               tWarning.visible = true;
            }
            else if(GLOBAL._bSiegeLab._lvl.Get() - 1 < this._currentWeapon.level)
            {
               tWarning.htmlText = KEYS.Get("msg_upgraderequiredlevel",{
                  "v1":GLOBAL._bSiegeLab.name,
                  "v2":this._currentWeapon.level + 1
               });
               tWarning.visible = true;
            }
            else
            {
               mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":this._currentWeapon.instantUpgradeCost}));
               if(this._currentWeapon.level == 0)
               {
                  mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("msg_unlockinstant") + "</b>";
                  mcResources.bAction.SetupKey("btn_startunlocking");
               }
               else
               {
                  mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("msg_upgradeinstant") + "</b>";
                  mcResources.bAction.SetupKey("btn_startupgrade");
               }
               mcInstant.visible = true;
               this.UpdateShowCurrentCosts();
            }
         }
      }
      
      private function UpdateShowCurrentWeaponFactory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(GLOBAL._bSiegeFactory.IsUpgrading(this._currentWeapon))
         {
            _loc1_ = GLOBAL._bSiegeFactory.UpgradeTimeLeft(this._currentWeapon);
            _loc2_ = GLOBAL._bSiegeFactory.UpgradeTimeTotal(this._currentWeapon);
            _loc3_ = 1 - _loc1_ / _loc2_;
            _loc4_ = GLOBAL._bSiegeFactory.getInstantUpgradeCost(this._currentWeapon.weaponID);
            mcInstant.bAction.Setup("<b>" + KEYS.Get("btn_finishnow") + "</b>");
            mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("siege_shiny",{"v1":_loc4_}) + "</b>";
            mcTimeTxt.htmlText = "<b>" + GLOBAL.ToTime(_loc1_,true,false) + "</b>";
            mcTime.mcBar.width = this._maxTimeBarWidth * _loc3_;
            mcTimeTxt.visible = true;
            mcTime.visible = true;
            bCancel.visible = true;
            mcInstant.visible = true;
         }
         else if(this._currentWeapon.quantity > 0)
         {
            bMap.visible = true;
         }
         else if(GLOBAL._bSiegeFactory.upgradingWeapon)
         {
            tWarning.htmlText = KEYS.Get("msg_oneweapon",{"v1":GLOBAL._bSiegeFactory.upgradingWeapon.name});
            tWarning.visible = true;
         }
         else if(SiegeWeapons.availableWeapon)
         {
            tWarning.htmlText = KEYS.Get("msg_oneweapon",{"v1":SiegeWeapons.availableWeapon.name});
            tWarning.visible = true;
         }
         else
         {
            mcInstant.bAction.Setup("<b>" + KEYS.Get("btn_useshiny",{"v1":this._currentWeapon.instantBuildCost}) + "</b>");
            mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("msg_buildinstant") + "</b>";
            mcResources.bAction.SetupKey("btn_startbuilding");
            mcInstant.visible = true;
            this.UpdateShowCurrentCosts();
         }
      }
      
      public function UpdateShowCurrentCosts() : void
      {
         var id:String = null;
         var i:int = 0;
         var j:int = 0;
         var text:String = null;
         var costIds:Vector.<String> = new Vector.<String>();
         var costs:Object = this._tab == "factory" ? this._currentWeapon.buildCosts : this._currentWeapon.upgradeCosts;
         for(id in costs)
         {
            costIds.push(id);
         }
         costIds.sort(function(param1:String, param2:String):Number
         {
            return param1 == "time" ? 1 : (param2 == "time" ? -1 : (param1 < param2 ? -1 : 1));
         });
         i = 0;
         j = 0;
         while(i < costIds.length && j < this._resourceCosts.length)
         {
            id = costIds[i];
            if(costs[id] > 0)
            {
               this._resourceCosts[j].gotoAndStop(GLOBAL.getResourceFrame(id,true));
               this._resourceCosts[j].tTitle.htmlText = "<b>" + GLOBAL.getResourceName(id,true) + "</b>";
               if(id == "time")
               {
                  text = GLOBAL.ToTime(costs[id],true,false);
               }
               else
               {
                  text = GLOBAL.FormatNumber(costs[id]);
               }
               if(Boolean(BASE._iresources[id]) && BASE._iresources[id].Get() < costs[id])
               {
                  text = "<b><font color=\'#FF0000\'>" + text + "</font></b>";
               }
               else
               {
                  text = "<b>" + text + "</b>";
               }
               this._resourceCosts[j].tValue.htmlText = text;
               this._resourceCosts[j].visible = true;
               j++;
            }
            i++;
         }
         while(j < this._resourceCosts.length)
         {
            this._resourceCosts[j].visible = false;
            j++;
         }
         mcResources.visible = true;
      }
      
      public function Hide() : void
      {
         this._timer.stop();
         SiegeBuilding.Hide();
         this._videoStream.close();
      }
      
      private function DoInstant(param1:MouseEvent = null) : void
      {
         if(this._tab == "lab")
         {
            if(GLOBAL._bSiegeLab.HasEnoughShinyToUpgrade(this._currentWeapon))
            {
               GLOBAL._bSiegeLab.InstantUpgrade(this._currentWeapon.weaponID);
               mcInstant.bAction.Enabled = false;
               mcInstant.bAction.mouseEnabled = false;
            }
            else
            {
               POPUPS.DisplayGetShiny();
            }
         }
         else if(this._tab == "factory")
         {
            if(GLOBAL._bSiegeFactory.HasEnoughShinyToUpgrade(this._currentWeapon))
            {
               GLOBAL._bSiegeFactory.InstantUpgrade(this._currentWeapon.weaponID);
               mcInstant.bAction.Enabled = false;
               mcInstant.bAction.mouseEnabled = false;
            }
            else
            {
               POPUPS.DisplayGetShiny();
            }
         }
         this.Update();
      }
      
      private function DoResources(param1:MouseEvent) : void
      {
         if(this._tab == "lab")
         {
            if(!this._currentWeapon.hasResourcesToUpgrade)
            {
               if(!this._currentWeapon.hasCapacityToUpgrade)
               {
                  GLOBAL.Message("<b>" + KEYS.Get("msg_morepodsunlock") + "</b>");
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("buildoptions_err_moreresources",{
                     "v1":GLOBAL.FormatNumber(this._currentWeapon.numResourcesToUpgradeNeeded),
                     "v2":GLOBAL.FormatNumber(this._currentWeapon.instantUpgradeResourceCost)
                  }),KEYS.Get("btn_getresources"),this._currentWeapon.buyResourcesAndUpgrade);
               }
            }
            else
            {
               GLOBAL._bSiegeLab.StartUpgradingWeapon(this._currentWeapon.weaponID);
            }
         }
         else if(this._tab == "factory")
         {
            if(!this._currentWeapon.hasResourcesToBuild)
            {
               if(!this._currentWeapon.hasCapacityToBuild)
               {
                  GLOBAL.Message("<b>" + KEYS.Get("msg_morepodsunlock") + "</b>");
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("buildoptions_err_moreresources",{
                     "v1":GLOBAL.FormatNumber(this._currentWeapon.numResourcesToBuildNeeded),
                     "v2":GLOBAL.FormatNumber(this._currentWeapon.instantBuildResourceCost)
                  }),KEYS.Get("btn_getresources"),this._currentWeapon.buyResourcesAndBuild);
               }
            }
            else
            {
               GLOBAL._bSiegeFactory.StartUpgradingWeapon(this._currentWeapon.weaponID);
            }
         }
         this.Update();
      }
      
      private function CancelAction(param1:MouseEvent) : void
      {
         var ActuallyCancel:Function = null;
         var e:MouseEvent = param1;
         ActuallyCancel = function():void
         {
            if(_tab == "lab")
            {
               GLOBAL._bSiegeLab.CancelUpgradingWeapon(_currentWeapon.weaponID);
            }
            else if(_tab == "factory")
            {
               GLOBAL._bSiegeFactory.CancelUpgradingWeapon(_currentWeapon.weaponID);
            }
            Update();
         };
         if(this._tab == "lab")
         {
            GLOBAL.Message(KEYS.Get("msg_upgrade_confirmcancel",{"v1":this._currentWeapon.name}),KEYS.Get("msg_stopupgrading_btn"),ActuallyCancel);
         }
         else if(this._tab == "factory")
         {
            GLOBAL.Message(KEYS.Get("msg_build_confirmcancel",{"v1":this._currentWeapon.name}),KEYS.Get("btn_stopbuilding"),ActuallyCancel);
         }
      }
      
      private function OpenMap(param1:MouseEvent) : void
      {
         GLOBAL.ShowMap();
         this.Hide();
      }
      
      private function SwitchToLab(param1:MouseEvent) : void
      {
         this._tab = "lab";
         this.Update();
      }
      
      private function SwitchToFactory(param1:MouseEvent) : void
      {
         this._tab = "factory";
         this.Update();
      }
      
      public function onTick(param1:TimerEvent) : void
      {
         this.Update();
      }
   }
}

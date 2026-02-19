package
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.baseBuffs.BaseBuffHandler;
   import com.monsters.baseBuffs.buffs.AutoBankBaseBuff;
   import com.monsters.configs.BYMConfig;
   import com.monsters.dealspot.DealSpot;
   import com.monsters.display.ScrollSetV;
   import com.monsters.enums.EnumYardType;
   import com.monsters.kingOfTheHill.graphics.KOTHHUDGraphic;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom3.MapRoom3Cell;
   import com.monsters.maproom_inferno.views.DescentDebuffPopup;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.subscriptions.SubscriptionHandler;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   import gs.*;
   import gs.easing.*;
   
   public class UI_TOP extends UI_TOP_CLIP
   {
      
      public static const CREATUREBUTTONOVER:String = "creatureButtonOver";
       
      
      public var _popupWarning:bubblepopup4;
      
      public var _popupBuff:bubblepopupBuff;
      
      public var _creatureButtons:Array;
      
      public var _creatureButtonsMC:flingerLevel;
      
      public var _bubbleDo:DisplayObject;
      
      public var _catapult:CATAPULTPOPUP;
      
      public var _siegeweapon:SIEGEWEAPONPOPUP;
      
      public var _buttonIcons:Array;
      
      public var _descentDebuff:DescentDebuffPopup;
      
      public var extraResourceRows:int = 0;
      
      public var _dealspot:DealSpot;
      
      public var _resourceUI:Object;
      
      public var _resourceR1:int;
      
      public var _resourceR2:int;
      
      public var _resourceR3:int;
      
      public var _resourceR4:int;
      
      public var _kothIcon:DisplayObject;
      
      public var _daveClub:DisplayObject;
      
      private const _RESOURCEBAR_HEIGHT:int = 37;
      
      private var m_creatureContainer:Sprite;
      
      private var m_scrollBar:ScrollSetV;
      
      public function UI_TOP()
      {
         var _loc1_:int = 0;
         var _loc3_:Boolean = false;
         super();
         var _loc2_:String = GLOBAL.mode;
         switch(GLOBAL.mode)
         {
            case GLOBAL.e_BASE_MODE.BUILD:
            case GLOBAL.e_BASE_MODE.IBUILD:
               _loc2_ = GLOBAL.e_BASE_MODE.BUILD;
               break;
            case GLOBAL.e_BASE_MODE.ATTACK:
            case GLOBAL.e_BASE_MODE.IATTACK:
               _loc2_ = GLOBAL.e_BASE_MODE.ATTACK;
               break;
            case GLOBAL.e_BASE_MODE.WMATTACK:
            case GLOBAL.e_BASE_MODE.IWMATTACK:
               _loc2_ = GLOBAL.e_BASE_MODE.WMATTACK;
               break;
            case GLOBAL.e_BASE_MODE.VIEW:
            case GLOBAL.e_BASE_MODE.IVIEW:
               _loc2_ = GLOBAL.e_BASE_MODE.VIEW;
               break;
            case GLOBAL.e_BASE_MODE.HELP:
            case GLOBAL.e_BASE_MODE.IHELP:
               _loc2_ = GLOBAL.e_BASE_MODE.HELP;
               break;
            case GLOBAL.e_BASE_MODE.WMVIEW:
            case GLOBAL.e_BASE_MODE.IWMVIEW:
               _loc2_ = MapRoomManager.instance.isInMapRoom3 ? (_loc2_ = GLOBAL.e_BASE_MODE.ATTACK) : GLOBAL.e_BASE_MODE.WMVIEW;
         }
         if(MapRoomManager.instance.isInMapRoom3 && (GLOBAL.mode === GLOBAL.e_BASE_MODE.VIEW || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMVIEW))
         {
            gotoAndStop(GLOBAL.e_BASE_MODE.ATTACK);
         }
         else
         {
            gotoAndStop(GLOBAL._loadmode);
         }
         if (mc && mc.mcPoints) mc.mcPoints.stop();
         if(GLOBAL._loadmode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IBUILD)
         {
            this.setupBuildMode();
         }
         else if(GLOBAL._loadmode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IWMATTACK)
         {
            this.setupAttackMode();
         }
         else if(MapRoomManager.instance.isInMapRoom3 && (GLOBAL.mode === GLOBAL.e_BASE_MODE.VIEW || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMVIEW))
         {
            this.setupScoutMode();
         }
         else
         {
            this.DescentDebuffHide();
         }
         this.Update();
      }
      
      private function setupBuildMode() : void
      {
         var _loc1_:int = 0;
         mc.mcPoints.addEventListener(MouseEvent.MOUSE_OVER,this.InfoShow);
         mc.mcPoints.addEventListener(MouseEvent.MOUSE_OUT,this.InfoHide);
         _loc1_ = 1;
         while(_loc1_ < 5)
         {
            mc["mcR" + _loc1_].mcHit.addEventListener(MouseEvent.MOUSE_OVER,this.StatsShow(_loc1_,false));
            mc["mcR" + _loc1_].mcHit.addEventListener(MouseEvent.MOUSE_OUT,this.StatsHide);
            mc["mcR" + _loc1_].bAdd.addEventListener(MouseEvent.CLICK,this.Topup(_loc1_));
            mc["mcR" + _loc1_].bAdd.buttonMode = true;
            mc["mcR" + _loc1_].bAdd.mouseEnabled = true;
            mc["mcR" + _loc1_].bAdd.mouseChildren = false;
            _loc1_++;
         }
         this._resourceUI = {};
         this._resourceUI.r1 = BASE._resources["r" + 1].Get();
         this._resourceUI.r2 = BASE._resources["r" + 2].Get();
         this._resourceUI.r3 = BASE._resources["r" + 3].Get();
         this._resourceUI.r4 = BASE._resources["r" + 4].Get();
         mc["mcR" + 1]._resource = BASE._resources["r" + 1].Get();
         mc["mcR" + 2]._resource = BASE._resources["r" + 2].Get();
         mc["mcR" + 3]._resource = BASE._resources["r" + 3].Get();
         mc["mcR" + 4]._resource = BASE._resources["r" + 4].Get();
         mc.mcR5.bAdd.txtAdd.autoSize = TextFieldAutoSize.LEFT;
         mc.mcR5.bAdd.txtAdd.htmlText = KEYS.Get("ui_topaddshiny");
         mc.mcR5.bAdd.mcBG.width = mc.mcR5.bAdd.txtAdd.width + 11;
         mc.mcR5.mcBG.width = 82 + mc.mcR5.bAdd.width;
         // mc.mcR5.bAdd.addEventListener(MouseEvent.CLICK,BUY.Show);
         mc.mcR5.bAdd.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
         {
            GLOBAL.Message(KEYS.Get("disabled_addshiny"));
         });
         mc.mcR5.bAdd.buttonMode = true;
         mc.mcR5.bAdd.mouseChildren = false;
         mc.mcOutposts.mcHit.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
         mc.mcOutposts.mcHit.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
         mc.mcOutposts.bNext.addEventListener(MouseEvent.CLICK,BASE.LoadNext);
         mc.mcOutposts.bNext.buttonMode = true;
         mc.mcOutposts.bNext.mouseEnabled = true;
         mc.mcOutposts.bNext.mouseChildren = false;
         mc.bInvite.buttonMode = true;
         mc.bInvite.mouseChildren = false;
         mc.bInvite.addEventListener(MouseEvent.CLICK,this.ButtonClick("invite"));
         mc.bInvite.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
         mc.bInvite.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
         mc.bGift.buttonMode = true;
         mc.bGift.mouseChildren = false;
         mc.bGift.addEventListener(MouseEvent.CLICK,this.ButtonClick("gift"));
         mc.bGift.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
         mc.bGift.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
         mc.bInbox.buttonMode = true;
         mc.bInbox.mouseChildren = false;
         mc.bInbox.addEventListener(MouseEvent.CLICK,this.ButtonClick("inbox"));
         mc.bInbox.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
         mc.bInbox.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
         mc.bAlert.buttonMode = true;
         mc.bAlert.mouseChildren = false;
         mc.bAlert.addEventListener(MouseEvent.CLICK,this.ButtonClick("alert"));
         mc.bAlert.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
         mc.bAlert.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
         this._buttonIcons = [];
         this._buttonIcons = [mc.bInvite,mc.bGift,mc.bInbox,mc.bAlert];
         addEventListener(Event.ENTER_FRAME, onSpinnerTick);
         mc.bEarn.bAction.tLabel.htmlText = KEYS.Get("btn_earn");
         if(GLOBAL._flags.showFBCEarn == 1)
         {
            mc.bEarn.buttonMode = true;
            mc.bEarn.mouseChildren = false;
            mc.bEarn.addEventListener(MouseEvent.CLICK,this.ButtonClick("earn"));
            mc.bEarn.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
            mc.bEarn.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
         }
         else
         {
            mc.bEarn.mouseChildren = false;
            mc.bEarn.mouseEnabled = false;
            mc.bEarn.visible = false;
         }
         mc.bDailyDeal.tLabel.htmlText = KEYS.Get("btn_dailydeal");
         if(GLOBAL._flags.showFBCDaily == 1)
         {
            mc.bDailyDeal.buttonMode = true;
            mc.bDailyDeal.mouseChildren = false;
            mc.bDailyDeal.addEventListener(MouseEvent.CLICK,this.ButtonClick("daily"));
            mc.bDailyDeal.addEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
            mc.bDailyDeal.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            if(GLOBAL._flags.showFBCEarn == 0)
            {
               mc.bDailyDeal.x = mc.bEarn.x;
            }
         }
         else
         {
            mc.bDailyDeal.mouseChildren = false;
            mc.bDailyDeal.mouseEnabled = false;
            mc.bDailyDeal.visible = false;
         }
      }

      private function onSpinnerTick(e:Event):void
      {
         for each (var btn:* in this._buttonIcons)
         {
            if (btn && btn.mcSpinner && btn.mcSpinner.visible)
            {
               btn.mcSpinner.rotation += 4;
            }
         }
      }

      private function setupScoutMode() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         this.setupAttackMode();
         if(!GLOBAL._attackersFlinger)
         {
            this._creatureButtonsMC._mc._txtContainer.flinger_txt.htmlText = KEYS.Get("no_flinger");
         }
         else
         {
            this._creatureButtonsMC._mc._txtContainer.flinger_txt.htmlText = BASE.isInfernoMainYardOrOutpost ? KEYS.Get("monster_limit") : KEYS.Get("attack_flingerbar");
         }
         this._creatureButtonsMC._mc._txtContainer.mcBar.visible = false;
         this._creatureButtonsMC._mc._txtContainer.tA.htmlText = "";
         _loc2_ = 1;
         while(_loc2_ < 5)
         {
            _loc1_ = mc["mcR" + _loc2_];
            _loc1_.visible = false;
            _loc2_++;
         }
      }
      
      private function setupAttackMode() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Sprite = null;
         this._creatureButtonsMC = mc.addChild(new flingerLevel()) as flingerLevel;
         this._creatureButtonsMC._mc._txtContainer.flinger_txt.htmlText = KEYS.Get("txt_flinger_capacity");
         this._creatureButtonsMC._mc._txtContainer.mcBar.visible = true;
         this._creatureButtonsMC._mc._txtContainer.tA.htmlText = "0%";
         this._creatureButtonsMC.y = 180;
         this._creatureButtonsMC._mc.x = 2;
         this._creatureButtonsMC._mc.y = -6;
         this._creatureButtons = [];
         if(!GLOBAL._attackersFlinger)
         {
            this._creatureButtonsMC._mc._txtContainer.flinger_txt.htmlText = KEYS.Get("no_flinger");
            this._creatureButtonsMC._mc._txtContainer.tA.htmlText = "";
            this._creatureButtonsMC._mc._bottomBar.visible = false;
         }
         else
         {
            this.m_creatureContainer = new Sprite();
            this._creatureButtonsMC.addChild(this.m_creatureContainer);
            _loc1_ = this.setupChampionButtons(this.m_creatureContainer);
            this.setupCreatureButtons(this.m_creatureContainer,_loc1_[0],_loc1_[1]);
            if(this.m_creatureContainer.numChildren == 0)
            {
               this._creatureButtonsMC._mc._txtContainer.flinger_txt.htmlText = KEYS.Get("no_monsters");
               this._creatureButtonsMC._mc._bottomBar.visible = false;
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.beginFill(16777215,1);
            _loc2_.graphics.drawRect(0,22,200,GLOBAL._SCREEN.height - 476);
            _loc2_.graphics.endFill();
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            this._creatureButtonsMC.addChild(_loc2_);
            this.m_creatureContainer.mask = _loc2_;
            this.m_scrollBar = new ScrollSetV(this.m_creatureContainer,_loc2_,true);
            this.m_scrollBar.x = 202 - this.m_scrollBar.width;
            this.m_scrollBar.y = 22;
            this._creatureButtonsMC.addChild(this.m_scrollBar);
         }
         if(SiegeWeapons.availableWeapon != null && !BASE.isInfernoMainYardOrOutpost)
         {
            this._siegeweapon = new SIEGEWEAPONPOPUP();
            mc.addChild(this._siegeweapon);
            this._siegeweapon.x = 442;
            this._siegeweapon.y = 20;
            this._siegeweapon.Setup(!GLOBAL.isInAttackMode);
         }
         if(GLOBAL._attackersCatapult > 0 && !BASE.isInfernoMainYardOrOutpost)
         {
            this._catapult = new CATAPULTPOPUP();
            mc.addChild(this._catapult);
            this._catapult.x = 350;
            this._catapult.y = 20;
            this._catapult.Setup(!GLOBAL.isInAttackMode);
         }
      }
      
      private function setupScrollMenu() : void
      {
         this.m_creatureContainer = new Sprite();
         this._creatureButtonsMC.addChild(this.m_creatureContainer);
         var _loc1_:Array = this.setupChampionButtons(this.m_creatureContainer);
         this.setupCreatureButtons(this.m_creatureContainer,_loc1_[0],_loc1_[1]);
         if(this.m_creatureContainer.numChildren == 0)
         {
            this._creatureButtonsMC._mc._txtContainer.flinger_txt.htmlText = KEYS.Get("no_monsters");
            this._creatureButtonsMC._mc._bottomBar.visible = false;
         }
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,1);
         _loc2_.graphics.drawRect(0,22,200,GLOBAL._SCREEN.height - 476);
         _loc2_.graphics.endFill();
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         this._creatureButtonsMC.addChild(_loc2_);
         this.m_creatureContainer.mask = _loc2_;
         var _loc3_:ScrollSetV = new ScrollSetV(this.m_creatureContainer,_loc2_,true);
         _loc3_.x = 202 - _loc3_.width;
         _loc3_.y = 22;
         this._creatureButtonsMC.addChild(_loc3_);
      }
      
      private function setupChampionButtons(param1:DisplayObjectContainer) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc2_:int = int(GLOBAL._playerGuardianData.length);
         while(_loc7_ < _loc2_)
         {
            if(Boolean(GLOBAL._playerGuardianData[_loc7_]) && GLOBAL._playerGuardianData[_loc7_].hp.Get() > 0)
            {
               if((_loc6_ = !!GLOBAL._playerGuardianData[_loc7_].status ? int(GLOBAL._playerGuardianData[_loc7_].status) : ChampionBase.k_CHAMPION_STATUS_NORMAL) == ChampionBase.k_CHAMPION_STATUS_NORMAL)
               {
                  if(_loc5_ && GLOBAL._playerGuardianData[_loc7_].t != 5)
                  {
                     LOGGER.Log("log","User is initializing combat with more than one normal champ.");
                  }
                  else if(GLOBAL._loadmode == GLOBAL.mode || GLOBAL._loadmode != GLOBAL.mode && !MAPROOM_DESCENT.DescentPassed)
                  {
                     if(GLOBAL._playerGuardianData[_loc7_].t != 5)
                     {
                        _loc5_ = true;
                     }
                     (_loc8_ = param1.addChild(new CHAMPIONBUTTON("G" + GLOBAL._playerGuardianData[_loc7_].t,GLOBAL._playerGuardianData[_loc7_].l.Get(),_loc7_,_loc3_,this._creatureButtonsMC)) as CHAMPIONBUTTON).x = 14;
                     _loc8_.y = 34 + _loc3_ * 53;
                     _loc8_.addEventListener(UI_TOP.CREATUREBUTTONOVER,this.sortCreatureButtons);
                     this._creatureButtons.push(_loc8_);
                     _loc3_++;
                     _loc4_++;
                  }
               }
            }
            _loc7_++;
         }
         if(_loc8_)
         {
            this._creatureButtonsMC._mc._bottomBar.y = Math.min(GLOBAL._SCREEN.height - 450,_loc8_.y + _loc8_.height - this._creatureButtonsMC._mc._bottomBar.height * 0.8);
         }
         return [_loc3_,_loc4_];
      }
      
      private function setupCreatureButtons(param1:DisplayObjectContainer, param2:int, param3:int) : void
      {
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc4_:Object = CREATURELOCKER._creatures;
         var _loc5_:Boolean = MapRoomManager.instance.isInMapRoom3;
         for(_loc6_ in _loc4_)
         {
            _loc7_ = int(_loc6_.substr(_loc6_.length - 1));
            _loc9_ = ATTACK._curCreaturesAvailable;
            if(ATTACK._curCreaturesAvailable[_loc6_])
            {
               _loc10_ = _loc6_;
               if(ATTACK._curCreaturesAvailable[_loc10_] > 0)
               {
                  (_loc8_ = param1.addChild(new CREATUREBUTTON(_loc10_,param2,this._creatureButtonsMC)) as CREATUREBUTTON).x = 14;
                  _loc8_.y = 34 + param2 * 53;
                  if(MapRoomManager.instance.isInMapRoom2or3)
                  {
                     _loc8_.addEventListener(UI_TOP.CREATUREBUTTONOVER,this.sortCreatureButtons);
                  }
                  this._creatureButtons.push(_loc8_);
                  param2++;
               }
            }
         }
         if(_loc8_)
         {
            this._creatureButtonsMC._mc._bottomBar.y = Math.min(GLOBAL._SCREEN.height - 450,_loc8_.y + _loc8_.height - this._creatureButtonsMC._mc._bottomBar.height * 0.8);
         }
      }
      
      private function sortCreatureButtons(param1:Event = null) : void
      {
         this._creatureButtonsMC.addChild(param1.target as DisplayObject);
      }
      
      private function InfoShow(param1:MouseEvent) : void
      {
         mc.mcPoints.gotoAndStop(2);
         var _loc2_:Object = BASE.BaseLevel();
         mc.mcPoints.tInfo.htmlText = KEYS.Get("pop_experiencebar",{
            "v1":GLOBAL.FormatNumber(_loc2_.points),
            "v2":GLOBAL.FormatNumber(_loc2_.needed),
            "v3":_loc2_.level + 1
         });
      }
      
      private function InfoHide(param1:MouseEvent) : void
      {
         mc.mcPoints.gotoAndStop(1);
      }
      
      public function resize(param1:Rectangle) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         x = param1.x + 10;
         y = param1.y + 4;
         mcProtected.x = param1.width - 125;
         mcReinforcements.x = param1.width - 125;
         mcSpecialEvent.x = param1.width - 125;
         mcBuffHolder.x = param1.width - 200;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            mcZoom.x = param1.width - 38 - 24;
            mcFullscreen.x = param1.width - 38;
            mcSound.x = param1.width - 38 - 24;
            mcMusic.x = param1.width - 38;
            mcSave.x = param1.width - 38 - 24;
         }
         else
         {
            mcZoom.x = param1.width - 130;
            mcFullscreen.x = param1.width - 100;
            mcSound.x = param1.width - 70;
            mcMusic.x = param1.width - 40;
            mcSave.x = param1.width - 160;
         }
         if(this._descentDebuff)
         {
            this._descentDebuff.x = param1.width - 160;
         }
         if(this.m_creatureContainer)
         {
            _loc2_ = this._creatureButtons.length;
            if(_loc2_)
            {
               while(_loc3_ < _loc2_)
               {
                  this._creatureButtons[_loc3_].x = 14;
                  this._creatureButtons[_loc3_].y = 34 + _loc3_ * 53;
                  _loc3_++;
               }
               this._creatureButtonsMC._mc._bottomBar.y = Math.min(GLOBAL._SCREEN.height - 450,this._creatureButtons[_loc2_ - 1].y + this._creatureButtons[_loc2_ - 1].height - this._creatureButtonsMC._mc._bottomBar.height * 0.8);
            }
            (this.m_creatureContainer.mask as Sprite).graphics.clear();
            (this.m_creatureContainer.mask as Sprite).graphics.beginFill(16777215,1);
            (this.m_creatureContainer.mask as Sprite).graphics.drawRect(0,22,200,GLOBAL._SCREEN.height - 476);
            (this.m_creatureContainer.mask as Sprite).graphics.endFill();
            this.m_creatureContainer.mask = this.m_creatureContainer.mask;
            this.m_scrollBar.checkResize();
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(mc.mcPoints)
            {
               mc.mcPoints.removeEventListener(MouseEvent.MOUSE_OVER,this.InfoShow);
               mc.mcPoints.removeEventListener(MouseEvent.MOUSE_OUT,this.InfoHide);
            }
            _loc1_ = 1;
            while(_loc1_ < 5)
            {
               if(mc["mcR" + _loc1_])
               {
                  if(mc["mcR" + _loc1_].mcHit)
                  {
                     mc["mcR" + _loc1_].mcHit.removeEventListener(MouseEvent.MOUSE_OVER,this.StatsShow(_loc1_,false));
                     mc["mcR" + _loc1_].mcHit.removeEventListener(MouseEvent.MOUSE_OUT,this.StatsHide);
                  }
                  if(mc["mcR" + _loc1_].bAdd)
                  {
                     mc["mcR" + _loc1_].bAdd.removeEventListener(MouseEvent.CLICK,this.Topup(_loc1_));
                  }
               }
               _loc1_++;
            }
            if(Boolean(mc.mcR5) && Boolean(mc.mcR5.bAdd))
            {
               mc.mcR5.bAdd.removeEventListener(MouseEvent.CLICK,BUY.Show);
            }
            if(Boolean(mc.mcOutposts) && Boolean(mc.mcOutposts.mcHit) && Boolean(mc.mcOutposts.bNext))
            {
               mc.mcOutposts.mcHit.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.mcOutposts.mcHit.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
               mc.mcOutposts.bNext.removeEventListener(MouseEvent.CLICK,BASE.LoadNext);
            }
            if(mc.bInvite)
            {
               mc.bInvite.removeEventListener(MouseEvent.CLICK,this.ButtonClick("invite"));
               mc.bInvite.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.bInvite.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            }
            if(mc.bGift)
            {
               mc.bGift.removeEventListener(MouseEvent.CLICK,this.ButtonClick("gift"));
               mc.bGift.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.bGift.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            }
            if(mc.bInbox)
            {
               mc.bInbox.removeEventListener(MouseEvent.CLICK,this.ButtonClick("inbox"));
               mc.bInbox.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.bInbox.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            }
            if(mc.bAlert)
            {
               mc.bAlert.removeEventListener(MouseEvent.CLICK,this.ButtonClick("alert"));
               mc.bAlert.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.bAlert.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            }
            if(mc.bEarn)
            {
               mc.bEarn.removeEventListener(MouseEvent.CLICK,this.ButtonClick("earn"));
               mc.bEarn.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.bEarn.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            }
            if(Boolean(mc.bDailyDeal) && GLOBAL._flags.showFBCDaily == 1)
            {
               mc.bDailyDeal.removeEventListener(MouseEvent.CLICK,this.ButtonClick("daily"));
               mc.bDailyDeal.removeEventListener(MouseEvent.MOUSE_OVER,this.ButtonInfoShow);
               mc.bDailyDeal.removeEventListener(MouseEvent.MOUSE_OUT,this.ButtonInfoHide);
            }
            removeEventListener(Event.ENTER_FRAME, onSpinnerTick);
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
         {
         }
      }
      
      public function ClearSiegeWeapon() : void
      {
         if(Boolean(this._siegeweapon) && Boolean(this._siegeweapon.parent))
         {
            this._siegeweapon.parent.removeChild(this._siegeweapon);
            this._siegeweapon = null;
         }
      }
      
      public function Topup(param1:int) : Function
      {
         var n:int = param1;
         return function(param1:MouseEvent = null):void
         {
            var _loc2_:* = Math.min((n - 1) * 0.4,1);
            if(BASE.isInfernoMainYardOrOutpost)
            {
               STORE.ShowB(2,_loc2_,["BR" + n + "1I","BR" + n + "2I","BR" + n + "3I"]);
            }
            else
            {
               STORE.ShowB(2,_loc2_,["BR" + n + "1","BR" + n + "2","BR" + n + "3"]);
            }
         };
      }
      
      public function Setup() : void
      {
         var onImageLoad:Function;
         var LoadImageError:Function;
         var loader:Loader = null;
         var mode:String = GLOBAL.mode;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != GLOBAL.e_BASE_MODE.IBUILD)
         {
            onImageLoad = function(param1:Event):void
            {
               mc.mcPic.mcBG.addChild(loader);
               if(Boolean(GLOBAL._flags.viximo) || Boolean(GLOBAL._flags.kongregate))
               {
                  loader.width = loader.height = 50;
               }
            };
            LoadImageError = function(param1:IOErrorEvent):void
            {
            };
            if(BASE._ownerName)
            {
               if(BASE._ownerName.toLowerCase().charAt(BASE._ownerName.length - 1) == "s")
               {
                  mc.mcPoints.tName.htmlText = KEYS.Get("uitop_yardownershort",{"v1":BASE._ownerName.toUpperCase()});
               }
               else
               {
                  mc.mcPoints.tName.htmlText = KEYS.Get("uitop_yardownerlong",{"v1":BASE._ownerName.toUpperCase()});
               }
            }
            else if(GLOBAL.mode == GLOBAL._loadmode)
            {
               mc.mcPoints.tName.htmlText = KEYS.Get("uitop_backyardmonsters");
            }
            else
            {
               mc.mcPoints.tName.htmlText = KEYS.Get("uitop_backyardmonstersinferno");
            }
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoad);
            if(GLOBAL._loadmode == "wmattack" || GLOBAL._loadmode == "wmview" || GLOBAL._loadmode == "iwmattack" || GLOBAL._loadmode == "iwmview")
            {
               loader.load(new URLRequest(GLOBAL._storageURL + BASE._ownerPic));
            }
            else if(Boolean(!GLOBAL._flags.viximo) || Boolean(!GLOBAL._flags.kongregate))
            {
               loader.load(new URLRequest(BASE._ownerPic));
            }
            else
            {
               loader.load(new URLRequest("http://graph.facebook.com/" + BASE._loadedFBID + "/picture"));
            }
         }
         else if(GLOBAL.mode == GLOBAL._loadmode)
         {
            mc.mcPoints.tName.htmlText = KEYS.Get("uitop_backyardmonsters");
         }
         else
         {
            mc.mcPoints.tName.htmlText = KEYS.Get("uitop_backyardmonstersinferno");
         }
         if((GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IWMATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IATTACK) && !MAPROOM_DESCENT.DescentPassed)
         {
            if(BASE.isInfernoMainYardOrOutpost && !MAPROOM_DESCENT.DescentPassed)
            {
               this.DescentDebuffShow();
            }
            else
            {
               this.DescentDebuffHide();
            }
         }
      }
      
      public function addIcon(param1:DisplayObject) : void
      {
         if(Boolean(mc) && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            param1.x = 222;
            param1.y = 0;
            this._kothIcon = mc.addChild(param1);
            mc.mcR5.x = 284;
            mc.bEarn.x = 415;
            mc.bDealSpot.x = 502;
            mc.bDailyDeal.x = 493;
         }
      }
      
      public function removeIcon(param1:DisplayObject) : void
      {
         if(Boolean(mc) && mc.contains(param1))
         {
            mc.removeChild(param1);
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               mc.mcR5.x = 227;
               mc.bEarn.x = 358;
               mc.bDailyDeal.x = 436;
               mc.bDealSpot.x = 445;
            }
         }
         if(this._kothIcon)
         {
            if(this._kothIcon.parent)
            {
               this._kothIcon.parent.removeChild(this._kothIcon);
            }
            this._kothIcon = null;
         }
      }
      
      public function addResourceBar(param1:DisplayObject) : void
      {
         var _loc2_:MovieClip = null;
         if(Boolean(mc) && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !BASE.isInfernoMainYardOrOutpost)
         {
            if(MapRoomManager.instance.isInMapRoom2)
            {
               _loc2_ = mc.mcOutposts;
            }
            else
            {
               _loc2_ = mc.mcR4;
            }
            param1.x = -4;
            param1.y = _loc2_.y + 37;
            this._daveClub = mc.addChild(param1);
            ++this.extraResourceRows;
            this.Update();
         }
      }
      
      public function removeResourceBar(param1:DisplayObject) : void
      {
         if(Boolean(mc) && mc.contains(param1))
         {
            mc.removeChild(param1);
            if(this.extraResourceRows > 0)
            {
               --this.extraResourceRows;
            }
         }
         if(this._daveClub)
         {
            if(this._daveClub.parent)
            {
               this._daveClub.parent.removeChild(this._daveClub);
            }
            this._daveClub = null;
         }
         this.Update();
      }
      
      public function BombSelect(param1:int) : Function
      {
         var n:int = param1;
         return function(param1:MouseEvent = null):void
         {
            MonsterDeselect();
            BombDeselect();
         };
      }
      
      public function BombDeselect() : void
      {
      }
      
      public function MonsterDeselect() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         for(_loc1_ in ATTACK._flingerBucket)
         {
            if(Boolean(ATTACK._flingerBucket[_loc1_]) && ATTACK._flingerBucket[_loc1_].Get() > 0)
            {
               ATTACK._curCreaturesAvailable[_loc1_].Add(ATTACK._flingerBucket[_loc1_].Get());
               ATTACK._flingerBucket[_loc1_].Set(0);
            }
         }
         ATTACK.BucketUpdate();
         _loc2_ = 0;
         while(_loc2_ < this._creatureButtons.length)
         {
            this._creatureButtons[_loc2_].Update();
            _loc2_++;
         }
      }
      
      public function StatsShow(param1:int, param2:Boolean) : Function
      {
         var n:int = param1;
         var topup:Boolean = param2;
         return function(param1:MouseEvent):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc5_:* = undefined;
            var _loc6_:* = undefined;
            var _loc7_:* = undefined;
            var _loc8_:* = undefined;
            if(n < 5)
            {
               if(topup)
               {
                  _loc2_ = "<b><font size=\"12\">" + KEYS.Get(GLOBAL._resourceNames[n - 1]) + "</font></b><br><b>" + KEYS.Get("bubble_topup") + "</b>";
                  _loc3_ = 2;
               }
               else if(MapRoomManager.instance.isInMapRoom2or3)
               {
                  _loc5_ = BaseBuffHandler.instance.getBuffByName(AutoBankBaseBuff.k_NAME) as AutoBankBaseBuff;
                  _loc6_ = MapRoomManager.instance.isInMapRoom3 && _loc5_ ? _loc5_.value * 3600 : BASE.getEmpireResources(n);
                  if(BASE.yardType === EnumYardType.RESOURCE)
                  {
                     _loc7_ = InstanceManager.getInstancesByClass(ResourceOutpost)[0] as ResourceOutpost;
                  }
                  _loc8_ = MapRoomManager.instance.isInMapRoom3 && _loc7_ ? _loc7_.resourcesPerSecond * 3600 : BASE._resources["r" + n + "Rate"];
                  _loc2_ = KEYS.Get("pop_resource2",{
                     "v1":KEYS.Get(GLOBAL._resourceNames[n - 1]),
                     "v2":GLOBAL.FormatNumber(BASE._resources["r" + n + "max"]),
                     "v3":GLOBAL.FormatNumber(_loc8_),
                     "v4":GLOBAL.FormatNumber(_loc6_)
                  });
                  _loc3_ = 4;
               }
               else
               {
                  _loc2_ = "<b><font size=\"12\">" + KEYS.Get(GLOBAL._resourceNames[n - 1]) + "</font></b><br>" + KEYS.Get("pop_resource",{
                     "v1":GLOBAL.FormatNumber(BASE._resources["r" + n + "max"]),
                     "v2":GLOBAL.FormatNumber(BASE._resources["r" + n + "Rate"])
                  });
                  _loc3_ = 3;
               }
            }
            else
            {
               _loc2_ = "<b>" + KEYS.Get("bubble_getshiny") + "</b>";
               _loc3_ = 2;
            }
            var _loc4_:* = mc["mcR" + n];
            BubbleShow(_loc4_.x + 135,_loc4_.y + int(_loc4_.height * 0.5),_loc2_,_loc3_);
         };
      }
      
      public function StatsHide(param1:MouseEvent) : void
      {
         this.BubbleHide();
      }
      
      public function OverchargeShow(param1:int) : void
      {
         if(!this._popupWarning)
         {
            this._popupWarning = addChild(new bubblepopup4()) as bubblepopup4;
         }
         this._popupWarning.tA.htmlText = BASE.isInfernoMainYardOrOutpost ? KEYS.Get("inf_ui_needmoreroom") : KEYS.Get("ui_needmoreroom");
         this._popupWarning.x = 150;
         this._popupWarning.y = 20 + 41 * param1;
         this._popupWarning.Wobble();
      }
      
      public function OverchargeHide() : void
      {
         if(this._popupWarning)
         {
            removeChild(this._popupWarning);
            this._popupWarning = null;
         }
      }
      
      public function UpdateTweenResourceText(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:int = param1;
         _loc5_ = Number((_loc4_ = mc["mcR" + _loc2_])._resource);
         _loc4_.tR.htmlText = "<b>" + GLOBAL.FormatNumber(_loc5_) + "</b>";
         _loc3_ = 90 / BASE._resources["r" + _loc2_ + "max"] * _loc5_;
         if(_loc3_ > 90)
         {
            _loc3_ = 90;
         }
         _loc4_.mcBar.width = _loc3_;
      }
      
      public function Update() : void
      {
         var _loc1_:Object = null;
         if(!GLOBAL._catchup)
         {
            if(GLOBAL._loadmode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IBUILD)
            {
               this.updateBuildMode();
            }
            else if(MapRoomManager.instance.isInMapRoom3 && (GLOBAL._loadmode === GLOBAL.e_BASE_MODE.VIEW || GLOBAL._loadmode === GLOBAL.e_BASE_MODE.WMVIEW))
            {
               this.updateScoutMode();
            }
            else if(GLOBAL._loadmode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.IWMATTACK || MapRoomManager.instance.isInMapRoom3 && (GLOBAL._loadmode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL._loadmode == GLOBAL.e_BASE_MODE.WMATTACK))
            {
               this.updateAttackMode();
            }
            _loc1_ = BASE.BaseLevel();
            this.SetPoints(_loc1_.lower,_loc1_.upper,_loc1_.needed,_loc1_.points,_loc1_.level,false);
         }
      }
      
      private function updateBuildMode() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:MovieClip = null;
         var _loc3_:Number = Number(BASE._resources["r" + 1].Get());
         var _loc4_:Number = Number(BASE._resources["r" + 2].Get());
         var _loc5_:Number = Number(BASE._resources["r" + 3].Get());
         var _loc6_:Number = Number(BASE._resources["r" + 4].Get());
         TweenLite.to(mc.mcR1,0.5,{
            "_resource":_loc3_,
            "onUpdate":this.UpdateTweenResourceText,
            "onUpdateParams":[1],
            "ease":Linear.easeNone,
            "overwrite":1
         });
         TweenLite.to(mc.mcR2,0.5,{
            "_resource":_loc4_,
            "onUpdate":this.UpdateTweenResourceText,
            "onUpdateParams":[2],
            "ease":Linear.easeNone,
            "overwrite":1
         });
         TweenLite.to(mc.mcR3,0.5,{
            "_resource":_loc5_,
            "onUpdate":this.UpdateTweenResourceText,
            "onUpdateParams":[3],
            "ease":Linear.easeNone,
            "overwrite":1
         });
         TweenLite.to(mc.mcR4,0.5,{
            "_resource":_loc6_,
            "onUpdate":this.UpdateTweenResourceText,
            "onUpdateParams":[4],
            "ease":Linear.easeNone,
            "overwrite":1
         });
         mc["mcR" + 5].tR.htmlText = "<b>" + GLOBAL.FormatNumber(BASE._credits.Get()) + "</b>";
         if(MapRoomManager.instance.isInMapRoom2)
         {
            mc.mcOutposts.visible = true;
            mc.mcOutposts.tR.htmlText = GLOBAL._mapOutpost.length;
         }
         else
         {
            mc.mcOutposts.visible = false;
         }
         if(TUTORIAL._stage < 200)
         {
            mc.bInvite.visible = false;
            mc.bGift.visible = false;
            mc.bInbox.visible = false;
            mc.bAlert.visible = false;
            mc.mcR5.bAdd.visible = false;
            mc.bEarn.visible = false;
            mc.bDailyDeal.visible = false;
            _loc1_ = 1;
            while(_loc1_ < 6)
            {
               mc["mcR" + _loc1_].bAdd.visible = false;
               _loc1_++;
            }
            this.SortButtonIcons();
         }
         else
         {
            if(GLOBAL._flags.sroverlay)
            {
               mc.mcR5.bAdd.visible = true;
            }
            else
            {
               mc.mcR5.bAdd.visible = true;
            }
            mc.bEarn.visible = GLOBAL._flags.showFBCEarn == 1;
            mc.bDailyDeal.visible = GLOBAL._flags.showFBCDaily == 1;
            _loc1_ = 1;
            while(_loc1_ < 6)
            {
               if(!mc["mcR" + _loc1_].bAdd.visible)
               {
                  mc["mcR" + _loc1_].bAdd.visible = true;
               }
               _loc1_++;
            }
            _loc7_ = 0;
            if(GLOBAL._canInvite && !GLOBAL._flags.kongregate)
            {
               if(GLOBAL._sessionCount >= 2 && !GLOBAL._canGift && GLOBAL.Timestamp() - GLOBAL.StatGet("pi") > 60 * 60 * 36)
               {
                  mc.bInvite.mcSpinner.visible = true;
               }
               else
               {
                  mc.bInvite.mcSpinner.visible = false;
               }
               mc.bInvite.visible = true;
            }
            else
            {
               mc.bInvite.visible = false;
            }
            if(mc.bInvite.visible)
            {
               mc.bInvite.visible = BYMConfig.instance.INVITE_BUTTON;
            }
            _loc8_ = this.extraResourceRows * this._RESOURCEBAR_HEIGHT;
            this.SortButtonIcons(2,4,_loc8_);
            mc.bGift.visible = true;
            if((_loc7_ = POPUPS.QueueCount("gifts")) > 0)
            {
               mc.bGift.mcSpinner.visible = true;
               mc.bGift.mcCounter.visible = true;
               if(_loc7_ < 10)
               {
                  mc.bGift.mcCounter.t.htmlText = "<b>" + _loc7_ + "</b>";
               }
               else
               {
                  mc.bGift.mcCounter.t.htmlText = "<b>+</b>";
               }
            }
            else
            {
               mc.bGift.mcSpinner.visible = false;
               mc.bGift.mcCounter.visible = false;
            }
            mc.bInbox.visible = true;
            if(GLOBAL._unreadMessages > 0)
            {
               mc.bInbox.mcCounter.t.htmlText = "<b>" + GLOBAL._unreadMessages + "</b>";
               mc.bInbox.mcCounter.visible = true;
               mc.bInbox.mcSpinner.visible = true;
            }
            else
            {
               mc.bInbox.mcCounter.visible = false;
               mc.bInbox.mcSpinner.visible = false;
            }
            if((_loc7_ = POPUPS.QueueCount("alerts")) > 0)
            {
               mc.bAlert.visible = true;
               mc.bAlert.mcSpinner.visible = true;
               mc.bAlert.mcCounter.visible = true;
               if(_loc7_ < 10)
               {
                  mc.bAlert.mcCounter.t.htmlText = "<b>" + _loc7_ + "</b>";
               }
               else
               {
                  mc.bAlert.mcCounter.t.htmlText = "<b>+</b>";
               }
            }
            else
            {
               mc.bAlert.visible = false;
            }
            this.DisplayBuffs();
            if(this._kothIcon)
            {
               _loc9_ = Boolean(CREATURES._krallen);
               _loc10_ = 0;
               if(_loc9_)
               {
                  _loc10_ = CREATURES._krallen._level.Get();
               }
               (this._kothIcon as KOTHHUDGraphic).update(_loc9_,_loc10_);
            }
            if(this._daveClub)
            {
               _loc11_ = SubscriptionHandler.instance.isSubscriptionActive;
               (this._daveClub as MovieClip).gotoAndStop(_loc11_ ? "on" : "off");
               if(MapRoomManager.instance.isInMapRoom2)
               {
                  _loc12_ = mc.mcOutposts;
               }
               else
               {
                  _loc12_ = mc.mcR4;
               }
               this._daveClub.x = -4;
               this._daveClub.y = _loc12_.y + 37;
            }
         }
      }
      
      private function updateAttackMode() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc6_:String = null;
         var _loc7_:* = false;
         var _loc1_:int = int(this._creatureButtons.length);
         _loc2_ = 1;
         while(_loc2_ < 5)
         {
            _loc3_ = mc["mcR" + _loc2_];
            _loc3_.tR.htmlText = "<b>" + GLOBAL.FormatNumber(ATTACK._loot["r" + _loc2_].Get()) + "</b>";
            _loc3_.mcBar.visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this._creatureButtons[_loc2_].Update();
            _loc2_++;
         }
         var _loc4_:int = int(GLOBAL._buildingProps[4].capacity[GLOBAL._attackersFlinger - 1]);
         if(MAPROOM_DESCENT.InDescent)
         {
            _loc4_ = int(YARD_PROPS._yardProps[4].capacity[GLOBAL._attackersFlinger - 1]);
         }
         if(POWERUPS.CheckPowers(POWERUPS.ALLIANCE_DECLAREWAR,"OFFENSE"))
         {
            _loc4_ += _loc4_ * 0.25;
         }
         var _loc5_:int = _loc4_;
         if(MapRoomManager.instance.isInMapRoom3 && ATTACK.USE_CUMULATIVE_FLINGER_CAPACITY)
         {
            _loc5_ -= ATTACK._flungSpace.Get();
         }
         for(_loc6_ in ATTACK._flingerBucket)
         {
            _loc7_ = _loc6_.substr(0,1) === "G";
            if(!MapRoomManager.instance.isInMapRoom3 && _loc7_)
            {
               _loc5_ -= CHAMPIONCAGE.GetGuardianProperty(_loc6_.substr(0,2),1,"bucket");
            }
            else if(!_loc7_)
            {
               _loc5_ -= CREATURES.GetProperty(_loc6_,"bucket") * ATTACK._flingerBucket[_loc6_].Get();
            }
         }
         this._creatureButtonsMC._mc._txtContainer.mcBar.width = 115 - 115 / _loc4_ * _loc5_;
         if(MapRoomManager.instance.isInMapRoom3)
         {
            this._creatureButtonsMC._mc._txtContainer.mcBar.scaleX = (1 - _loc5_ / _loc4_) * 1.2;
         }
         else
         {
            this._creatureButtonsMC._mc._txtContainer.mcBar.scaleX = (100 - 100 / _loc4_ * _loc5_) / 100;
         }
         if(GLOBAL._attackersFlinger)
         {
            if(MapRoomManager.instance.isInMapRoom3)
            {
               this._creatureButtonsMC._mc._txtContainer.tA.width = 60;
               this._creatureButtonsMC._mc._txtContainer.tA.htmlText = (_loc4_ - _loc5_).toString() + "/" + _loc4_.toString();
            }
            else
            {
               this._creatureButtonsMC._mc._txtContainer.tA.width = 56;
               this._creatureButtonsMC._mc._txtContainer.tA.htmlText = Math.min(100,int((1 - _loc5_ / _loc4_) * 100)).toString() + "%";
            }
         }
         if(GLOBAL.mode != GLOBAL._loadmode)
         {
            if(ATTACK._countdown > 0)
            {
               mc.tMessage.htmlText = KEYS.Get("attack_ui_attacklock");
            }
            else
            {
               mc.tMessage.htmlText = KEYS.Get("attack_ui_attackends");
            }
         }
         else if(ATTACK._countdown > 0)
         {
            mc.tMessage.htmlText = KEYS.Get("attack_ui_flingerlock");
         }
         else
         {
            mc.tMessage.htmlText = KEYS.Get("attack_ui_attackends");
         }
         if(ATTACK._countdown > 30)
         {
            mc.tTime.htmlText = GLOBAL.ToTime(ATTACK._countdown,true);
         }
         else if(ATTACK._countdown > 0)
         {
            mc.tTime.htmlText = "<font color=\"#FF0000\">" + GLOBAL.ToTime(ATTACK._countdown,true) + "</font>";
         }
         else if(ATTACK._countdown > -120)
         {
            mc.tTime.htmlText = "<font color=\"#FFFFFF\">" + GLOBAL.ToTime(120 + ATTACK._countdown,true) + "</font>";
         }
         else
         {
            mc.tTime.htmlText = "<font color=\"#FFFFFF\">" + KEYS.Get("attack_ui_over") + "</font>";
         }
      }
      
      private function updateScoutMode() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc1_:int = int(this._creatureButtons.length);
         _loc2_ = 1;
         while(_loc2_ < 5)
         {
            _loc3_ = mc["mcR" + _loc2_];
            _loc3_.tR.htmlText = "<b>" + GLOBAL.FormatNumber((GLOBAL._currentCell as MapRoom3Cell).attackCost[_loc2_ - 1]) + "</b>";
            _loc3_.mcBar.visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this._creatureButtons[_loc2_].Update();
            _loc2_++;
         }
         if(GLOBAL.mode != GLOBAL._loadmode)
         {
            if(ATTACK._countdown > 0)
            {
               mc.tMessage.htmlText = KEYS.Get("attack_ui_attacklock");
            }
            else
            {
               mc.tMessage.htmlText = KEYS.Get("attack_ui_attackends");
            }
         }
         else if(ATTACK._countdown > 0)
         {
            mc.tMessage.htmlText = KEYS.Get("attack_ui_flingerlock");
         }
         else
         {
            mc.tMessage.htmlText = KEYS.Get("attack_ui_attackends");
         }
         if(ATTACK._countdown > 30)
         {
            mc.tTime.htmlText = GLOBAL.ToTime(ATTACK._countdown,true);
         }
         else if(ATTACK._countdown > 0)
         {
            mc.tTime.htmlText = "<font color=\"#FF0000\">" + GLOBAL.ToTime(ATTACK._countdown,true) + "</font>";
         }
         else if(ATTACK._countdown > -120)
         {
            mc.tTime.htmlText = "<font color=\"#FFFFFF\">" + GLOBAL.ToTime(120 + ATTACK._countdown,true) + "</font>";
         }
         else
         {
            mc.tTime.htmlText = "<font color=\"#FFFFFF\">" + KEYS.Get("attack_ui_over") + "</font>";
         }
      }
      
      public function SortButtonIcons(param1:int = 2, param2:int = 4, param3:int = 0) : void
      {
         var _loc4_:int = 9;
         var _loc5_:int = 195;
         var _loc6_:int = param1;
         var _loc7_:int = param2;
         var _loc8_:int = 67;
         var _loc9_:int = 55;
         var _loc10_:int = param3;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(MapRoomManager.instance.isInMapRoom2)
         {
            _loc10_ += 35;
         }
         var _loc14_:int = 0;
         while(_loc14_ < this._buttonIcons.length)
         {
            if(this._buttonIcons[_loc14_].visible)
            {
               this._buttonIcons[_loc14_].x = _loc4_ + _loc11_;
               this._buttonIcons[_loc14_].y = _loc5_ + _loc10_;
               _loc13_++;
               _loc10_ += _loc9_;
               if(_loc13_ >= _loc7_)
               {
                  _loc13_ = 0;
                  _loc12_++;
                  _loc10_ = 0;
                  _loc11_ += _loc8_;
               }
            }
            _loc14_++;
         }
      }
      
      public function InitDealspot() : void
      {
         if(mc.bDealSpot)
         {
            mc.bDealSpot.visible = true;
            mc.bDealSpot.buttonMode = true;
            mc.bDealSpot.mouseChildren = true;
            while(mc.bDealSpot.numChildren)
            {
               mc.bDealSpot.removeChildAt(0);
            }
            this._dealspot = new DealSpot(this);
            this._dealspot.x = -5;
            this._dealspot.y = -5;
            mc.bDealSpot.addChild(this._dealspot);
         }
         else if(mc.bDealSpot)
         {
            mc.bDealSpot.visible = false;
            mc.bDealSpot.mouseChildren = false;
            this._dealspot = null;
         }
      }
      
      public function ButtonClick(param1:String) : Function
      {
         var label:String = param1;
         return function(param1:MouseEvent):void
         {
            if(label == "gift")
            {
               if(POPUPS.QueueCount("gifts") > 0 && GLOBAL._flags.gifts == 1)
               {
                  POPUPS.Show("gifts");
               }
               else
               {
                  // POPUPS.Gift();
                  GLOBAL.Message(KEYS.Get("disabled_gifts"));
               }
            }
            else if(label == "alert")
            {
               if (BASE._currentAttacks && BASE._currentAttacks.length > 0)
               {
                  for each (var attack:Object in BASE._currentAttacks)
                  {
                     attack.seen = true;
                  }
                  BASE._attacksModified = true;
                  BASE.Save();
               }
               POPUPS.Show("alerts");
            }
            else if(label == "invite")
            {
               if (GLOBAL._flags.invites == 1)
               {
                  POPUPS.Invite();
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("disabled_invites"));
               }
            }
            else if(label == "inbox")
            {
               if(GLOBAL._flags.messaging == 1)
               {
                  MAILBOX.Show();
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("disabled_mail"));
               }
            }
            else if(label == "daily")
            {
               BUY.Offers("daily");
            }
            else if(label == "earn")
            {
               GLOBAL.Message(KEYS.Get("discord_earn"));
            }
         };
      }
      
      public function DescentDebuffShow() : void
      {
         var _loc1_:Boolean = (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK) && BASE.isInfernoMainYardOrOutpost && !MAPROOM_DESCENT.DescentPassed && (MAPROOM_DESCENT.DescentLevel > 6 && MAPROOM_DESCENT.DescentLevel < MAPROOM_DESCENT._descentLvlMax);
         if(this._descentDebuff)
         {
            this.DescentDebuffHide();
         }
         if(_loc1_)
         {
            this._descentDebuff = new DescentDebuffPopup();
            this._descentDebuff.Show(MAPROOM_DESCENT.DescentLevel);
         }
      }
      
      public function DescentDebuffHide() : void
      {
         if(this._descentDebuff)
         {
            this._descentDebuff.Hide();
         }
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
         if(BASE.isInfernoMainYardOrOutpost)
         {
            this.BuffHide(null);
            return;
         }
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
            _loc11_ = POWERUPS.GetPowerups();
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
         var _loc8_:bubblepopupBuff = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:String = "";
         var _loc4_:* = "";
         var _loc5_:BaseBuff;
         _loc5_ = BaseBuff(BaseBuffHandler.instance.getBuffByName(_loc2_.name));
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:String = _loc5_.description;
         var _loc7_:String = "buff_duration";
         _loc3_ = _loc6_;
         _loc4_ = "<b>" + KEYS.Get(_loc7_) + "</b>";
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
            _loc8_ = new bubblepopupBuff();
            this._popupBuff = addChild(_loc8_) as bubblepopupBuff;
            _loc8_.Setup(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height + 4,_loc3_,_loc4_);
            _loc8_.x = this.mcBuffHolder.x + (_loc2_.x + _loc2_.width / 2);
            _loc8_.y = this.mcBuffHolder.y + (_loc2_.y + _loc2_.height + 4);
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
      
      public function ButtonInfoShow(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = param1.target.x + 50;
         var _loc3_:int = param1.target.y + 25;
         var _loc5_:Boolean = true;
         switch(param1.target.name)
         {
            case "bInvite":
               _loc4_ = KEYS.Get("pop_invite");
               break;
            case "bGift":
               if(POPUPS.QueueCount("gifts") > 0)
               {
                  _loc4_ = KEYS.Get("pop_acceptgifts",{"v1":POPUPS.QueueCount("gifts")});
               }
               else
               {
                  _loc4_ = KEYS.Get("pop_sendgifts");
               }
               break;
            case "bInbox":
               _loc4_ = KEYS.Get("pop_mailbox");
               break;
            case "bAlert":
               _loc4_ = KEYS.Get("pop_alerts");
               break;
            case "mcHit":
               _loc4_ = KEYS.Get("pop_outposts");
               _loc2_ = param1.target.parent.x + 140;
               _loc3_ = param1.target.parent.y + 20;
               break;
            case "bDealSpot":
            case "_dealspot":
               _loc4_ = "<b>DealSpot Offers</b><br>Check DealSpot to earn Shiny.";
               _loc2_ = param1.target.parent.x + 40;
               _loc3_ = param1.target.parent.y + 20;
               if(Boolean(this._dealspot) && this._dealspot._hasOffers)
               {
                  _loc4_ = "<b>DealSpot Offers</b><br>Check DealSpot to earn Shiny.";
                  _loc3_ = param1.target.parent.y + 25;
                  break;
               }
               _loc4_ = " ";
               mc.bDealSpot.mouseChildren = false;
               this.BubbleHide();
               mc.bDealSpot.visible = false;
               mc.bDealSpot.enabled = false;
               if(Boolean(this._dealspot) && Boolean(this._dealspot.parent))
               {
                  this._dealspot.parent.removeChild(this._dealspot);
               }
               _loc5_ = false;
               return;
         }
         if(_loc5_ && _loc4_ != null)
         {
            this.BubbleShow(_loc2_,_loc3_,_loc4_);
         }
         else if(_loc4_ == null)
         {
         }
      }
      
      public function ButtonInfoHide(param1:MouseEvent) : void
      {
         this.BubbleHide();
      }
      
      private function SetPoints(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:Boolean) : void
      {
         var _loc7_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            mc.mcPoints.mcLevel.text = param5.toString();
            _loc7_ = 200 / (param2 - param1) * (param4 - param1);
            TweenLite.to(mc.mcPoints.mcBar,0.6,{
               "width":_loc7_,
               "ease":Elastic.easeInOut
            });
            if(param6)
            {
               mc.mcPoints.mcStar.scaleX = mc.mcPoints.mcStar.scaleY = 0.8;
               mc.mcPoints.mcStar.rotation = 180;
               TweenLite.to(mc.mcPoints.mcStar,1,{
                  "scaleX":1,
                  "scaleY":1,
                  "rotation":0,
                  "ease":Elastic.easeOut
               });
            }
         }
      }
      
      public function BubbleShow(param1:int, param2:int, param3:String, param4:int = 3) : void
      {
         var _loc5_:bubblepopup3;
         (_loc5_ = new bubblepopup3()).Setup(param1,param2,param3,param4);
         _loc5_.Wobble();
         this._bubbleDo = this.addChild(_loc5_);
      }
      
      public function BubbleHide() : void
      {
         if(Boolean(this._bubbleDo) && Boolean(this._bubbleDo.parent))
         {
            this.removeChild(this._bubbleDo);
         }
      }
      
      public function validateSiegeWeapon() : Boolean
      {
         if(this._siegeweapon == null)
         {
            return false;
         }
         var _loc1_:Boolean = this._siegeweapon.validate();
         if(!_loc1_)
         {
            this.ClearSiegeWeapon();
         }
         return _loc1_;
      }
   }
}

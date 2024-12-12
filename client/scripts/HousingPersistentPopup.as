package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.player.CreepInfo;
   import com.monsters.player.MonsterData;
   import com.monsters.player.Player;
   import com.monsters.ui.popups.PersistantJuiceAllPopup;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HousingPersistentPopup extends HousingPersistentPopup_CLIP
   {
       
      
      public var _juiceList:Object;
      
      public var m_monsterBarList:Object;
      
      private var m_bunkerIDList:Array;
      
      public var _scroller:ScrollSet;
      
      private var m_strLastSelectedJuiced:String = "";
      
      private var m_nJuiceAmount:int = 0;
      
      private var m_bShownPopup:Boolean = false;
      
      private var m_JuiceAllPopup:PersistantJuiceAllPopup;
      
      private const k_juiceAllPopupLimit:int = 5;
      
      private const k_offsetY:int = 51;
      
      private const k_offsetTextY:int = 25;
      
      private const k_titlesX:int = 15;
      
      private const k_aBit:int = 8;
      
      public function HousingPersistentPopup()
      {
         var _loc1_:int = 0;
         var _loc10_:String = null;
         var _loc11_:HousingPersistentMonsterBar = null;
         var _loc12_:int = 0;
         this._juiceList = {};
         this.m_monsterBarList = {};
         this.m_bunkerIDList = [];
         super();
         if(!BASE.isInfernoMainYardOrOutpost)
         {
            bTransfer.SetupKey("btn_ascendmonsters");
            bTransfer.addEventListener(MouseEvent.CLICK,this.ascend);
         }
         else
         {
            bTransfer.visible = false;
         }
         bJuice.SetupKey("mh_nomonsters_btn");
         bJuice.addEventListener(MouseEvent.CLICK,this.juiceCheck);
         bClear.SetupKey("btn_clear");
         bClear.addEventListener(MouseEvent.CLICK,this.selectNone);
         bHealAll.SetupKey("btn_housing_heal_all");
         bHealAll.Highlight = true;
         bHealAll.addEventListener(MouseEvent.CLICK,this.healInstantAllShinyCheck);
         tHealthText.htmlText = "<b>" + KEYS.Get("mh_health_column_label") + "</b>";
         tCapacityText.htmlText = "<b>" + KEYS.Get("mh_capacity_column_label") + "</b>";
         if(GLOBAL._bJuicer)
         {
            tJuicingText.htmlText = KEYS.Get("mh_juicing_txt");
         }
         else
         {
            tJuicingText.htmlText = "";
            bJuice.visible = false;
            bClear.visible = false;
         }
         tTitleHealing.htmlText = KEYS.Get("mh_healing_section_label");
         tTitleHealing.visible = false;
         tTitleHousing.htmlText = KEYS.Get("mh_housing_section_label");
         tTitleBunkers.htmlText = KEYS.Get("mh_bunkers_section_label");
         tTitleBunkers.visible = false;
         m_bgWhite.x = m_bgWhite.y = 0;
         m_bgWhite.height = 0;
         monsterContainer.addChild(m_bgWhite);
         gotoAndStop(1);
         this._juiceList = {};
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 215;
         var _loc5_:int = 6;
         var _loc6_:int = 3;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = [];
         _loc9_ = this.getHousableCreatures();
         _loc1_ = 0;
         while(_loc1_ < _loc9_.length)
         {
            _loc10_ = String(_loc9_[_loc1_].id);
            (_loc11_ = new HousingPersistentMonsterBar(_loc10_)).x = 0;
            _loc3_ = _loc1_;
            _loc11_.y = _loc3_ * this.k_offsetY;
            _loc11_.mouseChildren = true;
            monsterContainer.addChild(_loc11_);
            this.m_monsterBarList[_loc10_] = _loc11_;
            _loc12_ = 0;
            if(_loc10_.substr(0,1) != "B")
            {
               _loc12_ = GLOBAL.player.monsterListByID(_loc10_).numHousedCreeps;
               ImageCache.GetImageWithCallBack("monsters/" + _loc10_ + "-medium.jpg",this.iconLoaded,true,1,"",[_loc11_.mcIcon]);
               _loc11_.tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[_loc10_].name) + "</b> x" + _loc12_;
            }
            else
            {
               ImageCache.GetImageWithCallBack("monsters/bunker-medium.jpg",this.iconLoaded,true,1,"",[_loc11_.mcIcon]);
               _loc11_.tName.htmlText = "<b>" + KEYS.Get("#b_monsterbunker#") + "</b>";
            }
            _loc11_.m_healthBar.mcBar.width = HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth * GLOBAL.player.curHealthByID(_loc10_) / GLOBAL.player.totalHealthByID(_loc10_);
            _loc11_.m_capacityBar.mcBar.width = HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth * GLOBAL.player.getStorageByID(_loc10_) / HOUSING._housingCapacity.Get();
            _loc11_.m_capacityBar.mcBarGrey.width = _loc11_.m_capacityBar.mcBar.width;
            _loc11_.tCapacityText.htmlText = "<b>" + GLOBAL.player.getStorageByID(_loc10_) + "</b>";
            _loc11_.tHealStatusText.htmlText = "";
            if(GLOBAL.player.checkQueued(_loc10_))
            {
               this.setHealMode(_loc11_);
            }
            else
            {
               this.setNormalMode(_loc11_);
            }
            _loc11_.buttonMode = false;
            _loc1_++;
         }
         tCapacityText.x = 320;
         tHealthText.x = 145;
         tCapacityText.y = tHealthText.y = this.k_aBit;
         monsterContainer.addChild(tHealthText);
         monsterContainer.addChild(tCapacityText);
         tTitleBunkers.x = tTitleHousing.x = tTitleHealing.x = this.k_titlesX;
         tTitleBunkers.y = tTitleHousing.y = tTitleHealing.y = this.k_aBit;
         monsterContainer.addChild(tTitleHealing);
         monsterContainer.addChild(tTitleHousing);
         monsterContainer.addChild(tTitleBunkers);
         m_line.visible = false;
         monsterContainer.addChild(m_line);
         mcStorage.mcBarB.width = 535 / HOUSING._housingCapacity.Get() * HOUSING._housingUsed.Get();
         this._scroller = new ScrollSet();
         this._scroller.x = 310;
         this._scroller.y = -145;
         this._scroller.width = 21;
         this._scroller.AutoHideEnabled = false;
         this._scroller.isHiddenWhileUnnecessary = true;
         addChild(this._scroller);
         monsterContainer.mask = monsterContainerMask;
         this._scroller.Init(monsterContainer as Sprite,monsterContainerMask as MovieClip,0,-145,240,30);
         if(BASE.isInfernoMainYardOrOutpost)
         {
            title_txt.htmlText = KEYS.Get("mhi_title");
            capacity_desc_txt.htmlText = "<b>" + KEYS.Get("compound_capacity_desc") + "</b>";
            tAscendText.htmlText = "";
         }
         else
         {
            title_txt.htmlText = KEYS.Get("mh_title");
            capacity_desc_txt.htmlText = "<b>" + KEYS.Get("mh_capacity_desc") + "</b>";
            tAscendText.htmlText = "";
         }
         this.Update();
         this.reorganize();
      }
      
      private function numHurtCreeps(param1:String) : Number
      {
         var _loc2_:int = GLOBAL.player.monsterListByID(param1).numHousedCreeps;
         return _loc2_ - _loc2_ * (GLOBAL.player.curHealthByID(param1) / GLOBAL.player.totalHealthByID(param1));
      }
      
      private function refundResourcesEvent(param1:MouseEvent = null) : void
      {
         var _loc2_:String = (param1.target.parent as HousingPersistentMonsterBar).m_creatureID;
         GLOBAL.player.refundResources(_loc2_,true);
         this.healQueueRemove(param1.target.parent as HousingPersistentMonsterBar);
      }
      
      private function attemptHeal(param1:MouseEvent = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:MESSAGE = null;
         var _loc2_:String = (param1.target.parent as HousingPersistentMonsterBar).m_creatureID;
         var _loc3_:int = GLOBAL.player.getResourceCostByID(_loc2_);
         var _loc4_:Boolean = _loc2_.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost;
         this.selectNone();
         if(BASE.Charge(4,_loc3_,true,_loc4_))
         {
            BASE.Charge(4,_loc3_,false,_loc4_);
            this.healQueueAdd(param1.target.parent as HousingPersistentMonsterBar);
         }
         else
         {
            _loc5_ = _loc4_ ? int(BASE._iresources.r4.Get()) : int(BASE._resources.r4.Get());
            _loc3_ -= _loc5_;
            _loc6_ = GLOBAL.getShinyCostFromResourceAmt(_loc3_);
            _loc7_ = int(GLOBAL.player.getNumToHealByResourceCost(_loc2_,_loc5_).num);
            _loc8_ = _loc2_.substr(0,1) == "B" ? "msg_moreresourcesheal" : (_loc2_.substr(0,1) == "I" ? "msg_moremagmaheal2" : "msg_moreresourcesheal2");
            if(_loc7_)
            {
               if((param1.target.parent as HousingPersistentMonsterBar).m_creatureID.substr(0,1) == "B")
               {
                  _loc9_ = GLOBAL.Message(KEYS.Get(_loc8_,{
                     "v1":GLOBAL.FormatNumber(_loc3_),
                     "v2":GLOBAL.FormatNumber(_loc6_)
                  }),KEYS.Get("buildoptions_shiny",{"v1":_loc6_}),this.startHealWithShiny,[param1.target.parent as HousingPersistentMonsterBar]);
               }
               else
               {
                  _loc9_ = GLOBAL.Message(KEYS.Get(_loc8_,{
                     "v1":_loc7_,
                     "v2":GLOBAL.FormatNumber(_loc3_),
                     "v3":GLOBAL.FormatNumber(_loc6_)
                  }),KEYS.Get("buildoptions_shiny",{"v1":_loc6_}),this.startHealWithShiny,[param1.target.parent as HousingPersistentMonsterBar],KEYS.Get("btn_healmon",{"v1":_loc7_}),this.healPartialWithGoo,[param1.target.parent as HousingPersistentMonsterBar]);
               }
            }
            else
            {
               _loc9_ = GLOBAL.Message(KEYS.Get(_loc8_,{
                  "v1":_loc7_,
                  "v2":GLOBAL.FormatNumber(_loc3_),
                  "v3":GLOBAL.FormatNumber(_loc6_)
               }),KEYS.Get("buildoptions_shiny",{"v1":_loc6_}),this.startHealWithShiny,[param1.target.parent as HousingPersistentMonsterBar]);
            }
            _loc9_.bAction.Highlight = true;
         }
      }
      
      private function healPartialWithGoo(param1:HousingPersistentMonsterBar) : void
      {
         var _loc2_:String = param1.m_creatureID;
         var _loc3_:Boolean = _loc2_.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost;
         var _loc4_:Number = _loc3_ ? Number(BASE._iresources.r4.Get()) : Number(BASE._resources.r4.Get());
         var _loc5_:Number = 0;
         var _loc6_:Object;
         if(!(_loc6_ = GLOBAL.player.getNumToHealByResourceCost(_loc2_,_loc4_)).num)
         {
            return;
         }
         GLOBAL.player.queuePartialHeal(_loc2_,_loc6_.num);
         BASE.Charge(4,_loc4_ - _loc6_.resoLeft,false,_loc3_);
         this.setHealMode(param1);
         this.updateHealAllButton();
         BASE.SaveB();
      }
      
      private function startHealWithShiny(param1:HousingPersistentMonsterBar) : void
      {
         var _loc2_:int = param1.getResourceCostInShiny();
         var _loc3_:Boolean = param1.m_creatureID.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost;
         if(BASE._pendingPurchase.length == 0)
         {
            if(_loc2_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               BASE.Charge(4,_loc3_ ? Number(BASE._iresources.r4.Get()) : Number(BASE._resources.r4.Get()),false,_loc3_);
               this.healQueueAdd(param1);
               if(_loc2_ > 0)
               {
                  BASE.Purchase("MHTOPUP",_loc2_,"HousingPersistentPopup.startHealWithShiny");
               }
            }
         }
      }
      
      private function healInstantAllShinyCheck(param1:MouseEvent = null) : void
      {
         var _loc2_:int = this.getAllShinyCost();
         if(BASE._pendingPurchase.length == 0)
         {
            if(_loc2_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               this.healAll();
               if(_loc2_ > 0)
               {
                  BASE.Purchase("HAM",_loc2_,"HousingPersistentPopup.healInstantAllShinyCheck");
               }
            }
         }
      }
      
      private function healInstantShinyCheck(param1:MouseEvent = null) : void
      {
         var _loc2_:HousingPersistentMonsterBar = param1.target.parent as HousingPersistentMonsterBar;
         var _loc3_:int = _loc2_.getTimeCost();
         if(BASE._pendingPurchase.length == 0)
         {
            if(_loc3_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               this.healInstant(_loc2_);
               if(_loc3_ > 0)
               {
                  BASE.Purchase("HSM",_loc3_,"HousingPersistentPopup.healInstantShinyCheck");
               }
            }
         }
      }
      
      private function healQueueRemove(param1:HousingPersistentMonsterBar) : void
      {
         GLOBAL.player.queueRemove(param1.m_creatureID);
         this.setNormalMode(param1);
         this.updateHealAllButton();
      }
      
      private function healQueueAdd(param1:HousingPersistentMonsterBar) : void
      {
         GLOBAL.player.queueHeal(param1.m_creatureID);
         this.setHealMode(param1);
         this.updateHealAllButton();
         BASE.SaveB();
      }
      
      private function setHealMode(param1:HousingPersistentMonsterBar) : void
      {
         param1.gotoAndStop(HousingPersistentMonsterBar.k_HealFrame);
         param1.bFinish.Setup(KEYS.Get("btn_housing_finish",{"v1":param1.getTimeCost()}));
         param1.bFinish.buttonMode = true;
         param1.bFinish.Highlight = true;
         param1.bFinish.addEventListener(MouseEvent.CLICK,this.healInstantShinyCheck);
         param1.bCancel.SetupKey("btn_cancel");
         param1.bCancel.addEventListener(MouseEvent.CLICK,this.refundResourcesEvent);
         param1.bCancel.buttonMode = true;
         param1.m_shine.visible = false;
         this.reorganize();
      }
      
      private function setNormalMode(param1:HousingPersistentMonsterBar) : void
      {
         param1.gotoAndStop(HousingPersistentMonsterBar.k_NormalFrame);
         param1.bHeal.SetupKey("btn_mh_heal");
         if(param1.m_healthBar.mcBar.width == HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth)
         {
            param1.bHeal.buttonMode = false;
            param1.bHeal.Enabled = false;
         }
         else
         {
            param1.bHeal.Enabled = true;
            param1.bHeal.buttonMode = true;
            param1.bHeal.addEventListener(MouseEvent.CLICK,this.attemptHeal);
         }
         if(param1.m_creatureID.substr(0,1) != "B")
         {
            param1.bJuice.SetupKey("bunker_btn_juice");
            param1.bJuice.buttonMode = param1.bJuice.Enabled = GLOBAL._bJuicer != null;
            param1.bJuice.addEventListener(MouseEvent.CLICK,this.juicerAdd);
         }
         else
         {
            param1.bJuice.visible = false;
         }
         param1.tHealStatusText.htmlText = "";
         param1.m_shine.visible = false;
         this.reorganize();
      }
      
      private function reorganize() : void
      {
         var _loc5_:Vector.<String> = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:Boolean = false;
         var _loc6_:int = int((_loc5_ = GLOBAL.player.healQueue).length);
         for(_loc7_ in this.m_monsterBarList)
         {
            this.m_monsterBarList[_loc7_].y = -1;
            if(!GLOBAL.player.numCreepsByID(_loc7_))
            {
               monsterContainer.removeChild(this.m_monsterBarList[_loc7_]);
               delete this.m_monsterBarList[_loc7_];
            }
            if(_loc7_.substr(0,1) == "B")
            {
               _loc3_[_loc7_] = this.m_monsterBarList[_loc7_];
            }
         }
         _loc8_ = 0;
         _loc9_ = 0;
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            if(this.m_monsterBarList[_loc5_[_loc10_]])
            {
               _loc4_ = true;
               this.m_monsterBarList[_loc5_[_loc10_]].tHealStatusText.htmlText = KEYS.Get("btn_housing_waiting");
               if(!_loc2_)
               {
                  _loc2_ += this.k_offsetTextY;
               }
               this.m_monsterBarList[_loc5_[_loc10_]].y = _loc2_;
               _loc2_ += this.k_offsetY;
               if(_loc10_ == 0)
               {
                  this.m_monsterBarList[_loc5_[_loc10_]].updateTimer();
                  this.m_monsterBarList[_loc5_[_loc10_]].m_shine.play();
                  this.m_monsterBarList[_loc5_[_loc10_]].m_shine.visible = true;
               }
            }
            _loc10_++;
         }
         if(_loc4_)
         {
            if(this.m_monsterBarList[_loc5_[_loc10_ - 1]])
            {
               m_bgWhite.height = this.m_monsterBarList[_loc5_[_loc10_ - 1]].y + this.k_offsetY + this.k_aBit;
            }
         }
         else
         {
            m_bgWhite.height = 0;
         }
         tTitleBunkers.visible = false;
         tTitleHealing.visible = _loc4_;
         tTitleHousing.y = _loc2_ + this.k_aBit;
         _loc2_ += this.k_offsetTextY;
         for(_loc7_ in this.m_monsterBarList)
         {
            if(this.m_monsterBarList[_loc7_].y < 0 && _loc7_.substr(0,1) != "B")
            {
               this.m_monsterBarList[_loc7_].y = _loc2_;
               _loc2_ += this.k_offsetY;
            }
         }
         tTitleBunkers.y = _loc2_ + this.k_aBit;
         _loc2_ += this.k_offsetTextY;
         for(_loc7_ in _loc3_)
         {
            if(this.m_monsterBarList[_loc7_].y < 0)
            {
               tTitleBunkers.visible = true;
               this.m_monsterBarList[_loc7_].y = _loc2_;
               _loc2_ += this.k_offsetY;
            }
         }
         if(monsterContainer.y < monsterContainerMask.height / 2 - monsterContainer.height)
         {
            monsterContainer.y = monsterContainerMask.height / 2 - monsterContainer.height;
         }
      }
      
      public function tickVisualHeal() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = !!GLOBAL.player.healQueue.length ? GLOBAL.player.healQueue[0] : "";
         for(_loc2_ in this.m_monsterBarList)
         {
            this.m_monsterBarList[_loc2_].m_healthBar.mcBar.width = HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth * GLOBAL.player.curHealthByID(_loc2_) / GLOBAL.player.totalHealthByID(_loc2_);
            if(_loc2_ == _loc1_)
            {
               this.m_monsterBarList[_loc2_].updateTimer();
            }
            if(this.m_monsterBarList[_loc2_].currentFrame == HousingPersistentMonsterBar.k_HealFrame && !GLOBAL.player.checkQueued(_loc2_))
            {
               this.setNormalMode(this.m_monsterBarList[_loc2_]);
            }
         }
      }
      
      private function getAllShinyCost() : int
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for(_loc2_ in this.m_monsterBarList)
         {
            _loc1_ += this.m_monsterBarList[_loc2_].getTimeCost(true);
            _loc1_ += this.m_monsterBarList[_loc2_].getResourceCostInShiny();
         }
         return _loc1_;
      }
      
      private function updateHealAllButton() : void
      {
         var _loc1_:int = this.getAllShinyCost();
         bHealAll.Setup(KEYS.Get("btn_housing_heal_all",{"v1":_loc1_}));
         if(_loc1_)
         {
            bHealAll.Enabled = true;
            bHealAll.enabled = true;
            bHealAll.Highlight = true;
         }
         else
         {
            bHealAll.Enabled = false;
            bHealAll.enabled = false;
            bHealAll.Highlight = false;
         }
      }
      
      public function Update() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         this.getHousableCreatures();
         this.tickVisualHeal();
         this.updateHealAllButton();
         HOUSING.HousingSpace();
         _loc3_ = 0;
         for(_loc2_ in this._juiceList)
         {
            _loc3_ += CREATURES.GetProperty(_loc2_,"cStorage") * this._juiceList[_loc2_];
         }
         HOUSING._housingUsed.Add(-_loc3_);
         _loc6_ = Math.round(100 / Number(HOUSING._housingCapacity.Get()) * Number(HOUSING._housingUsed.Get()));
         mcStorage.mcBar.width = 535 / HOUSING._housingCapacity.Get() * HOUSING._housingUsed.Get();
         tStorage.htmlText = "<b>" + GLOBAL.FormatNumber(HOUSING._housingUsed.Get()) + " / " + GLOBAL.FormatNumber(HOUSING._housingCapacity.Get()) + " (" + _loc6_ + "%)</b>";
         if(GLOBAL._bJuicer)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            for(_loc2_ in this._juiceList)
            {
               _loc3_ += this._juiceList[_loc2_];
               _loc7_ = 0.6;
               if(GLOBAL._bJuicer._lvl.Get() == 2)
               {
                  _loc7_ = 0.8;
               }
               if(GLOBAL._bJuicer._lvl.Get() == 3)
               {
                  _loc7_ = 1;
               }
               _loc4_ += Math.ceil(CREATURES.GetProperty(_loc2_,"cResource").Get() * _loc7_) * this._juiceList[_loc2_];
            }
            if(_loc3_ > 0)
            {
               bJuice.Enabled = true;
               bJuice.Highlight = true;
               if(_loc3_ == 1)
               {
                  bJuice.Setup(KEYS.Get("mh_juicemonsterX_btn",{
                     "v1":_loc3_,
                     "v2":GLOBAL.FormatNumber(_loc4_)
                  }));
               }
               else
               {
                  bJuice.Setup(KEYS.Get("mh_juicemonstersX_btn",{
                     "v1":_loc3_,
                     "v2":GLOBAL.FormatNumber(_loc4_)
                  }));
               }
            }
            else
            {
               bJuice.Enabled = false;
               bJuice.Highlight = false;
               bJuice.SetupKey("mh_nomonsters_btn");
            }
         }
         this._scroller.Update();
      }
      
      public function healInstant(param1:HousingPersistentMonsterBar) : void
      {
         GLOBAL.player.healInstantSingleByID(param1.m_creatureID);
      }
      
      private function healAll() : void
      {
         var _loc1_:HousingPersistentMonsterBar = null;
         var _loc2_:String = null;
         GLOBAL.player.healInstantAll();
         for(_loc2_ in this.m_monsterBarList)
         {
            _loc1_ = this.m_monsterBarList[_loc2_];
            if(_loc1_.bHeal)
            {
               _loc1_.bHeal.buttonMode = false;
               _loc1_.bHeal.Enabled = false;
               _loc1_.bHeal.removeEventListener(MouseEvent.CLICK,this.attemptHeal);
            }
         }
      }
      
      public function juicerAdd(param1:MouseEvent = null) : void
      {
         var _loc4_:int = 0;
         var _loc2_:HousingPersistentMonsterBar = param1.target.parent as HousingPersistentMonsterBar;
         var _loc3_:String = _loc2_.m_creatureID;
         if(!GLOBAL._bJuicer)
         {
            GLOBAL.Message(KEYS.Get("msg_nojuicer"));
            return;
         }
         if(GLOBAL._bJuicer._countdownUpgrade.Get() == 0)
         {
            if(GLOBAL._bJuicer.health > GLOBAL._bJuicer.maxHealth * 0.5)
            {
               if(Boolean(GLOBAL.player.monsterListByID(_loc3_)) && GLOBAL.player.monsterListByID(_loc3_).numHousedCreeps - int(this._juiceList[_loc3_]) > 0)
               {
                  if(!this._juiceList[_loc3_])
                  {
                     this._juiceList[_loc3_] = 0;
                  }
                  ++this._juiceList[_loc3_];
                  if(_loc3_ != this.m_strLastSelectedJuiced)
                  {
                     this.m_strLastSelectedJuiced = _loc3_;
                     this.m_nJuiceAmount = 0;
                     this.m_bShownPopup = false;
                  }
                  ++this.m_nJuiceAmount;
                  if(!this.m_bShownPopup && this.m_nJuiceAmount >= this.k_juiceAllPopupLimit)
                  {
                     this.m_JuiceAllPopup = new PersistantJuiceAllPopup();
                     this.m_JuiceAllPopup.setup(this.m_strLastSelectedJuiced,this.juiceAllByType,this.closeJuiceAll);
                     POPUPS.Add(this.m_JuiceAllPopup,POPUPS.k_CENTER);
                     this.m_bShownPopup = true;
                  }
               }
               _loc4_ = GLOBAL.player.monsterListByID(_loc3_).numHousedCreeps - this._juiceList[_loc3_];
               _loc2_.m_capacityBar.mcBar.width = HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth * (_loc4_ * CREATURES.GetProperty(_loc3_,"cStorage")) / HOUSING._housingCapacity.Get();
               if(!_loc4_)
               {
                  _loc2_.bJuice.Enabled = false;
                  _loc2_.bJuice.buttonMode = false;
               }
               this.Update();
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_juicerdamaged"));
            }
         }
         else
         {
            GLOBAL.Message(KEYS.Get("msg_juicerupgrading"));
         }
      }
      
      public function juiceCheck(param1:MouseEvent = null) : void
      {
         var _loc9_:Vector.<CreepInfo> = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc13_:int = 0;
         if(!bJuice.Enabled)
         {
            return;
         }
         var _loc2_:String = "";
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Player = GLOBAL.player;
         var _loc8_:int = 0;
         for(_loc10_ in this._juiceList)
         {
            _loc4_ = int(this._juiceList[_loc10_]);
            _loc3_ += _loc4_;
            _loc8_ = int((_loc9_ = _loc7_.monsterListByID(_loc10_).m_creeps).length);
            _loc13_ = 0;
            while(_loc13_ < _loc8_ && Boolean(_loc4_))
            {
               if(!_loc9_[_loc13_].ownerID)
               {
                  if(_loc9_[_loc13_].self)
                  {
                     _loc4_--;
                     if(_loc10_.substr(0,1) == "I")
                     {
                        _loc6_ += CREATURES.GetProperty(_loc10_,"cResource").Get() * (_loc9_[_loc13_].health / CREATURES.GetProperty(_loc10_,"health").Get());
                     }
                     else
                     {
                        _loc5_ += CREATURES.GetProperty(_loc10_,"cResource").Get() * (_loc9_[_loc13_].health / CREATURES.GetProperty(_loc10_,"health").Get());
                     }
                  }
               }
               _loc13_++;
            }
         }
         _loc11_ = 0.6;
         if(GLOBAL._bJuicer._lvl.Get() == 2)
         {
            _loc11_ = 0.8;
         }
         else if(GLOBAL._bJuicer._lvl.Get() == 3)
         {
            _loc11_ = 1;
         }
         _loc6_ = Math.floor(_loc11_ * _loc6_);
         if((Boolean(_loc5_ = Math.floor(_loc11_ * _loc5_))) && Boolean(_loc6_))
         {
            _loc2_ = KEYS.Get("msg_juiceboth",{
               "v1":_loc3_,
               "v2":GLOBAL.FormatNumber(_loc5_),
               "v3":GLOBAL.FormatNumber(_loc6_)
            });
         }
         else if(_loc5_)
         {
            _loc2_ = KEYS.Get("msg_juicegoo",{
               "v1":_loc3_,
               "v2":GLOBAL.FormatNumber(_loc5_)
            });
         }
         else if(_loc6_)
         {
            _loc2_ = KEYS.Get("msg_juicemagma",{
               "v1":_loc3_,
               "v2":GLOBAL.FormatNumber(_loc6_)
            });
         }
         var _loc12_:MESSAGE;
         (_loc12_ = GLOBAL.Message(_loc2_,KEYS.Get("btn_juicemonsters"),this.juice,null)).bAction.Highlight = true;
      }
      
      public function juice(param1:MouseEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:BFOUNDATION = null;
         var _loc5_:MonsterBase = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc4_ in _loc7_)
         {
            _loc6_.push(_loc4_);
         }
         for(_loc2_ in this._juiceList)
         {
            _loc8_ = int(this._juiceList[_loc2_]);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               GLOBAL.player.monsterListByID(_loc2_).juiceCreep();
               --this._juiceList[_loc2_];
               _loc9_++;
            }
         }
         mcStorage.mcBarB.width = mcStorage.mcBar.width;
         this.updateCapacityBars();
         this.tickVisualHeal();
         this.reorganize();
         this._juiceList = {};
         HOUSING.HousingSpace();
         BASE.Save();
      }
      
      private function updateCapacityBars() : void
      {
         var _loc2_:HousingPersistentMonsterBar = null;
         var _loc3_:String = null;
         var _loc1_:int = 0;
         for(_loc3_ in this.m_monsterBarList)
         {
            _loc2_ = this.m_monsterBarList[_loc3_];
            if(_loc3_.substr(0,1) != "B")
            {
               _loc1_ = GLOBAL.player.monsterListByID(_loc3_).numHousedCreeps;
               _loc2_.tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[_loc3_].name) + "</b> x" + _loc1_;
            }
            else
            {
               _loc2_.tName.htmlText = "<b>" + KEYS.Get("#b_monsterbunker#") + "</b>";
            }
            if(_loc2_.currentFrame == HousingPersistentMonsterBar.k_NormalFrame)
            {
               _loc2_.bJuice.Enabled = true;
               _loc2_.bJuice.buttonMode = true;
            }
            _loc2_.m_capacityBar.mcBar.width = HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth * GLOBAL.player.getStorageByID(_loc3_) / HOUSING._housingCapacity.Get();
            _loc2_.m_capacityBar.mcBarGrey.width = _loc2_.m_capacityBar.mcBar.width;
            _loc2_.tCapacityText.htmlText = "<b>" + GLOBAL.player.getStorageByID(_loc3_) + "</b>";
         }
      }
      
      public function getHousableCreatures() : Array
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Vector.<MonsterData>;
         var _loc5_:int = int((_loc4_ = GLOBAL.player.monsterList).length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(!(_loc7_ = CREATURELOCKER._creatures[_loc4_[_loc6_].m_creatureID]).blocked && Boolean(_loc4_[_loc6_].numHousedCreeps))
            {
               _loc7_.id = _loc4_[_loc6_].m_creatureID;
               _loc2_.push(_loc7_);
            }
            if(_loc4_[_loc6_].numBunkeredCreeps)
            {
               _loc1_ = int(_loc4_[_loc6_].m_creeps.length);
               _loc8_ = 0;
               while(_loc8_ < _loc1_)
               {
                  if(_loc4_[_loc6_].m_creeps[_loc8_].ownerID)
                  {
                     if(!this.m_bunkerIDList[_loc4_[_loc6_].m_creeps[_loc8_].ownerID])
                     {
                        this.m_bunkerIDList[_loc4_[_loc6_].m_creeps[_loc8_].ownerID] = 1;
                        (_loc7_ = new Object()).id = "B" + _loc4_[_loc6_].m_creeps[_loc8_].ownerID;
                        _loc7_.index = 300;
                        _loc2_.push(_loc7_);
                     }
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
         _loc2_.sortOn(["index"],Array.NUMERIC);
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc3_.concat(_loc2_);
         }
         return _loc3_;
      }
      
      public function selectNone(param1:MouseEvent = null) : void
      {
         this._juiceList = {};
         bJuice.SetupKey("mh_nomonsters_btn");
         bJuice.Enabled = false;
         bJuice.Highlight = false;
         this.updateCapacityBars();
         this.Update();
         this.m_bShownPopup = false;
         this.m_nJuiceAmount = 0;
         this.m_strLastSelectedJuiced = "";
         if(this.m_JuiceAllPopup)
         {
            POPUPS.Remove(this.m_JuiceAllPopup);
         }
         this.m_JuiceAllPopup = null;
      }
      
      public function closeJuiceAll(param1:MouseEvent) : void
      {
         if(this.m_JuiceAllPopup)
         {
            POPUPS.Remove(this.m_JuiceAllPopup);
         }
         this.m_JuiceAllPopup = null;
      }
      
      public function iconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
         param3[0].mcImage.visible = true;
         param3[0].mcLoading.visible = false;
      }
      
      public function ascend(param1:MouseEvent = null) : void
      {
         if(!MAPROOM_DESCENT.DescentPassed)
         {
            GLOBAL.Message(KEYS.Get("mh_ascension_noinf"));
         }
         else
         {
            SOUNDS.Play("click1");
            this.Hide();
            INFERNOPORTAL.AscendMonsters();
         }
      }
      
      protected function juiceAllByType(param1:String) : void
      {
         this._juiceList[param1] = GLOBAL.player.monsterListByID(param1).numHousedCreeps;
         this.m_strLastSelectedJuiced = "";
         this.m_nJuiceAmount = 0;
         this.m_bShownPopup = false;
         var _loc2_:int = GLOBAL.player.monsterListByID(param1).numHousedCreeps - this._juiceList[param1];
         this.m_monsterBarList[param1].m_capacityBar.mcBar.width = HousingPersistentMonsterBar.k_monsterBarDisplayBarWidth * (_loc2_ * CREATURES.GetProperty(param1,"cStorage")) / HOUSING._housingCapacity.Get();
         this.m_monsterBarList[param1].bJuice.Enabled = false;
         this.m_monsterBarList[param1].bJuice.buttonMode = false;
      }
      
      public function Hide() : void
      {
         HOUSING.Hide();
      }
      
      public function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
      
      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}

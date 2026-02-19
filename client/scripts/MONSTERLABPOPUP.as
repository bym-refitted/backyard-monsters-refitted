package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class MONSTERLABPOPUP extends MONSTERLABPOPUP_CLIP
   {
      
      public static var _page:int = 1;
      
      public static var _maxSpeed:int = 0;
      
      public static var _maxHealth:int = 0;
      
      public static var _maxDamage:int = 0;
      
      public static var _maxTime:int = 0;
      
      public static var _maxResource:int = 0;
      
      public static var _maxStorage:int = 0;
      
      public static var _maxAbility:int = 0;
      
      public static var _instantUpgradeCost:int = 0;
      
      public static var _STATE:String = "IDLE";
      
      public static var _creatureID:String;
      
      public static var _labItems:Object = {};
      
      public static var _bMonsterLab:MONSTERLAB;
      
      public static var _instantUnlockCost:int;
      
      public static var _unlockLevel:int = 0;
      
      public static var _maxLevel:int = 3;
       
      
      private var _portraitImage:MovieClip;
      
      private var _statusImage:MovieClip;
      
      private var tf_title:TextField;
      
      private var tf_statusTitle:TextField;
      
      private var tf_statusDesc:TextField;
      
      private var tf_statusIdle:TextField;
      
      private var icon_status:MovieClip;
      
      private var pBar_status:MovieClip;
      
      private var tf_statusPBarLabel:TextField;
      
      private var btn_action:MovieClip;
      
      private var tf_stats:TextField;
      
      private var tf_statsPBar:TextField;
      
      private var tf_statsPBarLabel:TextField;
      
      private var tf_statsWarning:TextField;
      
      private var pBar_stats:MovieClip;
      
      private var btn_resource:MovieClip;
      
      private var btn_instant:MovieClip;
      
      private var _scrollbar:ScrollSet;
      
      private var _shell:Sprite;
      
      private var list_mc:MovieClip;
      
      private var _listContainer:Sprite;
      
      public var _abilityUpgradesList:Array;
      
      public function MONSTERLABPOPUP()
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super();
         this.tf_title = title_txt;
         this.tf_statusTitle = tStatusTitle;
         this.tf_statusDesc = tStatusDesc;
         this.tf_statusIdle = tIdle;
         this.icon_status = mcStatusIcon;
         this.pBar_status = mcPBarStatus;
         this.tf_statusPBarLabel = tProgress;
         this.btn_action = bAction;
         this.tf_stats = tStatsTitle;
         this.tf_statsPBar = tStatsPBar;
         this.tf_statsPBarLabel = tStatsPBarLabel;
         this.tf_statsWarning = tStatsWarning;
         this.pBar_stats = mcPBarStats;
         this.btn_resource = mcResources;
         this.btn_instant = mcInstant;
         this.list_mc = mcList;
         this._scrollbar = new ScrollSet();
         _bMonsterLab = GLOBAL._bLab as MONSTERLAB;
         var _loc1_:int = 3;
         while(_loc1_ < 5)
         {
            this.btn_resource["mcR" + _loc1_].visible = false;
            this.btn_resource["mcR" + _loc1_].tTitle.htmlText = "<b>" + KEYS.Get(GLOBAL._resourceNames[_loc1_ - 1]) + "</b>";
            this.btn_resource["mcR" + _loc1_].tValue.htmlText = "<b>0</b>";
            this.btn_resource["mcR" + _loc1_].gotoAndStop(_loc1_);
            _loc1_++;
         }
         this.btn_resource.mcTime.visible = false;
         this.btn_resource.mcTime.tTitle.htmlText = "<b>" + KEYS.Get("#r_time#") + "</b>";
         this.btn_resource.mcTime.gotoAndStop(6);
         this.btn_instant.tDescription.htmlText = "<b>" + KEYS.Get("lab_upgradeinstant") + "</b>";
         this.tf_title.htmlText = "<b>" + KEYS.Get("monsterlab_title") + "</b>";
         this.tf_statusIdle.htmlText = "<b>" + KEYS.Get("lab_selectability") + "</b>";
         if(_bMonsterLab._upgrading)
         {
            this.tf_statusTitle.htmlText = KEYS.Get("monsterlab_currentlyresearching",{"v1":KEYS.Get(MONSTERLAB._powerupProps[_bMonsterLab._upgrading].name)});
            this.tf_statusDesc.htmlText = "<b>" + KEYS.Get("lab_level",{"v1":_bMonsterLab._upgradeLevel}) + "</b>";
            _loc2_ = _bMonsterLab._upgradeFinishTime.Get() - GLOBAL.Timestamp();
            this.tf_statusPBarLabel.htmlText = "<b>" + GLOBAL.ToTime(_loc2_,true) + "</b>";
            _loc3_ = MONSTERLAB.GetTimeCost(_bMonsterLab._upgrading,_bMonsterLab._upgradeLevel);
            _loc4_ = 100 - 100 / _loc3_ * _loc2_;
            mcPBarStatus.mcBar.width = _loc4_;
            mcPBarStatus.mcBar2.width = _loc4_;
         }
         this.tf_stats.htmlText = "<b>" + KEYS.Get("lab_rocketslevel",{"v1":0}) + "</b>" + "<br>" + KEYS.Get("lab_rockets_desc");
         this.tf_statsPBar.htmlText = "<b>" + KEYS.Get("lab_ability") + "</b>";
         this.tf_statsPBarLabel.htmlText = "<b>" + KEYS.Get("lab_davename") + "</b>";
         this.tf_statsWarning.htmlText = "<b>" + KEYS.Get("lab_locked",{"v1":2}) + "</b>";
         if(_bMonsterLab._upgrading)
         {
            this.Setup(_bMonsterLab._upgrading);
         }
         else
         {
            this.Setup("C3");
         }
      }
      
      public function Setup(param1:String) : void
      {
         _creatureID = param1;
         this.List();
         this.Update(_creatureID,true);
      }
      
      private function UpdatePortrait(param1:String) : void
      {
         var UpdatePortraitIcon:Function = null;
         var UpdateStatusIcon:Function = null;
         var key:String = param1;
         UpdatePortraitIcon = function(param1:String, param2:BitmapData):void
         {
            mcPortraitIcon.mcImage.addChild(new Bitmap(param2));
            mcPortraitIcon.loading.visible = false;
         };
         UpdateStatusIcon = function(param1:String, param2:BitmapData):void
         {
            icon_status.mcImage.addChild(new Bitmap(param2));
            icon_status.loading.visible = false;
         };
         this._portraitImage = mcPortraitIcon.mcImage;
         this._statusImage = this.icon_status.mcImage;
         if(mcPortraitIcon.mcImage)
         {
            while(this._portraitImage.numChildren)
            {
               this._portraitImage.removeChildAt(0);
            }
         }
         if(this.icon_status.mcImage)
         {
            while(this._statusImage.numChildren)
            {
               this._statusImage.removeChildAt(0);
            }
         }
         ImageCache.GetImageWithCallBack("popups/" + _creatureID + "-LAB-150.png",UpdatePortraitIcon);
         ImageCache.GetImageWithCallBack("popups/" + _creatureID + "-LAB-75.jpg",UpdateStatusIcon);
      }
      
      public function Update(param1:String, param2:Boolean = false) : void
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc16_:Boolean = false;
         _creatureID = param1;
         if(!param1)
         {
            _creatureID = "C3";
         }
         if(_bMonsterLab._upgrading)
         {
            _creatureID = _bMonsterLab._upgrading;
         }
         var _loc3_:Object = MONSTERLAB._powerupProps[_creatureID];
         var _loc4_:int = 0;
         if(Boolean(GLOBAL.player.m_upgrades[_creatureID]) && Boolean(GLOBAL.player.m_upgrades[_creatureID].powerup))
         {
            _loc4_ = int(GLOBAL.player.m_upgrades[_creatureID].powerup);
         }
         else
         {
            _loc4_ = 0;
         }
         _unlockLevel = _loc4_ + 1;
         var _loc5_:Object = _bMonsterLab.CanPowerup(_creatureID,_unlockLevel);
         var _loc6_:Array = MONSTERLAB._powerupProps[_creatureID].costs[_unlockLevel - 1];
         var _loc7_:Object = CREATURELOCKER._creatures[_creatureID];
         var _loc8_:Object = MONSTERLAB._powerupProps[_creatureID];
         if(_unlockLevel == 1)
         {
            this.tf_stats.htmlText = "<b>" + KEYS.Get(_loc8_.name) + "</b><br>" + KEYS.Get(_loc8_.description);
         }
         else
         {
            this.tf_stats.htmlText = "<b>" + KEYS.Get(_loc8_.name) + "</b><br>" + KEYS.Get(_loc8_.upgrade_description);
         }
         this.tf_statsPBar.htmlText = "<b>" + KEYS.Get(_loc8_.name) + "</b>";
         var _loc9_:String = "";
         if(_bMonsterLab.CanPowerup(_creatureID,_unlockLevel).errorString == "Fully Powered Up")
         {
            _unlockLevel = 3;
         }
         switch(_creatureID)
         {
            case "C2":
               _loc9_ = _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C3":
               _loc9_ = _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C4":
               _loc9_ = _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C5":
               _loc9_ = _loc8_.effect[_unlockLevel - 1] * 100 + "% " + _loc8_.ability;
               break;
            case "C7":
               _loc9_ = _loc8_.effect[_unlockLevel - 1] + "x speed " + _loc8_.ability;
               break;
            case "C8":
               _loc9_ = CREATURELOCKER._creatures[_creatureID].props.damage[_unlockLevel - 1] * _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C9":
               _loc9_ = String(_loc8_.effect[_unlockLevel - 1] + _loc8_.ability);
               break;
            case "C11":
               _loc9_ = CREATURELOCKER._creatures[_creatureID].props.damage[_unlockLevel - 1] * _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C12":
               _loc9_ = _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C13":
               _loc9_ = CREATURELOCKER._creatures[_creatureID].props.damage[_unlockLevel - 1] * _loc8_.effect[_unlockLevel - 1] + " " + _loc8_.ability;
               break;
            case "C14":
               _loc9_ = _unlockLevel + " " + _loc8_.ability;
         }
         if(_bMonsterLab.CanPowerup(_creatureID,_unlockLevel).errorString == "Fully Powered Up")
         {
            _unlockLevel = 4;
         }
         this.tf_statsPBarLabel.htmlText = _loc9_;
         var _loc10_:Number = 100 / _maxLevel * Math.min(_unlockLevel - 1,_maxLevel);
         var _loc11_:Number = 100 / _maxLevel * Math.min(_unlockLevel,_maxLevel) - 1;
         this.pBar_stats.mcBar.width = Math.max(_loc10_,1);
         this.pBar_stats.mcBar2.width = Math.max(_loc11_,1);
         this.pBar_stats.mcBar2.gotoAndStop(3);
         this.tf_statsWarning.visible = false;
         this.UpdatePortrait(_creatureID);
         if(Boolean(_bMonsterLab._upgrading) && GLOBAL.Timestamp() < _bMonsterLab._upgradeFinishTime.Get())
         {
            this.StatusChange("WORKING");
            this.btn_action.removeEventListener(MouseEvent.CLICK,this.SpeedUp);
            this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.CancelMonsterPowerup);
            this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
            this.btn_instant.gArrow.visible = false;
            this.btn_instant.tDescription.visible = false;
            this.btn_instant.gCoin.visible = false;
            this.btn_instant.bAction.SetupKey("btn_cancel");
            this.btn_instant.bAction.addEventListener(MouseEvent.CLICK,this.CancelMonsterPowerup);
            this.btn_instant.bAction.Highlight = false;
            this.btn_action.SetupKey("btn_speedup");
            this.btn_action.addEventListener(MouseEvent.CLICK,this.SpeedUp);
            this.btn_action.Highlight = true;
            this.btn_action.Enabled = true;
            this.btn_resource.mcR3.visible = false;
            this.btn_resource.mcR4.visible = false;
            this.btn_resource.mcTime.visible = false;
            this.btn_resource.visible = false;
         }
         else
         {
            this.StatusChange("IDLE");
            if(!_loc5_.error)
            {
               _loc12_ = MONSTERLAB.GetPuttyCost(_creatureID,_unlockLevel);
               _loc13_ = MONSTERLAB.GetTimeCost(_creatureID,_unlockLevel);
               _instantUnlockCost = MONSTERLAB.GetShinyCost(_creatureID,_unlockLevel);
               this.btn_instant.tDescription.htmlText = "<b>" + KEYS.Get("buildoptions_upgradeinstant") + "</b>";
               this.btn_instant.gArrow.visible = true;
               this.btn_instant.tDescription.visible = true;
               this.btn_instant.gCoin.visible = true;
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.CancelMonsterPowerup);
               this.btn_instant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":_instantUnlockCost}));
               this.btn_instant.bAction.Enabled = true;
               this.btn_instant.bAction.Highlight = true;
               this.btn_instant.bAction.addEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
               this.btn_resource.bAction.SetupKey("btn_startunlocking");
               this.btn_resource.bAction.Enabled = true;
               this.btn_resource.bAction.Highlight = true;
               this.btn_resource.bAction.addEventListener(MouseEvent.CLICK,this.StartMonsterPowerup);
               this.btn_resource.bAction.visible = true;
               this.btn_resource.mcR3.visible = true;
               this.btn_resource.mcR3.tValue.htmlText = "<b><font color=\"#" + (_loc6_[0] > GLOBAL._resources.r3.Get() ? "FF0000" : "000000") + "\">" + GLOBAL.FormatNumber(_loc12_) + "</font></b>";
               this.btn_resource.mcR4.visible = true;
               this.btn_resource.mcTime.visible = true;
               this.btn_resource.mcTime.tValue.htmlText = "<b>" + GLOBAL.ToTime(_loc13_) + "</b>";
               this.btn_instant.visible = true;
               this.btn_resource.visible = true;
            }
            else if(_loc5_.errorString == KEYS.Get("acad_err_putty"))
            {
               this.StatusChange("IDLE");
               _loc12_ = MONSTERLAB.GetPuttyCost(_creatureID,_unlockLevel);
               _loc13_ = MONSTERLAB.GetTimeCost(_creatureID,_unlockLevel);
               _instantUnlockCost = MONSTERLAB.GetShinyCost(_creatureID,_unlockLevel);
               this.btn_instant.tDescription.htmlText = KEYS.Get("academy_traininstantly");
               this.btn_instant.tDescription.visible = true;
               this.btn_instant.gArrow.visible = true;
               this.btn_instant.gCoin.visible = true;
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.CancelMonsterPowerup);
               this.btn_instant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":_instantUnlockCost}));
               this.btn_instant.bAction.Enabled = true;
               this.btn_instant.bAction.Highlight = true;
               this.btn_instant.bAction.addEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
               this.btn_resource.mcR3.visible = true;
               this.btn_resource.mcR3.tValue.htmlText = "<b><font color=\"#" + (_loc6_[0] > GLOBAL._resources.r3.Get() ? "FF0000" : "000000") + "\">" + GLOBAL.FormatNumber(_loc6_[0]) + "</font></b>";
               this.btn_resource.mcR4.visible = true;
               this.btn_resource.mcTime.visible = true;
               this.btn_resource.mcTime.tValue.htmlText = "<b>" + GLOBAL.ToTime(_loc6_[1],true) + "</b>";
               this.btn_resource.bAction.Setup(_loc5_.errorString);
               this.btn_resource.bAction.removeEventListener(MouseEvent.CLICK,this.StartMonsterPowerup);
               this.btn_resource.bAction.Enabled = false;
               this.btn_resource.bAction.Highlight = false;
               this.btn_resource.bAction.visible = true;
               this.btn_instant.visible = true;
               this.btn_resource.visible = true;
            }
            else if(Boolean(GLOBAL.player.m_upgrades[_creatureID]) && GLOBAL.player.m_upgrades[_creatureID].powerup == _maxLevel)
            {
               this.btn_instant.bAction.SetupKey("acad_err_fullytrained");
               this.btn_instant.bAction.Enabled = false;
               this.btn_instant.bAction.Highlight = false;
               this.btn_instant.gCoin.visible = false;
               this.btn_instant.gArrow.visible = false;
               this.btn_instant.tDescription.visible = false;
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.CancelMonsterPowerup);
               this.btn_resource.visible = false;
            }
            else if((_bMonsterLab.CanPowerup(_creatureID,_unlockLevel) as Object).error)
            {
               this.btn_instant.bAction.SetupKey("mon_locked");
               this.btn_instant.bAction.Enabled = false;
               this.btn_instant.bAction.Highlight = false;
               this.btn_instant.gCoin.visible = false;
               this.btn_instant.gArrow.visible = false;
               this.btn_instant.tDescription.visible = false;
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantMonsterPowerup);
               this.btn_instant.bAction.removeEventListener(MouseEvent.CLICK,this.CancelMonsterPowerup);
               this.btn_resource.bAction.removeEventListener(MouseEvent.CLICK,this.StartMonsterPowerup);
               this.btn_resource.visible = false;
               if(_bMonsterLab._lvl.Get() < _unlockLevel)
               {
                  this.tf_statsWarning.htmlText = KEYS.Get("monsterlab_requiredlevel",{"v1":_unlockLevel});
                  this.tf_statsWarning.visible = true;
               }
               else if(CREATURELOCKER._lockerData[_creatureID] == null || CREATURELOCKER._lockerData[_creatureID].t < 2 || GLOBAL.player.m_upgrades[_creatureID] == null || GLOBAL.player.m_upgrades[_creatureID].level <= _unlockLevel)
               {
                  if(_bMonsterLab._lvl.Get() < _unlockLevel)
                  {
                     this.tf_statsWarning.htmlText += "<br>" + KEYS.Get("monsterlab_requiredlevel2",{
                        "v1":KEYS.Get(CREATURELOCKER._creatures[_creatureID].name),
                        "v2":_unlockLevel + 1
                     });
                  }
                  else
                  {
                     this.tf_statsWarning.htmlText = KEYS.Get("monsterlab_requiredlevel2",{
                        "v1":KEYS.Get(CREATURELOCKER._creatures[_creatureID].name),
                        "v2":_unlockLevel + 1
                     });
                  }
                  this.tf_statsWarning.visible = true;
               }
            }
         }
         var _loc14_:* = (_loc14_ = (_loc14_ = "<b>" + KEYS.Get("acad_mon_name") + "</b> " + KEYS.Get(CREATURELOCKER._creatures[_creatureID].name) + "<br>") + ("<b>" + KEYS.Get("acad_mon_status") + "</b> " + _loc5_.status)) + ("<br>" + KEYS.Get(CREATURELOCKER._creatures[_creatureID].description));
         var _loc15_:int;
         if((_loc15_ = CREATURES.GetProperty(_creatureID,"damage",0,true)) > 0)
         {
            _loc16_ = false;
         }
         else
         {
            _loc16_ = true;
         }
      }
      
      public function Tick() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(_bMonsterLab._upgrading)
         {
            this.tf_statusTitle.htmlText = KEYS.Get("monsterlab_currentlyresearching",{"v1":KEYS.Get(MONSTERLAB._powerupProps[_bMonsterLab._upgrading].name)});
            this.tf_statusDesc.htmlText = "<b>" + KEYS.Get("lab_level",{"v1":_bMonsterLab._upgradeLevel}) + "</b>";
            _loc1_ = _bMonsterLab._upgradeFinishTime.Get() - GLOBAL.Timestamp();
            this.tf_statusPBarLabel.htmlText = "<b>" + GLOBAL.ToTime(_loc1_,true) + "</b>";
            _loc2_ = MONSTERLAB.GetTimeCost(_bMonsterLab._upgrading,_bMonsterLab._upgradeLevel);
            _loc3_ = 100 - 100 / _loc2_ * _loc1_;
            mcPBarStatus.mcBar.width = _loc3_;
            mcPBarStatus.mcBar2.width = _loc3_;
         }
         if(this._scrollbar)
         {
            if(!this._scrollbar.visible)
            {
               this._scrollbar.visible = true;
               this.list_mc.addChild(this._scrollbar);
            }
            this._scrollbar.Update();
         }
      }
      
      public function StartMonsterPowerup(param1:MouseEvent) : void
      {
         _bMonsterLab.StartMonsterPowerup(_creatureID,_unlockLevel);
         this.Setup(_creatureID);
      }
      
      public function InstantMonsterPowerup(param1:MouseEvent) : void
      {
         _bMonsterLab.InstantMonsterPowerup(_creatureID,_unlockLevel);
         this.Setup(_creatureID);
      }
      
      public function CancelMonsterPowerup(param1:MouseEvent) : void
      {
         _bMonsterLab.CancelMonsterPowerup(param1);
      }
      
      public function SpeedUp(param1:MouseEvent) : void
      {
         GLOBAL._selectedBuilding = _bMonsterLab;
         STORE.SpeedUp("SP4");
      }
      
      public function List() : void
      {
         var offset:int;
         var i:int;
         var UpdateItemIcon:Function;
         var cr:String = null;
         var abilityUpgrade:Object = null;
         var data:Object = null;
         var item:MONSTERLABITEM_CLIP = null;
         var str:String = null;
         var itemIconImage:MovieClip = null;
         this._abilityUpgradesList = [];
         for(cr in MONSTERLAB._powerupProps)
         {
            abilityUpgrade = MONSTERLAB._powerupProps[cr];
            if(!abilityUpgrade.blocked && !(Boolean(CREATURELOCKER._creatures[cr]) && Boolean(CREATURELOCKER._creatures[cr].blocked)))
            {
               abilityUpgrade.id = cr;
               this._abilityUpgradesList.push(abilityUpgrade);
            }
         }
         this._abilityUpgradesList.sortOn(["order"],Array.NUMERIC);
         if(this._listContainer)
         {
            this.list_mc.mcContainer.removeChild(this._listContainer);
         }
         this._listContainer = this.list_mc.mcContainer.addChild(new Sprite());
         this._listContainer.x = 0;
         this._listContainer.y = 0;
         this._listContainer.mask = this.list_mc.mcMask;
         this._scrollbar.x = 190;
         this._scrollbar.y = 0;
         this.list_mc.addChild(this._scrollbar);
         this._scrollbar.Init(this._listContainer,this.list_mc.mcMask,0,0,this.list_mc.height,20);
         this._scrollbar.AutoHideEnabled = false;
         this._scrollbar.visible = false;
         offset = 0;
         i = 0;
         while(i < this._abilityUpgradesList.length)
         {
            UpdateItemIcon = function(param1:String, param2:BitmapData):void
            {
               var _loc3_:MONSTERLABITEM_CLIP = _labItems[param1];
               _loc3_.mcIcon.mcImage.addChild(new Bitmap(param2));
               _loc3_.mcIcon.loading.visible = false;
            };
            abilityUpgrade = this._abilityUpgradesList[i];
            cr = String(abilityUpgrade.id);
            data = MONSTERLAB._powerupProps[cr];
            item = this._listContainer.addChild(new MONSTERLABITEM_CLIP()) as MONSTERLABITEM_CLIP;
            _labItems["popups/" + cr + "-LAB-50.jpg"] = item;
            item.y = offset;
            offset += 60;
            str = "<b>" + KEYS.Get(CREATURELOCKER._creatures[cr].name) + "</b><br>" + KEYS.Get(abilityUpgrade.name);
            item.tLabel.htmlText = str;
            item.addEventListener(MouseEvent.MOUSE_DOWN,this.Show(cr));
            item.buttonMode = true;
            item.mouseChildren = false;
            item.mouseEnabled = true;
            if(Boolean(GLOBAL.player.m_upgrades[cr]) && Boolean(GLOBAL.player.m_upgrades[cr].powerup))
            {
               item.mcLevel.tLevel.htmlText = "" + GLOBAL.player.m_upgrades[cr].powerup + "";
            }
            else
            {
               item.mcLevel.visible = false;
            }
            itemIconImage = item.mcIcon.mcImage;
            if(itemIconImage)
            {
               while(itemIconImage.numChildren)
               {
                  itemIconImage.removeChildAt(0);
               }
            }
            ImageCache.GetImageWithCallBack("popups/" + cr + "-LAB-50.jpg",UpdateItemIcon);
            if(data)
            {
               if(data.t != 1)
               {
                  if(data.t == 2)
                  {
                  }
               }
            }
            i++;
         }
      }
      
      public function get Scrollbar() : *
      {
         return this._scrollbar;
      }
      
      public function Show(param1:String) : Function
      {
         var creatureID:String = param1;
         return function(param1:MouseEvent = null):void
         {
            Update(creatureID,true);
         };
      }
      
      public function StatusChange(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc2_:Object = MONSTERLAB._powerupProps[_creatureID];
         _loc3_ = MONSTERLAB._powerupProps[_creatureID].costs[_unlockLevel - 1];
         switch(param1)
         {
            case "IDLE":
               this.tf_statusIdle.visible = true;
               this.tf_statusTitle.visible = false;
               this.tf_statusDesc.visible = false;
               this.icon_status.visible = false;
               this.pBar_status.visible = false;
               this.tf_statusPBarLabel.visible = false;
               this.btn_action.visible = false;
               break;
            case "WORKING":
               this.tf_statusIdle.visible = false;
               this.tf_statusTitle.visible = true;
               this.tf_statusDesc.visible = true;
               this.icon_status.visible = true;
               this.pBar_status.visible = true;
               this.tf_statusPBarLabel.visible = true;
               this.btn_action.visible = true;
               _loc4_ = _bMonsterLab._upgradeFinishTime.Get() - GLOBAL.Timestamp();
               _loc5_ = GLOBAL.ToTime(_loc4_,true);
               this.tf_statusPBarLabel.htmlText = "<b>" + _loc5_ + "</b>";
               _loc6_ = int(_loc3_[1]);
               _loc7_ = 100 / _loc6_ * (_loc6_ - _loc4_);
               this.pBar_status.mcBar.width = Math.max(_loc7_,1);
               this.pBar_status.mcBar2.width = Math.max(_loc7_,1);
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         MONSTERLAB.Hide(param1);
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

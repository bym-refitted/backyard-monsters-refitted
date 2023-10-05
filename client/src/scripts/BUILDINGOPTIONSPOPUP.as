package
{
   import com.cc.utils.SecNum;
   import com.monsters.display.BuildingAssetContainer;
   import com.monsters.display.ImageCache;
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class BUILDINGOPTIONSPOPUP extends BUILDINGOPTIONSPOPUP_CLIP
   {
       
      
      private var _building:BFOUNDATION;
      
      private var _costsMC:MovieClip;
      
      private var _tmpIcon:MovieClip;
      
      public var streampost_cb:Checkbox;
      
      public var _isPosting:Boolean = false;
      
      public var _doStreamPost:Boolean = true;
      
      public var imageContainer:BuildingAssetContainer;
      
      public function BUILDINGOPTIONSPOPUP(param1:String = "info", param2:int = 0)
      {
         super();
         this._doStreamPost = false;
         mcCBBG.visible = false;
         mcInfoCB.visible = false;
         if(param1 == "build")
         {
            this._building = new BFOUNDATION();
            InstanceManager.removeInstance(this._building);
            this._building._type = param2;
            if(!STORE._storeItems["BUILDING" + this._building._type])
            {
               mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.ActionInstantBuild);
               mcInstant.bAction.Setup(KEYS.Get("buildoptions_shiny",{"v1":this._building.InstantBuildCost()}));
               mcInstant.tDescription.htmlText = KEYS.Get("buildoptions_buildinstant");
               mcInstant.gCoin.mouseEnabled = false;
            }
         }
         else if(param1 == "fortify")
         {
            this._building = BUILDINGOPTIONS._building;
            mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.ActionInstantFortify);
            mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":this._building.InstantFortifyCost()}));
            mcInstant.tDescription.htmlText = KEYS.Get("buildoptions_fortifyinstant");
            mcInstant.gCoin.mouseEnabled = false;
         }
         else
         {
            this._building = BUILDINGOPTIONS._building;
            mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.ActionInstantUpgrade);
            mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":this._building.InstantUpgradeCost()}));
            mcInstant.tDescription.htmlText = KEYS.Get("buildoptions_upgradeinstant");
            mcInstant.gCoin.mouseEnabled = false;
         }
         this.toggleCheckbox(false);
         tDescription.autoSize = TextFieldAutoSize.LEFT;
         tDescription.mouseWheelEnabled = false;
         this.imageContainer = new BuildingAssetContainer();
         this.imageContainer.mouseChildren = false;
         this.imageContainer.mouseEnabled = false;
         mcImage.addChild(this.imageContainer);
         this.Render(param1);
         this.Switch(param1);
      }
      
      private function Switch(param1:String) : void
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:BFOUNDATION = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:MovieClip = null;
         var _loc16_:Boolean = false;
         var _loc17_:Object = null;
         var _loc18_:Array = null;
         var _loc2_:* = "";
         var _loc3_:Object = {};
         var _loc4_:* = "";
         SOUNDS.Play("click1");
         var _loc5_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         if(param1 == "build")
         {
            mcResources.bAction.addEventListener(MouseEvent.CLICK,this.ActionResourceBuild);
            mcResources.bAction.Highlight = true;
            if(InventoryManager.buildingStorageCount(this._building._type) > 0)
            {
               mcResources.bAction.SetupKey("btn_place");
            }
            else
            {
               mcResources.bAction.SetupKey("btn_build");
            }
            for each(_loc6_ in GLOBAL._buildingProps[this._building._type - 1].costs[0].re)
            {
               _loc7_ = 0;
               _loc8_ = "#CC0000";
               if(_loc6_[0] == INFERNOQUAKETOWER.UNDERHALL_ID)
               {
                  _loc9_ = "#bi_townhall#";
                  if(GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL) >= _loc6_[2] || Boolean(GLOBAL._buildingProps[this._building._type - 1].rewarded))
                  {
                     _loc7_ = 1;
                  }
               }
               else
               {
                  _loc9_ = String(GLOBAL._buildingProps[_loc6_[0] - 1].name);
                  for each(_loc10_ in _loc5_)
                  {
                     if(_loc10_._type == _loc6_[0] && _loc10_._lvl.Get() >= _loc6_[2])
                     {
                        _loc7_++;
                     }
                  }
               }
               if(_loc7_ >= _loc6_[1])
               {
                  _loc8_ = "#333333";
               }
               _loc4_ += "<font color=\"" + _loc8_ + "\">";
               if(_loc6_[1] == 1)
               {
                  if(_loc6_[2] == 1)
                  {
                     _loc4_ += "• " + KEYS.Get(_loc9_);
                  }
                  else
                  {
                     _loc4_ += "• " + KEYS.Get("bdg_buildingrequirement",{
                        "v1":_loc6_[2],
                        "v2":KEYS.Get(_loc9_)
                     });
                  }
               }
               else if(_loc6_[2] == 1)
               {
                  _loc4_ += "• " + KEYS.Get(_loc9_) + " x" + _loc6_[1];
               }
               else
               {
                  _loc4_ += "• " + KEYS.Get("bdg_buildingsrequirement",{
                     "v1":_loc6_[2],
                     "v2":KEYS.Get(_loc9_),
                     "v3":_loc6_[1]
                  });
               }
               _loc4_ += "</font><br>";
            }
            if(Boolean(GLOBAL._buildingProps[this._building._type - 1].names) && GLOBAL._buildingProps[this._building._type - 1].names.length > 1)
            {
               if((_loc12_ = this._building._lvl.Get()) < 1)
               {
                  _loc12_ = int(BASE._buildingsStored["bl" + this._building._type].Get());
               }
               _loc2_ = "<b>" + KEYS.Get(GLOBAL._buildingProps[this._building._type - 1].names[_loc12_ - 1]) + "</b><br>";
            }
            else
            {
               _loc2_ = "<b>" + KEYS.Get(GLOBAL._buildingProps[this._building._type - 1].name) + "</b><br>";
            }
            if(Boolean(GLOBAL._buildingProps[this._building._type - 1].descriptions) && GLOBAL._buildingProps[this._building._type - 1].descriptions.length > 1)
            {
               if((_loc12_ = this._building._lvl.Get()) < 1)
               {
                  _loc12_ = int(BASE._buildingsStored["bl" + this._building._type].Get());
               }
               _loc2_ += KEYS.Get(GLOBAL._buildingProps[this._building._type - 1].descriptions[_loc12_ - 1]);
            }
            else
            {
               _loc2_ += KEYS.Get(GLOBAL._buildingProps[this._building._type - 1].description);
            }
            if(_loc4_ != "")
            {
               _loc2_ += "<br><br>" + KEYS.Get("bdg_upgraderequirements",{"v1":_loc4_});
            }
            _loc3_ = GLOBAL._buildingProps[this._building._type - 1].costs[0];
            if(GLOBAL._buildingProps[this._building._type - 1].rewarded)
            {
               _loc3_ = {
                  "r1":0,
                  "r2":0,
                  "r3":0,
                  "r4":0,
                  "r5":0
               };
            }
            this.toggleCheckbox(true);
         }
         else if(param1 == "upgrade")
         {
            mcResources.bAction.addEventListener(MouseEvent.CLICK,this.ActionResourceUpgrade);
            mcResources.bAction.Setup(KEYS.Get("buildoptions_resources"));
            if(this._building._lvl.Get() < this._building._buildingProps.costs.length)
            {
               if(this._building._type != 14)
               {
                  for each(_loc6_ in this._building._buildingProps.costs[this._building._lvl.Get()].re)
                  {
                     _loc7_ = 0;
                     _loc8_ = "#CC0000";
                     if(_loc6_[0] == INFERNOQUAKETOWER.UNDERHALL_ID)
                     {
                        _loc9_ = "#bi_townhall#";
                        if(GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL) >= _loc6_[2] || Boolean(GLOBAL._buildingProps[this._building._type - 1].rewarded))
                        {
                           _loc7_ = 1;
                        }
                     }
                     else
                     {
                        _loc9_ = String(GLOBAL._buildingProps[_loc6_[0] - 1].name);
                        for each(_loc10_ in _loc5_)
                        {
                           if(_loc10_._type == _loc6_[0] && _loc10_._lvl.Get() >= _loc6_[2])
                           {
                              _loc7_++;
                           }
                        }
                     }
                     if(_loc7_ >= _loc6_[1])
                     {
                        _loc8_ = "#333333";
                     }
                     _loc4_ += "<font color=\"" + _loc8_ + "\">";
                     if(_loc6_[1] == 1)
                     {
                        if(_loc6_[2] == 1)
                        {
                           _loc4_ += "• " + KEYS.Get(_loc9_);
                        }
                        else
                        {
                           _loc4_ += "• " + KEYS.Get("bdg_buildingrequirement",{
                              "v1":_loc6_[2],
                              "v2":KEYS.Get(_loc9_)
                           });
                        }
                     }
                     else if(_loc6_[2] == 1)
                     {
                        _loc4_ += "• " + KEYS.Get(_loc9_) + " x" + _loc6_[1];
                     }
                     else
                     {
                        _loc4_ += "• " + KEYS.Get("bdg_buildingsrequirement",{
                           "v1":_loc6_[2],
                           "v2":KEYS.Get(GLOBAL._buildingProps[_loc6_[0] - 1].name),
                           "v3":_loc6_[1]
                        });
                     }
                     _loc4_ += "</font><br>";
                  }
               }
               _loc2_ = KEYS.Get("bdg_upgradedesc",{
                  "v1":KEYS.Get(this._building._buildingProps.name),
                  "v2":this._building._lvl.Get() + 1,
                  "v3":this._building._upgradeDescription
               });
               if(_loc4_ != "")
               {
                  _loc2_ += KEYS.Get("bdg_upgraderequirements",{"v1":_loc4_});
               }
               _loc3_ = this._building.UpgradeCost();
               this.toggleCheckbox(true);
            }
            else
            {
               _loc2_ = KEYS.Get("bdg_fullyupgraded");
               _loc3_ = null;
               this.toggleCheckbox(false);
            }
         }
         else if(param1 == "fortify")
         {
            mcResources.bAction.addEventListener(MouseEvent.CLICK,this.ActionResourceFortify);
            mcResources.bAction.Setup(KEYS.Get("buildoptions_resources"));
            if(Boolean(this._building._buildingProps.can_fortify) && this._building._fortification.Get() < this._building._buildingProps.fortify_costs.length)
            {
               for each(_loc6_ in this._building._buildingProps.fortify_costs[this._building._fortification.Get()].re)
               {
                  _loc7_ = 0;
                  _loc8_ = "#CC0000";
                  for each(_loc10_ in _loc5_)
                  {
                     if(_loc10_._type == _loc6_[0] && _loc10_._lvl.Get() >= _loc6_[2])
                     {
                        _loc7_++;
                     }
                  }
                  if(_loc7_ >= _loc6_[1])
                  {
                     _loc8_ = "#333333";
                  }
                  _loc4_ += "<font color=\"" + _loc8_ + "\">";
                  if(_loc6_[1] == 1)
                  {
                     if(_loc6_[2] == 1)
                     {
                        _loc4_ += "• " + KEYS.Get(GLOBAL._buildingProps[_loc6_[0] - 1].name);
                     }
                     else
                     {
                        _loc4_ += "• " + KEYS.Get("bdg_buildingrequirement",{
                           "v1":_loc6_[2],
                           "v2":KEYS.Get(GLOBAL._buildingProps[_loc6_[0] - 1].name)
                        });
                     }
                  }
                  else if(_loc6_[2] == 1)
                  {
                     _loc4_ += "• " + KEYS.Get(GLOBAL._buildingProps[_loc6_[0] - 1].name) + " x" + _loc6_[1];
                  }
                  else
                  {
                     _loc4_ += "• " + KEYS.Get("bdg_buildingsrequirement",{
                        "v1":_loc6_[2],
                        "v2":KEYS.Get(GLOBAL._buildingProps[_loc6_[0] - 1].name),
                        "v3":_loc6_[1]
                     });
                  }
                  _loc4_ += "</font><br>";
               }
               _loc2_ = "<b>Fortify your " + KEYS.Get(this._building._buildingProps.name) + " to level " + (this._building._fortification.Get() + 1) + "!<br></b>";
               _loc2_ += "Damage protection goes from " + (!!this._building._fortification.Get() ? this._building._fortification.Get() * 10 + 10 : 0) + "% to " + (this._building._fortification.Get() * 10 + 20) + "%.<br><br>";
               if(_loc4_ != "")
               {
                  _loc2_ += KEYS.Get("bdg_upgraderequirements",{"v1":_loc4_});
               }
               _loc3_ = this._building.FortifyCost();
               this.toggleCheckbox(true);
            }
            else
            {
               _loc2_ = KEYS.Get("bdg_fullyfortified");
               _loc3_ = null;
               this.toggleCheckbox(false);
            }
         }
         else if(param1 == "more")
         {
            mcResources.bAction.addEventListener(MouseEvent.CLICK,this.ActionRecycle);
            mcResources.bAction.SetupKey("btn_recycle");
            if(this._building._buildingProps.costs.length == 1)
            {
               _loc2_ = KEYS.Get("bdg_morenolevel",{
                  "v1":KEYS.Get(this._building._buildingProps.name),
                  "v2":KEYS.Get(this._building._buildingProps.description),
                  "v3":this._building._recycleDescription
               });
            }
            else if(this._building._buildingProps.names && this._building._buildingProps.names.length > 1 && Boolean(this._building._buildingProps.descriptions) && this._building._buildingProps.descriptions.length > 1)
            {
               _loc2_ = KEYS.Get("bdg_morenolevel",{
                  "v1":KEYS.Get(this._building._buildingProps.names[this._building._lvl.Get() - 1]),
                  "v2":KEYS.Get(this._building._buildingProps.descriptions[this._building._lvl.Get() - 1]),
                  "v3":this._building._recycleDescription
               });
            }
            else
            {
               _loc2_ = KEYS.Get("bdg_more",{
                  "v1":KEYS.Get(this._building._buildingProps.name),
                  "v2":this._building._lvl.Get(),
                  "v3":KEYS.Get(this._building._buildingProps.description),
                  "v4":this._building._recycleDescription
               });
            }
            if(this._building._class == "decoration")
            {
               mcResources.bAction.SetupKey("btn_addstorage");
            }
            else
            {
               mcResources.bAction.SetupKey("btn_recycle");
               if(TUTORIAL._stage < 200)
               {
                  mcResources.bAction.Enabled = false;
               }
            }
            _loc3_ = this._building.RecycleCost();
            this.toggleCheckbox();
         }
         tDescription.htmlText = _loc2_;
         var _loc11_:int = 0;
         if(_loc3_)
         {
            _loc13_ = int(_loc3_.time);
            _loc14_ = 1;
            while(_loc14_ < 5)
            {
               _loc15_ = this.mcResources["mcR" + _loc14_];
               _loc17_ = (_loc16_ = BASE.isInfernoBuilding(this._building._type)) ? BASE._iresources : BASE._resources;
               _loc18_ = _loc16_ ? GLOBAL.iresourceNames : GLOBAL._resourceNames;
               _loc15_.gotoAndStop(_loc16_ || BASE.isInfernoMainYardOrOutpost ? _loc14_ + 6 : _loc14_);
               _loc15_.tTitle.htmlText = "<b>" + KEYS.Get(_loc18_[_loc14_ - 1]) + "</b>";
               _loc15_.tValue.htmlText = "<b><font color=\"#" + (_loc3_["r" + _loc14_] > _loc17_["r" + _loc14_].Get() && (param1 == "upgrade" || param1 == "build" || param1 == "fortify") ? "FF0000" : "000000") + "\">" + GLOBAL.FormatNumber(_loc3_["r" + _loc14_]) + "</font></b>";
               if(Boolean(_loc3_["r" + _loc14_]) && _loc3_["r" + _loc14_] > 0)
               {
                  _loc15_.alpha = 1;
               }
               else
               {
                  _loc15_.alpha = 0.25;
               }
               _loc14_++;
            }
            (_loc15_ = this.mcResources.mcTime).gotoAndStop(BASE.isInfernoBuilding(this._building._type) || BASE.isInfernoMainYardOrOutpost ? 12 : 6);
            if(TUTORIAL._stage >= 200 && _loc3_.time > 0)
            {
               _loc15_.visible = true;
               _loc15_.tTitle.htmlText = "<b>" + KEYS.Get(_loc18_[5]) + "</b>";
               _loc15_.tValue.htmlText = "<b>" + GLOBAL.ToTime(_loc13_,true,false) + "</b>";
            }
            else
            {
               _loc15_.visible = false;
            }
            if(this._doStreamPost && BASE.isMainYard)
            {
               if(_loc3_.time > 600)
               {
                  this.streampost_cb.Enabled = true;
                  mcCBBG.alpha = 1;
                  this.streampost_cb.alpha = 1;
               }
               else
               {
                  this.streampost_cb.Enabled = false;
                  mcCBBG.alpha = 0.25;
                  this.streampost_cb.alpha = 0.25;
               }
            }
            if(TUTORIAL._stage < 200 || STORE._storeItems["BUILDING" + this._building._type] || param1 != GLOBAL.e_BASE_MODE.BUILD && param1 != "upgrade" && param1 != "fortify")
            {
               mcInstant.visible = false;
               _loc11_ = tDescription.height + 53;
            }
            else
            {
               _loc11_ = tDescription.height + 93;
            }
            _loc11_ += 30;
         }
         else
         {
            mcResources.visible = false;
            mcInstant.visible = false;
         }
         if(_loc11_ < 200)
         {
            _loc11_ = 200;
         }
         mcBG.height = _loc11_;
         mcBG.Setup();
         if(TUTORIAL._stage < 200 || STORE._storeItems["BUILDING" + this._building._type] || param1 != GLOBAL.e_BASE_MODE.BUILD && param1 != "upgrade" && param1 != "fortify")
         {
            mcResources.y = mcBG.y + _loc11_ - 63;
         }
         else
         {
            mcResources.y = mcBG.y + _loc11_ - 63;
            mcInstant.y = mcBG.y + _loc11_ - 100;
         }
         if(this._doStreamPost && BASE.isMainYard)
         {
            mcCBBG.y = mcResources.y + (mcResources.height + 2);
            this.streampost_cb.y = mcResources.y + (mcResources.height + 2);
            mcInfoCB.y = this.streampost_cb.y + this.streampost_cb.height / 2;
         }
      }
      
      private function ActionRecycle(param1:MouseEvent) : void
      {
         if(TUTORIAL._stage < 200)
         {
            GLOBAL.Message(KEYS.Get("tut_recycle_locked"),KEYS.Get("btn_close"));
         }
         else
         {
            this._building.Recycle();
         }
      }
      
      private function ActionResourceBuild(param1:MouseEvent = null) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = BASE.CanBuild(this._building._type);
         var _loc6_:Object = GLOBAL._buildingProps[this._building._type - 1].costs[0];
         if(GLOBAL._buildingProps[this._building._type - 1].rewarded)
         {
            _loc6_ = {
               "r1":0,
               "r2":0,
               "r3":0,
               "r4":0,
               "time":_loc6_.time,
               "re":_loc6_.re
            };
         }
         if(Boolean(_loc5_.error) && !_loc5_.needResource)
         {
            GLOBAL.Message(_loc5_.errorMessage);
         }
         else
         {
            if(this._doStreamPost && BASE.isMainYard)
            {
               if(this.streampost_cb.Checked)
               {
                  GLOBAL.StatSet("post_bu",1);
               }
               else
               {
                  GLOBAL.StatSet("post_bu",0);
               }
            }
            if(STORE._storeItems["BUILDING" + this._building._type])
            {
               if(InventoryManager.buildingStorageCount(this._building._type) > 0)
               {
                  if(BASE.addBuildingB(this._building._type))
                  {
                     BUILDINGS.Hide(param1);
                  }
                  return;
               }
               if(STORE._storeItems["BUILDING" + this._building._type].c[0] > BASE._credits.Get())
               {
                  POPUPS.DisplayGetShiny();
                  return;
               }
            }
            if(_loc5_.needResource)
            {
               _loc3_ = 0;
               _loc8_ = (_loc7_ = BASE.isInfernoBuilding(this._building._type)) ? BASE._iresources : BASE._resources;
               _loc9_ = 1;
               while(_loc9_ < 5)
               {
                  if(_loc6_["r" + _loc9_] > 0)
                  {
                     if(_loc6_["r" + _loc9_] > _loc8_["r" + _loc9_ + "max"])
                     {
                        _loc2_ = true;
                        break;
                     }
                     if(_loc6_["r" + _loc9_] > _loc8_["r" + _loc9_].Get())
                     {
                        _loc3_ += _loc6_["r" + _loc9_] - _loc8_["r" + _loc9_].Get();
                     }
                  }
                  _loc9_++;
               }
               _loc4_ = Math.ceil(Math.pow(Math.sqrt(_loc3_ / 2),0.75));
               if(_loc2_)
               {
                  GLOBAL.Message(_loc7_ ? KEYS.Get("inf_buildoptions_err_moresilos") : KEYS.Get("buildoptions_err_moresilos"));
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("buildoptions_err_moreresources",{
                     "v1":GLOBAL.FormatNumber(_loc3_),
                     "v2":GLOBAL.FormatNumber(_loc4_)
                  }),KEYS.Get("btn_getresources"),this.TopoffBuild);
               }
            }
            else if(BASE.addBuildingB(this._building._type))
            {
               BUILDINGS.Hide(param1);
            }
         }
      }
      
      private function ActionResourceUpgrade(param1:MouseEvent) : void
      {
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = BASE.CanUpgrade(this._building);
         var _loc6_:Boolean;
         var _loc7_:Object = (_loc6_ = BASE.isInfernoBuilding(this._building._type)) ? BASE._iresources : BASE._resources;
         if(Boolean(_loc5_.error) && !_loc5_.needResource)
         {
            GLOBAL.Message(_loc5_.errorMessage);
         }
         else if(_loc5_.needResource)
         {
            _loc8_ = this._building._buildingProps.costs[this._building._lvl.Get()];
            _loc3_ = 0;
            _loc9_ = 1;
            while(_loc9_ < 5)
            {
               if(_loc8_["r" + _loc9_] > 0)
               {
                  if(_loc8_["r" + _loc9_] > _loc7_["r" + _loc9_ + "max"])
                  {
                     _loc2_ = true;
                  }
                  else if(_loc8_["r" + _loc9_] > _loc7_["r" + _loc9_].Get())
                  {
                     _loc3_ += _loc8_["r" + _loc9_] - _loc7_["r" + _loc9_].Get();
                  }
               }
               _loc9_++;
            }
            _loc4_ = Math.ceil(Math.pow(Math.sqrt(_loc3_ / 2),0.75));
            if(_loc2_)
            {
               GLOBAL.Message(_loc6_ || BASE.isInfernoMainYardOrOutpost ? KEYS.Get("inf_buildoptions_err_moresilosupgrade") : KEYS.Get("buildoptions_err_moresilosupgrade"));
            }
            else
            {
               GLOBAL.Message(KEYS.Get("buildoptions_err_moreresourcesupgrade",{
                  "v1":GLOBAL.FormatNumber(_loc3_),
                  "v2":GLOBAL.FormatNumber(_loc4_)
               }),KEYS.Get("btn_getresources"),this.TopoffUpgrade);
            }
         }
         else
         {
            if(this._doStreamPost && BASE.isMainYard)
            {
               if(this.streampost_cb.Checked)
               {
                  GLOBAL.StatSet("post_bu",1);
               }
               else
               {
                  GLOBAL.StatSet("post_bu",0);
               }
            }
            if(this._building.Upgrade())
            {
               BUILDINGOPTIONS.Hide();
            }
         }
      }
      
      private function ActionResourceFortify(param1:MouseEvent) : void
      {
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object;
         if(Boolean((_loc5_ = BASE.CanFortify(this._building)).error) && !_loc5_.needResource)
         {
            GLOBAL.Message(_loc5_.errorMessage);
         }
         else if(_loc5_.needResource)
         {
            _loc6_ = this._building._buildingProps.fortify_costs[this._building._fortification.Get()];
            _loc3_ = 0;
            _loc7_ = 1;
            while(_loc7_ < 5)
            {
               if(_loc6_["r" + _loc7_] > 0)
               {
                  if(_loc6_["r" + _loc7_] > BASE._resources["r" + _loc7_ + "max"])
                  {
                     _loc2_ = true;
                  }
                  else if(_loc6_["r" + _loc7_] > BASE._resources["r" + _loc7_].Get())
                  {
                     _loc3_ += _loc6_["r" + _loc7_] - BASE._resources["r" + _loc7_].Get();
                  }
               }
               _loc7_++;
            }
            _loc4_ = Math.ceil(Math.pow(Math.sqrt(_loc3_ / 2),0.75));
            if(_loc2_)
            {
               GLOBAL.Message(KEYS.Get("buildoptions_err_moresilosfortify"));
            }
            else
            {
               GLOBAL.Message(KEYS.Get("buildoptions_err_moreresourcesfortify",{
                  "v1":GLOBAL.FormatNumber(_loc3_),
                  "v2":GLOBAL.FormatNumber(_loc4_)
               }),KEYS.Get("btn_getresources"),this.TopoffFortify);
            }
         }
         else if(this._building.Fortify())
         {
            BUILDINGOPTIONS.Hide();
         }
      }
      
      private function ActionInstantBuild(param1:MouseEvent) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = BASE.CanBuild(this._building._type,true);
         var _loc6_:Object = GLOBAL._buildingProps[this._building._type - 1].costs[0];
         if(_loc5_.error)
         {
            GLOBAL.Message(_loc5_.errorMessage);
         }
         else
         {
            if((_loc7_ = int(_loc6_.time)) <= 300)
            {
               _loc7_ = 0;
            }
            _loc8_ = _loc6_.r1 + _loc6_.r2 + _loc6_.r3;
            _loc9_ = Math.ceil(Math.pow(Math.sqrt(_loc8_ / 2),0.75));
            _loc10_ = STORE.GetTimeCost(_loc7_);
            _loc11_ = _loc9_ + _loc10_;
            if((_loc11_ = int(_loc11_ * 0.95)) <= 5)
            {
               _loc11_ = 5;
            }
            if(_loc11_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
               return;
            }
            if(BASE.addBuildingB(this._building._type,true))
            {
               BUILDINGS.Hide(param1);
               GLOBAL._newBuilding._buildInstant = true;
               GLOBAL._newBuilding._buildInstantCost = new SecNum(_loc11_);
            }
         }
      }
      
      private function ActionInstantUpgrade(param1:MouseEvent) : void
      {
         var _loc2_:Object = BASE.CanUpgrade(this._building);
         if(Boolean(_loc2_.error) && !_loc2_.needResource)
         {
            GLOBAL.Message(_loc2_.errorMessage);
         }
         else if(this._building.DoInstantUpgrade())
         {
            BUILDINGOPTIONS.Hide();
         }
      }
      
      private function ActionInstantFortify(param1:MouseEvent) : void
      {
         var _loc2_:Object = BASE.CanFortify(this._building);
         if(Boolean(_loc2_.error) && !_loc2_.needResource)
         {
            GLOBAL.Message(_loc2_.errorMessage);
         }
         else if(this._building.DoInstantFortify())
         {
            BUILDINGOPTIONS.Hide();
         }
      }
      
      private function TopoffUpgrade(param1:MouseEvent = null) : void
      {
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc5_:Boolean;
         var _loc6_:Object = (_loc5_ = BASE.isInfernoBuilding(this._building._type)) ? BASE._iresources : BASE._resources;
         var _loc7_:Object = this._building._buildingProps.costs[this._building._lvl.Get()];
         _loc8_ = 1;
         while(_loc8_ < 5)
         {
            if(_loc7_["r" + _loc8_] > 0)
            {
               if(_loc7_["r" + _loc8_] > _loc6_["r" + _loc8_ + "max"])
               {
                  _loc3_ = true;
               }
               else if(_loc7_["r" + _loc8_] > _loc6_["r" + _loc8_].Get())
               {
                  _loc2_ += _loc7_["r" + _loc8_] - _loc6_["r" + _loc8_].Get();
               }
            }
            _loc8_++;
         }
         _loc4_ = Math.ceil(Math.pow(Math.sqrt(_loc2_ / 2),0.75));
         if(_loc3_)
         {
            GLOBAL.Message(KEYS.Get("msg_overcapacity"));
         }
         else if(BASE._pendingPurchase.length == 0)
         {
            if(_loc4_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               _loc8_ = 1;
               while(_loc8_ < 5)
               {
                  if(_loc7_["r" + _loc8_] > 0 && _loc7_["r" + _loc8_] > _loc6_["r" + _loc8_].Get())
                  {
                     BASE.Fund(_loc8_,_loc7_["r" + _loc8_] - _loc6_["r" + _loc8_].Get(),false,null,_loc5_);
                  }
                  _loc8_++;
               }
               if(this._doStreamPost && BASE.isMainYard)
               {
                  if(this.streampost_cb.Checked)
                  {
                     GLOBAL.StatSet("post_bu",1);
                  }
                  else
                  {
                     GLOBAL.StatSet("post_bu",0);
                  }
               }
               this._building.Upgrade();
               this.Hide();
               BASE.Purchase("BRTOPUP",_loc4_,"BUILDINGOPTIONS.TopoffUpgrade");
            }
         }
      }
      
      public function TopoffBuild(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = GLOBAL._buildingProps[this._building._type - 1].costs[0];
         var _loc3_:Boolean = BASE.isInfernoBuilding(this._building._type);
         var _loc4_:Object = _loc3_ ? BASE._iresources : BASE._resources;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 1;
         while(_loc7_ < 5)
         {
            if(_loc2_["r" + _loc7_] > 0)
            {
               if(_loc2_["r" + _loc7_] > _loc4_["r" + _loc7_ + "max"])
               {
                  _loc6_ = true;
               }
               else if(_loc2_["r" + _loc7_] > _loc4_["r" + _loc7_].Get())
               {
                  _loc5_ += _loc2_["r" + _loc7_] - _loc4_["r" + _loc7_].Get();
               }
            }
            _loc7_++;
         }
         var _loc8_:int = Math.ceil(Math.pow(Math.sqrt(_loc5_ / 2),0.75));
         if(_loc6_)
         {
            GLOBAL.Message(KEYS.Get("msg_overcapacity"));
         }
         else if(_loc8_ > BASE._credits.Get())
         {
            POPUPS.DisplayGetShiny();
         }
         else
         {
            BASE.Purchase("BRTOPUP",_loc8_,"BUILDINGOPTIONS.TopoffBuild");
            _loc7_ = 1;
            while(_loc7_ < 5)
            {
               if(_loc2_["r" + _loc7_] > 0 && _loc2_["r" + _loc7_] > _loc4_["r" + _loc7_].Get())
               {
                  BASE.Fund(_loc7_,_loc2_["r" + _loc7_] - _loc4_["r" + _loc7_].Get(),false,null,_loc3_);
               }
               _loc7_++;
            }
            this.ActionResourceBuild();
         }
      }
      
      private function TopoffFortify(param1:MouseEvent = null) : void
      {
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc5_:Object = this._building._buildingProps.fortify_costs[this._building._fortification.Get()];
         _loc6_ = 1;
         while(_loc6_ < 5)
         {
            if(_loc5_["r" + _loc6_] > 0)
            {
               if(_loc5_["r" + _loc6_] > BASE._resources["r" + _loc6_ + "max"])
               {
                  _loc3_ = true;
               }
               else if(_loc5_["r" + _loc6_] > BASE._resources["r" + _loc6_].Get())
               {
                  _loc2_ += _loc5_["r" + _loc6_] - BASE._resources["r" + _loc6_].Get();
               }
            }
            _loc6_++;
         }
         _loc4_ = Math.ceil(Math.pow(Math.sqrt(_loc2_ / 2),0.75));
         if(_loc3_)
         {
            GLOBAL.Message(KEYS.Get("msg_overcapacity"));
         }
         else if(BASE._pendingPurchase.length == 0)
         {
            if(_loc4_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               _loc6_ = 1;
               while(_loc6_ < 5)
               {
                  if(_loc5_["r" + _loc6_] > 0 && _loc5_["r" + _loc6_] > BASE._resources["r" + _loc6_].Get())
                  {
                     BASE.Fund(_loc6_,_loc5_["r" + _loc6_] - BASE._resources["r" + _loc6_].Get());
                  }
                  _loc6_++;
               }
               this._building.Fortify();
               this.Hide();
               BASE.Purchase("BRTOPUP",_loc4_,"BUILDINGOPTIONS.TopoffFortify");
            }
         }
      }
      
      private function Render(param1:String) : String
      {
         var FortifyImageLoaded:Function;
         var ImageLoaded:Function;
         var numImageElements:Function;
         var DefaultImageLoaded:Function;
         var img:String = null;
         var nextFortifyLevel:int = 0;
         var imageDataA:Object = null;
         var imageDataB:Object = null;
         var imageLevel:int = 0;
         var thlvl:int = 0;
         var lowestLevel:int = 0;
         var n:String = null;
         var upgradeImgLen:int = 0;
         var i:int = 0;
         var j:int = 0;
         var str:String = param1;
         var buildingProps:Object = GLOBAL._buildingProps[this._building._type - 1];
         if(str == "fortify")
         {
            FortifyImageLoaded = function(param1:String, param2:BitmapData):void
            {
               imageContainer.Clear();
               imageContainer.addChild(new Bitmap(param2));
            };
            nextFortifyLevel = this._building._fortification.Get() + 1;
            if(nextFortifyLevel > 4)
            {
               nextFortifyLevel = 4;
            }
            img = "fortifybuttons/" + "fort" + nextFortifyLevel + ".png";
            ImageCache.GetImageWithCallBack(img,FortifyImageLoaded);
         }
         else if(buildingProps.upgradeImgData)
         {
            ImageLoaded = function(param1:String, param2:BitmapData):void
            {
               imageContainer.Clear();
               imageContainer.addChild(new Bitmap(param2));
            };
            imageDataA = buildingProps.upgradeImgData;
            thlvl = GLOBAL.GetBuildingTownHallLevel(buildingProps);
            if(buildingProps.upgradeImgData)
            {
               lowestLevel = int.MAX_VALUE;
               for(n in buildingProps.upgradeImgData)
               {
                  if(!isNaN(Number(n)))
                  {
                     lowestLevel = Math.min(lowestLevel,Number(n));
                  }
               }
               if(lowestLevel != int.MAX_VALUE && buildingProps.upgradeImgData[lowestLevel].silhouette_img && !BASE.HasRequirements(buildingProps.costs[0]) && !buildingProps.rewarded)
               {
                  img = String(buildingProps.upgradeImgData.baseurl + buildingProps.upgradeImgData[lowestLevel].silhouette_img);
               }
            }
            if(!img)
            {
               if(this._building._lvl.Get() == 0)
               {
                  imageDataB = imageDataA[1];
                  imageLevel = 1;
               }
               else
               {
                  numImageElements = function(param1:Object):int
                  {
                     var _loc3_:String = null;
                     var _loc2_:int = 0;
                     for(_loc3_ in param1)
                     {
                        _loc2_++;
                     }
                     return _loc2_;
                  };
                  upgradeImgLen = numImageElements(imageDataA);
                  if(Boolean(imageDataA[this._building._lvl.Get()]) && imageDataA[this._building._lvl.Get()] >= this._building._buildingProps.hp.length)
                  {
                     imageDataB = imageDataA[this._building._lvl.Get()];
                     imageLevel = this._building._lvl.Get();
                  }
                  else
                  {
                     i = this._building._lvl.Get();
                     if(str == "upgrade")
                     {
                        i += 1;
                     }
                     if(Boolean(imageDataA[i]) && i > this._building._lvl.Get())
                     {
                        imageDataB = imageDataA[i];
                        imageLevel = i;
                     }
                     else
                     {
                        j = this._building._lvl.Get();
                        while(j > 0)
                        {
                           if(imageDataA[j])
                           {
                              imageDataB = imageDataA[j];
                              imageLevel = j;
                              break;
                           }
                           if(j == 1)
                           {
                              imageDataB = imageDataB[1];
                              imageLevel = 1;
                              break;
                           }
                           j--;
                        }
                     }
                  }
               }
               img = String(buildingProps.upgradeImgData.baseurl + buildingProps.upgradeImgData[imageLevel].img);
            }
            ImageCache.GetImageWithCallBack(img,ImageLoaded);
         }
         else
         {
            DefaultImageLoaded = function(param1:String, param2:BitmapData):void
            {
               imageContainer.Clear();
               imageContainer.addChild(new Bitmap(param2));
            };
            if(Boolean(buildingProps.buildingbuttons) && Boolean(BASE._buildingsStored["bl" + this._building._type]) && buildingProps.buildingbuttons.length >= BASE._buildingsStored["bl" + this._building._type].Get())
            {
               img = "buildingbuttons/" + buildingProps.buildingbuttons[BASE._buildingsStored["bl" + this._building._type].Get() - 1] + ".jpg";
            }
            else if(Boolean(buildingProps.buildingbuttons) && buildingProps.buildingbuttons.length >= this._building._lvl.Get())
            {
               img = "buildingbuttons/" + buildingProps.buildingbuttons[this._building._lvl.Get() - 1] + ".jpg";
            }
            else if(Boolean(buildingProps.buildingbuttons) && buildingProps.buildingbuttons.length > 0)
            {
               img = "buildingbuttons/" + buildingProps.buildingbuttons[0] + ".jpg";
            }
            else
            {
               img = "buildingbuttons/" + this._building._type + ".jpg";
            }
            ImageCache.GetImageWithCallBack(img,DefaultImageLoaded);
         }
         return img;
      }
      
      private function onPostRollOver(param1:MouseEvent) : void
      {
         if(this._doStreamPost && BASE.isMainYard)
         {
            mcInfoCB.visible = true;
         }
      }
      
      private function onPostRollOut(param1:MouseEvent) : void
      {
         if(this._doStreamPost && BASE.isMainYard)
         {
            mcInfoCB.visible = false;
         }
      }
      
      public function toggleCheckbox(param1:Boolean = false) : void
      {
         if(this._doStreamPost && BASE.isMainYard)
         {
            mcInfoCB.visible = false;
            mcCBBG.visible = param1;
            this.streampost_cb.visible = param1;
         }
      }
      
      public function Hide() : void
      {
         try
         {
            BUILDINGS._mc.HideInfo();
         }
         catch(e:Error)
         {
         }
         try
         {
            BUILDINGOPTIONS.Hide();
         }
         catch(e:Error)
         {
         }
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

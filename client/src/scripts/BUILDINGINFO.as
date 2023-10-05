package
{
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom3.popups.MapRoom3ConfirmMigrationPopup;
   import com.monsters.maproom3.popups.MapRoom3RelocatePopup;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.radio.RADIO;
   import com.monsters.siege.SiegeFactory;
   import com.monsters.siege.SiegeLab;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import gs.*;
   import gs.easing.*;
   
   public class BUILDINGINFO
   {
      
      public static var _mc:MovieClip;
      
      public static var _buttonsMC:MovieClip;
      
      public static var _building:BFOUNDATION;
      
      public static var _clickPoint:Point;
      
      public static var _props:Object;
      
      private static var _positionSet:Boolean = false;
       
      
      public function BUILDINGINFO()
      {
         super();
      }
      
      public static function Show(param1:BFOUNDATION) : void
      {
         if(Boolean(GLOBAL._selectedBuilding) && GLOBAL._selectedBuilding._moving)
         {
            return;
         }
         _positionSet = false;
         _building = param1;
         _props = GLOBAL._buildingProps[_building._type - 1];
         _mc = MAP._BUILDINGINFO.addChild(new buildingInfo()) as MovieClip;
         _mc.tName.autoSize = TextFieldAutoSize.CENTER;
         var _loc2_:* = "<b>" + KEYS.Get(_props.name) + "</b>";
         if(_building._lvl.Get() > 0 && _props.costs && _props.costs.length > 1)
         {
            if(Boolean(_props.names) && _props.names.length > 1)
            {
               _loc2_ = "<b>" + KEYS.Get(_props.names[param1._lvl.Get() - 1]) + "</b>";
            }
            else
            {
               _loc2_ += "<br><b>" + KEYS.Get("bdg_infopop_levelnum",{"v1":param1._lvl.Get()}) + "</b>";
            }
            if(_building._fortification.Get() > 0)
            {
               _loc2_ += "<br><b>" + KEYS.Get("bdg_fortified_level",{"v1":_building._fortification.Get()}) + "</b>";
            }
            if(_building._class == "tower" && _building._type != 22 && GLOBAL._towerOverdrive && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp() && _building._countdownBuild.Get() == 0 && _building._countdownUpgrade.Get() == 0)
            {
               _loc2_ += "<font color=\"#0000ff\"> <br><b>" + KEYS.Get("bdg_25%boost") + "</b></font>";
            }
         }
         _mc.tName.htmlText = _loc2_;
         _mc.removeEventListener(Event.ENTER_FRAME,Tick);
         _mc.addEventListener(Event.ENTER_FRAME,Tick);
         if(GLOBAL._zoomed)
         {
            _mc.scaleX = _mc.scaleY = 2;
         }
         Update();
      }
      
      public static function Update() : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:BFOUNDATION = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Button_CLIP = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:TextField = null;
         var _loc1_:Array = [];
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = MapRoomManager.instance.isInMapRoom3 && BASE.isOutpost;
         if(_mc)
         {
            _loc5_ = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.health < _loc6_.maxHealth)
               {
                  _loc4_ += 1;
               }
            }
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               if(_building.health < _building.maxHealth)
               {
                  _loc2_ = false;
                  if(_building._repairing == 0)
                  {
                     _loc1_.push(["btn_repair",30]);
                  }
                  else
                  {
                     _loc1_.push(["btn_speedup",30,_loc4_ >= 2 ? false : true]);
                     if(_loc4_ >= 2)
                     {
                        _loc1_.push(["btn_repairall",30,true]);
                     }
                  }
               }
               else if(_building._countdownBuild.Get() > 0)
               {
                  _loc2_ = false;
                  _loc1_.push(["btn_speedup",30,true]);
                  if(TUTORIAL._stage > 100 && _building._buildingProps.type != "decoration")
                  {
                     _loc1_.push(["btn_stopbuild",26]);
                  }
               }
               else if(_building._countdownUpgrade.Get() > 0)
               {
                  _loc2_ = false;
                  _loc1_.push(["btn_speedup",30,true]);
                  if(TUTORIAL._stage > 100)
                  {
                     _loc1_.push(["btn_stopupgrade",26]);
                  }
               }
               else if(_building._countdownFortify.Get() > 0)
               {
                  _loc2_ = false;
                  _loc1_.push(["btn_speedup",30,true]);
                  _loc1_.push(["btn_stopfortify",26]);
               }
               else if(_props.type == "resource")
               {
                  if(BASE.isOutpost)
                  {
                     _loc1_.push(["btn_bank_disabled",30,0,true]);
                  }
                  else
                  {
                     if(TUTORIAL._stage != 20 && TUTORIAL._stage != 21)
                     {
                        _loc1_.push(["btn_bank",30,0,GLOBAL.FormatNumber(_building._stored.Get())]);
                     }
                     if(TUTORIAL._stage >= 200)
                     {
                        _loc1_.push(["btn_bankall",30]);
                     }
                  }
               }
               if(TUTORIAL._stage > 4)
               {
                  if(_loc2_)
                  {
                     _loc12_ = true;
                     _loc13_ = false;
                     if(_building._countdownBuild.Get() + _building._countdownUpgrade.Get() + _building._countdownFortify.Get() > 0 || _building._repairing > 0)
                     {
                        _loc1_.push(["btn_speedup",30,true]);
                        _loc13_ = true;
                     }
                     if(_props.id == 8)
                     {
                        if(BASE.isInfernoMainYardOrOutpost)
                        {
                           _loc1_.push(["btn_openstrongbox",30,true]);
                        }
                        else
                        {
                           _loc1_.push(["btn_openlocker",30,true]);
                        }
                        if(CREATURELOCKER._unlocking != null && !_loc13_)
                        {
                           _loc1_.push(["btn_speedup",30,true]);
                        }
                     }
                     else if(_props.id == 9)
                     {
                        _loc1_.push(["btn_juicemonsters",30,true]);
                        if(CREATURES._guardian)
                        {
                           _loc1_.push(["btn_juiceguardian",30,true]);
                        }
                     }
                     else if(_props.id == 10)
                     {
                        _loc1_.push(["btn_yardplanner",30,true]);
                     }
                     else if(_props.id == 11 || _props.id == 5 || _props.id == 51)
                     {
                        if(MapRoomManager.instance.isInMapRoom3 === false)
                        {
                           _loc1_.push(["btn_joinnwm",30,_loc12_]);
                           _loc12_ = false;
                        }
                        _loc1_.push(["btn_viewmap",30,_loc12_]);
                     }
                     else if(_props.id == 12)
                     {
                        _loc1_.push(["btn_openstore",30,true]);
                     }
                     else if(_props.id == 13)
                     {
                        if(GLOBAL._bHatcheryCC)
                        {
                           _loc1_.push(["btn_openhcc",30,true]);
                        }
                        else
                        {
                           _loc1_.push([BASE.isInfernoMainYardOrOutpost ? "btn_viewincubator" : "btn_viewhatchery",30,true]);
                        }
                        if(!GLOBAL._hatcheryOverdrive && !_loc13_ && TUTORIAL._stage > 200)
                        {
                           _loc1_.push(["btn_speedup",30,true]);
                        }
                     }
                     else if(HOUSING.isHousingBuilding(_props.id))
                     {
                        if(BASE.isInfernoMainYardOrOutpost)
                        {
                           _loc1_.push(["btn_viewcompound",30,true]);
                        }
                        else
                        {
                           _loc1_.push(["btn_viewhousing",30,true]);
                        }
                     }
                     else if(_props.id == 19)
                     {
                        _loc1_.push(["btn_openbaiter",30,true]);
                     }
                     else if(_props.id == 22)
                     {
                        _loc1_.push(["btn_openbunker",30,true]);
                     }
                     else if(_props.id == 16)
                     {
                        _loc1_.push(["btn_openhcc",30,true]);
                        if(!GLOBAL._hatcheryOverdrive && !_loc13_)
                        {
                           _loc1_.push(["btn_speedup",30,true]);
                        }
                     }
                     else if(_props.id == 26)
                     {
                        _loc1_.push(["btn_openacademy",30,true]);
                        if(Boolean(_building._upgrading) && !_loc13_)
                        {
                           _loc1_.push(["btn_speedup",30,true]);
                        }
                     }
                     else if(_props.id == 113)
                     {
                        _loc1_.push(["btn_openradio",30,true]);
                     }
                     else if(_props.id == 114)
                     {
                        _loc1_.push(["btn_opencage",30,true]);
                     }
                     else if(_props.id == 116)
                     {
                        _loc1_.push(["btn_openlab",30,true]);
                     }
                     else if(_props.id == 119)
                     {
                        _loc1_.push(["btn_openchamber",30,true]);
                     }
                     else if(_props.id == SiegeFactory.ID)
                     {
                        _loc1_.push([SiegeFactory.SIEGE_BUTTON,30,true]);
                     }
                     else if(_props.id == SiegeLab.ID)
                     {
                        _loc1_.push([SiegeLab.SIEGE_BUTTON,30,true]);
                     }
                     else if(_props.id == BUILDING14.k_TYPE && MapRoomManager.instance.isInMapRoom3 && !BASE.isInfernoMainYardOrOutpost)
                     {
                        _loc1_.push([MapRoom3RelocatePopup.k_RELOCATE_BUTTONINFO,30,true]);
                     }
                  }
                  if(_loc2_ && _props.type != "mushroom")
                  {
                     if(_props.type != "decoration" && _props.id != MAPROOM.TYPE && !_loc3_)
                     {
                        _loc1_.push(["btn_upgrade",30]);
                     }
                     if(_props.type == "wall" && !_loc3_)
                     {
                        _loc1_.push(["btn_upgradeall",30,1]);
                     }
                     if(_props.type == "resource" && !_loc3_)
                     {
                        if(!GLOBAL._harvesterOverdrive || GLOBAL._harvesterOverdrive < GLOBAL.Timestamp())
                        {
                           _loc1_.push(["btn_speedup",30,1]);
                        }
                     }
                     if(TUTORIAL._stage >= 200)
                     {
                        if(Boolean(_props.can_fortify) && !_loc3_)
                        {
                           _loc1_.push(["btn_fortify",30]);
                        }
                        if(!_props.isNoMoreInfoButton)
                        {
                           _loc1_.push(["btn_more",30]);
                        }
                        if(!_building.isImmobile || GLOBAL._aiDesignMode)
                        {
                           _loc1_.push(["btn_move",30]);
                        }
                     }
                  }
                  if(_loc2_ && _props.type == "taunt")
                  {
                     _loc1_.push(["btn_viewmessage",30]);
                  }
               }
            }
            else if(LOGIN._playerID == _building._senderid)
            {
               _loc1_.push(["btn_editmessage",26]);
            }
            else if(_props.type == "taunt")
            {
               _loc1_.push(["btn_viewmessage",30]);
            }
            else
            {
               _loc1_.push(["btn_help",30]);
            }
            if(_props.type == "mushroom")
            {
               _loc1_.push(["btn_pick",30,true]);
            }
            _loc7_ = _mc.tName.y + _mc.tName.height + 5;
            if(!_positionSet)
            {
               _positionSet = true;
               _clickPoint = new Point(MAP._GROUND.mouseX,MAP._GROUND.mouseY);
               _mc.x = int(_clickPoint.x) - 60;
               _mc.y = int(_clickPoint.y) - _loc7_ - 15;
            }
            if(_building == INFERNOPORTAL.building && INFERNOPORTAL.isAboveMaxLevel())
            {
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  _loc1_ = [[INFERNOPORTAL.EXIT_BUTTON,30,true]];
               }
               else if(MAPROOM_DESCENT.DescentPassed)
               {
                  _loc1_ = [[INFERNOPORTAL.ENTER_BUTTON,30,true],[INFERNOPORTAL.ASCENSION_BUTTON,30,false]];
               }
               else
               {
                  _loc1_ = [[INFERNOPORTAL.ENTER_BUTTON,30,true]];
               }
            }
            if(_buttonsMC)
            {
               _mc.removeChild(_buttonsMC);
            }
            _buttonsMC = _mc.addChild(new MovieClip()) as MovieClip;
            _loc8_ = 0;
            while(_loc8_ < _loc1_.length)
            {
               _loc14_ = new Button_CLIP();
               _buttonsMC.addChild(_loc14_);
               if(_loc1_[_loc8_][0] == "btn_move")
               {
                  _loc14_.SetupKey(_loc1_[_loc8_][0],false,52,_loc1_[_loc8_][1]);
                  _loc14_.x = 6;
                  _loc14_.y = _loc7_;
                  _loc7_ += _loc14_.height + 2;
               }
               else if(_loc1_[_loc8_][0] == "btn_more")
               {
                  _loc14_.SetupKey(_loc1_[_loc8_][0],false,55,_loc1_[_loc8_][1]);
                  _loc14_.x = 60;
                  _loc14_.y = _loc7_;
               }
               else if(_loc1_[_loc8_][0] == "btn_bank")
               {
                  _loc14_.labelKey = "btn_bank";
                  _loc14_.Setup(KEYS.Get("btn_bank",{"v1":_loc1_[_loc8_][3]}),false,110,_loc1_[_loc8_][1]);
                  _loc14_.x = 6;
                  _loc14_.y = _loc7_;
                  _loc7_ += _loc14_.height + 2;
               }
               else if(_loc1_[_loc8_][0] == "btn_bankall")
               {
                  _loc14_.labelKey = "btn_bankall";
                  _loc14_.SetupKey(_loc1_[_loc8_][0],false,110,_loc1_[_loc8_][1]);
                  _loc14_.x = 6;
                  _loc14_.y = _loc7_;
                  _loc7_ += _loc14_.height + 2;
               }
               else
               {
                  _loc14_.SetupKey(_loc1_[_loc8_][0],false,110,_loc1_[_loc8_][1]);
                  _loc14_.x = 6;
                  _loc14_.y = _loc7_;
                  _loc7_ += _loc14_.height + 2;
               }
               _loc15_ = _loc1_[_loc8_][0] == "btn_bank" ? 4 : 3;
               if(_loc1_[_loc8_][2])
               {
                  _loc14_.Highlight = true;
               }
               if(_loc1_[_loc8_][_loc15_])
               {
                  _loc14_.Enabled = false;
               }
               _loc14_.addEventListener(MouseEvent.MOUSE_DOWN,Special);
               _loc8_++;
            }
            _loc7_ += 5;
            _loc9_ = "";
            if(_building.health < _building.maxHealth)
            {
               _loc10_ = 0;
               if(_building._lvl.Get() == 0)
               {
                  _loc10_ = int(_building._buildingProps.repairTime[0]);
               }
               else
               {
                  _loc10_ = int(_building._buildingProps.repairTime[_building._lvl.Get() - 1]);
               }
               _loc10_ = Math.min(3600,_loc10_);
               _loc10_ = Math.ceil(_building.maxHealth / _loc10_);
               if(_building._repairing)
               {
                  _loc9_ = KEYS.Get("ui_repairing",{"v1":GLOBAL.ToTime(int((_building.maxHealth - _building.health) / _loc10_),true,true)});
               }
            }
            else if(_building._countdownBuild.Get() > 0)
            {
               _loc9_ = KEYS.Get("ui_building",{"v1":GLOBAL.ToTime(_building._countdownBuild.Get(),true,true)});
            }
            else if(_building._countdownUpgrade.Get() > 0)
            {
               _loc9_ = KEYS.Get("ui_upgrading",{"v1":GLOBAL.ToTime(_building._countdownUpgrade.Get(),true,true)});
            }
            else if(_building._countdownFortify.Get() > 0)
            {
               _loc9_ = KEYS.Get("ui_fortifying",{"v1":GLOBAL.ToTime(_building._countdownFortify.Get(),true,true)});
            }
            else if(_building._class == "resource")
            {
               if(BASE.isOutpost)
               {
                  _loc9_ = KEYS.Get("harvester_autobank_msg");
               }
               else if(_building._producing)
               {
                  _loc16_ = _building._buildingProps.capacity[_building._lvl.Get() - 1] - _building._stored.Get();
                  _loc17_ = 60 / _building._buildingProps.cycleTime[_building._lvl.Get() - 1] * _building._buildingProps.produce[_building._lvl.Get() - 1];
                  if(BASE.isOutpost)
                  {
                     _loc17_ = BRESOURCE.AdjustProduction(GLOBAL._currentCell,_loc17_);
                  }
                  if(GLOBAL._harvesterOverdrive >= GLOBAL.Timestamp() && GLOBAL._harvesterOverdrivePower.Get() > 0)
                  {
                     _loc17_ *= GLOBAL._harvesterOverdrivePower.Get();
                  }
                  _loc18_ = _loc16_ / _loc17_ * 60;
                  _loc19_ = 100 / _building._buildingProps.capacity[_building._lvl.Get() - 1] * _building._stored.Get();
                  _loc9_ = KEYS.Get("ui_producing",{
                     "v1":KEYS.Get(GLOBAL._resourceNames[_building._type - 1]),
                     "v2":GLOBAL.ToTime(_loc18_,true,true),
                     "v3":_loc19_
                  });
               }
               else
               {
                  _loc9_ = KEYS.Get("ui_buildingfull");
               }
            }
            if(_loc9_ != "")
            {
               if((_loc11_ = MAP._GROUND.x + _mc.x) < 500)
               {
                  _mc.gotoAndStop(2);
                  _loc20_ = _mc.tInfoRight;
               }
               else
               {
                  _mc.gotoAndStop(3);
                  _loc20_ = _mc.tInfoLeft;
               }
               _loc20_.autoSize = TextFieldAutoSize.CENTER;
               _loc20_.htmlText = _loc9_;
               if(_loc20_.height + 10 > _loc7_)
               {
                  _loc7_ = _loc20_.height + 10;
               }
               if(_loc20_.height < _loc7_)
               {
                  _loc20_.y = (_loc7_ - _loc20_.height) * 0.5;
               }
            }
            _mc.mcBG.height = _loc7_;
         }
      }
      
      public static function Tick(param1:Event) : void
      {
         if(_mc.mouseX > 150 || _mc.mouseX < -30 || _mc.mouseY > _mc.mcBG.height + 20 || _mc.mouseY < -50)
         {
            Hide();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_mc)
         {
            _mc.removeEventListener(Event.ENTER_FRAME,Tick);
            if(MAP._BUILDINGINFO)
            {
               MAP._BUILDINGINFO.removeChild(_mc);
            }
            _mc = null;
            _buttonsMC = null;
            if(!STORE._open && !HATCHERY._open && !HATCHERYCC._open && !CREATURELOCKER._open && !ACADEMY._open && !MONSTERBUNKER._open && !STORE._streamline)
            {
               BASE.BuildingDeselect();
            }
         }
      }
      
      public static function Special(param1:MouseEvent) : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         var _loc4_:MONSTERLAB = null;
         var _loc5_:Boolean = false;
         if(param1.target.labelKey == "btn_bank")
         {
            _building.Bank();
            SALESPECIALSPOPUP.Check();
         }
         if(param1.target.labelKey == "btn_bankall")
         {
            _loc2_ = InstanceManager.getInstancesByClass(BRESOURCE);
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_._class === "resource" && _loc3_._countdownUpgrade.Get() === 0 && _loc3_._countdownBuild.Get() === 0 && _loc3_._countdownFortify.Get() === 0 && _loc3_.health === _loc3_.maxHealth)
               {
                  _loc3_.Bank();
               }
            }
            SALESPECIALSPOPUP.Check();
         }
         if(param1.target.labelKey == "btn_openlocker" || param1.target.labelKey == "btn_openstrongbox")
         {
            CREATURELOCKER.Show();
         }
         if(param1.target.labelKey == "btn_viewmap")
         {
            GLOBAL.ShowMap();
         }
         if(param1.target.labelKey == "btn_openlab")
         {
            (_loc4_ = GLOBAL._bLab as MONSTERLAB).Show();
         }
         if(param1.target.labelKey == "btn_joinnwm")
         {
            MapRoom3ConfirmMigrationPopup.instance.Show();
         }
         if(param1.target.labelKey == "btn_viewhatchery" || param1.target.labelKey == "btn_viewincubator")
         {
            HATCHERY.Show(_building as BUILDING13);
         }
         if(param1.target.labelKey == "btn_viewhousing" || param1.target.labelKey == "btn_viewcompound" || param1.target.labelKey == "btn_juicemonsters")
         {
            HOUSING.Show();
         }
         if(param1.target.labelKey == "btn_juiceguardian")
         {
            CHAMPIONCAGE.ShowJuice();
         }
         if(param1.target.labelKey == "btn_openstore")
         {
            STORE.ShowB(1,0);
         }
         if(param1.target.labelKey == "btn_yardplanner")
         {
            PLANNER.Show();
         }
         if(param1.target.labelKey == "btn_openbunker")
         {
            MONSTERBUNKER.Show();
         }
         if(param1.target.labelKey == "btn_stopbuild")
         {
            _building.Recycle();
         }
         if(param1.target.labelKey == "btn_stopupgrade")
         {
            _building.UpgradeCancel();
         }
         if(param1.target.labelKey == "btn_stopfortify")
         {
            _building.FortifyCancel();
         }
         if(param1.target.labelKey == "btn_openhcc")
         {
            HATCHERYCC.Show();
         }
         if(param1.target.labelKey == "btn_openbaiter")
         {
            MONSTERBAITER.Show();
         }
         if(param1.target.labelKey == "btn_openacademy")
         {
            ACADEMY.Show(_building);
         }
         if(param1.target.labelKey == "btn_repair")
         {
            _building.Repair();
         }
         if(param1.target.labelKey == "btn_repairall")
         {
            STORE.ShowB(3,1,["FIX"],true);
         }
         if(param1.target.labelKey == "btn_help")
         {
            _building.Help();
         }
         if(param1.target.labelKey == "btn_openradio")
         {
            RADIO.Show();
         }
         if(param1.target.labelKey == "btn_opencage")
         {
            CHAMPIONCAGE.Show();
         }
         if(param1.target.labelKey == "btn_openchamber")
         {
            CHAMPIONCHAMBER.Show();
         }
         if(param1.target.labelKey == INFERNOPORTAL.ENTER_BUTTON || param1.target.labelKey == INFERNOPORTAL.EXIT_BUTTON)
         {
            INFERNOPORTAL.EnterPortal();
         }
         if(param1.target.labelKey == INFERNOPORTAL.ASCENSION_BUTTON)
         {
            INFERNOPORTAL.AscendMonsters();
         }
         if(param1.target.labelKey == SiegeFactory.SIEGE_BUTTON)
         {
            SiegeFactory.Show();
         }
         if(param1.target.labelKey == SiegeLab.SIEGE_BUTTON)
         {
            SiegeLab.Show();
         }
         if(param1.target.labelKey == MapRoom3RelocatePopup.k_RELOCATE_BUTTONINFO)
         {
            MapRoom3RelocatePopup.instance.Show();
         }
         if(param1.target.labelKey == "btn_move")
         {
            _building.StartMove();
         }
         if(param1.target.labelKey == "btn_upgrade")
         {
            if(_building._type == 14 && _building._lvl.Get() && _building._lvl.Get() < _building._buildingProps.costs.length)
            {
               if(!(_loc5_ = BUY.FBCNcpCheckEligibility()))
               {
                  BUILDINGOPTIONS.Show(_building,"upgrade");
               }
            }
            else
            {
               BUILDINGOPTIONS.Show(_building,"upgrade");
            }
         }
         if(param1.target.labelKey == "btn_fortify")
         {
            BUILDINGOPTIONS.Show(_building,"fortify");
         }
         if(param1.target.labelKey == "btn_upgradeall")
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               STORE.ShowB(1,0,["BLK2I","BLK3I"]);
            }
            else
            {
               STORE.ShowB(1,0,["BLK2","BLK3","BLK4","BLK5"]);
            }
         }
         if(param1.target.labelKey == "btn_more")
         {
            BUILDINGOPTIONS.Show(_building,"more");
         }
         if(param1.target.labelKey == "btn_pick")
         {
            MUSHROOMS.PickWorker(_building);
         }
         if(param1.target.labelKey == "btn_speedup")
         {
            Update();
            if(Boolean(_building._repairing) || _building._countdownBuild.Get() + _building._countdownUpgrade.Get() + _building._countdownFortify.Get() > 0)
            {
               STORE.SpeedUp("SP4");
            }
            else if(_props.id == 8)
            {
               STORE.SpeedUp("SP4");
            }
            else if(_props.id == 13 || _props.id == 16)
            {
               if(!BASE.isInfernoMainYardOrOutpost)
               {
                  STORE.ShowB(3,1,["HOD","HOD2","HOD3"]);
               }
               else
               {
                  STORE.ShowB(3,1,["HODI","HOD2I","HOD3I"]);
               }
            }
            else if(_props.id == 26)
            {
               STORE.SpeedUp("SP4");
            }
            else if(_props.type == "resource")
            {
               STORE.ShowB(3,1,["POD"]);
            }
         }
         if(param1.target.labelKey == "btn_viewmessage")
         {
            SIGNS.ShowMessage(_building);
         }
         if(param1.target.labelKey == "btn_editmessage")
         {
            SIGNS.EditForBuilding(_building);
         }
         Hide();
      }
   }
}

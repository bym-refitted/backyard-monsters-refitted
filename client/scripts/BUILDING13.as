package
{
   import com.cc.utils.SecNum;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BUILDING13 extends HatcheryBase
   {
       
      
      public var _frameNumber:int;
      
      public var _timeStamp:int;
      
      public function BUILDING13()
      {
         super();
         this._frameNumber = 0;
         _type = 13;
         _inProduction = "";
         _productionStage.Set(0);
         _spoutPoint = new Point(-28,-58);
         _spoutHeight = 97;
         _taken = new SecNum(0);
         if(BASE.isInfernoMainYardOrOutpost)
         {
            _animRandomStart = false;
         }
         SetProps();
      }
      
      override public function PlaceB() : void
      {
         super.PlaceB();
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         if(GLOBAL._render && _animLoaded && _countdownBuild.Get() + _countdownUpgrade.Get() == 0 && _inProduction != "" && _productionStage.Get() == 1 && _canFunction)
         {
            if(GLOBAL._render && _animLoaded && _countdownBuild.Get() + _countdownUpgrade.Get() == 0 && _canFunction)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && this._frameNumber % 2 == 0 && CREEPS._creepCount == 0)
               {
                  this.AnimFrame();
               }
               else if(this._frameNumber % 7 == 0)
               {
                  this.AnimFrame();
               }
            }
         }
         else if(_animTick != 0)
         {
            _animTick = 0;
            super.AnimFrame(false);
         }
         ++this._frameNumber;
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         super.AnimFrame(param1);
         if(GLOBAL._hatcheryOverdrivePower.Get() == 10)
         {
            _animTick += 4;
         }
         else if(GLOBAL._hatcheryOverdrivePower.Get() == 6)
         {
            _animTick += 2;
         }
         else if(GLOBAL._hatcheryOverdrivePower.Get() == 4)
         {
            ++_animTick;
         }
         if(_animTick >= 30)
         {
            _animTick -= 30;
         }
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Vector.<SecNum> = new Vector.<SecNum>(2);
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = new SecNum(0);
            _loc3_++;
         }
         if(_inProduction != "")
         {
            if(BASE.isInfernoCreep(_inProduction))
            {
               _loc2_[1].Add(CREATURES.GetProperty(_inProduction,"cResource").Get());
            }
            else
            {
               _loc2_[0].Add(CREATURES.GetProperty(_inProduction,"cResource").Get());
            }
            _inProduction = "";
         }
         if(_monsterQueue.length > 0)
         {
            _loc5_ = int(_monsterQueue.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(BASE.isInfernoCreep(_monsterQueue[_loc3_][0]))
               {
                  _loc2_[1].Add(CREATURES.GetProperty(_monsterQueue[_loc3_][0],"cResource").Get() * _monsterQueue[_loc3_][1]);
               }
               else
               {
                  _loc2_[0].Add(CREATURES.GetProperty(_monsterQueue[_loc3_][0],"cResource").Get() * _monsterQueue[_loc3_][1]);
               }
               _loc3_++;
            }
            _monsterQueue = [];
         }
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            BASE.Fund(4,Math.ceil(_loc2_[_loc3_].Get() * 0.75),false,null,Boolean(_loc3_));
            _loc4_ = 0;
            if(_loc2_[_loc3_].Get() > 20000)
            {
               _loc4_ = 12;
            }
            else if(_loc2_[_loc3_].Get() > 10000)
            {
               _loc4_ = 9;
            }
            else if(_loc2_[_loc3_].Get() > 5000)
            {
               _loc4_ = 7;
            }
            else if(_loc2_[_loc3_].Get() > 1000)
            {
               _loc4_ = 5;
            }
            else if(_loc2_[_loc3_].Get() > 400)
            {
               _loc4_ = 4;
            }
            else if(_loc2_[_loc3_].Get() > 200)
            {
               _loc4_ = 3;
            }
            else if(_loc2_[_loc3_].Get() > 100)
            {
               _loc4_ = 2;
            }
            else if(_loc2_[_loc3_].Get() > 0)
            {
               _loc4_ = 1;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               ResourcePackages.Spawn(this,GLOBAL.townHall,BASE.isInfernoMainYardOrOutpost || Boolean(_loc3_) ? 8 : 4,_loc6_);
               _loc6_++;
            }
            _loc3_++;
         }
         super.Destroyed(param1);
      }
      
      override public function Description() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Description();
         if(GLOBAL._hatcheryOverdrive > 0)
         {
            _buildingTitle += " <font color=\"#CC0000\">" + KEYS.Get("building_hatcheryoverdrive_title",{
               "v1":GLOBAL._hatcheryOverdrivePower.Get(),
               "v2":GLOBAL.ToTime(GLOBAL._hatcheryOverdrive)
            }) + "</font>";
         }
         if(_inProduction == "")
         {
            _specialDescription = "<font color=\"#CC0000\">" + KEYS.Get("building_hatchery_noprod",{"v1":GLOBAL._buildingProps[12].name}) + "</font>";
         }
         else if(_canFunction)
         {
            if(CREATURES.GetProperty(_inProduction,"cResource").Get() < BASE._resources.r3.Get() && _productionStage.Get() == 3)
            {
               _specialDescription = "<font color=\"#CC0000\">" + KEYS.Get("building_hatchery_res",{"v1":GLOBAL._resourceNames[3]}) + "</font>";
            }
            else if(_productionStage.Get() == 2 && !HOUSING.HousingStore(_inProduction,new Point(_mc.x,_mc.y),true))
            {
               _specialDescription = "<font color=\"#CC0000\">" + KEYS.Get("building_hatchery_housing",{
                  "v1":GLOBAL._buildingProps[14].name,
                  "v2":CREATURELOCKER._creatures[_inProduction].name
               }) + "</font>";
            }
            else if(_productionStage.Get() == 1)
            {
               _loc1_ = CREATURES.GetProperty(_inProduction,"cTime").Get();
               _loc2_ = 100 / _loc1_ * _countdownProduce.Get();
               if(_loc2_ < 0)
               {
                  _loc2_ = 0;
               }
               if(GLOBAL._hatcheryOverdrive)
               {
                  _loc1_ = int(_loc1_ / GLOBAL._hatcheryOverdrivePower.Get());
               }
               _specialDescription = "Producing a " + CREATURELOCKER._creatures[_inProduction].name + "<br>";
               if(_productionStage.Get() == 1)
               {
                  _specialDescription += 100 - _loc2_ + "% ";
                  if(_loc2_ < 10)
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage7");
                  }
                  else if(_loc2_ < 20)
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage6");
                  }
                  else if(_loc2_ < 30)
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage5");
                  }
                  else if(_loc2_ < 60)
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage4");
                  }
                  else if(_loc2_ < 70)
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage3",{"v1":GLOBAL._resourceNames[3]});
                  }
                  else if(_loc2_ < 80)
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage2");
                  }
                  else
                  {
                     _specialDescription += KEYS.Get("building_hatchery_stage1",{"v1":GLOBAL._resourceNames[3]});
                  }
               }
            }
         }
         else
         {
            _specialDescription = "<font color=\"#CC0000\">" + KEYS.Get("building_hatchery_damaged") + "</font>";
         }
      }
      
      public function ResetProduction() : void
      {
         if(_taken.Get() > 0)
         {
            BASE.Fund(4,_taken.Get());
         }
         _taken.Set(0);
         _hasResources = false;
         _countdownProduce.Set(0);
         _hpCountdownProduce = 0;
         if(_inProduction == "")
         {
            _productionStage.Set(0);
         }
         else
         {
            _productionStage.Set(3);
         }
      }
      
      override public function StartProduction() : void
      {
         _inProduction = "";
         _productionStage.Set(0);
         _taken.Set(0);
         if(_monsterQueue.length > 0)
         {
            _inProduction = _monsterQueue[0][0];
            if(_inProduction == "C100")
            {
               _inProduction = "C12";
            }
            --_monsterQueue[0][1];
            if(_monsterQueue[0][1] <= 0)
            {
               _monsterQueue.splice(0,1);
            }
            HATCHERY.Tick();
            _productionStage.Set(3);
            this.Tick(1);
         }
      }
      
      override public function get tickLimit() : int
      {
         var _loc1_:int = super.tickLimit;
         if(this._timeStamp > GLOBAL.Timestamp())
         {
            _loc1_ = Math.min(_loc1_,this._timeStamp - GLOBAL.Timestamp());
         }
         else if(_inProduction != "" && _countdownProduce.Get() >= 0 && HOUSING.HousingStore(_inProduction,new Point(_mc.x,_mc.y),true,0))
         {
            _loc1_ = Math.min(_loc1_,_countdownProduce.Get());
         }
         return _loc1_;
      }
      
      override public function Tick(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(_inProduction == "C100")
         {
            _inProduction = "C12";
         }
         super.Tick(param1);
         if(this._timeStamp > GLOBAL.Timestamp())
         {
            return;
         }
         if(_countdownBuild.Get() > 0 || health < maxHealth * 0.5)
         {
            _canFunction = false;
         }
         else
         {
            _canFunction = true;
         }
         if(_canFunction)
         {
            if(!GLOBAL._bHatcheryCC)
            {
               _loc2_ = HOUSING._housingSpace.Get();
               _finishQueue = {};
               _finishAll = true;
               _loc3_ = 0;
               if(_inProduction != "" && _loc2_ >= CREATURES.GetProperty(_inProduction,"cStorage"))
               {
                  _loc2_ -= CREATURES.GetProperty(_inProduction,"cStorage");
                  _finishQueue[_inProduction] = 1;
                  _loc3_ = _countdownProduce.Get();
                  if(_monsterQueue.length > 0)
                  {
                     _loc4_ = int(_monsterQueue.length);
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_)
                     {
                        _loc6_ = String(_monsterQueue[_loc5_][0]);
                        if(_loc2_ >= CREATURES.GetProperty(_loc6_,"cStorage") * _monsterQueue[_loc5_][1])
                        {
                           _loc3_ += CREATURES.GetProperty(_loc6_,"cTime").Get() * _monsterQueue[_loc5_][1];
                           _loc2_ -= CREATURES.GetProperty(_loc6_,"cStorage") * _monsterQueue[_loc5_][1];
                           if(_finishQueue[_loc6_])
                           {
                              _finishQueue[_loc6_] += _monsterQueue[_loc5_][1];
                           }
                           else
                           {
                              _finishQueue[_loc6_] = _monsterQueue[_loc5_][1];
                           }
                        }
                        else if(_loc2_ >= CREATURES.GetProperty(_loc6_,"cStorage"))
                        {
                           _loc3_ += CREATURES.GetProperty(_loc6_,"cTime").Get() * (_loc2_ / CREATURES.GetProperty(_loc6_,"cStorage"));
                           if(_finishQueue[_loc6_])
                           {
                              _finishQueue[_loc6_] += _loc2_ / CREATURES.GetProperty(_loc6_,"cStorage");
                           }
                           else
                           {
                              _finishQueue[_loc6_] = _loc2_ / CREATURES.GetProperty(_loc6_,"cStorage");
                           }
                           _finishAll = false;
                           break;
                        }
                        _loc5_++;
                     }
                  }
                  _finishCost.Set(STORE.GetTimeCost(_loc3_,false) * 4);
               }
               else
               {
                  _finishCost.Set(0);
               }
            }
            if(_countdownBuild.Get() + _countdownUpgrade.Get() == 0 && health > 10)
            {
               if(_inProduction != "" && _productionStage.Get() == 1)
               {
                  if(_countdownProduce.Get() <= 0)
                  {
                     _productionStage.Set(2);
                     this.Tick(1);
                     return;
                  }
                  _hasResources = true;
                  if(GLOBAL._hatcheryOverdrive)
                  {
                     _countdownProduce.Add(-GLOBAL._hatcheryOverdrivePower.Get() * param1);
                  }
                  else
                  {
                     _countdownProduce.Add(-param1);
                  }
               }
               if(_productionStage.Get() == 2 && Boolean(_inProduction))
               {
                  _taken.Set(0);
                  if(HOUSING.HousingStore(_inProduction,new Point(_mc.x,_mc.y),false,_countdownProduce.Get()))
                  {
                     this.StartProduction();
                  }
               }
               if(_productionStage.Get() == 3)
               {
                  _productionStage.Set(4);
                  _hasResources = true;
               }
               if(_productionStage.Get() == 4 && (_hasResources || !GLOBAL._render))
               {
                  _hasResources = true;
                  _countdownProduce.Set(CREATURES.GetProperty(_inProduction,"cTime").Get());
                  _productionStage.Set(1);
                  this.Tick(1);
                  return;
               }
            }
         }
      }
      
      public function FinishNow() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(!_canFunction)
         {
            GLOBAL.Message(KEYS.Get("building_hcc_cantfunction"));
            return;
         }
         if(BASE._credits.Get() >= _finishCost.Get())
         {
            _loc1_ = [];
            _loc2_ = HOUSING._housingSpace.Get();
            if(_inProduction != "" && _loc2_ >= CREATURES.GetProperty(_inProduction,"cStorage"))
            {
               _loc3_ = new Point(_mc.x - 10 + Math.random() * 20,_mc.y - 10 + Math.random() * 20);
               HOUSING.HousingStore(_inProduction,_loc3_);
               _loc2_ -= CREATURES.GetProperty(_inProduction,"cStorage");
               _inProduction = "";
               _productionStage.Set(0);
               if(_monsterQueue.length > 0)
               {
                  while(_monsterQueue.length > 0 && _loc2_ > 0)
                  {
                     _loc5_ = String(_monsterQueue[0][0]);
                     _loc6_ = CREATURES.GetProperty(_loc5_,"cStorage");
                     while(_monsterQueue[0][1] > 0 && _loc2_ >= _loc6_)
                     {
                        if(_loc2_ >= _loc6_)
                        {
                           _loc7_ = int(Math.random() * _loc1_.length);
                           _loc3_ = new Point(_mc.x - 10 + Math.random() * 20,_mc.y - 10 + Math.random() * 20);
                           --_monsterQueue[0][1];
                           _loc2_ -= _loc6_;
                           HOUSING.HousingStore(_loc5_,_loc3_);
                        }
                     }
                     if(_monsterQueue[0][1] <= 0)
                     {
                        _monsterQueue.shift();
                     }
                     else if(_loc2_ < _loc6_)
                     {
                        break;
                     }
                  }
               }
            }
            if(_monsterQueue.length > 0)
            {
               _inProduction = _monsterQueue[0][0];
               if(_inProduction == "C100")
               {
                  _inProduction = "C12";
               }
               --_monsterQueue[0][1];
               if(_monsterQueue[0][1] <= 0)
               {
                  _monsterQueue.splice(0,1);
               }
               _productionStage.Set(3);
            }
            else
            {
               _productionStage.Set(0);
            }
            BASE.Purchase("FQ",_finishCost.Get(),"BUILDING13.FinishNow");
            HATCHERY.Tick();
            this.Tick(1);
         }
         else
         {
            POPUPS.DisplayGetShiny();
         }
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bHatchery = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && TUTORIAL._stage > 200 && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-ha",KEYS.Get("pop_hatbuilt_streamtitle"),KEYS.Get("pop_hatbuilt_body"),"build-hatchery.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_hatbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_hatbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Cancel() : void
      {
         GLOBAL._bHatchery = null;
         super.Cancel();
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bHatchery = null;
         super.RecycleC();
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Upgraded();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !BASE.isInfernoMainYardOrOutpost)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["upgrade-ha-" + _lvl.Get(),KEYS.Get("pop_hatupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_hatupgraded_body",{"v1":_lvl.Get()}),"upgrade-hatchery.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_hatupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_hatupgraded_body",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         var _loc2_:int = 0;
         _monsterQueue = [];
         if(param1.mq)
         {
            _monsterQueue = param1.mq;
         }
         if(param1.saved >= 0)
         {
            this._timeStamp = param1.saved;
         }
         else
         {
            this._timeStamp = 0;
         }
         _loc2_ = int(_monsterQueue.length - 1);
         while(_loc2_ >= 0)
         {
            if(!_monsterQueue[_loc2_][0])
            {
               _monsterQueue.splice(_loc2_);
            }
            else if(_monsterQueue[_loc2_][0] == "C100")
            {
               _monsterQueue[_loc2_][0] = "C12";
            }
            _loc2_--;
         }
         super.Setup(param1);
         if(_countdownBuild.Get() == 0 || TUTORIAL._stage < 200)
         {
            GLOBAL._bHatchery = this;
         }
      }
      
      override public function Export() : Object
      {
         var _loc1_:Object = super.Export();
         if(_monsterQueue.length > 0)
         {
            _loc1_.mq = _monsterQueue;
         }
         return _loc1_;
      }
   }
}

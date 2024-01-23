package
{
   import com.cc.utils.SecNum;
   import com.monsters.managers.InstanceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BUILDING16 extends HatcheryBase
   {
       
      
      public function BUILDING16()
      {
         super();
         _type = 16;
         _spoutPoint = new Point(0,-5);
         _spoutHeight = 55;
         SetProps();
      }
      
      override public function PlaceB() : void
      {
         super.PlaceB();
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
         if(_monsterQueue.length > 0)
         {
            _loc5_ = int(_monsterQueue.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               if(BASE.isInfernoCreep(_monsterQueue[_loc3_][0]))
               {
                  _loc2_[1].Add(CREATURES.GetProperty(_monsterQueue[_loc3_][0],"cResource") * _monsterQueue[_loc3_][1]);
               }
               else
               {
                  _loc2_[0].Add(CREATURES.GetProperty(_monsterQueue[_loc3_][0],"cResource") * _monsterQueue[_loc3_][1]);
               }
               _loc3_++;
            }
            _monsterQueue = [];
         }
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            BASE.Fund(4,Math.ceil(_loc2_[_loc3_].Get() * 0.75),false,this,Boolean(_loc3_));
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
      
      public function ResetProduction() : void
      {
         if(_inProduction == "")
         {
            _productionStage.Set(0);
         }
         else
         {
            _productionStage.Set(3);
            _countdownProduce.Set(0);
            _hpCountdownProduce = 0;
         }
      }
      
      override public function Tick(param1:int) : void
      {
         var _loc4_:Vector.<Object> = null;
         var _loc5_:BUILDING13 = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         super.Tick(param1);
         var _loc2_:int = HOUSING._housingSpace.Get();
         var _loc3_:int = 0;
         _finishQueue = {};
         _finishAll = true;
         if(_countdownBuild.Get() == 0 && health > 10)
         {
            _canFunction = true;
            _loc4_ = InstanceManager.getInstancesByClass(BUILDING13);
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_._canFunction)
               {
                  if(_loc5_._inProduction != "" && _loc2_ >= CREATURES.GetProperty(_loc5_._inProduction,"cStorage"))
                  {
                     _loc2_ -= CREATURES.GetProperty(_loc5_._inProduction,"cStorage");
                     if(_finishQueue[_loc5_._inProduction])
                     {
                        ++_finishQueue[_loc5_._inProduction];
                     }
                     else
                     {
                        _finishQueue[_loc5_._inProduction] = 1;
                     }
                     _loc3_ += _loc5_._countdownProduce.Get();
                  }
                  else if(_monsterQueue.length > 0)
                  {
                     if(_loc5_._canFunction && _loc5_._inProduction == "")
                     {
                        _loc5_._inProduction = _monsterQueue[0][0];
                        --_monsterQueue[0][1];
                        if(_monsterQueue[0][1] <= 0)
                        {
                           _monsterQueue.splice(0,1);
                        }
                        _loc5_._productionStage.Set(3);
                        _loc5_.Tick(1);
                        HATCHERYCC.Tick();
                        if(_monsterQueue.length == 0)
                        {
                           return;
                        }
                     }
                  }
               }
            }
            if(_monsterQueue.length > 0 && _loc2_ >= 10)
            {
               _loc6_ = int(_monsterQueue.length);
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_ = String(_monsterQueue[_loc7_][0]);
                  if(_loc2_ >= CREATURES.GetProperty(_loc8_,"cStorage") * _monsterQueue[_loc7_][1])
                  {
                     _loc3_ += CREATURES.GetProperty(_loc8_,"cTime") * _monsterQueue[_loc7_][1];
                     _loc2_ -= CREATURES.GetProperty(_loc8_,"cStorage") * _monsterQueue[_loc7_][1];
                     if(_finishQueue[_loc8_])
                     {
                        _finishQueue[_loc8_] += _monsterQueue[_loc7_][1];
                     }
                     else
                     {
                        _finishQueue[_loc8_] = _monsterQueue[_loc7_][1];
                     }
                  }
                  else if(_loc2_ >= CREATURES.GetProperty(_loc8_,"cStorage"))
                  {
                     _loc3_ += CREATURES.GetProperty(_loc8_,"cTime") * (_loc2_ / CREATURES.GetProperty(_loc8_,"cStorage"));
                     if(_finishQueue[_loc8_])
                     {
                        _finishQueue[_loc8_] += _loc2_ / CREATURES.GetProperty(_loc8_,"cStorage");
                     }
                     else
                     {
                        _finishQueue[_loc8_] = _loc2_ / CREATURES.GetProperty(_loc8_,"cStorage");
                     }
                     _finishAll = false;
                     break;
                  }
                  _loc7_++;
               }
            }
         }
         else
         {
            _canFunction = false;
         }
         if(_canFunction && _loc3_ > 0)
         {
            _finishCost.Set(STORE.GetTimeCost(_loc3_,false) * 4);
         }
         else
         {
            _finishCost.Set(0);
         }
      }
      
      public function FinishNow() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:BUILDING13 = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!_canFunction)
         {
            GLOBAL.Message(KEYS.Get("building_hcc_cantfunction"));
            return;
         }
         if(BASE._credits.Get() >= _finishCost.Get())
         {
            _loc1_ = [];
            _loc2_ = HOUSING._housingSpace.Get();
            _loc4_ = InstanceManager.getInstancesByClass(BUILDING13);
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_._canFunction)
               {
                  _loc1_.push(_loc5_);
                  if(_loc5_._inProduction != "" && _loc2_ >= CREATURES.GetProperty(_loc5_._inProduction,"cStorage"))
                  {
                     _loc3_ = new Point(_loc5_._mc.x - 10 + Math.random() * 20,_loc5_._mc.y - 10 + Math.random() * 20);
                     HOUSING.HousingStore(_loc5_._inProduction,_loc3_);
                     _loc2_ -= CREATURES.GetProperty(_loc5_._inProduction,"cStorage");
                     _loc5_._inProduction = "";
                     _loc5_._productionStage.Set(0);
                  }
               }
            }
            if(_monsterQueue.length > 0)
            {
               while(_monsterQueue.length > 0 && _loc2_ > 0)
               {
                  _loc7_ = String(_monsterQueue[0][0]);
                  _loc8_ = CREATURES.GetProperty(_loc7_,"cStorage");
                  while(_monsterQueue[0][1] > 0 && _loc2_ >= _loc8_)
                  {
                     if(_loc2_ >= _loc8_)
                     {
                        _loc9_ = int(Math.random() * _loc1_.length);
                        _loc3_ = new Point(_loc1_[_loc9_]._mc.x - 10 + Math.random() * 20,_loc1_[_loc9_]._mc.y - 10 + Math.random() * 20);
                        --_monsterQueue[0][1];
                        _loc2_ -= _loc8_;
                        HOUSING.HousingStore(_loc7_,_loc3_);
                     }
                  }
                  if(_monsterQueue[0][1] <= 0)
                  {
                     _monsterQueue.shift();
                  }
                  else if(_loc2_ < _loc8_)
                  {
                     break;
                  }
               }
            }
            BASE.Purchase("FQ",_finishCost.Get(),"BUILDING16.FinishNow");
         }
         else
         {
            POPUPS.DisplayGetShiny();
         }
      }
      
      override public function Constructed() : void
      {
         var hatcheryInstances:Vector.<Object>;
         var Brag:Function;
         var building:BUILDING13 = null;
         var i:int = 0;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bHatcheryCC = this;
         hatcheryInstances = InstanceManager.getInstancesByClass(BUILDING13);
         for each(building in hatcheryInstances)
         {
            i = 0;
            while(i < building._monsterQueue.length)
            {
               BASE.Fund(4,building._monsterQueue[i][1] * CREATURES.GetProperty(building._monsterQueue[i][0],"cResource"));
               i++;
            }
            building._monsterQueue = [];
         }
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-hcc",KEYS.Get("pop_hccbuilt_streamtitle"),KEYS.Get("pop_hccbuilt_streambody"),"build-hatcherycontrolcenter.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_hccbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_hccbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bHatcheryCC = null;
         super.RecycleC();
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
      }
      
      override public function Setup(param1:Object) : void
      {
         _monsterQueue = [];
         if(param1.mq)
         {
            _monsterQueue = param1.mq;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _monsterQueue.length)
         {
            if(_monsterQueue[_loc2_][0] == "C100")
            {
               _monsterQueue[_loc2_][0] = "C12";
            }
            _loc2_++;
         }
         super.Setup(param1);
         if(_countdownBuild.Get() == 0)
         {
            GLOBAL._bHatcheryCC = this;
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

package
{
   import com.cc.utils.SecNum;
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MONSTERBUNKERPOPUP extends MONSTERBUNKERPOPUP_CLIP
   {
       
      
      public var _juiceList:Object;
      
      private var _bunker:* = null;
      
      private var _capacity:int = 0;
      
      private var _mode:String;
      
      private var _selected:Object;
      
      private var _scrollerA:ScrollSet;
      
      private var _scrollerB:ScrollSet;
      
      private const BUYABLE_MONSTERS:Object = {
         "C2":2,
         "IC1":3,
         "C6":5,
         "C5":16,
         "C7":8,
         "C8":12,
         "C10":14,
         "C11":24,
         "C13":24,
         "C12":65,
         "C17":17,
         "IC2":4,
         "IC5":32,
         "IC7":32,
         "IC8":55
      };
      
      private const BUNKERABLE_MONSTERS:Object = {
         "IC1":1,
         "IC2":1,
         "IC3":1,
         "IC4":1,
         "IC5":1,
         "IC6":1,
         "IC7":1,
         "IC8":1,
         "C1":1,
         "C2":1,
         "C3":1,
         "C4":1,
         "C5":1,
         "C6":1,
         "C7":1,
         "C8":1,
         "C9":1,
         "C10":1,
         "C11":1,
         "C12":1,
         "C13":1,
         "C17":1
      };
      
      private var _guidePage:int = 0;
      
      public function MONSTERBUNKERPOPUP()
      {
         var _loc1_:MovieClip = null;
         this._juiceList = {};
         super();
         this._bunker = GLOBAL._selectedBuilding;
         this._capacity = GLOBAL._buildingProps[21].capacity[this._bunker._lvl.Get() - 1];
         this._selected = {};
         this._juiceList = {};
         transferCanvasA.mask = transferCanvasAmask;
         transferCanvasB.mask = transferCanvasBmask;
         this._scrollerA = new ScrollSet();
         this._scrollerA.AutoHideEnabled = false;
         this._scrollerA.width = scrollerA.width;
         this._scrollerA.x = scrollerA.x;
         this._scrollerA.y = scrollerA.y;
         addChild(this._scrollerA);
         this._scrollerA.Init(transferCanvasA,transferCanvasAmask,0,scrollerA.y,scrollerA.height);
         this._scrollerB = new ScrollSet();
         this._scrollerB.AutoHideEnabled = false;
         this._scrollerB.width = scrollerB.width;
         this._scrollerB.x = scrollerB.x;
         this._scrollerB.y = scrollerB.y;
         addChild(this._scrollerB);
         this._scrollerB.Init(transferCanvasB,transferCanvasBmask,0,scrollerB.y,scrollerB.height);
         title_txt.htmlText = KEYS.Get("bunker_title");
         tCapacity.htmlText = "<b>" + KEYS.Get("bunker_capacity") + "</b>";
         bHousing.addEventListener(MouseEvent.CLICK,this.Switch("housing"));
         bHousing.SetupKey("bunker_btn_housing");
         bHousing.buttonMode = true;
         bSpecial.addEventListener(MouseEvent.CLICK,this.Switch("special"));
         bSpecial.SetupKey("bunker_btn_store");
         bSpecial.buttonMode = true;
         bTransfer.addEventListener(MouseEvent.CLICK,this.Transfer);
         bTransfer.Setup(">>");
         bTransfer.buttonMode = true;
         this.SwitchB("housing");
      }
      
      public function InitTransferBarAListeners(param1:MovieClip) : void
      {
         param1.bAdd.addEventListener(MouseEvent.CLICK,this.SelectAdd);
         param1.bAdd.Setup("+");
         param1.bAdd.buttonMode = true;
         param1.bRemove.addEventListener(MouseEvent.CLICK,this.SelectRemove);
         param1.bRemove.Setup("-");
         param1.bRemove.buttonMode = true;
      }
      
      public function InitTransferBarBListeners(param1:MovieClip) : void
      {
         param1.bRemove.addEventListener(MouseEvent.CLICK,this.BunkerJuiceID);
         var _loc2_:* = param1.id.substring(0,2) == "IC";
         if(Boolean(GLOBAL._bJuicer) && !_loc2_)
         {
            param1.bRemove.SetupKey("bunker_btn_juice");
         }
         else
         {
            param1.bRemove.SetupKey("bunker_btn_remove");
         }
         param1.bRemove.buttonMode = true;
      }
      
      public function RemoveTransferBarListeners(param1:MovieClip) : void
      {
         if(param1 is MonsterBunkerPopup_TransferBtnA_CLIP)
         {
            param1.bAdd.removeEventListener(MouseEvent.CLICK,this.SelectAdd);
            param1.bRemove.removeEventListener(MouseEvent.CLICK,this.SelectRemove);
         }
         else if(param1 is MonsterBunkerPopup_TransferBtnB_CLIP)
         {
            param1.bRemove.removeEventListener(MouseEvent.CLICK,this.BunkerJuiceID);
         }
      }
      
      public function RemoveTransferBarBListeners(param1:MovieClip) : void
      {
         param1.bAdd.removeEventListener(MouseEvent.CLICK,this.SelectAdd);
         param1.bRemove.removeEventListener(MouseEvent.CLICK,this.SelectRemove);
      }
      
      public function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
         param3[0].mcLoading.visible = false;
      }
      
      private function Switch(param1:String) : Function
      {
         var mode:String = param1;
         return function(param1:MouseEvent):void
         {
            SwitchB(mode);
            UpdateScrollers(true);
         };
      }
      
      private function SwitchB(param1:String) : void
      {
         SOUNDS.Play("click1");
         this._mode = param1;
         this._selected = {};
         if(this._mode == "housing")
         {
            bHousing.Enabled = false;
            bSpecial.Enabled = true;
         }
         else
         {
            bHousing.Enabled = true;
            bSpecial.Enabled = false;
         }
         this.Update();
      }
      
      private function CanBunkerFromHousingNormal(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 <= 13 && param1 > 0)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function CanBunkerFromHousingInferno(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 <= 8 && param1 > 0)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function CanBunkerFromHousing(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.BUNKERABLE_MONSTERS[param1])
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function CanBunkerFromStoreNormal(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.BUYABLE_MONSTERS[param1] > 0)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function CanBunkerFromStoreInferno(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         if(param1 <= 8 && param1 > 0)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function ClearTransferCanvas(param1:MovieClip = null) : void
      {
         var _loc2_:Array = [];
         switch(param1)
         {
            case transferCanvasA:
               _loc2_.push(transferCanvasA);
               break;
            case transferCanvasB:
               _loc2_.push(transferCanvasB);
               break;
            default:
               _loc2_.push(transferCanvasA);
               _loc2_.push(transferCanvasB);
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            while(_loc2_[_loc3_].numChildren)
            {
               if(_loc2_[_loc3_].getChildAt(0) is MovieClip)
               {
                  this.RemoveTransferBarListeners(_loc2_[_loc3_].getChildAt(0));
               }
               _loc2_[_loc3_].removeChildAt(0);
            }
            _loc3_++;
         }
      }
      
      public function Update() : void
      {
         var monsterID:String = null;
         var c:String = null;
         var goo:int = 0;
         var creatureProps:Object = null;
         var i:int = 0;
         var n:int = 0;
         var v:int = 0;
         var barMC:MovieClip = null;
         var p:int = 0;
         var housedMonsters:Array = null;
         var transferBtnA:MonsterBunkerPopup_TransferBtnA_CLIP = null;
         var name:String = null;
         var availableMonsters:Array = null;
         var quantity:int = 0;
         var transferBtnB:MonsterBunkerPopup_TransferBtnB_CLIP = null;
         var count:int = 0;
         var usedA:int = 0;
         var usedB:int = 0;
         var currX:Number = 0;
         var currY:Number = 0;
         var offsetX:Number = 0;
         var offsetY:Number = 0;
         var spacingX:Number = 0;
         var spacingY:Number = 0;
         try
         {
            this.ClearTransferCanvas(transferCanvasA);
            if(this._mode == "housing")
            {
               n = 1;
               housedMonsters = HOUSING.GetHousingCreatures();
               i = 0;
               while(i < housedMonsters.length)
               {
                  monsterID = String(housedMonsters[i].id);
                  if(this.CanBunkerFromHousing(monsterID))
                  {
                     transferBtnA = new MonsterBunkerPopup_TransferBtnA_CLIP();
                     ImageCache.GetImageWithCallBack("monsters/" + monsterID + "-medium.jpg",this.IconLoaded,true,1,"",[transferBtnA.mcIcon]);
                     name = String(CREATURELOCKER._creatures[monsterID].name);
                     if(monsterID == "IC8")
                     {
                        name = "#m_k_wormzer#";
                     }
                     transferBtnA.tName.htmlText = "<b>" + KEYS.Get(name) + "</b>";
                     transferBtnA.id = monsterID;
                     transferBtnA._id = monsterID.substring(monsterID.indexOf("C") + 1);
                     transferBtnA.index = monsterID.substring(monsterID.indexOf("C") + 1);
                     v = GLOBAL.player.monsterListByID(monsterID).numCreeps;
                     if(this._selected[monsterID])
                     {
                        v -= this._selected[monsterID].Get();
                     }
                     if(v == 0)
                     {
                        transferBtnA.tHoused.htmlText = "<font color=\"#FF0000\">" + KEYS.Get("bunker_housed",{"v1":0}) + "</font>";
                     }
                     else
                     {
                        transferBtnA.tHoused.htmlText = "<font color=\"#000000\">" + KEYS.Get("bunker_housed",{"v1":v}) + "</font>";
                     }
                     if(Boolean(this._selected[monsterID]) && this._selected[monsterID].Get() > 0)
                     {
                        transferBtnA.tSelected.htmlText = "<font color=\"#FF0000\">" + KEYS.Get("bunker_selected",{"v1":this._selected[monsterID].Get()}) + "</font>";
                     }
                     else
                     {
                        transferBtnA.tSelected.htmlText = "<font color=\"#CCCCCC\">" + KEYS.Get("bunker_selected",{"v1":0}) + "</font>";
                     }
                     transferBtnA.x = 0 * transferBtnA.width;
                     transferBtnA.y = -(1 * transferBtnA.height) + n * transferBtnA.height + n * spacingY;
                     this.InitTransferBarAListeners(transferBtnA);
                     transferCanvasA.addChild(transferBtnA);
                     n += 1;
                  }
                  if(n == 1)
                  {
                     tNoMonsters.htmlText = KEYS.Get("bunker_empty");
                  }
                  else
                  {
                     tNoMonsters.htmlText = "";
                  }
                  i++;
               }
            }
            else
            {
               n = 1;
               availableMonsters = this.GetBunkerCreatures();
               i = 0;
               while(i < availableMonsters.length)
               {
                  monsterID = String(availableMonsters[i].id);
                  if(this.CanBunkerFromStoreNormal(monsterID))
                  {
                     transferBtnA = new MonsterBunkerPopup_TransferBtnA_CLIP();
                     ImageCache.GetImageWithCallBack("monsters/" + monsterID + "-medium.jpg",this.IconLoaded,true,1,"",[transferBtnA.mcIcon]);
                     name = String(CREATURELOCKER._creatures[monsterID].name);
                     if(monsterID == "IC8")
                     {
                        name = "#m_k_wormzer#";
                     }
                     transferBtnA.tName.htmlText = "<b>" + KEYS.Get(name) + "</b>";
                     transferBtnA.id = monsterID;
                     transferBtnA._id = monsterID.substring(monsterID.indexOf("C") + 1);
                     transferBtnA.index = monsterID.substring(monsterID.indexOf("C") + 1);
                     if(GLOBAL.player.monsterListByID(monsterID))
                     {
                        v = GLOBAL.player.monsterListByID(monsterID).numCreeps;
                     }
                     if(Boolean(CREATURELOCKER._lockerData[monsterID]) && CREATURELOCKER._lockerData[monsterID].t == 2)
                     {
                        transferBtnA.tHoused.htmlText = "<font color=\"#0000CC\">" + this.GetCost(monsterID,1) + " " + KEYS.Get(GLOBAL._resourceNames[4]) + "</font>";
                        if(Boolean(this._selected[monsterID]) && this._selected[monsterID].Get() > 0)
                        {
                           transferBtnA.tSelected.htmlText = "<font color=\"#FF0000\">" + KEYS.Get("bunker_selected",{"v1":this._selected[monsterID].Get()}) + "</font>";
                        }
                        else
                        {
                           transferBtnA.tSelected.htmlText = "<font color=\"#CCCCCC\">" + KEYS.Get("bunker_selected",{"v1":0}) + "</font>";
                        }
                     }
                     else
                     {
                        transferBtnA.tHoused.htmlText = "<font color=\"#0000CC\">" + this.GetCost(monsterID,1) + " " + KEYS.Get(GLOBAL._resourceNames[4]) + "</font>";
                        transferBtnA.tSelected.htmlText = "<font color=\"#CC0000\">" + KEYS.Get("bunker_store_locked") + "</font>";
                     }
                     transferBtnA.x = 0 * transferBtnA.width;
                     transferBtnA.y = -(1 * transferBtnA.height) + n * transferBtnA.height + n * spacingY;
                     this.InitTransferBarAListeners(transferBtnA);
                     transferCanvasA.addChild(transferBtnA);
                     n += 1;
                  }
                  if(n == 1)
                  {
                     tNoMonsters.htmlText = KEYS.Get("bunker_empty");
                  }
                  else
                  {
                     tNoMonsters.htmlText = "";
                  }
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            GLOBAL.ErrorMessage("MONSTERBUNKERPOPUP.Update TransferA" + e.message + " | " + e.getStackTrace());
            LOGGER.Log("err","MONSTERBUNKERPOPUP.Update TransferA" + e.message + " | " + e.getStackTrace());
         }
         n = 0;
         for(c in this._selected)
         {
            n += this._selected[c].Get();
         }
         if(n > 0)
         {
            bTransfer.Highlight = true;
            bTransfer.Enabled = true;
         }
         else
         {
            bTransfer.Highlight = false;
            bTransfer.Enabled = false;
         }
         for(c in this._bunker._monsters)
         {
            usedA += CREATURES.GetProperty(c,"cStorage",0,true) * this._bunker._monsters[c];
         }
         this._bunker._used = usedA;
         for(c in this._selected)
         {
            usedB += CREATURES.GetProperty(c,"cStorage",0,true) * this._selected[c].Get();
         }
         p = 100 / this._capacity * (usedA + usedB);
         mcStorage.mcBar.width = 535 / this._capacity * usedA;
         mcStorage.mcBarB.width = 535 / this._capacity * (usedA + usedB);
         if(usedA + usedB >= this._capacity)
         {
            if(this._bunker._lvl.Get() < 3)
            {
               tStored.htmlText = KEYS.Get("bunker_full_2");
            }
            else
            {
               tStored.htmlText = "<b>" + KEYS.Get("bunker_full") + "</b>";
            }
         }
         else
         {
            tStored.htmlText = "<b>" + GLOBAL.FormatNumber(usedA + usedB) + " / " + GLOBAL.FormatNumber(this._capacity) + " (" + p + "%)</b>";
         }
         usedA = 0;
         for(c in this._selected)
         {
            usedA += this.GetCost(c,this._selected[c].Get());
         }
         if(this._mode == "housing")
         {
            if(usedA > 0)
            {
               tCost.htmlText = "<b>" + GLOBAL.FormatNumber(usedA) + "<br>" + KEYS.Get(GLOBAL._resourceNames[2]) + "</b>";
            }
            else
            {
               tCost.htmlText = "<b>" + KEYS.Get("bunker_btn_transfer") + "</b>";
            }
         }
         else
         {
            tCost.htmlText = "<font color=\"#0000CC\"><b>" + GLOBAL.FormatNumber(usedA) + "<br>" + KEYS.Get(GLOBAL._resourceNames[4]) + "</b></font>";
         }
         try
         {
            this.ClearTransferCanvas(transferCanvasB);
            n = 1;
            for(c in this._bunker._monsters)
            {
               quantity = int(this._bunker._monsters[c]);
               if(quantity > 0)
               {
                  creatureProps = CREATURELOCKER._creatures[c];
                  transferBtnB = new MonsterBunkerPopup_TransferBtnB_CLIP();
                  transferBtnB.id = c;
                  transferBtnB._id = c.substr(1);
                  transferBtnB.index = c.substr(1);
                  transferBtnB.tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[c].name) + "</b>";
                  transferBtnB.tHoused.htmlText = KEYS.Get("bunker_bunkered",{"v1":quantity});
                  ImageCache.GetImageWithCallBack("monsters/" + c + "-medium.jpg",this.IconLoaded,true,1,"",[transferBtnB.mcIcon]);
                  transferBtnB.x = 0 * transferBtnB.width;
                  transferBtnB.y = -(1 * transferBtnB.height) + n * transferBtnB.height + n * spacingY;
                  this.InitTransferBarBListeners(transferBtnB);
                  transferCanvasB.addChild(transferBtnB);
                  n += 1;
               }
            }
         }
         catch(e:Error)
         {
            GLOBAL.ErrorMessage("MONSTERBUNKERPOPUP.Update TransferB" + e.message + " | " + e.getStackTrace());
            LOGGER.Log("err","MONSTERBUNKERPOPUP.Update TransferB" + e.message + " | " + e.getStackTrace());
         }
         this.UpdateScrollers();
      }
      
      private function UpdateScrollers(param1:Boolean = false) : void
      {
         if(this._scrollerA)
         {
            this._scrollerA.Update();
         }
         if(this._scrollerB)
         {
            this._scrollerB.Update();
         }
         if(param1)
         {
            this._scrollerA.ScrollTo(0,true);
            this._scrollerA.Update();
            this._scrollerB.ScrollTo(0,true);
            this._scrollerB.Update();
         }
      }
      
      private function GetCost(param1:String, param2:int) : int
      {
         var _loc4_:int = 0;
         var _loc3_:String = LOGIN._playerID.toString();
         if(this._mode == "housing")
         {
            return CREATURES.GetProperty(param1,"cResource",0,true) * 0.5 * param2;
         }
         if(!this.BUYABLE_MONSTERS[param1])
         {
            GLOBAL.ErrorMessage("MONSTERBUNKERPOPUP");
            return 0;
         }
         return this.BUYABLE_MONSTERS[param1] * param2;
      }
      
      private function SelectAdd(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         var _loc2_:String = String(param1.target.parent.id);
         if(this.CheckID(_loc2_))
         {
            if(this._selected[_loc2_])
            {
               this._selected[_loc2_].Add(1);
            }
            else
            {
               this._selected[_loc2_] = new SecNum(1);
            }
            this.Update();
         }
      }
      
      private function SelectRemove(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         var _loc2_:String = String(param1.target.parent.id);
         if(this._selected[_loc2_])
         {
            this._selected[_loc2_].Add(-1);
         }
         if(Boolean(this._selected[_loc2_]) && this._selected[_loc2_].Get() <= 0)
         {
            delete this._selected[_loc2_];
         }
         this.Update();
      }
      
      private function Transfer(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc5_:int = 0;
         if(!bTransfer.Enabled)
         {
            return;
         }
         var _loc3_:SecNum = new SecNum(0);
         var _loc4_:Array = [];
         if(this._mode == "housing")
         {
            for(_loc2_ in this._selected)
            {
               _loc3_.Add(this.GetCost(_loc2_,this._selected[_loc2_].Get()));
            }
            if(_loc3_.Get() == 0 || Boolean(BASE.Charge(3,_loc3_.Get(),false)))
            {
               for(_loc2_ in this._selected)
               {
                  _loc5_ = 0;
                  while(_loc5_ < this._selected[_loc2_].Get())
                  {
                     this.BunkerStore(_loc2_);
                     _loc5_++;
                  }
               }
               SOUNDS.Play("click1");
               this._selected = {};
               this.Update();
               BASE.Save();
            }
            else
            {
               GLOBAL.Message(KEYS.Get("bunker_lowputty"),KEYS.Get("bunker_btn_lowputty"),STORE.ShowB,[2,0.8,["BR31","BR32","BR33"]]);
            }
         }
         else
         {
            for(_loc2_ in this._selected)
            {
               _loc3_.Add(this.GetCost(_loc2_,this._selected[_loc2_].Get()));
               _loc4_.push([this._selected[_loc2_].Get(),KEYS.Get(CREATURELOCKER._creatures[_loc2_].name)]);
            }
            if(_loc3_.Get() <= BASE._credits.Get())
            {
               for(_loc2_ in this._selected)
               {
                  if(this._bunker._monsters[_loc2_])
                  {
                     this._bunker._monsters[_loc2_] += this._selected[_loc2_].Get();
                  }
                  else
                  {
                     this._bunker._monsters[_loc2_] = this._selected[_loc2_].Get();
                     this._bunker._monstersDispatched[_loc2_] = 0;
                  }
               }
               SOUNDS.Play("purchasepopup");
               this._selected = {};
               BASE.Purchase("BUNK",_loc3_.Get(),"bunker");
               GLOBAL.Message(KEYS.Get("bunker_purchased",{"v1":_loc3_.Get()}));
            }
            else
            {
               POPUPS.DisplayGetShiny();
            }
            this.Update();
         }
         this.UpdateScrollers(true);
      }
      
      private function Check(param1:int) : Boolean
      {
         var _loc5_:String = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for(_loc5_ in this._bunker._monsters)
         {
            _loc3_ += CREATURES.GetProperty(_loc5_,"cStorage",0,true) * this._bunker._monsters[_loc5_];
         }
         for(_loc5_ in this._selected)
         {
            _loc4_ += CREATURES.GetProperty(_loc5_,"cStorage",0,true) * this._selected[_loc5_].Get();
         }
         _loc4_ += int(CREATURELOCKER._creatures["C" + param1].props.cStorage);
         if(_loc3_ + _loc4_ > this._capacity)
         {
            return false;
         }
         if(this._mode == "housing")
         {
            if(Boolean(GLOBAL.player.monsterListByID("C" + param1)) && GLOBAL.player.monsterListByID("C" + param1).numCreeps > 0)
            {
               _loc2_ = GLOBAL.player.monsterListByID("C" + param1).numCreeps;
            }
            if(this._selected["C" + param1])
            {
               _loc2_ -= this._selected["C" + param1].Get();
            }
            if(_loc2_ > 0)
            {
               return true;
            }
         }
         else
         {
            if(Boolean(CREATURELOCKER._lockerData["C" + param1]) && CREATURELOCKER._lockerData["C" + param1].t == 2)
            {
               return true;
            }
            GLOBAL.Message(KEYS.Get("bunker_locker_desc",{"v1":KEYS.Get(CREATURELOCKER._creatures["C" + param1].name)}),KEYS.Get("btn_openlocker"),CREATURELOCKER.Show);
         }
         return false;
      }
      
      private function CheckID(param1:String) : Boolean
      {
         var _loc6_:String = null;
         var _loc2_:* = param1.substring(0,2) == "IC";
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for(_loc6_ in this._bunker._monsters)
         {
            _loc4_ += CREATURES.GetProperty(_loc6_,"cStorage",0,true) * this._bunker._monsters[_loc6_];
         }
         for(_loc6_ in this._selected)
         {
            _loc5_ += CREATURES.GetProperty(_loc6_,"cStorage",0,true) * this._selected[_loc6_].Get();
         }
         if(CREATURELOCKER._creatures[param1].props.cStorage.length > 1)
         {
            _loc5_ += int(CREATURELOCKER._creatures[param1].props.cStorage[CREATURELOCKER._creatures[param1].level]);
         }
         else
         {
            _loc5_ += int(CREATURELOCKER._creatures[param1].props.cStorage);
         }
         if(_loc4_ + _loc5_ > this._capacity)
         {
            return false;
         }
         if(this._mode == "housing")
         {
            if(Boolean(GLOBAL.player.monsterListByID(param1)) && GLOBAL.player.monsterListByID(param1).numCreeps > 0)
            {
               _loc3_ = GLOBAL.player.monsterListByID(param1).numCreeps;
            }
            if(this._selected[param1])
            {
               _loc3_ -= this._selected[param1].Get();
            }
            if(_loc3_ > 0)
            {
               return true;
            }
         }
         else
         {
            if(Boolean(CREATURELOCKER._lockerData[param1]) && CREATURELOCKER._lockerData[param1].t == 2)
            {
               return true;
            }
            if(_loc2_)
            {
               GLOBAL.Message(KEYS.Get("bunker_locker_desc_inf",{"v1":KEYS.Get(CREATURELOCKER._creatures[param1].name)}),null,null);
            }
            else
            {
               GLOBAL.Message(KEYS.Get("bunker_locker_desc",{"v1":KEYS.Get(CREATURELOCKER._creatures[param1].name)}),KEYS.Get("btn_openlocker"),CREATURELOCKER.Show);
            }
         }
         return false;
      }
      
      private function BunkerStore(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:CreepBase = null;
         var _loc6_:MonsterBase = null;
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc3_ in BASE._buildingsHousing)
         {
            _loc2_.push(_loc3_);
         }
         _loc4_ = int(CREATURELOCKER._creatures[param1].props.cStorage);
         if(Boolean(GLOBAL.player.monsterListByID(param1)) && _loc4_ <= this._bunker._capacity - this._bunker._used)
         {
            _loc5_ = null;
            for each(_loc6_ in CREATURES._creatures)
            {
               if(_loc6_._creatureID == param1 && (_loc6_._behaviour == "housing" || _loc6_._behaviour == "pen"))
               {
                  _loc5_ = _loc6_ as CreepBase;
                  break;
               }
            }
            if(_loc5_ == null)
            {
               _loc3_ = _loc2_[int(Math.random() * _loc2_.length)];
               _loc5_ = CREATURES.Spawn(param1,MAP._BUILDINGTOPS,"bunker",new Point(_loc3_.x,_loc3_.y).add(new Point(-60 + Math.random() * 135,65 + Math.random() * 50)),Math.random() * 360) as CreepBase;
            }
            if(_loc5_)
            {
               _loc5_._homeBunker = this._bunker;
               _loc5_.changeModeBunker();
               GLOBAL.player.monsterListByID(param1).add(-1);
               if(Boolean(this._bunker._monsters[param1]) && this._bunker._monsters[param1] > 0)
               {
                  this._bunker._monsters[param1] += 1;
                  this._bunker._used += int(_loc4_);
                  if(this._bunker._monstersDispatched[param1])
                  {
                     this._bunker._monstersDispatched[param1] += 1;
                  }
                  else
                  {
                     this._bunker._monstersDispatched[param1] = 1;
                  }
               }
               else
               {
                  this._bunker._monsters[param1] = 1;
                  this._bunker._monstersDispatched[param1] = 1;
               }
               ++this._bunker._monstersDispatchedTotal;
            }
            this.Update();
            HOUSING.HousingSpace();
         }
      }
      
      private function BunkerJuice(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         this.BunkerJuiceById(param1.target.parent._id);
      }
      
      private function BunkerJuiceID(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         this.BunkerJuiceById(param1.target.parent.id);
      }
      
      private function BunkerJuiceById(param1:String) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:MonsterBase = null;
         var _loc2_:* = param1.substring(0,2) == "IC";
         if(Boolean(GLOBAL._bJuicer) && !_loc2_)
         {
            if(Boolean(GLOBAL._bJuicer) && GLOBAL._bJuicer._countdownUpgrade.Get() == 0)
            {
               if(GLOBAL._bJuicer.health > GLOBAL._bJuicer.maxHealth * 0.5)
               {
                  if(this._bunker._monsters[param1])
                  {
                     _loc3_ = false;
                     for each(_loc4_ in CREATURES._creatures)
                     {
                        if(_loc4_._creatureID == param1 && _loc4_._behaviour == "bunker")
                        {
                           _loc4_.changeModeJuice();
                           this._bunker._monstersDispatched[param1] = int(this._bunker._monstersDispatched[param1]) - 1;
                           if(this._bunker._monstersDispatched[param1] < 0)
                           {
                              this._bunker._monstersDispatched[param1] = 0;
                           }
                           --this._bunker._monstersDispatchedTotal;
                           if(this._bunker._monstersDispatchedTotal < 0)
                           {
                              this._bunker._monstersDispatchedTotal = 0;
                           }
                           _loc3_ = true;
                           break;
                        }
                     }
                     if(!_loc3_)
                     {
                        CREATURES.Spawn(param1,MAP._BUILDINGTOPS,"juice",new Point(this._bunker.x,this._bunker.y).add(new Point(-60 + Math.random() * 135,-5 + Math.random() * 20)),Math.random() * 360);
                     }
                     this._bunker._monsters[param1] = int(this._bunker._monsters[param1]) - 1;
                     if(this._bunker._monsters[param1] < 0)
                     {
                        this._bunker._monsters[param1] = 0;
                     }
                  }
                  this.Update();
                  BASE.Save();
                  return;
               }
            }
         }
         if(this._bunker._monsters[param1])
         {
            this._bunker._monsters[param1] = int(this._bunker._monsters[param1]) - 1;
            if(this._bunker._monsters[param1] < 0)
            {
               this._bunker._monsters[param1] = 0;
            }
         }
         this.Update();
         BASE.Save();
      }
      
      public function GetBunkerCreatures() : Array
      {
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc12_:Object = null;
         var _loc1_:Object = {};
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Object = CREATURELOCKER.GetCreatures("above");
         var _loc6_:*;
         if(_loc6_ = !BASE.isInfernoMainYardOrOutpost)
         {
            for(_loc9_ in _loc5_)
            {
               if(!(_loc10_ = CREATURELOCKER._creatures[_loc9_]).blocked)
               {
                  _loc10_.id = _loc9_;
                  _loc2_.push(_loc10_);
                  _loc1_[_loc9_] = _loc10_;
               }
            }
            _loc2_.sortOn(["index"],Array.NUMERIC);
         }
         var _loc7_:Object = CREATURELOCKER.GetCreatures("inferno");
         var _loc8_:Boolean;
         if(_loc8_ = MAPROOM_DESCENT.DescentPassed)
         {
            for(_loc11_ in _loc7_)
            {
               if(!(_loc12_ = CREATURELOCKER._creatures[_loc11_]).blocked)
               {
                  _loc12_.id = _loc11_;
                  _loc3_.push(_loc12_);
                  _loc1_[_loc11_] = _loc12_;
               }
            }
            _loc3_.sortOn(["index"],Array.NUMERIC);
         }
         if(_loc2_.length > 0)
         {
            _loc4_ = _loc4_.concat(_loc2_);
         }
         if(_loc3_.length > 0)
         {
            _loc4_ = _loc4_.concat(_loc3_);
         }
         return _loc4_;
      }
      
      public function Help(param1:MouseEvent = null) : void
      {
         this._guidePage += 1;
         var _loc2_:String = KEYS.Get("bunker_tut_" + this._guidePage);
         if(this._guidePage <= 3)
         {
            this.gotoAndStop(2);
            txtGuide.htmlText = _loc2_;
            if(this._guidePage == 1)
            {
               this.bContinue.addEventListener(MouseEvent.CLICK,this.Help);
               this.bContinue.SetupKey("btn_continue");
            }
         }
         else
         {
            this._guidePage = 0;
            this.gotoAndStop(1);
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         MONSTERBUNKER.Hide(param1);
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

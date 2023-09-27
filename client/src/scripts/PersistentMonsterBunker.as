package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import com.monsters.managers.InstanceManager;
   import com.monsters.player.CreepInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PersistentMonsterBunker extends MonsterBunkerPopup_Persistent_CLIP
   {
      
      private static const kBarWidth:int = 535;
       
      
      private var m_bunker = null;
      
      private var _capacity:int = 0;
      
      private var _selected:Object;
      
      private var _scrollerA:ScrollSet;
      
      private var _scrollerB:ScrollSet;
      
      private var _guidePage:int = 0;
      
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
      
      public function PersistentMonsterBunker()
      {
         var _loc1_:MovieClip = null;
         super();
         this.m_bunker = GLOBAL._selectedBuilding;
         this._capacity = GLOBAL._buildingProps[21].capacity[this.m_bunker._lvl.Get() - 1];
         this._selected = {};
         transferCanvasA.mask = transferCanvasAmask;
         transferCanvasB.mask = transferCanvasBmask;
         var _loc2_:int = 267;
         this._scrollerA = new ScrollSet();
         this._scrollerA.AutoHideEnabled = false;
         this._scrollerA.width = 16;
         this._scrollerA.x = -50;
         this._scrollerA.y = -102;
         addChild(this._scrollerA);
         this._scrollerA.Init(transferCanvasA,transferCanvasAmask,0,this._scrollerA.y,_loc2_);
         this._scrollerB = new ScrollSet();
         this._scrollerB.AutoHideEnabled = false;
         this._scrollerB.width = 16;
         this._scrollerB.x = 300;
         this._scrollerB.y = -102;
         addChild(this._scrollerB);
         this._scrollerB.Init(transferCanvasB,transferCanvasBmask,0,this._scrollerB.y,_loc2_);
         title_txt.htmlText = KEYS.Get("bunker_title");
         tCapacity.htmlText = "<b>" + KEYS.Get("bunker_word") + "</b>";
         tHousing.htmlText = "<b>" + KEYS.Get("bunker_all_monsters") + "</b>";
         var _loc3_:int = HOUSING._housingUsed.Get();
         var _loc4_:int = HOUSING._housingCapacity.Get();
         var _loc5_:int = Math.floor(_loc3_ * 100 / Number(_loc4_));
         tHoused.htmlText = "<b>" + KEYS.Get("bunker_capacity2") + " " + GLOBAL.FormatNumber(_loc3_) + " / " + GLOBAL.FormatNumber(_loc4_) + " (" + _loc5_ + "%)<b>";
         mcHousing.mcBar.width = kBarWidth * (_loc3_ / _loc4_);
         mcHousing.mcBarB.width = 0;
         this.Update();
      }
      
      public function InitTransferBarAListeners(param1:MovieClip) : void
      {
         param1.bAdd.addEventListener(MouseEvent.CLICK,this.SelectAdd);
         param1.bAdd.Setup(">>");
         param1.bAdd.buttonMode = true;
      }
      
      public function InitTransferBarBListeners(param1:MovieClip) : void
      {
         param1.bRemove.addEventListener(MouseEvent.CLICK,this.ReturnMonsterId);
         param1.bRemove.Setup("&lt;&lt;");
         param1.bRemove.buttonMode = true;
      }
      
      public function RemoveTransferBarListeners(param1:MovieClip) : void
      {
         if(param1 is MonsterBunkerPopup_TransferBtnA_CLIP_Persistant)
         {
            param1.bAdd.removeEventListener(MouseEvent.CLICK,this.SelectAdd);
         }
         else if(param1 is MonsterBunkerPopup_TransferBtnB_CLIP_Persistant)
         {
            param1.bRemove.removeEventListener(MouseEvent.CLICK,this.ReturnMonsterId);
         }
      }
      
      public function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
         param3[0].mcLoading.visible = false;
      }
      
      private function CanBunkerFromHousing(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         if(Boolean(this.BUNKERABLE_MONSTERS[param1]) && GLOBAL.player.monsterListByID(param1).numHealthyHousedCreeps > 0)
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
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:MovieClip = null;
         var _loc19_:int = 0;
         var _loc20_:MonsterBunkerPopup_TransferBtnA_CLIP_Persistant = null;
         var _loc21_:String = null;
         var _loc22_:int = 0;
         var _loc23_:MonsterBunkerPopup_TransferBtnB_CLIP_Persistant = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         this.ClearTransferCanvas(transferCanvasA);
         _loc9_ = 1;
         var _loc18_:Array = HOUSING.GetHousingCreatures();
         _loc8_ = 0;
         while(_loc8_ < _loc18_.length)
         {
            _loc1_ = String(_loc18_[_loc8_].id);
            if(this.CanBunkerFromHousing(_loc1_))
            {
               _loc20_ = new MonsterBunkerPopup_TransferBtnA_CLIP_Persistant();
               ImageCache.GetImageWithCallBack("monsters/" + _loc1_ + "-medium.jpg",this.IconLoaded,true,1,"",[_loc20_.mcIcon]);
               _loc21_ = String(CREATURELOCKER._creatures[_loc1_].name);
               if(_loc1_ == "IC8")
               {
                  _loc21_ = "#m_k_wormzer#";
               }
               _loc20_.tName.htmlText = "<b>" + KEYS.Get(_loc21_) + "</b>";
               _loc20_.id = _loc1_;
               _loc20_._id = _loc1_.substring(_loc1_.indexOf("C") + 1);
               _loc20_.index = _loc1_.substring(_loc1_.indexOf("C") + 1);
               if((_loc10_ = GLOBAL.player.monsterListByID(_loc1_).numHealthyHousedCreeps) == 0)
               {
                  _loc20_.tHoused.htmlText = "<font color=\"#FF0000\">" + KEYS.Get("bunker_housed",{"v1":0}) + "</font>";
               }
               else
               {
                  _loc20_.tHoused.htmlText = "<font color=\"#000000\">" + KEYS.Get("bunker_housed",{"v1":_loc10_}) + "</font>";
               }
               _loc20_.bAdd.Enabled = _loc10_ != 0;
               _loc20_.tSize.text = CREATURES.GetProperty(_loc1_,"cStorage",0,true).toString();
               _loc20_.x = 0;
               _loc20_.y = (_loc9_ - 1) * _loc20_.height;
               this.InitTransferBarAListeners(_loc20_);
               transferCanvasA.addChild(_loc20_);
               _loc9_ += 1;
            }
            _loc8_++;
         }
         if(_loc9_ == 1)
         {
            tNoMonsters.htmlText = KEYS.Get("mr3_bunker_empty");
         }
         else
         {
            tNoMonsters.htmlText = "";
         }
         _loc9_ = 0;
         for(_loc2_ in this._selected)
         {
            _loc9_ += this._selected[_loc2_].Get();
         }
         for(_loc2_ in this.m_bunker._monsters)
         {
            _loc4_ += CREATURES.GetProperty(_loc2_,"cStorage",0,true) * this.m_bunker._monsters[_loc2_].length;
         }
         this.m_bunker._used = _loc4_;
         for(_loc2_ in this._selected)
         {
            _loc5_ += CREATURES.GetProperty(_loc2_,"cStorage",0,true) * this._selected[_loc2_].Get();
         }
         _loc19_ = 100 / this._capacity * (_loc4_ + _loc5_);
         mcStorage.mcBar.width = 0;
         mcStorage.mcBarB.width = 535 / this._capacity * (_loc4_ + _loc5_);
         if(_loc4_ + _loc5_ >= this._capacity)
         {
            if(this.m_bunker._lvl.Get() < 3)
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
            tStored.htmlText = "<b>" + KEYS.Get("bunker_capacity2") + " " + GLOBAL.FormatNumber(_loc4_ + _loc5_) + " / " + GLOBAL.FormatNumber(this._capacity) + " (" + _loc19_ + "%)</b>";
         }
         this.ClearTransferCanvas(transferCanvasB);
         _loc9_ = 1;
         for(_loc2_ in this.m_bunker._monsters)
         {
            if((_loc22_ = int(this.m_bunker._monsters[_loc2_].length)) > 0)
            {
               _loc7_ = CREATURELOCKER._creatures[_loc2_];
               (_loc23_ = new MonsterBunkerPopup_TransferBtnB_CLIP_Persistant()).id = _loc2_;
               _loc23_._id = _loc2_.substr(1);
               _loc23_.index = _loc2_.substr(1);
               _loc23_.tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[_loc2_].name) + "</b>";
               _loc23_.tHoused.htmlText = KEYS.Get("bunker_bunkered",{"v1":_loc22_});
               ImageCache.GetImageWithCallBack("monsters/" + _loc2_ + "-medium.jpg",this.IconLoaded,true,1,"",[_loc23_.mcIcon]);
               _loc23_.bRemove.Enabled = _loc22_ != 0;
               _loc23_.tSize.text = CREATURES.GetProperty(_loc2_,"cStorage",0,true).toString();
               _loc23_.x = 0;
               _loc23_.y = (_loc9_ - 1) * _loc23_.height;
               this.InitTransferBarBListeners(_loc23_);
               transferCanvasB.addChild(_loc23_);
               _loc9_ += 1;
            }
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
      
      private function SelectAdd(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         var _loc2_:String = String(param1.target.parent.id);
         if(Boolean(_loc2_) && this.CheckID(_loc2_))
         {
            this.BunkerStore(_loc2_);
            this.Update();
         }
      }
      
      private function CheckID(param1:String) : Boolean
      {
         var _loc6_:String = null;
         var _loc2_:* = param1.substring(0,2) == "IC";
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for(_loc6_ in this.m_bunker._monsters)
         {
            _loc4_ += CREATURES.GetProperty(_loc6_,"cStorage",0,true) * this.m_bunker._monsters[_loc6_].length;
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
         if(Boolean(GLOBAL.player.monsterListByID(param1)) && GLOBAL.player.monsterListByID(param1).numHealthyHousedCreeps > 0)
         {
            _loc3_ = GLOBAL.player.monsterListByID(param1).numHealthyHousedCreeps;
         }
         if(this._selected[param1])
         {
            _loc3_ -= this._selected[param1].Get();
         }
         if(_loc3_ > 0)
         {
            return true;
         }
         return false;
      }
      
      private function BunkerStore(param1:String) : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:CreepInfo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in BASE._buildingsHousing)
         {
            _loc2_.push(_loc3_);
         }
         InstanceManager.getInstancesByClass(HOUSING);
         _loc4_ = int(CREATURELOCKER._creatures[param1].props.cStorage);
         if(Boolean(GLOBAL.player.monsterListByID(param1)) && _loc4_ <= this.m_bunker._capacity - this.m_bunker._used)
         {
            _loc5_ = null;
            for each(_loc6_ in CREATURES._creatures)
            {
               if(_loc6_._creatureID == param1 && (_loc6_._behaviour == "housing" || _loc6_._behaviour == "pen"))
               {
                  _loc5_ = _loc6_;
                  break;
               }
            }
            if(_loc5_)
            {
               _loc5_._homeBunker = this.m_bunker;
               _loc5_.changeModeBunker();
               if(_loc7_ = GLOBAL.player.monsterListByID(param1).reserve(this.m_bunker._id))
               {
                  if(Boolean(this.m_bunker._monsters[param1]) && this.m_bunker._monsters[param1].length > 0)
                  {
                     this.m_bunker._monsters[param1].push(_loc7_);
                     this.m_bunker._used += int(_loc4_);
                     if(this.m_bunker._monstersDispatched[param1])
                     {
                        this.m_bunker._monstersDispatched[param1] += 1;
                     }
                     else
                     {
                        this.m_bunker._monstersDispatched[param1] = 1;
                     }
                  }
                  else
                  {
                     this.m_bunker._monsters[param1] = new Vector.<CreepInfo>();
                     this.m_bunker._monsters[param1].push(_loc7_);
                     this.m_bunker._monstersDispatched[param1] = 1;
                  }
                  ++this.m_bunker._monstersDispatchedTotal;
               }
            }
            this.Update();
            HOUSING.HousingSpace();
         }
      }
      
      private function ReturnMonsterId(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         this.bunkerRemove(param1.target.parent.id);
      }
      
      private function bunkerRemove(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BFOUNDATION = null;
         var _loc6_:Point = null;
         var _loc2_:CreepInfo = GLOBAL.player.monsterListByID(param1).release(this.m_bunker._id);
         if(_loc2_)
         {
            _loc3_ = int(this.m_bunker._monsters[param1].length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this.m_bunker._monsters[param1][_loc4_] == _loc2_)
               {
                  this.m_bunker._monsters[param1].splice(_loc4_,1);
                  break;
               }
               _loc4_++;
            }
            --this.m_bunker._monstersDispatched[param1];
            if(this.m_bunker._monstersDispatched[param1] < 0)
            {
               this.m_bunker._monstersDispatched[param1] = 0;
            }
            --this.m_bunker._monstersDispatchedTotal;
            if(this.m_bunker._monstersDispatchedTotal < 0)
            {
               this.m_bunker._monstersDispatchedTotal = 0;
            }
            if(_loc2_.self)
            {
               if(_loc2_.self._house)
               {
                  _loc5_ = _loc2_.self._house;
               }
               else
               {
                  _loc5_ = HOUSING.getClosestHouseToPoint(new Point(_loc2_.self.x,_loc2_.self.y));
               }
               _loc2_.self._targetCenter = GRID.FromISO(_loc5_.x,_loc5_.y);
               _loc2_.self.changeModeHousing();
            }
            else
            {
               _loc6_ = new Point(this.m_bunker._mc.x - 10 + Math.random() * 20,this.m_bunker._mc.y - 10 + Math.random() * 20);
               _loc2_.self = HOUSING.createAndHouseCreep(param1,_loc6_);
            }
         }
         this.Update();
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
         BASE.Save();
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

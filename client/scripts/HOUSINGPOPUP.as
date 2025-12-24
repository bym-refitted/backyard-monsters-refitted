package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.MonsterBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class HOUSINGPOPUP extends HOUSINGPOPUP_CLIP
   {
       
      
      public var _juiceList:Object;
      
      public var _creatureList:Object;
      
      public var _creatureData:Object;
      
      public var _scroller:ScrollSet;
      
      public function HOUSINGPOPUP()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:HousingPopupMonster_CLIP = null;
         this._juiceList = {};
         this._creatureList = {};
         this._creatureData = {};
         super();
         if(GLOBAL._bJuicer)
         {
            gotoAndStop(2);
            bJuice.SetupKey("mh_nomonsters_btn");
            bJuice.Enabled = false;
            bJuice.addEventListener(MouseEvent.CLICK,this.Juice);
            bAll.SetupKey("mh_selectall_btn");
            bAll.addEventListener(MouseEvent.CLICK,this.SelectAll);
            bCancel.SetupKey("mh_cancel_btn");
            bCancel.Enabled = false;
            bCancel.addEventListener(MouseEvent.CLICK,this.SelectNone);
         }
         else
         {
            gotoAndStop(1);
         }
         this._juiceList = {};
         if(MAPROOM_DESCENT.DescentPassed && BASE.isMainYard)
         {
            bAscend.visible = true;
            bAscend.Enabled = true;
            bAscend.SetupKey("btn_ascendmonsters");
            bAscend.addEventListener(MouseEvent.CLICK,this.Ascend);
         }
         else
         {
            ascend_desc_txt.visible = false;
            bAscend.visible = false;
            bAscend.Enabled = false;
         }
         _loc2_ = 3;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 215;
         var _loc7_:int = 40;
         var _loc8_:int = 6;
         var _loc9_:int = 3;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Array = [];
         _loc12_ = this.GetHousableCreatures();
         _loc1_ = 0;
         while(_loc1_ < _loc12_.length)
         {
            _loc13_ = int(_loc12_[_loc1_].id.substring(_loc12_[_loc1_].id.indexOf("C") + 1));
            _loc14_ = String(_loc12_[_loc1_].id);
            (_loc15_ = new HousingPopupMonster_CLIP()).x = _loc1_ * _loc6_ % (_loc2_ * _loc6_);
            _loc5_ = _loc1_ / _loc2_;
            _loc15_.y = _loc5_ * _loc7_;
            _loc15_.mouseChildren = false;
            monsterContainer.addChild(_loc15_);
            this._creatureList["m" + _loc14_] = _loc15_;
            ImageCache.GetImageWithCallBack("monsters/" + _loc14_ + "-medium.jpg",this.IconLoaded,true,1,"",[_loc15_.mcIcon]);
            _loc15_.tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[_loc14_].name) + "</b>";
            if(GLOBAL._bJuicer)
            {
               _loc15_.addEventListener(MouseEvent.CLICK,this.JuicerAdd(_loc14_));
               _loc15_.buttonMode = true;
               _loc15_.mouseChildren = false;
            }
            _loc1_++;
         }
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
         }
         else
         {
            title_txt.htmlText = KEYS.Get("mh_title");
         }
         if(BASE.isInfernoMainYardOrOutpost)
         {
            capacity_desc_txt.htmlText = "<b>" + KEYS.Get("compound_capacity_desc") + "</b>";
         }
         else
         {
            capacity_desc_txt.htmlText = "<b>" + KEYS.Get("mh_capacity_desc") + "</b>";
         }
         if(GLOBAL._bJuicer)
         {
            juicefooter_desc_txt.htmlText = KEYS.Get("mh_juicefooter_desc");
         }
         else
         {
            footer_desc_txt.htmlText = KEYS.Get(BASE.isInfernoMainYardOrOutpost ? "hb_footer_desc" : "mh_footer_desc");
         }
         if(MAPROOM_DESCENT.DescentPassed)
         {
            ascend_desc_txt.htmlText = KEYS.Get("mh_ascension_desc");
         }
         else
         {
            ascend_desc_txt.htmlText = KEYS.Get("mh_ascension_noinf");
         }
         this.Update();
      }
      
      public function GetHousableCreatures() : Array
      {
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         this._creatureData = {};
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Object = CREATURELOCKER.GetCreatures("above");
         var _loc5_:*;
         if(_loc5_ = !BASE.isInfernoMainYardOrOutpost)
         {
            for(_loc8_ in _loc4_)
            {
               if(!(_loc9_ = CREATURELOCKER._creatures[_loc8_]).blocked)
               {
                  _loc9_.id = _loc8_;
                  _loc1_.push(_loc9_);
                  this._creatureData[_loc8_] = _loc9_;
               }
            }
            _loc1_.sortOn(["index"],Array.NUMERIC);
         }
         var _loc6_:Object = CREATURELOCKER.GetCreatures("inferno");
         var _loc7_:Boolean;
         if(_loc7_ = MAPROOM_DESCENT.DescentPassed)
         {
            for(_loc10_ in _loc6_)
            {
               if(!(_loc11_ = CREATURELOCKER._creatures[_loc10_]).blocked)
               {
                  _loc11_.id = _loc10_;
                  _loc2_.push(_loc11_);
                  this._creatureData[_loc10_] = _loc11_;
               }
            }
            _loc2_.sortOn(["index"],Array.NUMERIC);
         }
         if(_loc1_.length > 0)
         {
            _loc3_ = _loc3_.concat(_loc1_);
         }
         if(_loc2_.length > 0)
         {
            _loc3_ = _loc3_.concat(_loc2_);
         }
         return _loc3_;
      }
      
      public function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
         param3[0].mcImage.visible = true;
         param3[0].mcLoading.visible = false;
      }
      
      public function Update() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:* = false;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         this.GetHousableCreatures();
         HOUSING.HousingSpace();
         _loc3_ = 0;
         for(_loc2_ in this._juiceList)
         {
            _loc3_ += CREATURELOCKER._creatures[_loc2_].props.cStorage * this._juiceList[_loc2_];
         }
         HOUSING._housingUsed.Add(-_loc3_);
         _loc7_ = Math.round(100 / Number(HOUSING._housingCapacity.Get()) * Number(HOUSING._housingUsed.Get()));
         mcStorage.mcBar.width = 535 / HOUSING._housingCapacity.Get() * HOUSING._housingUsed.Get();
         mcStorage.mcBarB.width = 1;
         tStorage.htmlText = "<b>" + GLOBAL.FormatNumber(HOUSING._housingUsed.Get()) + " / " + GLOBAL.FormatNumber(HOUSING._housingCapacity.Get()) + " (" + _loc7_ + "%)</b>";
         for(_loc8_ in this._creatureData)
         {
            _loc11_ = int(_loc8_.substring(_loc8_.indexOf("C") + 1));
            _loc1_ = _loc8_;
            if(!((_loc6_ = _loc1_.substring(0,2) == "IC") && !MAPROOM_DESCENT.DescentPassed))
            {
               if(!_loc6_ && !CREATURELOCKER._lockerData[_loc1_])
               {
                  if(BASE.isInfernoMainYardOrOutpost)
                  {
                     this._creatureList["m" + _loc1_].tInfo.htmlText = KEYS.Get("compound_item_locked");
                  }
                  else
                  {
                     this._creatureList["m" + _loc1_].tInfo.htmlText = KEYS.Get("mh_item_locked");
                  }
                  this._creatureList["m" + _loc1_];
               }
               else if(!_loc6_ && CREATURELOCKER._lockerData[_loc1_].t == 1)
               {
                  this._creatureList["m" + _loc1_].tInfo.htmlText = KEYS.Get("mh_item_unlocking");
                  this._creatureList["m" + _loc1_].alpha = 0.5;
               }
               else
               {
                  this._creatureList["m" + _loc1_].tInfo.htmlText = KEYS.Get("mh_item_0housed");
                  this._creatureList["m" + _loc1_].alpha = 0.5;
               }
            }
         }
         _loc9_ = int(GLOBAL.player.monsterList.length);
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc2_ = GLOBAL.player.monsterList[_loc10_].m_creatureID;
            _loc12_ = GLOBAL.player.monsterList[_loc10_].numCreeps;
            if(this._creatureList["m" + _loc2_])
            {
               if(_loc12_ > 0)
               {
                  _loc5_ = CREATURELOCKER._creatures[_loc2_];
                  _loc13_ = int(_loc2_.substring(_loc2_.indexOf("C") + 1));
                  if(Boolean(this._juiceList[_loc2_]) && this._juiceList[_loc2_] > 0)
                  {
                     this._creatureList["m" + _loc2_].tInfo.htmlText = "<font color=\"#FF0000\">" + KEYS.Get("mh_selectedforjuicing",{
                        "v1":this._juiceList[_loc2_],
                        "v2":GLOBAL.FormatNumber(_loc12_)
                     }) + "</font>";
                  }
                  else
                  {
                     this._creatureList["m" + _loc2_].tInfo.htmlText = KEYS.Get("mh_item_cost",{
                        "v1":GLOBAL.FormatNumber(_loc12_),
                        "v2":GLOBAL.FormatNumber(CREATURES.GetProperty(_loc2_,"cStorage") * _loc12_)
                     });
                  }
                  this._creatureList["m" + _loc2_].alpha = 1;
               }
            }
            _loc10_++;
         }
         if(GLOBAL._bJuicer)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            for(_loc2_ in this._juiceList)
            {
               if(!(_loc6_ = _loc2_.substring(0,2) == "IC"))
               {
                  _loc3_ += this._juiceList[_loc2_];
                  _loc14_ = 0.6;
                  if(GLOBAL._bJuicer._lvl.Get() == 2)
                  {
                     _loc14_ = 0.8;
                  }
                  if(GLOBAL._bJuicer._lvl.Get() == 3)
                  {
                     _loc14_ = 1;
                  }
                  _loc4_ += Math.ceil(CREATURES.GetProperty(_loc2_,"cResource").Get() * _loc14_) * this._juiceList[_loc2_];
               }
            }
            if(_loc3_ > 0)
            {
               bJuice.Enabled = true;
               bJuice.Highlight = true;
               bCancel.Enabled = true;
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
               bCancel.Enabled = false;
            }
            if(HOUSING._housingUsed.Get() == 0)
            {
               bAll.Enabled = false;
            }
            else
            {
               bAll.Enabled = true;
            }
         }
         this._scroller.Update();
      }
      
      public function JuicerAdd(param1:String) : Function
      {
         var isInfernoType:Boolean = false;
         var n:String = param1;
         isInfernoType = n.substring(0,2) == "IC";
         return function(param1:MouseEvent = null):void
         {
            if(isInfernoType)
            {
               GLOBAL.Message(KEYS.Get("msg_juicernoinferno"));
               return;
            }
            if(GLOBAL._bJuicer._countdownUpgrade.Get() == 0)
            {
               if(GLOBAL._bJuicer.health > GLOBAL._bJuicer.maxHealth * 0.5)
               {
                  if(Boolean(GLOBAL.player.monsterListByID(n)) && GLOBAL.player.monsterListByID(n).numCreeps - int(_juiceList[n]) > 0)
                  {
                     if(!_juiceList[n])
                     {
                        _juiceList[n] = 0;
                     }
                     ++_juiceList[n];
                  }
                  Update();
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
         };
      }
      
      public function Juice(param1:MouseEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:BFOUNDATION = null;
         var _loc5_:MonsterBase = null;
         var _loc8_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc4_ in _loc7_)
         {
            _loc6_.push(_loc4_);
         }
         for(_loc2_ in this._juiceList)
         {
            GLOBAL.player.monsterListByID(_loc2_).add(-this._juiceList[_loc2_]);
            for each(_loc5_ in CREATURES._creatures)
            {
               if(this._juiceList[_loc2_] > 0)
               {
                  if(_loc5_._creatureID == _loc2_ && _loc5_._behaviour != "juice")
                  {
                     _loc5_.changeModeJuice();
                     --this._juiceList[_loc2_];
                  }
               }
            }
            _loc8_ = 0;
            while(_loc8_ < this._juiceList[_loc2_])
            {
               _loc4_ = _loc6_[int(Math.random() * _loc6_.length)];
               CREATURES.Spawn(_loc2_,MAP._BUILDINGTOPS,"juice",new Point(_loc4_.x,_loc4_.y).add(new Point(-60 + Math.random() * 135,65 + Math.random() * 50)),Math.random() * 360);
               _loc8_++;
            }
         }
         this._juiceList = {};
         HOUSING.HousingSpace();
         BASE.Save();
         HOUSING.Hide();
      }
      
      public function SelectAll(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:* = false;
         if(GLOBAL._bJuicer._countdownUpgrade.Get() == 0)
         {
            this._juiceList = {};
            _loc2_ = int(GLOBAL.player.monsterList.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = GLOBAL.player.monsterList[_loc4_].m_creatureID;
               _loc5_ = _loc3_.substring(0,2) == "IC";
               if(GLOBAL.player.monsterList[_loc4_].numCreeps > 0 && !_loc5_)
               {
                  this._juiceList[_loc3_] = GLOBAL.player.monsterList[_loc4_].numCreeps;
               }
               _loc4_++;
            }
            this.Update();
         }
         else
         {
            GLOBAL.Message(KEYS.Get("msg_juicerupgrading"));
         }
      }
      
      public function SelectNone(param1:MouseEvent = null) : void
      {
         this._juiceList = {};
         bJuice.SetupKey("mh_nomonsters_btn");
         bJuice.Enabled = false;
         bJuice.Highlight = false;
         this.Update();
      }
      
      public function Ascend(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         this.Hide();
         INFERNOPORTAL.AscendMonsters();
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

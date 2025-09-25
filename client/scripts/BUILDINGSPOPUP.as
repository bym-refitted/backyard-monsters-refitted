package
{
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   
   public class BUILDINGSPOPUP extends BUILDINGSPOPUP_CLIP
   {
       
      
      public var _subButtonsMC:MovieClip;
      
      public var _thumbnailsMC:MovieClip;
      
      public var _buildingInfoMC:BUILDINGOPTIONSPOPUP;
      
      public var _pageCount:int;
      
      public var _excluded:Array;
      
      public var _subButtons:Array;
      
      public function BUILDINGSPOPUP()
      {
         super();
         this._subButtonsMC = null;
         this._thumbnailsMC = null;
         this._buildingInfoMC = null;
         this._pageCount = 0;
         mcNew.visible = GLOBAL._newThings;
         b1.SetupKey("btn_resources");
         b2.SetupKey("btn_buildings");
         b3.SetupKey("btn_defensive");
         b4.SetupKey("btn_decorations");
         b1.addEventListener(MouseEvent.CLICK,this.Switch(1,1,0));
         b2.addEventListener(MouseEvent.CLICK,this.Switch(2,1,0));
         b3.addEventListener(MouseEvent.CLICK,this.Switch(3,1,0));
         b4.addEventListener(MouseEvent.CLICK,this.Switch(4,0,0));
         bPrevious.addEventListener(MouseEvent.CLICK,this.Previous);
         bPrevious.buttonMode = true;
         bNext.addEventListener(MouseEvent.CLICK,this.Next);
         bNext.buttonMode = true;
         if(!GLOBAL.townHall)
         {
            this.SwitchB(2,1,0);
         }
         else
         {
            this.SwitchB(BUILDINGS._menuA,BUILDINGS._menuB,BUILDINGS._page);
         }
         if(BASE.isMainYard)
         {
            if(!GLOBAL._flags.radio)
            {
               GLOBAL._buildingProps[112].block = true;
               GLOBAL._buildingProps[11].order = 2;
            }
         }
      }
      
      public function Switch(param1:int, param2:int, param3:int) : Function
      {
         var a:int = param1;
         var b:int = param2;
         var p:int = param3;
         return function(param1:MouseEvent):void
         {
            if(param1.target.Enabled)
            {
               SOUNDS.Play("click1");
               SwitchB(a,b,p);
            }
         };
      }
      
      public function Exclude(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] is Array)
            {
               if(this._subButtons)
               {
                  if(param1[_loc2_].length == this._subButtons.length)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < param1[_loc2_].length)
                     {
                        this._subButtons[param1[_loc2_][_loc3_]].Enabled = false;
                        _loc2_++;
                     }
                  }
               }
            }
            else
            {
               this["b" + param1[_loc2_]].Enabled = false;
            }
            _loc2_++;
         }
         this._excluded = param1;
      }
      
      public function SwitchB(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:BUILDINGBUTTON = null;
         BUILDINGS._menuA = int(param1);
         BUILDINGS._menuB = int(param2);
         BUILDINGS._page = int(param3);
         var _loc4_:int = 1;
         while(_loc4_ < 5)
         {
            this["b" + _loc4_].Highlight = false;
            _loc4_++;
         }
         this["b" + param1].Highlight = true;
         if(param1 == 4)
         {
            this.SubMenu([KEYS.Get("btn_evil"),KEYS.Get("btn_plants"),KEYS.Get("btn_good"),KEYS.Get("btn_flags"),KEYS.Get("btn_premium")]);
         }
         else
         {
            this.SubMenu([]);
         }
         if(this._thumbnailsMC)
         {
            this.removeChild(this._thumbnailsMC);
         }
         this._thumbnailsMC = this.addChild(new MovieClip()) as MovieClip;
         this._thumbnailsMC.x = 60;
         this._thumbnailsMC.y = 115 + 25;
         var _loc7_:Array = GLOBAL._buildingProps.concat();
         if(TUTORIAL.hasFinished)
         {
            this.SortBuildings(_loc7_);
         }
         else
         {
            _loc7_.sortOn("order",Array.NUMERIC);
         }
         param2 = 0;
         while(param2 < _loc7_.length)
         {
            _loc10_ = _loc7_[param2];
            if(int(_loc10_.group) == param1 && (_loc10_.subgroup == null || int(_loc10_.subgroup) == BUILDINGS._menuB) && (!_loc10_.block || InventoryManager.buildingStorageCount(int(_loc10_.id))))
            {
               if(_loc8_ >= 10 * BUILDINGS._page && _loc8_ < 10 + 10 * BUILDINGS._page)
               {
                  (_loc11_ = this._thumbnailsMC.addChild(new BUILDINGBUTTON()) as BUILDINGBUTTON).x = _loc5_ * 130;
                  _loc11_.y = _loc6_ * 170;
                  _loc11_.Setup(int(_loc10_.id));
                  _loc5_++;
                  if(_loc5_ == 5)
                  {
                     _loc5_ = 0;
                     _loc6_++;
                  }
                  if(_loc6_ == 2)
                  {
                     _loc6_ = 0;
                  }
               }
               _loc8_++;
            }
            param2++;
         }
         var _loc9_:BUILDINGBUTTONSOON;
         (_loc9_ = new BUILDINGBUTTONSOON()).t.htmlText = KEYS.Get("building_coming_soon");
         if(_loc8_ == 0)
         {
            this._thumbnailsMC.addChild(_loc9_);
         }
         this._pageCount = Math.ceil(_loc8_ / 10);
         if(BUILDINGS._page > 0)
         {
            bPrevious.Trigger(true);
         }
         else
         {
            bPrevious.Trigger(false);
         }
         if(BUILDINGS._page < this._pageCount - 1 && TUTORIAL._stage >= 200)
         {
            bNext.Trigger(true);
         }
         else
         {
            bNext.Trigger(false);
         }
      }
      
      public function SortBuildings(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BFOUNDATION = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if((_loc5_ = param1[_loc4_]).group == BUILDINGS._menuA && (_loc5_.subgroup == null || _loc5_.subgroup == BUILDINGS._menuB) && (!_loc5_.block || InventoryManager.buildingStorageCount(_loc5_.id)))
            {
               _loc3_ = GLOBAL._buildingProps[_loc5_.id - 1];
               if(_loc3_.type != "decoration")
               {
                  _loc7_ = (_loc6_ = GLOBAL.GetBuildingTownHallLevel(_loc3_)) < _loc3_.quantity.length ? int(_loc3_.quantity[_loc6_]) : int(_loc3_.quantity[_loc3_.quantity.length - 1]);
                  _loc8_ = 0;
                  _loc3_.buildStatus = 1;
                  for each(_loc9_ in _loc2_)
                  {
                     if(_loc9_._type == _loc5_.id)
                     {
                        _loc8_++;
                     }
                  }
                  if(_loc8_ <= 0 && Boolean(_loc3_.upgradeImgData))
                  {
                     _loc11_ = int.MAX_VALUE;
                     for(_loc12_ in _loc3_.upgradeImgData)
                     {
                        if(!isNaN(Number(_loc12_)))
                        {
                           _loc11_ = Math.min(_loc11_,Number(_loc12_));
                        }
                     }
                     if(_loc11_ != int.MAX_VALUE && _loc3_.upgradeImgData[_loc11_].silhouette_img && !BASE.HasRequirements(_loc3_.costs[0]) && !_loc3_.rewarded)
                     {
                        _loc3_.buildStatus = 2;
                     }
                  }
                  else if(_loc8_ >= _loc7_)
                  {
                     _loc3_.buildStatus = 3;
                  }
                  _loc10_ = Math.max.apply(Math,_loc3_.quantity);
                  if(_loc8_ >= _loc10_ && _loc10_ > 0)
                  {
                     _loc3_.buildStatus = 4;
                  }
               }
            }
            _loc4_++;
         }
         param1.sortOn(["buildStatus","order"],Array.NUMERIC);
      }
      
      public function SubMenu(param1:Array) : void
      {
         var _loc4_:Button = null;
         if(this._subButtonsMC)
         {
            this.removeChild(this._subButtonsMC);
         }
         this._subButtonsMC = this.addChild(new MovieClip()) as MovieClip;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            (_loc4_ = this._subButtonsMC.addChild(new Button_CLIP()) as Button_CLIP).x = _loc3_ * 110;
            _loc4_.width = 105;
            _loc4_.Setup(param1[_loc3_]);
            _loc2_.push(_loc4_);
            _loc4_.addEventListener(MouseEvent.CLICK,this.Switch(BUILDINGS._menuA,_loc3_,0));
            if(_loc3_ == BUILDINGS._menuB)
            {
               _loc4_.Highlight = true;
            }
            _loc3_++;
         }
         this._subButtonsMC.x = 380 - this._subButtonsMC.width / 2;
         this._subButtonsMC.y = 75 + 25;
      }
      
      public function ShowInfo(param1:int) : void
      {
         BUILDINGS._buildingID = param1;
         if(this._buildingInfoMC)
         {
            this._buildingInfoMC.parent.removeChild(this._buildingInfoMC);
         }
         GLOBAL.BlockerAdd();
         this._buildingInfoMC = GLOBAL._layerWindows.addChild(new BUILDINGOPTIONSPOPUP("build",param1)) as BUILDINGOPTIONSPOPUP;
         this._buildingInfoMC.x = GLOBAL._SCREENCENTER.x;
         this._buildingInfoMC.y = GLOBAL._SCREENCENTER.y;
      }
      
      public function HideInfo() : void
      {
         if(this._buildingInfoMC)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            this._buildingInfoMC.parent.removeChild(this._buildingInfoMC);
            this._buildingInfoMC = null;
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         BUILDINGS.Hide();
      }
      
      public function Previous(param1:MouseEvent = null) : void
      {
         if(BUILDINGS._page > 0)
         {
            --BUILDINGS._page;
            this.SwitchB(BUILDINGS._menuA,BUILDINGS._menuB,BUILDINGS._page);
            SOUNDS.Play("click1");
         }
      }
      
      public function Next(param1:MouseEvent = null) : void
      {
         if(BUILDINGS._page < this._pageCount - 1)
         {
            ++BUILDINGS._page;
            this.SwitchB(BUILDINGS._menuA,BUILDINGS._menuB,BUILDINGS._page);
            SOUNDS.Play("click1");
         }
      }
      
      public function Center() : void
      {
         if (Capabilities.playerType == "Desktop") 
         {
            POPUPSETTINGS.AlignToCenter(this);
            this.x = -300;
            this.y = -220;
         }
         else 
         {
            POPUPSETTINGS.AlignToUpperLeft(this);
         }
      }
      
      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}

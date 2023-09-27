package com.monsters.missions
{
   import com.monsters.display.ScrollSet;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import gs.easing.*;
   
   public class UI_MISSIONMENU extends UI_MISSIONMENU_CLIP
   {
       
      
      private var _counter:int;
      
      private var _prioritycounter:int;
      
      private var _CollectedMissions:Object;
      
      private var _CompletedMissions:Object;
      
      private var _PriorityMissions:Object;
      
      private var _ActiveMissions:Array;
      
      private var _Container:Sprite;
      
      private var _Missions:MovieClip;
      
      private var _PriorityContainer:Sprite;
      
      private var _Priority:MovieClip;
      
      private var _PriorityMask:Shape;
      
      private var _ScrollBar:ScrollSet;
      
      private var _numDisplayItems:int = 10;
      
      private var _numDisplaySlots:int = 4;
      
      private var _numPinnedItems:int = 1;
      
      private var _UI_OffsetY:Number = 10;
      
      private var _ItemPaddingY:Number = 2;
      
      public var _Width:Number = 380;
      
      public var _Height:Number = 208;
      
      private var _seperatePriorities:Boolean = true;
      
      private var _animating:Boolean = false;
      
      private var _windowState:int = 1;
      
      public var _alertsCounter:int;
      
      public var _disableMissions:Boolean = false;
      
      private var _skinTag:int = 1;
      
      public var _enabled:Boolean = false;
      
      public var _maximized:Boolean = false;
      
      public var _open:Boolean = true;
      
      private var _skinnedElements:Array;
      
      private var _originProps:Object;
      
      private var _maxProps:Object;
      
      private var _openProps:Object;
      
      private var _closeProps:Object;
      
      private var _chatWidthDefault:Object;
      
      public function UI_MISSIONMENU()
      {
         this._skinnedElements = [];
         this._originProps = {
            "screenHeight":240,
            "screenWidth":400
         };
         this._maxProps = {
            "screenHeight":470,
            "maskHeight":470 - 12,
            "y":-(470 + 30),
            "scrollerY":-470,
            "scrollHeight":470 - 16,
            "footerY":-12
         };
         this._openProps = {
            "screenHeight":240,
            "maskHeight":136,
            "y":-178,
            "scrollerY":-148,
            "scrollHeight":120,
            "footerY":-12
         };
         this._closeProps = {
            "screenHeight":114,
            "maskHeight":105,
            "y":0,
            "scrollerY":30,
            "scrollHeight":105,
            "footerY":27
         };
         this._chatWidthDefault = {
            "sizeW":380,
            "headerW":380,
            "headerX":-5,
            "titleTxtX":70,
            "alertX":220,
            "arrowUpX":343,
            "arrowUpY":16,
            "arrowDownX":325,
            "arrowDownY":13,
            "borderW":380,
            "mcMaskW":348,
            "tOutputW":330,
            "mcScreenW":350,
            "inputWoodBgW":380,
            "inputTxtBgW":310,
            "inputTxtW":310,
            "sendBtnX":331,
            "scrollerX":347,
            "ignoreBtnX":315
         };
         super();
         frame.tTitle.htmlText = KEYS.Get("quests_title");
         this._CollectedMissions = {};
         this._CompletedMissions = {};
         this._PriorityMissions = {};
         this._ActiveMissions = [];
         this._skinnedElements = [this.frame.border,this.frame.header,this.frame.mcScreen.canvas,this.footer];
         if(GLOBAL.StatGet("missionmin") == 1)
         {
            this._open = false;
            this._maximized = false;
            this._enabled = true;
         }
         else
         {
            this._open = true;
            this._maximized = false;
         }
         this.frame.mcMask.height = this._numDisplaySlots * (32 + this._ItemPaddingY);
         this._Container = new Sprite();
         this._Container.x = this.frame.mcScreen.x;
         this._Container.y = this.frame.mcScreen.y;
         this._Container.mask = this.frame.mcMask;
         this.frame.addChild(this._Container);
         this._Missions = new MovieClip();
         this._Container.addChild(this._Missions);
         this._ScrollBar = new ScrollSet();
         this.frame.addChild(this._ScrollBar);
         this._ScrollBar.Init(this._Container,this.frame.mcMask,0,30,this.frame.mcMask.height);
         this._ScrollBar.x = 380 - 16 - 16;
         this._ScrollBar.y = 30;
         this._ScrollBar.AutoHideEnabled = false;
         this._PriorityMask = new Shape();
         this._PriorityMask.graphics.lineStyle();
         this._PriorityMask.graphics.beginFill(16777215,1);
         this._PriorityMask.graphics.drawRect(0,0,380 - 16 - 16,this._numPinnedItems * (32 + this._ItemPaddingY * (this._numPinnedItems - 1)));
         this._PriorityMask.graphics.endFill();
         this._PriorityMask.x = this.footer.x + 16;
         this._PriorityMask.y = this.footer.y + 5;
         this.addChild(this._PriorityMask);
         this._PriorityContainer = new Sprite();
         this._PriorityContainer.x = this._PriorityMask.x;
         this._PriorityContainer.y = this._PriorityMask.y;
         this._PriorityContainer.mask = this._PriorityMask;
         this.addChild(this._PriorityContainer);
         this._Priority = new MovieClip();
         this._PriorityContainer.addChild(this._Priority);
         this.CheckMissionsStatus();
         this.frame.arrowUp.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleHide);
         this.frame.arrowUp.mouseChildren = false;
         this.frame.arrowUp.buttonMode = true;
         this.frame.arrowUp.useHandCursor = true;
         this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
         this.frame.arrowUp.visible = false;
         this.frame.arrowDown.mouseChildren = false;
         this.frame.arrowDown.buttonMode = true;
         this.frame.arrowDown.useHandCursor = true;
         this.frame.arrowDown.gotoAndStop("on" + this._skinTag);
         this.frame.arrowDown.enabled = false;
         this.frame.arrowDown.visible = false;
         this.frame.mcToggle.addEventListener(MouseEvent.MOUSE_DOWN,this.OnDisableClick);
         this.frame.mcToggle.mouseChildren = false;
         this.frame.mcToggle.buttonMode = true;
         this.frame.mcToggle.useHandCursor = true;
         this.frame.mcToggle.gotoAndStop(this._enabled ? "on" + this._skinTag : "close" + this._skinTag);
         this.frame.mcToggle.visible = TUTORIAL.hasFinished;
         this.toggleHide();
      }
      
      public function Skin() : void
      {
         var _loc1_:int = 1;
         if(GLOBAL.InfernoMode())
         {
            _loc1_ = 2;
         }
         this._skinTag = _loc1_;
         var _loc2_:int = 0;
         while(_loc2_ < this._skinnedElements.length)
         {
            this._skinnedElements[_loc2_].gotoAndStop(_loc1_);
            _loc2_++;
         }
         this.frame.mcToggle.gotoAndStop(this._enabled ? "on" + this._skinTag : "close" + this._skinTag);
         this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
         this.frame.arrowDown.gotoAndStop("on" + this._skinTag);
      }
      
      public function Update() : void
      {
         this.Skin();
         if(!this.frame.mcToggle.visible && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            this.frame.mcToggle.visible = TUTORIAL.hasFinished;
         }
         if(GLOBAL._catchup)
         {
            return;
         }
         if(!this._open)
         {
            return;
         }
         this.CheckMissionsStatus();
      }
      
      public function AddItem(param1:String, param2:Boolean = false) : int
      {
         var _loc4_:MISSIONS_ITEM = null;
         var _loc3_:Object = QUESTS._quests[param1];
         if(!_loc3_.block)
         {
            _loc4_ = new MISSIONS_ITEM(param1);
            if(param2)
            {
               this._Priority.addChild(_loc4_);
               _loc4_.y = (_loc4_._Height + this._ItemPaddingY) * this._prioritycounter;
               _loc4_.bg.gotoAndStop("shiny" + this._skinTag);
            }
            else
            {
               this._Missions.addChild(_loc4_);
               _loc4_.y = (_loc4_._Height + this._ItemPaddingY) * this._counter;
            }
            if(this._counter % 2 == 0)
            {
               _loc4_.bg.gotoAndStop("off" + this._skinTag);
            }
            else
            {
               _loc4_.bg.gotoAndStop("on" + this._skinTag);
            }
            if(param2)
            {
               _loc4_.bg.gotoAndStop("shiny" + this._skinTag);
               _loc4_.bg.height = _loc4_._Height;
            }
            this._ActiveMissions.push(_loc4_);
            return 1;
         }
         return 0;
      }
      
      public function CheckMissionsStatus() : void
      {
         var _loc1_:String = null;
         var _loc3_:String = null;
         if(!GLOBAL.isAtHome())
         {
            this._disableMissions = true;
         }
         else if(MapRoomManager.instance.isInMapRoom2or3 && MapRoomManager.instance.isOpen)
         {
            this._disableMissions = true;
         }
         else
         {
            this._disableMissions = false;
         }
         if(this._disableMissions)
         {
            this.RefreshMissions(this._disableMissions);
            return;
         }
         if(!this._open)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(QUESTS._completed)
         {
            for(_loc1_ in QUESTS._quests)
            {
               _loc3_ = String(QUESTS._quests[_loc1_].id);
               if(QUESTS._completed[_loc3_])
               {
                  if(QUESTS._completed[_loc3_] == 1)
                  {
                     if(_loc1_ in this._CompletedMissions == false && !this._CompletedMissions[_loc3_])
                     {
                        this._CompletedMissions[_loc3_] = true;
                        _loc2_ = true;
                     }
                  }
                  else if(QUESTS._completed[_loc3_] == 2)
                  {
                     if(_loc1_ in this._CollectedMissions == false && !this._CollectedMissions[_loc3_])
                     {
                        this._CollectedMissions[_loc3_] = true;
                        _loc2_ = true;
                     }
                  }
               }
            }
            if(_loc2_ && this._open)
            {
               this.RebuildContainer();
            }
         }
      }
      
      public function Clear() : void
      {
         if(Boolean(this._Container) && Boolean(this._Missions))
         {
            this._Container.removeChild(this._Missions);
            this._Missions = new MovieClip();
            this._Container.addChild(this._Missions);
         }
         if(Boolean(this._PriorityContainer) && Boolean(this._Priority))
         {
            this._PriorityContainer.removeChild(this._Priority);
            this._Priority = new MovieClip();
            this._PriorityContainer.addChild(this._Priority);
         }
         this._ActiveMissions = [];
         this._counter = 0;
         this._prioritycounter = 0;
      }
      
      private function RebuildContainer() : void
      {
         var _loc1_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         this.Clear();
         if(QUESTS._completed)
         {
            for(_loc1_ in QUESTS._quests)
            {
               _loc5_ = String(QUESTS._quests[_loc1_].id);
               if(QUESTS._completed[_loc5_] && QUESTS._completed[_loc5_] == 1 && (!QUESTS._quests[_loc1_].prereq || QUESTS._completed[QUESTS._quests[_loc1_].prereq] == 2))
               {
                  _loc2_.push({
                     "missionID":_loc1_,
                     "order":QUESTS._quests[_loc1_].order
                  });
               }
            }
            _loc2_.sortOn("order",Array.NUMERIC);
         }
         for(_loc1_ in QUESTS._quests)
         {
            _loc5_ = String(QUESTS._quests[_loc1_].id);
            if(!QUESTS._completed[_loc5_] && (!QUESTS._quests[_loc1_].prereq || QUESTS._completed[QUESTS._quests[_loc1_].prereq] == 2))
            {
               _loc3_.push({
                  "missionID":_loc1_,
                  "order":QUESTS._quests[_loc1_].order
               });
               if(QUESTS._quests[_loc1_].priority == 1)
               {
                  _loc4_.push({
                     "missionID":_loc1_,
                     "order":QUESTS._quests[_loc1_].order
                  });
               }
            }
            _loc3_.sortOn("order",Array.NUMERIC);
            if(_loc4_.length > 1)
            {
               _loc4_.sortOn("order",Array.NUMERIC);
            }
         }
         if(_loc4_.length < 1 && GLOBAL.mode == GLOBAL._loadmode)
         {
            this.frame.mcMask.height = (this._numDisplaySlots + 1) * (32 + this._ItemPaddingY);
         }
         else
         {
            this.frame.mcMask.height = this._numDisplaySlots * (32 + this._ItemPaddingY);
         }
         this._ScrollBar.Update();
         this.frame.y = this._openProps.y;
         this.footer.y = this._openProps.footerY;
         var _loc7_:int = int(_loc2_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            this._counter += this.AddItem(_loc2_[_loc6_].missionID);
            _loc6_++;
         }
         _loc7_ = int(_loc4_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(!(this._seperatePriorities && this._prioritycounter >= this._numPinnedItems))
            {
               this._prioritycounter += this.AddItem(_loc4_[_loc6_].missionID,true);
            }
            _loc6_++;
         }
         var _loc8_:int = this._counter;
         var _loc9_:Boolean = true;
         _loc7_ = int(_loc3_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc9_ = true;
            if(this._numDisplayItems == 0 || this._counter - _loc8_ < this._numDisplayItems)
            {
               if(this._seperatePriorities)
               {
                  _loc10_ = 0;
                  while(_loc10_ < this._prioritycounter)
                  {
                     if(_loc4_[_loc10_].missionID == _loc3_[_loc6_].missionID)
                     {
                        _loc9_ = false;
                     }
                     _loc10_++;
                  }
               }
               if(_loc9_)
               {
                  this._counter += this.AddItem(_loc3_[_loc6_].missionID);
               }
            }
            _loc6_++;
         }
         addChild(this._ScrollBar);
         this._ScrollBar.Update();
      }
      
      public function RefreshMissions(param1:Boolean = false) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < this._ActiveMissions.length)
         {
            (this._ActiveMissions[_loc2_] as MISSIONS_ITEM).Init(param1);
            _loc2_++;
         }
      }
      
      private function toggleHide(param1:MouseEvent = null) : void
      {
         var _loc4_:Object = null;
         this.CheckMissionsStatus();
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1 != null)
         {
            if(param1.currentTarget == this.frame.arrowUp)
            {
               if(this._maximized)
               {
                  _loc2_ = false;
               }
               else
               {
                  _loc2_ = true;
               }
            }
            if(param1.currentTarget == this.frame.mcToggle)
            {
               if(this._open)
               {
                  _loc2_ = false;
                  this._maximized = false;
               }
               else
               {
                  _loc2_ = true;
                  this._maximized = false;
               }
            }
         }
         if(this._animating)
         {
            return;
         }
         if(!this._open)
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               SOUNDS.Play("iquestshow");
            }
            else
            {
               SOUNDS.Play("click1");
            }
         }
         else if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.Play("iquesthide");
         }
         else
         {
            SOUNDS.Play("close");
         }
         var _loc5_:Number = 0.5;
         if(param1 == null)
         {
            if(this._open)
            {
               _loc4_ = this._openProps;
            }
            else
            {
               _loc4_ = this._closeProps;
            }
            this._maximized = false;
            this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
            this.frame.arrowDown.gotoAndStop("off" + this._skinTag);
            this.frame.arrowUp.buttonMode = true;
            this.frame.arrowDown.buttonMode = false;
         }
         else if(this._maximized && this._open)
         {
            if(!(!_loc2_ && !_loc3_))
            {
               return;
            }
            _loc4_ = this._openProps;
            this._maximized = false;
            this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
            this.frame.arrowDown.gotoAndStop("on" + this._skinTag);
            this.frame.arrowUp.buttonMode = true;
            this.frame.arrowDown.buttonMode = true;
            GLOBAL.StatSet("missionmin",0);
         }
         else if(this._open)
         {
            if(!_loc2_)
            {
               _loc4_ = this._closeProps;
               this._maximized = false;
               this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
               this.frame.arrowDown.gotoAndStop("off" + this._skinTag);
               this.frame.arrowUp.buttonMode = true;
               this.frame.arrowDown.buttonMode = false;
               GLOBAL.StatSet("missionmin",1);
            }
            else if(_loc2_)
            {
               _loc4_ = this._maxProps;
               this._maximized = true;
               this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
               this.frame.arrowDown.gotoAndStop("on" + this._skinTag);
               this.frame.arrowUp.buttonMode = true;
               this.frame.arrowDown.buttonMode = false;
               GLOBAL.StatSet("missionmin",0);
            }
            else if(_loc3_)
            {
               return;
            }
         }
         else if(!this._open)
         {
            if(!(_loc2_ || _loc3_))
            {
               return;
            }
            _loc4_ = this._openProps;
            this._maximized = false;
            this.frame.arrowUp.gotoAndStop("on" + this._skinTag);
            this.frame.arrowDown.gotoAndStop("on" + this._skinTag);
            this.frame.arrowUp.buttonMode = true;
            this.frame.arrowDown.buttonMode = true;
            GLOBAL.StatSet("missionmin",0);
         }
         if(_loc4_ == null)
         {
            return;
         }
         this._ScrollBar.visible = false;
         TweenLite.to(this.frame,_loc5_,{
            "y":_loc4_.y,
            "onUpdate":this.toggleOnUpdate,
            "onComplete":this.toggleVisibleB
         });
         TweenLite.to(this.frame.mcScreen,_loc5_,{"height":_loc4_.screenHeight});
         TweenLite.to(this.frame.mcMask,_loc5_,{"height":_loc4_.maskHeight});
         TweenLite.to(this._ScrollBar,_loc5_,{"y":_loc4_.scrollerY});
         this._animating = true;
         this._open = _loc4_ != this._closeProps;
         var _loc6_:int = this._open ? 1 : 0;
         if(this._open)
         {
            if(!this._counter)
            {
               this.RebuildContainer();
               this.CheckMissionsStatus();
            }
            this.RefreshMissions(this._disableMissions);
            TweenLite.to(this.footer,_loc5_,{
               "y":_loc4_.footerY,
               "autoAlpha":1,
               "ease":Expo.easeOut
            });
            TweenLite.to(this._PriorityMask,_loc5_,{
               "autoAlpha":1,
               "ease":Expo.easeOut
            });
            TweenLite.to(this._PriorityContainer,_loc5_,{
               "autoAlpha":1,
               "ease":Expo.easeOut
            });
         }
         else
         {
            TweenLite.to(this.footer,_loc5_,{
               "y":_loc4_.footerY,
               "autoAlpha":0,
               "ease":Quad.easeIn
            });
            TweenLite.to(this._PriorityMask,_loc5_,{
               "autoAlpha":0,
               "ease":Expo.easeOut
            });
            TweenLite.to(this._PriorityContainer,_loc5_,{
               "autoAlpha":0,
               "ease":Expo.easeOut
            });
         }
      }
      
      private function toggleOnUpdate() : void
      {
         UI_BOTTOM.Resize();
      }
      
      private function toggleVisibleB() : void
      {
         this._animating = false;
         var _loc1_:Object = this._maximized ? this._maxProps : this._openProps;
         this._ScrollBar.Update();
         this._ScrollBar.visible = this._Container.height > this.frame.mcMask.height;
         this._PriorityMask.x = this.footer.x + 16;
         this._PriorityMask.y = this.footer.y + 5;
         this._PriorityContainer.x = this._PriorityMask.x;
         this._PriorityContainer.y = this._PriorityMask.y;
         if(!this._open)
         {
            this._ScrollBar.visible = false;
         }
         else
         {
            this._ScrollBar.visible = true;
            this._ScrollBar.ScrollTo(0,true);
         }
         UI_BOTTOM.Resize();
      }
      
      private function OnDisableClick(param1:MouseEvent = null) : void
      {
         if(param1 && param1.currentTarget == this.frame.mcToggle && TUTORIAL.hasFinished)
         {
            this._enabled = !this._enabled;
         }
         if(TUTORIAL.hasFinished)
         {
            if(!this._enabled)
            {
               this._open = false;
            }
            else
            {
               this._open = true;
            }
            this.frame.mcToggle.gotoAndStop(this._enabled ? "on" + this._skinTag : "close" + this._skinTag);
            this.toggleHide(param1);
         }
      }
      
      public function Resize() : void
      {
         x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - this._Width;
         y = GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - 30;
         if(this._open)
         {
            this.CheckMissionsStatus();
            this.RefreshMissions(this._disableMissions);
         }
      }
   }
}

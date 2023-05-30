package com.monsters.maproom3
{
   import com.monsters.display.ImageCache;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gs.TweenLite;
   
   public class MapRoom3Tutorial
   {
      
      private static const k_ID_START:uint = 0;
      
      private static const k_ID_HALFWAY:uint = 1;
      
      private static const k_ID_FINISHED:uint = 2;
      
      public static const k_STEP_OPENMAP:uint = 0;
      
      public static const k_STEP_CLICKWM:uint = 1;
      
      public static const k_STEP_SCOUTWM:uint = 2;
      
      public static const k_STEP_ATTACKWM:uint = 3;
      
      public static const k_STEP_HOLD:uint = 4;
      
      public static const k_STEP_COUNQURED:uint = 5;
      
      public static const k_STEP_FORTIFICATION_ARM:uint = 6;
      
      public static const k_STEP_FINISHED:uint = 7;
      
      public static const k_MAX_STEP:uint = 8;
      
      private static var m_instance:com.monsters.maproom3.MapRoom3Tutorial;
       
      
      private var m_started:Boolean;
      
      private var m_tutorialStep:uint;
      
      private var m_currImageUrl:String;
      
      private var m_bigPopup:popup_mr2tutorial;
      
      private var m_tutorialId:uint;
      
      private var m_target:Object;
      
      public function MapRoom3Tutorial(param1:InstanceEnforcer)
      {
         super();
         if(!param1)
         {
            throw new Error(this + " must be used as a singleton.");
         }
      }
      
      public static function get instance() : com.monsters.maproom3.MapRoom3Tutorial
      {
         m_instance = m_instance || new com.monsters.maproom3.MapRoom3Tutorial(new InstanceEnforcer());
         return m_instance;
      }
      
      public function get tutorialId() : uint
      {
         return this.m_tutorialId;
      }
      
      public function get tutorialStep() : uint
      {
         return this.m_tutorialStep;
      }
      
      public function get allowScrolling() : Boolean
      {
         return !this.m_started || this.m_tutorialStep < k_STEP_CLICKWM || this.m_tutorialStep > k_STEP_ATTACKWM;
      }
      
      public function get isStarted() : Boolean
      {
         return this.m_started;
      }
      
      public function get isHolding() : Boolean
      {
         return this.m_tutorialStep === k_STEP_HOLD;
      }
      
      public function isClickableCell(param1:MapRoom3Cell) : Boolean
      {
         return !this.m_target || param1 == this.m_target || TUTORIAL.hasFinished;
      }
      
      public function importData(param1:Object) : void
      {
      }
      
      public function update() : void
      {
         var _loc1_:MapRoom3Cell = null;
         var _loc2_:Vector.<MapRoom3Cell> = null;
         var _loc3_:MapRoom3CellMouseover = null;
         switch(this.m_tutorialStep)
         {
            case k_STEP_OPENMAP:
               BASE.BuildingDeselect();
               TUTORIAL.Add(6,TUTORIAL.BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step33"),TUTORIAL.POINT_MAP,["mc",UI_BOTTOM._mc.bMap,new Point(15,15),-30],false,false,this.openedMapRoom);
               break;
            case k_STEP_CLICKWM:
               if(!MapRoomManager.instance.isOpen || !MapRoomManager.instance.isInMapRoom3)
               {
                  break;
               }
               TUTORIAL._container = MapRoom3.mapRoom3Window.scrollingCanvas;
               this.m_target = null;
               _loc2_ = MapRoomManager.instance.GetHexCellsInRange(GLOBAL._mapHome.x,GLOBAL._mapHome.y,1);
               for each(_loc1_ in _loc2_)
               {
                  if(_loc1_.cellType === EnumYardType.FORTIFICATION && (!this.m_target || _loc1_.baseLevel < (this.m_target as MapRoom3Cell).baseLevel))
                  {
                     if(_loc1_.isOwnedByPlayer)
                     {
                        TUTORIAL._container = GLOBAL._layerMessages;
                        TUTORIAL.Add(6,TUTORIAL.BOBBOTTOMLEFTLOW,KEYS.Get("btn_returnhome"),TUTORIAL.POINT_MAP,["mc",UI_BOTTOM._mc.bMap,new Point(15,15),-30],false,false,this.returnedHome);
                        this.m_target = null;
                        break;
                     }
                     this.m_target = _loc1_;
                  }
               }
               if(this.m_target)
               {
                  TUTORIAL.Add(6,new Point(this.m_target.cellGraphic.x + GLOBAL._SCREEN.width / 2 - 160,this.m_target.cellGraphic.y),KEYS.Get("tut_NWM_Step_2"),new Point(this.m_target.cellGraphic.x + this.m_target.cellGraphic.width * 0.5,this.m_target.cellGraphic.y + this.m_target.cellGraphic.height * 0.5),[],false,false,this.clickWMBase,null);
                  TUTORIAL._mcArrow.alpha = 0;
                  TweenLite.to(TUTORIAL._mcArrow,0.75,{
                     "autoAlpha":1,
                     "delay":0.5,
                     "overwrite":1
                  });
                  MapRoom3.mapRoom3Window.NavigateToCell(this.m_target as MapRoom3Cell);
               }
               break;
            case k_STEP_SCOUTWM:
               if(!MapRoomManager.instance.isOpen)
               {
                  break;
               }
               if(!MapRoom3.mapRoom3Window.mouseoverInfo || !MapRoom3.mapRoom3Window.mouseoverInfo.visible)
               {
                  this.rewind();
               }
               else
               {
                  TUTORIAL._container = GLOBAL._layerMessages;
                  _loc3_ = MapRoom3.mapRoom3Window.mouseoverInfo;
                  TUTORIAL.Add(6,new Point(100,160),KEYS.Get("tut_NWM_Step_3"),new Point(_loc3_.x,_loc3_.y + 100),["mc",_loc3_.scoutAttackButton,new Point(15,15),100],false,false,this.scoutWMBase,this.failScoutWMBase);
                  TUTORIAL._mcArrow.alpha = 0;
                  TweenLite.to(TUTORIAL._mcArrow,0.75,{
                     "autoAlpha":1,
                     "delay":0.5,
                     "overwrite":1
                  });
               }
               break;
            case k_STEP_ATTACKWM:
               MAP.Focus(-200,0);
               MAP.FocusTo(200,0,5,0,0,false);
               TUTORIAL.Add(6,TUTORIAL.BOBBOTTOMLEFTLOW,KEYS.Get("tut_NWM_Step_4"),TUTORIAL.POINT_MAP,["mc",UI_VISITOR.mc.bAttack,new Point(15,15),-30],false,false,this.attackWMBase);
               break;
            case k_STEP_HOLD:
               this.m_target = null;
               break;
            case k_STEP_COUNQURED:
               if(!MapRoomManager.instance.isOpen)
               {
                  this.rewind();
               }
               else
               {
                  TUTORIAL._container = MapRoom3.mapRoom3Window.scrollingCanvas;
                  this.m_target = null;
                  _loc2_ = MapRoomManager.instance.GetHexCellsInRange(GLOBAL._mapHome.x,GLOBAL._mapHome.y,1);
                  for each(_loc1_ in _loc2_)
                  {
                     if(_loc1_.cellType === EnumYardType.FORTIFICATION && (!this.m_target || _loc1_.baseLevel < (this.m_target as MapRoom3Cell).baseLevel))
                     {
                        this.m_target = _loc1_;
                     }
                  }
                  if(this.m_target)
                  {
                     TUTORIAL.Add(6,new Point(this.m_target.cellGraphic.x - 100,this.m_target.cellGraphic.y + 200),KEYS.Get("tut_NWM_Step_8"),new Point(this.m_target.cellGraphic.x + this.m_target.cellGraphic.width * 0.5,this.m_target.cellGraphic.y),[],true,false,null,null);
                     TUTORIAL._mcArrow.alpha = 0;
                     TweenLite.to(TUTORIAL._mcArrow,0.75,{
                        "autoAlpha":1,
                        "delay":1,
                        "overwrite":1
                     });
                     MapRoom3.mapRoom3Window.NavigateToCell(this.m_target as MapRoom3Cell);
                  }
               }
               break;
            case k_STEP_FORTIFICATION_ARM:
               TUTORIAL._container = MapRoom3.mapRoom3Window.scrollingCanvas;
               this.m_target = null;
               _loc2_ = MapRoomManager.instance.GetHexCellsInRange(GLOBAL._mapHome.x,GLOBAL._mapHome.y,1);
               for each(_loc1_ in _loc2_)
               {
                  if(_loc1_.cellType === EnumYardType.FORTIFICATION && (!this.m_target || _loc1_.baseLevel < (this.m_target as MapRoom3Cell).baseLevel))
                  {
                     this.m_target = _loc1_;
                  }
               }
               if(this.m_target)
               {
                  TUTORIAL.Add(6,new Point(this.m_target.cellGraphic.x - 100,this.m_target.cellGraphic.y + 200),KEYS.Get("tut_NWM_Step_8"),new Point(this.m_target.cellGraphic.x + this.m_target.cellGraphic.width * 0.5,this.m_target.cellGraphic.y),[],true,false,null,null);
                  TUTORIAL._mcArrow.alpha = 0;
                  TweenLite.to(TUTORIAL._mcArrow,0.75,{
                     "autoAlpha":1,
                     "delay":1,
                     "overwrite":1
                  });
                  MapRoom3.mapRoom3Window.NavigateToCell(this.m_target as MapRoom3Cell);
               }
         }
      }
      
      private function openedMapRoom() : void
      {
         var _loc1_:MapRoom3Cell = GLOBAL._currentCell as MapRoom3Cell;
         if(MapRoomManager.instance.isOpen && _loc1_ && _loc1_.isDataLoaded)
         {
            this.advance();
         }
      }
      
      private function returnedHome() : void
      {
         if(!MapRoomManager.instance.isOpen && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            this.finish();
         }
      }
      
      private function clickWMBase() : void
      {
         var _loc1_:MapRoom3CellMouseover = MapRoom3.mapRoom3Window.mouseoverInfo;
         if(_loc1_ && _loc1_.visible && _loc1_.scoutAttackButton.parent && _loc1_.scoutAttackButton.parent.visible && _loc1_.selectedCell == this.m_target)
         {
            this.advance();
         }
      }
      
      private function scoutWMBase() : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW)
         {
            TUTORIAL._container = GLOBAL._layerMessages;
            this.advance();
         }
      }
      
      private function failScoutWMBase() : void
      {
         if(!MapRoom3.mapRoom3Window.mouseoverInfo || !MapRoom3.mapRoom3Window.mouseoverInfo.visible)
         {
            this.rewind();
         }
      }
      
      private function attackWMBase() : void
      {
         if(GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK)
         {
            this.advance();
            TUTORIAL._stage = 111;
            TUTORIAL.Advance();
         }
      }
      
      private function closedMapRoom() : void
      {
         if(!MapRoomManager.instance.isOpen)
         {
            TUTORIAL._container = GLOBAL._layerMessages;
            this.m_tutorialStep = 0;
            TUTORIAL._stage = 99;
            TUTORIAL.Advance();
         }
      }
      
      public function advance(param1:Event = null) : void
      {
         ++this.m_tutorialStep;
         TUTORIAL.clearStage();
         this.update();
      }
      
      private function rewind() : void
      {
         --this.m_tutorialStep;
         TUTORIAL.clearStage();
         this.update();
      }
      
      private function showBigDialog(param1:String, param2:String) : void
      {
         this.hideBigDialog();
         GLOBAL.BlockerAdd();
         SOUNDS.Play("click1");
         this.m_bigPopup = new popup_mr2tutorial();
         this.m_bigPopup.tBody.htmlText = param1;
         this.m_bigPopup.bAction.SetupKey("btn_continue");
         this.m_bigPopup.bAction.addEventListener(MouseEvent.CLICK,this.advance,false,0,true);
         this.m_bigPopup.bAction.Highlight = true;
         this.m_bigPopup.mcFrame.Setup(true,this.finish);
         this.m_currImageUrl = param2;
         ImageCache.GetImageWithCallBack(this.m_currImageUrl,this.imageLoaded);
         GLOBAL._layerTop.addChild(this.m_bigPopup);
         POPUPSETTINGS.AlignToCenter(this.m_bigPopup);
         POPUPSETTINGS.ScaleUp(this.m_bigPopup);
      }
      
      private function imageLoaded(param1:String, param2:BitmapData) : void
      {
         if(this.m_currImageUrl == param1)
         {
            this.m_bigPopup.mcImageContainer.addChild(new Bitmap(param2));
         }
      }
      
      private function showSmallDialog(param1:String) : void
      {
         this.hideBigDialog();
         this.m_currImageUrl = "";
         GLOBAL.Message(param1,KEYS.Get("btn_continue"),this.advance);
      }
      
      public function start() : void
      {
         if(!MapRoomManager.instance.isInMapRoom3 || this.m_tutorialStep >= k_STEP_FINISHED)
         {
            return;
         }
         this.m_started = true;
         this.update();
      }
      
      public function finish(param1:Event = null) : void
      {
         this.clear();
         TUTORIAL._stage = 129;
         TUTORIAL.Advance();
      }
      
      public function clear() : void
      {
         this.m_started = false;
         this.m_tutorialStep = k_STEP_FINISHED;
         this.m_tutorialId = k_ID_FINISHED;
         TUTORIAL._container = GLOBAL._layerMessages;
      }
      
      public function continueFromAttack() : void
      {
         this.m_tutorialStep = k_STEP_COUNQURED;
         this.update();
      }
      
      private function hideBigDialog() : void
      {
         if(this.m_bigPopup)
         {
            GLOBAL.BlockerRemove();
            GLOBAL._layerTop.removeChild(this.m_bigPopup);
            this.m_bigPopup = null;
         }
      }
   }
}

final class InstanceEnforcer
{
    
   
   public function InstanceEnforcer()
   {
      super();
   }
}

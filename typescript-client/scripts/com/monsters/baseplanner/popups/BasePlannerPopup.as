package com.monsters.baseplanner.popups
{
   import com.monsters.baseplanner.BasePlanner;
   import com.monsters.baseplanner.PlannerDesignView;
   import com.monsters.baseplanner.PlannerExplorer;
   import com.monsters.baseplanner.PlannerNode;
   import com.monsters.baseplanner.PlannerTemplate;
   import com.monsters.baseplanner.events.BasePlannerEvent;
   import com.monsters.baseplanner.events.BasePlannerNodeEvent;
   import com.monsters.baseplanner.popups.transfer.BasePlannerTransferConfirmation;
   import com.monsters.display.ScrollSetV;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   
   public class BasePlannerPopup extends Sprite
   {
      
      private static var _layoutSpacing:Point = new Point(10,10);
      
      private static var _layoutOffset:Point = new Point(0,0);
      
      public static const EXPLORER_BUILDING_CLICK:String = "explorer_click";
      
      public static const EXPLORER_UPDATE:String = "explorer_update";
      
      public static const DESIGN_CLEAR_EXPLORER:String = "design_explorer_clear";
      
      public static const DESIGN_BUILDING_STORE:String = "design_building_store";
      
      public static const DESIGN_BUILDING_PLACE:String = "design_building_place";
      
      public static const DESIGN_BUILDING_INVALID:String = "design_building_invalid";
      
      public static const DESIGN_TOOL_UPDATE:String = "design_tool_update";
      
      public static const PLANNER_HINT:String = "planner_hint";
      
      public static const PLANNER_HINT_HIDE:String = "planner_hide";
       
      
      public var mcFrame:frame;
      
      public var displayCanvas:BasePlannerPopup_DisplayViewContainer;
      
      public var sideBar:BasePlannerPopup_ExplorerContainer;
      
      private var sideBarScrollBar:ScrollSetV;
      
      public var sideBarHeader:BasePlannerPopup_ExplorerHeader;
      
      public var bottomMenu:BasePlannerPopup_BottomLayout;
      
      public var toolMenu:BasePlannerPopup_ToolsLayout;
      
      public var storeMenu:Sprite;
      
      public var inventoryMenu:Sprite;
      
      public var zoomMenu:BasePlannerPopup_ZoomLayout;
      
      public var toolTipMenu:BasePlannerPopup_ToolTip;
      
      public var buildingExplorer:PlannerExplorer;
      
      public var designView:PlannerDesignView;
      
      public var fullscreenButton:Sprite;
      
      private var _guideMC:BasePlannerPopup_CLIP;
      
      private var _mcFrame:Sprite;
      
      private var _plannerTemplate:PlannerTemplate;
      
      private var _hasBeenSaved:Boolean;
      
      private var _currentTool:String;
      
      private const _PLANNER_SIDEBAR_WIDTH:int = 190;
      
      private const _PLANNER_BOTTOMBAR_SPACING:int = 60;
      
      private const _PLANNER_TOP_MARGIN:int = 10;
      
      private const _PLANNER_BOTTOM_MARGIN:int = 5;
      
      private const _PLANNER_RIGHT_MARGIN:int = 10;
      
      private const _PLANNER_LEFT_MARGIN:int = 10;
      
      private const _PLANNER_HEADER_MARGIN:int = 32;
      
      private var _bSave:Button;
      
      private var _bApply:Button;
      
      private var _bLoad:Button;
      
      private var _bClear:Button;
      
      private var _isTemplateApplicable:Boolean = true;
      
      private var _confirmationPopup:BasePlannerTransferConfirmation;
      
      private var _clearConfirmationPopup:BasePlannerTransferConfirmation;
      
      public function BasePlannerPopup(param1:PlannerTemplate)
      {
         super();
         this._plannerTemplate = param1;
         this.setup();
         this.Resize();
      }
      
      public function setup() : void
      {
         this.configPopupTemplate();
         this.buildingExplorer.addEventListener(PlannerExplorer.EXPLORER_ITEM_CLICK,this.onExplorerItemClick);
         if(!BasePlanner.canSave)
         {
            this._bLoad.Enabled = false;
            this._bLoad.mouseEnabled = false;
            this._bSave.Enabled = false;
            this._bSave.mouseEnabled = false;
            this._bSave.mouseChildren = false;
            this._bSave.enabled = false;
         }
      }
      
      private function set canApply(param1:Boolean) : void
      {
         this._bApply.Enabled = param1;
         this._isTemplateApplicable = param1;
      }
      
      private function checkIfApplicable() : Boolean
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._plannerTemplate.inventoryData.length)
         {
            _loc2_ = this._plannerTemplate.inventoryData[_loc1_].category;
            if(_loc2_ != PlannerNode.TYPE_DECORATION && _loc2_ != PlannerNode.TYPE_MISC)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function redraw() : void
      {
         this.buildingExplorer.redraw();
         this.designView.redraw();
         this.sideBarScrollBar.checkResize();
      }
      
      public function configPopupTemplate(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:Point = null;
         var _loc6_:Checkbox = null;
         var _loc7_:Checkbox = null;
         var _loc8_:Checkbox = null;
         var _loc9_:Checkbox = null;
         if(!this._guideMC)
         {
            this._guideMC = new BasePlannerPopup_CLIP();
         }
         if(!this._mcFrame)
         {
            this._mcFrame = new Sprite();
            this.addChild(this._mcFrame);
         }
         if(!this.mcFrame)
         {
            this.mcFrame = new frame(false);
            this.mcFrame.addChild(this._guideMC.guideBG);
            this._mcFrame.addChild(this.mcFrame);
         }
         if(param1 != 0)
         {
            this._guideMC.guideBG.width = param1;
         }
         if(param2 != 0)
         {
            this._guideMC.guideBG.height = param2;
         }
         this.mcFrame.width = this._guideMC.guideBG.width;
         this.mcFrame.height = this._guideMC.guideBG.height;
         (this.mcFrame as frame).Setup(true,this.Hide);
         _loc3_ = new Point(this._PLANNER_LEFT_MARGIN,this._PLANNER_TOP_MARGIN);
         if(!this.sideBar)
         {
            this.sideBar = new BasePlannerPopup_ExplorerContainer();
         }
         this.sideBar.x = _layoutSpacing.x + _loc3_.x;
         this.sideBar.y = _layoutSpacing.y + _loc3_.y + this._PLANNER_HEADER_MARGIN;
         this.sideBar.mcScroller.visible = false;
         this.sideBar.mcframe.width = this._PLANNER_SIDEBAR_WIDTH;
         this.sideBar.mcframe.height = param2 - (this.sideBar.y + _layoutSpacing.y + this._PLANNER_BOTTOM_MARGIN);
         this.sideBar.canvasmask.width = this._PLANNER_SIDEBAR_WIDTH;
         this.sideBar.canvasmask.height = param2 - (this.sideBar.y + _layoutSpacing.y + this._PLANNER_BOTTOM_MARGIN);
         this.sideBar.bg.width = this._PLANNER_SIDEBAR_WIDTH;
         this.sideBar.bg.height = param2 - (this.sideBar.y + _layoutSpacing.y + this._PLANNER_BOTTOM_MARGIN);
         if(!this.sideBarHeader)
         {
            this.sideBarHeader = new BasePlannerPopup_ExplorerHeader();
         }
         this.sideBarHeader.tLabel.htmlText = KEYS.Get("basePlanner_explorerHeader");
         this.sideBarHeader.x = _layoutSpacing.x + _loc3_.x;
         this.sideBarHeader.y = _layoutSpacing.y + _loc3_.y;
         addChild(this.sideBarHeader);
         if(!this.buildingExplorer)
         {
            this.buildingExplorer = new PlannerExplorer(this._plannerTemplate.inventoryData);
            this.buildingExplorer.setup();
            this.buildingExplorer.addEventListener(BasePlannerPopup.EXPLORER_BUILDING_CLICK,this.onExplorerItemClick);
            this.buildingExplorer.addEventListener(BasePlannerPopup.PLANNER_HINT,this.onToolTipNodeHint);
            this.buildingExplorer.addEventListener(BasePlannerPopup.PLANNER_HINT_HIDE,this.onToolTipNodeHide);
            this.buildingExplorer.addEventListener(BasePlannerPopup.EXPLORER_UPDATE,this.onExplorerChange);
            this.buildingExplorer.x = 0;
            this.buildingExplorer.y = 0;
            this.sideBar.canvas.getChildAt(0).height = 0;
            this.sideBar.canvas.addChild(this.buildingExplorer);
         }
         _layoutOffset.x = this.sideBar.x + this.sideBar.canvasmask.width;
         _layoutOffset.y = this.sideBar.y + this.sideBar.canvasmask.height;
         this.addChild(this.sideBar);
         if(!this.sideBarScrollBar)
         {
            this.createExplorerScrollBar(this.sideBar.canvas);
         }
         else
         {
            this.sideBarScrollBar.checkResize();
            this.sideBarScrollBar.x = this.sideBar.canvas.x + this.sideBar.canvas.width - this.sideBarScrollBar.width + this._PLANNER_LEFT_MARGIN;
            this.sideBarScrollBar.y = this.sideBar.canvas.y + _layoutSpacing.y + this._PLANNER_TOP_MARGIN + this._PLANNER_HEADER_MARGIN;
            addChildAt(this.sideBarScrollBar,numChildren);
         }
         if(!this.displayCanvas)
         {
            this.displayCanvas = new BasePlannerPopup_DisplayViewContainer();
            this.addChild(this.displayCanvas);
         }
         if(param1 == 0)
         {
            param1 = this.mcFrame.width;
         }
         if(param2 == 0)
         {
            param2 = this.mcFrame.height;
         }
         this.displayCanvas.x = _layoutOffset.x;
         this.displayCanvas.y = _layoutSpacing.y + _loc3_.y;
         this.displayCanvas.mcframemask.width = param1 - (this.displayCanvas.x + _layoutSpacing.x + this._PLANNER_RIGHT_MARGIN);
         this.displayCanvas.mcframemask.height = param2 - (this.displayCanvas.y + _layoutSpacing.y - 1 + this._PLANNER_BOTTOM_MARGIN) - this._PLANNER_BOTTOMBAR_SPACING;
         this.displayCanvas.mcframe.width = param1 - (this.displayCanvas.x + _layoutSpacing.x + this._PLANNER_RIGHT_MARGIN);
         this.displayCanvas.mcframe.height = param2 - (this.displayCanvas.y + _layoutSpacing.y - 1 + this._PLANNER_BOTTOM_MARGIN) - this._PLANNER_BOTTOMBAR_SPACING;
         this.displayCanvas.canvasmask.width = param1 - (this.displayCanvas.x + _layoutSpacing.x + this._PLANNER_RIGHT_MARGIN);
         this.displayCanvas.canvasmask.height = param2 - (this.displayCanvas.y + _layoutSpacing.y + this._PLANNER_BOTTOM_MARGIN) - this._PLANNER_BOTTOMBAR_SPACING;
         if(!this.designView)
         {
            this.designView = new PlannerDesignView(this._plannerTemplate.displayData);
            this.designView.setup();
            this.designView.addEventListener(BasePlannerPopup.DESIGN_BUILDING_PLACE,this.onDesignItemPlace);
            this.designView.addEventListener(BasePlannerPopup.DESIGN_BUILDING_STORE,this.onDesignItemStore);
            this.designView.addEventListener(BasePlannerPopup.DESIGN_BUILDING_INVALID,this.onDesignItemInvalid);
            this.designView.addEventListener(BasePlannerPopup.DESIGN_CLEAR_EXPLORER,this.onClearExplorerSelections);
            this.designView.addEventListener(BasePlannerPopup.PLANNER_HINT,this.onToolTipNodeHint);
            this.designView.addEventListener(BasePlannerPopup.PLANNER_HINT_HIDE,this.onToolTipNodeHide);
            this.designView.addEventListener(BasePlannerPopup.DESIGN_TOOL_UPDATE,this.onToolUpdate);
            this.designView.addEventListener(PlannerDesignView.STATE_CHANGE,this.onDesignStateChange);
         }
         this.displayCanvas.canvas.addChild(this.designView);
         this.designView.recenter();
         if(!this.bottomMenu)
         {
            this.bottomMenu = new BasePlannerPopup_BottomLayout();
            this.addChild(this.bottomMenu);
            this._bSave = new Button_CLIP();
            this._bSave.x = this.bottomMenu.btnSave.x;
            this._bSave.y = this.bottomMenu.btnSave.y;
            this._bSave.width = this.bottomMenu.btnSave.width;
            this._bSave.height = this.bottomMenu.btnSave.height;
            this._bSave.SetupKey("basePlanner_btnSave");
            this._bSave.addEventListener(MouseEvent.CLICK,this.onSaveClick);
            this._bSave.addEventListener(MouseEvent.ROLL_OVER,this.onToolTipMouseHint(this.onToolTipHint,[KEYS.Get("basePlanner_saveTool")]));
            this._bSave.addEventListener(MouseEvent.ROLL_OUT,this.onToolTipHide);
            this.bottomMenu.addChild(this._bSave);
            this.bottomMenu.removeChild(this.bottomMenu.btnSave);
            if(!BasePlanner.canSave)
            {
               this._bSave.mouseEnabled = this._bSave.enabled = this._bSave.Enabled = false;
            }
            this._bLoad = new Button_CLIP();
            this._bLoad.x = this.bottomMenu.btnLoad.x;
            this._bLoad.y = this.bottomMenu.btnLoad.y;
            this._bLoad.width = this.bottomMenu.btnLoad.width;
            this._bLoad.height = this.bottomMenu.btnLoad.height;
            this._bLoad.SetupKey("basePlanner_btnLoad");
            this._bLoad.addEventListener(MouseEvent.CLICK,this.onLoadClick);
            this._bLoad.addEventListener(MouseEvent.ROLL_OVER,this.onToolTipMouseHint(this.onToolTipHint,[KEYS.Get("basePlanner_loadTool")]));
            this._bLoad.addEventListener(MouseEvent.ROLL_OUT,this.onToolTipHide);
            this.bottomMenu.addChild(this._bLoad);
            this.bottomMenu.removeChild(this.bottomMenu.btnLoad);
            if(!BasePlanner.canSave)
            {
               this._bLoad.mouseEnabled = this._bLoad.enabled = false;
            }
            this._bApply = new Button_CLIP();
            this._bApply.x = this.bottomMenu.btnApply.x;
            this._bApply.y = this.bottomMenu.btnApply.y;
            this._bApply.width = this.bottomMenu.btnApply.width;
            this._bApply.height = this.bottomMenu.btnApply.height;
            this._bApply.SetupKey("basePlanner_btnApply");
            this._bApply.addEventListener(MouseEvent.CLICK,this.onApplyClick);
            this._bApply.addEventListener(MouseEvent.ROLL_OVER,this.onToolTipMouseHint(this.onToolTipHint,[KEYS.Get("basePlanner_applyTool")]));
            this._bApply.addEventListener(MouseEvent.ROLL_OUT,this.onToolTipHide);
            this.bottomMenu.addChild(this._bApply);
            this.bottomMenu.removeChild(this.bottomMenu.btnApply);
            this._bClear = new Button_CLIP();
            this._bClear.x = this.bottomMenu.btnClear.x;
            this._bClear.y = this.bottomMenu.btnClear.y;
            this._bClear.width = this.bottomMenu.btnClear.width;
            this._bClear.height = this.bottomMenu.btnClear.height;
            this._bClear.SetupKey("basePlanner_btnClear");
            this._bClear.addEventListener(MouseEvent.CLICK,this.onClearClick);
            this._bClear.addEventListener(MouseEvent.ROLL_OVER,this.onToolTipMouseHint(this.onToolTipHint,[KEYS.Get("basePlanner_clearTool")]));
            this._bClear.addEventListener(MouseEvent.ROLL_OUT,this.onToolTipHide);
            this.bottomMenu.addChild(this._bClear);
            this.bottomMenu.removeChild(this.bottomMenu.btnClear);
            _loc6_ = Checkbox.Replace(this.bottomMenu.check1);
            this.bottomMenu.addChild(_loc6_);
            _loc6_.addEventListener(Checkbox.CHECK_EVENT,this.onCheckboxClick);
            (_loc7_ = Checkbox.Replace(this.bottomMenu.check2)).addEventListener(Checkbox.CHECK_EVENT,this.onCheckboxClick);
            this.bottomMenu.addChild(_loc7_);
            (_loc8_ = Checkbox.Replace(this.bottomMenu.check3)).addEventListener(Checkbox.CHECK_EVENT,this.onCheckboxClick);
            this.bottomMenu.addChild(_loc8_);
            if(this.bottomMenu.check4)
            {
               (_loc9_ = Checkbox.Replace(this.bottomMenu.check4)).addEventListener(Checkbox.CHECK_EVENT,this.onCheckboxClick);
               this.bottomMenu.addChild(_loc9_);
            }
            this.bottomMenu.check1_txt.htmlText = KEYS.Get("basePlanner_groundrange");
            this.bottomMenu.check2_txt.htmlText = KEYS.Get("basePlanner_aerialrange");
            this.bottomMenu.check3_txt.htmlText = KEYS.Get("basePlanner_minerange");
            if(this.bottomMenu.check4_txt)
            {
               this.bottomMenu.check4_txt.htmlText = KEYS.Get("basePlanner_moreinfo");
            }
         }
         var _loc4_:int = 520;
         this.bottomMenu.x = param1 - (_layoutSpacing.x + _loc4_) + _loc3_.x;
         this.bottomMenu.y = this.displayCanvas.y + this.displayCanvas.canvasmask.height;
         if(!this.toolMenu)
         {
            this.toolMenu = new BasePlannerPopup_ToolsLayout();
            this.addChild(this.toolMenu);
            this.toolMenu.mcSelectMove.gotoAndStop(1);
            this.toolMenu.mcSelectMove.buttonMode = true;
            this.toolMenu.mcSelectMove.addEventListener(MouseEvent.CLICK,this.onToolClick);
            this.toolMenu.mcSelectMove.addEventListener(MouseEvent.ROLL_OVER,this.onToolOver);
            this.toolMenu.mcSelectMove.addEventListener(MouseEvent.ROLL_OUT,this.onToolOut);
            this.toolMenu.mcStore.gotoAndStop(1);
            this.toolMenu.mcStore.buttonMode = true;
            this.toolMenu.mcStore.addEventListener(MouseEvent.CLICK,this.onToolClick);
            this.toolMenu.mcStore.addEventListener(MouseEvent.ROLL_OVER,this.onToolOver);
            this.toolMenu.mcStore.addEventListener(MouseEvent.ROLL_OUT,this.onToolOut);
            if(Boolean(STORE._storeData.ENL) && STORE._storeData.ENL.q == 6)
            {
               this.toolMenu.mcExpand.enabled = false;
               this.toolMenu.mcExpand.mouseEnabled = false;
               this.toolMenu.mcExpand.gotoAndStop("off");
            }
            else if(BASE.isMainYardOrInfernoMainYard)
            {
               this.toolMenu.mcExpand.gotoAndStop(1);
               this.toolMenu.mcExpand.buttonMode = true;
               this.toolMenu.mcExpand.addEventListener(MouseEvent.CLICK,this.onStoreOpen);
               this.toolMenu.mcExpand.addEventListener(MouseEvent.ROLL_OVER,this.onToolOver);
               this.toolMenu.mcExpand.addEventListener(MouseEvent.ROLL_OUT,this.onToolOut);
               this.toolMenu.mcExpand.visible = true;
            }
            else
            {
               this.toolMenu.mcExpand.visible = false;
            }
         }
         this.toolMenu.x = _layoutOffset.x + 50;
         this.toolMenu.y = _layoutSpacing.y + _loc3_.y;
         if(!this.zoomMenu)
         {
            this.zoomMenu = new BasePlannerPopup_ZoomLayout();
            this.addChild(this.zoomMenu);
            if(GLOBAL.DOES_USE_SCROLL)
            {
               this.displayCanvas.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll);
            }
            this.zoomMenu.btnUp.addEventListener(MouseEvent.CLICK,this.onZoomUp);
            this.zoomMenu.btnDown.addEventListener(MouseEvent.CLICK,this.onZoomDown);
            this.zoomMenu.scrollbar.addEventListener(MouseEvent.CLICK,this.onZoomScroll);
         }
         this.zoomMenu.x = _layoutOffset.x + 25;
         this.zoomMenu.y = _layoutSpacing.y + 10;
         this.zoomScrollerUpdate();
         if(!this.fullscreenButton)
         {
            this.fullscreenButton = new Sprite();
            this.fullscreenButton.addChild(new buttonFullscreenFrame_CLIP());
            this.fullscreenButton.addEventListener(MouseEvent.CLICK,GLOBAL.goFullScreen);
         }
         this._mcFrame.addChild(this.fullscreenButton);
         this.fullscreenButton.x = param1 - (_layoutSpacing.x + 50) + _loc3_.x;
         this.fullscreenButton.y = -10;
         if(!this.toolTipMenu)
         {
            this.toolTipMenu = new BasePlannerPopup_ToolTip();
            this.toolTipMenu.mouseEnabled = false;
            this.addChild(this.toolTipMenu);
         }
         var _loc5_:int = this.displayCanvas.canvasmask.width;
         this.toolTipMenu.x = this.displayCanvas.x + this.displayCanvas.canvasmask.width / 2;
         this.toolTipMenu.y = this.displayCanvas.y + this.displayCanvas.canvasmask.height - 40;
         this.onToolTipHide();
         this.onToolUpdate();
         this.x = -(this.width / 2);
         this.y = -(this.height / 2);
      }
      
      public function onToolTipNodeHint(param1:BasePlannerNodeEvent) : void
      {
         if(!this.toolTipMenu.hitTestPoint(stage.mouseX,mouseY))
         {
            this.onToolTipHint(null,param1.node.displayNameFull);
         }
      }
      
      public function onToolTipMouseHint(param1:Function, param2:Array) : Function
      {
         var method:Function = param1;
         var additionalArguments:Array = param2;
         return function(param1:MouseEvent):void
         {
            method.apply(null,[param1].concat(additionalArguments));
         };
      }
      
      public function onToolTipHint(param1:Event, param2:String) : void
      {
         this.toolTipMenu.tLabel.htmlText = param2;
         this.toolTipMenu.tLabel.autoSize = TextFieldAutoSize.CENTER;
         this.toolTipMenu.tLabel.width = 140;
         while(this.toolTipMenu.tLabel.height > 20)
         {
            this.toolTipMenu.tLabel.width += 2;
         }
         this.toolTipMenu.tLabel.x = -(this.toolTipMenu.tLabel.width / 2);
         this.toolTipMenu.mcBG.width = this.toolTipMenu.tLabel.width + 20;
         this.toolTipMenu.visible = true;
      }
      
      public function onToolTipNodeHide(param1:BasePlannerNodeEvent) : void
      {
         this.onToolTipHide();
      }
      
      public function onToolTipHide(param1:MouseEvent = null) : void
      {
         this.toolTipMenu.visible = false;
      }
      
      public function onToolUpdate(param1:Event = null) : void
      {
         this.onToolReset();
         if(this.designView.currentTool == PlannerDesignView.TOOL_SELECTMOVE)
         {
            this.toolMenu.mcSelectMove.gotoAndStop("over");
         }
         else if(this.designView.currentTool == PlannerDesignView.TOOL_STORE)
         {
            this.toolMenu.mcStore.gotoAndStop("over");
         }
         if(Boolean(STORE._storeData.ENL) && STORE._storeData.ENL.q == 6)
         {
            this.toolMenu.mcExpand.enabled = false;
            this.toolMenu.mcExpand.mouseEnabled = false;
            this.toolMenu.mcExpand.gotoAndStop("off");
         }
         else if(BASE.isMainYardOrInfernoMainYard)
         {
            this.toolMenu.mcExpand.visible = true;
         }
         else
         {
            this.toolMenu.mcExpand.visible = false;
         }
      }
      
      public function onToolReset(param1:Event = null) : void
      {
         this.toolMenu.mcSelectMove.gotoAndStop("out");
         this.toolMenu.mcStore.gotoAndStop("out");
         this.toolMenu.mcExpand.gotoAndStop("out");
      }
      
      public function onToolClick(param1:MouseEvent) : void
      {
         if(param1.target == this.toolMenu.mcSelectMove)
         {
            this.designView.setTool(PlannerDesignView.TOOL_SELECTMOVE);
         }
         if(param1.target == this.toolMenu.mcStore)
         {
            this.designView.setTool(PlannerDesignView.TOOL_STORE);
         }
         this.onToolUpdate();
      }
      
      public function onToolOver(param1:MouseEvent) : void
      {
         param1.target.gotoAndStop("over");
         if(param1.target == this.toolMenu.mcSelectMove)
         {
            this.onToolTipHint(null,KEYS.Get("basePlanner_moveTool"));
         }
         else if(param1.target == this.toolMenu.mcStore)
         {
            this.onToolTipHint(null,KEYS.Get("basePlanner_storageTool"));
         }
         else if(param1.target == this.toolMenu.mcExpand)
         {
            this.onToolTipHint(null,KEYS.Get("basePlanner_expandTool"));
         }
      }
      
      public function onToolOut(param1:MouseEvent) : void
      {
         this.onToolUpdate();
         this.onToolTipHide();
      }
      
      public function onStoreOpen(param1:MouseEvent = null) : void
      {
         if(BASE.isMainYardOrInfernoMainYard)
         {
            STORE.ShowB(1,1,["ENL"]);
            if(STORE._mc)
            {
               STORE._mc.addEventListener(Event.REMOVED_FROM_STAGE,this.onStoreClosed);
            }
         }
      }
      
      public function onStoreClosed(param1:Event = null) : void
      {
         this.designView.redraw();
         this.onToolUpdate();
      }
      
      public function onCheckboxClick(param1:Event = null) : void
      {
         var _loc2_:Checkbox = null;
         if(param1.target is Checkbox)
         {
            _loc2_ = param1.target as Checkbox;
            this.designView.toggleView(_loc2_);
         }
      }
      
      public function removeSelection() : void
      {
         this.designView.removeSelection();
      }
      
      protected function onScroll(param1:MouseEvent) : void
      {
         if(param1.delta < 0)
         {
            this.onZoomDown(null);
         }
         else
         {
            this.onZoomUp(null);
         }
      }
      
      public function onZoomUp(param1:MouseEvent = null) : void
      {
         var _loc2_:Number = PlannerDesignView.zoomValue;
         if(_loc2_ < this.designView.zoomMax)
         {
            _loc2_ = Math.min(_loc2_ + this.designView.zoomStep,this.designView.zoomMax);
            this.designView.setZoom(_loc2_);
         }
         this.zoomScrollerUpdate();
      }
      
      public function onZoomDown(param1:MouseEvent = null) : void
      {
         var _loc2_:Number = PlannerDesignView.zoomValue;
         if(_loc2_ > this.designView.zoomMin)
         {
            _loc2_ = Math.max(_loc2_ - this.designView.zoomStep,this.designView.zoomMin);
            this.designView.setZoom(_loc2_);
         }
         this.zoomScrollerUpdate();
      }
      
      public function onZoomScroll(param1:MouseEvent = null) : void
      {
      }
      
      public function zoomScrollerUpdate() : void
      {
         var _loc1_:Number = 42;
         var _loc2_:Number = 107;
         var _loc3_:Number = _loc2_ - _loc1_;
         var _loc4_:Number = this.designView.zoomMax - this.designView.zoomMin;
         var _loc5_:Number = _loc2_ - _loc3_ / _loc4_ * PlannerDesignView.zoomValue;
         this.zoomMenu.scrollbar.y = _loc5_;
      }
      
      private function createExplorerScrollBar(param1:Sprite) : void
      {
         param1.mask = this.sideBar.canvasmask;
         this.sideBarScrollBar = new ScrollSetV(param1,this.sideBar.canvasmask);
         this.sideBarScrollBar.x = param1.x + param1.width - this.sideBarScrollBar.width + this._PLANNER_LEFT_MARGIN;
         this.sideBarScrollBar.y = param1.y + _layoutSpacing.y + this._PLANNER_TOP_MARGIN;
         addChildAt(this.sideBarScrollBar,numChildren);
      }
      
      protected function onApplyClick(param1:MouseEvent) : void
      {
         if(this._isTemplateApplicable)
         {
            dispatchEvent(new BasePlannerEvent(BasePlannerEvent.APPLY));
         }
         else
         {
            GLOBAL.Message(KEYS.Get("basePlanner_cantApply"));
         }
      }
      
      protected function onLoadClick(param1:MouseEvent) : void
      {
         dispatchEvent(new BasePlannerEvent(BasePlannerEvent.LOAD));
      }
      
      protected function onSaveClick(param1:MouseEvent) : void
      {
         dispatchEvent(new BasePlannerEvent(BasePlannerEvent.SAVE));
      }
      
      protected function onClearClick(param1:MouseEvent) : void
      {
         if(this._clearConfirmationPopup)
         {
            return;
         }
         this._clearConfirmationPopup = new BasePlannerTransferConfirmation();
         this._clearConfirmationPopup.tBody.htmlText = KEYS.Get("basePlanner_unsaved");
         this._clearConfirmationPopup.bCancel.SetupKey("basePlanner_btnClear");
         this._clearConfirmationPopup.bCancel.addEventListener(MouseEvent.CLICK,this.clickedClearInConfirmationClear,false,0,true);
         if(BasePlanner.canSave == false)
         {
            this._clearConfirmationPopup.bConfirm.Enabled = false;
         }
         else
         {
            this._clearConfirmationPopup.bConfirm.Enabled = true;
            this._clearConfirmationPopup.bConfirm.addEventListener(MouseEvent.CLICK,this.clickedSaveInConfirmationClear,false,0,true);
         }
         this._clearConfirmationPopup.addEventListener(Event.CLOSE,this.clickedCloseInConfirmationClear,false,0,true);
         POPUPS.Add(this._clearConfirmationPopup);
         POPUPSETTINGS.AlignToCenter(this._clearConfirmationPopup);
      }
      
      protected function clickedCloseInConfirmationClear(param1:Event) : void
      {
         this.removeClearConfirmationPopup();
      }
      
      protected function clickedSaveInConfirmationClear(param1:MouseEvent) : void
      {
         this.removeClearConfirmationPopup();
         this.onSaveClick(null);
      }
      
      protected function clickedClearInConfirmationClear(param1:MouseEvent) : void
      {
         this.removeClearConfirmationPopup();
         this.clear();
      }
      
      private function removeClearConfirmationPopup() : void
      {
         if(this._clearConfirmationPopup)
         {
            POPUPS.Remove(this._clearConfirmationPopup);
            this._clearConfirmationPopup = null;
         }
      }
      
      private function clear() : void
      {
         var _loc3_:String = null;
         var _loc1_:int = int(this._plannerTemplate.displayData.length);
         var _loc2_:int = _loc1_ - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this._plannerTemplate.displayData[_loc2_].category;
            if(_loc3_ != PlannerNode.TYPE_MISC)
            {
               this._plannerTemplate.inventoryData.push(this._plannerTemplate.displayData[_loc2_]);
               this._plannerTemplate.displayData.splice(_loc2_,1);
            }
            _loc2_--;
         }
         this.redraw();
         this.sideBarScrollBar.checkResize();
         this.changedPlannerData();
         this.zoomScrollerUpdate();
         this.designView.redrawRanges();
         this.onDesignStateChange();
      }
      
      public function onExplorerChange(param1:Event = null) : void
      {
         this.sideBarScrollBar.checkResize();
         this.changedPlannerData();
         this.onToolUpdate();
      }
      
      public function onClearExplorerSelections(param1:Event = null) : void
      {
         this.buildingExplorer.clearSelections();
      }
      
      public function onExplorerItemClick(param1:BasePlannerNodeEvent = null) : void
      {
         this.removeSelection();
         this.designView.addInventoryItem(param1.node);
         this.changedPlannerData();
         this.onToolUpdate();
      }
      
      public function onDesignItemPlace(param1:BasePlannerNodeEvent = null) : void
      {
         this.buildingExplorer.removeBuilding(param1);
         this.changedPlannerData();
      }
      
      public function onDesignItemStore(param1:BasePlannerNodeEvent = null) : void
      {
         this.buildingExplorer.addElement(param1.node);
         this.designView.spliceDisplayData(param1.node);
         this.changedPlannerData();
      }
      
      public function onDesignItemInvalid(param1:BasePlannerNodeEvent = null) : void
      {
         this.buildingExplorer.clearSelections();
      }
      
      public function changedPlannerData() : void
      {
         this.canApply = this.checkIfApplicable();
      }
      
      public function onDesignStateChange(param1:Event = null) : void
      {
         this.hasBeenSaved = false;
      }
      
      public function Remove() : void
      {
         if(this.designView)
         {
            this.designView.remove();
            this.displayCanvas.canvas.removeChild(this.designView);
            this.designView = null;
         }
         if(this.displayCanvas)
         {
            removeChild(this.displayCanvas);
            this.displayCanvas = null;
         }
         if(this.buildingExplorer)
         {
            this.buildingExplorer.clear();
            this.sideBar.canvas.removeChild(this.buildingExplorer);
            this.buildingExplorer = null;
         }
         if(this.sideBar)
         {
            removeChild(this.sideBar);
            this.sideBar = null;
         }
         if(this.mcFrame)
         {
            (this.mcFrame as frame).Clear();
            this.mcFrame = null;
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         if(!this.hasBeenSaved && BasePlanner.canSave)
         {
            if(this._confirmationPopup)
            {
               return;
            }
            this._confirmationPopup = new BasePlannerTransferConfirmation();
            this._confirmationPopup.tBody.htmlText = KEYS.Get("basePlanner_unsaved");
            this._confirmationPopup.bCancel.SetupKey("basePlanner_btnDiscard");
            this._confirmationPopup.bCancel.addEventListener(MouseEvent.CLICK,this.clickedDiscardInConfirmation,false,0,true);
            this._confirmationPopup.bConfirm.addEventListener(MouseEvent.CLICK,this.clickedSaveInConfirmation,false,0,true);
            this._confirmationPopup.addEventListener(Event.CLOSE,this.clickedCloseInConfirmation,false,0,true);
            POPUPS.Add(this._confirmationPopup);
            POPUPSETTINGS.AlignToCenter(this._confirmationPopup);
         }
         else
         {
            PLANNER.Hide();
         }
      }
      
      protected function clickedCloseInConfirmation(param1:Event) : void
      {
         this.removeConfirmationPopup();
      }
      
      private function removeConfirmationPopup() : void
      {
         POPUPS.Remove(this._confirmationPopup);
         this._confirmationPopup = null;
      }
      
      protected function clickedDiscardInConfirmation(param1:Event) : void
      {
         PLANNER.Hide();
         this.removeConfirmationPopup();
      }
      
      protected function clickedSaveInConfirmation(param1:Event) : void
      {
         this.removeConfirmationPopup();
         dispatchEvent(new BasePlannerEvent(BasePlannerEvent.SAVE));
      }
      
      public function Resize() : void
      {
         this.configPopupTemplate(GLOBAL._SCREEN.width - 30,GLOBAL._SCREEN.height - 30);
         this.x = GLOBAL._SCREENCENTER.x + -(this._mcFrame.width / 2) + 10;
         this.y = GLOBAL._SCREENCENTER.y + -(this._mcFrame.height / 2) + 10;
      }
      
      public function debugBreakTrace() : void
      {
      }
      
      public function get hasBeenSaved() : Boolean
      {
         return this._hasBeenSaved;
      }
      
      public function set hasBeenSaved(param1:Boolean) : void
      {
         this._hasBeenSaved = param1;
         if(param1)
         {
            this._bSave.Enabled = !BASE.isOutpost;
            this._bSave.enabled = !BASE.isOutpost;
            this._bSave.mouseEnabled = !BASE.isOutpost;
         }
         else
         {
            this._bSave.Enabled = BasePlanner.canSave;
            this._bSave.enabled = BasePlanner.canSave;
            this._bSave.mouseEnabled = BasePlanner.canSave;
         }
      }
   }
}

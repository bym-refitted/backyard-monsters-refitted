package com.monsters.baseplanner
{
   import com.monsters.baseplanner.components.BuildingItem;
   import com.monsters.baseplanner.components.PlannerExplorerButton;
   import com.monsters.baseplanner.components.PlannerExplorerHeader;
   import com.monsters.baseplanner.events.BasePlannerNodeEvent;
   import com.monsters.baseplanner.popups.BasePlannerPopup;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PlannerExplorer extends Sprite
   {
      
      public static const EXPLORER_ITEM_CLICK:String = "explorer_item_click";
      
      public static const EXPLORER_ITEM_OVER:String = "explorer_item_over";
      
      public static const EXPLORER_ITEM_OUT:String = "explorer_item_out";
      
      public static const EXPLORER_CHANGE:String = "explorer_change";
       
      
      private var _canvas:Sprite;
      
      private var _layerHeaders:Sprite;
      
      private var _inventoryData:Vector.<com.monsters.baseplanner.PlannerNode>;
      
      private var _headers:Vector.<PlannerExplorerHeader>;
      
      private var _lastClickedItem:String;
      
      public function PlannerExplorer(param1:Vector.<com.monsters.baseplanner.PlannerNode>)
      {
         super();
         this._inventoryData = param1;
         this._canvas = new Sprite();
         this.addChild(this._canvas);
         this._layerHeaders = new Sprite();
         this._canvas.addChild(this._layerHeaders);
         addEventListener(MouseEvent.CLICK,this.onClick);
         this._canvas.x = 0;
         this._canvas.y = 0;
         this._headers = new Vector.<PlannerExplorerHeader>();
         this._headers[0] = new PlannerExplorerHeader(BuildingItem.TYPE_DEFENSIVE);
         this._headers[1] = new PlannerExplorerHeader(BuildingItem.TYPE_BUILDING);
         this._headers[2] = new PlannerExplorerHeader(BuildingItem.TYPE_RESOURCE);
         this._headers[3] = new PlannerExplorerHeader(BuildingItem.TYPE_TRAP);
         this._headers[4] = new PlannerExplorerHeader(BuildingItem.TYPE_WALL);
         this._headers[5] = new PlannerExplorerHeader(BuildingItem.TYPE_DECORATION);
         var _loc2_:int = 0;
         while(_loc2_ < this._headers.length)
         {
            this._layerHeaders.addChild(this._headers[_loc2_]);
            this._headers[_loc2_].addEventListener(EXPLORER_CHANGE,this.onExplorerUpdate);
            _loc2_++;
         }
      }
      
      private function sortInventoryData() : void
      {
         this._inventoryData.sort(this.plannerNodeSort);
      }
      
      private function plannerNodeSort(param1:com.monsters.baseplanner.PlannerNode, param2:com.monsters.baseplanner.PlannerNode) : Number
      {
         if(param1.name < param2.name)
         {
            return -1;
         }
         if(param1.name > param2.name)
         {
            return 1;
         }
         if(param1.level < param2.level)
         {
            return -1;
         }
         if(param1.level > param2.level)
         {
            return 1;
         }
         return 0;
      }
      
      public function setup() : void
      {
         this.sortInventoryData();
         var _loc1_:int = 0;
         while(_loc1_ < this._inventoryData.length)
         {
            this.addElement(this._inventoryData[_loc1_],false,false);
            _loc1_++;
         }
         this.reposition();
      }
      
      public function redraw() : void
      {
         this.clearHeaders();
         this.setup();
      }
      
      private function clearHeaders() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._headers.length)
         {
            this._headers[_loc1_].clear();
            _loc1_++;
         }
      }
      
      public function clearSelections(param1:Boolean = false) : void
      {
         if(param1)
         {
            this._lastClickedItem = "";
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._headers.length)
         {
            this._headers[_loc2_].deselectChildren(this._lastClickedItem);
            _loc2_++;
         }
      }
      
      public function addElement(param1:com.monsters.baseplanner.PlannerNode, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc5_:PlannerExplorerButton = null;
         var _loc4_:int = 0;
         if((_loc4_ = this.getCategoryIndex(param1.category)) >= this._headers.length)
         {
            return;
         }
         _loc5_ = this._headers[_loc4_].addElement(param1);
         if(param3)
         {
            this._inventoryData.push(param1);
         }
         if(_loc5_.isNew())
         {
            _loc5_.addEventListener(EXPLORER_ITEM_CLICK,this.onClickBuilding);
            _loc5_.addEventListener(EXPLORER_ITEM_OVER,this.onOverBuilding);
            _loc5_.addEventListener(EXPLORER_ITEM_OUT,this.onOutBuilding);
         }
         this.sortInventoryData();
         if(param2)
         {
            this.reposition();
         }
      }
      
      public function onClick(param1:MouseEvent = null) : void
      {
         this.reposition();
      }
      
      public function onClickBuilding(param1:BasePlannerNodeEvent) : void
      {
         var _loc2_:int = this.getCategoryIndex(param1.node.category);
         this._lastClickedItem = param1.node.displayName;
         this.reposition();
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.EXPLORER_BUILDING_CLICK,param1.node));
      }
      
      public function onOverBuilding(param1:BasePlannerNodeEvent) : void
      {
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.PLANNER_HINT,param1.node));
      }
      
      public function onOutBuilding(param1:BasePlannerNodeEvent) : void
      {
         dispatchEvent(new BasePlannerNodeEvent(BasePlannerPopup.PLANNER_HINT_HIDE,param1.node));
      }
      
      public function clear() : void
      {
         this.clearHeaders();
         this.reposition();
         removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function onExplorerUpdate(param1:Event = null) : void
      {
         dispatchEvent(new Event(BasePlannerPopup.EXPLORER_UPDATE));
      }
      
      public function removeBuilding(param1:BasePlannerNodeEvent) : void
      {
         var _loc2_:int = this.getCategoryIndex(param1.node.category);
         this._headers[_loc2_].removeNode(param1.node);
         this._inventoryData.splice(this._inventoryData.indexOf(param1.node),1);
         this.reposition();
      }
      
      private function getCategoryIndex(param1:String) : int
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case BuildingItem.TYPE_DEFENSIVE:
               _loc2_ = 0;
               break;
            case BuildingItem.TYPE_BUILDING:
               _loc2_ = 1;
               break;
            case BuildingItem.TYPE_RESOURCE:
               _loc2_ = 2;
               break;
            case BuildingItem.TYPE_TRAP:
               _loc2_ = 3;
               break;
            case BuildingItem.TYPE_WALL:
               _loc2_ = 4;
               break;
            case BuildingItem.TYPE_DECORATION:
               _loc2_ = 5;
               break;
            case BuildingItem.TYPE_MISC:
               _loc2_ = 6;
         }
         return _loc2_;
      }
      
      public function reposition(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         var _loc3_:int = int(this._headers.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._headers[_loc4_].y = _loc2_;
            _loc2_ += this._headers[_loc4_].rePosition() + this._headers[_loc4_].mc.height;
            _loc4_++;
         }
      }
   }
}

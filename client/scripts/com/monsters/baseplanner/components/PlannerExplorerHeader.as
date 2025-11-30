package com.monsters.baseplanner.components
{
   import com.monsters.baseplanner.PlannerExplorer;
   import com.monsters.baseplanner.PlannerNode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PlannerExplorerHeader extends PlannerItem
   {
       
      
      public var _category:String;
      
      private var _collapsed:Boolean;
      
      private var _elementList:Vector.<PlannerExplorerButton>;
      
      public function PlannerExplorerHeader(param1:String)
      {
         var _loc2_:String = null;
         super();
         this._category = param1;
         this._elementList = new Vector.<PlannerExplorerButton>();
         mc = new BasePlannerPopup_ExplorerItem_Category();
         addChild(mc);
         switch(param1)
         {
            case BuildingItem.TYPE_DEFENSIVE:
               _loc2_ = KEYS.Get("basePlanner_catDefensive");
               break;
            case BuildingItem.TYPE_BUILDING:
               _loc2_ = KEYS.Get("basePlanner_catBuilding");
               break;
            case BuildingItem.TYPE_RESOURCE:
               _loc2_ = KEYS.Get("basePlanner_catResource");
               break;
            case BuildingItem.TYPE_DECORATION:
               _loc2_ = KEYS.Get("basePlanner_catDecoration");
               break;
            case BuildingItem.TYPE_TRAP:
               _loc2_ = KEYS.Get("basePlanner_catTrap");
               break;
            case BuildingItem.TYPE_WALL:
               _loc2_ = KEYS.Get("basePlanner_catWall");
               break;
            case BuildingItem.TYPE_MISC:
            default:
               _loc2_ = KEYS.Get("basePlanner_catMisc");
         }
         mc.tLabel.htmlText = _loc2_;
         mc.mcCarrot.rotation = 90;
         mc.mcBG.gotoAndStop(param1);
         mc.mcFrame.gotoAndStop("off");
         this.emptyCheck();
      }
      
      override public function onClick(param1:MouseEvent = null) : void
      {
         if(this._collapsed)
         {
            this.expand();
         }
         else
         {
            this.collapse();
         }
         dispatchEvent(new Event(PlannerExplorer.EXPLORER_CHANGE));
      }
      
      private function expand() : void
      {
         this._collapsed = false;
         var _loc1_:int = 0;
         while(_loc1_ < this._elementList.length)
         {
            this._elementList[_loc1_].alpha = 1;
            _loc1_++;
         }
         mc.mcCarrot.rotation = 90;
      }
      
      private function collapse() : void
      {
         this._collapsed = true;
         var _loc1_:int = 0;
         while(_loc1_ < this._elementList.length)
         {
            this._elementList[_loc1_].alpha = 0;
            _loc1_++;
         }
         mc.mcCarrot.rotation = 0;
      }
      
      private function emptyCheck() : void
      {
         if(this._elementList.length == 0)
         {
            mc.mcCarrot.visible = 0;
         }
         else
         {
            mc.mcCarrot.visible = 1;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._elementList.length)
         {
            this._elementList[_loc1_].clear();
            _loc1_++;
         }
         this._elementList.length = 0;
         this.emptyCheck();
         var _loc2_:int = 0;
         while(numChildren > 1)
         {
            if(getChildAt(_loc2_) != mc)
            {
               removeChildAt(_loc2_);
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      public function deselectChildren(param1:String = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._elementList.length)
         {
            this._elementList[_loc2_].cleanSelection(param1);
            _loc2_++;
         }
      }
      
      public function removeNode(param1:PlannerNode) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._elementList.length)
         {
            if(this._elementList[_loc2_].displayName == param1.displayName)
            {
               this._elementList[_loc2_].decrement();
               if(this._elementList[_loc2_].numBuildings <= 0)
               {
                  var _loc3_:PlannerExplorerButton = this._elementList[_loc2_];
                  _loc3_.x = 30000;
                  this._elementList.splice(_loc2_,1);
                  removeChild(_loc3_);
                  _loc3_.clear();
               }
            }
            _loc2_++;
         }
         this.emptyCheck();
      }
      
      override public function update() : void
      {
      }
      
      public function rePosition() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._elementList.length)
         {
            this._elementList[_loc2_].x = 0;
            if(this._collapsed)
            {
               this._elementList[_loc2_].y = 0;
            }
            else
            {
               _loc1_ += this._elementList[_loc2_].height;
               this._elementList[_loc2_].y = _loc1_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addElement(param1:PlannerNode) : PlannerExplorerButton
      {
         var _loc4_:PlannerExplorerButton = null;
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._elementList.length)
         {
            if(this._elementList[_loc3_].displayName == param1.displayName)
            {
               this._elementList[_loc3_].increment(param1);
               _loc2_ = false;
               this.emptyCheck();
               return this._elementList[_loc3_];
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc4_ = new PlannerExplorerButton(param1);
            this._elementList.push(_loc4_);
            this._elementList.sort(this.sortExplorerButtons);
            addChild(_loc4_);
            if(this._collapsed)
            {
               _loc4_.alpha = 0;
            }
            this.emptyCheck();
            return _loc4_;
         }
         return null;
      }
      
      private function sortExplorerButtons(param1:PlannerExplorerButton, param2:PlannerExplorerButton) : Number
      {
         if(param1.displayName < param2.displayName)
         {
            return -1;
         }
         if(param1.displayName > param2.displayName)
         {
            return 1;
         }
         return 0;
      }
      
      override public function onRollOver(param1:MouseEvent = null) : void
      {
         mc.mcFrame.gotoAndStop("on");
      }
      
      override public function onRollOut(param1:MouseEvent = null) : void
      {
         mc.mcFrame.gotoAndStop("off");
      }
      
      override public function onMouseDown(param1:MouseEvent = null) : void
      {
      }
      
      override public function onMouseUp(param1:MouseEvent = null) : void
      {
      }
   }
}

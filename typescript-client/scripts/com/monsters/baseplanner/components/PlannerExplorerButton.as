package com.monsters.baseplanner.components
{
   import com.monsters.baseplanner.PlannerExplorer;
   import com.monsters.baseplanner.PlannerNode;
   import com.monsters.baseplanner.events.BasePlannerNodeEvent;
   import flash.events.MouseEvent;
   
   public class PlannerExplorerButton extends PlannerItem
   {
       
      
      private var _nodeList:Vector.<PlannerNode>;
      
      private var _clicked:Boolean;
      
      public function PlannerExplorerButton(param1:PlannerNode)
      {
         super();
         this._nodeList = new Vector.<PlannerNode>();
         mc = new BasePlannerPopup_ExplorerItem_Type();
         addChild(mc);
         mc.tLabel.htmlText = param1.displayName;
         mc.tLabel.mouseEnabled = false;
         mc.mcFrame.gotoAndStop("off");
         mc.buttonMode = true;
         this._clicked = false;
         this.increment(param1);
      }
      
      public function get displayName() : String
      {
         return this._nodeList[0].displayName;
      }
      
      override public function onClick(param1:MouseEvent = null) : void
      {
         if(alpha > 0)
         {
            this.toggleSelection();
            dispatchEvent(new BasePlannerNodeEvent(PlannerExplorer.EXPLORER_ITEM_CLICK,this._nodeList[this._nodeList.length - 1]));
            param1.stopImmediatePropagation();
         }
      }
      
      public function increment(param1:PlannerNode) : void
      {
         this._nodeList.push(param1);
         mc.mcLevel.tLabel.htmlText = this._nodeList.length;
      }
      
      public function clear() : void
      {
         this._nodeList.length = 0;
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      public function decrement(param1:Boolean = true) : PlannerNode
      {
         if(this._nodeList.length - 1 <= 0)
         {
            alpha = 0;
         }
         mc.mcLevel.tLabel.htmlText = this._nodeList.length - 1;
         if(this._nodeList.length - 1 > 0 && param1)
         {
            PLANNER.basePlanner.popup.designView.addInventoryItem(this._nodeList[this._nodeList.length - 2]);
         }
         else
         {
            mc.mcFrame.gotoAndStop("off");
         }
         return this._nodeList.pop();
      }
      
      public function isNew() : Boolean
      {
         return this._nodeList.length < 2;
      }
      
      public function get numBuildings() : int
      {
         return this._nodeList.length;
      }
      
      public function cleanSelection(param1:String) : void
      {
         if(param1 != this.displayName)
         {
            this._clicked = false;
            mc.mcFrame.gotoAndStop("off");
         }
      }
      
      public function toggleSelection(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            this._clicked = !this._clicked;
         }
         else
         {
            this._clicked = Boolean(param1);
         }
         if(this._clicked)
         {
            mc.mcFrame.gotoAndStop("on");
         }
         else
         {
            mc.mcFrame.gotoAndStop("off");
         }
      }
      
      override public function onRollOver(param1:MouseEvent = null) : void
      {
         if(alpha > 0)
         {
            mc.mcFrame.gotoAndStop("on");
            dispatchEvent(new BasePlannerNodeEvent(PlannerExplorer.EXPLORER_ITEM_OVER,this._nodeList[0]));
            param1.stopImmediatePropagation();
         }
      }
      
      override public function onRollOut(param1:MouseEvent = null) : void
      {
         if(alpha > 0)
         {
            if(!this._clicked)
            {
               mc.mcFrame.gotoAndStop("off");
            }
            dispatchEvent(new BasePlannerNodeEvent(PlannerExplorer.EXPLORER_ITEM_OUT,this._nodeList[0]));
            param1.stopImmediatePropagation();
         }
      }
      
      override public function onMouseDown(param1:MouseEvent = null) : void
      {
      }
      
      override public function onMouseUp(param1:MouseEvent = null) : void
      {
      }
   }
}

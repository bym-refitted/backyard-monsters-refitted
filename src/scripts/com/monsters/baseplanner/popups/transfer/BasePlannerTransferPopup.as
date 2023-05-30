package com.monsters.baseplanner.popups.transfer
{
   import com.monsters.baseplanner.BasePlanner;
   import com.monsters.baseplanner.BaseTemplate;
   import com.monsters.display.ScalableFrame;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BasePlannerTransferPopup extends BasePlannerTransfer_CLIP
   {
      
      public static const CLICKED_TRANSFER:String = "clickTransfer";
       
      
      protected var _rows:Vector.<com.monsters.baseplanner.popups.transfer.BasePlannerTransferRow>;
      
      protected var _rowsContainer:Sprite;
      
      private var _frame:ScalableFrame;
      
      public function BasePlannerTransferPopup()
      {
         super();
      }
      
      public function updateList(param1:Vector.<BaseTemplate>) : void
      {
         var _loc2_:uint = 0;
         var _loc5_:BaseTemplate = null;
         var _loc6_:com.monsters.baseplanner.popups.transfer.BasePlannerTransferRow = null;
         if(this._rowsContainer)
         {
            mcRowContainer.removeChild(this._rowsContainer);
         }
         this._rowsContainer = new Sprite();
         this._rows = new Vector.<com.monsters.baseplanner.popups.transfer.BasePlannerTransferRow>();
         var _loc3_:uint = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < BasePlanner.maxNumberOfSlots)
         {
            _loc5_ = _loc4_ >= _loc3_ ? null : param1[_loc4_];
            _loc6_ = new com.monsters.baseplanner.popups.transfer.BasePlannerTransferRow(_loc5_,_loc4_);
            if(!_loc5_ && _loc4_ >= BasePlanner.slots)
            {
               _loc6_.disable();
            }
            _loc6_.bTransfer.SetupKey("basePlanner_btnSaveLayout");
            _loc6_.addEventListener(CLICKED_TRANSFER,this.clickedTransfer);
            _loc6_.y = _loc2_;
            this._rowsContainer.addChild(_loc6_);
            _loc2_ += _loc6_.height + 5;
            this._rows.push(_loc6_);
            _loc4_++;
         }
         mcRowContainer.addChild(this._rowsContainer);
         mcFrame.height = mcRowContainer.height + 80;
         mcFrame.resize();
      }
      
      override public function get name() : String
      {
         return "UNASSIGNED";
      }
      
      protected function clickedTransfer(param1:Event) : void
      {
      }
      
      public function clear() : void
      {
      }
   }
}

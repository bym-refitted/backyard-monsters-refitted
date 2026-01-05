package com.monsters.baseplanner.popups.transfer
{
   import com.monsters.baseplanner.BaseTemplate;
   import com.monsters.baseplanner.events.BasePlannerEvent;
   import com.monsters.baseplanner.events.BasePlannerTransferEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BasePlannerLoadPopup extends BasePlannerTransferPopup
   {
       
      
      public function BasePlannerLoadPopup()
      {
         super();
         tTitle.htmlText = KEYS.Get("basePlanner_loadtitle");
      }
      
      override public function updateList(param1:Vector.<BaseTemplate>) : void
      {
         var _loc2_:uint = 0;
         var _loc5_:BaseTemplate = null;
         var _loc6_:BasePlannerTransferRow = null;
         if(_rowsContainer)
         {
            mcRowContainer.removeChild(_rowsContainer);
         }
         _rowsContainer = new Sprite();
         _rows = new Vector.<BasePlannerTransferRow>();
         var _loc3_:uint = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc4_ >= _loc3_ ? null : param1[_loc4_];
            (_loc6_ = new BasePlannerTransferRow(_loc5_,_loc4_)).canEdit = false;
            _loc6_.bTransfer.SetupKey("basePlanner_btnLoadLayout");
            _loc6_.addEventListener(CLICKED_TRANSFER,this.clickedTransfer);
            _loc6_.y = _loc2_;
            _rowsContainer.addChild(_loc6_);
            _loc2_ += _loc6_.height + 5;
            _rows.push(_loc6_);
            _loc4_++;
         }
         mcRowContainer.addChild(_rowsContainer);
         mcFrame.height = mcRowContainer.height + 80;
         mcFrame.resize();
      }
      
      override public function get name() : String
      {
         return KEYS.Get("basePlanner_btnLoad");
      }
      
      override protected function clickedTransfer(param1:Event) : void
      {
         var _loc2_:BasePlannerTransferRow = param1.currentTarget as BasePlannerTransferRow;
         dispatchEvent(new BasePlannerTransferEvent(BasePlannerEvent.LOAD,_loc2_.slot));
      }
   }
}

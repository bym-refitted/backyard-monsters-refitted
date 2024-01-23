package com.monsters.baseplanner.popups.transfer
{
   import com.monsters.baseplanner.events.BasePlannerEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BasePlannerTransferConfirmation extends BasePlannerTransferConfirmation_CLIP
   {
       
      
      public function BasePlannerTransferConfirmation(param1:String = null)
      {
         super();
         tTitle.htmlText = KEYS.Get("pop_areyousure");
         tBody.htmlText = KEYS.Get("basePlanner_overwrite",{"v1":param1});
         bCancel.SetupKey("btn_cancel");
         bConfirm.SetupKey("basePlanner_btnSave");
         bCancel.addEventListener(MouseEvent.CLICK,this.clickedCancel,false,0,true);
         bConfirm.addEventListener(MouseEvent.CLICK,this.clickedConfirm,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
      }
      
      protected function removedFromStage(param1:Event) : void
      {
         bCancel.removeEventListener(MouseEvent.CLICK,this.clickedCancel);
         bConfirm.removeEventListener(MouseEvent.CLICK,this.clickedConfirm);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
      }
      
      protected function clickedConfirm(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(BasePlannerEvent.SAVE));
      }
      
      protected function clickedCancel(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function Hide() : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

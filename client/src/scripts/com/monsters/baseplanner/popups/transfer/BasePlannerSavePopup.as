package com.monsters.baseplanner.popups.transfer
{
   import com.monsters.baseplanner.events.BasePlannerEvent;
   import com.monsters.baseplanner.events.BasePlannerTransferEvent;
   import flash.events.Event;
   
   public class BasePlannerSavePopup extends BasePlannerTransferPopup
   {
       
      
      private var _row:BasePlannerTransferRow;
      
      private var _confirmationPopup:BasePlannerTransferConfirmation;
      
      public function BasePlannerSavePopup()
      {
         super();
         tTitle.htmlText = KEYS.Get("basePlanner_savetitle");
      }
      
      override public function get name() : String
      {
         return KEYS.Get("basePlanner_btnSave");
      }
      
      override protected function clickedTransfer(param1:Event) : void
      {
         this._row = param1.currentTarget as BasePlannerTransferRow;
         if(this._row.template)
         {
            if(!this._confirmationPopup)
            {
               this._confirmationPopup = new BasePlannerTransferConfirmation("\'" + this._row.template.name + "\'");
               this._confirmationPopup.addEventListener(BasePlannerEvent.SAVE,this.confirmedSave);
               this._confirmationPopup.addEventListener(Event.CLOSE,this.clickedClose);
               POPUPS.Add(this._confirmationPopup);
               POPUPSETTINGS.AlignToCenter(this._confirmationPopup);
            }
         }
         else
         {
            this.confirmedSave(null);
         }
      }
      
      protected function clickedClose(param1:Event = null) : void
      {
         if(this._confirmationPopup)
         {
            this._confirmationPopup.removeEventListener(BasePlannerEvent.SAVE,this.confirmedSave);
            this._confirmationPopup.removeEventListener(Event.CLOSE,this.clickedClose);
            POPUPS.Remove(this._confirmationPopup);
            this._confirmationPopup = null;
         }
      }
      
      protected function confirmedSave(param1:Event) : void
      {
         dispatchEvent(new BasePlannerTransferEvent(BasePlannerEvent.SAVE,this._row.slot,this._row.tTemplateName.text));
         if(this._confirmationPopup)
         {
            this.clickedClose();
         }
      }
      
      override public function clear() : void
      {
         this.clickedClose();
      }
   }
}

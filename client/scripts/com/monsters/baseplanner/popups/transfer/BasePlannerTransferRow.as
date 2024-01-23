package com.monsters.baseplanner.popups.transfer
{
   import com.monsters.baseplanner.BaseTemplate;
   import com.monsters.subscriptions.SubscriptionHandler;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   public class BasePlannerTransferRow extends BasePlannerTransferRow_CLIP
   {
       
      
      public var slot:uint;
      
      public var template:BaseTemplate;
      
      private var _isEditing:Boolean;
      
      private const _DEFAULT_SLOT_NAME:String = "<Empty>";
      
      public function BasePlannerTransferRow(param1:BaseTemplate, param2:uint)
      {
         super();
         this.template = param1;
         this.slot = param2;
         tSlotName.htmlText = KEYS.Get("basePlanner_slot_label",{"v1":String(param2 + 1)});
         tTemplateName.multiline = false;
         mcLock.visible = false;
         bTransfer.addEventListener(MouseEvent.CLICK,this.clickedTransfer,false,0,true);
         tTemplateName.maxChars = 15;
         tTemplateName.addEventListener(MouseEvent.CLICK,this.clickedEdit,false,0,true);
         tTemplateName.addEventListener(MouseEvent.MOUSE_OVER,this.rollOverName,false,0,true);
         tTemplateName.addEventListener(MouseEvent.MOUSE_OUT,this.rollOutName,false,0,true);
         tTemplateName.addEventListener(KeyboardEvent.KEY_DOWN,this.pressedEnterOnName,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage,false,0,true);
         if(param1)
         {
            tTemplateName.htmlText = param1.name;
         }
         else
         {
            tTemplateName.htmlText = KEYS.Get("basePlanner_layoutname",{"v1":(param2 + 1).toString()});
         }
         mcEdit.visible = false;
      }
      
      public function set canEdit(param1:Boolean) : void
      {
         tTemplateName.removeEventListener(MouseEvent.CLICK,this.clickedEdit);
         mcEdit.visible = false;
      }
      
      protected function rollOutName(param1:MouseEvent) : void
      {
         mcEdit.gotoAndStop("disabled");
      }
      
      protected function rollOverName(param1:MouseEvent) : void
      {
         mcEdit.gotoAndStop("enabled");
      }
      
      protected function pressedEnterOnName(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.clickedTransfer(null);
         }
      }
      
      public function set isEditing(param1:Boolean) : void
      {
         if(param1 == this._isEditing)
         {
            return;
         }
         if(param1)
         {
            tTemplateName.type = TextFieldType.INPUT;
            tTemplateName.selectable = true;
            tTemplateName.setSelection(0,tTemplateName.text.length);
         }
         else
         {
            tTemplateName.type = TextFieldType.DYNAMIC;
            tTemplateName.selectable = false;
         }
         this._isEditing = param1;
      }
      
      public function disable(param1:Boolean = true) : void
      {
         mouseChildren = false;
         bTransfer.visible = false;
         tTemplateName.htmlText = "<font color=\"#333333\">" + KEYS.Get("basePlanner_layoutname",{"v1":(this.slot + 1).toString()}) + "</font>";
         tSlotName.htmlText = "<font color=\"#AAAAAA\">" + KEYS.Get("basePlanner_slot_label",{"v1":String(this.slot + 1)}) + "</font>";
         mcBackground.transform.colorTransform = new ColorTransform(0.75,0.75,0.75);
         if(param1)
         {
            mcLock.visible = true;
            addEventListener(MouseEvent.CLICK,this.clickedUnlock,false,0,true);
         }
      }
      
      protected function clickedUnlock(param1:MouseEvent) : void
      {
         SubscriptionHandler.instance.showPromoPopup();
      }
      
      protected function removedFromStage(param1:Event) : void
      {
         bTransfer.removeEventListener(MouseEvent.CLICK,this.clickedTransfer);
         tTemplateName.removeEventListener(MouseEvent.CLICK,this.clickedEdit);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
         tTemplateName.removeEventListener(MouseEvent.MOUSE_OVER,this.rollOverName);
         tTemplateName.removeEventListener(MouseEvent.MOUSE_OUT,this.rollOutName);
         tTemplateName.removeEventListener(KeyboardEvent.KEY_DOWN,this.pressedEnterOnName);
      }
      
      protected function clickedEdit(param1:MouseEvent) : void
      {
         this.isEditing = true;
      }
      
      protected function clickedTransfer(param1:MouseEvent) : void
      {
         this.isEditing = false;
         dispatchEvent(new Event(BasePlannerTransferPopup.CLICKED_TRANSFER));
      }
   }
}

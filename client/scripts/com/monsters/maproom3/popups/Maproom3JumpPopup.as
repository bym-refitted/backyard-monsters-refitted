package com.monsters.maproom3.popups
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.IMapRoomCell;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class Maproom3JumpPopup extends MapRoomPopupJump
   {
      
      public static const k_clickedJump:String = "clickedJumpButton";
       
      
      public var targetCell:IMapRoomCell;
      
      public function Maproom3JumpPopup()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      protected function addedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         tMessage.htmlText = KEYS.Get("label_jumptolocation");
         tX.htmlText = "";
         tX.addEventListener(KeyboardEvent.KEY_UP,this.keyUpOnX);
         tY.htmlText = "";
         tY.addEventListener(KeyboardEvent.KEY_UP,this.keyUpOnY);
         bJump.SetupKey("btn_jump");
         bJump.addEventListener(MouseEvent.CLICK,this.clickedJump);
         mcFrame.Setup(true);
         stage.focus = tX;
      }
      
      protected function keyUpOnY(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
         if(_loc2_ == Keyboard.NUMPAD_ENTER || _loc2_ == Keyboard.ENTER)
         {
            this.clickedJump();
         }
      }
      
      protected function keyUpOnX(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
      }
      
      protected function clickedJump(param1:MouseEvent = null) : void
      {
         this.targetCell = MapRoomManager.instance.FindCell(int(tX.text),int(tY.text));
         if(!this.targetCell || this.targetCell.baseType == EnumYardType.BORDER)
         {
            GLOBAL.Message(KEYS.Get("map_coordinateoffmap"));
            return;
         }
         dispatchEvent(new Event(k_clickedJump));
      }
      
      public function Hide() : void
      {
         tX.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpOnX);
         tY.removeEventListener(KeyboardEvent.KEY_UP,this.keyUpOnY);
         bJump.removeEventListener(MouseEvent.CLICK,this.clickedJump);
         POPUPS.Next();
      }
   }
}

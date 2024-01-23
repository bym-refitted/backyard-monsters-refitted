package
{
   import flash.events.MouseEvent;
   
   public class UI_WILDMONSTERBAR extends UI_WILDMONSTERBAR_CLIP
   {
       
      
      public function UI_WILDMONSTERBAR()
      {
         super();
         info.addEventListener(MouseEvent.CLICK,this.infoDown);
         tA.htmlText = KEYS.Get("ai_monsterbar_title");
         info.addEventListener(MouseEvent.MOUSE_OVER,this.infoOver);
         info.addEventListener(MouseEvent.MOUSE_OUT,this.infoOut);
         info.tA.htmlText = "<b>" + KEYS.Get("ai_monsterbar_sendnow_btn") + "</b>";
         info.mouseChildren = false;
         info.useHandCursor = true;
      }
      
      private function infoOver(param1:MouseEvent) : void
      {
         info.gotoAndStop(2);
      }
      
      private function infoOut(param1:MouseEvent) : void
      {
         info.gotoAndStop(1);
      }
      
      private function infoDown(param1:MouseEvent) : void
      {
         WMATTACK.Attack();
      }
   }
}

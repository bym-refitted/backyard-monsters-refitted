package
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class UI_BAITERSCAREAWAY extends UI_BAITERSCAREAWAY_CLIP
   {
       
      
      public function UI_BAITERSCAREAWAY(param1:Boolean = true)
      {
         super();
         if(param1)
         {
            bReturn.SetupKey("bait_scareaway");
         }
         else
         {
            bReturn.SetupKey("wmi_surrenderbtn");
         }
         var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
         if(activeEvent.active)
         {
            bReturn.SetupKey("wmi_surrenderbtn");
         }
         bReturn.addEventListener(MouseEvent.CLICK,this.onReturnDown);
      }
      
      private function onReturnDown(param1:MouseEvent) : void
      {
         var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
         var _loc2_:Boolean = activeEvent.active;
         if(_loc2_)
         {
            activeEvent.Surrender();
            return;
         }
         dispatchEvent(new Event("scareAway"));
      }
      
      public function Resize() : void
      {
         GLOBAL.RefreshScreen();
         x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - mcBG.width - 10;
         y = GLOBAL._SCREENHUD.y - (mcBG.height + 10);
      }
   }
}

package
{
   import flash.events.MouseEvent;
   
   public class popup_prefab_help extends popup_prefab_help_CLIP
   {
       
      
      public function popup_prefab_help()
      {
         super();
         b1.SetupKey("newmap_sk_btn");
         b1.Highlight = true;
         b1.addEventListener(MouseEvent.CLICK,this.Next);
         tTitle.htmlText = KEYS.Get("newmap_sk_title");
         tMessage.htmlText = KEYS.Get("newmap_sk_hlp");
      }
      
      private function Next(param1:MouseEvent = null) : void
      {
         b1.removeEventListener(MouseEvent.CLICK,this.Next);
         POPUPS.Next();
         POPUPS.Push(new popup_prefab());
      }
   }
}

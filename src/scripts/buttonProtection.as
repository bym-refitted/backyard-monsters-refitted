package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class buttonProtection extends MovieClip
   {
       
      
      public function buttonProtection()
      {
         super();
         mouseChildren = false;
         addEventListener(MouseEvent.CLICK,this.Show);
         buttonMode = true;
      }
      
      public function Show(param1:MouseEvent = null) : void
      {
         var _loc2_:popup_protected = new popup_protected();
         _loc2_.tA.htmlText = "<b>" + KEYS.Get("pop_protection_title") + "</b>";
         if(BASE._isSanctuary)
         {
            _loc2_.tB.htmlText = KEYS.Get("pop_protection_body",{"v1":GLOBAL.ToTime(BASE._isProtected - GLOBAL.Timestamp(),false,false)});
         }
         else
         {
            _loc2_.tB.htmlText = KEYS.Get("pop_starterprotection_body",{"v1":GLOBAL.ToTime(BASE._isProtected - GLOBAL.Timestamp(),false,false)});
         }
         POPUPS.Push(_loc2_,null,null,"","greenbouncer.png");
      }
   }
}

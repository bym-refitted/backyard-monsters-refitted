package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   /*
   * This is the original DEFENSEEVENTPOPUP.as class for Wild Monster Invasion 1.
   * The original developers rewrote this class when Wild Monster Invasion 2 was released
   * instead of creating a new class.
   * 
   * This file archives the original implementation for reference and renamed to DEFENSEEVENTPOPUP_WM1.
   */
   public class DEFENSEEVENTPOPUP_WM1 extends DEFENSEEVENTPOPUP_CLIP
   {
      
      private static var _open:Boolean = false;
      
      private var bm:Bitmap;
      
      public function DEFENSEEVENTPOPUP_WM1(param1:int = 0)
      {
         var bannerComplete:Function = null;
         var imageComplete:Function = null;
         var popupnum:int = param1;
         bannerComplete = function(param1:String, param2:BitmapData):void
         {
            bm = new Bitmap(param2);
            mcBanner.addChild(bm);
            mcBanner.width = 672;
            mcBanner.height = 82;
         };
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            _loc3_.smoothing = true;
            mcImage.addChild(_loc3_);
            mcImage.width = 200;
            mcImage.height = 200;
         };
         super();
         if(popupnum == -1)
         {
            popupnum = Math.floor(Math.random() * 3) + 1;
         }
         if(popupnum == 4)
         {
            if(SPECIALEVENT.wave == 1)
            {
               rsvpBtn.Setup(KEYS.Get("wmi_buttonpopup2"),false,0,0);
               rsvpBtn.addEventListener(MouseEvent.CLICK,this.startDown);
            }
            else
            {
               rsvpBtn.visible = false;
            }
         }
         else if(popupnum == 5)
         {
            rsvpBtn.Setup(KEYS.Get("str_zazzle"),false,0,0);
            rsvpBtn.Highlight = true;
            rsvpBtn.addEventListener(MouseEvent.CLICK,this.merchandiseDown);
         }
         else
         {
            rsvpBtn.Setup(KEYS.Get("wmi_buttonpopup1"),false,0,0);
            rsvpBtn.addEventListener(MouseEvent.CLICK,this.rsvpDown);
         }
         ImageCache.GetImageWithCallBack("specialevent/monsterinvasionbannerred.jpg",bannerComplete);
         if(popupnum > 0 && popupnum < 5)
         {
            ImageCache.GetImageWithCallBack("specialevent/200x200_" + popupnum + ".jpg",imageComplete);
            mcText.htmlText = KEYS.Get("wmi_popup" + popupnum);
         }
         else if(popupnum == 5)
         {
            ImageCache.GetImageWithCallBack("specialevent/tshirt_v2.png",imageComplete);
            mcText.htmlText = KEYS.Get("wmi_tshirt");
         }
         mcFrame.Setup(true);
         _open = true;
      }
      
      public static function get open() : Boolean
      {
         return _open;
      }
      
      public function rsvpDown(param1:MouseEvent) : void
      {
         // GLOBAL.gotoURL("http://www.facebook.com/event.php?eid=141841065917218",null,true,null);
         GLOBAL.gotoURL("https://backyard-monsters.fandom.com/wiki/Wild_Monster_Invasion",null,true,null);
         POPUPS.Next();
      }
      
      public function startDown(param1:MouseEvent) : void
      {
         this.Hide();
      }
      
      private function merchandiseDown(param1:MouseEvent) : void
      {
         GLOBAL.gotoURL("http://www.zazzle.com/ultimate_i_survived_wild_monster_invasion_t_shirt-235246313457240737",null,true,[63,1]);
         POPUPS.Next();
      }
      
      public function Hide() : void
      {
         _open = false;
         POPUPS.Next();
      }
   }
}


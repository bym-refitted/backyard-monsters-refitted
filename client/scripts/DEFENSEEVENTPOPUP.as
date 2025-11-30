package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class DEFENSEEVENTPOPUP extends DEFENSEEVENTPOPUP_CLIP
   {
      
      private static var _open:Boolean = false;
       
      
      private var bm:Bitmap;
      
      public function DEFENSEEVENTPOPUP(param1:int = 0)
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
         rsvpBtn.Setup(KEYS.Get("wmi_buttonpopup1"),false,0,0);
         rsvpBtn.addEventListener(MouseEvent.CLICK,this.rsvpDown);
         ImageCache.GetImageWithCallBack(SPECIALEVENT.BANNERIMAGE,bannerComplete);
         if(popupnum > 0 && popupnum < 4)
         {
            ImageCache.GetImageWithCallBack("specialevent/wmi2_" + popupnum + ".jpg",imageComplete);
            mcText.htmlText = KEYS.Get("wmi2_popup" + popupnum);
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
         this.Hide();
         // GLOBAL.gotoURL("https://www.facebook.com/events/211384668938961/",null,true,null);
         GLOBAL.gotoURL("https://backyard-monsters.fandom.com/wiki/Wild_Monster_Invasion_2",null,true,null);
      }
      
      public function startDown(param1:MouseEvent) : void
      {
         this.Hide();
      }
      
      public function Hide() : void
      {
         _open = false;
         POPUPS.Next();
      }
   }
}

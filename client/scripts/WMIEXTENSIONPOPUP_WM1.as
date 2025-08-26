package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   /*
   * This is the original WMIEXTENSIONPOPUP.as class for Wild Monster Invasion 1.
   * The original developers rewrote this class when Wild Monster Invasion 2 was released
   * instead of creating a new class.
   * 
   * This file archives the original implementation for reference and renamed to WMIEXTENSIONPOPUP_WM1.
   */
   public class WMIEXTENSIONPOPUP_WM1 extends WMIEXTENSIONPOPUP_CLIP
   {
      
      private static var _open:Boolean = false;
      
      public function WMIEXTENSIONPOPUP_WM1()
      {
         var bannerComplete:Function = null;
         var imageComplete:Function = null;
         bannerComplete = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            _loc3_.smoothing = true;
            mcBanner.addChild(_loc3_);
            mcBanner.width = 672;
            mcBanner.height = 82;
         };
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            _loc3_.smoothing = true;
            mcImage.addChild(_loc3_);
            mcImage.width = 672;
            mcImage.height = 200;
         };
         super();
         ImageCache.GetImageWithCallBack("specialevent/monsterinvasionbannerred.jpg",bannerComplete);
         ImageCache.GetImageWithCallBack("specialevent/extension.png",imageComplete);
         mcFrame.Setup(true);
         closeBtn.Setup(KEYS.Get("btn_close"),false,0,0);
         closeBtn.addEventListener(MouseEvent.CLICK,this.CloseButtonClicked);
         mcText.htmlText = KEYS.Get("wmi_extension");
         _open = true;
      }
      
      public static function get open() : Boolean
      {
         return _open;
      }
      
      public function Hide() : void
      {
         _open = false;
         POPUPS.Next();
      }
      
      private function CloseButtonClicked(param1:MouseEvent) : void
      {
         this.Hide();
      }
   }
}


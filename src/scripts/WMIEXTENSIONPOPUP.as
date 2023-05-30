package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class WMIEXTENSIONPOPUP extends WMIEXTENSIONPOPUP_CLIP
   {
      
      private static var _open:Boolean = false;
       
      
      public function WMIEXTENSIONPOPUP()
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
         ImageCache.GetImageWithCallBack(SPECIALEVENT.BANNERIMAGE,bannerComplete);
         ImageCache.GetImageWithCallBack("specialevent/wmi2_4-v2.png",imageComplete);
         mcFrame.Setup(true);
         closeBtn.visible = false;
         mcText.htmlText = KEYS.Get("wmi2_popup4");
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

package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class SpecialRewardInfo extends SpecialInfo_CLIP
   {
       
      
      public function SpecialRewardInfo()
      {
         super();
      }
      
      public function Setup(param1:String, param2:int, param3:String) : void
      {
         var ImageLoaded:Function = null;
         var name:String = param1;
         var quantity:int = param2;
         var image:String = param3;
         ImageLoaded = function(param1:String, param2:BitmapData):void
         {
            mcImage.addChild(new Bitmap(param2));
            mcImage.width = 30;
            mcImage.height = 27;
         };
         if(quantity)
         {
            tName.htmlText = "<b>" + name + ": " + GLOBAL.FormatNumber(quantity) + "</b>";
         }
         else
         {
            tName.htmlText = "<b>" + name + "</b>";
         }
         ImageCache.GetImageWithCallBack(image,ImageLoaded);
      }
   }
}

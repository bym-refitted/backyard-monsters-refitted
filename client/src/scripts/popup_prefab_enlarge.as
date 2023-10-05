package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class popup_prefab_enlarge extends popup_prefab_enlarge_CLIP
   {
       
      
      public function popup_prefab_enlarge()
      {
         super();
      }
      
      public function Setup(param1:int) : void
      {
         ImageCache.GetImageWithCallBack("ui/prefab-large-" + (param1 + 1) + ".v5.jpg",this.ShowImage,true,1);
      }
      
      public function ShowImage(param1:String, param2:BitmapData) : void
      {
         this.mcImage.addChild(new Bitmap(param2));
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         GLOBAL.BlockerRemove();
         this.parent.removeChild(this);
      }
      
      public function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
   }
}

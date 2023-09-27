package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class BUILDING18 extends BWALL
   {
       
      
      public function BUILDING18()
      {
         super();
         _type = 18;
         _footprint = [new Rectangle(0,0,20,20)];
         _gridCost = [[new Rectangle(-10,-10,40,40),20],[new Rectangle(0,0,20,20),200]];
         _mcBase = MAP._BUILDINGBASES.addChild(new MovieClip()) as MovieClip;
         SetProps();
      }
      
      private function onAssetLoaded(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = null;
         if(param1 == imageData.shadowURL)
         {
            _loc3_ = _mcBase.addChild(new Bitmap(param2)) as Bitmap;
            _loc3_.x = imageData.shadowX;
            _loc3_.y = imageData.shadowY;
            _loc3_.blendMode = "multiply";
         }
         else if(param1 == imageData.topURL)
         {
            MovieClip(topContainer).addChild(new Bitmap(param2));
         }
      }
   }
}

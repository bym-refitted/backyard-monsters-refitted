package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="buildingInfo")]
   public dynamic class buildingInfo extends MovieClip
   {
       
      
      public var tInfoRight:TextField;
      
      public var tName:TextField;
      
      public var mcBG:MovieClip;
      
      public var tInfoLeft:TextField;
      
      public function buildingInfo()
      {
         super();
         stop();
      }
   }
}

package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="ResourceBar4")]
   public dynamic class ResourceBar4 extends MovieClip
   {
       
      
      public var mcHit:MovieClip;
      
      public var tR:TextField;
      
      public var bAdd:MovieClip;
      
      public var mcPoints:points_txt;
      
      public var mcBar:MovieClip;
      
      public function ResourceBar4()
      {
         super();
         if (mcBar) mcBar.stop();
         if (mcPoints) mcPoints.stop();
         if (bAdd) bAdd.stop();
      }
   }
}

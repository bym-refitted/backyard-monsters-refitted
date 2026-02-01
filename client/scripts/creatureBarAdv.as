package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="creatureBarAdv")]
   public dynamic class creatureBarAdv extends MovieClip
   {
       
      
      public var mcBar2:MovieClip;
      
      public var mcBar:MovieClip;
      
      public function creatureBarAdv()
      {
         super();
         if (mcBar) mcBar.stop();
         if (mcBar2) mcBar2.stop();
      }
   }
}

package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="creatureBarGuardian")]
   public dynamic class creatureBarGuardian extends MovieClip
   {
       
      
      public var mcBuff1:MovieClip;
      
      public var mcBuff2:MovieClip;
      
      public var mcBar:MovieClip;
      
      public var mcBuff3:MovieClip;
      
      public function creatureBarGuardian()
      {
         super();
         if (mcBar) mcBar.stop();
         if (mcBuff1) mcBuff1.stop();
         if (mcBuff2) mcBuff2.stop();
         if (mcBuff3) mcBuff3.stop();
      }
   }
}

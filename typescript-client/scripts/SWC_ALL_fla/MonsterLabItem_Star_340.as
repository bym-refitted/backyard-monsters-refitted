package SWC_ALL_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="SWC_ALL_fla.MonsterLabItem_Star_340")]
   public dynamic class MonsterLabItem_Star_340 extends MovieClip
   {
       
      
      public var tLevel:TextField;
      
      public function MonsterLabItem_Star_340()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

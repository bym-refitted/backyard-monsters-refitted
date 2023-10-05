package
{
   import flash.display.MovieClip;
   
   public dynamic class MapRoomPopup_InfernoDescent extends MovieClip
   {
       
      
      public var background_mc:frame_CLIP;
      
      public var bReturn:Button_CLIP;
      
      public var mcImage:MovieClip;
      
      public function MapRoomPopup_InfernoDescent()
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

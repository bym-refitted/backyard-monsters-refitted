package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="BasePlannerPopup_ExplorerContainer")]
   public dynamic class BasePlannerPopup_ExplorerContainer extends MovieClip
   {
       
      
      public var canvasmask:BasePlannerPopup_ExplorerCanvas;
      
      public var bg:BasePlannerPopup_ExplorerCanvas;
      
      public var mcScroller:MovieClip;
      
      public var canvas:MovieClip;
      
      public var mcframe:BasePlannerPopup_ExplorerFrame;
      
      public function BasePlannerPopup_ExplorerContainer()
      {
         super();
      }
   }
}

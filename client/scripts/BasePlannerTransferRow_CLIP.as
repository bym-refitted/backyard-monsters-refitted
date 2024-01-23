package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="BasePlannerTransferRow_CLIP")]
   public dynamic class BasePlannerTransferRow_CLIP extends MovieClip
   {
       
      
      public var tTemplateName:TextField;
      
      public var mcBackground:MovieClip;
      
      public var tSlotName:TextField;
      
      public var mcLock:SimpleButton;
      
      public var mcEdit:MovieClip;
      
      public var bTransfer:Button_CLIP;
      
      public function BasePlannerTransferRow_CLIP()
      {
         super();
      }
   }
}

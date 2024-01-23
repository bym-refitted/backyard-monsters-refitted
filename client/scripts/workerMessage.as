package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="workerMessage")]
   public dynamic class workerMessage extends MovieClip
   {
       
      
      public var txt:TextField;
      
      public var mcBG:MovieClip;
      
      public function workerMessage()
      {
         super();
      }
   }
}

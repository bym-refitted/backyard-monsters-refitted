package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="ChatBox_msg_CLIP")]
   public dynamic class ChatBox_msg_CLIP extends MovieClip
   {
       
      
      public var ignoreBtn:MovieClip;
      
      public var txt:TextField;
      
      public var bg:MovieClip;
      
      public function ChatBox_msg_CLIP()
      {
         super();
      }
   }
}

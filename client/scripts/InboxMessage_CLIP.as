package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="InboxMessage_CLIP")]
   public dynamic class InboxMessage_CLIP extends MovieClip
   {
       
      
      public var subject_txt:TextField;
      
      public var subjectType_txt:TextField;
      
      public var placeholder:MovieClip;
      
      public var b1:Button_CLIP;
      
      public var userid_txt:TextField;
      
      public var replies_txt:TextField;
      
      public var sent_txt:TextField;
      
      public var sender_txt:TextField;
      
      public var dot_mc:MovieClip;
      
      public var bg_mc:MovieClip;
      
      public function InboxMessage_CLIP()
      {
         super();
      }
   }
}

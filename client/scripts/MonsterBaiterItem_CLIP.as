package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="MonsterBaiterItem_CLIP")]
   public dynamic class MonsterBaiterItem_CLIP extends MovieClip
   {
       
      
      public var tInfo:TextField;
      
      public var tName:TextField;
      
      public var decr_btn:SimpleButton;
      
      public var mcIcon:HatcheryMonsterIcon_CLIP;
      
      public var incr_btn:SimpleButton;
      
      public function MonsterBaiterItem_CLIP()
      {
         super();
      }
   }
}

package
{
   public class UI_WARNING extends UI_WARNING_CLIP
   {
       
      
      public function UI_WARNING()
      {
         super();
      }
      
      public function Update(param1:String) : void
      {
         // Guard against the lossy assets.swf: the `mc` symbol can be missing its
         // `tText` child, so `mc.tText.htmlText` throws #1009 every frame during a
         // wild-monster attack (WMATTACK), freezing the game in a refresh loop.
         // Skipping the text keeps the warning banner working without crashing.
         if(mc != null && mc.tText != null)
         {
            mc.tText.htmlText = param1;
         }
      }
   }
}

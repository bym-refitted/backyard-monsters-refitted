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
         mc.tText.htmlText = param1;
      }
   }
}

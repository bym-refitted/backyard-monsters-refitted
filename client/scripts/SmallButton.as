package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SmallButton extends MovieClip
   {
       
      
      public var label_txt:TextField;
      
      private var _highlight:Boolean = false;
      
      public function SmallButton()
      {
         super();
         stop();
         mouseChildren = false;
         buttonMode = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.Over);
         addEventListener(MouseEvent.MOUSE_OUT,this.Out);
      }
      
      public function set Highlight(param1:Boolean) : void
      {
         this._highlight = param1;
         if(this._highlight)
         {
            gotoAndStop(3);
         }
         else
         {
            gotoAndStop(1);
         }
      }
      
      public function get Highlight() : Boolean
      {
         return this._highlight;
      }
      
      public function Over(param1:MouseEvent) : *
      {
         if(this._highlight)
         {
            gotoAndStop(4);
         }
         else
         {
            gotoAndStop(2);
         }
      }
      
      public function Out(param1:MouseEvent) : *
      {
         if(this._highlight)
         {
            gotoAndStop(3);
         }
         else
         {
            gotoAndStop(1);
         }
      }
   }
}

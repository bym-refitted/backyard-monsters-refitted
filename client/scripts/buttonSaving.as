package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class buttonSaving extends MovieClip
   {
       
      
      private var _bubble:bubblepopup5;
      
      public function buttonSaving()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.Over);
         addEventListener(MouseEvent.MOUSE_OUT,this.Out);
         addEventListener(Event.ENTER_FRAME,this.Tick);
         buttonMode = true;
      }
      
      private function Over(param1:MouseEvent) : void
      {
         this.Out();
         this._bubble = new bubblepopup5();
         this._bubble.x = 12;
         this._bubble.y = 20;
         this._bubble.mcText.autoSize = TextFieldAutoSize.LEFT;
         this._bubble.mouseChildren = this._bubble.mouseEnabled = false;
         if(currentFrame == 2)
         {
            this._bubble.mcText.htmlText = "<b>" + KEYS.Get("settings_saving") + "</b>";
         }
         else
         {
            this._bubble.mcText.htmlText = "<b>" + KEYS.Get("settings_saved") + "</b>";
         }
         this._bubble.mcText.x = 10 - this._bubble.mcText.width;
         this._bubble.mcBG.x = this._bubble.mcText.x - 5;
         this._bubble.mcBG.width = this._bubble.mcText.width + 10;
         this.addChild(this._bubble);
      }
      
      private function Tick(param1:Event) : void
      {
         if(Boolean(this._bubble) && Boolean(this._bubble.parent))
         {
            if(currentFrame == 2)
            {
               this._bubble.mcText.htmlText = "<b>" + KEYS.Get("settings_saving") + "</b>";
            }
            else
            {
               this._bubble.mcText.htmlText = "<b>" + KEYS.Get("settings_saved") + "</b>";
            }
         }
      }
      
      private function Out(param1:MouseEvent = null) : void
      {
         if(Boolean(this._bubble) && Boolean(this._bubble.parent))
         {
            this._bubble.parent.removeChild(this._bubble);
         }
      }
   }
}

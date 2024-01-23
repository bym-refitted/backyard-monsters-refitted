package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Button extends MovieClip
   {
       
      
      public var _highlight:Boolean = false;
      
      public var _enabled:Boolean = true;
      
      public var _selected:Boolean = false;
      
      public var _counter:int = 0;
      
      public var _txt:TextField;
      
      public var _format:TextFormat;
      
      public var _startY:int;
      
      public var _tab:Boolean;
      
      public var label:String;
      
      public var labelKey:String;
      
      public function Button()
      {
         super();
         this._startY = y;
         addEventListener(MouseEvent.MOUSE_OVER,this.Over);
         addEventListener(MouseEvent.MOUSE_OUT,this.Out);
         mouseChildren = false;
         buttonMode = true;
         this._format = new TextFormat();
         this._format.font = "Verdana";
         this._format.size = 9;
         this._format.align = TextFormatAlign.CENTER;
         this._format.color = 3355443;
         this._txt = new TextField();
         this._txt.selectable = false;
         this._txt.defaultTextFormat = this._format;
         this._txt.text = "xxxx";
         this._txt.width = 64;
         this._txt.height = 20;
         this.addChild(this._txt);
         this._txt.y = int(height / 2 - this._txt.height / 2 + 2);
         this._txt.x = 1;
         cacheAsBitmap = true;
      }
      
      public function Setup(param1:String = "", param2:Boolean = false, param3:int = 0, param4:int = 0) : void
      {
         this._tab = param2;
         if(param3 > 0)
         {
            width = param3;
         }
         if(param4 > 0)
         {
            height = param4;
         }
         if(param1)
         {
            this._txt.htmlText = "<b><font color=\"#333333\">" + param1 + "</font></b>";
            this.label = param1;
         }
         if(this._tab)
         {
            this._txt.y = 2;
         }
         this.Update();
      }
      
      public function SetupKey(param1:String = "", param2:Boolean = false, param3:int = 0, param4:int = 0) : void
      {
         this.labelKey = param1;
         this.Setup(KEYS.Get(this.labelKey),param2,param3,param4);
      }
      
      public function Update() : void
      {
         if(this._highlight)
         {
            gotoAndStop(4);
         }
         else if(this._enabled)
         {
            if(this._selected)
            {
               gotoAndStop(2);
            }
            else
            {
               gotoAndStop(1);
            }
         }
         else
         {
            gotoAndStop(3);
         }
      }
      
      public function Over(param1:MouseEvent) : void
      {
         if(this._highlight)
         {
            gotoAndStop(5);
         }
         else if(this._enabled)
         {
            gotoAndStop(2);
         }
      }
      
      public function Out(param1:MouseEvent) : void
      {
         if(this._highlight)
         {
            gotoAndStop(4);
         }
         else if(this._enabled)
         {
            if(this._selected)
            {
               gotoAndStop(2);
            }
            else
            {
               gotoAndStop(1);
            }
         }
      }
      
      public function get Enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this._enabled = param1;
            if(param1)
            {
               this._txt.alpha = 1;
               buttonMode = true;
            }
            else
            {
               this._txt.alpha = 0.5;
               buttonMode = false;
            }
            this.Update();
         }
      }
      
      public function get Highlight() : Boolean
      {
         return this._highlight;
      }
      
      public function set Highlight(param1:Boolean) : void
      {
         if(this._highlight != param1)
         {
            this._highlight = param1;
            this.Update();
         }
      }
      
      public function get Selected() : Boolean
      {
         return this._selected;
      }
      
      public function set Selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            this.Update();
         }
      }
      
      public function get Counter() : int
      {
         return this._counter;
      }
      
      public function set Counter(param1:int) : void
      {
         if(this._counter != param1)
         {
            this._counter = param1;
            this.Update();
         }
      }
   }
}

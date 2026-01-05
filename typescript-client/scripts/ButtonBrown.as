package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ButtonBrown extends MovieClip
   {
       
      
      public var _highlight:Boolean = false;
      
      public var _enabled:Boolean = true;
      
      public var _selected:Boolean = false;
      
      public var _counter:int = 0;
      
      public var _txt:TextField;
      
      public var _format:TextFormat;
      
      public var _formatHighlight:TextFormat;
      
      public var _startY:int;
      
      public var _tab:Boolean;
      
      public var label:String;
      
      public var labelKey:String;
      
      public var _onColor:Number = 3355443;
      
      public var _offColor:Number = 14398588;
      
      public function ButtonBrown()
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
         this._format.color = this._onColor;
         this._formatHighlight = new TextFormat();
         this._formatHighlight.font = "Verdana";
         this._formatHighlight.size = 9;
         this._formatHighlight.align = TextFormatAlign.CENTER;
         this._formatHighlight.color = this._offColor;
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
      
      public function Setup(param1:String = "", param2:Boolean = false, param3:int = 0, param4:int = 0, param5:String = "#333333") : void
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
            this._txt.htmlText = "<b><font color=\"" + param5 + "\">" + param1 + "</font></b>";
            this.label = param1;
         }
         this.Update();
      }
      
      public function SetupKey(param1:String = "", param2:Boolean = false, param3:int = 0, param4:int = 0, param5:String = "#333333") : void
      {
         this.labelKey = param1;
         this.Setup(KEYS.Get(this.labelKey),param2,param3,param4);
      }
      
      public function Update() : void
      {
         if(this._highlight)
         {
            gotoAndStop(4);
            this._txt.setTextFormat(this._format);
         }
         else if(this._enabled)
         {
            this._txt.setTextFormat(this._formatHighlight);
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
            this._txt.setTextFormat(this._formatHighlight);
            gotoAndStop(3);
         }
      }
      
      public function Over(param1:MouseEvent) : void
      {
         if(this._highlight)
         {
            gotoAndStop(5);
            this._txt.setTextFormat(this._formatHighlight);
         }
         else if(this._enabled)
         {
            gotoAndStop(2);
            this._txt.setTextFormat(this._format);
         }
      }
      
      public function Out(param1:MouseEvent) : void
      {
         if(this._highlight)
         {
            gotoAndStop(4);
            this._txt.setTextFormat(this._format);
         }
         else if(this._enabled)
         {
            if(this._selected)
            {
               gotoAndStop(2);
               this._txt.setTextFormat(this._format);
            }
            else
            {
               gotoAndStop(1);
               this._txt.setTextFormat(this._formatHighlight);
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

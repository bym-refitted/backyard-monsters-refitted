package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TUTORIALPOPUPMC extends TUTORIALPOPUPMC_CLIP
   {
       
      
      public var posX:int;
      
      public var posY:int;
      
      private var offsetX:int;
      
      private var offsetY:int;
      
      private var mcButton2:Button;
      
      private var m_fullScreenButton:MovieClip;
      
      private var m_origButtonWidth:Number;
      
      public function TUTORIALPOPUPMC(param1:int = 0, param2:int = 0)
      {
         super();
         mcButton.addEventListener(MouseEvent.CLICK,TUTORIAL.Advance);
         mcButton.Highlight = true;
         mcBlocker.mouseEnabled = true;
         mcText.autoSize = "left";
         this.posX = param1;
         this.posY = param2;
         this.m_origButtonWidth = mcButton.width;
         if(GLOBAL._local && GLOBAL._aiDesignMode)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.DragStart);
            addEventListener(MouseEvent.MOUSE_UP,this.DragStop);
         }
      }
      
      public function showTwoButtons(param1:String, param2:String, param3:Function) : void
      {
         mcArrow.visible = false;
         mcButton.width /= 2.4;
         mcButton.Highlight = false;
         mcButton.SetupKey(param1);
         this.mcButton2 = addChild(new Button_CLIP()) as Button;
         this.mcButton2.width = mcButton.width;
         this.mcButton2.x = mcButton.x + mcButton.width + 30;
         this.mcButton2.y = mcButton.y;
         this.mcButton2.addEventListener(MouseEvent.CLICK,param3);
         this.mcButton2.Highlight = true;
         this.mcButton2.SetupKey(param2);
      }
      
      public function Say(param1:String, param2:Boolean, param3:Boolean) : void
      {
         mcArrow.visible = true;
         mcText.htmlText = param1;
         if(TUTORIAL._stage < 200)
         {
            mcButton.SetupKey("tut_next_btn");
         }
         else
         {
            mcButton.SetupKey("tut_finish_btn");
         }
         if(param2)
         {
            mcBlocker.visible = true;
         }
         else
         {
            mcBlocker.visible = false;
         }
         mcArrow.visible = false;
         if(param3)
         {
            if(TUTORIAL._stage <= 5)
            {
               mcArrow.visible = true;
            }
            mcButton.width = this.m_origButtonWidth;
            mcButton.visible = true;
            mcBubble.height = mcText.height + 55;
         }
         else
         {
            mcButton.visible = false;
            mcBubble.height = mcText.height + 15;
         }
         if(this.mcButton2)
         {
            this.mcButton2.visible = false;
         }
         this.removeFullScreenButton();
         mcText.y = 0 - mcBubble.height + 10;
      }
      
      public function DragStart(param1:MouseEvent) : void
      {
         this.offsetX = GLOBAL._ROOT.mouseX - x;
         this.offsetY = GLOBAL._ROOT.mouseY - y;
         addEventListener(Event.ENTER_FRAME,this.Move);
      }
      
      public function DragStop(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.Move);
      }
      
      public function Move(param1:Event = null) : void
      {
         x = GLOBAL._ROOT.mouseX - this.offsetX;
         y = GLOBAL._ROOT.mouseY - this.offsetY;
      }
      
      public function SetPos(param1:int, param2:int) : void
      {
         this.posX = param1;
         this.posY = param2;
      }
      
      public function addFullScreenButton(param1:Function) : void
      {
         this.m_fullScreenButton = GAME._instance.stage.addChild(new buttonFullscreen_CLIP()) as MovieClip;
         this.m_fullScreenButton.x = UI2._top.localToGlobal(new Point(UI2._top.mcSound.x,UI2._top.mcSound.y)).x - 31;
         this.m_fullScreenButton.y = UI2._top.y;
         this.m_fullScreenButton.addEventListener(MouseEvent.CLICK,param1);
      }
      
      public function removeFullScreenButton() : void
      {
         if(this.m_fullScreenButton)
         {
            this.m_fullScreenButton.parent.removeChild(this.m_fullScreenButton);
            this.m_fullScreenButton = null;
         }
      }
      
      public function Resize() : void
      {
         x = GLOBAL.isFullScreen ? (GLOBAL._SCREENINIT.right - mcBubble.width) / 2 + this.posX : GLOBAL._SCREEN.x + this.posX;
         y = GLOBAL._SCREENINIT.y - GLOBAL._SCREEN.y + this.posY;
         mcBlocker.width = GLOBAL._SCREEN.width;
         mcBlocker.height = GLOBAL._SCREEN.height;
         mcBlocker.x = GLOBAL.isFullScreen ? -((mcBlocker.width - mcBubble.width) * 0.5 + this.posX) : -this.posX;
         mcBlocker.y = GLOBAL.isFullScreen ? -(mcBlocker.height * 0.5 - mcBubble.height * 1.5 + this.posY) : -this.posY;
         if(this.m_fullScreenButton)
         {
            this.m_fullScreenButton.x = UI2._top.localToGlobal(new Point(UI2._top.mcSound.x,UI2._top.mcSound.y)).x - 31;
            this.m_fullScreenButton.y = UI2._top.y;
         }
      }
   }
}

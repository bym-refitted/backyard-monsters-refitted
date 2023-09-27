package
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class frame1 extends MovieClip
   {
       
      
      private var _bottomLeft:Bitmap;
      
      private var _bottomRight:Bitmap;
      
      private var _topLeft:Bitmap;
      
      private var _topRight:Bitmap;
      
      private var _topMiddle:Bitmap;
      
      private var _bottomMiddle:Bitmap;
      
      private var _fillerLeft:Bitmap;
      
      private var _fillerRight:Bitmap;
      
      private var _fillerTop:Bitmap;
      
      private var _fillerBottom:Bitmap;
      
      private var _buttonClose:Bitmap;
      
      private var _buttonHelp:Bitmap;
      
      private var _buttonFullScreen:Bitmap;
      
      private var _background:Bitmap;
      
      private var _frameMC:MovieClip;
      
      private var _frameDO:DisplayObject;
      
      private var _backgroundMC:MovieClip;
      
      private var _backgroundDO:DisplayObject;
      
      public function frame1()
      {
         super();
         this.Setup(true,false,false);
      }
      
      public function Setup(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:int = 1, param5:int = 1, param6:int = 0) : void
      {
         var _loc7_:MovieClip = null;
         this.Clear();
         this._bottomLeft = new Bitmap(new frame1_bottom_left(0,0));
         this._bottomRight = new Bitmap(new frame1_bottom_right(0,0));
         this._topLeft = new Bitmap(new frame1_top_left(0,0));
         this._topRight = new Bitmap(new frame1_top_right(0,0));
         if(param4 == 1)
         {
            this._topMiddle = new Bitmap(new frame1_top_middle(0,0));
         }
         if(param4 == 2)
         {
            this._topMiddle = new Bitmap(new frame1_top_middle_2(0,0));
         }
         this._bottomMiddle = new Bitmap(new frame1_bottom_middle(0,0));
         this._fillerTop = new Bitmap(new frame1_filler_top(0,0));
         this._fillerLeft = new Bitmap(new frame1_filler_left(0,0));
         this._fillerRight = new Bitmap(new frame1_filler_right(0,0));
         this._fillerBottom = new Bitmap(new frame1_filler_bottom(0,0));
         if(param1)
         {
            this._buttonClose = new Bitmap(new frame1_button_close(0,0));
         }
         if(param2)
         {
            this._buttonHelp = new Bitmap(new frame1_button_help(0,0));
         }
         if(param3)
         {
            this._buttonFullScreen = new Bitmap(new frame1_button_fullscreen(0,0));
         }
         this._topRight.x = x + width - 123 + 10;
         this._topRight.y = y - 8;
         this._topLeft.x = x - 12;
         this._topLeft.y = y - 10;
         this._bottomLeft.x = x - 8;
         this._bottomLeft.y = y + height - 64 + 15;
         this._bottomRight.x = x + width - 112 + 12;
         this._bottomRight.y = y + height - 158 + 12;
         this._topMiddle.x = x + int(width * 0.5) - 140;
         if(param4 == 1)
         {
            this._topMiddle.y = y - 11;
         }
         if(param4 == 2)
         {
            this._topMiddle.y = y - 15;
         }
         this._bottomMiddle.x = x + int(width * 0.5) - 195;
         this._bottomMiddle.y = y + height - 14;
         if(param1)
         {
            this._buttonClose.x = x + width - 20;
         }
         if(param1)
         {
            this._buttonClose.y = y - 7;
         }
         if(param2)
         {
            this._buttonHelp.x = x + width - 50;
         }
         if(param2)
         {
            this._buttonHelp.y = y - 7;
         }
         if(param3 && param2)
         {
            this._buttonFullScreen.x = x + width - 80;
         }
         if(param3 && !param2)
         {
            this._buttonFullScreen.x = x + width - 50;
         }
         if(param3)
         {
            this._buttonFullScreen.y = y - 7;
         }
         this._fillerTop.x = x + 42;
         this._fillerTop.y = y - 5;
         this._fillerTop.width = width - 153;
         this._fillerLeft.x = x - 4;
         this._fillerLeft.y = y + 172;
         this._fillerLeft.height = height - 219;
         this._fillerRight.x = x + width - 14;
         this._fillerRight.y = y + 39;
         this._fillerRight.height = height - 158;
         this._fillerBottom.x = x + 50;
         this._fillerBottom.y = y + height - 10;
         this._fillerBottom.width = width - 100;
         this._frameMC = new MovieClip();
         this._frameMC.mouseEnabled = false;
         this._frameMC.addChild(this._fillerTop);
         if(height - 219 > 0)
         {
            this._frameMC.addChild(this._fillerLeft);
         }
         if(height - 216 > 0)
         {
            this._frameMC.addChild(this._fillerRight);
         }
         this._frameMC.addChild(this._fillerBottom);
         this._frameMC.addChild(this._bottomLeft);
         this._frameMC.addChild(this._bottomRight);
         this._frameMC.addChild(this._topLeft);
         this._frameMC.addChild(this._topRight);
         if(param4 > 0)
         {
            this._frameMC.addChild(this._topMiddle);
         }
         if(param5 > 0)
         {
            this._frameMC.addChild(this._bottomMiddle);
         }
         this._backgroundMC = new MovieClip();
         if(param1)
         {
            (_loc7_ = new MovieClip()).addChild(this._buttonClose);
            _loc7_.addEventListener(MouseEvent.CLICK,this.BtnClose);
            _loc7_.buttonMode = true;
            this._frameMC.addChild(_loc7_);
         }
         if(param2)
         {
            (_loc7_ = new MovieClip()).addChild(this._buttonHelp);
            _loc7_.addEventListener(MouseEvent.CLICK,this.BtnHelp);
            _loc7_.buttonMode = true;
            this._frameMC.addChild(_loc7_);
         }
         if(param3)
         {
            (_loc7_ = new MovieClip()).addChild(this._buttonFullScreen);
            _loc7_.addEventListener(MouseEvent.CLICK,this.BtnFullScreen);
            _loc7_.buttonMode = true;
            this._frameMC.addChild(_loc7_);
         }
         this._frameDO = parent.addChild(this._frameMC);
         var _loc8_:int = parent.getChildIndex(this);
         parent.setChildIndex(this._frameDO,_loc8_);
         this._backgroundDO = parent.addChild(this._backgroundMC);
         parent.setChildIndex(this._backgroundDO,param6);
         this.visible = false;
      }
      
      public function Clear() : void
      {
         if(Boolean(this._bottomLeft) && Boolean(this._bottomLeft.bitmapData))
         {
            this._bottomLeft.bitmapData.dispose();
            this._bottomLeft.bitmapData = null;
         }
         if(Boolean(this._bottomRight) && Boolean(this._bottomRight.bitmapData))
         {
            this._bottomRight.bitmapData.dispose();
            this._bottomRight.bitmapData = null;
         }
         if(Boolean(this._topLeft) && Boolean(this._topLeft.bitmapData))
         {
            this._topLeft.bitmapData.dispose();
            this._topLeft.bitmapData = null;
         }
         if(Boolean(this._topRight) && Boolean(this._topRight.bitmapData))
         {
            this._topRight.bitmapData.dispose();
            this._topRight.bitmapData = null;
         }
         if(Boolean(this._topMiddle) && Boolean(this._topMiddle.bitmapData))
         {
            this._topMiddle.bitmapData.dispose();
            this._topMiddle.bitmapData = null;
         }
         if(Boolean(this._bottomMiddle) && Boolean(this._bottomMiddle.bitmapData))
         {
            this._bottomMiddle.bitmapData.dispose();
            this._bottomMiddle.bitmapData = null;
         }
         if(Boolean(this._fillerTop) && Boolean(this._fillerTop.bitmapData))
         {
            this._fillerTop.bitmapData.dispose();
            this._fillerTop.bitmapData = null;
         }
         if(Boolean(this._fillerLeft) && Boolean(this._fillerLeft.bitmapData))
         {
            this._fillerLeft.bitmapData.dispose();
            this._fillerLeft.bitmapData = null;
         }
         if(Boolean(this._fillerRight) && Boolean(this._fillerRight.bitmapData))
         {
            this._fillerRight.bitmapData.dispose();
            this._fillerRight.bitmapData = null;
         }
         if(Boolean(this._fillerBottom) && Boolean(this._fillerBottom.bitmapData))
         {
            this._fillerBottom.bitmapData.dispose();
            this._fillerBottom.bitmapData = null;
         }
         if(Boolean(this._background) && Boolean(this._background.bitmapData))
         {
            this._background.bitmapData.dispose();
            this._background.bitmapData = null;
         }
         if(Boolean(this._buttonClose) && Boolean(this._buttonClose.bitmapData))
         {
            this._buttonClose.bitmapData.dispose();
            this._buttonClose.bitmapData = null;
         }
         if(Boolean(this._buttonHelp) && Boolean(this._buttonHelp.bitmapData))
         {
            this._buttonHelp.bitmapData.dispose();
            this._buttonHelp.bitmapData = null;
         }
         if(Boolean(this._buttonFullScreen) && Boolean(this._buttonFullScreen.bitmapData))
         {
            this._buttonFullScreen.bitmapData.dispose();
            this._buttonFullScreen.bitmapData = null;
         }
         try
         {
            if(this._frameDO.parent)
            {
               this._frameDO.parent.removeChild(this._frameDO);
            }
            if(this._backgroundDO.parent)
            {
               this._backgroundDO.parent.removeChild(this._backgroundDO);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function BtnClose(param1:MouseEvent = null) : void
      {
         if("Hide" in parent)
         {
            (parent as MovieClip).Hide();
         }
         else
         {
            POPUPS.Next();
         }
      }
      
      private function BtnHelp(param1:MouseEvent = null) : void
      {
         if("Help" in parent)
         {
            (parent as MovieClip).Help();
         }
      }
      
      private function BtnFullScreen(param1:MouseEvent = null) : void
      {
         GLOBAL.goFullScreen();
         if("FullScreen" in parent)
         {
            (parent as MovieClip).FullScreen();
         }
      }
   }
}

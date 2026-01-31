package
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;

   public class frame3 extends MovieClip
   {
       
      
      private var _bottomLeft:Bitmap;
      
      private var _bottomRight:Bitmap;
      
      private var _topLeft:Bitmap;
      
      private var _topRight:Bitmap;
      
      private var _fillerLeft:Bitmap;
      
      private var _fillerRight:Bitmap;
      
      private var _fillerTop:Bitmap;
      
      private var _fillerBottom:Bitmap;
      
      private var _buttonClose:Bitmap;
      
      private var _buttonHelp:Bitmap;
      
      private var _background:Bitmap;
      
      private var _frameMC:MovieClip;
      
      private var _frameDO:DisplayObject;
      
      private var _backgroundMC:MovieClip;
      
      private var _backgroundDO:DisplayObject;
      
      private var _customCloseFunction:Function = null;
      
      public function frame3()
      {
         super();
         this.Setup();
      }
      
      public function Setup(param1:Boolean = true, param2:Function = null) : void
      {
         var _loc3_:* = false;
         var _loc4_:MovieClip = null;
         this.Clear();
         this._customCloseFunction = param2;
         _loc3_ = "Help" in parent;
         this._bottomLeft = new Bitmap(new frame3_bottom_left(0,0));
         this._bottomRight = new Bitmap(new frame3_bottom_right(0,0));
         this._topLeft = new Bitmap(new frame3_top_left(0,0));
         this._topRight = new Bitmap(new frame3_top_right(0,0));
         this._fillerTop = new Bitmap(new frame3_filler_top(0,0));
         this._fillerLeft = new Bitmap(new frame3_filler_left(0,0));
         this._fillerRight = new Bitmap(new frame3_filler_right(0,0));
         this._fillerBottom = new Bitmap(new frame3_filler_bottom(0,0));
         this._background = new Bitmap(new frame3_background(0,0));
         this._buttonClose = new Bitmap(new frame_button_close(0,0));
         if(_loc3_)
         {
            this._buttonHelp = new Bitmap(new frame_button_help(0,0));
         }
         this._topLeft.x = x - 31;
         this._topLeft.y = y - 18;
         this._topRight.x = x + width - 80;
         this._topRight.y = y - 18;
         this._bottomLeft.x = x - 31;
         this._bottomLeft.y = y + height - 69 + 20;
         this._bottomRight.x = x + width - 80;
         this._bottomRight.y = y + height - 66 + 17;
         this._background.x = x + 10;
         this._background.y = y + 10;
         this._background.width = width - 20;
         this._background.height = height - 20;
         this._buttonClose.x = x + width - 32;
         this._buttonClose.y = y - 5;
         if(_loc3_)
         {
            this._buttonHelp.x = x + width - 55;
         }
         if(_loc3_)
         {
            this._buttonHelp.y = y - 5;
         }
         this._fillerTop.x = x + 56;
         this._fillerTop.y = y - 7;
         this._fillerTop.width = width - 105;
         this._fillerLeft.x = x - 8;
         this._fillerLeft.y = y + 50;
         this._fillerLeft.height = height - 80;
         this._fillerRight.x = x + width - 16;
         this._fillerRight.y = y + 50;
         this._fillerRight.height = height - 95;
         this._fillerBottom.x = x + 40;
         this._fillerBottom.y = y + height - 11;
         this._fillerBottom.width = width - 90;
         this._frameMC = new MovieClip();
         this._frameMC.mouseEnabled = false;
         this._frameMC.addChild(this._background);
         this._frameMC.addChild(this._fillerTop);
         if(height > 100)
         {
            this._frameMC.addChild(this._fillerLeft);
         }
         if(height > 95)
         {
            this._frameMC.addChild(this._fillerRight);
         }
         this._frameMC.addChild(this._fillerBottom);
         this._frameMC.addChild(this._bottomLeft);
         this._frameMC.addChild(this._bottomRight);
         this._frameMC.addChild(this._topLeft);
         this._frameMC.addChild(this._topRight);
         if(param1)
         {
            (_loc4_ = new MovieClip()).addChild(this._buttonClose);
            _loc4_.addEventListener(MouseEvent.CLICK,this.BtnClose);
            _loc4_.buttonMode = true;
            this._frameMC.addChild(_loc4_);
         }
         if(param1 && _loc3_)
         {
            (_loc4_ = new MovieClip()).addChild(this._buttonHelp);
            _loc4_.addEventListener(MouseEvent.CLICK,this.BtnHelp);
            _loc4_.buttonMode = true;
            this._frameMC.addChild(_loc4_);
         }
         this._frameDO = parent.addChild(this._frameMC);
         var _loc5_:int = parent.getChildIndex(this);
         parent.setChildIndex(this._frameDO,_loc5_);
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
         else if(Boolean(this._customCloseFunction))
         {
            this._customCloseFunction();
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

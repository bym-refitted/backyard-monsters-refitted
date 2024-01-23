package com.monsters.display
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ScrollSetV extends ScrollSet_CLIP
   {
       
      
      private var _defaultScrollHeight:Number;
      
      private var _content:DisplayObject;
      
      private var _mask:DisplayObject;
      
      private var _scroller:MovieClip;
      
      private var _track:DisplayObject;
      
      public function ScrollSetV(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false)
      {
         super();
         this._content = param1;
         this._mask = param2;
         this._scroller = mcScroller;
         this._scroller.buttonMode = param3;
         this._defaultScrollHeight = this._scroller.height;
         this._scroller.y = 0;
         this._track = mcBG;
         this._track.height = param2.height;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._content.addEventListener(Event.RESIZE,this.onContentResize);
         this._content.addEventListener(MouseEvent.CLICK,this.onContentResize);
         this.onContentResize();
         this.mcScroller.gotoAndStop(1);
      }
      
      public function checkResize() : void
      {
         this.onContentResize();
      }
      
      protected function onContentResize(param1:Event = null) : void
      {
         visible = this._content.height <= this._mask.height ? false : true;
         this.updateScrollerSize();
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._scroller.startDrag(false,new Rectangle(this._scroller.x,0,0,height - this._scroller.height));
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._scroller.stopDrag();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = this._scroller.y / (height - this._scroller.height);
         this._content.y = this._mask.y + _loc2_ * -(this._content.height - this._mask.height);
      }
      
      private function updateScrollerSize() : void
      {
         this._scroller.height = this._defaultScrollHeight * (this._mask.height / this._content.height);
         this._track.height = this._mask.height;
         if(this._content.y < -this._content.height || this._content.height <= this._mask.height)
         {
            this._content.y = 0;
            this._scroller.y = 0;
         }
      }
   }
}

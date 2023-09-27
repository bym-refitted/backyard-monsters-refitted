package com.monsters.display
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class ScrollSetH extends ScrollSetH_CLIP
   {
       
      
      private var _defaultScrollWidth:Number;
      
      private var _content:DisplayObject;
      
      private var _mask:DisplayObject;
      
      private var _scroller:MovieClip;
      
      private var _track:DisplayObject;
      
      public function ScrollSetH(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false)
      {
         super();
         this._content = param1;
         this._mask = param2;
         this._scroller = mcScroller;
         this._scroller.buttonMode = param3;
         this._defaultScrollWidth = this._scroller.width;
         this._track = mcBG;
         this._track.width = param2.width;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this._content.addEventListener(Event.RESIZE,this.onContentResize);
         this.onContentResize();
      }
      
      protected function onContentResize(param1:Event = null) : void
      {
         visible = this._content.width <= this._mask.width ? false : true;
         this.updateScrollerSize();
      }
      
      protected function onMouseDown(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._scroller.startDrag(false,new Rectangle(0,this._scroller.y,width - this._scroller.width,0));
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this._scroller.stopDrag();
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = this._scroller.x / (width - this._scroller.width);
         this._content.x = this._mask.x + _loc2_ * -(this._content.width - this._mask.width);
      }
      
      private function updateScrollerSize() : void
      {
         this._scroller.width = this._defaultScrollWidth * (this._mask.width / this._content.width);
      }
   }
}

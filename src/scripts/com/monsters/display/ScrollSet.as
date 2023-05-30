package com.monsters.display
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import gs.TweenLite;
   
   public class ScrollSet extends ScrollSet_CLIP
   {
      
      public static const BROWN:int = 0;
      
      public static const GREY:int = 1;
      
      private static const NUM_COLORS:int = 2;
       
      
      private var _IsInitialized:Boolean = false;
      
      private var _Container:Sprite;
      
      private var _ContainerHeight:int;
      
      private var _Mask:MovieClip;
      
      private var _ScrollBarHeight:Number;
      
      private var _OffsetY:Number = 0;
      
      private var _Easing:Number = 1;
      
      private var _Margin:Number = 1;
      
      private var _Thresh:Number = 0.03;
      
      private var _BottomPadding:Number = 0;
      
      private var _AutoHideEnabled:Boolean = true;
      
      public var isHiddenWhileUnnecessary:Boolean = false;
      
      private var _MinScrollerHeight:Number;
      
      private var _IsDragging:Boolean = false;
      
      public function ScrollSet()
      {
         super();
      }
      
      public function Init(param1:Sprite, param2:MovieClip, param3:int = 0, param4:Number = 0, param5:Number = 128, param6:Number = 30, param7:Number = 0) : void
      {
         var _loc8_:Number = NaN;
         this._Container = param1;
         this._ContainerHeight = param1.height;
         this._Mask = param2;
         this._ScrollBarHeight = param5;
         this._MinScrollerHeight = param6;
         this._OffsetY = param4;
         this._BottomPadding = param7;
         param3 = GLOBAL.InfernoMode() ? 1 : 0;
         if(param3 < 0 || param3 >= NUM_COLORS)
         {
            return;
         }
         switch(param3)
         {
            case BROWN:
               this.mcScroller.gotoAndStop(1);
               break;
            case GREY:
               this.mcScroller.gotoAndStop(2);
         }
         this.mcScroller.y = this._Margin;
         this.mcBG.height = param5;
         this.mcScroller.useHandCursor = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.Show,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.Hide,false,0,true);
         this._Container.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         this.mcScroller.addEventListener(MouseEvent.MOUSE_DOWN,this.ScrollerDown,false,0,true);
         if(Boolean(this.parent) && param1.height < this._Mask.height)
         {
            this.parent.removeChild(this);
         }
         else
         {
            if(param1.height == 0)
            {
               param1.height = 1;
            }
            _loc8_ = param5 * (param2.height / param1.height);
            this.mcScroller.height = _loc8_ < param6 ? param6 : _loc8_;
            this.Show();
         }
         this._IsInitialized = true;
      }
      
      protected function onResize(param1:MouseEvent) : void
      {
         this.Update();
      }
      
      public function Update() : void
      {
         this.ResizeScroller();
         if(this._Mask.height != this._ScrollBarHeight)
         {
            this.ResizeScrollBar();
         }
         this._ContainerHeight = this._Container.height;
         if(mcScroller.height + mcScroller.y > this._Mask.height)
         {
            mcScroller.y = this._Mask.height - mcScroller.height;
         }
         if(this.isHiddenWhileUnnecessary)
         {
            if(this._ContainerHeight <= this._Mask.height)
            {
               visible = false;
            }
            else
            {
               visible = true;
            }
         }
         var _loc1_:int = GLOBAL.InfernoMode() ? 1 : 0;
         if(_loc1_ < 0 || _loc1_ >= NUM_COLORS)
         {
            return;
         }
         switch(_loc1_)
         {
            case BROWN:
               this.mcScroller.gotoAndStop(1);
               break;
            case GREY:
               this.mcScroller.gotoAndStop(2);
         }
      }
      
      private function ResizeScroller() : void
      {
         var _loc1_:Number = this._Mask.height / this._Container.height;
         _loc1_ = Math.min(_loc1_,1);
         var _loc2_:Number = this.mcBG.height * _loc1_;
         _loc2_ = _loc2_ < this._MinScrollerHeight ? this._MinScrollerHeight : _loc2_;
         _loc2_ = Math.min(_loc2_,this._ScrollBarHeight);
         this.mcScroller.height = _loc2_;
      }
      
      private function ResizeScrollBar() : void
      {
         this._ScrollBarHeight = this._Mask.height;
         this.mcBG.height = this._Mask.height;
      }
      
      private function ScrollerDown(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.OnStageUp);
         addEventListener(Event.ENTER_FRAME,this.OnDrag);
         var _loc2_:Rectangle = new Rectangle(this.mcScroller.x,this.mcBG.y + this._Margin,0,this.mcBG.height - this.mcScroller.height - 2 * this._Margin);
         this.mcScroller.startDrag(false,_loc2_);
         this._IsDragging = true;
      }
      
      private function OnDrag(param1:Event = null) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Number = (this._Margin + this.mcScroller.y) / (this.mcBG.height - this.mcScroller.height - this._Margin);
         if(_loc2_ < this._Thresh)
         {
            _loc2_ = 0;
         }
         if(_loc2_ > 1 - this._Thresh)
         {
            _loc2_ = 1;
         }
         var _loc3_:Number = this._OffsetY - _loc2_ * (this._ContainerHeight - this._Mask.height + this._BottomPadding);
         if(this._Easing != 0)
         {
            _loc4_ = this._Container.y - (this._Container.y - _loc3_) / this._Easing;
            this._Container.y = int(_loc4_);
         }
         else
         {
            this._Container.y = int(_loc3_);
         }
      }
      
      private function OnStageUp(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.OnDrag);
         this.mcScroller.stopDrag();
         this._IsDragging = false;
      }
      
      public function Show(param1:MouseEvent = null) : void
      {
         TweenLite.to(this,0.3,{"alpha":1});
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         if(!this._IsDragging && this._AutoHideEnabled)
         {
            TweenLite.to(this,0.3,{"alpha":0.2});
         }
      }
      
      public function ScrollTo(param1:Number, param2:Boolean = false) : void
      {
         var tgtY:Number;
         var oldEase:Number = NaN;
         var pctY:Number = param1;
         var instant:Boolean = param2;
         if(!this._IsInitialized)
         {
            return;
         }
         TweenLite.killTweensOf(this.mcScroller);
         oldEase = this._Easing;
         this._Easing = 1;
         tgtY = pctY * (this.mcBG.height - this.mcScroller.height - this._Margin) + this._Margin;
         if(instant)
         {
            this.mcScroller.y = tgtY;
            this.OnDrag();
         }
         else
         {
            TweenLite.to(this.mcScroller,0.6,{
               "y":tgtY,
               "onUpdate":this.OnDrag,
               "onComplete":function():void
               {
                  _Easing = oldEase;
               }
            });
         }
      }
      
      public function get AutoHideEnabled() : Boolean
      {
         return this._AutoHideEnabled;
      }
      
      public function set AutoHideEnabled(param1:Boolean) : void
      {
         this._AutoHideEnabled = param1;
      }
      
      public function get BottomPadding() : Number
      {
         return this._BottomPadding;
      }
      
      public function set BottomPadding(param1:Number) : void
      {
         this._BottomPadding = param1;
      }
      
      public function get ContainerHeight() : Number
      {
         return this._ContainerHeight;
      }
      
      public function set ContainerHeight(param1:Number) : void
      {
         this._ContainerHeight = param1;
      }
      
      public function get ScrollerBarHeight() : Number
      {
         return this._ScrollBarHeight;
      }
      
      public function set ScrollerBarHeight(param1:Number) : void
      {
         this._ScrollBarHeight = param1;
      }
      
      public function get Easing() : Number
      {
         return this._Easing;
      }
      
      public function set Easing(param1:Number) : void
      {
         this._Easing = param1;
      }
      
      public function get IsDragging() : Boolean
      {
         return this._IsDragging;
      }
   }
}

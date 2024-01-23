package com.monsters.baseplanner.components
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class PlannerItem extends Sprite
   {
       
      
      public var mc:MovieClip;
      
      public var size:Rectangle;
      
      public function PlannerItem()
      {
         super();
         addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      public function remove() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(MouseEvent.CLICK,this.onRollOver);
         removeEventListener(MouseEvent.CLICK,this.onRollOut);
         removeEventListener(MouseEvent.CLICK,this.onMouseDown);
         removeEventListener(MouseEvent.CLICK,this.onMouseUp);
      }
      
      public function update() : void
      {
      }
      
      public function onClick(param1:MouseEvent = null) : void
      {
      }
      
      public function onRollOver(param1:MouseEvent = null) : void
      {
      }
      
      public function onRollOut(param1:MouseEvent = null) : void
      {
      }
      
      public function onMouseDown(param1:MouseEvent = null) : void
      {
      }
      
      public function onMouseUp(param1:MouseEvent = null) : void
      {
      }
   }
}

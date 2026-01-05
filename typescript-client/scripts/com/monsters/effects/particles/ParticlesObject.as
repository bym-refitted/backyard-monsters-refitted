package com.monsters.effects.particles
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.easing.Sine;
   
   public class ParticlesObject extends ParticlesObject_CLIP
   {
       
      
      private var _frame:int = 0;
      
      private var _id:int;
      
      private var _targetPoint:Point;
      
      private var _target:MovieClip;
      
      public var _cleared:Boolean;
      
      private var xd:Number;
      
      private var yd:Number;
      
      private var _targetRotation:Number;
      
      private var _speed:Number;
      
      public function ParticlesObject()
      {
         super();
      }
      
      public function init(param1:int, param2:Point, param3:Point, param4:Number, param5:Number, param6:Number) : void
      {
         this._id = param1;
         visible = false;
         this._cleared = false;
         x = param2.x;
         y = param2.y;
         scaleX = scaleY = param6;
         var _loc7_:Number;
         if((_loc7_ = Math.sqrt(param4 * 0.3) * 0.2) < 0.3)
         {
            _loc7_ = 0.3;
         }
         TweenLite.to(this,_loc7_,{
            "x":param3.x,
            "y":param3.y,
            "visible":true,
            "ease":Sine.easeInOut,
            "delay":param5,
            "onComplete":this.Arrived,
            "overwrite":false
         });
         TweenLite.to(mcDot,_loc7_ / 2,{
            "y":-(_loc7_ * 50),
            "ease":Sine.easeOut,
            "delay":param5,
            "overwrite":0
         });
         TweenLite.to(mcDot,_loc7_ / 2,{
            "y":0,
            "ease":Sine.easeIn,
            "delay":_loc7_ / 2 + param5,
            "overwrite":0
         });
         cacheAsBitmap = true;
      }
      
      private function Arrived() : void
      {
         if(!this._cleared)
         {
            Particles.SnapShot(x,y,scaleX,this);
            Particles.Remove(this._id);
         }
      }
      
      public function Clear() : void
      {
         this._cleared = true;
      }
   }
}

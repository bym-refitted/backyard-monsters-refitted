package com.monsters.maproom_inferno
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import gs.TweenLite;
   
   public class Ring extends Sprite
   {
      
      private static var actives:Object = {};
       
      
      public function Ring(param1:Number, param2:uint)
      {
         super();
         this.graphics.beginFill(0,0);
         this.graphics.lineStyle(param1,param2);
         this.graphics.drawEllipse(-10,-10,20,20);
         this.graphics.endFill();
      }
      
      public static function MakeRings(param1:int, param2:Number, param3:DisplayObjectContainer, param4:Number, param5:Number, param6:Number = 20, param7:Number = 1, param8:Number = 2, param9:uint = 65280) : void
      {
         var _loc10_:Sprite = null;
         (_loc10_ = new Sprite()).x = param4;
         _loc10_.y = param5;
         param3.addChild(_loc10_);
         var _loc11_:Number = 1000 * param2 / param1;
         var _loc12_:Timer = new Timer(_loc11_,param1 - 1);
         actives[_loc12_] = {
            "color":param9,
            "rc":0,
            "make":param1,
            "container":_loc10_,
            "endSize":param6,
            "growTime":param7,
            "ringWidth":param8
         };
         _loc12_.addEventListener(TimerEvent.TIMER,onTimer);
         _loc12_.start();
         _loc12_.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
      }
      
      private static function onTimer(param1:TimerEvent = null) : void
      {
         var _loc3_:Ring = null;
         var _loc2_:Object = actives[param1.target];
         if(Boolean(_loc2_) && _loc2_.rc++ < _loc2_.make)
         {
            _loc3_ = new Ring(_loc2_.ringWidth,_loc2_.color);
            _loc3_.width = 0;
            _loc3_.height = 0;
            _loc2_.container.addChild(_loc3_);
            TweenLite.to(_loc3_,_loc2_.growTime,{
               "width":_loc2_.endSize,
               "height":_loc2_.endSize,
               "onComplete":_loc3_.kill,
               "alpha":0
            });
         }
         else if(Boolean(param1.target) && Boolean(_loc2_))
         {
            _loc2_.container.parent.removeChild(_loc2_.container);
            delete actives[param1.target];
         }
      }
      
      public function kill() : void
      {
         parent.removeChild(this);
      }
   }
}

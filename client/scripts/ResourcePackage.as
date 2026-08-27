package
{
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.easing.Sine;
   
   public class ResourcePackage extends ResourcePackage_CLIP
   {
       
      
      private var _frame:int = 0;
      
      private var _id:int;
      
      private var _targetPoint:Point;
      
      private var _target:BFOUNDATION;
      
      private var xd:Number;
      
      private var yd:Number;
      
      private var _targetRotation:Number;
      
      private var _speed:Number;
      
      public function ResourcePackage(param1:Point, param2:Point, param3:int, param4:int, param5:int, param6:int = 0, param7:BFOUNDATION = null, param8:Number = 0)
      {
         var time:Number;
         var Sound:Function = null;
         var sourcePoint:Point = param1;
         var targetPoint:Point = param2;
         var startHeight:int = param3;
         var endHeight:int = param4;
         var type:int = param5;
         var id:int = param6;
         var target:BFOUNDATION = param7;
         var delay:Number = param8;
         super();
         Sound = function():void
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               SOUNDS.Play("ibankfire");
            }
            else
            {
               SOUNDS.Play("bankfire");
            }
         };
         this._target = target;
         visible = false;
         x = sourcePoint.x;
         y = sourcePoint.y;
         this._id = id;
         // mcDot (the flying resource icon) / mcShadow may not be auto-instantiated by the
         // iOS AIR interpreter (they come up null -> #1009 for every collected package).
         // Recreate mcDot so the collect animation still plays; mcShadow (a plain decorative
         // shadow) is optional and just skipped when absent.
         if(!mcDot)
         {
            mcDot = new packagedot();
            addChildAt(mcDot,0);
         }
         if(mcShadow)
         {
            mcShadow.y = startHeight;
            mcShadow.x = startHeight / 2;
            mcShadow.cacheAsBitmap = true;
         }
         mcDot.gotoAndStop(type);
         mcDot.cacheAsBitmap = true;
         time = Point.distance(targetPoint,sourcePoint) + Math.random() * 50;
         time /= 150;
         if(time < 0.8)
         {
            time = 0.8;
         }
         TweenLite.to(this,time,{
            "x":targetPoint.x,
            "y":targetPoint.y,
            "visible":true,
            "ease":Sine.easeInOut,
            "delay":delay,
            "onStart":Sound,
            "onComplete":this.Arrived
         });
         TweenLite.to(mcDot,time / 2,{
            "y":-(time * 120),
            "ease":Sine.easeOut,
            "delay":delay,
            "overwrite":0
         });
         TweenLite.to(mcDot,time / 2,{
            "y":0,
            "ease":Sine.easeIn,
            "delay":time / 2 + delay,
            "overwrite":0
         });
         if(mcShadow)
         {
            TweenLite.to(mcShadow,time / 2,{
               "x":startHeight / 2 + time * 100,
               "alpha":0,
               "ease":Sine.easeOut,
               "delay":delay,
               "overwrite":0
            });
            TweenLite.to(mcShadow,time / 2,{
               "x":endHeight / 2,
               "y":endHeight,
               "alpha":1,
               "ease":Sine.easeIn,
               "delay":time / 2 + delay,
               "overwrite":0
            });
         }
      }
      
      private function Arrived() : void
      {
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.Play("ibankland");
         }
         else
         {
            SOUNDS.Play("bankland");
         }
         if(this._target)
         {
            this._target._hasResources = true;
         }
         ResourcePackages.Remove(this._id);
      }
   }
}

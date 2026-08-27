package
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.TransformGestureEvent;
   import flash.geom.Point;
   import flash.ui.Multitouch;
   import flash.ui.MultitouchInputMode;

   // iOS: free, continuous pinch-to-zoom (Clash-of-Clans style), replacing the 2-level toggle feel.
   //
   // GESTURE input mode keeps single-touch MOUSE events (the whole game polls mouseX / MOUSE_DOWN/UP)
   // and adds multi-finger gestures. We apply the zoom DIRECTLY on each gesture event (immediate, no
   // easing lag) about the pinch focal point, and sync the camera target so MAP.Scroll clamps to
   // bounds. Quality is left at full (renderMode=direct offloads the composite to the GPU, so the
   // zoom stays smooth without dropping quality). Client-side view only, no ban risk.
   public class PINCHZOOM
   {
      public static const MIN:Number = 0.45; // most zoomed-OUT
      public static const MAX:Number = 2.40; // most zoomed-IN (vector stays crisp when close)

      private static var _setup:Boolean = false;
      private static var _stage:Stage;

      public static function setup(stage:Stage) : void
      {
         if(_setup || !stage)
         {
            return;
         }
         _setup = true;
         _stage = stage;
         try
         {
            if(Multitouch.supportsGestureEvents)
            {
               Multitouch.inputMode = MultitouchInputMode.GESTURE;
               stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom);
            }
         }
         catch(e:Error)
         {
         }
      }

      private static function onZoom(e:TransformGestureEvent) : void
      {
         try
         {
            var g:Sprite = MAP._GROUND;
            if(!g)
            {
               return;
            }
            var ns:Number = g.scaleX * e.scaleX;
            if(ns < MIN)
            {
               ns = MIN;
            }
            else if(ns > MAX)
            {
               ns = MAX;
            }
            if(ns != g.scaleX)
            {
               // keep the content pixel under the fingers fixed while scaling
               var focal:Point = new Point(e.localX,e.localY);
               var before:Point = g.globalToLocal(focal);
               g.scaleX = g.scaleY = ns;
               var after:Point = g.localToGlobal(before);
               g.x += focal.x - after.x;
               g.y += focal.y - after.y;
               GLOBAL._zoomed = ns < 0.75;      // keep MAP.Scroll's bounds clamp roughly right
               MAP.tx = MAP.targX = g.x;         // sync camera target so Scroll won't ease it away
               MAP.ty = MAP.targY = g.y;
            }
         }
         catch(err:Error)
         {
         }
      }
   }
}

package
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import gs.*;
   import gs.easing.*;
   
   public class TUTORIALARROWMC extends TUTORIALARROWMC_CLIP
   {
       
      
      private var offsetX:Number;
      
      private var offsetY:Number;
      
      private var dragging:Boolean = false;
      
      private var wobbleCountdown:int = 0;
      
      public var posX:Number;
      
      public var posY:Number;
      
      public var Resize:Function;
      
      public var ResizeParams:Array;
      
      public function TUTORIALARROWMC(param1:Number = 0, param2:Number = 0)
      {
         var posx:Number = param1;
         var posy:Number = param2;
         super();
         this.posX = posx;
         this.posY = posy;
         if(GLOBAL._local)
         {
            this.addEventListener(MouseEvent.MOUSE_DOWN,this.DragStart);
            MAP.stage.addEventListener(MouseEvent.MOUSE_UP,this.DragStop);
         }
         else
         {
            this.mouseEnabled = false;
            this.mouseChildren = false;
            mcArrow.mouseEnabled = false;
            mcArrow.mouseChildren = false;
         }
         this.addEventListener(Event.ENTER_FRAME,this.Wobble);
         this.ResizeParams = new Array();
         this.Resize = function():void
         {
            var _loc1_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:Object = null;
            var _loc2_:int = GLOBAL._ROOT.stage.stageWidth;
            var _loc3_:Point = new Point();
            if(ResizeParams)
            {
               if(ResizeParams[0] == "percent" && ResizeParams[1] && ResizeParams[1] is Point)
               {
                  x = GLOBAL._SCREEN.x + posX * (GLOBAL._SCREEN.width / GLOBAL._SCREENINIT.width);
                  y = GLOBAL._SCREEN.y + posY * (GLOBAL._SCREEN.height / GLOBAL._SCREENINIT.height);
               }
               else if(ResizeParams[0] == "mc" && ResizeParams[1] && ResizeParams[1] is DisplayObject)
               {
                  _loc4_ = int(ResizeParams[1].x);
                  _loc5_ = int(ResizeParams[1].y);
                  _loc6_ = ResizeParams[1].parent;
                  while(Boolean(_loc6_) && Boolean(_loc6_.parent))
                  {
                     _loc4_ += _loc6_.x;
                     _loc5_ += _loc6_.y;
                     if(_loc6_.parent == GLOBAL._ROOT.stage)
                     {
                        break;
                     }
                     _loc6_ = _loc6_.parent;
                  }
                  if(ResizeParams[2])
                  {
                     _loc4_ += ResizeParams[2].x;
                     _loc5_ += ResizeParams[2].y;
                  }
                  x = _loc4_;
                  y = _loc5_;
               }
            }
            else
            {
               x = GLOBAL._SCREEN.x + posX * (GLOBAL._SCREEN.width / GLOBAL._SCREENINIT.width);
               y = GLOBAL._SCREEN.y + posY * (GLOBAL._SCREEN.height / GLOBAL._SCREENINIT.height);
            }
            Rotate();
         };
      }
      
      public function DragStart(param1:MouseEvent) : void
      {
         this.dragging = true;
         this.offsetX = GLOBAL._ROOT.mouseX - this.x;
         this.offsetY = GLOBAL._ROOT.mouseY - this.y;
         this.addEventListener(Event.ENTER_FRAME,this.Move);
      }
      
      public function DragStop(param1:MouseEvent) : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.Move);
         if(this.dragging)
         {
         }
         this.dragging = false;
      }
      
      public function Move(param1:Event = null) : void
      {
         this.x = GLOBAL._ROOT.mouseX - this.offsetX;
         this.y = GLOBAL._ROOT.mouseY - this.offsetY;
         this.Rotate();
      }
      
      public function Rotate() : void
      {
         if(this.ResizeParams && this.ResizeParams[3] && this.ResizeParams[3] is int)
         {
            mcArrow.rotation = this.ResizeParams[3];
            if(mcArrow.rotation >= 0)
            {
               mcArrow.mcArrow.gotoAndStop(1);
            }
            else
            {
               mcArrow.mcArrow.gotoAndStop(2);
            }
         }
         else
         {
            if(y < GLOBAL._ROOT.stage.stageHeight / 2)
            {
               mcArrow.rotation = this.x / (6 / GLOBAL._SCREENINIT.width * GLOBAL._ROOT.stage.stageWidth) + 130;
            }
            else
            {
               mcArrow.rotation = (0 - this.x) / (6 / GLOBAL._SCREENINIT.width * GLOBAL._ROOT.stage.stageWidth) + 45;
            }
            if(x < GLOBAL._ROOT.stage.stageWidth / 2)
            {
               mcArrow.mcArrow.gotoAndStop(1);
            }
            else
            {
               mcArrow.mcArrow.gotoAndStop(2);
            }
         }
      }
      
      public function Wobble(param1:Event) : void
      {
         if(this.wobbleCountdown == 0)
         {
            this.wobbleCountdown = 80;
            mcArrow.mcArrow.y = -60;
            TweenLite.to(mcArrow.mcArrow,0.6,{
               "y":-70,
               "ease":Expo.easeInOut,
               "onComplete":this.WobbleB
            });
         }
         --this.wobbleCountdown;
      }
      
      public function WobbleB() : void
      {
         TweenLite.to(mcArrow.mcArrow,0.6,{
            "y":-60,
            "ease":Bounce.easeOut
         });
      }
      
      public function SetPos(param1:int, param2:int) : void
      {
         this.posX = param1;
         this.posY = param2;
      }
   }
}

package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Checkbox extends CheckBox_CLIP
   {
      
      private static const FRAME_SELECT:int = 2;
      
      private static const FRAME_DESELECT:int = 1;
      
      public static const CHECK_EVENT:String = "cb_checked";
       
      
      private var checked:Boolean = false;
      
      private var _enabled:Boolean = true;
      
      private var _over:Boolean = false;
      
      private var _down:Boolean = false;
      
      public function Checkbox()
      {
         super();
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         stop();
      }
      
      public static function Replace(param1:MovieClip) : Checkbox
      {
         var _loc2_:Checkbox = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         _loc2_ = new Checkbox();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.scaleX = param1.scaleX;
         _loc2_.scaleY = param1.scaleY;
         _loc2_.gotoAndStop(param1.currentFrame);
         _loc2_.name = param1.name;
         if(param1.parent)
         {
            _loc3_ = param1.parent.getChildIndex(param1);
            (_loc4_ = param1.parent).removeChild(param1);
            _loc4_.addChildAt(_loc2_,_loc3_ - 1);
         }
         return _loc2_;
      }
      
      public function onDown(param1:MouseEvent) : void
      {
         this._down = true;
         this.Update();
      }
      
      public function onUp(param1:MouseEvent) : void
      {
         this._down = false;
         if(this._enabled)
         {
            this.Checked = !this.checked;
            dispatchEvent(new Event(CHECK_EVENT));
         }
         this.Update();
      }
      
      public function onClick(param1:MouseEvent) : void
      {
         if(this._enabled)
         {
            this.Checked = !this.checked;
            dispatchEvent(new Event(CHECK_EVENT));
         }
      }
      
      public function onOver(param1:MouseEvent) : void
      {
         this._over = true;
         this.Update();
      }
      
      public function onOut(param1:MouseEvent) : void
      {
         this._over = false;
         this.Update();
      }
      
      public function Update() : void
      {
         if(this._enabled)
         {
            if(this._over)
            {
               gotoAndStop(this.checked ? 4 : 3);
            }
            else
            {
               gotoAndStop(this.checked ? 2 : 1);
            }
            if(this._down)
            {
               gotoAndStop(this.checked ? 8 : 7);
            }
         }
         else
         {
            gotoAndStop(this.checked ? 6 : 5);
         }
      }
      
      public function set Checked(param1:Boolean) : void
      {
         this.checked = param1;
         this.Update();
      }
      
      public function get Checked() : Boolean
      {
         return this.checked;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         this.Update();
      }
      
      public function get Enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function select() : void
      {
         this.checked = true;
      }
      
      public function deselect() : void
      {
         this.checked = false;
      }
      
      public function get selected() : Boolean
      {
         return this.checked;
      }
      
      public function toggle() : void
      {
         if(this.selected)
         {
            this.deselect();
         }
         else
         {
            this.select();
         }
         dispatchEvent(new Event(CHECK_EVENT));
      }
      
      public function fromInt(param1:int) : void
      {
         if(param1)
         {
            this.select();
         }
         else
         {
            this.deselect();
         }
      }
      
      public function toInt() : int
      {
         return this.selected ? 1 : 0;
      }
      
      public function Remove() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         this.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
   }
}

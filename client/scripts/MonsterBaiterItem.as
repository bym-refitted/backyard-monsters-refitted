package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MonsterBaiterItem extends MonsterBaiterItem_CLIP
   {
       
      
      public var _count:int = 0;
      
      public var _cost:int = 0;
      
      public var _configObj:Object;
      
      public var _level:int = 0;
      
      public var _key:String;
      
      private var tick:int = 0;
      
      private var _enabled:Boolean = false;
      
      private var _initialCount:int = 0;
      
      public function MonsterBaiterItem()
      {
         super();
         tInfo.textColor = 16711680;
      }
      
      public function Setup(param1:String) : void
      {
         this._configObj = CREATURELOCKER._creatures[param1];
         this._key = param1;
         ImageCache.GetImageWithCallBack("monsters/" + param1 + "-medium.jpg",this.IconLoaded,true,1,"",[mcIcon]);
         tInfo.text = "";
         tName.htmlText = "<b>" + KEYS.Get(this._configObj.name) + "</b>";
         this._cost = CREATURES.GetProperty(param1,"cStorage");
         decr_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.decrDown);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         incr_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.incrDownB);
      }
      
      public function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
         param3[0].mcImage.visible = true;
      }
      
      private function onAdd(param1:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         MONSTERBAITER._mc.Update();
      }
      
      private function onStageUp(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.lessTick);
         removeEventListener(Event.ENTER_FRAME,this.moreTick);
         MONSTERBAITER._mc.Update();
      }
      
      public function Update() : void
      {
         if(this._count > 0)
         {
            tInfo.htmlText = KEYS.Get("bait_sending",{"v1":this._count});
         }
         else
         {
            tInfo.htmlText = "";
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getCost() : int
      {
         return this._cost * this._count;
      }
      
      private function incrDown(param1:MouseEvent) : void
      {
         this._initialCount = this._count;
         ++this._count;
         this.tick = 0;
         this.addEventListener(Event.ENTER_FRAME,this.moreTick);
         this.addEventListener(MouseEvent.MOUSE_UP,this.Stop);
         MONSTERBAITER._mc.Update();
         SOUNDS.Play("click1");
      }
      
      private function incrDownB(param1:MouseEvent) : void
      {
         this.dispatchEvent(new Event("increment"));
         MONSTERBAITER._mc.Update();
      }
      
      private function moreTick(param1:Event) : void
      {
         if(this.tick > 10 && this.tick % 2 == 0 || this._count - this._initialCount > 60)
         {
            this.moreTickB();
         }
         ++this.tick;
         this.MovedOut();
      }
      
      private function moreTickB() : void
      {
         ++this._count;
         MONSTERBAITER._mc.Update();
      }
      
      private function decrDown(param1:MouseEvent) : void
      {
         if(this._count > 0)
         {
            this._initialCount = this._count;
            --this._count;
            this.tick = 0;
            this.addEventListener(Event.ENTER_FRAME,this.lessTick);
            this.addEventListener(MouseEvent.MOUSE_UP,this.Stop);
            SOUNDS.Play("click1");
            MONSTERBAITER._mc.Update();
         }
      }
      
      private function lessTick(param1:Event) : void
      {
         if(this.tick > 10 && this.tick % 2 == 0 || this._initialCount - this._count > 60)
         {
            this.lessTickB();
         }
         ++this.tick;
         this.MovedOut();
      }
      
      private function lessTickB() : void
      {
         if(this._count > 0)
         {
            --this._count;
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.lessTick);
         }
         MONSTERBAITER._mc.Update();
      }
      
      public function Enable(param1:Boolean) : void
      {
         var _loc2_:Number = 0.3;
         if(param1)
         {
            if(!this._enabled)
            {
               this._enabled = true;
               incr_btn.addEventListener(MouseEvent.MOUSE_DOWN,this.incrDown);
               incr_btn.alpha = decr_btn.alpha = 1;
            }
         }
         else
         {
            this._enabled = false;
            incr_btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.incrDown);
            incr_btn.alpha = _loc2_;
            removeEventListener(Event.ENTER_FRAME,this.lessTick);
            removeEventListener(Event.ENTER_FRAME,this.moreTick);
         }
         decr_btn.alpha = this._count > 0 ? 1 : _loc2_;
      }
      
      private function MovedOut() : void
      {
         if(mouseX < incr_btn.x || mouseX > incr_btn.x + incr_btn.width || mouseY < incr_btn.y || mouseY > decr_btn.y + decr_btn.height)
         {
            removeEventListener(Event.ENTER_FRAME,this.lessTick);
            removeEventListener(Event.ENTER_FRAME,this.moreTick);
         }
      }
      
      private function Stop(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.lessTick);
         removeEventListener(Event.ENTER_FRAME,this.moreTick);
      }
   }
}

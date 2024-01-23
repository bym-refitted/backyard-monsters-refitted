package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CREATUREBUTTON extends CREATUREBUTTON_CLIP
   {
       
      
      public var _creatureID:String;
      
      public var _creatureData:Object;
      
      public var _tick:int;
      
      public var _description:bubblepopup3;
      
      protected var m_index:int;
      
      public function CREATUREBUTTON(param1:String, param2:int, param3:DisplayObjectContainer)
      {
         var _loc4_:String = null;
         super();
         this._creatureID = param1;
         this._creatureData = CREATURELOCKER._creatures[this._creatureID];
         ImageCache.GetImageWithCallBack("monsters/" + this._creatureID + "-small.png",this.IconLoaded,true,1);
         _loc4_ = KEYS.Get(CREATURELOCKER._creatures[this._creatureID].name);
         var _loc5_:uint = Math.max(0.8,Math.min(1,1 / (_loc4_.length / 10))) * 12;
         if(Boolean(GLOBAL.attackingPlayer.m_upgrades[param1]) && Boolean(GLOBAL.attackingPlayer.m_upgrades[param1].level))
         {
            txtName.htmlText = "<b><font size=\"" + _loc5_ + "\">" + _loc4_ + " Level " + GLOBAL.attackingPlayer.m_upgrades[param1].level + "</font></b>";
         }
         else
         {
            txtName.htmlText = "<b><font size=\"" + _loc5_ + "\">" + _loc4_ + " Level 1</font></b>";
         }
         this._description = new bubblepopup3();
         this._description.Setup(190,26,KEYS.Get(CREATURELOCKER._creatures[this._creatureID].description),5);
         param3.addChild(this._description);
         this._description.visible = false;
         this.m_index = param2;
         _bg.gotoAndStop("bg" + String(this.m_index % 2 + 1));
         addEventListener(MouseEvent.ROLL_OVER,this.Over);
         addEventListener(MouseEvent.ROLL_OUT,this.Out);
         if(!GLOBAL.isInAttackMode)
         {
            bMore.visible = false;
            bMore.Enabled = false;
            bLess.visible = false;
            bLess.Enabled = false;
            txtNumber.x = 40;
         }
         else
         {
            bMore.Setup("+");
            bMore.addEventListener(MouseEvent.MOUSE_DOWN,this.More);
            bMore.addEventListener(MouseEvent.MOUSE_UP,this.Clear);
            bMore.addEventListener(MouseEvent.ROLL_OVER,this.Over);
            bLess.Setup("-");
            bLess.addEventListener(MouseEvent.MOUSE_DOWN,this.Less);
            bLess.addEventListener(MouseEvent.MOUSE_UP,this.Clear);
            bLess.addEventListener(MouseEvent.ROLL_OVER,this.Over);
            txtNumber.x = 110;
         }
         this._tick = 0;
         this.Update();
      }
      
      public function IconLoaded(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = new Bitmap(param2);
         _creatureImage.addChild(_loc3_);
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         _loc1_ = int(ATTACK._curCreaturesAvailable[this._creatureID]);
         var _loc2_:* = "<b>";
         if(ATTACK._flingerBucket[this._creatureID])
         {
            _loc2_ = "<font color=\"#FF0000\">" + ATTACK._flingerBucket[this._creatureID].Get() + "</font> / ";
         }
         _loc2_ += _loc1_ + "</b>";
         txtNumber.htmlText = _loc2_;
         if(_loc1_ > 0)
         {
            bMore.enabled = true;
            _bg.gotoAndStop("bg" + String(this.m_index % 2 + 1));
         }
         if(_loc1_ <= 0)
         {
            bMore.enabled = false;
            _bg.gotoAndStop("full" + String(this.m_index % 2 + 1));
         }
      }
      
      public function Over(param1:MouseEvent) : void
      {
         this._description.visible = true;
      }
      
      public function Out(param1:MouseEvent) : void
      {
         this._description.visible = false;
      }
      
      public function Clear(param1:MouseEvent = null) : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.MoreTick);
         }
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.LessTick);
         }
      }
      
      public function More(param1:MouseEvent) : void
      {
         UI2._top.BombDeselect();
         this.MoreTickB();
         this._tick = 0;
         addEventListener(Event.ENTER_FRAME,this.MoreTick);
      }
      
      public function MoreTick(param1:Event = null) : void
      {
         if(this._tick > 10 && this._tick % 2 == 0)
         {
            this.MoreTickB();
         }
         this.MoreMovedOut();
         ++this._tick;
      }
      
      public function MoreTickB() : void
      {
         ATTACK.BucketAdd(this._creatureID);
         this.Update();
         ATTACK.BucketUpdate();
      }
      
      public function Less(param1:MouseEvent) : void
      {
         UI2._top.BombDeselect();
         this.LessTickB();
         this._tick = 0;
         addEventListener(Event.ENTER_FRAME,this.LessTick);
      }
      
      public function LessTick(param1:Event = null) : void
      {
         if(this._tick > 10 && this._tick % 2 == 0)
         {
            this.LessTickB();
         }
         this.LessMovedOut();
         ++this._tick;
      }
      
      public function LessTickB() : void
      {
         ATTACK.BucketRemove(this._creatureID);
         this.Update();
         ATTACK.BucketUpdate();
      }
      
      public function MoreMovedOut() : void
      {
         if(mouseX < bMore.x || mouseX > bMore.x + bMore.width || mouseY < bMore.y || mouseY > bMore.y + bMore.height)
         {
            this.Clear();
         }
      }
      
      public function LessMovedOut() : void
      {
         if(mouseX < bLess.x || mouseX > bLess.x + bLess.width || mouseY < bLess.y || mouseY > bLess.y + bLess.height)
         {
            this.Clear();
         }
      }
   }
}

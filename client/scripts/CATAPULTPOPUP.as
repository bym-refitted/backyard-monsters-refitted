package
{
   import com.monsters.display.ImageCache;
   import com.monsters.effects.ResourceBombs;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CATAPULTPOPUP extends CATAPULTPOPUP_view
   {
       
      
      private var _t:Timer;
      
      private var _open:Boolean;
      
      private var _items:Array;
      
      private var _currentImage:String;
      
      private var _bm:Bitmap;
      
      private var _canClose:Boolean;
      
      private var m_waitTime:int;
      
      public function CATAPULTPOPUP()
      {
         super();
      }
      
      public static function Format(param1:Number, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 > 1000000)
         {
            _loc3_ = "" + param1 / 1000000;
            _loc4_ = param2 ? " " + KEYS.Get("bomb_million_long") : KEYS.Get("bomb_million_short");
            _loc3_ += _loc4_;
         }
         else
         {
            _loc3_ = GLOBAL.FormatNumber(param1);
         }
         return _loc3_;
      }
      
      public function get waitTime() : int
      {
         return this.m_waitTime;
      }
      
      public function Setup(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:CATAPULTITEM = null;
         _imageContainer.txtName.selectable = false;
         if(param1)
         {
            _mc.visible = false;
            this.Update();
            return;
         }
         _mc.visible = true;
         _imageContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.Show);
         _imageContainer._image.buttonMode = true;
         this._items = [];
         for(_loc4_ in ResourceBombs._bombs)
         {
            _loc3_ = int(ResourceBombs._bombs[_loc4_].col);
            _loc2_ = int(ResourceBombs._bombs[_loc4_].group);
            (_loc5_ = new CATAPULTITEM()).x = _mc[_loc4_].x;
            _loc5_.y = _mc[_loc4_].y;
            _mc.removeChild(_mc[_loc4_]);
            _loc5_.Setup(_loc4_);
            _loc5_.addEventListener(MouseEvent.MOUSE_OVER,this.overBomb(_loc5_));
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.hideBomb(_loc5_));
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,this.downBomb(_loc5_));
            _mc.addChild(_loc5_);
            this._items.push(_loc5_);
         }
         this._t = new Timer(100);
         this._t.addEventListener(TimerEvent.TIMER,this.testMouseOff);
         ResourceBombs._mc = this;
         this.Update();
         this.Hide();
      }
      
      private function downBomb(param1:CATAPULTITEM) : Function
      {
         var b:CATAPULTITEM = param1;
         return function(param1:MouseEvent):void
         {
            if(b.Enabled)
            {
               Hide();
               ResourceBombs._bombid = b._bombid;
               _imageContainer.txtName.htmlText = "<font color=\"#FF0000\">Cancel</font>";
               Update();
               Fire(param1);
            }
         };
      }
      
      private function hideBomb(param1:CATAPULTITEM) : Function
      {
         var b:CATAPULTITEM = param1;
         return function(param1:MouseEvent):void
         {
            b.Hide();
         };
      }
      
      private function overBomb(param1:CATAPULTITEM) : Function
      {
         var b:CATAPULTITEM = param1;
         return function(param1:MouseEvent):void
         {
            b.ShowOver();
            b.parent.setChildIndex(b,b.parent.numChildren - 1);
         };
      }
      
      private function testMouseOff(param1:TimerEvent) : void
      {
         if(this._open)
         {
            if(this._canClose && (_mc.mouseX < _mc._bg.x || _mc.mouseX > _mc._bg.width + _mc._bg.x || _mc.mouseY < _mc._bg.y || _mc.mouseY > _mc._bg.height + _mc._bg.y))
            {
               this.Hide();
            }
            else if(_mc.mouseX > _mc._bg.x && _mc.mouseX < _mc._bg.width + _mc._bg.x && _mc.mouseY > _mc._bg.y && _mc.mouseY < _mc._bg.height + _mc._bg.y)
            {
               this._canClose = true;
            }
         }
      }
      
      public function Update() : void
      {
         var _loc4_:CATAPULTITEM = null;
         var _loc1_:Object = {
            "tw":KEYS.Get("bomb_tw_name"),
            "pb":KEYS.Get("bomb_pb_name"),
            "pu":KEYS.Get("bomb_pu_name")
         };
         var _loc2_:Object = ResourceBombs._bombs[ResourceBombs._bombid];
         _mc.tTitleTwig.htmlText = KEYS.Get("bomb_tw_name_pl");
         _mc.tTitlePebble.htmlText = KEYS.Get("bomb_pb_name_pl");
         _mc.tTitlePutty.htmlText = KEYS.Get("bomb_pu_name");
         var _loc3_:String = String(_loc1_[ResourceBombs._bombid.substr(0,2)]);
         if(_loc2_.image != this._currentImage)
         {
            ImageCache.GetImageWithCallBack(_loc2_.image,this.onImageLoaded);
         }
         for each(_loc4_ in this._items)
         {
            _loc4_.Update();
         }
         if(ResourceBombs._state == 0)
         {
            _imageContainer.txtName.htmlText = "<font color=\"#FFFFFF\">Catapult</font>";
         }
         else if(ResourceBombs._state == 1)
         {
            _imageContainer.txtName.htmlText = "<font color=\"#FF0000\">Cancel</font>";
         }
      }
      
      private function onImageLoaded(param1:String, param2:BitmapData) : void
      {
         if(this._bm)
         {
            if(this._bm.parent)
            {
               this._bm.parent.removeChild(this._bm);
            }
            this._bm = null;
         }
         this._bm = new Bitmap(param2);
         this._bm.width = this._bm.height = 60;
         _imageContainer._image.addChild(this._bm);
         this._currentImage = param1;
      }
      
      public function fired() : void
      {
         _imageContainer.txtName.htmlText = "<font color=\"#FFFFFF\">Catapult</font>";
      }
      
      public function Show(param1:MouseEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         for(_loc2_ in ATTACK._flingerBucket)
         {
            if(ATTACK._flingerBucket[_loc2_].Get() > 0)
            {
               if(_loc2_.substr(0,1) != "G")
               {
                  ATTACK._curCreaturesAvailable[_loc2_] += ATTACK._flingerBucket[_loc2_].Get();
                  ATTACK._flingerBucket[_loc2_].Set(0);
               }
            }
         }
         for each(_loc3_ in UI2._top._creatureButtons)
         {
            if(_loc3_ is CHAMPIONBUTTON)
            {
               if(_loc3_._sent)
               {
                  (_loc3_ as CHAMPIONBUTTON).deSelectSend();
               }
            }
            _loc3_.Update();
         }
         ATTACK.RemoveDropZone();
         if(UI2._top._siegeweapon)
         {
            UI2._top._siegeweapon.Cancel();
         }
         if(ResourceBombs._state != 0)
         {
            ResourceBombs.BombRemove();
            _imageContainer.txtName.htmlText = "<font color=\"#FFFFFF\">Catapult</font>";
            return;
         }
         addChild(_mc);
         this._t.start();
         this._open = true;
         this._canClose = false;
         param1.stopImmediatePropagation();
      }
      
      public function Fire(param1:MouseEvent = null) : void
      {
         this.m_waitTime = GLOBAL.Timestamp() + 1;
         if(UI2._top._siegeweapon)
         {
            UI2._top._siegeweapon.Cancel();
         }
         if(ResourceBombs._state == 0)
         {
            if(ResourceBombs._bombid && !ResourceBombs._bombs[ResourceBombs._bombid].used && GLOBAL._attackersResources["r" + ResourceBombs._bombs[ResourceBombs._bombid].resource].Get() >= ResourceBombs._bombs[ResourceBombs._bombid].cost.Get())
            {
               ResourceBombs.BombAdd(ResourceBombs._bombs[ResourceBombs._bombid]);
            }
         }
         else
         {
            ResourceBombs.BombRemove();
         }
      }
      
      public function Hide() : void
      {
         if(_mc.parent)
         {
            _mc.parent.removeChild(_mc);
         }
         this._t.stop();
         this._open = false;
         this.Update();
      }
      
      public function CanUse() : Boolean
      {
         return true;
      }
      
      public function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
      
      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}

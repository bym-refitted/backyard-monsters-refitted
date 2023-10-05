package
{
   import com.monsters.display.ImageCache;
   import com.monsters.effects.ResourceBombs;
   import com.monsters.siege.SiegeWeaponProperty;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.Decoy;
   import com.monsters.siege.weapons.IDurable;
   import com.monsters.siege.weapons.Jars;
   import com.monsters.siege.weapons.SiegeWeapon;
   import com.monsters.siege.weapons.Vacuum;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import gs.TweenLite;
   import gs.easing.*;
   
   public class SIEGEWEAPONPOPUP extends SIEGEWEAPONPOPUP_view
   {
       
      
      private const DOES_USE_NEW_DISPLAY:Boolean = true;
      
      private var _t:Timer;
      
      private var _open:Boolean;
      
      private var _items:Array;
      
      private var _currentImage:String;
      
      private var _bm:Bitmap;
      
      private var _canClose:Boolean;
      
      public var _currentSiegeWeapon:SiegeWeapon;
      
      public var _state:int = 0;
      
      public var _tooltip:MovieClip;
      
      private var _healthBarSource:BitmapData;
      
      private var _healthBar:BitmapData;
      
      private var _healthBarBitmap:Bitmap;
      
      private var _bmGreyScaled:Bitmap;
      
      private var _mask:Shape;
      
      private var _isWeaponFinished:Boolean;
      
      private var _imageContainer:Sprite;
      
      public function SIEGEWEAPONPOPUP()
      {
         this._healthBarSource = new bmp_healthbarlarge();
         this._healthBar = new BitmapData(50,6,true,0);
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
      
      public function Setup(param1:Boolean) : void
      {
         _iconbg.mouseChildren = false;
         _image.mouseEnabled = false;
         _image.mouseChildren = false;
         this._items = [];
         _bar.alpha = 0;
         _bar.timebar.visible = false;
         _bar._tB.visible = false;
         _bar._tB.htmlText = "";
         timeLeftMC.mouseEnabled = false;
         timeLeftMC.mouseChildren = false;
         timeLeftMC.alpha = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._currentSiegeWeapon = SiegeWeapons.availableWeapon;
         if(this._currentSiegeWeapon == null)
         {
            UI2._top.ClearSiegeWeapon();
            return;
         }
         if(param1)
         {
            ImageCache.GetImageWithCallBack(SiegeWeapons.availableWeapon.image,this.onImageLoaded);
            return;
         }
         _iconbg.buttonMode = true;
         _iconbg.addEventListener(MouseEvent.MOUSE_DOWN,this.Target);
         _iconbg.addEventListener(MouseEvent.MOUSE_OVER,this.ToolTipShow);
         _iconbg.addEventListener(MouseEvent.MOUSE_OUT,this.ToolTipHide);
         this._t = new Timer(100,int.MAX_VALUE);
         this._t.addEventListener(TimerEvent.TIMER,this.UpdateTimer);
         this._t.start();
         this.Update();
      }
      
      public function Cancel() : void
      {
         if(this._currentSiegeWeapon.quantity > 0 && this._state == 1)
         {
            this._state = 0;
            txtName.htmlText = "<b>\n" + KEYS.Get("siege_firebtn") + "</b>";
            TweenLite.to(_bar,0.3,{
               "autoAlpha":0,
               "y":23
            });
            ATTACK.RemoveDropZone();
         }
         if(this._state <= 1)
         {
            this._t.stop();
         }
      }
      
      public function UpdateTimer(param1:TimerEvent) : void
      {
         this.Update();
      }
      
      public function Update() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(this._currentSiegeWeapon.image != this._currentImage)
         {
            ImageCache.GetImageWithCallBack(this._currentSiegeWeapon.image,this.onImageLoaded);
         }
         if(this._state == 0)
         {
            txtName.htmlText = "<b>" + KEYS.Get("siege_firebtn") + "</b>";
            if(this._currentSiegeWeapon.canFire())
            {
               if(this._currentSiegeWeapon.quantity <= 0)
               {
                  _image.alpha = 0.5;
               }
               else
               {
                  _image.alpha = 1;
               }
               TweenLite.to(_bar,0.3,{
                  "autoAlpha":0,
                  "y":23
               });
            }
         }
         else if(this._state == 1)
         {
            txtName.htmlText = "<b><font color=\"#FF0000\">\n" + KEYS.Get("siege_cancelbtn") + "</font></b>";
            if(_bar.parent)
            {
               _bar.parent.setChildIndex(_bar,_bar.parent.numChildren - 1);
            }
            TweenLite.to(_bar,0.3,{
               "autoAlpha":1,
               "y":65,
               "ease":Bounce.easeOut
            });
            if(this._currentSiegeWeapon.weaponID == Decoy.ID)
            {
               _bar._tA.htmlText = KEYS.Get("siege_target_ground");
            }
            else if(this._currentSiegeWeapon.weaponID == Jars.ID)
            {
               _bar._tA.htmlText = KEYS.Get("siege_target_towers");
            }
            else
            {
               _bar._tA.htmlText = KEYS.Get("siege_target_targets");
            }
            _bar._tA.y = 12;
            _bar._tB.y = _bar.timebar.y;
            _bar._tB.visible = false;
            _bar.timebar.visible = false;
         }
         else if(this._state == 2)
         {
            if(this.DOES_USE_NEW_DISPLAY)
            {
               if(SiegeWeapons.activeWeapon)
               {
                  if(this._currentSiegeWeapon.duration)
                  {
                     this.updateTimeRemaining();
                  }
                  if(this._currentSiegeWeapon is IDurable)
                  {
                     this.updateHealth();
                  }
               }
               else if(!this._isWeaponFinished)
               {
                  this.SiegeWeaponFinished();
               }
               txtName.visible = false;
            }
            else
            {
               _loc2_ = SiegeWeapons.getTimeRemaingOnActiveWeapon();
               _loc3_ = _loc2_ * 10 / 10;
               if(_loc2_ > 0)
               {
                  TweenLite.to(_bar,0.3,{
                     "autoAlpha":1,
                     "y":65,
                     "ease":Sine.easeOut
                  });
                  _bar._tA.htmlText = this._currentSiegeWeapon.name;
                  _bar._tA.y = 4;
                  if(_loc4_ = this._currentSiegeWeapon.duration)
                  {
                     _bar.timebar.visible = true;
                     _bar.timebar.alpha = 1;
                     _bar.timebar.mcBar.width = 100 / _loc4_ * _loc2_;
                     _bar._tB.visible = true;
                     _bar._tB.htmlText = _loc3_;
                  }
                  else
                  {
                     _bar.timebar.visible = false;
                     _bar.timebar.alpha = 0;
                  }
               }
               else
               {
                  TweenLite.to(_bar,0.3,{
                     "autoAlpha":0,
                     "y":23,
                     "ease":Circ.easeOut
                  });
                  TweenLite.to(_bar.timebar,0.3,{"autoAlpha":0});
                  _bar._tB.visible = false;
               }
            }
            TweenLite.to(_bar,0.3,{
               "autoAlpha":0,
               "y":23,
               "ease":Circ.easeOut
            });
         }
         var _loc1_:* = !this._currentSiegeWeapon.canFire();
         if(_loc1_)
         {
            TweenLite.to(_bar,0.3,{
               "autoAlpha":0,
               "y":23,
               "ease":Circ.easeOut
            });
            _image.removeEventListener(MouseEvent.MOUSE_DOWN,this.Target);
            TweenLite.to(_image,0.6,{"autoAlpha":0.5});
         }
      }
      
      private function SiegeWeaponFinished() : void
      {
         if(this._currentSiegeWeapon.duration)
         {
            timeLeftMC.visible = false;
            TweenLite.killTweensOf(this._mask);
         }
         if(this._currentSiegeWeapon is IDurable)
         {
            _image.removeChild(this._healthBarBitmap);
         }
         this._mask.scaleY = 0;
         this._isWeaponFinished = true;
      }
      
      private function updateHealth() : void
      {
         var _loc1_:Number = IDurable(this._currentSiegeWeapon).activeDurability;
         if(_loc1_ <= 0)
         {
            this._healthBarBitmap.alpha = 0;
            return;
         }
         this._healthBarBitmap.alpha = 1;
         var _loc2_:Number = this._currentSiegeWeapon.getProperty(SiegeWeapon.DURABILITY).getValueForLevel(this._currentSiegeWeapon.level);
         var _loc3_:int = 50;
         var _loc4_:int = 120;
         var _loc5_:int = 6;
         var _loc6_:int = (1 - _loc1_ / _loc2_) * _loc4_;
         _loc6_ = Math.round(_loc6_ / _loc5_) * _loc5_;
         this._healthBar.copyPixels(this._healthBarSource,new Rectangle(0,_loc6_,_loc3_,_loc5_),new Point(0,0));
      }
      
      private function updateTimeRemaining() : void
      {
         var _loc1_:Number = SiegeWeapons.getTimeRemaingOnActiveWeapon();
         var _loc2_:uint = _loc1_ < 10 ? 16711680 : 255;
         timeLeftMC.alpha = 1;
         timeLeftMC.timeLeftText.text = _loc1_ + "s";
         timeLeftMC.filters = [new GlowFilter(_loc2_)];
      }
      
      private function bluificyImage(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([2,0,0,0,0]);
         _loc2_ = _loc2_.concat([0,2,0,0,0]);
         _loc2_ = _loc2_.concat([0,0,3,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         param1.filters = [new ColorMatrixFilter(_loc2_)];
      }
      
      private function desaturateImage(param1:DisplayObject) : void
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.33,0.33,0.33,0.33,0]);
         _loc2_ = _loc2_.concat([0.33,0.33,0.33,0.33,0]);
         _loc2_ = _loc2_.concat([0.33,0.33,0.33,0.33,0]);
         _loc2_ = _loc2_.concat([0.33,0.33,0.33,1,0]);
         param1.filters = [new ColorMatrixFilter(_loc2_)];
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
         this._imageContainer = new Sprite();
         this._bm = new Bitmap(param2);
         if(this.DOES_USE_NEW_DISPLAY)
         {
            this._bmGreyScaled = new Bitmap(param2);
            this.desaturateImage(this._bmGreyScaled);
            _image.addChild(this._bmGreyScaled);
            this._mask = new Shape();
            this._mask.graphics.beginFill(255);
            this._mask.graphics.drawRect(0,-this._bm.height,this._bm.height,this._bm.width);
            this._mask.y = this._bm.height;
            _image.addChild(this._mask);
            this._imageContainer.mask = this._mask;
            if(this._currentSiegeWeapon is IDurable)
            {
               this._healthBarBitmap = new Bitmap(this._healthBar);
               this._healthBarBitmap.width = _image.width;
               this._healthBarBitmap.y = _image.height - 6;
               this._healthBarBitmap;
            }
         }
         this._imageContainer.addChild(this._bm);
         _image.addChild(this._imageContainer);
         if(this._healthBarBitmap)
         {
            _image.addChild(this._healthBarBitmap);
         }
         this._currentImage = param1;
      }
      
      public function Show(param1:MouseEvent = null) : void
      {
         this.ZeroOutAttacks();
      }
      
      public function Target(param1:MouseEvent = null) : void
      {
         var _loc2_:Boolean = false;
         if(this._state == 1)
         {
            this.Cancel();
         }
         else if(this._state == 0)
         {
            this.ZeroOutAttacks();
            if(this._currentSiegeWeapon.range > 0)
            {
               ATTACK.DropZone(this._currentSiegeWeapon.range,this._currentSiegeWeapon.dropTarget);
               _loc2_ = true;
               this._state = 1;
            }
            else
            {
               _loc2_ = SiegeWeapons.activateWeapon(this._currentSiegeWeapon.weaponID);
               if(_loc2_)
               {
                  this.HasFired();
               }
            }
            if(_loc2_)
            {
               this._t.start();
            }
         }
      }
      
      public function ToolTipShow(param1:MouseEvent = null) : void
      {
         var _loc6_:SiegeWeaponProperty = null;
         this._tooltip = new bubblepopupUpSiegeWeapon_CLIP();
         this._tooltip.x = -40;
         this._tooltip.y = 70;
         var _loc2_:* = "<b>" + this._currentSiegeWeapon.name + "</b>" + "<br>" + "<b>" + KEYS.Get("siege_tooltip_level",{"v1":this._currentSiegeWeapon.level}) + "</b>";
         var _loc3_:Vector.<SiegeWeaponProperty> = this._currentSiegeWeapon.getProperties();
         var _loc4_:* = "";
         if(BASE.isOutpost && !this._currentSiegeWeapon.canUseInOutposts)
         {
            _loc4_ += "<b>" + KEYS.Get("vacuum_nooutposts",{"v1":this._currentSiegeWeapon.name}) + "</b><br>";
         }
         else
         {
            _loc4_ += this._currentSiegeWeapon.tooltip;
         }
         _loc4_ += "<ul>";
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc4_ += "<li>" + _loc6_.label + _loc6_.getDescription(this._currentSiegeWeapon.level) + "</li>";
            _loc5_++;
         }
         _loc4_ += "</ul>";
         this._tooltip.tTitle.htmlText = _loc2_;
         this._tooltip.tBody.htmlText = _loc4_;
         addChild(this._tooltip);
      }
      
      public function ToolTipHide(param1:MouseEvent = null) : void
      {
         if(Boolean(this._tooltip) && Boolean(this._tooltip.parent))
         {
            this._tooltip.parent.removeChild(this._tooltip);
            this._tooltip = null;
         }
      }
      
      public function Fire(param1:int, param2:int) : void
      {
         var _loc3_:Boolean = false;
         if(this._state == 1)
         {
            _loc3_ = SiegeWeapons.activateWeapon(this._currentSiegeWeapon.weaponID,param1,param2);
            if(!_loc3_)
            {
               return;
            }
            ATTACK.RemoveDropZone();
            this.HasFired();
         }
      }
      
      public function HasFired() : void
      {
         var _loc1_:Shape = null;
         if(this._state < 2)
         {
            this._state = 2;
            _image.mouseEnabled = false;
            if(!this.DOES_USE_NEW_DISPLAY)
            {
               TweenLite.to(_image,0.6,{"autoAlpha":0.5});
            }
            else if(this._currentSiegeWeapon.duration)
            {
               _loc1_ = new Shape();
               _loc1_.graphics.beginFill(52479);
               _loc1_.graphics.drawRect(0,0,this._bm.height,this._bm.width);
               _loc1_.blendMode = BlendMode.OVERLAY;
               this.desaturateImage(this._bm);
               this._imageContainer.addChild(_loc1_);
               TweenLite.to(this._mask,this._currentSiegeWeapon.duration,{
                  "scaleY":0,
                  "ease":Linear.easeNone
               });
            }
            this.Update();
         }
      }
      
      public function ZeroOutAttacks() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         for(_loc1_ in ATTACK._flingerBucket)
         {
            if(ATTACK._flingerBucket[_loc1_].Get() > 0)
            {
               ATTACK._curCreaturesAvailable[_loc1_].Add(ATTACK._flingerBucket[_loc1_].Get());
               ATTACK._flingerBucket[_loc1_].Set(0);
            }
         }
         for each(_loc2_ in UI2._top._creatureButtons)
         {
            _loc2_.Update();
         }
         ATTACK.RemoveDropZone();
         ResourceBombs.BombRemove();
      }
      
      public function Hide() : void
      {
         this._t.stop();
         this._t.removeEventListener(TimerEvent.TIMER,this.UpdateTimer);
         this._open = false;
         this.Update();
      }
      
      public function validate() : Boolean
      {
         var _loc1_:Boolean = true;
         switch(this._currentSiegeWeapon.weaponID)
         {
            case Vacuum.ID:
               _loc1_ = Boolean(GLOBAL.townHall) && GLOBAL.townHall._destroyed === false;
               enabled = _loc1_;
         }
         return _loc1_;
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

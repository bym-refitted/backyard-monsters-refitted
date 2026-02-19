package com.monsters.effects.fire
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.ConvolutionFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Flame extends Sprite
   {
       
      
      private var _emitter:DisplayObject;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _mc:DisplayObject;
      
      private var _clearBmd:BitmapData;
      
      private var _greyBmd:BitmapData;
      
      private var _greyFilter:ColorMatrixFilter;
      
      private var _spreadFilter:ConvolutionFilter;
      
      private var _spread:int;
      
      public var phase:int = 0;
      
      private var _cooling:Number;
      
      private var _coolingBmd1:BitmapData;
      
      private var _coolingBmd2:BitmapData;
      
      private var _coolingOffset:Array;
      
      private var _coolingFilter:ColorMatrixFilter;
      
      private var _coolingOffset1:Point;
      
      private var _coolingOffset2:Point;
      
      private var _coolingTmpBmd1:BitmapData;
      
      private var _coolingTmpBmd2:BitmapData;
      
      private var _enhance:Number;
      
      private var _enhanceTransform:ColorTransform;
      
      private var _palette:Array;
      
      private var _paletteAlpha:Array;
      
      private var _fire:BitmapData;
      
      private var _zeros:Array;
      
      private var _point:Point;
      
      private var _rect:Rectangle;
      
      private var _particleCount:int;
      
      private var _particleFirst:Particle;
      
      private var _sparkLife:int;
      
      private var _sparkThreshold:int;
      
      public function Flame(param1:DisplayObject, param2:int, param3:int)
      {
         var _loc9_:Particle = null;
         var _loc10_:Particle = null;
         super();
         this._emitter = param1;
         this._width = param2;
         this._height = param3;
         this._point = new Point(0,0);
         this._rect = new Rectangle(0,0,this._width,this._height);
         this._clearBmd = new BitmapData(this._width,this._height,false,0);
         this._greyBmd = new BitmapData(this._width,this._height,false,0);
         this._greyFilter = new ColorMatrixFilter([0.198912,0.586611,0.114478,0,0,0.298912,0.586611,0.114478,0,0,0.298912,0.586611,0.114478,0,0,0,0,0,1,0]);
         this._spread = 3;
         this._spreadFilter = new ConvolutionFilter(this._spread,this._spread,[0,1,0,1,1,1,0,1,0],5);
         this._coolingBmd1 = new BitmapData(this._width,this._height,false,0);
         this._coolingBmd2 = new BitmapData(this._width,this._height,false,0);
         this._coolingOffset = [new Point(0,0),new Point(0,0)];
         this.cooling = 0.1;
         var _loc4_:Number = 0.1;
         var _loc5_:Number = 1;
         var _loc6_:Number = 2;
         var _loc7_:Number = 1;
         this._coolingBmd1.perlinNoise(this._width * _loc4_,this._height * _loc5_,2,Math.random() * 1000,true,false,0,true);
         this._coolingBmd2.perlinNoise(this._width * _loc6_,this._height * _loc7_,2,Math.random() * 1000,true,false,0,true);
         this._coolingTmpBmd1 = this._coolingBmd1.clone();
         this._coolingTmpBmd2 = this._coolingBmd2.clone();
         this._coolingOffset1 = new Point();
         this._coolingOffset2 = new Point();
         this._palette = [0,0,41877504,61472768,97268480,114567680,148840448,165878784,199765504,233514752,267268864,284110848,317798656,334640640,368259328,385038848,418657536,435502336,469055744,502676992,536295936,553074688,586628096,603472384,637025792,653804288,704200192,720978688,754533888,771310592,804865536,821708032,855262976,872039936,922371840,939149824,972703744,989481728,1023101952,1039878912,1073433856,1106988544,1140542464,1157320448,1190875136,1207652096,1241206784,1274761728,1291538432,1325093376,1341936640,1375491328,1409046016,1442599936,1459377664,1492932352,1509709312,1543264000,1560041728,1610373888,1627150848,1660705536,1677483264,1711037696,1727814656,1761370112,1778147072,1828478464,1828479232,1878876160,1895588352,1929142784,1945920512,1979474944,1996318208,2029872128,2063426560,2096981248,2113758208,2147312640,2164090368,2197644288,2214421760,2247975936,2281530368,2315084800,2331862016,2365416448,2382193920,2415748096,2432525568,2466080000,2499634176,2533188608,2549966080,2583520256,2600297728,2633852160,2667406336,2684183808,2717738240,2751292416,2768069888,2801624320,2835178496,2851955968,2885510400,2902287616,2935842048,2969396480,3002950656,3019728128,3053282560,3070059776,3103614208,3120391168,3154011392,3187500288,3221054720,3237897472,3271386368,3288163328,3305006336,3321718016,3338494976,3355337984,3355337984,3372049664,3372049664,3388826880,3405669632,3405669632,3422381056,3439224064,3439224064,3455935744,3472712960,3472712960,3489490176,3506267136,3506267136,3523044608,3539821824,3539821824,3556599040,3573376256,3573376256,3590153216,3606996224,3623707904,3623708416,3640551936,3640552960,3657265152,3674043648,3674044416,3690887936,3707600384,3707600896,3724444416,3741222912,3741223680,3757935872,3774713856,3774714880,3791558656,3808270848,3808272128,3825049856,3841893376,3841894400,3858672128,3875384832,3875385600,3892163840,3909007104,3909008128,3925785856,3942498560,3942499072,3959277568,3976055552,3976056320,3992899840,4009677824,4009678592,4026457088,4043235072,4043235584,4059948032,4076726016,4076727040,4093505024,4110283264,4110284032,4127127552,4143905792,4143906305,4160683525,4177460746,4177460750,4194237971,4211015191,4211015196,4227792416,4244569636,4244569641,4261346862,4278124082,4278124086,4294967100,4294967104,4294967109,4294967113,4294967118,4294967122,4294967126,4294967131,4294967136,4294967140,4294967145,4294967149,4294967153,4294967158,4294967162,4294967167,4294967171,4294967176,4294967180,4294967185,4294967189,4294967194,4294967198,4294967203,4294967207,4294967211,4294967216,4294967220,4294967225,4294967230,4294967234,4294967238,4294967243,4294967247,4294967252,4294967256,4294967261,4294967265,4294967269,4294967274,4294967279,4294967283,4294967288,4294967292,4294967295,4294967295];
         this._zeros = new Array(256);
         this._paletteAlpha = new Array(256);
         var _loc8_:int = 0;
         while(_loc8_ < 256)
         {
            this._zeros[_loc8_] = 0;
            this._paletteAlpha[_loc8_] = _loc8_;
            _loc8_++;
         }
         this.enhance = 1;
         this._sparkLife = 50;
         this._sparkThreshold = 50;
         this._particleCount = 50;
         _loc8_ = 0;
         while(_loc8_ < this._particleCount)
         {
            _loc9_ = new Particle(Math.random() * this._width,Math.random() * this._height);
            if(this._particleFirst == null)
            {
               _loc10_ = this._particleFirst = _loc9_;
            }
            else
            {
               _loc10_.next = _loc9_;
               _loc10_ = _loc9_;
            }
            _loc8_++;
         }
         this._fire = new BitmapData(this._width,this._height,true,0);
         this._mc = addChild(new Bitmap(this._fire));
         this._mc.x = -10;
         this._mc.y = -60;
      }
      
      public function get emitter() : DisplayObject
      {
         return this._emitter;
      }
      
      public function set emitter(param1:DisplayObject) : void
      {
         this._emitter = param1;
      }
      
      public function get cooling() : Number
      {
         return this._cooling;
      }
      
      public function set cooling(param1:Number) : void
      {
         this._cooling = param1;
         this._coolingFilter = new ColorMatrixFilter([param1,0,0,0,0,0,param1,0,0,0,0,0,param1,0,0,0,0,0,param1,0]);
      }
      
      public function get enhance() : Number
      {
         return this._enhance;
      }
      
      public function set enhance(param1:Number) : void
      {
         this._enhance = param1;
         this._enhanceTransform = new ColorTransform(this._enhance,this._enhance,this._enhance);
      }
      
      public function get palette() : Array
      {
         return this._palette;
      }
      
      public function set palette(param1:Array) : void
      {
         this._palette = param1;
      }
      
      public function get sparkLife() : int
      {
         return this._sparkLife;
      }
      
      public function set sparkLife(param1:int) : void
      {
         this._sparkLife = param1;
      }
      
      public function get sparkThreshold() : int
      {
         return this._sparkThreshold;
      }
      
      public function set sparkThreshold(param1:int) : void
      {
         this._sparkThreshold = param1;
      }
      
      public function Tick() : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc1_:Rectangle = this._emitter.getRect(this._emitter);
         var _loc4_:Particle = this._particleFirst;
         var _loc5_:Matrix;
         (_loc5_ = new Matrix()).translate(10,60);
         this._greyBmd.lock();
         this._fire.lock();
         this._coolingTmpBmd1.lock();
         this._coolingTmpBmd2.lock();
         this._coolingBmd1.lock();
         this._coolingBmd2.lock();
         this._greyBmd.draw(this._emitter,_loc5_,this._enhanceTransform);
         this._greyBmd.applyFilter(this._greyBmd,this._rect,this._point,this._greyFilter);
         this._greyBmd.applyFilter(this._greyBmd,this._rect,this._point,this._spreadFilter);
         this._scrollBitmapData(this._coolingBmd1,this._coolingTmpBmd1,this._coolingOffset1.x,this._coolingOffset1.y);
         this._scrollBitmapData(this._coolingBmd2,this._coolingTmpBmd2,this._coolingOffset2.x,this._coolingOffset2.y);
         this._coolingOffset1.x -= 0;
         this._coolingOffset1.y -= 10;
         this._coolingOffset2.x += 2;
         this._coolingOffset2.y -= 5;
         this._coolingTmpBmd2.draw(this._coolingTmpBmd1,_loc5_,null,BlendMode.ADD);
         this._coolingTmpBmd2.applyFilter(this._coolingTmpBmd2,this._rect,this._point,this._coolingFilter);
         this._greyBmd.draw(this._coolingTmpBmd2,null,null,BlendMode.SUBTRACT);
         this._greyBmd.scroll(0,-this._spread);
         do
         {
            _loc2_ = this._greyBmd.getPixel(_loc4_.x,_loc4_.y) & 255;
            _loc4_.vx = Math.sin(_loc4_.clock);
            _loc4_.vy = -_loc2_ * 0.05 - 1;
            _loc4_.clock += 0.01;
            _loc4_.x += _loc4_.vx;
            _loc4_.y += _loc4_.vy;
            if(_loc2_ > this._sparkThreshold)
            {
               _loc4_.life = this._sparkLife;
            }
            else
            {
               --_loc4_.life;
            }
            if(_loc4_.x > _loc1_.x + _loc1_.width)
            {
               _loc4_.x -= _loc1_.width;
               _loc4_.life = 0;
            }
            if(_loc4_.x < _loc1_.x)
            {
               _loc4_.x += _loc1_.width;
               _loc4_.life = 0;
            }
            if(_loc4_.y < 0)
            {
               _loc4_.y += _loc1_.y + _loc1_.height;
               _loc4_.life = 0;
            }
            if(_loc4_.life > 0)
            {
               _loc3_ = _loc4_.life / this._sparkLife * 255;
               _loc3_ = _loc3_ > _loc2_ ? _loc3_ : _loc2_;
               this._greyBmd.setPixel(_loc4_.x + 10,_loc4_.y + 30,_loc3_ << 16 | _loc3_ << 8 | _loc3_);
            }
            _loc4_ = _loc4_.next;
         }
         while(_loc4_);
         
         this._fire.paletteMap(this._greyBmd,this._rect,this._point,this._zeros,this._zeros,this._palette,this._zeros);
         this._coolingBmd1.unlock();
         this._coolingBmd2.unlock();
         this._coolingTmpBmd1.unlock();
         this._coolingTmpBmd2.unlock();
         this._greyBmd.unlock();
         this._fire.unlock();
      }
      
      public function Clear() : void
      {
         this._clearBmd.dispose();
         this._greyBmd.dispose();
         this._coolingBmd1.dispose();
         this._coolingBmd2.dispose();
         this._coolingTmpBmd1.dispose();
         this._coolingTmpBmd2.dispose();
         this._fire.dispose();
         this.removeChild(this._mc);
      }
      
      private function _scrollBitmapData(param1:BitmapData, param2:BitmapData, param3:int, param4:int) : void
      {
         param3 %= this._width;
         param4 %= this._height;
         if(param3 != 0)
         {
            if(param3 > 0)
            {
               param2.copyPixels(param1,new Rectangle(0,0,this._width - param3,this._height),new Point(param3,0));
               param2.copyPixels(param1,new Rectangle(this._width - param3,0,param3,this._height),this._point);
            }
            else
            {
               param2.copyPixels(param1,new Rectangle(-param3,0,this._width + param3,this._height),this._point);
               param2.copyPixels(param1,new Rectangle(0,0,-param3,this._height),new Point(this._width + param3,0));
            }
         }
         if(param4 != 0)
         {
            if(param3 != 0)
            {
               param1 = param2.clone();
            }
            if(param4 > 0)
            {
               param2.copyPixels(param1,new Rectangle(0,0,this._width,this._height - param4),new Point(0,param4));
               param2.copyPixels(param1,new Rectangle(0,this._height - param4,this._width,param4),this._point);
            }
            else
            {
               param2.copyPixels(param1,new Rectangle(0,-param4,this._width,this._height + param4),this._point);
               param2.copyPixels(param1,new Rectangle(0,0,this._width,-param4),new Point(0,this._height + param4));
            }
         }
      }
   }
}

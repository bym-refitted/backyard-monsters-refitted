package
{
   import com.monsters.effects.LASERS;
   import com.monsters.effects.ResourceBombs;
   import com.monsters.effects.particles.Particles;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EFFECTS
   {
      
      public static var _items:Object = {};
      
      public static var _itemCount:int = 0;
      
      public static var _effects:Array = [];
      
      public static var _effectsJSON:String = "";
      
      public static var _scorches:Array = [new ParticleScorch1(0,0)];
      
      public static var _burns:BitmapData = new bmd_burns(0,0);
      
      public static var _splats:Array = [new ParticleSplat()];
      
      public static var _switcher:int = 0;
      
      public static var _trash:Object = {};
      
      public static var _tmpSplatCount:int = 0;
      
      public static var _effectsLimit:int;
      
      public static var _effectDuration:int;
       
      
      public function EFFECTS()
      {
         super();
      }
      
      public static function Setup(param1:Array) : void
      {
         _items = {};
         _itemCount = 0;
         _effects = param1;
         _effectsLimit = GLOBAL._flags.efl;
         _effectDuration = 172800;
      }
      
      public static function CreepSplat(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         if(param1.substr(0,1) == "G")
         {
            _loc4_ = 10;
         }
         else
         {
            _loc4_ = CREATURES.GetProperty(param1,"cResource") / 100;
         }
         if(_loc4_ > 5 && param1.substr(0,1) != "G")
         {
            _loc4_ = 5;
         }
         if(_tmpSplatCount < 2)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               ++_tmpSplatCount;
               _loc6_ = Math.random() * 360 * 0.0174532925;
               _loc7_ = Math.random() * 16;
               SplatParticle(30,param2 + Math.sin(_loc6_) * _loc7_,param3 + Math.cos(_loc6_) * _loc7_,_loc6_,Math.random() * 20 / 15);
               _loc5_++;
            }
         }
         GIBLETS.Create(new Point(param2,param3 + 3),0.8,75,_loc4_);
      }
      
      public static function SplatParticle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc7_:int = 0;
         var _loc6_:ParticleSplat = MAP._EFFECTS.addChild(new ParticleSplat()) as ParticleSplat;
         _loc7_ = 1 + int(Math.random() * 5);
         _loc6_.gotoAndStop(_loc7_);
         _loc6_.x = param2;
         _loc6_.y = param3;
         var _loc8_:Number = 1 / 32 * param1;
         _loc6_.scaleX = _loc6_.scaleY = _loc8_;
         _items["i" + _itemCount] = {
            "mc":_loc6_,
            "xd":Math.sin(param4),
            "yd":Math.cos(param4) * 0.5,
            "speed":param5,
            "life":0,
            "code":"s" + _loc7_,
            "frame":_loc7_
         };
         ++_itemCount;
      }
      
      public static function Scorch(param1:Point, param2:int = 0) : void
      {
         SnapShotB(param1.x,param1.y,"b" + param2,0);
         Push([param1.x,param1.y,"b" + param2,0]);
      }
      
      public static function Burn(param1:int, param2:int) : void
      {
         var _loc3_:int = 80 * int(Math.random() * 4) - 80;
         MAP.effectsBMD.copyPixels(_burns,new Rectangle(_loc3_,0,80,40),new Point(param1 + MAP.effectsBMD.width * 0.5 - 40,param2 + MAP.effectsBMD.height * 0.5 - 20),null,null,true);
      }
      
      public static function Lightning(param1:int, param2:int, param3:int, param4:int, param5:DisplayObjectContainer = null, param6:uint = 3197178) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(!param5)
         {
            param5 = MAP._PROJECTILES;
         }
         var _loc7_:int = Point.distance(new Point(param1,param2),new Point(param3,param4));
         var _loc8_:Shape;
         (_loc8_ = param5.addChild(new Shape()) as Shape).graphics.lineStyle(1,param6,1);
         _loc8_.graphics.moveTo(param1,param2);
         var _loc13_:int = 0;
         while(_loc13_ < int(_loc7_ / 30))
         {
            _loc9_ = param3 - param1;
            _loc10_ = param4 - param2;
            _loc11_ = Math.cos(Math.atan2(_loc10_,_loc9_)) * (_loc7_ / int(_loc7_ / 30) * _loc13_);
            _loc12_ = Math.sin(Math.atan2(_loc10_,_loc9_)) * (_loc7_ / int(_loc7_ / 30) * _loc13_);
            _loc8_.graphics.lineTo(_loc11_ + param1 - 7 + Math.random() * 15,_loc12_ + param2 - 7 + Math.random() * 15);
            _loc8_.filters = [new GlowFilter(param6,1,4,4,2,2,false,false)];
            _loc13_++;
         }
         _loc8_.graphics.lineTo(param3 - 5 + Math.random() * 10,param4 - Math.random() * 10);
         _loc8_.blendMode = "add";
         _trash["i" + _itemCount] = {
            "counter":0,
            "container":param5,
            "mc":_loc8_
         };
         ++_itemCount;
      }
      
      public static function Laser(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Number, param7:Number, param8:Function = null) : void
      {
         LASERS.Fire(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function Tick() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(_tmpSplatCount > 0)
         {
            --_tmpSplatCount;
         }
         for(_loc2_ in _items)
         {
            _loc1_ = _items[_loc2_];
            if(GLOBAL._render)
            {
               _loc1_.mc.x += _loc1_.xd * _loc1_.speed;
               _loc1_.mc.y += _loc1_.yd * _loc1_.speed;
               _loc1_.mc.scaleX = _loc1_.mc.scaleY = _loc1_.mc.scaleY + 0.02;
               if(_loc1_.speed > 0)
               {
                  _loc1_.speed -= 0.02;
               }
               ++_loc1_.life;
               if(_loc1_.speed <= 0 && _loc1_.life > 10)
               {
                  SnapShot(_loc1_);
                  Remove(MAP._EFFECTS,_loc1_.mc);
                  delete _items[_loc2_];
               }
            }
            else
            {
               _loc1_.mc.x += _loc1_.xd * (_loc1_.speed * 20);
               _loc1_.mc.y += _loc1_.yd * (_loc1_.speed * 20);
               _loc1_.mc.scaleX = _loc1_.mc.scaleY = _loc1_.mc.scaleY + 0.4;
               SnapShot(_loc1_);
               Remove(MAP._EFFECTS,_loc1_.mc);
               delete _items[_loc2_];
            }
         }
         LASERS.Tick();
         ResourceBombs.Tick();
         for(_loc3_ in _trash)
         {
            if((_loc4_ = _trash[_loc3_]).counter >= 3)
            {
               Remove(_loc4_.container,_loc4_.mc);
               delete _trash[_loc3_];
            }
            else
            {
               _loc4_.mc.alpha /= 1.75;
            }
            ++_loc4_.counter;
         }
      }
      
      public static function Remove(param1:DisplayObjectContainer, param2:DisplayObject) : void
      {
         param1.removeChild(param2);
      }
      
      public static function Process(param1:*) : void
      {
         var _loc3_:Array = null;
         while(_effects.length > _effectsLimit)
         {
            _effects.shift();
         }
         var _loc2_:int = 0;
         while(_loc2_ < _effects.length)
         {
            _loc3_ = _effects[_loc2_];
            if(_loc3_[3] + param1 > _effectDuration)
            {
               _effects.splice(_loc2_,1);
            }
            else
            {
               _loc3_[3] += param1;
               SnapShotB(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3]);
            }
            _loc2_++;
         }
         _effectsJSON = JSON.encode(_effects);
      }
      
      public static function SnapShot(param1:Object) : void
      {
         SnapShotB(param1.mc.x,param1.mc.y,param1.code,0,param1.mc.scaleX);
         Push([int(param1.mc.x),int(param1.mc.y),param1.code,0]);
      }
      
      public static function SnapShotB(param1:int, param2:int, param3:String, param4:int, param5:Number = 0) : void
      {
         var _loc6_:BitmapData = null;
         var _loc7_:Matrix = null;
         var _loc8_:ParticleSplat = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         try
         {
            _loc7_ = new Matrix();
            if(param5 == 0)
            {
               param5 = 1 + Math.random() * 10 / 10;
            }
            if(param3.substr(0,1) == "s")
            {
               _loc9_ = 100;
               _loc10_ = 100;
               _loc6_ = new BitmapData(100,100,true,0);
               _loc7_.scale(param5,param5);
               _loc7_.tx = 50;
               _loc7_.ty = 50;
               (_loc8_ = _splats[0]).gotoAndStop(param3.substr(1,1));
               _loc6_.draw(_loc8_,_loc7_,new ColorTransform(1,1,1,1 - param4 / _effectDuration));
            }
            else if(param3.substr(0,1) == "b")
            {
               _loc9_ = 200;
               _loc10_ = 100;
               _loc6_ = _scorches[param3.substr(1,1)];
               _loc7_.tx = 100;
               _loc7_.ty = 50;
            }
            MAP.effectsBMD.copyPixels(_loc6_,new Rectangle(0,0,_loc9_,_loc10_),new Point(param1 + MAP.effectsBMD.width * 0.5 - _loc9_ / 2,param2 + MAP.effectsBMD.height * 0.5 - _loc10_ / 2),null,null,true);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function Push(param1:Array) : void
      {
         if(_switcher % 2 == 0)
         {
            _effects.push(param1);
            _effectsJSON = JSON.encode(_effects);
            if(_effects.length > _effectsLimit)
            {
               _effects.shift();
            }
         }
         ++_switcher;
      }
      
      public static function Dig(param1:int, param2:int) : void
      {
         Particles.Create(new Point(param1,param2),1 + Math.random() * 0.5,30,20,0);
      }
      
      public static function Burrow(param1:int, param2:int) : void
      {
         Particles.Create(new Point(param1,param2),0.5 + Math.random() * 0.5,10,3,0);
      }
   }
}

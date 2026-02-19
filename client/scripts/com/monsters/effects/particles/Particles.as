package com.monsters.effects.particles
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   public class Particles
   {
      
      public static var _particles:Object = {};
      
      public static var _particleCount:int = 0;
      
      public static var _tmpParticleCount:int = 0;
      
      public static var _frame:int = 0;
      
      private static var _pool:Vector.<ParticlesObject> = new Vector.<ParticlesObject>();
       
      
      public function Particles()
      {
         super();
      }
      
      public static function Clear() : void
      {
         var particle:ParticlesObject = null;
         var g:String = null;
         try
         {
            for(g in _particles)
            {
               particle = _particles[g];
               if(particle.parent)
               {
                  particle.parent.removeChild(particle);
               }
               particle.Clear();
               PoolSet(particle);
               delete _particles[g];
            }
            _particles = {};
            _particleCount = 0;
            _frame = 0;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Particles Clear" + " " + e.getStackTrace());
         }
      }
      
      public static function PoolGet(param1:int, param2:Point, param3:Point, param4:int, param5:Number, param6:Number) : ParticlesObject
      {
         var _loc7_:ParticlesObject = null;
         if(_pool.length)
         {
            _loc7_ = _pool.pop();
         }
         else
         {
            (_loc7_ = new ParticlesObject()).gotoAndStop(int(Math.random() * 3) + 1);
         }
         _loc7_.init(param1,param2,param3,param4,param5,param6);
         return _loc7_;
      }
      
      public static function PoolSet(param1:ParticlesObject) : void
      {
         _pool.push(param1);
      }
      
      public static function Create(param1:Point, param2:Number, param3:int, param4:int, param5:int = 0) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         if(!GLOBAL._catchup)
         {
            if(_tmpParticleCount < 80)
            {
               _loc6_ = 0;
               while(_loc6_ < param4)
               {
                  _tmpParticleCount += 1;
                  _loc7_ = param3 * 0.2 + Math.random() * (param3 * 0.8);
                  if(Math.random() <= 0.3)
                  {
                     _loc7_ *= 1.5;
                  }
                  Spawn(param1.add(new Point(-3 + Math.random() * 6,-2 + Math.random() * 4)),param2,_loc7_,_loc6_ / 100,param5);
                  _loc6_++;
               }
            }
         }
      }
      
      public static function Spawn(param1:Point, param2:Number, param3:int, param4:Number, param5:int) : void
      {
         var _loc6_:Number = Math.random() * 360;
         var _loc7_:Point;
         var _loc8_:Number = (_loc7_ = GRID.FromISO(param1.x,param1.y)).x + Math.cos(_loc6_) * param3;
         var _loc9_:Number = _loc7_.y + Math.sin(_loc6_) * param3;
         var _loc10_:Point = GRID.ToISO(_loc8_,_loc9_,0).add(new Point(0,param5));
         _particles[_particleCount] = MAP._GROUND.addChild(PoolGet(_particleCount,param1,_loc10_,param3,param4,param2));
         _particleCount += 1;
      }
      
      public static function Remove(param1:*) : void
      {
         var _loc2_:ParticlesObject = _particles[param1];
         --_tmpParticleCount;
         try
         {
            MAP._GROUND.removeChild(_loc2_);
            _loc2_.Clear();
            PoolSet(_loc2_);
            delete _particles[param1];
         }
         catch(e:Error)
         {
         }
      }
      
      public static function SnapShot(param1:int, param2:int, param3:Number, param4:ParticlesObject) : void
      {
         var _loc5_:BitmapData = null;
         var _loc6_:Matrix = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         try
         {
            _loc6_ = new Matrix();
            _loc7_ = 26;
            _loc8_ = 26;
            _loc5_ = new BitmapData(_loc7_,_loc8_,true,0);
            _loc6_.scale(param3,param3);
            _loc6_.tx = _loc7_ * 0.5;
            _loc6_.ty = _loc8_ * 0.5;
            _loc5_.draw(param4,_loc6_);
            MAP.effectsBMD.copyPixels(_loc5_,new Rectangle(0,0,_loc7_,_loc8_),new Point(param1 + MAP.effectsBMD.width * 0.5 - _loc7_ / 2,param2 + MAP.effectsBMD.height * 0.5 - _loc8_ * 0.5),null,null,true);
         }
         catch(e:Error)
         {
         }
      }
   }
}

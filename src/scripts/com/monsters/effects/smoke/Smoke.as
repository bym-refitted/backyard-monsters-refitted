package com.monsters.effects.smoke
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class Smoke
   {
      
      private static var _bmd:BitmapData;
      
      private static var _mc:DisplayObject;
      
      private static var _tmpPoint:Point;
      
      private static var _tmpSmokeParticle:com.monsters.effects.smoke.SmokeParticle;
      
      private static var _noiseBMD:BitmapData;
      
      private static var setupCompleted:Boolean;
      
      private static var _rect:Rectangle;
      
      private static var _frameNumber:int;
      
      private static var _sourceID:int;
      
      private static var lastProcessTime:Number;
      
      private static var _particles:Vector.<com.monsters.effects.smoke.SmokeParticle> = new Vector.<com.monsters.effects.smoke.SmokeParticle>();
      
      private static var _sources:Vector.<com.monsters.effects.smoke.SmokeSystem> = new Vector.<com.monsters.effects.smoke.SmokeSystem>();
      
      private static var _enabled:Boolean = false;
      
      public static var _smokeParticleBMD:Vector.<BitmapData> = new Vector.<BitmapData>(100,true);
       
      
      public function Smoke()
      {
         super();
      }
      
      public static function Setup() : void
      {
         var tmpSpriteSheet:BitmapData = null;
         var i:int = 0;
         var tmpW:int = 0;
         var tmpO:int = 0;
         var tmpSprite:BitmapData = null;
         try
         {
            if(!_enabled)
            {
               return;
            }
            if(!setupCompleted)
            {
               _rect = new Rectangle(0,0,1500,800);
               _frameNumber = 0;
               _sourceID = 0;
               tmpSpriteSheet = new smoke1(0,0);
               i = 0;
               while(i < 100)
               {
                  tmpW = 5 + 25 / 100 * i;
                  tmpO = (30 - tmpW) * 0.5;
                  tmpSprite = new BitmapData(tmpW,tmpW,true,16777215);
                  tmpSprite.copyPixels(tmpSpriteSheet,new Rectangle(i * 30 + tmpO,tmpO,tmpW,tmpW),new Point(0,0),null,null,true);
                  _smokeParticleBMD[i] = tmpSprite;
                  i++;
               }
               setupCompleted = true;
            }
            _bmd = new BitmapData(_rect.width,_rect.height,true,0);
            _mc = MAP._EFFECTSTOP.addChild(new Bitmap(_bmd));
            _mc.x = -_rect.width;
            _mc.y = -_rect.height;
            _mc.scaleX = _mc.scaleY = 2;
            _sources = new Vector.<com.monsters.effects.smoke.SmokeSystem>();
            _particles = new Vector.<com.monsters.effects.smoke.SmokeParticle>();
            _bmd.fillRect(_bmd.rect,0);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Smoke.Setup " + setupCompleted);
         }
      }
      
      public static function CreatePoof(param1:Point, param2:int, param3:Number) : void
      {
         if(!_enabled)
         {
            return;
         }
         if(GLOBAL._fps < 30)
         {
            return;
         }
         Add(param1,5,100 * param3,param2,2);
      }
      
      public static function CreateStream(param1:Point) : void
      {
         if(!_enabled)
         {
            return;
         }
         if(GLOBAL._fps < 30)
         {
            return;
         }
         Add(param1,200,4,2,1);
      }
      
      private static function Add(param1:Point, param2:int, param3:int, param4:int, param5:Number) : void
      {
         if(!_enabled)
         {
            return;
         }
         if(!setupCompleted)
         {
            return;
         }
         param1 = new Point(param1.x * 0.5,param1.y * 0.5).add(new Point(_rect.width * 0.5,_rect.height * 0.5));
         var _loc6_:com.monsters.effects.smoke.SmokeSystem;
         (_loc6_ = new com.monsters.effects.smoke.SmokeSystem()).id = _sourceID = _sourceID + 1;
         _loc6_.position = param1;
         _loc6_.life = param2;
         _loc6_.density = param3;
         _loc6_.basesize = param4 * 0.5;
         _loc6_.expand = param5;
         _sources.push(_loc6_);
         if(_sources.length > 3)
         {
            _sources.shift();
         }
      }
      
      private static function Remove(param1:int) : void
      {
         var _loc2_:int = 0;
         if(!_enabled)
         {
            return;
         }
         if(!setupCompleted)
         {
            return;
         }
         var _loc3_:int = int(_sources.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if((_sources[_loc2_] as com.monsters.effects.smoke.SmokeSystem).id == param1)
            {
               _sources.splice(_loc2_,1);
               return;
            }
            _loc2_ += 1;
         }
      }
      
      public static function Tick() : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:com.monsters.effects.smoke.SmokeSystem = null;
         var _loc6_:com.monsters.effects.smoke.SmokeParticle = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:BitmapData = null;
         if(!_enabled)
         {
            return;
         }
         if(!setupCompleted)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc3_:int = getTimer();
         _frameNumber += 1;
         _loc9_ = int(_particles.length);
         _loc10_ = int(_sources.length);
         if(_frameNumber % 2 == 0)
         {
            if(_loc9_ < 700 && GLOBAL._fps > 20)
            {
               _loc1_ = 0;
               while(_loc1_ < _loc10_)
               {
                  _loc11_ = (_loc5_ = _sources[_loc1_]).basesize * 0.5;
                  --_loc5_.life;
                  if(lastProcessTime > 10)
                  {
                     --_loc5_.life;
                  }
                  if(_loc5_.life <= 0)
                  {
                     Remove(_loc5_.id);
                     _loc10_--;
                     _loc1_--;
                  }
                  else
                  {
                     _loc2_ = 0;
                     while(_loc2_ < _loc5_.density)
                     {
                        (_loc6_ = new com.monsters.effects.smoke.SmokeParticle()).position = new Point(_loc5_.position.x - _loc11_ + Math.random() * _loc5_.basesize,_loc5_.position.y - _loc11_ + Math.random() * _loc5_.basesize);
                        _loc6_.position.x += Math.random() * _loc5_.basesize - _loc5_.basesize * 0.5;
                        _loc6_.position.y += (Math.random() * _loc5_.basesize - _loc5_.basesize * 0.5) * 0.5;
                        _loc6_.speed = 2 + Math.random();
                        _loc6_.wind = Math.random() * _loc5_.expand;
                        _particles.push(_loc6_);
                        _loc2_ += 1;
                     }
                     if(_loc5_.life % 10 == 0 && _loc5_.density > 1)
                     {
                        --_loc5_.density;
                     }
                  }
                  _loc1_ += 1;
               }
            }
            if((_loc9_ = int(_particles.length)) > 0)
            {
               _bmd.lock();
               _loc1_ = 0;
               while(_loc1_ < _loc9_)
               {
                  _loc6_ = _particles[_loc1_];
                  _loc7_ = int(100 - 100 / 3 * _loc6_.speed);
                  _loc8_ = _smokeParticleBMD[_loc7_].rect.width + 2;
                  _bmd.fillRect(new Rectangle(_loc6_.position.x - 1,_loc6_.position.y - 1,_loc8_,_loc8_),0);
                  _loc1_ += 1;
               }
               _loc4_ = 0;
               while(_loc4_ < GLOBAL._loops)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc9_)
                  {
                     (_loc6_ = _particles[_loc1_]).position.x = _loc6_.position.x + _loc6_.wind * 0.25;
                     _loc6_.position.y -= _loc6_.speed * 0.25;
                     _loc6_.speed -= 0.01;
                     if((_loc7_ = int(100 - 100 / 3 * _loc6_.speed)) >= 98)
                     {
                        _particles.splice(_loc1_,1);
                        _loc1_--;
                        _loc9_--;
                     }
                     _loc1_ += 1;
                  }
                  _loc4_++;
               }
               _loc1_ = 0;
               while(_loc1_ < _loc9_)
               {
                  _loc6_ = _particles[_loc1_];
                  _loc7_ = int(100 - 100 / 3 * _loc6_.speed);
                  _loc12_ = _smokeParticleBMD[_loc7_];
                  if(!GLOBAL._catchup)
                  {
                     _bmd.copyPixels(_loc12_,_loc12_.rect,_loc6_.position,null,null,true);
                  }
                  _loc1_ += 1;
               }
               _bmd.unlock();
            }
            lastProcessTime = getTimer() - _loc3_;
         }
      }
   }
}

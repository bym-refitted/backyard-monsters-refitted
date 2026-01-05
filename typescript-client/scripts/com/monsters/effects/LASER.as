package com.monsters.effects
{
   import com.monsters.monsters.MonsterBase;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class LASER
   {
       
      
      public var _container:DisplayObjectContainer;
      
      public var _mc:MovieClip;
      
      public var _buffer:Shape;
      
      public var _mcBitmapData:BitmapData;
      
      public var _height:int;
      
      public var _distance:int;
      
      public var _angle:Number;
      
      public var _origin:Point;
      
      public var _pointA:Point;
      
      public var _pointB:Point;
      
      public var _duration:Number = 0;
      
      public var _power:Number = 0;
      
      public var _trackCallbackFunction:Function;
      
      public var _damage:Number;
      
      public var _splash:Number;
      
      public var _frameNumber:int = 0;
      
      public var _bitmapWidth:int = 500;
      
      public var _bitmapHeight:int = 250;
      
      public function LASER()
      {
         super();
      }
      
      public function Fire(param1:MovieClip, param2:Point, param3:Point, param4:int, param5:Number, param6:Number, param7:Function) : void
      {
         this._height = param4;
         this._damage = param5;
         this._splash = param6;
         this._pointA = param2;
         this._pointB = param3;
         this._origin = param2;
         if(param7 != null)
         {
            this._trackCallbackFunction = param7;
         }
         this._container = param1.addChild(new MovieClip()) as DisplayObjectContainer;
         this._distance = Point.distance(this._pointA,this._pointB);
         var _loc8_:int = this._pointA.x - this._pointB.x;
         var _loc9_:int = this._pointA.y - this._pointB.y;
         this._angle = Math.atan2(_loc9_,_loc8_) * 57.2957795 + 180 - 150 / Math.sqrt(this._distance);
         this._duration = 0;
      }
      
      public function Tick() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc13_:Number = NaN;
         var _loc7_:int = Point.distance(new Point(this._pointA.x,this._pointA.y),new Point(this._pointB.x,this._pointB.y));
         _loc3_ = this._pointB.x - this._pointA.x;
         _loc4_ = this._pointB.y - this._pointA.y;
         _loc5_ = Math.cos(Math.atan2(_loc4_,_loc3_)) * 8;
         _loc6_ = Math.sin(Math.atan2(_loc4_,_loc3_)) * 8;
         var _loc8_:Point = this._pointA.add(new Point(_loc5_,_loc6_ - this._height));
         if(this._duration < 80)
         {
            if(this._power < 1)
            {
               this._power += 0.1;
            }
         }
         else if(this._power > 0)
         {
            this._power -= 0.1;
         }
         if(this._mc)
         {
            this._container.removeChild(this._mc);
            this._mc = null;
         }
         this._mc = this._container.addChild(new MovieClip()) as MovieClip;
         if(this._duration > 100)
         {
            return true;
         }
         var _loc9_:Number = 4 / Math.sqrt(this._distance);
         this._angle += _loc9_ / 2 * GLOBAL._loops;
         this._duration += GLOBAL._loops;
         var _loc10_:Number = this._pointA.x + Math.cos(this._angle * (Math.PI / 180)) * (this._distance + Math.sin((this._duration / 4 + getTimer() / 1000) / 20) * (this._distance / 20));
         var _loc11_:Number = this._pointA.y + Math.sin(this._angle * (Math.PI / 180)) * (this._distance + Math.sin((this._duration / 4 + getTimer() / 1000) / 20) * (this._distance / 20));
         this._pointB = new Point(_loc10_,_loc11_);
         if(this._trackCallbackFunction != null)
         {
            this._trackCallbackFunction(this._angle - 25);
         }
         if(!GLOBAL._catchup)
         {
            this._buffer = new Shape();
            this._buffer.graphics.beginFill(16555315,1);
            this._buffer.graphics.drawEllipse(this._pointB.x - 8,this._pointB.y - 4,16,8);
            this._buffer.filters = [new GlowFilter(16555315,1,40,20,15 + Math.random() * 5,2,false,false)];
            this._buffer.alpha = this._power / 2;
            this._mc.addChild(this._buffer);
            this._buffer = new Shape();
            this._buffer.graphics.beginFill(16555315,1);
            this._buffer.graphics.drawEllipse(_loc8_.x,_loc8_.y,8,8);
            this._buffer.filters = [new GlowFilter(16555315,1,20,20,5 + Math.random() * 5,1,false,false)];
            this._buffer.alpha = this._power / 2;
            this._mc.addChild(this._buffer);
            this._buffer = new Shape();
            this._buffer.graphics.beginFill(16051677,1);
            this._buffer.graphics.drawEllipse(_loc8_.x,_loc8_.y,5,5);
            this._buffer.filters = [new GlowFilter(16051677,0.75,20,20,1 + Math.random() * 2,1,false,false)];
            this._mc.addChild(this._buffer);
            this._buffer = new Shape();
            this._buffer.graphics.lineStyle(2 + Math.random() * 2,16051677,1);
            this._buffer.graphics.moveTo(_loc8_.x,_loc8_.y);
            this._buffer.graphics.lineTo(this._pointB.x,this._pointB.y);
            this._buffer.filters = [new GlowFilter(13313803,1,20 + Math.random() * 2,20 + Math.random() * 2,4,2,false,false)];
            this._buffer.alpha = this._power;
            this._mc.addChild(this._buffer);
            this._buffer = new Shape();
            this._buffer.graphics.moveTo(_loc8_.x,_loc8_.y);
            _loc7_ = Point.distance(new Point(_loc8_.x,_loc8_.y),new Point(this._pointB.x,this._pointB.y));
            _loc1_ = 1;
            while(_loc1_ < 30)
            {
               _loc13_ = 3 + Math.sin(_loc1_ / 3 - getTimer() / 70);
               this._buffer.graphics.lineStyle(_loc13_,16051677,1);
               _loc3_ = this._pointB.x - _loc8_.x;
               _loc4_ = this._pointB.y - _loc8_.y;
               _loc5_ = Math.cos(Math.atan2(_loc4_,_loc3_)) * (_loc7_ / 30 * _loc1_);
               _loc6_ = Math.sin(Math.atan2(_loc4_,_loc3_)) * (_loc7_ / 30 * _loc1_);
               this._buffer.graphics.lineTo(_loc5_ + _loc8_.x,_loc6_ + _loc8_.y);
               _loc1_++;
            }
            _loc7_ = Point.distance(new Point(this._pointA.x,this._pointA.y),new Point(this._pointB.x,this._pointB.y));
            this._buffer.graphics.lineTo(this._pointB.x,this._pointB.y);
            this._buffer.filters = [new GlowFilter(16051677,1,6 + Math.random() * 2,6 + Math.random() * 2,2,2,false,false)];
            this._buffer.alpha = this._power;
            this._mc.addChild(this._buffer);
            this._buffer = new Shape();
            this._buffer.graphics.beginFill(16051677,1);
            this._buffer.graphics.drawEllipse(this._pointB.x - 6,this._pointB.y - 3,12,6);
            this._buffer.filters = [new GlowFilter(16051677,1,20,10,5 + Math.random() * 5,2,false,false)];
            this._mc.addChild(this._buffer);
         }
         var _loc12_:int = 0;
         while(_loc12_ < GLOBAL._loops)
         {
            if(this._frameNumber % 8 == 0)
            {
               this.Splash(this._pointB);
            }
            if(this._frameNumber % 16 == 0)
            {
               EFFECTS.Burn(this._pointB.x,this._pointB.y);
            }
            ++this._frameNumber;
            _loc12_++;
         }
         return false;
      }
      
      public function Splash(param1:Point) : void
      {
         var _loc2_:Object = null;
         var _loc3_:MonsterBase = null;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Array = Targeting.getCreepsInRange(this._splash,param1,Targeting.getOldStyleTargets(-1));
         var _loc10_:int = 0;
         for(_loc4_ in _loc9_)
         {
            _loc2_ = _loc9_[_loc4_];
            _loc3_ = _loc2_.creep;
            _loc5_ = Number(_loc2_.dist);
            _loc6_ = _loc2_.pos;
            _loc8_ = this._damage * 0.5 / this._splash * (this._splash - _loc5_);
            _loc10_ += _loc8_;
            _loc3_.modifyHealth(-_loc8_);
         }
      }
   }
}

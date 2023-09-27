package com.gskinner.geom
{
   public dynamic class ColorMatrix extends Array
   {
      
      private static const DELTA_INDEX:Array = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.2,0.21,0.22,0.24,0.25,0.27,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.8,0.83,0.86,0.89,0.92,0.95,0.98,1,1.06,1.12,1.18,1.24,1.3,1.36,1.42,1.48,1.54,1.6,1.66,1.72,1.78,1.84,1.9,1.96,2,2.12,2.25,2.37,2.5,2.62,2.75,2.87,3,3.2,3.4,3.6,3.8,4,4.3,4.7,4.9,5,5.5,6,6.5,6.8,7,7.3,7.5,7.8,8,8.4,8.7,9,9.4,9.6,9.8,10];
      
      private static const IDENTITY_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
      
      private static const LENGTH:Number = IDENTITY_MATRIX.length;
       
      
      public function ColorMatrix(param1:Array = null)
      {
         super();
         param1 = this.fixMatrix(param1);
         this.copyMatrix(param1.length == LENGTH ? param1 : IDENTITY_MATRIX);
      }
      
      public function reset() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < LENGTH)
         {
            this[_loc1_] = IDENTITY_MATRIX[_loc1_];
            _loc1_++;
         }
      }
      
      public function adjustColor(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.adjustHue(param4);
         this.adjustContrast(param2);
         this.adjustBrightness(param1);
         this.adjustSaturation(param3);
      }
      
      public function adjustBrightness(param1:Number) : void
      {
         param1 = this.cleanValue(param1,100);
         if(param1 == 0 || isNaN(param1))
         {
            return;
         }
         this.multiplyMatrix([1,0,0,0,param1,0,1,0,0,param1,0,0,1,0,param1,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function adjustContrast(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         param1 = this.cleanValue(param1,100);
         if(param1 == 0 || isNaN(param1))
         {
            return;
         }
         if(param1 < 0)
         {
            _loc2_ = 127 + param1 / 100 * 127;
         }
         else
         {
            _loc2_ = param1 % 1;
            if(_loc2_ == 0)
            {
               _loc2_ = Number(DELTA_INDEX[param1]);
            }
            else
            {
               _loc2_ = DELTA_INDEX[param1 << 0] * (1 - _loc2_) + DELTA_INDEX[(param1 << 0) + 1] * _loc2_;
            }
            _loc2_ = _loc2_ * 127 + 127;
         }
         this.multiplyMatrix([_loc2_ / 127,0,0,0,0.5 * (127 - _loc2_),0,_loc2_ / 127,0,0,0.5 * (127 - _loc2_),0,0,_loc2_ / 127,0,0.5 * (127 - _loc2_),0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function adjustSaturation(param1:Number) : void
      {
         param1 = this.cleanValue(param1,100);
         if(param1 == 0 || isNaN(param1))
         {
            return;
         }
         var _loc2_:Number = 1 + (param1 > 0 ? 3 * param1 / 100 : param1 / 100);
         var _loc3_:Number = 0.3086;
         var _loc4_:Number = 0.6094;
         var _loc5_:Number = 0.082;
         this.multiplyMatrix([_loc3_ * (1 - _loc2_) + _loc2_,_loc4_ * (1 - _loc2_),_loc5_ * (1 - _loc2_),0,0,_loc3_ * (1 - _loc2_),_loc4_ * (1 - _loc2_) + _loc2_,_loc5_ * (1 - _loc2_),0,0,_loc3_ * (1 - _loc2_),_loc4_ * (1 - _loc2_),_loc5_ * (1 - _loc2_) + _loc2_,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function adjustHue(param1:Number) : void
      {
         param1 = this.cleanValue(param1,180) / 180 * Math.PI;
         if(param1 == 0 || isNaN(param1))
         {
            return;
         }
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         var _loc4_:Number = 0.213;
         var _loc5_:Number = 0.715;
         var _loc6_:Number = 0.072;
         this.multiplyMatrix([_loc4_ + _loc2_ * (1 - _loc4_) + _loc3_ * -_loc4_,_loc5_ + _loc2_ * -_loc5_ + _loc3_ * -_loc5_,_loc6_ + _loc2_ * -_loc6_ + _loc3_ * (1 - _loc6_),0,0,_loc4_ + _loc2_ * -_loc4_ + _loc3_ * 0.143,_loc5_ + _loc2_ * (1 - _loc5_) + _loc3_ * 0.14,_loc6_ + _loc2_ * -_loc6_ + _loc3_ * -0.283,0,0,_loc4_ + _loc2_ * -_loc4_ + _loc3_ * -(1 - _loc4_),_loc5_ + _loc2_ * -_loc5_ + _loc3_ * _loc5_,_loc6_ + _loc2_ * (1 - _loc6_) + _loc3_ * _loc6_,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function concat(param1:Array) : void
      {
         param1 = this.fixMatrix(param1);
         if(param1.length != LENGTH)
         {
            return;
         }
         this.multiplyMatrix(param1);
      }
      
      public function clone() : ColorMatrix
      {
         return new ColorMatrix(this);
      }
      
      public function toString() : String
      {
         return "ColorMatrix [ " + this.join(" , ") + " ]";
      }
      
      public function toArray() : Array
      {
         return slice(0,20);
      }
      
      protected function copyMatrix(param1:Array) : void
      {
         var _loc2_:Number = LENGTH;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
      }
      
      protected function multiplyMatrix(param1:Array) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               _loc2_[_loc4_] = this[_loc4_ + _loc3_ * 5];
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               _loc5_ = 0;
               _loc6_ = 0;
               while(_loc6_ < 5)
               {
                  _loc5_ += param1[_loc4_ + _loc6_ * 5] * _loc2_[_loc6_];
                  _loc6_++;
               }
               this[_loc4_ + _loc3_ * 5] = _loc5_;
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      protected function cleanValue(param1:Number, param2:Number) : Number
      {
         return Math.min(param2,Math.max(-param2,param1));
      }
      
      protected function fixMatrix(param1:Array = null) : Array
      {
         if(param1 == null)
         {
            return IDENTITY_MATRIX;
         }
         if(param1 is ColorMatrix)
         {
            param1 = param1.slice(0);
         }
         if(param1.length < LENGTH)
         {
            param1 = param1.slice(0,param1.length).concat(IDENTITY_MATRIX.slice(param1.length,LENGTH));
         }
         else if(param1.length > LENGTH)
         {
            param1 = param1.slice(0,LENGTH);
         }
         return param1;
      }
   }
}

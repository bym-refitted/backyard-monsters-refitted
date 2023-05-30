package com.cc.utils
{
   public class SecNum
   {
      
      private static const TWOPOW32:Number = Math.pow(2,32);
       
      
      private var _seed:uint;
      
      private var _x:uint;
      
      private var _n:uint;
      
      private var _n64:uint;
      
      private var _neg:Boolean;
      
      public function SecNum(param1:Number)
      {
         super();
         this.Set(param1);
      }
      
      public function Set(param1:Number) : void
      {
         this._neg = false;
         if(param1 < 0)
         {
            param1 *= -1;
            this._neg = true;
         }
         this._seed = Math.random() * 99999;
         param1 = Math.round(param1);
         this._x = param1 ^ this._seed;
         this._n = uint(param1) + (this._seed << 1) ^ this._seed;
         this._n64 = param1 / TWOPOW32;
      }
      
      public function Add(param1:Number) : Number
      {
         this.Set(param1 = param1 + this.Get());
         return param1;
      }
      
      public function Get() : Number
      {
         var _loc1_:Number = this._n64 * TWOPOW32 + uint(this._x ^ this._seed);
         if(_loc1_ == this._n64 * TWOPOW32 + uint(uint(this._n ^ this._seed) - (this._seed << 1)))
         {
            if(this._neg)
            {
               _loc1_ *= -1;
            }
            return _loc1_;
         }
         LOGGER.Log("err","SecNum Broke (impossible unless.....)" + _loc1_ + " != " + (this._n64 * TWOPOW32 + uint(uint(this._n ^ this._seed) - (this._seed << 1))) + "?");
         GLOBAL.ErrorMessage("SecNum");
         return 0;
      }
   }
}

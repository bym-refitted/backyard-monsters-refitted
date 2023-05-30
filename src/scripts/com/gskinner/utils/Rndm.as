package com.gskinner.utils
{
   import flash.display.BitmapData;
   
   public class Rndm
   {
      
      protected static var _instance:com.gskinner.utils.Rndm;
       
      
      protected var _seed:uint = 0;
      
      protected var _pointer:uint = 0;
      
      protected var bmpd:BitmapData;
      
      protected var seedInvalid:Boolean = true;
      
      public function Rndm(param1:uint = 0)
      {
         super();
         this._seed = param1;
         this.bmpd = new BitmapData(1000,200);
      }
      
      public static function get instance() : com.gskinner.utils.Rndm
      {
         if(_instance == null)
         {
            _instance = new com.gskinner.utils.Rndm();
         }
         return _instance;
      }
      
      public static function get seed() : uint
      {
         return instance.seed;
      }
      
      public static function set seed(param1:uint) : void
      {
         instance.seed = param1;
      }
      
      public static function get pointer() : uint
      {
         return instance.pointer;
      }
      
      public static function set pointer(param1:uint) : void
      {
         instance.pointer = param1;
      }
      
      public static function random() : Number
      {
         return instance.random();
      }
      
      public static function float(param1:Number, param2:Number = NaN) : Number
      {
         return instance.float(param1,param2);
      }
      
      public static function boolean(param1:Number = 0.5) : Boolean
      {
         return instance.boolean(param1);
      }
      
      public static function sign(param1:Number = 0.5) : int
      {
         return instance.sign(param1);
      }
      
      public static function bit(param1:Number = 0.5) : int
      {
         return instance.bit(param1);
      }
      
      public static function integer(param1:Number, param2:Number = NaN) : int
      {
         return instance.integer(param1,param2);
      }
      
      public static function reset() : void
      {
         instance.reset();
      }
      
      public function get seed() : uint
      {
         return this._seed;
      }
      
      public function set seed(param1:uint) : void
      {
         if(param1 != this._seed)
         {
            this.seedInvalid = true;
            this._pointer = 0;
         }
         this._seed = param1;
      }
      
      public function get pointer() : uint
      {
         return this._pointer;
      }
      
      public function set pointer(param1:uint) : void
      {
         this._pointer = param1;
      }
      
      public function random() : Number
      {
         if(this.seedInvalid)
         {
            this.bmpd.noise(this._seed,0,255,1 | 2 | 4 | 8);
            this.seedInvalid = false;
         }
         this._pointer = (this._pointer + 1) % 200000;
         return (this.bmpd.getPixel32(this._pointer % 1000,this._pointer / 1000 >> 0) * 0.999999999999998 + 1e-15) / 4294967295;
      }
      
      public function float(param1:Number, param2:Number = NaN) : Number
      {
         if(isNaN(param2))
         {
            param2 = param1;
            param1 = 0;
         }
         return this.random() * (param2 - param1) + param1;
      }
      
      public function boolean(param1:Number = 0.5) : Boolean
      {
         return this.random() < param1;
      }
      
      public function sign(param1:Number = 0.5) : int
      {
         return this.random() < param1 ? 1 : -1;
      }
      
      public function bit(param1:Number = 0.5) : int
      {
         return this.random() < param1 ? 1 : 0;
      }
      
      public function integer(param1:Number, param2:Number = NaN) : int
      {
         if(isNaN(param2))
         {
            param2 = param1;
            param1 = 0;
         }
         return Math.floor(this.float(param1,param2));
      }
      
      public function reset() : void
      {
         this._pointer = 0;
      }
   }
}

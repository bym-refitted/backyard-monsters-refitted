package com.cc.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;

   public class SecNum
   {
      private var _value:Number;
      private var _neg:Boolean;
      private var _hash:String;
      private var _secretSeed:String;

      /**
       * Constructor for SecNum, initializes with an optional value.
       * @param initialValue The initial number to store securely.
       */
      public function SecNum(initialValue:Number = 0)
      {
         this._secretSeed = this.generateRandomSeed();
         this.Set(initialValue); // Initialize with the provided value
      }

      /**
       * Getter for retrieving the stored value securely.
       */
      public function Get():Number
      {
         if (this._hash === this.computeHash(this._value, this._secretSeed))
         {
            return this._value;
         }
         else
         {
            GLOBAL.ErrorMessage("SecNum integrity failure.");
            return NaN;
         }
      }

      /**
       * Setter for securely setting a new value.
       * @param value The new number to securely store.
       */
      public function Set(value:Number):void
      {
         this._neg = false;
         if (value < 0)
         {
            value *= -1; // Convert to positive, what is this shit?
            this._neg = true;
         }
         this._value = value;
         this._hash = this.computeHash(value, this._secretSeed);
      }

      /**
       * Computes a simple hash using the number and a seed.
       * @param value The number to hash.
       * @param seed The secret seed for hashing.
       * @return A hash string of the combined value and seed.
       */
      private function computeHash(value:Number, seed:String):String
      {
         var byteArray:ByteArray = new ByteArray();
         byteArray.endian = Endian.LITTLE_ENDIAN;

         byteArray.writeDouble(value);
         byteArray.writeUTFBytes(seed);

         var hash:uint = 0;
         byteArray.position = 0;
         while (byteArray.bytesAvailable)
         {
            hash ^= byteArray.readUnsignedByte();
         }

         return hash.toString(16);
      }

      /**
       * Generates a random seed string for additional security.
       * @return A random seed string.
       */
      private function generateRandomSeed():String
      {
         return Math.random().toString(36).substr(2, 10);
      }
   }
}

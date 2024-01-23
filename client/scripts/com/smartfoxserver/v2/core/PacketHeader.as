package com.smartfoxserver.v2.core
{
   public class PacketHeader
   {
       
      
      private var _expectedLen:int;
      
      private var _binary:Boolean;
      
      private var _compressed:Boolean;
      
      private var _encrypted:Boolean;
      
      private var _blueBoxed:Boolean;
      
      private var _bigSized:Boolean;
      
      public function PacketHeader(param1:Boolean, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this._expectedLen = -1;
         this._binary = true;
         this._compressed = param2;
         this._encrypted = param1;
         this._blueBoxed = param3;
         this._bigSized = param4;
      }
      
      public static function fromBinary(param1:int) : PacketHeader
      {
         return new PacketHeader((param1 & 64) > 0,(param1 & 32) > 0,(param1 & 16) > 0,(param1 & 8) > 0);
      }
      
      public function get expectedLen() : int
      {
         return this._expectedLen;
      }
      
      public function set expectedLen(param1:int) : void
      {
         this._expectedLen = param1;
      }
      
      public function get binary() : Boolean
      {
         return this._binary;
      }
      
      public function set binary(param1:Boolean) : void
      {
         this._binary = param1;
      }
      
      public function get compressed() : Boolean
      {
         return this._compressed;
      }
      
      public function set compressed(param1:Boolean) : void
      {
         this._compressed = param1;
      }
      
      public function get encrypted() : Boolean
      {
         return this._encrypted;
      }
      
      public function set encrypted(param1:Boolean) : void
      {
         this._encrypted = param1;
      }
      
      public function get blueBoxed() : Boolean
      {
         return this._blueBoxed;
      }
      
      public function set blueBoxed(param1:Boolean) : void
      {
         this._blueBoxed = param1;
      }
      
      public function get bigSized() : Boolean
      {
         return this._bigSized;
      }
      
      public function set bigSized(param1:Boolean) : void
      {
         this._bigSized = param1;
      }
      
      public function encode() : int
      {
         var _loc1_:int = 0;
         if(this.binary)
         {
            _loc1_ += 128;
         }
         if(this.encrypted)
         {
            _loc1_ += 64;
         }
         if(this.compressed)
         {
            _loc1_ += 32;
         }
         if(this.blueBoxed)
         {
            _loc1_ += 16;
         }
         if(this.bigSized)
         {
            _loc1_ += 8;
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc1_:* = "";
         _loc1_ += "---------------------------------------------\n";
         _loc1_ += "Binary:  \t" + this.binary + "\n";
         _loc1_ += "Compressed:\t" + this.compressed + "\n";
         _loc1_ += "Encrypted:\t" + this.encrypted + "\n";
         _loc1_ += "BlueBoxed:\t" + this.blueBoxed + "\n";
         _loc1_ += "BigSized:\t" + this.bigSized + "\n";
         return _loc1_ + "---------------------------------------------\n";
      }
   }
}

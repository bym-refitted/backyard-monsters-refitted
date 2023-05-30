package com.smartfoxserver.v2.bitswarm
{
   import com.smartfoxserver.v2.core.PacketHeader;
   import flash.utils.ByteArray;
   
   public class PendingPacket
   {
       
      
      private var _header:PacketHeader;
      
      private var _buffer:ByteArray;
      
      public function PendingPacket(param1:PacketHeader)
      {
         super();
         this._header = param1;
         this._buffer = new ByteArray();
      }
      
      public function get header() : PacketHeader
      {
         return this._header;
      }
      
      public function get buffer() : ByteArray
      {
         return this._buffer;
      }
      
      public function set buffer(param1:ByteArray) : void
      {
         this._buffer = param1;
      }
   }
}

package com.monsters.chat
{
   /**
    * Neutral key-value data container for chat system abstraction.
    * Replaces direct dependency on SmartFoxServer SFSObject type.
    */
   public class ChatData
   {
      private var _data:Object;
      
      public function ChatData()
      {
         this._data = {};
      }
      
      // String operations
      public function putUtfString(key:String, value:String):void
      {
         this._data[key] = value;
      }
      
      public function getUtfString(key:String):String
      {
         return this._data[key] as String;
      }
      
      // Integer operations
      public function putInt(key:String, value:int):void
      {
         this._data[key] = value;
      }
      
      public function getInt(key:String):int
      {
         return int(this._data[key]);
      }
      
      // Long operations
      public function putLong(key:String, value:Number):void
      {
         this._data[key] = value;
      }
      
      public function getLong(key:String):Number
      {
         return Number(this._data[key]);
      }
      
      // Boolean operations
      public function putBool(key:String, value:Boolean):void
      {
         this._data[key] = value;
      }
      
      public function getBool(key:String):Boolean
      {
         return Boolean(this._data[key]);
      }
      
      // Number operations
      public function putDouble(key:String, value:Number):void
      {
         this._data[key] = value;
      }
      
      public function getDouble(key:String):Number
      {
         return Number(this._data[key]);
      }
      
      // Array operations
      public function putArray(key:String, value:Array):void
      {
         this._data[key] = value;
      }
      
      public function getArray(key:String):Array
      {
         return this._data[key] as Array;
      }
      
      // Nested ChatData operations
      public function putChatData(key:String, value:ChatData):void
      {
         this._data[key] = value;
      }
      
      public function getChatData(key:String):ChatData
      {
         return this._data[key] as ChatData;
      }
      
      // Generic operations
      public function put(key:String, value:*):void
      {
         this._data[key] = value;
      }
      
      public function get(key:String):*
      {
         return this._data[key];
      }
      
      public function containsKey(key:String):Boolean
      {
         return key in this._data;
      }
      
      public function remove(key:String):void
      {
         delete this._data[key];
      }
      
      public function get keys():Array
      {
         var result:Array = [];
         for (var key:String in this._data)
         {
            result.push(key);
         }
         return result;
      }
      
      public function get size():int
      {
         var count:int = 0;
         for (var key:String in this._data)
         {
            count++;
         }
         return count;
      }
      
      /**
       * Returns raw data object for internal use
       */
      public function get rawData():Object
      {
         return this._data;
      }
   }
}

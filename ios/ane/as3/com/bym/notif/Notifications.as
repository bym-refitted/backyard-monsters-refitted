package com.bym.notif
{
   import flash.external.ExtensionContext;

   // AS3 side of the com.bym.notif ANE. NOTE: the game (NOTIFY.as) talks to the ExtensionContext
   // DIRECTLY by id, so it does NOT link this SWC — this class exists only so build-ane.sh can
   // produce a valid library.swf for the ANE, and it documents the native interface. Keeping it
   // here means the ANE can be linked as a typed dependency later if ever wanted.
   public class Notifications
   {
      public static const EXTENSION_ID:String = "com.bym.notif";

      private static var _ctx:ExtensionContext;

      public static function get isSupported() : Boolean
      {
         return ensure() != null;
      }

      private static function ensure() : ExtensionContext
      {
         if(_ctx == null)
         {
            try
            {
               _ctx = ExtensionContext.createExtensionContext(EXTENSION_ID,null);
            }
            catch(e:Error)
            {
               _ctx = null;
            }
         }
         return _ctx;
      }

      public static function requestPermission() : void
      {
         var c:ExtensionContext = ensure();
         if(c)
         {
            c.call("requestPermission");
         }
      }

      public static function schedule(id:String, title:String, body:String, seconds:Number) : void
      {
         var c:ExtensionContext = ensure();
         if(c)
         {
            c.call("schedule",id,title,body,seconds);
         }
      }

      public static function cancel(id:String) : void
      {
         var c:ExtensionContext = ensure();
         if(c)
         {
            c.call("cancel",id);
         }
      }

      public static function cancelAll() : void
      {
         var c:ExtensionContext = ensure();
         if(c)
         {
            c.call("cancelAll");
         }
      }
   }
}

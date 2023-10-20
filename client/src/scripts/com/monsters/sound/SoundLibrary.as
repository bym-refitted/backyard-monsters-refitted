package com.monsters.sound
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.events.IEventDispatcher;
   import flash.system.Security;
   import flash.media.Sound;
   import flash.errors.IOError;

   public class SoundLibrary
   {

      public var _asset:String;

      public var li:LoaderInfo;

      public var loader:Loader;

      public var next:com.monsters.sound.SoundLibrary;

      public var loaded:Boolean;

      public function SoundLibrary(audioAsset:String)
      {
         super();
         this._asset = audioAsset;
         this.loaded = false;
      }

      public function Load():void
      {
         var sound:Sound = new Sound();
         sound.addEventListener(Event.COMPLETE, onLoad);
         sound.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);

         var soundURLRequest:URLRequest = new URLRequest(this._asset);

         try
         {
            sound.load(soundURLRequest);
         }
         catch (error:IOError)
         {
            trace("IOError: " + error.message);
         }
      }

      private function onLoad(event:Event):void
      {
         // The MP3 file is loaded and ready to be played.
         this.loaded = true;
         if (this.next)
         {
            this.next.Load();
         }
         else
         {
            SOUNDS._loadState = 2;
         }
      }

      private function handleLoadError(param1:IOErrorEvent):void
      {
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR, this.handleLoadError);
         var errMessage:String = param1.text;
         GLOBAL._layerTop.addChild(GLOBAL.Message("There was an error loading sounds and music"));
      }
   }
}

package com.monsters.sound
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class SoundLibrary
   {
       
      
      public var _asset:String;
      
      public var li:LoaderInfo;
      
      public var loader:Loader;
      
      public var next:com.monsters.sound.SoundLibrary;
      
      public var loaded:Boolean;
      
      public function SoundLibrary(param1:String)
      {
         super();
         this._asset = param1;
         this.loaded = false;
      }
      
      public function Load() : void
      {
         this.loader = new Loader();
         this.loader.load(new URLRequest(this._asset),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoad);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,GLOBAL.handleLoadError);
      }
      
      private function onLoad(param1:Event) : void
      {
         this.li = param1.target as LoaderInfo;
         this.loaded = true;
         if(this.next)
         {
            this.next.Load();
         }
         else
         {
            SOUNDS._loadState = 2;
         }
      }
   }
}

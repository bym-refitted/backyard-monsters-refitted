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
         Security.loadPolicyFile(GLOBAL.serverUrl + "crossdomain.xml");
         var context:LoaderContext = new LoaderContext();
         context.checkPolicyFile = true;
         //context.securityDomain = SecurityDomain.currentDomain;
         context.applicationDomain = ApplicationDomain.currentDomain;

         this.loader = new Loader();
         this.loader.load(new URLRequest(this._asset), context);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoad);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadError);
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

      private function handleLoadError(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadError);
         var errMessage:String = param1.text;
         GLOBAL._layerTop.addChild(GLOBAL.Message("There was an error loading sounds and music"));
      }
   }
}

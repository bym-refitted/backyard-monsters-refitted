package com.monsters.display
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   import com.monsters.display.Loadable;
   import flash.events.UncaughtErrorEvent;
   
   public class ImageCache
   {
      
      public static var load:Array;
      
      public static var groups:Object = {};
      
      public static const UNLOADED:uint = 0;
      
      public static const LOADING:uint = 1;
      
      public static const LOADED:uint = 2;
      
      public static const GAVE_UP:uint = 3;
      
      private static var instance:com.monsters.display.ImageCache;
      
      private static var allowInstantiation:Boolean = false;
      
      public static var prependImagePath:String = "";
       
      
      public var queue:Array;
      
      public var cache:Object;
      
      private var concurrentLoadLimit:uint = 20;
      
      private var loadTick:Timer;
      
      public function ImageCache()
      {
         super();
         if(allowInstantiation)
         {
            load = [].concat();
            this.queue = [].concat();
            this.cache = {};
            this.loadTick = new Timer(100);
            this.loadTick.addEventListener(TimerEvent.TIMER,this.checkQueue);
            this.loadTick.start();
            return;
         }
         throw new Error("nice try, sucka\'!");
      }
      
      private static function getInstance() : com.monsters.display.ImageCache
      {
         if(!instance)
         {
            allowInstantiation = true;
            instance = new com.monsters.display.ImageCache();
            allowInstantiation = false;
         }
         return instance;
      }
      
      public static function GetImageGroupWithCallBack(param1:String, param2:Array, param3:Function = null, param4:Boolean = true, param5:int = 4, param6:String = null) : void
      {
         var _loc7_:Object = null;
         var _loc8_:String = null;
         if(!groups[param1])
         {
            groups[param1] = {
               "urls":{},
               "cbfs":[param3]
            };
            for each(_loc8_ in param2)
            {
               groups[param1].urls[_loc8_] = {
                  "loaded":false,
                  "bmd":null,
                  "state":param6
               };
            }
            for each(_loc8_ in param2)
            {
               GetImageWithCallBack(_loc8_,GroupImageLoaded,param4,param5,param1);
            }
         }
         else
         {
            groups[param1].cbfs.push(param3);
            GroupImageLoaded(param1);
         }
      }
      
      public static function GroupImageLoaded(param1:String, param2:String = null, param3:BitmapData = null) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Function = null;
         if(param2)
         {
            (_loc4_ = groups[param1].urls[param2]).loaded = true;
            _loc4_.bmd = param3;
         }
         var _loc6_:Boolean = true;
         for each(_loc4_ in groups[param1].urls)
         {
            if(!_loc4_.loaded)
            {
               _loc6_ = false;
            }
         }
         if(_loc6_)
         {
            _loc7_ = [];
            for(_loc5_ in groups[param1].urls)
            {
               _loc4_ = groups[param1].urls[_loc5_];
               _loc7_.push([_loc5_,_loc4_.bmd]);
            }
            for each(_loc8_ in groups[param1].cbfs)
            {
               _loc8_(_loc7_,_loc4_.state);
            }
            groups[param1].cbfs = [];
         }
      }
      
      public static function ClearCache() : void
      {
         getInstance().cache = {};
      }
      
      public static function GetImageWithCallBack(param1:String, param2:Function = null, param3:Boolean = true, param4:int = 4, param5:String = "", param6:Array = null) : void
      {
         var _loc9_:Loadable = null;
         var _loc10_:Loadable = null;
         var _loc7_:Boolean = false;
         if(getInstance().cache[param1])
         {
            if(param2 != null)
            {
               getInstance().cache[param1].callbacks.push([param2,param5,param6]);
            }
            getInstance().executeAndRemoveCallbacksOnLoadable(getInstance().cache[param1]);
            _loc7_ = true;
         }
         var _loc8_:Boolean = false;
         for each(_loc9_ in getInstance().queue)
         {
            if(_loc9_.key == param1)
            {
               if(param2 != null)
               {
                  _loc9_.callbacks.push([param2,param5,param6]);
               }
               _loc8_ = true;
               break;
            }
         }
         if(!_loc7_ && !_loc8_)
         {
            _loc10_ = new Loadable();
            if(param2 != null)
            {
               if(param2 != null)
               {
                  _loc10_.callbacks.push([param2,param5,param6]);
               }
            }
            _loc10_.shouldPrepend = param3;
            _loc10_.key = param1;
            _loc10_.priority = param4;
            _loc10_.loadState = UNLOADED;
            getInstance().queue.push(_loc10_);
            getInstance().queue.sortOn("priority",Array.NUMERIC);
         }
      }
      
      public static function loadImageAndAddChild(param1:String, param2:DisplayObjectContainer) : void
      {
         GetImageWithCallBack(param1,onImageLoad,true,4,"",[param2]);
      }
      
      private static function onImageLoad(param1:String, param2:BitmapData, param3:Array) : void
      {
         DisplayObjectContainer(param3[0]).addChild(new Bitmap(param2));
      }
      
      private function checkQueue(param1:TimerEvent = null) : void
      {
         var _loc2_:int = 0;
         while(load.length < this.concurrentLoadLimit && this.queue.length != 0)
         {
            _loc2_++;
            this.initLoadable(this.queue.shift());
         }
      }
      
      // Load Dynamic assets
      private function initLoadable(param1:Loadable) : void
      {
         var req_str:String;
         var l:Loadable = param1;
         l.loadState = LOADING;
         req_str = l.shouldPrepend ? prependImagePath + l.key : l.key;
         // Comment: Attempts to load all dynamic assets from the server
         l.loader.load(new URLRequest(req_str));
         LOGGER.DebugQAdd("Fetched asset: ", {url: req_str});
         LOGGER.DebugQPost();
         l.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            onAssetComplete(l);
         });
         l.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
         {
            //Comment: Errors out here
            onError(l);
         });
         //l.loader.uncaughtErrorEvents.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void {});
         l.loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,function(param1:IOErrorEvent):void
         {
            onError(l);
         });
         load.push(l);
      }
      
      private function onError(param1:Loadable) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < load.length)
         {
            if(param1 == load[_loc2_])
            {
               ++param1.tries;
               if(param1.tries < param1.tryLimit)
               {
                  this.queue.push(load.splice(_loc2_,1)[0]);
               }
               else
               {
                  // Comment: Resolves here, gives up.
                  param1.loadState = GAVE_UP;
                  load.splice(_loc2_,1);
                  print("ImageCache.onError Failed" + param1);
               }
               return;
            }
            _loc2_++;
         }
      }
      
      private function onAssetComplete(param1:Loadable) : void
      {
         param1.loadState = LOADED;
         var _loc2_:uint = 0;
         while(_loc2_ < load.length)
         {
            if(param1 == load[_loc2_])
            {
               load.splice(_loc2_,1);
            }
            _loc2_++;
         }
         this.cache[param1.key] = param1;
         this.executeAndRemoveCallbacksOnLoadable(param1);
      }
      
      private function executeAndRemoveCallbacksOnLoadable(param1:Loadable) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Bitmap = null;
         var _loc5_:Function = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc2_:Array = param1.callbacks.concat();
         param1.callbacks = [].concat();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = param1.loader.content as Bitmap;
            _loc5_ = _loc3_[0];
            _loc6_ = String(_loc3_[1]);
            _loc7_ = _loc3_[2];
            if(_loc6_)
            {
               if(_loc7_)
               {
                  _loc5_(_loc6_,param1.key,_loc4_.bitmapData,_loc7_);
               }
               else
               {
                  _loc5_(_loc6_,param1.key,_loc4_.bitmapData);
               }
            }
            else if(_loc7_)
            {
               _loc5_(param1.key,_loc4_.bitmapData,_loc7_);
            }
            else
            {
               _loc5_(param1.key,_loc4_.bitmapData);
            }
         }
      }
   }
}

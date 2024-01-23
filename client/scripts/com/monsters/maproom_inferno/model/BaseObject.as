package com.monsters.maproom_inferno.model
{
   import com.cc.utils.SecNum;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class BaseObject
   {
       
      
      public var baseid:SecNum;
      
      public var attackpermitted:SecNum;
      
      public var seentime:SecNum;
      
      public var friend:SecNum;
      
      public var attacker:String;
      
      public var helpsto:SecNum;
      
      public var baseseed:SecNum;
      
      public var attacksto:SecNum;
      
      public var helpsfrom:SecNum;
      
      public var basename:String;
      
      public var attacksfrom:SecNum;
      
      public var saved:SecNum;
      
      public var online:Boolean;
      
      public var pic:String;
      
      public var ownerName:String;
      
      public var trucestate:String = "";
      
      public var truceexpire:int = 0;
      
      public var userid:SecNum;
      
      public var level:SecNum;
      
      public var wm:SecNum;
      
      public var description:String;
      
      public var type:int;
      
      public var retaliatecount:int;
      
      public var destroyed:int = 0;
      
      private var dsp:EventDispatcher;
      
      public var loader:Loader;
      
      public var loaded:uint = 0;
      
      public function BaseObject(param1:Object)
      {
         super();
         this.level = new SecNum(Number(param1.level));
         this.baseid = new SecNum(Number(param1.baseid));
         this.basename = param1.basename;
         this.ownerName = this.basename.split("\'s")[0];
         this.pic = param1.pic;
         this.dsp = new EventDispatcher();
         if(param1.wm != undefined && param1.wm == 1)
         {
            this.wm = new SecNum(int(param1.wm));
            this.attackpermitted = new SecNum(1);
            this.saved = new SecNum(0);
            this.seentime = new SecNum(0);
            this.friend = new SecNum(0);
            this.trucestate = "";
            this.truceexpire = 0;
            this.description = param1.description;
            this.type = param1.type;
         }
         else
         {
            this.wm = new SecNum(0);
            this.userid = new SecNum(int(param1.userid));
            this.attackpermitted = new SecNum(int(param1.attackpermitted));
            this.friend = new SecNum(int(param1.friend));
            this.attacker = param1.attacker;
            this.helpsto = new SecNum(int(param1.helpsto));
            this.helpsfrom = new SecNum(int(param1.helpsfrom));
            this.baseseed = new SecNum(int(param1.baseseed));
            this.attacksto = new SecNum(int(param1.attacksto));
            this.attacksfrom = new SecNum(int(param1.attacksfrom));
            this.saved = new SecNum(int(param1.saved));
            this.retaliatecount = int(param1.retaliatecount);
            this.seentime = new SecNum(int(param1.saved));
            this.truceexpire = int(param1.truceexpire);
            this.trucestate = param1.trucestate;
         }
         if(param1.destroyed)
         {
            this.destroyed = param1.destroyed;
         }
      }
      
      public function Clear() : void
      {
         this.baseid = null;
         this.attackpermitted = null;
         this.seentime = null;
         this.friend = null;
         this.attacker = null;
         this.helpsto = null;
         this.baseseed = null;
         this.attacksto = null;
         this.helpsfrom = null;
         this.basename = null;
         this.attacksfrom = null;
         this.saved = null;
         this.pic = null;
         this.userid = null;
         this.level = null;
         this.wm = null;
         this.dsp = null;
         this.loader = null;
      }
      
      public function Update(param1:Object) : void
      {
         if(this.wm.Get() == 0)
         {
            this.seentime.Set(param1.saved);
            this.saved.Set(param1.saved);
            this.truceexpire = int(param1.truceexpire);
            this.trucestate = param1.trucestate;
            this.attacksfrom.Set(param1.attacksfrom);
            this.attacker = param1.attacker;
            this.attackpermitted.Set(int(param1.attackpermitted));
            this.friend.Set(int(param1.friend));
            this.dsp.dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this.dsp.addEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.dsp.removeEventListener(param1,param2);
      }
      
      public function loadImage() : void
      {
         var LoadImageError:Function;
         if(!this.loader && this.loaded == 0 && this.pic.length > 5)
         {
            try
            {
               LoadImageError = function(param1:IOErrorEvent):void
               {
               };
               this.loader = new Loader();
               this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imgComplete);
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
               this.loader.load(new URLRequest(this.pic),new LoaderContext(true));
               this.loaded = 1;
            }
            catch(e:*)
            {
            }
         }
         else
         {
            this.dsp.dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function imgComplete(param1:Event) : void
      {
         this.loaded = 2;
         this.dsp.dispatchEvent(param1.clone());
      }
      
      public function toString() : String
      {
         return "[BaseObject name:" + this.basename + " trucestate:" + this.trucestate + "]";
      }
   }
}

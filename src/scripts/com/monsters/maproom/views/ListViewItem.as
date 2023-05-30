package com.monsters.maproom.views
{
   import com.monsters.maproom.MapRoom;
   import com.monsters.maproom.PlayerHandler;
   import com.monsters.maproom.model.BaseObject;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class ListViewItem extends ListViewItem_CLIP
   {
       
      
      private var loaded:Boolean = false;
      
      public var portrait:Bitmap;
      
      public var data:BaseObject;
      
      public var attackStarPoints:Number;
      
      public var helpStarPoints:Number;
      
      public var online:Number;
      
      public var ownerName:String;
      
      public var status:String;
      
      public var level:int;
      
      public var loader:Loader;
      
      public var helpStars:Array;
      
      public var attackStars:Array;
      
      public var handler:PlayerHandler;
      
      public function ListViewItem()
      {
         super();
         truceBtn.SetupKey("map_truce_btn");
         msgBtn.SetupKey("map_message_btn");
         this.loader = new Loader();
      }
      
      public function Display() : void
      {
         var LoadImageError:Function;
         if(!this.loaded)
         {
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageLoaded);
            try
            {
               LoadImageError = function(param1:IOErrorEvent):void
               {
               };
               this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,LoadImageError,false,0,true);
               this.loader.load(new URLRequest(this.data.pic),new LoaderContext(true));
               this.loaded = true;
            }
            catch(e:Error)
            {
               MapRoom.BRIDGE.Log("err","MapRoom ListViewItem Display: " + e.getStackTrace());
            }
         }
      }
      
      private function onImageLoaded(param1:Event) : void
      {
         addChild(this.loader);
         this.loader.x = placeholder.x;
         this.loader.y = placeholder.y;
         this.loader.width = this.loader.height = 50;
      }
      
      public function Setup(param1:BaseObject) : void
      {
         this.data = param1;
         this.handler = new PlayerHandler();
         this.Update();
         param1.addEventListener(Event.CHANGE,this.Update);
      }
      
      public function Update(param1:Event = null) : void
      {
         var _loc2_:Object = this.handler.configure(this);
         name_txt.htmlText = "<b>" + this.data.ownerName;
         userid_txt.text = KEYS.Get("label_userid",{"v1":this.data.userid.Get()});
         online_txt.text = "";
         if(this.data.saved.Get() >= MapRoom.BRIDGE.Timestamp() - 62)
         {
            dot.gotoAndStop(2);
         }
         else
         {
            dot.gotoAndStop(1);
         }
         this.ownerName = this.data.ownerName;
         this.online = this.data.saved.Get();
         this.attackStarPoints = this.data.attacksto.Get() + this.data.attacksfrom.Get();
         this.helpStarPoints = this.data.helpsto.Get() + this.data.helpsfrom.Get();
         this.status = _loc2_.relation;
         this.level = this.data.level.Get();
         var _loc3_:Array = [1,10,85,200];
         var _loc4_:String = this.attackStarPoints == 0 ? "#666666" : "#990000";
         var _loc5_:String = this.attackStarPoints == 1 ? "map_battle" : "map_battles";
         this.attacks_txt.htmlText = "<font color=\'" + _loc4_ + "\'>" + MapRoom.BRIDGE.KEYS.Get(_loc5_,{"v1":this.attackStarPoints});
         this.status_txt.htmlText = "<font color=\'" + _loc2_.relationColor + "\'>" + _loc2_.relation;
         this.extraStatus_txt.htmlText = "<b><font color=\'" + _loc2_.extraStatusColor + "\'>" + _loc2_.extraStatus;
         this.levelStar.lv_txt.htmlText = "<b>" + this.level;
      }
      
      private function setStars(param1:*, param2:Array, param3:Array) : void
      {
         var _loc4_:uint = 0;
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            if(param1 < param2[_loc4_])
            {
               break;
            }
            _loc4_++;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < param3.length)
         {
            if(_loc5_ < _loc4_)
            {
               param3[_loc5_].gotoAndStop(1);
            }
            else
            {
               param3[_loc5_].gotoAndStop(2);
            }
            _loc5_++;
         }
      }
   }
}

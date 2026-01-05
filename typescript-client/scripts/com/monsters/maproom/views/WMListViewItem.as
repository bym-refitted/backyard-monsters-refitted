package com.monsters.maproom.views
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom.MapRoom;
   import com.monsters.maproom.PlayerHandler;
   import com.monsters.maproom.model.BaseObject;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   
   public class WMListViewItem extends WMListViewItem_CLIP
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
      
      public function WMListViewItem()
      {
         super();
         removeChild(dot);
         removeChild(attacks_txt);
         removeChild(status_txt);
         removeChild(extraStatus_txt);
      }
      
      public function Display() : void
      {
         if(!this.loaded)
         {
            try
            {
               ImageCache.GetImageWithCallBack(this.data.pic,this.onImageLoaded);
               this.loaded = true;
            }
            catch(e:Error)
            {
               MapRoom.BRIDGE.Log("err","MapRoom WMListViewItem Display: " + e.getStackTrace());
            }
         }
      }
      
      private function onImageLoaded(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = null;
         _loc3_ = new Bitmap(param2);
         addChild(_loc3_);
         _loc3_.x = placeholder.x;
         _loc3_.y = placeholder.y;
         _loc3_.width = _loc3_.height = 50;
      }
      
      public function Setup(param1:BaseObject) : void
      {
         this.data = param1;
         this.handler = new PlayerHandler();
         this.Update();
      }
      
      public function Update(... rest) : void
      {
         var _loc2_:Object = this.handler.configure(this);
         name_txt.htmlText = "<b>" + this.data.ownerName;
         this.ownerName = this.data.ownerName;
         this.online = 0;
         this.attackStarPoints = 5;
         this.helpStarPoints = 0;
         this.status = "enemy";
         this.level = this.data.level.Get();
         var _loc3_:Array = [1,10,85,200];
      }
   }
}

package com.monsters.maproom.views
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import gs.TweenLite;
   import gs.easing.Quad;
   
   public class MapView extends MapView_CLIP
   {
      
      private static var instance:MapView;
       
      
      public var map:Sprite;
      
      public var shell:Sprite;
      
      public var shell_mask:Sprite;
      
      public var map_mc:MovieClip;
      
      public var miniMap:MiniMap;
      
      public var players:PlayerLayer;
      
      private var dragPoint:Point;
      
      private var bounds:Rectangle;
      
      public var displayBounds:Rectangle;
      
      public var hardBounds:Rectangle;
      
      private var updateTimer:Timer;
      
      private var throwDrag:Number = 0.28;
      
      private var dragging:Boolean;
      
      public var bases:Array;
      
      public var gotFirstData:Boolean = false;
      
      public function MapView()
      {
         super();
         instance = this;
         this.bases = [].concat();
      }
      
      public static function getInstance() : MapView
      {
         if(!instance)
         {
            return new MapView();
         }
         return instance;
      }
      
      public function Clear() : void
      {
         TweenLite.killTweensOf(this.shell);
         if(Boolean(this.shell) && Boolean(this.shell.parent))
         {
            this.shell.parent.removeChild(this.shell);
         }
         this.shell = null;
         if(Boolean(this.map_mc) && Boolean(this.map_mc.parent))
         {
            this.map_mc.parent.removeChild(this.map_mc);
         }
         this.map_mc = null;
         if(Boolean(this.miniMap) && Boolean(this.miniMap.parent))
         {
            this.miniMap.parent.removeChild(this.miniMap);
         }
         this.miniMap.Clear();
         this.miniMap = null;
         this.shell = null;
         this.map = null;
         this.players.Clear();
         if(Boolean(this.players) && Boolean(this.players.parent))
         {
            this.players.parent.removeChild(this.players);
         }
         this.players = null;
         instance = null;
      }
      
      public function Setup() : void
      {
         var i:int;
         var imageLoaded:Function = null;
         imageLoaded = function(param1:String, param2:BitmapData):void
         {
            var key:String = param1;
            var bmd:BitmapData = param2;
            try
            {
               map_mc.addChild(new Bitmap(bmd));
            }
            catch(e:Error)
            {
            }
         };
         this.bounds = new Rectangle(0,0,-1760,-1760);
         this.displayBounds = new Rectangle(mask_mc.x,mask_mc.y,mask_mc.width,mask_mc.height);
         this.hardBounds = new Rectangle(mask_mc.x,mask_mc.y,-1760 + mask_mc.width + mask_mc.x,-1760 + mask_mc.height + mask_mc.y);
         this.shell = new Sprite();
         addChild(this.shell);
         this.shell_mask = new Sprite();
         this.shell_mask.graphics.lineStyle(1,0);
         this.shell_mask.graphics.beginFill(16711935);
         this.shell_mask.graphics.drawRect(0,0,700,385);
         this.shell_mask.graphics.endFill();
         addChild(this.shell_mask);
         this.map_mc = new map_bg_inferno();
         Obstruction.Clear();
         i = 1;
         while(i < this.map_mc.numChildren)
         {
            Obstruction.Register(this.map_mc.getChildAt(i));
            this.map_mc.getChildAt(i).visible = false;
            i++;
         }
         ImageCache.GetImageWithCallBack("ui/map.v1.jpg",imageLoaded,true,1);
         this.map = new Sprite();
         this.map.addChild(this.map_mc);
         this.shell.addChild(this.map);
         this.shell.mask = this.shell_mask;
         mask_mc.visible = false;
         this.players.mapWidth = Math.abs(this.bounds.width + 260);
         this.players.addEventListener("down",this.onBaseDown,false,0,true);
         this.players.addEventListener(Event.COMPLETE,this.onPlayersData,false,0,true);
         this.shell.addChild(this.players);
         this.map.addEventListener(MouseEvent.MOUSE_DOWN,this.shellDown);
         this.scrollTo(0.5,0.5);
         this.miniMap = MiniMap.getInstance();
         this.miniMap.selectorSize = new Rectangle(0,0,529,393);
         this.miniMap.mapSize = new Rectangle(this.displayBounds.x,this.displayBounds.y,1760,1760);
         this.miniMap.x = 583;
         this.miniMap.y = 8;
         this.miniMap.Setup();
         this.miniMap.dragCallBack = this.scrollTo;
         addChild(this.miniMap);
         this.miniMap.drawPlayerAt(this.players.player.x,this.players.player.y);
      }
      
      public function onAdd() : void
      {
         if(TUTORIAL._stage < 130)
         {
            this.scrollToBase(this.players.basesWM[0]);
         }
         else
         {
            this.scrollToBase(this.players.player);
         }
      }
      
      private function onPlayersData(param1:Event) : void
      {
         if(!this.gotFirstData)
         {
            if(MapRoom.BRIDGE.TUTORIAL._stage < 130)
            {
               this.scrollToBase(this.players.basesWM[0]);
            }
            else
            {
               this.scrollToBase(this.players.player);
            }
            this.gotFirstData = true;
         }
      }
      
      private function onBaseDown(param1:Event) : void
      {
      }
      
      private function scrollToBase(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = -(param1.x - this.displayBounds.x) + this.displayBounds.width * 0.5;
            _loc3_ = -(param1.y - this.displayBounds.y) + this.displayBounds.height * 0.5;
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = 0;
         }
         _loc3_ -= 30;
         var _loc4_:Rectangle = new Rectangle(this.displayBounds.x,this.displayBounds.y,this.displayBounds.x + this.bounds.width + this.displayBounds.width,this.displayBounds.y + this.bounds.height + this.displayBounds.height);
         if(_loc2_ > _loc4_.x)
         {
            _loc2_ = _loc4_.x;
         }
         if(_loc2_ < _loc4_.width)
         {
            _loc2_ = _loc4_.width;
         }
         if(_loc3_ > _loc4_.y)
         {
            _loc3_ = _loc4_.y;
         }
         if(_loc3_ < _loc4_.height)
         {
            _loc3_ = _loc4_.height;
         }
         if(param1 is ForeignBase)
         {
            MiniMap.getInstance().highlightBase(param1);
         }
         TweenLite.to(this.shell,0.5,{
            "x":_loc2_,
            "y":_loc3_,
            "ease":Quad.easeOut,
            "onUpdate":this.baseScrollUpdate
         });
      }
      
      public function scrollToBaseId(param1:Number) : void
      {
         var _loc2_:ForeignBase = null;
         for each(_loc2_ in this.players.basesForeign)
         {
            if(_loc2_.data.baseid.Get() == param1)
            {
               this.scrollToBase(_loc2_);
               return;
            }
         }
      }
      
      private function baseScrollUpdate() : void
      {
         var _loc1_:Number = (this.shell.x - this.displayBounds.x) / (this.bounds.width + this.displayBounds.width);
         var _loc2_:Number = (this.shell.y - this.displayBounds.y) / (this.bounds.height + this.displayBounds.height);
         MiniMap.getInstance().scrollTo(_loc1_,_loc2_);
      }
      
      private function shellDown(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.shell,false);
         if(TUTORIAL._stage < 110)
         {
            return;
         }
         this.dragging = true;
         this.dragPoint = new Point(stage.mouseX - this.shell.x,stage.mouseY - this.shell.y);
         addEventListener(Event.ENTER_FRAME,this.shellDrag,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stageUp,false,0,true);
      }
      
      public function scrollTo(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         if(!param3)
         {
            if(param1 > 1)
            {
               param1 = 1;
            }
            if(param1 < 0)
            {
               param1 = 0;
            }
            if(param2 > 1)
            {
               param2 = 1;
            }
            if(param2 < 0)
            {
               param2 = 0;
            }
         }
         this.shell.x = this.displayBounds.x + int(param1 * (this.bounds.width + this.displayBounds.width));
         this.shell.y = this.displayBounds.y + int(param2 * (this.bounds.height + this.displayBounds.height));
      }
      
      public function Tick() : void
      {
         this.players.Tick();
      }
      
      public function Get() : void
      {
         this.players.Get();
      }
      
      public function Hide(... rest) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageUp);
      }
      
      private function stageUp(param1:MouseEvent) : void
      {
         if(!this.dragging)
         {
            return;
         }
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stageUp,false,0,true);
         removeEventListener(Event.ENTER_FRAME,this.shellDrag);
         var _loc2_:Boolean = false;
         var _loc3_:int = this.shell.x;
         var _loc4_:int = this.shell.y;
         var _loc5_:Rectangle = new Rectangle(this.displayBounds.x,this.displayBounds.y,this.displayBounds.x + this.bounds.width + this.displayBounds.width,this.displayBounds.y + this.bounds.height + this.displayBounds.height);
         if(this.shell.x > _loc5_.x)
         {
            _loc3_ = _loc5_.x;
            _loc2_ = true;
         }
         if(this.shell.x < _loc5_.width)
         {
            _loc3_ = _loc5_.width;
            _loc2_ = true;
         }
         if(this.shell.y > _loc5_.y)
         {
            _loc4_ = _loc5_.y;
            _loc2_ = true;
         }
         if(this.shell.y < _loc5_.height)
         {
            _loc4_ = _loc5_.height;
            _loc2_ = true;
         }
         this.dragging = false;
         if(_loc2_)
         {
         }
      }
      
      private function shellDrag(param1:Event) : void
      {
         var _loc2_:int = int(stage.mouseX - this.dragPoint.x);
         var _loc3_:int = int(stage.mouseY - this.dragPoint.y);
         if(_loc2_ > this.hardBounds.x)
         {
            _loc2_ = this.hardBounds.x;
         }
         if(_loc3_ > this.hardBounds.y)
         {
            _loc3_ = this.hardBounds.y;
         }
         if(_loc2_ < this.hardBounds.width)
         {
            _loc2_ = this.hardBounds.width;
         }
         if(_loc3_ < this.hardBounds.height)
         {
            _loc3_ = this.hardBounds.height;
         }
         var _loc4_:Number = this.shell.x - (this.shell.x - _loc2_) * this.throwDrag;
         var _loc5_:Number = this.shell.y - (this.shell.y - _loc3_) * this.throwDrag;
         var _loc6_:Number = (_loc4_ - this.displayBounds.x) / (this.bounds.width + this.displayBounds.width);
         var _loc7_:Number = (_loc5_ - this.displayBounds.y) / (this.bounds.height + this.displayBounds.height);
         MiniMap.getInstance().scrollTo(_loc6_,_loc7_);
         this.scrollTo(_loc6_,_loc7_,true);
      }
   }
}

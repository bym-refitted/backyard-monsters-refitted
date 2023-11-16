package com.monsters.maproom
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import gs.TweenLite;
   
   public class MiniMap extends MiniMap_CLIP
   {
      
      private static var instance:MiniMap;
      
      private static const COLOR1:uint = 65280;
      
      private static const COLOR2:uint = 16776960;
      
      private static const COLOR3:uint = 16750848;
      
      private static const COLOR4:uint = 16711680;
       
      
      public var playerLayer:PlayerLayer;
      
      public var largeMap:MapRoom;
      
      public var selector:Sprite;
      
      public var selectorSize:Rectangle;
      
      public var players:Sprite;
      
      public var ai:Sprite;
      
      public var mapSize:Rectangle;
      
      public var dragCallBack:Function;
      
      private var dragFriction:Number = 0.7;
      
      private var playerDot:Sprite;
      
      private var rings:Sprite;
      
      public var pctX:Number;
      
      public var pctY:Number;
      
      public function MiniMap()
      {
         super();
      }
      
      public static function getInstance() : MiniMap
      {
         if(!instance)
         {
            instance = new MiniMap();
         }
         return instance;
      }
      
      public function Setup() : void
      {
         var _loc1_:Number = background_mc.width / this.mapSize.width;
         this.players = new Sprite();
         addChild(this.players);
         this.ai = new Sprite();
         addChild(this.ai);
         this.playerDot = new Sprite();
         addChild(this.playerDot);
         this.rings = new Sprite();
         addChild(this.rings);
         this.selector = new Sprite();
         this.selector.graphics.lineStyle(1,16777215,1,false);
         this.selector.graphics.beginFill(16777215,0.5);
         this.selector.graphics.drawRect(0,0,this.selectorSize.width * _loc1_,this.selectorSize.height * _loc1_);
         this.selector.graphics.endFill();
         this.selector.buttonMode = true;
         addChild(this.selector);
         this.selector.addEventListener(MouseEvent.MOUSE_DOWN,this.selectorDown);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.mapDown);
      }
      
      public function Clear() : void
      {
         instance = null;
         this.playerLayer = null;
      }
      
      private function mapDown(param1:MouseEvent) : void
      {
         var reposition:Function;
         var tx:Number = NaN;
         var ty:Number = NaN;
         var t:TweenLite = null;
         var e:MouseEvent = param1;
         if(TUTORIAL._stage < 110)
         {
            return;
         }
         if(e.target != this.selector)
         {
            reposition = function():void
            {
               scrollTo(pctX,pctY);
               dragCallBack(pctX,pctY);
            };
            tx = e.localX / background_mc.width;
            ty = e.localY / background_mc.height;
            TweenLite.to(this,0.3,{
               "pctX":tx,
               "pctY":ty,
               "onUpdate":reposition
            });
         }
      }
      
      public function drawPlayerAt(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = background_mc.width / this.mapSize.width;
         this.playerDot.graphics.clear();
         this.playerDot.graphics.beginFill(COLOR2,1);
         this.playerDot.graphics.drawEllipse(param1 * _loc3_,param2 * _loc3_,5,5);
         this.playerDot.graphics.endFill();
      }
      
      private function selectorDown(param1:MouseEvent) : void
      {
         if(TUTORIAL._stage < 110)
         {
            return;
         }
         var _loc2_:Rectangle = new Rectangle(background_mc.x,background_mc.y,background_mc.width - this.selector.width + 1,background_mc.height - this.selector.height + 1);
         this.selector.startDrag(false,_loc2_);
         addEventListener(Event.ENTER_FRAME,this.onSelectorDragged);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
      }
      
      private function onSelectorDragged(param1:Event) : void
      {
         this.pctX = this.selector.x / (background_mc.width - this.selector.width);
         this.pctY = this.selector.y / (background_mc.height - this.selector.height);
         this.dragCallBack(this.pctX,this.pctY);
      }
      
      private function onStageUp(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onSelectorDragged);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageUp);
         this.selector.stopDrag();
      }
      
      public function scrollTo(param1:Number, param2:Number) : void
      {
         this.pctX = param1;
         this.pctY = param2;
         if(this.pctX < 0)
         {
            this.pctX = 0;
         }
         if(this.pctX > 1)
         {
            this.pctX = 1;
         }
         if(this.pctY < 0)
         {
            this.pctY = 0;
         }
         if(this.pctY > 1)
         {
            this.pctY = 1;
         }
         this.selector.x = background_mc.x + this.pctX * (background_mc.width - this.selector.width);
         this.selector.y = background_mc.y + this.pctY * (background_mc.height - this.selector.height);
      }
      
      public function highlightBase(param1:ForeignBase) : void
      {
         var _loc2_:Number = background_mc.width / this.mapSize.width;
         var _loc3_:int = param1.x * _loc2_ - 0.5;
         var _loc4_:int = param1.y * _loc2_ - 0.5;
         Ring.MakeRings(3,1.5,this.rings,_loc3_,_loc4_,40,1,3,this.colorForBase(param1));
      }
      
      public function Update(param1:Array, param2:Array) : void
      {
         var _loc4_:ForeignBase = null;
         var _loc5_:WildMonsterBase = null;
         var _loc3_:Number = background_mc.width / this.mapSize.width;
         this.players.cacheAsBitmap = false;
         this.players.graphics.clear();
         for each(_loc4_ in param1)
         {
            this.dotAt(_loc4_.x * _loc3_,_loc4_.y * _loc3_,this.colorForBase(_loc4_),this.players);
         }
         this.players.cacheAsBitmap = true;
         this.ai.cacheAsBitmap = false;
         this.ai.graphics.clear();
         for each(_loc5_ in param2)
         {
            this.dotAt(_loc5_.x * _loc3_,_loc5_.y * _loc3_,16711680,this.ai);
         }
         this.ai.cacheAsBitmap = true;
      }
      
      private function colorForBase(param1:ForeignBase) : uint
      {
         var _loc2_:uint = 0;
         if(param1.data.friend.Get() == 1)
         {
            _loc2_ = COLOR1;
         }
         else
         {
            _loc2_ = COLOR3;
         }
         return _loc2_;
      }
      
      private function dotAt(param1:Number, param2:Number, param3:uint, param4:Sprite) : void
      {
         var _loc5_:Number = background_mc.width / this.mapSize.width;
         param4.graphics.beginFill(param3);
         param4.graphics.drawRect(param1 - 2,param2 - 2,3,3);
         param4.graphics.endFill();
      }
   }
}

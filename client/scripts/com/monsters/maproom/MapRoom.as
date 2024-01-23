package com.monsters.maproom
{
   import com.monsters.maproom.views.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapRoom extends old_maproom
   {
      
      public static var top:Sprite;
      
      public static var _useMailBoxForTruces:Boolean = true;
      
      public static var currentView:MovieClip;
      
      public static var BRIDGE:Object = {};
       
      
      public var players:PlayerLayer;
      
      public var miniMap:MiniMap;
      
      public var mv:MapView;
      
      public var lv:ListView;
      
      private var firstRun:Boolean = true;
      
      public var _tutorialModeThresh:int = 130;
      
      public function MapRoom()
      {
         super();
      }
      
      public function init(param1:Object) : void
      {
         BRIDGE = param1;
         this.Setup();
         this.players.Get();
      }
      
      public function Setup() : void
      {
         this.x = 0;
         this.y = 20;
         top = new Sprite();
         top.addChild(mvBtn);
         top.addChild(lvBtn);
         addChild(top);
         this.players = new PlayerLayer();
         if(BRIDGE.TUTORIAL._stage < this._tutorialModeThresh)
         {
            this.players._wmbToDisplay = 1;
            this.players._playersLimit = 0;
         }
         this.players.addEventListener(Event.COMPLETE,this.onPlayersFirstLoad);
         mvBtn.SetupKey("map_map_btn");
         lvBtn.SetupKey("map_list_btn");
         mvBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.mvBtnDown);
         lvBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.lvBtnDown);
         this.mv = MapView.getInstance();
         this.mv.players = this.players;
         this.mv.Setup();
         this.lv = new ListView();
         this.lv.players = this.players;
         this.lv.Setup();
         PushPin.Setup();
      }
      
      private function onPlayersFirstLoad(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(BRIDGE)
         {
            BRIDGE.readyFunction();
         }
         this.players.removeEventListener(Event.COMPLETE,this.onPlayersFirstLoad);
         if(BRIDGE.scrollToBaseID != 0)
         {
            this.mvBtnDown();
            this.mv.scrollToBaseId(BRIDGE.scrollToBaseID);
         }
         else
         {
            _loc2_ = BRIDGE.TUTORIAL._stage <= this._tutorialModeThresh ? 0 : int(BRIDGE._lastView);
            _loc3_ = [this.mvBtnDown,this.lvBtnDown];
            _loc3_[_loc2_]();
         }
      }
      
      private function mvBtnDown(param1:MouseEvent = null) : void
      {
         this.setView(this.mv);
         mvBtn.Highlight = true;
         lvBtn.Highlight = false;
      }
      
      private function lvBtnDown(param1:MouseEvent = null) : void
      {
         if(TUTORIAL._stage < 110)
         {
            return;
         }
         this.setView(this.lv);
         lvBtn.Highlight = true;
         mvBtn.Highlight = false;
      }
      
      public function setView(param1:MovieClip) : void
      {
         if(!this.firstRun)
         {
            MapRoom.BRIDGE.SOUNDS.Play("click1");
         }
         if(Boolean(currentView) && Boolean(currentView.parent))
         {
            currentView.parent.removeChild(currentView);
            currentView = null;
         }
         currentView = param1;
         mcHolder.addChild(currentView);
         if(currentView == this.mv)
         {
            this.mv.onAdd();
         }
         setChildIndex(top,this.numChildren - 1);
         var _loc2_:int = param1 == this.mv ? 0 : 1;
         BRIDGE.setLastView(_loc2_);
         this.firstRun = false;
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
         var _loc2_:Function = null;
         if(BRIDGE.Hide)
         {
            Obstruction.Clear();
            this.mv.Clear();
            this.players = null;
            this.lv.Clear();
            _loc2_ = BRIDGE.Hide;
            BRIDGE = null;
            _loc2_();
            _loc2_ = null;
         }
      }
      
      public function Resize() : void
      {
         this.x = 0;
         this.y = 20;
      }
   }
}

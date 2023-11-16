package com.monsters.maproom_inferno
{
   import com.monsters.maproom_inferno.views.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DescentMapRoom extends MapRoomPopup_InfernoDescent
   {
      
      public static var top:Sprite;
      
      public static var _useMailBoxForTruces:Boolean = true;
      
      public static var currentView:MovieClip;
      
      public static var BRIDGE:Object = {};
       
      
      public var players:DescentLayer;
      
      public var miniMap:MiniMap;
      
      public var dv:DescentView;
      
      private var firstRun:Boolean = true;
      
      public var _tutorialModeThresh:int = 130;
      
      public function DescentMapRoom()
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
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y + 20;
         top = new Sprite();
         top.addChild(bReturn);
         addChild(top);
         this.players = new DescentLayer();
         if(BRIDGE.TUTORIAL._stage < this._tutorialModeThresh)
         {
            this.players._wmbToDisplay = 1;
            this.players._playersLimit = 0;
         }
         this.players.addEventListener(Event.COMPLETE,this.onPlayersFirstLoad);
         bReturn.SetupKey("btn_returnhome");
         bReturn.addEventListener(MouseEvent.MOUSE_DOWN,this.rtBtnDown);
         this.dv = DescentView.getInstance();
         this.dv.players = this.players;
         this.dv.Setup();
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
            this.dv.scrollToBaseId(BRIDGE.scrollToBaseID);
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
         this.setView(this.dv);
      }
      
      private function lvBtnDown(param1:MouseEvent = null) : void
      {
      }
      
      private function rtBtnDown(param1:MouseEvent = null) : void
      {
         this.Hide();
      }
      
      public function setView(param1:MovieClip) : void
      {
         if(!this.firstRun)
         {
            SOUNDS.Play("click1");
         }
         if(Boolean(currentView) && Boolean(currentView.parent))
         {
            currentView.parent.removeChild(currentView);
            currentView = null;
         }
         currentView = param1;
         mcImage.addChild(currentView);
         if(currentView == this.dv)
         {
            this.dv.onAdd();
         }
         setChildIndex(top,this.numChildren - 1);
         var _loc2_:int = param1 == this.dv ? 0 : 1;
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
         if(BRIDGE.Hide)
         {
            Obstruction.Clear();
            this.dv.Clear();
            this.players = null;
            BRIDGE.Hide();
            BRIDGE = null;
         }
      }
      
      public function Resize() : void
      {
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y + 20;
      }
   }
}

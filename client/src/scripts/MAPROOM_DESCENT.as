package
{
   import com.monsters.ai.*;
   import com.monsters.mailbox.Message;
   import com.monsters.maproom_inferno.DescentMapRoom;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import com.brokenfunction.json.encodeJson;
   
   public class MAPROOM_DESCENT
   {
      
      public static var _mc:DescentMapRoom;
      
      public static var _open:Boolean;
      
      public static var _inDescent:Boolean = false;
      
      public static var _descentLvl:int = 0;
      
      public static const _descentLvlMax:int = 8;
      
      public static var _bases:Array = [];
      
      public static var _loot:Object;
      
      public static var _lastView:int = 0;
      
      public static var _lastSort:int = 3;
      
      public static var _lastSortReversed:int = 0;
      
      public static var _visitingFriend:Boolean = false;
      
      private static var loadState:int;
      
      private static var andShow:Boolean = true;
      
      private static var loadThenShow:Boolean = false;
      
      private static var bridge_obj:Object;
      
      public static var DEBUG_UNLOCKDESCENT:Boolean = false;
      
      public static var _descentTribe:Object = {
         "id":1,
         "name":KEYS.Get("ai_descenttribe_name"),
         "process":PROCESS7,
         "type":WMATTACK.TYPE_NERD,
         "taunt":KEYS.Get("ai_descenttribe_taunt"),
         "splash":"popups/portrait_moloch.png",
         "description":KEYS.Get("ai_descenttribe_description"),
         "succ":KEYS.Get("ai_descenttribe_succ"),
         "succ_stream":KEYS.Get("ai_descenttribe_succstream"),
         "fail":KEYS.Get("ai_descenttribe_fail"),
         "profilepic":"monsters/tribe_dreadnaut_50.v2.jpg",
         "streampostpic":"tribe-dreadnaut.v2.png"
      };
      
      public static var _initialized:Boolean = false;
      
      public static var _initing:Boolean = false;
       
      
      public function MAPROOM_DESCENT()
      {
         super();
      }
      
      public static function Setup(param1:Boolean = false) : void
      {
         _mc = null;
         loadState = 0;
         _open = false;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _visitingFriend = false;
            _descentLvl = GLOBAL.StatGet("descentLvl");
            _inDescent = _descentLvl < _descentLvlMax ? true : false;
            _loot = {};
            bridge_obj = {
               "Timestamp":GLOBAL.Timestamp,
               "GLOBAL":GLOBAL,
               "BASE":BASE,
               "readyFunction":onMapRoomReady,
               "ErrorMessage":GLOBAL.ErrorMessage,
               "Log":LOGGER.Log,
               "URLLoaderApi":URLLoaderApi,
               "Hide":Hide,
               "truceShareHandler":TruceSent,
               "Log":LOGGER.Log,
               "playerBaseID":BASE._loadedBaseID,
               "playerBaseSeed":BASE._baseSeed,
               "_playerName":LOGIN._playerName,
               "_playerPic":LOGIN._playerPic,
               "LoadBase":BASE.LoadBase,
               "MessageUI":Message,
               "HOUSING":HOUSING,
               "RequestTruce":RequestTruce,
               "TruceSent":TruceSent,
               "setLastView":setLastView,
               "setLastSort":setLastSort,
               "setLastSortReversed":setLastSortReversed,
               "setVisitingFriend":setVisitingFriend,
               "SOUNDS":SOUNDS,
               "BaseLevel":BASE.BaseLevel,
               "scrollToBaseID":0,
               "TUTORIAL":TUTORIAL,
               "WMBASE":WMBASE,
               "TRIBES":TRIBES,
               "KEYS":KEYS,
               "MAPROOM":MAPROOM_DESCENT
            };
            _initing = true;
            if(param1)
            {
               loadThenShow = true;
            }
            INFERNOAPI.LoadInfernoData(GLOBAL._infBaseURL,0,0,"idescent");
            INFERNOAPI.addEventListener(INFERNOAPI.EVENT_DESCENTLOADED,DescentDataLoaded,false,0,true);
         }
      }
      
      private static function DescentDataLoaded(param1:Event = null) : void
      {
         INFERNOAPI.removeEventListener(INFERNOAPI.EVENT_DESCENTLOADED,DescentDataLoaded);
         _initialized = true;
         _initing = false;
         if(DescentLevel >= _descentLvlMax && DescentPassed)
         {
            INFERNOPORTAL.ToggleYard();
            return;
         }
         if(loadThenShow)
         {
            Show();
         }
      }
      
      public static function Show(param1:MouseEvent = null) : void
      {
         if(!_initialized)
         {
            return;
         }
         bridge_obj._lastView = _lastView;
         bridge_obj._lastSort = _lastSort;
         bridge_obj._lastSortReversed = _lastSortReversed;
         andShow = true;
         GLOBAL.BlockerAdd();
         SOUNDS.Play("click1");
         _open = true;
         EnterDescent();
         if(loadState != 2 && loadState != 1)
         {
            _mc = new DescentMapRoom();
            _mc.init(bridge_obj);
            GLOBAL._layerTop.addChild(_mc);
         }
         else if(loadState == 2)
         {
            ShowB();
         }
      }
      
      private static function ShowB() : void
      {
         andShow = false;
         GLOBAL._layerWindows.addChild(_mc);
         GLOBAL.WaitHide();
      }
      
      public static function EnterDescent() : void
      {
         if(!_inDescent)
         {
            _inDescent = true;
         }
      }
      
      public static function ExitDescent() : void
      {
         if(_inDescent)
         {
            if(BASE.isInfernoMainYardOrOutpost)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.IWMATTACK)
               {
               }
            }
         }
      }
      
      private static function mapRoomProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesLoaded / param1.bytesTotal * 100;
         PLEASEWAIT.MessageChange(_loc2_ + "%");
      }
      
      private static function onMapRoomReady() : void
      {
         loadState = 2;
         if(andShow)
         {
            ShowB();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         try
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            if(Boolean(_mc) && Boolean(_mc.parent))
            {
               _mc.parent.removeChild(_mc);
            }
            _open = false;
            ExitDescent();
            _mc = null;
            loadState = 0;
            if(_initialized)
            {
               INFERNOAPI.RevertWmBases();
               _initialized = false;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function Tick() : void
      {
         if(Boolean(_mc) && Boolean(_mc.parent))
         {
            _mc.Tick();
         }
      }
      
      public static function RequestTruce(param1:String, param2:int) : void
      {
         var mc:MovieClip = null;
         var Truce:Function = null;
         var name:String = param1;
         var baseid:int = param2;
         Truce = function(param1:MouseEvent = null):void
         {
            var handleLoadSuccessful:Function = null;
            var e:MouseEvent = param1;
            handleLoadSuccessful = function(param1:Object):void
            {
               if(param1.error == 0)
               {
                  if(_mc)
                  {
                     _mc.Get();
                  }
               }
               else
               {
                  LOGGER.Log("err","MAPROOM.RequestTruce: " + encodeJson(param1));
               }
            };
            new URLLoaderApi().load(GLOBAL._apiURL + "player/requesttruce",[["baseid",baseid],["duration",1209600],["message",mc.bMessage.text]],handleLoadSuccessful);
            POPUPS.Next();
            TruceSent(name,mc.bMessage.text);
         };
         mc = new popup_truce();
         mc.tA.htmlText = "<b>" + KEYS.Get("map_trucerequest") + " " + name + ".</b>";
         mc.tB.htmlText = KEYS.Get("map_trucerequest_desc");
         mc.bSend.SetupKey("map_trucereq_btn");
         mc.bSend.addEventListener(MouseEvent.CLICK,Truce);
         mc.bMessage.htmlText = "";
         POPUPS.Push(mc);
      }
      
      public static function TruceAccepted(param1:String, param2:String) : void
      {
         var mc:MovieClip = null;
         var i:int = 0;
         var Share:Function = null;
         var imgNumber:int = 0;
         var name:String = param1;
         var message:String = param2;
         Share = function(param1:MouseEvent = null):void
         {
            GLOBAL.CallJS("sendFeed",["Truce",KEYS.Get("map_truceaccept_streamtitle",{"v1":name}),KEYS.Get("map_truceaccept_streambody"),"truceaccept" + imgNumber + ".png",0]);
            POPUPS.Next();
         };
         var Switch:Function = function(param1:int):Function
         {
            var n:int = param1;
            return function(param1:MouseEvent = null):void
            {
               SwitchB(n);
            };
         };
         var SwitchB:Function = function(param1:int):void
         {
            imgNumber = param1;
            i = 1;
            while(i < 4)
            {
               mc["mcIcon" + i].alpha = 0.4;
               ++i;
            }
            mc["mcIcon" + param1].alpha = 1;
         };
         mc = new popup_truce_accept();
         mc.bShare.SetupKey("btn_share");
         mc.bShare.addEventListener(MouseEvent.CLICK,Share);
         mc.bShare.Highlight = true;
         mc.tTitle.htmlText = KEYS.Get("popup_desc_truceaccept");
         i = 1;
         while(i < 4)
         {
            mc["mcIcon" + i].buttonMode = true;
            mc["mcIcon" + i].gotoAndStop(i + 3);
            mc["mcIcon" + i].addEventListener(MouseEvent.CLICK,Switch(i));
            i++;
         }
         POPUPS.Push(mc);
         SwitchB(1);
      }
      
      public static function TruceSent(param1:String, param2:String) : void
      {
         var mc:MovieClip = null;
         var i:int = 0;
         var Share:Function = null;
         var imgNumber:int = 0;
         var name:String = param1;
         var message:String = param2;
         Share = function(param1:MouseEvent = null):void
         {
            GLOBAL.CallJS("sendFeed",["Truce",KEYS.Get("map_truceproposed_streamtitle",{"v1":name}),KEYS.Get("map_truceproposed_streambody"),"truceaccept" + imgNumber + ".png",0]);
            POPUPS.Next();
         };
         var Switch:Function = function(param1:int):Function
         {
            var n:int = param1;
            return function(param1:MouseEvent = null):void
            {
               SwitchB(n);
            };
         };
         var SwitchB:Function = function(param1:int):void
         {
            imgNumber = param1;
            i = 1;
            while(i < 4)
            {
               mc["mcIcon" + i].alpha = 0.4;
               ++i;
            }
            mc["mcIcon" + param1].alpha = 1;
         };
         mc = new popup_truce_sent();
         mc.bShare.SetupKey("btn_share");
         mc.bShare.addEventListener(MouseEvent.CLICK,Share);
         mc.bShare.Highlight = true;
         mc.tTitle.htmlText = KEYS.Get("popup_desc_trucesent");
         i = 1;
         while(i < 4)
         {
            mc["mcIcon" + i].buttonMode = true;
            mc["mcIcon" + i].gotoAndStop(i + 3);
            mc["mcIcon" + i].addEventListener(MouseEvent.CLICK,Switch(i));
            i++;
         }
         POPUPS.Push(mc);
         SwitchB(1);
      }
      
      public static function TruceRejected(param1:String, param2:String) : void
      {
         var mc:MovieClip = null;
         var i:int = 0;
         var Share:Function = null;
         var imgNumber:int = 0;
         var name:String = param1;
         var message:String = param2;
         Share = function(param1:MouseEvent = null):void
         {
            GLOBAL.CallJS("sendFeed",["Truce",KEYS.Get("map_trucerejected_streamtitle",{"v1":name}),KEYS.Get("map_trucerejected_streambody"),"taunt" + imgNumber + ".png",0]);
            POPUPS.Next();
         };
         var Switch:Function = function(param1:int):Function
         {
            var n:int = param1;
            return function(param1:MouseEvent = null):void
            {
               SwitchB(n);
            };
         };
         var SwitchB:Function = function(param1:int):void
         {
            imgNumber = param1;
            i = 1;
            while(i < 4)
            {
               mc["mcIcon" + i].alpha = 0.4;
               ++i;
            }
            mc["mcIcon" + param1].alpha = 1;
         };
         mc = new popup_truce_sent();
         mc.bShare.SetupKey("btn_share");
         mc.bShare.addEventListener(MouseEvent.CLICK,Share);
         mc.bShare.Highlight = true;
         mc.tTitle.htmlText = KEYS.Get("popup_desc_trucesent");
         i = 1;
         while(i < 4)
         {
            mc["mcIcon" + i].buttonMode = true;
            mc["mcIcon" + i].gotoAndStop(i);
            mc["mcIcon" + i].addEventListener(MouseEvent.CLICK,Switch(i));
            i++;
         }
         POPUPS.Push(mc);
         SwitchB(1);
      }
      
      public static function setVisitingFriend(param1:Boolean) : void
      {
         _visitingFriend = param1;
      }
      
      private static function setLastSort(param1:int) : void
      {
         _lastSort = param1;
         GLOBAL.StatSet("mrls",MAPROOM._lastSort);
      }
      
      private static function setLastView(param1:int) : void
      {
         _lastView = param1;
         GLOBAL.StatSet("mrlv",_lastView);
      }
      
      private static function setLastSortReversed(param1:int) : void
      {
         _lastSortReversed = param1;
         GLOBAL.StatSet("mrlsr",MAPROOM._lastSortReversed);
      }
      
      public static function get DescentLevel() : int
      {
         var _loc1_:int = _descentLvl;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(Boolean(WMBASE._descentBases) && WMBASE._descentBases.length > 0)
            {
               _loc1_ = WMBASE.CheckDescentProgress();
               _descentLvl = _loc1_;
               GLOBAL.StatSet("descentLvl",_descentLvl);
            }
            else
            {
               _loc1_ = GLOBAL.StatGet("descentLvl");
            }
         }
         return _loc1_;
      }
      
      public static function get InDescent() : Boolean
      {
         var _loc1_:Boolean = false;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _descentLvl = GLOBAL.StatGet("descentLvl");
         }
         return _descentLvl < _descentLvlMax ? true : false;
      }
      
      public static function get DescentPassed() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:Boolean = false;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && GLOBAL.StatGet("descentLvl") < 1)
         {
            return false;
         }
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc2_ = GLOBAL.StatGet("descentLvl");
            _descentLvl = _descentLvl < _loc2_ ? _loc2_ : _descentLvl;
         }
         return _descentLvl >= _descentLvlMax;
      }
   }
}

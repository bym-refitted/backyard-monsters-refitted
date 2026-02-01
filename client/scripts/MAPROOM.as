package
{
   import com.monsters.ai.TRIBES;
   import com.monsters.ai.WMBASE;
   import com.monsters.mailbox.Message;
   import com.monsters.maproom.MapRoom;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   
   public class MAPROOM
   {
      
      public static const TYPE:uint = 11;
      
      public static var _mc:MapRoom;
      
      public static var _open:Boolean;
      
      public static var _lastView:int = 0;
      
      public static var _lastSort:int = 3;
      
      public static var _lastSortReversed:int = 0;
      
      public static var _visitingFriend:Boolean = false;

      public static var initMaproomSetup:Boolean;
      
      private static var loadState:int;
      
      private static var andShow:Boolean = true;
      
      private static var bridge_obj:Object;
       
      public function MAPROOM()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _mc = null;
         loadState = 0;
         initMaproomSetup = false;
         _open = false;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _visitingFriend = false;
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
               "MAPROOM":MAPROOM
            };
         }
      }
      
      public static function Show(param1:MouseEvent = null) : void
      {
         if(GLOBAL._otherStats["mrlsr"] != undefined)
         {
            _lastSortReversed = GLOBAL.StatGet("mrlsr");
         }
         if(GLOBAL._otherStats["mrls"] != undefined)
         {
            _lastSort = GLOBAL.StatGet("mrls");
         }
         if(GLOBAL._otherStats["mrlv"] != undefined)
         {
            _lastView = GLOBAL.StatGet("mrlv");
         }
         bridge_obj._lastView = _lastView;
         bridge_obj._lastSort = _lastSort;
         bridge_obj._lastSortReversed = _lastSortReversed;
         andShow = true;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(GLOBAL._flags.maproom == 1)
            {
               if(GLOBAL._newBuilding)
               {
                  GLOBAL._newBuilding.Cancel();
               }
               if(GLOBAL._bMap)
               {
                  if(GLOBAL._bMap._canFunction && initMaproomSetup)
                  {
                     GLOBAL.BlockerAdd();
                     SOUNDS.Play("click1");
                     _open = true;
                     if([1, 2].indexOf(loadState) === -1)
                     {
                        // Loads Map Room 1
                        // This can be triggered if save.usemap on the server is not set or 0
                        _mc = new MapRoom();
                        _mc.init(bridge_obj);
                        GLOBAL._layerTop.addChild(_mc);
                     }
                     else if(loadState == 2)
                     {
                        ShowB();
                     }
                  } else if(!GLOBAL._flags.discordOldEnough) {
                     GLOBAL.Message(KEYS.Get("newmap_discord_age"));
                  }
                  else if(!initMaproomSetup)
                  {
                     GLOBAL.Message(KEYS.Get("newmap_init_setup"));
                  }
                  else
                  {
                     GLOBAL.Message(KEYS.Get("map_msg_damaged"));
                  }
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("map_msg_notbuilt"));
               }
            }
            else
            {
               GLOBAL.Message(KEYS.Get("map_msg_disabled"));
            }
         }
      }
      
      private static function ShowB() : void
      {
         andShow = false;
         GLOBAL._layerWindows.addChild(_mc);
         GLOBAL.WaitHide();
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
            GLOBAL._layerWindows.removeChild(_mc);
            _open = false;
            _mc.Hide();
            _mc = null;
            loadState = 0;
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
                  LOGGER.Log("err","MAPROOM.RequestTruce: " + JSON.stringify(param1));
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
   }
}

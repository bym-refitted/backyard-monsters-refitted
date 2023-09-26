package
{
   import com.flashdynamix.utils.SWFProfiler;
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.configs.BYMConfig;
   import com.monsters.debug.Console;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.marketing.MarketingRecapture;
   import com.monsters.radio.RADIO;
   import flash.display.*;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.system.Security;
   
   public class GAME extends Sprite
   {
      
      public static var _instance:GAME;
      
      public static var _contained:Boolean;
      
      public static var _isSmallSize:Boolean = true;
      
      public static var _firstLoadComplete:Boolean = false;
       
      
      private var _checkScreenSize:Boolean = true;
      
      public function GAME()
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         super();
         _instance = this;
         GLOBAL._local = !ExternalInterface.available;
         ReferencedExposedStructures.Include();
         if(this.parent)
         {
            _loc1_ = {};
            switch(GLOBAL._localMode)
            {
               case BYMConfig.k_sLOCAL_MODE_TRUNK:
                  _loc1_._baseURL = "http://bym-fb-trunk.dev.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-fb-trunk.dev.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-fb-trunk.dev.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-fb-trunk.dev.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-fb-trunk.dev.kixeye.com/alliance/";
                  _loc1_.languageurl = "http://bym-netdna.s3.amazonaws.com/gamedev/assets/";
                  _loc2_ = "http://bym-fb-trunk.dev.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_KONG:
                  _loc1_._baseURL = "http://bym-ko-halbvip1.dc.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-ko-halbvip1.dc.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-ko-halbvip1.dc.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-ko-halbvip1.dc.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bmstage.fb.casualcollective.com/alliance/";
                  _loc1_.fb_kongregate_api_path = "http://chat.kongregate.com/flash/API_AS3_46ebaf5ef297ce57605ca0a769f70b7d.swf";
                  _loc2_ = "http://bym-ko-halbvip1.dc.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_VIXTEST:
                  _loc1_._baseURL = "http://bmdev.vx.casualcollective.com/base/";
                  _loc1_._apiURL = "http://bmdev.vx.casualcollective.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bmdev.vx.casualcollective.com/recordstats.php";
                  _loc1_._mapURL = "http://bmdev.vx.casualcollective.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bmdev.vx.casualcollective.com/alliance/";
                  _loc2_ = "http://bmdev.vx.casualcollective.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_VIXSTAGE:
                  _loc1_._baseURL = "http://bym-vx-web.stage.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-vx-web.stage.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-vx-web.stage.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-vx-web.stage.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-vx-web.stage.kixeye.com/alliance/";
                  _loc2_ = "http://bym-vx-web.stage.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_VIXLIVE:
                  _loc1_._baseURL = "http://bym-vx2-vip.sjc.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-vx2-vip.sjc.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-vx2-vip.sjc.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-vx2-vip.sjc.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-vx2-vip.sjc.kixeye.com/alliance/";
                  _loc2_ = "http://bym-vx2-vip.sjc.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_INF_TRUNK:
                  _loc1_._baseURL = "http://bym-fb-inferno.dev.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-fb-inferno.dev.kixeye.com/api/";
                  _loc1_.infbaseurl = null;
                  _loc1_._statsURL = "http://bym-fb-inferno.dev.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-fb-inferno.dev.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-fb-inferno.dev.kixeye.com/alliance/";
                  _loc1_.languageurl = "http://bym-netdna.s3.amazonaws.com/gamedev/assets/";
                  _loc2_ = "http://bym-fb-inferno.dev.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_LIVE:
                  _loc1_._baseURL = "http://bym-fb-lbns.dc.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-fb-lbns.dc.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-fb-lbns.dc.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-fb-lbns.dc.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-fb-lbns.dc.kixeye.com/alliance/";
                  _loc1_.languageurl = "http://bym-netdna.s3.amazonaws.com/game/assets/";
                  _loc2_ = "http://bym-fb-lbns.dc.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_ALEX:
                  _loc1_._baseURL = "http://bym-fb-alex.dev.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-fb-alex.dev.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-fb-alex.dev.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-fb-alex.dev.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-fb-alex.dev.kixeye.com/alliance/";
                  _loc2_ = "http://bym-fb-alex.dev.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_NICK:
                  _loc1_._baseURL = "http://bym-fb-nmoore.dev.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-fb-nmoore.dev.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-fb-nmoore.dev.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-fb-nmoore.dev.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-fb-nmoore.dev.kixeye.com/alliance/";
                  _loc2_ = "http://bym-fb-nmoore.dev.kixeye.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_KONGDEV:
                  _loc1_._baseURL = "http://bm-kg-web2.dev.casualcollective.com/api/bm/base/";
                  _loc1_._apiURL = "http://bm-kg-web2.dev.casualcollective.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._gameURL = "http://bm-kg-cdn.casualcollective.com/bmkg/gamedev/";
                  _loc1_._statsURL = "http://bm-kg-web2.dev.casualcollective.com/recordstats.php";
                  _loc1_._mapURL = "http://bm-kg-web2.dev.casualcollective.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bm-kg-web2.dev.casualcollective.com/alliance/";
                  _loc2_ = "http://bm-kg-web2.dev.casualcollective.com/";
                  break;
               case BYMConfig.k_sLOCAL_MODE_KONGSTAGE:
                  _loc1_._baseURL = "http://bym-ko-web1.stage.kixeye.com/api/bm/base/";
                  _loc1_._apiURL = "http://bym-ko-web1.stage.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._gameURL = "http://bym-ko-web1.stage.kixeye.com/bmkg/gamedev/";
                  _loc1_._statsURL = "http://bym-ko-web1.stage.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-ko-web1.stage.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-ko-web1.stage.kixeye.com/alliance/";
                  _loc2_ = "http://bym-ko-web1.stage.kixeye.com/";
                  break;

               // Endpoints
               case BYMConfig.k_sLOCAL_MODE_PREVIEW:
                  _loc1_._baseURL = "http://localhost:3001/base/";
                  _loc1_._apiURL = "http://localhost:3001/api/";
                  _loc1_.infbaseurl = "http://localhost:3001/api/bm/base/";
                  _loc1_._statsURL = "http://localhost:3001/recordstats.php";
                  _loc1_._mapURL = "http://localhost:3001/worldmapv2/";
                  _loc1_._allianceURL = "http://localhost:3001/alliance/";
                  _loc1_.languageurl = "http://localhost:3001/gamedev/assets/";
                  _loc2_ = "http://localhost:3001/";
                  break;
               default:
                  _loc1_._baseURL = "http://bym-fb-web1.stage.kixeye.com/base/";
                  _loc1_._apiURL = "http://bym-fb-web1.stage.kixeye.com/api/";
                  _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
                  _loc1_._statsURL = "http://bym-fb-web1.stage.kixeye.com/recordstats.php";
                  _loc1_._mapURL = "http://bym-fb-web1.stage.kixeye.com/worldmapv2/";
                  _loc1_._allianceURL = "http://bym-fb-web1.stage.kixeye.com/alliance/";
                  _loc1_.languageurl = "http://bym-netdna.s3.amazonaws.com/gamestage/assets/";
                  _loc2_ = "http://bym-fb-web1.stage.kixeye.com/";
            }
            if(_loc2_)
            {
               _loc1_._baseURL = _loc2_ + "base/";
               _loc1_._apiURL = _loc2_ + "api/";
               _loc1_.infbaseurl = _loc1_._apiURL + "bm/base/";
               _loc1_._statsURL = _loc2_ + "recordstats.php";
               _loc1_._mapURL = _loc2_ + "worldmapv2/";
               _loc1_.map3url = _loc2_ + "worldmapv3/";
               _loc1_._allianceURL = _loc2_ + "alliance/";
               _loc1_.languageurl = _loc2_ + "gamestage/assets/";
               _loc1_._storageURL = _loc2_ + "assets/";
               _loc1_._soundPathURL = _loc2_ + "assets/sounds/";
               _loc1_._gameURL = _loc2_ + "";
               _loc1_._appid = _loc2_ + "";
               _loc1_._tpid = _loc2_ + "";
               _loc1_._currencyURL = _loc2_ + "";
               _loc1_._countryCode = _loc2_ + "us";
            }
            this.Data(_loc1_,false);
         }
      }
      
      public static function disableWindowScroll(param1:Event = null) : void
      {
         GLOBAL.CallJS("cc.disableMouseWheel");
      }
      
      public static function enableWindowScroll(param1:Event = null) : void
      {
         GLOBAL.CallJS("cc.enableMouseWheel");
      }
      
      public function Data(param1:Object, param2:Boolean = false) : void
      {
         var u:String;
         var obj:Object = param1;
         var contained:Boolean = param2;
         loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorThrown);
         GLOBAL._baseURL = obj._baseURL;
         u = String(GLOBAL._baseURL.split("/")[2]);
         Security.allowDomain("*");
         SWFProfiler.init(stage,null);
         Console.initialize(stage);
         _contained = contained;
         GLOBAL._infBaseURL = obj.infbaseurl;
         GLOBAL._apiURL = obj._apiURL;
         GLOBAL._gameURL = obj._gameURL;
         GLOBAL._storageURL = obj._storageURL;
         GLOBAL.languageUrl = obj.languageurl;
         GLOBAL._allianceURL = obj._allianceURL;
         GLOBAL._soundPathURL = obj._soundPathURL;
         GLOBAL._statsURL = obj._statsURL;
         GLOBAL._mapURL = obj._mapURL;
         MapRoomManager.instance.mapRoom3URL = obj.map3url;
         GLOBAL._appid = obj.app_id;
         GLOBAL._tpid = obj.tpid;
         GLOBAL._countryCode = obj._countryCode;
         GLOBAL._currencyURL = obj.currency_url;
         GLOBAL.__ = obj.__;
         GLOBAL.___ = obj.___;
         GLOBAL._softversion = obj.softversion;
         GLOBAL._fbdata = obj;
         GLOBAL._monetized = obj.monetized;
         MarketingRecapture.instance.importData(obj.urlparams);

         GLOBAL._ROOT = new MovieClip();
         addChild(GLOBAL._ROOT);
         GLOBAL._layerMap = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerUI = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerWindows = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerMessages = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerTop = GLOBAL._ROOT.addChild(new Sprite()) as Sprite;
         GLOBAL._layerMap.mouseEnabled = false;
         GLOBAL._layerUI.mouseEnabled = false;
         GLOBAL._layerWindows.mouseEnabled = false;
         GLOBAL._layerMessages.mouseEnabled = false;
         GLOBAL._layerTop.mouseEnabled = false;
         GLOBAL.RefreshScreen();
         if(obj.openbase)
         {
            GLOBAL._openBase = JSON.decode(obj.openbase);
         }
         else
         {
            GLOBAL._openBase = null;
         }
         addEventListener(Event.ENTER_FRAME,GLOBAL.TickFast);
         LOGIN.Login();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.addEventListener(Event.RESIZE,GLOBAL.ResizeGame);
         stage.showDefaultContextMenu = false;
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("openbase",function(param1:String):void
            {
               var _loc2_:Object = null;
               var _loc3_:int = 0;
               if(BASE._saveCounterA == BASE._saveCounterB && !BASE._saving && !BASE._loading)
               {
                  GLOBAL._currentCell = null;
                  _loc2_ = JSON.decode(param1);
                  _loc3_ = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
                  if(_loc2_.viewleader)
                  {
                     BASE.LoadBase(_loc2_.url,_loc2_.userid,Number(_loc2_.baseid),GLOBAL.e_BASE_MODE.VIEW,true,_loc3_);
                  }
                  else if(Boolean(_loc2_.infurl) && BASE.isInfernoMainYardOrOutpost)
                  {
                     BASE.LoadBase(_loc2_.infurl,0,Number(_loc2_.infbaseid),GLOBAL.e_BASE_MODE.IVIEW,true,EnumYardType.INFERNO_YARD);
                  }
                  else
                  {
                     BASE.LoadBase(_loc2_.url,_loc2_.userid,Number(_loc2_.baseid),GLOBAL.e_BASE_MODE.HELP,true,_loc3_);
                  }
               }
            });
            ExternalInterface.addCallback("fbcBuyItem",function(param1:String):void
            {
               STORE.FacebookCreditPurchaseB(param1);
            });
            ExternalInterface.addCallback("callbackgift",function(param1:String):void
            {
               POPUPS.CallbackGift(param1);
            });
            ExternalInterface.addCallback("callbackshiny",function(param1:String):void
            {
               POPUPS.CallbackShiny(param1);
            });
            ExternalInterface.addCallback("twitteraccount",function(param1:String):void
            {
               RADIO.TwitterCallback(param1);
            });
            ExternalInterface.addCallback("updateCredits",function(param1:String):void
            {
               STORE.updateCredits(param1);
            });
            ExternalInterface.addCallback("fbcAdd",function(param1:String):void
            {
               BUY.FBCAdd(param1);
            });
            ExternalInterface.addCallback("fbcOfferDaily",function(param1:String):void
            {
               BUY.FBCOfferDaily(param1);
            });
            ExternalInterface.addCallback("fbcOfferEarn",function(param1:String):void
            {
               BUY.FBCOfferEarn(param1);
            });
            ExternalInterface.addCallback("fbcNcp",function(param1:String):void
            {
               BUY.FBCNcp(param1);
            });
            ExternalInterface.addCallback("fbcNcpConfirm",function(param1:String):void
            {
               BUY.FBCNcpConfirm(param1);
            });
            ExternalInterface.addCallback("purchaseReceive",function(param1:String):void
            {
               BUY.purchaseReceive(param1);
            });
            ExternalInterface.addCallback("purchaseComplete",function(param1:String):void
            {
               BUY.purchaseComplete(param1);
            });
            ExternalInterface.addCallback("receivePurchase",function(param1:String):void
            {
               BUY.purchaseReceive(param1);
            });
            ExternalInterface.addCallback("startPromoTimer",function(param1:String):void
            {
               BUY.startPromo(param1);
            });
            ExternalInterface.addCallback("alliancesupdate",function(param1:String):void
            {
               ALLIANCES.AlliancesServerUpdate(param1);
            });
            ExternalInterface.addCallback("alliancesViewLeader",function(param1:String):void
            {
               ALLIANCES.AlliancesViewLeader(param1);
            });
            ExternalInterface.addCallback("openmap",function(param1:String):void
            {
               GLOBAL.ShowMap();
            });
         }
         if(this._checkScreenSize)
         {
            GLOBAL._SCREENINIT = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
            if(_isSmallSize)
            {
               GLOBAL._SCREENINIT = new Rectangle(0,0,760,670);
            }
            else
            {
               GLOBAL._SCREENINIT = new Rectangle(0,0,760,750);
            }
         }
      }
      
      protected function uncaughtErrorThrown(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Error = null;
         if(param1.error is Error)
         {
            _loc2_ = Error(param1.error).message;
            _loc3_ = param1.error as Error;
         }
         else if(param1.error is ErrorEvent)
         {
            _loc2_ = ErrorEvent(param1.error).text;
         }
         else
         {
            _loc2_ = String(param1.error.toString());
         }
         LOGGER.Log("err","UncaughtError: " + _loc2_ + (!!_loc3_ ? " | " + _loc3_.getStackTrace() : ""));
      }
      
      public function onStageRollOver(param1:MouseEvent = null) : void
      {
         GAME.disableWindowScroll();
      }
      
      public function onStageRollOut(param1:MouseEvent = null) : void
      {
         GAME.enableWindowScroll();
      }
   }
}

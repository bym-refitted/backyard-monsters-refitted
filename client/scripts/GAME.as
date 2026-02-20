package
{
   import com.flashdynamix.utils.SWFProfiler;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.marketing.MarketingRecapture;
   import flash.display.*;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.system.Security;
   import flash.net.SharedObject;
   import com.monsters.external_interface.ExternalInterfaceManager;
   import com.bymr.hxbridge.HaxeLib;
   public class GAME extends Sprite
   {

      public static var _instance:GAME;

      public static var _isSmallSize:Boolean = true;

      public static var _firstLoadComplete:Boolean = false;

      public static var sharedObj:SharedObject;

      public static var token:String = "";

      public static var language:String = "";

      private var _checkScreenSize:Boolean = true;

      private var _previousDistance:Number = 0;

      private var _scaleFactor:Number = 1;

      public function GAME()
      {
         HaxeLib.bootstrap(new GLOBAL(), new LOGGER());

         var urls:Object = null;
         var serverUrl:String = GLOBAL.serverUrl;
         var apiVersionSuffix:String = GLOBAL.apiVersionSuffix + "/";
         var cdnUrl:String = GLOBAL.cdnUrl;
         super();
         _instance = this;
         GLOBAL._local = !ExternalInterface.available;
         ReferencedExposedStructures.Include();
         if (this.parent)
         {
            urls = {};
            if (serverUrl)
            {
               urls._baseURL = serverUrl + "base/";
               urls._apiURL = serverUrl + "api/" + apiVersionSuffix;
               urls.infbaseurl = urls._apiURL + "bm/base/";
               urls._statsURL = serverUrl + "recordstats.php";
               urls._mapURL = serverUrl + "worldmapv2/";
               urls.map3url = serverUrl + "worldmapv3/";
               urls._allianceURL = serverUrl + "alliance/";
               urls.languageurl = cdnUrl + "gamestage/assets/";
               urls._storageURL = cdnUrl + "assets/";
               urls._soundPathURL = cdnUrl + "assets/sounds/";
               urls._gameURL = serverUrl + "";
               urls._appid = serverUrl + "";
               urls._tpid = serverUrl + "";
               urls._currencyURL = serverUrl + "";
               urls._countryCode = serverUrl + "us";
            }
            this.Data(urls, loaderInfo.parameters);
         }
      }

      public static function disableWindowScroll(param1:Event = null):void
      {
         GLOBAL.CallJS("cc.disableMouseWheel");
      }

      public static function enableWindowScroll(param1:Event = null):void
      {
         GLOBAL.CallJS("cc.enableMouseWheel");
      }

      public function setLauncherVars(params:Object):void
      {
         try
         {
            sharedObj = SharedObject.getLocal("bymr_data", "/");

            if (params && params.language)
            {
               language = params.language;
               sharedObj.data.language = language;
            }

            if (params && params.token)
            {
               token = params.token;
               sharedObj.data.token = token;
            }
            sharedObj.flush();
         }
         catch (e:Error)
         {
            LOGGER.Log("err", "Error setting token from loader: " + e.message);
         }
      }

      public function Data(urls:Object, loaderParams:Object):void
      {
         loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.uncaughtErrorThrown);
         setLauncherVars(loaderParams);
         SWFProfiler.init(stage, this);
         Security.allowDomain("*");
         GLOBAL.init();
         GLOBAL._baseURL = urls._baseURL;
         GLOBAL._infBaseURL = urls.infbaseurl;
         GLOBAL._apiURL = urls._apiURL;
         GLOBAL._gameURL = urls._gameURL;
         GLOBAL._storageURL = urls._storageURL;
         GLOBAL.languageUrl = urls.languageurl;
         GLOBAL._allianceURL = urls._allianceURL;
         GLOBAL._soundPathURL = urls._soundPathURL;
         GLOBAL._statsURL = urls._statsURL;
         GLOBAL._mapURL = urls._mapURL;
         MapRoomManager.instance.mapRoom3URL = urls.map3url;
         GLOBAL._appid = urls.app_id;
         GLOBAL._tpid = urls.tpid;
         GLOBAL._countryCode = urls._countryCode;
         GLOBAL._currencyURL = urls.currency_url;
         GLOBAL.__ = urls.__;
         GLOBAL.___ = urls.___;
         GLOBAL._softversion = urls.softversion;
         GLOBAL._fbdata = urls;
         GLOBAL._monetized = urls.monetized;
         MarketingRecapture.instance.importData(urls.urlparams);
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
         if (urls.openbase)
         {
            GLOBAL._openBase = JSON.parse(urls.openbase);
         }
         else
         {
            GLOBAL._openBase = null;
         }
         addEventListener(Event.ENTER_FRAME, GLOBAL.TickFast);

         LOGIN.Login();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.addEventListener(Event.RESIZE, GLOBAL.ResizeGame);
         stage.showDefaultContextMenu = false;
         ExternalInterfaceManager.Initialize();

         if (this._checkScreenSize)
         {
            GLOBAL._SCREENINIT = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            if (_isSmallSize)
            {
               GLOBAL._SCREENINIT = new Rectangle(0, 0, 760, 670);
            }
            else
            {
               GLOBAL._SCREENINIT = new Rectangle(0, 0, 760, 750);
            }
         }
      }

      protected function uncaughtErrorThrown(param1:UncaughtErrorEvent):void
      {
         var _loc2_:String = null;
         var _loc3_:Error = null;
         if (param1.error is Error)
         {
            _loc2_ = Error(param1.error).message;
            _loc3_ = param1.error as Error;
         }
         else if (param1.error is ErrorEvent)
         {
            _loc2_ = ErrorEvent(param1.error).text;
         }
         else
         {
            _loc2_ = String(param1.error.toString());
         }
         LOGGER.Log("err", "UncaughtError: " + _loc2_ + (!!_loc3_ ? " | " + _loc3_.getStackTrace() : ""));
      }

      public function onStageRollOver(param1:MouseEvent = null):void
      {
         GAME.disableWindowScroll();
      }

      public function onStageRollOut(param1:MouseEvent = null):void
      {
         GAME.enableWindowScroll();
      }
   }
}

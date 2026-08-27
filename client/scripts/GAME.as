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
   import flash.system.Capabilities;
   import flash.net.SharedObject;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.filesystem.FileMode;
   import com.monsters.external_interface.ExternalInterfaceManager;
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
         var urls:Object = null;
         
         // Override server URL if provided as a flash var
         var flashVarServerUrl:* = loaderInfo.parameters["serverUrl"];

         if (flashVarServerUrl != undefined && flashVarServerUrl != "")
         {
            GLOBAL.serverUrl = String(flashVarServerUrl);
         }

         var serverUrl:String = GLOBAL.serverUrl;
         var apiVersionSuffix:String = GLOBAL.apiVersionSuffix + "/";
         var cdnUrl:String = GLOBAL.cdnUrl;
         super();
         _instance = this;
         GLOBAL._local = !ExternalInterface.available;
         ReferencedExposedStructures.Include();
         // On iOS the game SWF is the AIR app root; init even without a preloader parent.
         if (this.parent || Capabilities.version.substr(0, 3) == "IOS")
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
            var loaderParams:Object = loaderInfo.parameters;
            if (this.stage)
            {
               this.Data(urls, loaderParams);
            }
            else
            {
               // iOS AIR root: the constructor runs before the root is added to the
               // stage, so `stage` is null here and stage-dependent init (RefreshScreen,
               // scaleMode…) would NPE. Defer until we're actually on the stage.
               var self:GAME = this;
               var urlsRef:Object = urls;
               var onAddedInit:Function = function(e:Event):void
               {
                  self.removeEventListener(Event.ADDED_TO_STAGE, onAddedInit);
                  self.Data(urlsRef, loaderParams);
               };
               this.addEventListener(Event.ADDED_TO_STAGE, onAddedInit);
            }
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
            else if (Capabilities.version.substr(0, 3) == "IOS")
            {
               // The desktop launcher always loads gameloader.swf?language=spanish, forcing it
               // on every launch. iOS has no URL launcher to pass ?language=..., so replicate
               // that here: force Spanish each launch (not just when unset) so a stale/English
               // value in the persisted SharedObject can never win. English keys stay as the
               // fallback for any missing spanish.json entries (see KEYS.as).
               language = "spanish";
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
         GAME.clearDiag();
         loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.uncaughtErrorThrown);
         setLauncherVars(loaderParams);
         // Perf (local optimized build): SWFProfiler attaches an ENTER_FRAME stats
         // loop that samples FPS/memory every frame — pure overhead. Disabled here.
         // SWFProfiler.init(stage, this);
         // Security.allowDomain is a browser-SWF cross-domain feature; in the AIR
         // application sandbox (iOS) it throws SecurityError #3207 and would abort init.
         try { Security.allowDomain("*"); } catch (securityErr:Error) { }

         continueBoot(urls, loaderParams);
      }

      /**
       * The rest of boot after the (iOS-only) server pick: fire GLOBAL.init against
       * the chosen server, wire URLs into GLOBAL, build the display layers, show the
       * login. On desktop this runs straight through from Data().
       */
      public function continueBoot(urls:Object, loaderParams:Object):void
      {
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
         if (Capabilities.version.substr(0, 3) == "IOS")
         {
            // BYM is a fixed 760x670 mouse game. On iOS (AIR) SHOW_ALL scales that canvas to
            // fit the device height preserving aspect, centered (empty align = center); AIR
            // maps single taps to clicks. On a wide phone the canvas is letterboxed but the
            // map bleeds into the side bars (Flash doesn't clip the stage), so the game still
            // looks full-screen. The UI, however, must anchor to the *real* visible width, not
            // the narrow 760 canvas — GLOBAL.GetGameWidth() computes that from the device
            // aspect once this flag is set, keeping the HUD at the true edges and popups
            // centered on ANY iPhone.
            stage.scaleMode = StageScaleMode.SHOW_ALL;
            stage.align = "";
            // Adaptive-width UI: widen _SCREEN to the real visible width so the HUD spreads
            // to the screen edges. Verified safe for the base map on this build: it renders
            // via the vector path (BYMConfig.RENDERER_ON=false), so MAP._viewRect/resizeViewRect
            // is dead code, and the base camera keys off _SCREENINIT (760) + a hardcoded 380
            // center that is invariant under symmetric widening; _SCREENCENTER.x also stays 380
            // so popups don't move. GetGameWidth() applies a small margin so the HUD doesn't
            // jam against the physical edge / notch.
            GLOBAL._iosViewport = true;
            // Pins the play frame rate to the authored 40 fps and throttles to ~2 fps only when
            // the app is backgrounded (no downside — the sim is getTimer-based + server-
            // authoritative). Quality stays full; the render optimisation is renderMode=direct
            // in the app descriptor (GPU composite/present), not a quality drop.
            POWER.setup(stage);
            // Free continuous pinch-to-zoom (Clash-of-Clans style). GESTURE mode still delivers
            // single-touch mouse events the rest of the game depends on.
            PINCHZOOM.setup(stage);
            // Local notifications: buzz the player when a build/upgrade/fortify finishes while the
            // app is backgrounded. Native side is the com.bym.notif ANE (UNUserNotificationCenter);
            // schedules on DEACTIVATE, cancels on ACTIVATE. Client-only, no server, no ban risk.
            NOTIFY.init(stage);
         }
         // Perf (local optimized build): the engine never sets stage.quality, so Flash
         // defaults to HIGH (4x antialiasing) — the single biggest CPU cost in vector
         // Flash and the main cause of stutter. MEDIUM keeps it readable but ~halves
         // the rasterization load. Switch to LOW for max smoothness on weak hardware.
         stage.quality = StageQuality.MEDIUM;
         stage.addEventListener(Event.RESIZE, GLOBAL.ResizeGame);
         stage.showDefaultContextMenu = false;
         ExternalInterfaceManager.Initialize();

         if (this._checkScreenSize)
         {
            GLOBAL._SCREENINIT = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            if (Capabilities.version.substr(0, 3) == "IOS")
            {
               // _SCREENINIT is the fixed design canvas (760x670 = SHOW_ALL authored size).
               // Hardcode it rather than read stage.stageWidth so the frame is deterministic
               // regardless of when SHOW_ALL settles the reported stage size. RefreshScreen
               // then derives _SCREEN from GetGameWidth() (the real visible width), so
               // _SCREEN.x = -(visibleW - 760)/2 — the canvas is centered inside the wider
               // visible area and the UI spreads to the true screen edges.
               GLOBAL._SCREENINIT = new Rectangle(0, 0, 760, 670);
            }
            else if (_isSmallSize)
            {
               GLOBAL._SCREENINIT = new Rectangle(0, 0, 760, 670);
            }
            else
            {
               GLOBAL._SCREENINIT = new Rectangle(0, 0, 760, 750);
            }
            // _SCREEN was first computed (line ~184) before _SCREENINIT was finalised;
            // recompute now so the visible rect + center match the frame we just set.
            GLOBAL.RefreshScreen();
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
         if (_diagCount < 40) { _diagCount++; GAME.logDiag("UNCAUGHT: " + _loc2_ + (!!_loc3_ ? "\n" + _loc3_.getStackTrace() : "")); }
      }

      public static var _diagCount:int = 0;

      public static function clearDiag():void
      {
         _diagCount = 0;
         try
         {
            var f:File = File.documentsDirectory.resolvePath("bym_error.txt");
            var fs:FileStream = new FileStream();
            fs.open(f, FileMode.WRITE);
            fs.writeUTFBytes("=== launch BUILD-MARKER-B16 ===\n");
            fs.close();
         }
         catch (e:Error) { }
      }

      public static function logDiag(msg:String):void
      {
         try
         {
            var f:File = File.documentsDirectory.resolvePath("bym_error.txt");
            var fs:FileStream = new FileStream();
            fs.open(f, FileMode.APPEND);
            fs.writeUTFBytes(msg + "\n");
            fs.close();
         }
         catch (e:Error) { }
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

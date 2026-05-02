package
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.Timer;

    /**
     * This file is not used in this codebase, but is left here for reference on how the game loader works.
     * It is responsible for showing the loading screen, fetching the version manifest,
     * and then loading the appropriate game SWF based on the manifest data.
     *
     * This lives in a separate SWF file called "gameloader.swf" which is the initial entry point when the game is launched.
     */
    public class GAMELOADER extends Sprite
    {
        public var mcLoading:MovieClip;
        public var _game:Loader;

        private const API_URL:String = "https://server.bymrefitted.com/";
        private const CDN_URL:String = "https://cdn.bymrefitted.com/";

        private var urls:Object;

        private var step:int = 0;
        private var steps:int;

        private var manifestData:Object;
        private var timerDone:Boolean = false;
        private var _pendingURL:String;

        public function GAMELOADER()
        {
            super();

            this.urls = {};

            var apiVersionSuffix:String = "v0.0.0/";

            this.urls._baseURL = API_URL + "base/";
            this.urls._apiURL = API_URL + "api/" + apiVersionSuffix;
            this.urls.infbaseurl = this.urls._apiURL + "bm/base/";
            this.urls._statsURL = API_URL + "recordstats.php";
            this.urls._mapURL = API_URL + "worldmapv2/";
            this.urls.map3url = API_URL + "worldmapv3/";
            this.urls._allianceURL = API_URL + "alliance/";
            this.urls.languageurl = CDN_URL + "gamestage/assets/";
            this.urls._storageURL = CDN_URL + "assets/";
            this.urls._soundPathURL = this.urls._storageURL + "sounds/";
            this.urls._gameURL = API_URL;
            this.urls._appid = API_URL;
            this.urls._tpid = API_URL;
            this.urls._currencyURL = API_URL;
            this.urls._countryCode = API_URL + "us";

            this.mcLoading.tProgress.htmlText = "0%";
            this.mcLoading.mcLoadingScreen.mcBar.width = 0;

            var duration:int = 1000;
            var interval:int = 10;
            steps = duration / interval;

            var timer:Timer = new Timer(interval, steps);
            timer.addEventListener(TimerEvent.TIMER, onTimerProgress);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
            timer.start();

            _pendingURL = CDN_URL + "versionManifest.json";
            var manifestLoader:URLLoader = new URLLoader();
            manifestLoader.addEventListener(Event.COMPLETE, onManifestLoaded);
            manifestLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            manifestLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            manifestLoader.load(new URLRequest(_pendingURL));
        }

        private function onTimerProgress(e:TimerEvent):void
        {
            ++step;
            var pct:Number = Math.min(100, Math.floor(step / steps * 100));
            mcLoading.tProgress.htmlText = pct + "%";
            mcLoading.mcLoadingScreen.mcBar.width = pct * 2.4;
        }

        private function onTimerComplete(e:TimerEvent):void
        {
            timerDone = true;
            if (manifestData != null)
                proceedWithManifest();
        }

        private function onManifestLoaded(e:Event):void
        {
            try
            {
                manifestData = JSON.parse(e.target.data);
            }
            catch (err:Error)
            {
                showError(err.message, _pendingURL);
                return;
            }

            if (timerDone)
                proceedWithManifest();
        }

        private function onIOError(e:IOErrorEvent):void
        {
            var url:String = (e.target is LoaderInfo) ? LoaderInfo(e.target).url : _pendingURL;
            showError(describeErrorID(e.errorID), url);
        }

        private function onSecurityError(e:SecurityErrorEvent):void
        {
            var url:String = (e.target is LoaderInfo) ? LoaderInfo(e.target).url : _pendingURL;
            showError(describeErrorID(e.errorID), url);
        }

        /**
         * Maps common Flash load error IDs to human-readable descriptions.
         * Flash exposes only the numeric code via IOErrorEvent.text — descriptions are internal to the runtime.
         *
         * @param {int} id - The error ID from the event
         * @returns {String} Human-readable description with the error code
         */
        private function describeErrorID(id:int):String
        {
            var desc:String;
            switch (id)
            {
                case 2032:
                    desc = "Stream Error (network failure or connection refused)";
                    break;
                case 2035:
                    desc = "URL Not Found";
                    break;
                case 2048:
                    desc = "Security sandbox violation";
                    break;
                case 2124:
                    desc = "Loaded file is an unknown type";
                    break;
                default:
                    desc = "Unexpected load error";
                    break;
            }
            return "Error #" + id + ": " + desc;
        }

        // Android:
        // var version:String = manifestData.currentAndroidVersion;
        private function proceedWithManifest():void
        {
            var version:String = manifestData.currentGameVersion;
            var versionSuffix:String = "v" + version + "-beta";

            this.urls._apiURL = API_URL + "api/" + versionSuffix + "/";
            this.urls.infbaseurl = this.urls._apiURL + "bm/base/";

            loadGameSWF(versionSuffix);
        }

        // Android:
        // _pendingURL = CDN_URL + "swfs/bymr-android-" + versionSuffix + ".swf";
        private function loadGameSWF(versionSuffix:String):void
        {
            this._game = new Loader();
            _pendingURL = CDN_URL + "swfs/bymr-stable-" + versionSuffix + ".swf";

            var request:URLRequest = new URLRequest(_pendingURL);

            this._game.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
            this._game.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this._game.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            this._game.load(request);
        }

        public function onComplete(e:Event):void
        {
            var loaderParams:Object = this.loaderInfo.parameters;

            removeChild(this.mcLoading);
            this.mcLoading = null;

            addChild(this._game);

            Object(this._game.content).Data(this.urls, loaderParams);
        }

        private function showError(message:String, url:String):void
        {
            var tf:TextField = new TextField();
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.wordWrap = false;
            tf.textColor = 0xFFFFFF;
            tf.text = message + "\n" + url;
            tf.x = 8;
            tf.y = 8;

            var banner:Sprite = new Sprite();
            banner.graphics.beginFill(0xCC2222);
            banner.graphics.drawRect(0, 0, stage.stageWidth, tf.height + 16);
            banner.graphics.endFill();
            banner.addChild(tf);

            addChild(banner);
        }
    }
}

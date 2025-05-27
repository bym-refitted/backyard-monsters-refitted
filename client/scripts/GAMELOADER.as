package
{
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    public class GAMELOADER extends Sprite
    {
        public var mcLoading:MovieClip;

        public var _game:Loader;

        private var urls:Object;

        private var step:int = 0;

        private var steps:int;

        public function GAMELOADER()
        {
            super();
            this.urls = {};
            var serverUrl:String = "https://server.bymrefitted.com/";
            var cdnUrl:String = "https://cdn.bymrefitted.com/";
            var apiVersionSuffix:String = "v1.2.4-beta/";

            this.urls._baseURL = serverUrl + "base/";
            this.urls._apiURL = serverUrl + "api/" + apiVersionSuffix;
            this.urls.infbaseurl = urls._apiURL + "bm/base/";
            this.urls._statsURL = serverUrl + "recordstats.php";
            this.urls._mapURL = serverUrl + "worldmapv2/";
            this.urls.map3url = serverUrl + "worldmapv3/";
            this.urls._allianceURL = serverUrl + "alliance/";
            this.urls.languageurl = cdnUrl + "gamestage/assets/";
            this.urls._storageURL = cdnUrl + "assets/";
            this.urls._soundPathURL = cdnUrl + "assets/sounds/";
            this.urls._gameURL = serverUrl + "";
            this.urls._appid = serverUrl + "";
            this.urls._tpid = serverUrl + "";
            this.urls._currencyURL = serverUrl + "";
            this.urls._countryCode = serverUrl + "us";

            this.mcLoading.tProgress.htmlText = "0%";
            this.mcLoading.mcLoadingScreen.mcBar.width = 0;

            var duration:int = 500;
            var interval:int = 10;
            steps = duration / interval;

            var timer:Timer = new Timer(interval, steps);

            timer.addEventListener(TimerEvent.TIMER, onTimerProgress);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);

            timer.start();
        }

        private function onTimerProgress(e:TimerEvent):void
        {
            step++;
            var pct:Number = Math.min(100, Math.floor((step / steps) * 100));
            mcLoading.tProgress.htmlText = pct + "%";
            mcLoading.mcLoadingScreen.mcBar.width = pct * 2.4;
        }

        private function onTimerComplete(e:TimerEvent):void
        {
            this._game = new Loader();

            var request:URLRequest = new URLRequest("https://cdn.bymrefitted.com/swfs/bymr-stable.swf");
            this._game.load(request);
            this._game.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
        }

        public function onComplete(e:Event):void
        {
            var loaderParams:Object = this.loaderInfo.parameters;
            
            removeChild(this.mcLoading);
            this.mcLoading = null;

            addChild(this._game);
            Object(this._game.content).Data(this.urls, loaderParams);
        }
    }
}

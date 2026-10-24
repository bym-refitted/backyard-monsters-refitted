package {
    import flash.display.MovieClip;
    import flash.text.TextField;

    [Embed(source="/_assets/ReplayableEventCountdownUI.swf", symbol="ReplayableEventCountdownUI")]
    public dynamic class ReplayableEventCountdownUI extends MovieClip {

        public var mcBackground:MovieClip;

        public var tLabel:TextField;

        public var bHelp:MovieClip;

        public function ReplayableEventCountdownUI() {
            super();
        }
    }
}

package
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    [Embed(source="/_assets/assets.swf", symbol="buildingInfo")]
    public dynamic class buildingInfoData extends MovieClip
    {

        public var tInfoRight:TextField;

        public var tName:TextField;

        public var mcBG:MovieClip;

        public var tInfoLeft:TextField;

        public function buildingInfoData()
        {
            super();
            addFrameScript(0, this.frame1);
        }

        internal function frame1():*
        {
            stop();
        }
    }
}
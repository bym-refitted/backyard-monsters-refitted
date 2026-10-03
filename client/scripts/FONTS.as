package {
    import flash.text.Font;

    /**
     * The fonts text may be set in, and the one font compiled in here rather
     * than taken from assets.swf.
     *
     * Grobold and Verdana already ship inside assets.swf, so their glyphs are in
     * the SWF through the symbols we embed from it - naming them here only saves
     * code from repeating the strings. Embedding them again would carry a second
     * copy of every glyph.
     *
     * embedAsCFF must stay false: classic TextFields cannot render CFF outlines,
     * and text set in one silently disappears. unicodeRange keeps only Latin
     * glyphs, since the whole range costs far more than the SWF should carry.
     */
    public class FONTS {

        public static const ANIME_ACE:String = "Anime Ace";

        public static const GROBOLDOV:String = "Groboldov";

        public static const VERDANA:String = "Verdana";

        [Embed(source = "/_fonts/animeace.ttf", fontName = "Anime Ace", mimeType = "application/x-font", embedAsCFF = "false", advancedAntiAliasing = "true", unicodeRange = "U+0020-U+007E")]
        private static const ANIME_ACE_REGULAR:Class;

        private static var _registered:Boolean = false;

        public static function Register():void {
            if (_registered) {
                return;
            }
            Font.registerFont(ANIME_ACE_REGULAR);
            _registered = true;
        }
    }
}

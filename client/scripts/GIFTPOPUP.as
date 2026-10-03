package {
    import com.monsters.display.ImageCache;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    /**
     * The mystery sack popup, shown from the gift button when nothing is waiting
     * to be collected.
     *
     * Laid out like the original Facebook page it replaces: title across the top,
     * sack art on the left, explanation on the right, action beneath it.
     *
     * Everything is positioned around the origin because POPUPSETTINGS.AlignToCenter
     * only moves the clip to the middle of the screen - it does not account for the
     * clip's own bounds, so content built from 0,0 hangs off the bottom right.
     */
    public class GIFTPOPUP extends MovieClip {

        private static const BG_W:int = 640;
        private static const BG_H:int = 410;

        private static const PAD_H:int = 26;
        private static const PAD_TOP:int = 34;

        private static const TITLE_SIZE:int = 25;
        private static const TITLE_H:int = 36;

        private static const IMAGE_W:Number = 348;
        private static const IMAGE_TOP:int = 88;

        private static const TEXT_W:int = 230;
        private static const TEXT_TOP:int = 118;
        private static const BODY_SIZE:int = 18;

        private static const BUTTON_W:int = 210;
        private static const BUTTON_BOTTOM:int = 70;

        private static const IMAGE:String = "popups/mystery_sacksend.png";

        /** Gap between the art and the text column. */
        private static const COLUMN_GAP:int = 8;

        private var _image:MovieClip;

        public function GIFTPOPUP() {
            super();
            this._build();
        }

        private function _build():void {
            const left:int = -int(BG_W * 0.5);
            const top:int = -int(BG_H * 0.5);

            this._buildFrame(left, top);
            this._buildTitle(left, top);
            this._buildImage(left, top);
            this._buildBody(left, top);
            this._buildAction(left, top);
        }

        private function _buildFrame(param1:int, param2:int):void {
            var _loc3_:frame_CLIP = addChild(new frame_CLIP()) as frame_CLIP;
            _loc3_.width = BG_W;
            _loc3_.height = BG_H;
            _loc3_.x = param1;
            _loc3_.y = param2;
            _loc3_.Setup();
        }

        private function _buildTitle(param1:int, param2:int):void {
            var _loc3_:TextField = addChild(new TextField()) as TextField;
            var _loc4_:TextFormat = new TextFormat(FONTS.GROBOLDOV, TITLE_SIZE, 0xFFFFFF);
            _loc4_.align = TextFormatAlign.CENTER;
            _loc3_.defaultTextFormat = _loc4_;
            _loc3_.embedFonts = true;
            _loc3_.antiAliasType = AntiAliasType.NORMAL;
            _loc3_.selectable = false;
            _loc3_.mouseEnabled = false;
            _loc3_.width = BG_W - PAD_H * 2;
            _loc3_.height = TITLE_H;
            _loc3_.x = param1 + PAD_H;
            _loc3_.y = param2 + PAD_TOP;
            _loc3_.text = KEYS.Get("pop_giftempty_title");
            _loc3_.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
        }

        private function _buildImage(param1:int, param2:int):void {
            var onLoaded:Function = null;
            this._image = addChild(new MovieClip()) as MovieClip;
            this._image.mouseEnabled = false;
            this._image.x = param1 + PAD_H;
            this._image.y = param2 + IMAGE_TOP;
            onLoaded = function(param1:String, param2:BitmapData):void {
                var _loc3_:Bitmap = new Bitmap(param2);
                _loc3_.smoothing = true;
                _loc3_.scaleX = _loc3_.scaleY = IMAGE_W / _loc3_.width;
                _image.addChild(_loc3_);
            };
            ImageCache.GetImageWithCallBack(IMAGE, onLoaded, true, 0);
        }

        private function _buildBody(param1:int, param2:int):void {
            var _loc3_:TextField = addChild(new TextField()) as TextField;
            var _loc4_:TextFormat = new TextFormat(FONTS.ANIME_ACE, BODY_SIZE, 0x000000);
            _loc4_.align = TextFormatAlign.CENTER;
            _loc3_.defaultTextFormat = _loc4_;
            _loc3_.embedFonts = true;
            _loc3_.antiAliasType = AntiAliasType.NORMAL;
            _loc3_.selectable = false;
            _loc3_.mouseEnabled = false;
            _loc3_.multiline = true;
            _loc3_.wordWrap = false;
            _loc3_.width = TEXT_W;
            _loc3_.height = 200;
            _loc3_.x = this._columnCenter(param1) - int(TEXT_W * 0.5);
            _loc3_.y = param2 + TEXT_TOP;
            _loc3_.htmlText = KEYS.Get("pop_giftempty_body");
        }

        private function _buildAction(param1:int, param2:int):void {
            var _loc3_:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
            _loc3_.SetupKey("btn_sendtofriends", false, BUTTON_W);
            _loc3_.x = this._columnCenter(param1) - int(BUTTON_W * 0.5);
            _loc3_.y = -param2 - BUTTON_BOTTOM;
            _loc3_.addEventListener(MouseEvent.CLICK, this._onAction);
        }

        /**
         * Middle of the space left of the frame edge once the art has taken its
         * half, so the text and button sit centred in their column rather than
         * hugging the border.
         *
         * @param {int} param1 - The frame's left edge, in this clip's coordinates.
         * @returns {int} The column's centre x.
         */
        private function _columnCenter(param1:int):int {
            var _loc2_:int = param1 + PAD_H + IMAGE_W + COLUMN_GAP;
            var _loc3_:int = -param1 - PAD_H;

            return _loc2_ + int((_loc3_ - _loc2_) * 0.5);
        }

        private function _onAction(param1:MouseEvent):void {
            SOUNDS.Play("click1");
            POPUPS.OpenFriendsPage();
        }
    }
}

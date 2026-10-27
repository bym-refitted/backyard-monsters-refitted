package com.monsters.replayableEvents {
    import com.monsters.chat.Chat;
    import com.monsters.debug.Console;
    import com.monsters.display.ImageCache;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ReplayableEventCountdown extends ReplayableEventCountdownUI implements IReplayableEventUI {

        private var m_event:ReplayableEvent;

        public function ReplayableEventCountdown() {
            super();
        }

        public function get eventUI():DisplayObject {
            return this;
        }

        public function update():void {
            tLabel.htmlText = "<b>" + GLOBAL.ToTime(this.m_event.timeUntilNextDate, true) + "</b>";
            this.resize();
        }

        private function loadedImage(param1:String, param2:BitmapData):void {
            var _loc3_:Bitmap = null;
            _loc3_ = new Bitmap(param2);
            _loc3_.y = -_loc3_.height + mcBackground.height;
            addChild(_loc3_);
        }

        private function loadedTitle(param1:String, param2:BitmapData):void {
            var _loc3_:Bitmap = new Bitmap(param2);
            addChild(_loc3_);
        }

        protected function clickedHelp(param1:MouseEvent):void {
            dispatchEvent(new Event(ReplayableEventUI.CLICKED_INFO));
        }

        private function resize():void {
            x = GLOBAL._SCREEN.x;
            y = GLOBAL._SCREEN.y + (GLOBAL._SCREEN.height - this.height);
            if (Boolean(Chat._bymChat) && Boolean(Chat._bymChat.chatBox) && Boolean(Chat._bymChat.chatBox.background)) {
                y = int(Chat._bymChat.y + Chat._bymChat.chatBox.y + Chat._bymChat.chatBox.background.y - 53);
            }
        }

        public function setup(param1:ReplayableEvent):void {
            this.m_event = ReplayableEventHandler.activeEvent;
            if (!this.m_event) {
                Console.warning("you\'re setting up the event UI but there\'s no active event", true);
            }
            if (this.m_event.imageURL) {
                ImageCache.GetImageWithCallBack(this.m_event.imageURL, this.loadedImage);
            }
            if (this.m_event.titleImage) {
                ImageCache.GetImageWithCallBack(this.m_event.titleImage, this.loadedTitle);
            }
            bHelp.addEventListener(MouseEvent.CLICK, this.clickedHelp);
            bHelp.buttonMode = true;
            this.resize();
        }
    }
}

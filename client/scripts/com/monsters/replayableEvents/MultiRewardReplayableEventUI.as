package com.monsters.replayableEvents {
    import com.monsters.chat.Chat;
    import com.monsters.display.ImageCache;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.monsters.replayableEvents.RewardGraphics;

    public class MultiRewardReplayableEventUI extends MultiRewardEventsBar implements IReplayableEventUI {

        public static var CLICKED_ACTION:String = "eventBarAction";

        public static var CLICKED_INFO:String = "eventBarInfo";

        public static const k_REWARD_COLOR:uint = 15924337;

        public static const k_PROGRESS_COLOR:uint = 8567294;

        private static const k_RIBBON_COUNT:uint = 3;

        private var _event:ReplayableEvent;

        private var m_progressBarFill:Shape;

        private var m_rewardGraphics:Vector.<RewardGraphics>;

        private var k_BUFFER:Number = 0.25;

        public function MultiRewardReplayableEventUI() {
            this.m_rewardGraphics = new Vector.<RewardGraphics>();
            super();
        }

        public function get eventUI():DisplayObject {
            return this;
        }

        public function setup(param1:ReplayableEvent):void {
            var i:uint = 0;
            var quota:ReplayableEventQuota = null;
            var rewardQuotas:Vector.<ReplayableEventQuota> = new Vector.<ReplayableEventQuota>();
            var slot:int = 0;
            var ribbon:EventRewardRibbon = null;
            var previousScore:Number = NaN;
            var segment:Sprite = null;
            var barWidth:Number = NaN;
            this._event = param1;
            tScore.visible = false;
            tScore.mouseEnabled = false;
            timeLabel.x = 49;
            buttonHelp.addEventListener(MouseEvent.CLICK, this.ShowInfoPopup);
            buttonHelp.buttonMode = true;
            if (this._event.buttonCopy) {
                buttonAction.stop();
                buttonAction.addEventListener(MouseEvent.CLICK, this.ShowEventPopup, false, 0, true);
                buttonAction.buttonMode = true;
                buttonActionLabel.text = this._event.buttonCopy;
                buttonActionLabel.mouseEnabled = false;
            }
            else {
                buttonActionLabel.visible = false;
                buttonAction.visible = false;
            }
            progressBarOverlay.visible = true;
            progressBarOverlay.mouseEnabled = false;
            if (this._event.imageURL) {
                ImageCache.GetImageWithCallBack(this._event.imageURL, this.onImageLoaded);
            }
            if (this._event.titleImage) {
                ImageCache.GetImageWithCallBack(this._event.titleImage, this.onLogoLoaded);
            }
            for (i = 0; i < k_RIBBON_COUNT; i++) {
                this.getChildByName("reward" + i).visible = false;
            }

            for each (quota in this._event.rewards) {
                if (quota.rewardID) {
                    rewardQuotas.push(quota);
                }
            }

            barWidth = progressBarFillMask.width;

            for (i = 0; i < rewardQuotas.length; i++) {
                quota = rewardQuotas[i];
                slot = k_RIBBON_COUNT - rewardQuotas.length + i;
                ribbon = this.getChildByName("reward" + slot) as EventRewardRibbon;

                if (ribbon == null)
                    break;

                ribbon.visible = true;
                ImageCache.GetImageWithCallBack(quota.imageURL, this.onRewardImageLoaded, true, 4, "", [ribbon]);

                if (i > 0) {
                    previousScore = rewardQuotas[i - 1].quota;
                }
                else if (rewardQuotas.length > 1) {
                    previousScore = Math.max(0, 2 * quota.quota - rewardQuotas[1].quota);
                }
                else {
                    previousScore = 0;
                }

                segment = new Sprite();
                segment.x = previousScore / this._event.maxScore * barWidth + 2;
                segment.y = 1;
                segment.graphics.beginFill(k_REWARD_COLOR);
                segment.graphics.drawRect(0, 0, (quota.quota - previousScore) / this._event.maxScore * barWidth, progressBarFillMask.height - 2);
                this.progressBarFill.addChild(segment);
                this.m_rewardGraphics.push(new RewardGraphics(segment, ribbon));
            }
            this.m_progressBarFill = new Shape();
            this.m_progressBarFill.x += 2;
            this.progressBarFill.addChild(this.m_progressBarFill);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStage);
        }

        private function removedFromStage(param1:Event):void {
            this.m_rewardGraphics = null;
        }

        public function update():void {
            var _loc1_:int = this._event.timeUntilNextDate;
            if (_loc1_ <= 0) {
                timeLabel.htmlText = "<b>DATE NOT INITIALIZED!</b>";
            }
            else {
                timeLabel.htmlText = "<b>" + GLOBAL.ToTime(_loc1_, true) + "</b>";
            }
            if (this._event.hasEventStarted) {
                this.m_progressBarFill.graphics.clear();
                this.m_progressBarFill.graphics.beginFill(k_PROGRESS_COLOR);
                this.m_progressBarFill.graphics.drawRect(0, 0, this._event.progress * progressBarFillMask.width, progressBarFillMask.height);
                this.m_progressBarFill.graphics.endFill();
            }
            if (this._event.buttonCopy) {
                buttonActionLabel.text = this._event.buttonCopy;
            }
            tScore.htmlText = "<b>" + Math.max(this._event.score, 0) + "/" + this._event.maxScore + "</b>";
            this.Resize();
        }

        private function Resize():void {
            x = int(GLOBAL._SCREEN.x);
            y = int(GLOBAL._SCREEN.y + (GLOBAL._SCREEN.height - mcBackground.height));
            if (Chat._bymChat && Chat._bymChat.chatBox && Boolean(Chat._bymChat.chatBox.background)) {
                y = int(Chat._bymChat.y + Chat._bymChat.chatBox.y + Chat._bymChat.chatBox.background.y - mcBackground.height);
            }
        }

        private function onImageLoaded(param1:String, param2:BitmapData):void {
            var _loc3_:Bitmap = new Bitmap(param2);
            var _loc4_:Sprite;
            (_loc4_ = new Sprite()).addChild(_loc3_);
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            addChildAt(_loc4_, 0);
            _loc4_.y -= _loc4_.height + this.k_BUFFER;
        }

        private function onLogoLoaded(param1:String, param2:BitmapData):void {
            var _loc3_:Bitmap = new Bitmap(param2);
            addChild(_loc3_);
            _loc3_.visible = true;
        }

        private function onRewardImageLoaded(param1:String, param2:BitmapData, param3:Array):void {
            var _loc4_:EventRewardRibbon = param3[0] as EventRewardRibbon;
            while (_loc4_.rewardImage0.numChildren) {
                _loc4_.rewardImage0.removeChildAt(0);
            }
            _loc4_.rewardImage0.addChild(new Bitmap(param2));
            _loc4_.visible = true;
        }

        private function ShowEventPopup(param1:MouseEvent = null):void {
            dispatchEvent(new Event(CLICKED_ACTION));
        }

        private function ShowInfoPopup(param1:MouseEvent = null):void {
            dispatchEvent(new Event(CLICKED_INFO));
        }
    }
}

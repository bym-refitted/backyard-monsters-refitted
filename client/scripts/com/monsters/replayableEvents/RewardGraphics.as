package com.monsters.replayableEvents {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import gs.TweenLite;

    internal class RewardGraphics {

        public var ribbon:EventRewardRibbon;

        public var fill:Sprite;

        private var width:Number;

        private var height:Number;

        private var isOver:Boolean;

        private var backIndex:int = -1;

        public function RewardGraphics(param1:Sprite, param2:EventRewardRibbon) {
            super();
            this.width = param1.width;
            this.height = param1.height;
            this.ribbon = param2;
            this.fill = param1;
            this.fill.addEventListener(MouseEvent.MOUSE_OVER, this.OnProgressBarSectionMouseOver, false, 0, true);
            this.ribbon.addEventListener(MouseEvent.MOUSE_OVER, this.OnProgressBarSectionMouseOver, false, 0, true);
            this.fill.addEventListener(MouseEvent.MOUSE_OUT, this.OnProgressBarSectionMouseOut, false, 0, true);
            this.ribbon.addEventListener(MouseEvent.MOUSE_OUT, this.OnProgressBarSectionMouseOut, false, 0, true);
            this.OnProgressBarSectionMouseOut();
            this.fill.buttonMode = true;
            this.ribbon.buttonMode = true;
        }

        protected function OnProgressBarSectionMouseOut(param1:Event = null):void {
            this.isOver = false;
            TweenLite.to(this.ribbon.rewardImage0, 0.25, {"y": 0});
            TweenLite.to(this.ribbon.rewardRibbon0, 0.25, {"y": 0});
            this.SendRewardToBack(this.ribbon);
            this.redraw(0);
        }

        protected function OnProgressBarSectionMouseOver(param1:Event):void {
            this.isOver = true;
            TweenLite.to(this.ribbon.rewardImage0, 0.25, {"y": -50});
            TweenLite.to(this.ribbon.rewardRibbon0, 0.25, {
                        "y": -50,
                        "onComplete": this.BringRewardToFront,
                        "onCompleteParams": [this.ribbon]
                    });
            this.redraw(1);
        }

        private function redraw(param1:Number):void {
            this.fill.graphics.clear();
            this.fill.graphics.lineStyle(1, 11053224);
            this.fill.graphics.beginFill(MultiRewardReplayableEventUI.k_REWARD_COLOR, param1);
            this.fill.graphics.drawRect(0, 0, this.width, this.height);
        }

        private function BringRewardToFront(param1:DisplayObject):void {
            if (!this.isOver || this.backIndex >= 0 || !param1.parent)
                return;

            this.backIndex = param1.parent.getChildIndex(param1);
            param1.parent.setChildIndex(param1, param1.parent.numChildren - 1);
        }

        private function SendRewardToBack(param1:DisplayObject):void {
            if (this.backIndex < 0 || !param1.parent)
                return;

            param1.parent.setChildIndex(param1, this.backIndex);
            this.backIndex = -1;
        }
    }
}

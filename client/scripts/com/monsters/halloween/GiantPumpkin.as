package com.monsters.halloween {
    import flash.events.MouseEvent;

    public class GiantPumpkin extends BDECORATION {

        private static const SHAKE_AMOUNT:Number = 100;

        private static const FOCUS_SECONDS:Number = 1;

        private var m_wasOpened:Boolean = false;

        private var m_isLiftingLid:Boolean = false;

        public function GiantPumpkin() {
            super(HalloweenEvent.GIANT_PUMPKIN_TYPE);
        }

        override public function Export():Object {
            return null;
        }

        override public function Description():void {
            _buildingTitle = "<b>" + _buildingProps.name + "</b>";
            _specialDescription = "";
        }

        /**
         * Rests on its first frame, the lid closed, until clicked. Then it plays its animation once, the lid lifting
         * and D.A.V.E. climbing out, and holds the last frame. Decorations loop their animation
         * (BDECORATION.TickFast); this holds a frame by drawing it without advancing, as BUILDING19 holds its own.
         *
         * Its 45 frames are wrapped into rows (large-anim-6.png), as one row would be wider than Flash allows a
         * bitmap to be. BFOUNDATION only steps along the first row, so the frame's row is selected here and
         * BFOUNDATION draws its column.
         */
        override public function AnimFrame(param1:Boolean = true):void {
            if (!_animBMD || !_animRect) {
                super.AnimFrame(param1);
                return;
            }

            var frame:int = _animTick;
            var framesPerRow:int = Math.max(1, int(_animBMD.width / _animRect.width));
            var isOnLastFrame:Boolean = frame >= _animFrames - 1;

            _animRect.y = int(frame / framesPerRow) * _animRect.height;
            _animTick = frame % framesPerRow;
            super.AnimFrame(false);

            var shouldAdvance:Boolean = param1 && m_isLiftingLid && !isOnLastFrame;

            _animTick = shouldAdvance ? frame + 1 : frame;
        }

        override public function Click(param1:MouseEvent = null):void {
            if (MAP._dragged)
                return;

            dare();
        }

        public function dare():void {
            if (m_wasOpened)
                return;

            new HalloweenDarePopup().Show(open, HalloweenEvent.sawDare);
        }

        private function open():void {
            if (m_wasOpened)
                return;

            m_wasOpened = true;
            MAP.FocusTo(_mc.x, _mc.y, FOCUS_SECONDS, 0, 0, true, startOpening);
        }

        private function startOpening():void {
            m_isLiftingLid = true;
            BASE.Shake(SHAKE_AMOUNT);
        }
    }
}

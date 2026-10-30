package com.monsters.halloween {
    import com.monsters.configs.BYMConfig;
    import com.monsters.pathing.PATHING;
    import flash.display.StageDisplayState;
    import flash.events.MouseEvent;

    public class GiantPumpkin extends BDECORATION {

        private static const SHAKE_AMOUNT:Number = 100;

        private static const FOCUS_SECONDS:Number = 1;

        private var m_wasOpened:Boolean = false;

        private var m_isLiftingLid:Boolean = false;

        private var m_hasExploded:Boolean = false;

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
        override public function AnimFrame(advance:Boolean = true):void {
            if (!_animBMD || !_animRect) {
                super.AnimFrame(advance);
                return;
            }

            var frame:int = _animTick;
            var framesPerRow:int = Math.max(1, int(_animBMD.width / _animRect.width));
            var isOnLastFrame:Boolean = frame >= _animFrames - 1;

            _animRect.y = int(frame / framesPerRow) * _animRect.height;
            _animTick = frame % framesPerRow;
            super.AnimFrame(false);

            var shouldAdvance:Boolean = advance && m_isLiftingLid && !isOnLastFrame;

            _animTick = shouldAdvance ? frame + 1 : frame;

            if (m_isLiftingLid && isOnLastFrame && !m_hasExploded) {
                m_hasExploded = true;
                HalloweenExplosion.play(HalloweenEvent.pumpkinExploded);
            }
        }

        /**
         * Keeps the pumpkin drawn while the yard shakes. The renderer skips a layer it judges off screen
         * (MAP.viewRect), and the shake moves the ground after the view is worked out, so the pumpkin's tall
         * animation, out past the yard's corner, blinked off and on. It's one building, so it's drawn whenever it's
         * shown and the canvas clips it.
         */
        override protected function updateRasterData():void {
            super.updateRasterData();

            if (!BYMConfig.instance.RENDERER_ON || !_mc)
                return;

            for (var i:int = _RASTERDATA_SHADOW + 1; i < _RASTERDATA_AMOUNT; i++) {
                if (_rasterData[i] && _rasterPt[i])
                    _rasterData[i].visible = _sources[i] && !_sources[i].visible ? false : _mc.visible;
            }
        }

        override public function Click(event:MouseEvent = null):void {
            if (MAP._dragged)
                return;

            dare();
        }

        public function dare():void {
            if (m_wasOpened)
                return;

            new HalloweenDarePopup().Show(open);
        }

        private function open():void {
            if (m_wasOpened)
                return;

            m_wasOpened = true;
            POPUPS.Hold();
            HalloweenEvent.claimGoodieBag();
            goFullscreen();
            SOUNDS.StopMusic();
            MAP.FocusTo(_mc.x, _mc.y, FOCUS_SECONDS, 0, 0, true, startOpening);
        }

        /**
         * Puts the game in fullscreen for the show, unless it already is (GLOBAL.goFullScreen toggles, so it would take
         * it out). Flash only allows it inside a click, so this runs straight from the dare's "Open the Pumpkin"; a
         * player or host that refuses it leaves the game windowed.
         */
        private function goFullscreen():void {
            if (GLOBAL._ROOT.stage.displayState != StageDisplayState.NORMAL)
                return;

            try {
                GLOBAL.goFullScreen();
            }
            catch (e:SecurityError) {
            }
        }

        public function remove():void {
            GridCost(false);
            PATHING.ResetCosts();
            clear();
        }

        private function startOpening():void {
            m_isLiftingLid = true;
            BASE.Shake(SHAKE_AMOUNT);
        }
    }
}

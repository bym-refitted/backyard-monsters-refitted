package {
    import com.monsters.configs.BYMConfig;
    import com.monsters.rendering.RasterData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import gs.TweenLite;

    /**
     * The blue ripple a Quake Tower sends out when it fires: three rings that spread to the
     * tower's range over a second and fade as they go.
     */
    public class QuakeGraphic {

        public var graphic:Shape;

        protected var m_rasterData:RasterData;

        protected var m_rasterPt:Point;

        /**
         * @param size How wide the rings start out, in pixels across half the outer ring
         * @param range How far the rings spread before they are gone
         * @param rasterPt Where the renderer should draw the ripple. Leave out when the
         *                 bitmap renderer is off and the ripple is added to a display object.
         */
        public function QuakeGraphic(size:uint, range:uint, rasterPt:Point = null) {
            var wrapper:Sprite = null;
            super();
            this.graphic = new Shape();
            this.graphic.graphics.lineStyle(0.3, 6710988, 0.5);
            this.graphic.graphics.drawEllipse(-size, -size / 2, size * 2, size);
            this.graphic.graphics.drawEllipse(-size * 0.8, -size / 2.5, size * 1.6, size * 0.8);
            this.graphic.graphics.drawEllipse(-size * 0.6, -size / 3.333333, size * 1.2, size * 0.6);
            var glow:GlowFilter = new GlowFilter(3379402, 1, 20, 20, 5 + Math.random() * 5, 1, false, false);
            this.graphic.filters = [glow];
            TweenLite.to(this.graphic, 1, {
                        "width": range * 2,
                        "height": range,
                        "alpha": 0,
                        "onComplete": this.onComplete
                    });
            if (BYMConfig.instance.RENDERER_ON && Boolean(rasterPt)) {
                wrapper = new Sprite();
                wrapper.addChild(this.graphic);
                this.m_rasterPt = rasterPt;
                this.m_rasterData = new RasterData(wrapper, this.m_rasterPt, MAP.DEPTH_SHADOW + 1);
            }
        }

        /**
         * Moves the ripple the renderer is drawing. Does nothing once it has faded, or when
         * the bitmap renderer is off and the ripple moves with whatever it was added to.
         *
         * @param x Where to draw it on the canvas
         * @param y Where to draw it on the canvas
         * @param depth Its place in the draw order
         */
        public function moveTo(x:Number, y:Number, depth:Number):void {
            if (this.m_rasterData) {
                this.m_rasterPt.x = x;
                this.m_rasterPt.y = y;
                this.m_rasterData.depth = depth;
            }
        }

        private function onComplete():void {
            this.graphic.parent.removeChild(this.graphic);
            this.graphic.filters = [];
            this.graphic = null;
            if (this.m_rasterData) {
                this.m_rasterData.clear();
            }
            this.m_rasterData = null;
            this.m_rasterPt = null;
        }
    }
}

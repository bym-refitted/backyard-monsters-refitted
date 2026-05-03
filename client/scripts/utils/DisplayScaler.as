package utils
{
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.system.Capabilities;
    import com.monsters.enums.EnumPlayerType;

    public class DisplayScaler
    {
        // Calibrated so getUIScale() returns 1.8 at FHD+ (1080px stage height),
        // which matched the developer's empirically chosen scale on that device.
        // 1080 / 1.8 = 600.
        private static const DESIGN_HEIGHT:Number = 600;

        // Cached stage reference — set via init() before any UI is created
        private static var _stage:Stage;

        /**
         * Call once (and again on resize) with the live stage so getUIScale()
         * reads the actual rendered dimensions instead of Capabilities, which
         * reports hardware-max on Samsung devices regardless of the resolution
         * setting chosen by the user.
         */
        public static function init(stage:Stage):void
        {
            _stage = stage;
        }

        /**
         * Returns a scale factor derived directly from the design canvas.
         * Prefers stage dimensions (accurate per resolution setting) over
         * Capabilities (reports hardware max on Samsung, never updates).
         *
         * @return scale factor for this device
         */
        public static function getUIScale():Number
        {
            if (Capabilities.playerType != EnumPlayerType.DESKTOP) return 1.0;
            var shortEdge:Number;
            if (_stage != null && _stage.stageWidth > 0 && _stage.stageHeight > 0)
            {
                shortEdge = Math.min(_stage.stageWidth, _stage.stageHeight);
            }
            else
            {
                var w:Number = Capabilities.screenResolutionX;
                var h:Number = Capabilities.screenResolutionY;
                shortEdge = Math.min(w, h);
            }
            if (shortEdge <= 0) shortEdge = DESIGN_HEIGHT;
            return Math.max(0.5, Math.min(shortEdge / DESIGN_HEIGHT, 5.0));
        }

        /*
         * Applies the UI scale factor directly to a DisplayObject.
         *
         * @param element Display object to scale
         */
        public static function scaleElement(element:DisplayObject):void
        {
            var scale:Number = getUIScale();
            element.scaleX = element.scaleY = scale;
        }

        /*
         * Scales a design-time value (spacing, offsets, sizes) to match
         * the current screen density.
         *
         * @param designValue Value from the design canvas (e.g. 90px spacing)
         * @return Pixel value for the current device
         */
        public static function scaleValue(designValue:Number):Number
        {
            return designValue * getUIScale();
        }
    }
}

package utils
{
    import flash.display.DisplayObject;
    import flash.system.Capabilities;
    import flash.display.Stage;

    public class DisplayScaler
    {
        private static const DESIGN_WIDTH:Number = 360;

        private static const DESIGN_HEIGHT:Number = 640;

        private static const GLOBAL_SCALE_MULTIPLIER:Number = 1.0;

        /*
         * Calculates a UI scale factor based on the design canvas.
         * This ensures consistent UI sizing across devices by scaling
         * relative to the base design resolution.
         *
         * @return scale factor for this device
         */
        public static function getUIScale():Number
        {
            if (Capabilities.playerType != "Desktop")
            {
                return 1.0;
            }

            var screenWidth:Number = Capabilities.screenResolutionX;
            var screenHeight:Number = Capabilities.screenResolutionY;

            var scaleX:Number = screenWidth / DESIGN_WIDTH;
            var scaleY:Number = screenHeight / DESIGN_HEIGHT;
            var scale:Number = Math.min(scaleX, scaleY) * GLOBAL_SCALE_MULTIPLIER;

            return Math.max(0.5, Math.min(scale, 2.5));
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
         * Scales a design-time value (like spacing, offsets, sizes)
         * to match the current UI scale.
         *
         * @param designValue The value from your design (e.g. 90px spacing)
         * @return Scaled value for current device
         */
        public static function scaleValue(designValue:Number):Number
        {
            return designValue * getUIScale();
        }
    }
}

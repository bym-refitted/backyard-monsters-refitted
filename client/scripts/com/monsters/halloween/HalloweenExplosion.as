package com.monsters.halloween {
    import com.monsters.display.ImageCache;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import gs.TweenLite;
    import gs.easing.Quad;
    import gs.easing.Sine;

    public class HalloweenExplosion {

        public static const IMAGE:String = "events/halloween/hwn_explosion.png";

        public static const LIGHT_IMAGE:String = "events/halloween/hwn_light.png";

        public static const CRATER_IMAGE:String = "events/halloween/hwn_crater.png";

        public static const SCORCH_IMAGE:String = "events/halloween/hwn_scorch.png";

        private static const CRATER_OFFSET:Point = new Point(1.5, -6);

        private static const CRATER_SCALE:Number = 0.755;

        private static const SCORCH_SCALE:Number = 2;

        private static const LIGHT_OFFSET:Point = new Point(-18, 75);

        private static const LIGHT_SCALE:Number = 1.3 / 1.11;

        /**
         * The light is a soft wash, so it's saved at half size and drawn at twice that, as the scorch is.
         */
        private static const LIGHT_IMAGE_SCALE:Number = 2;

        private static const BASE_SCALE:Number = 1.3;

        private static const GROWTH:Number = 1.19;

        private static const RISE:Number = 34;

        private static const SHIFT:Number = 40;

        private static const CRATER_SHIFT:Number = 20;

        private static const YARD_MIDDLE:Point = new Point(0, 0);

        private static const WHITE_HOLD_SECONDS:Number = 1.4;

        private static const WHITE_OUT_SECONDS:Number = 2.6;

        private static const BEAMS_OUT_SECONDS:Number = 4.5;

        private static const HOLD_SECONDS:Number = 10;

        private static const FADE_OUT_SECONDS:Number = 2;

        private static const CRATER_HOLD_SECONDS:Number = 10;

        private static const SHAKE_AMOUNT:Number = 100;

        private static const ZOOM_OUT:Number = 0.5;

        private static var s_layer:Sprite;

        private static var s_explosion:Sprite;

        private static var s_light:Sprite;

        private static var s_crater:Sprite;

        private static var s_inputBlocker:Sprite;

        private static var s_white:Shape;

        private static var s_onComplete:Function;

        private static var s_wasZoomed:Boolean;

        /**
         * The show's images are only seen once a year, so they're freed from the image cache once it's over.
         */
        private static function releaseImages():void {
            ImageCache.Release(IMAGE);
            ImageCache.Release(LIGHT_IMAGE);
            ImageCache.Release(CRATER_IMAGE);
            ImageCache.Release(SCORCH_IMAGE);
        }

        public static function preload():void {
            ImageCache.GetImageWithCallBack(IMAGE, null);
            ImageCache.GetImageWithCallBack(LIGHT_IMAGE, null);
            ImageCache.GetImageWithCallBack(CRATER_IMAGE, null);
            ImageCache.GetImageWithCallBack(SCORCH_IMAGE, null);
        }

        public static function play(onComplete:Function = null):void {
            s_onComplete = onComplete;

            lockYard();
            UI2.Hide("top");
            UI2.Hide("bottom");

            s_white = new Shape();
            s_white.graphics.beginFill(0xffffff);
            s_white.graphics.drawRect(GLOBAL._SCREEN.x, GLOBAL._SCREEN.y, GLOBAL._SCREEN.width, GLOBAL._SCREEN.height);
            s_white.graphics.endFill();
            GLOBAL._layerTop.addChild(s_white);

            whiteScreen();
        }

        private static function whiteScreen():void {
            zoomOut();
            MAP.FocusTo(YARD_MIDDLE.x, YARD_MIDDLE.y, 0.01);
            TweenLite.delayedCall(WHITE_HOLD_SECONDS, explode);
        }

        private static function explode():void {
            s_layer = createLayer();
            MAP._EFFECTSTOP.addChild(s_layer);

            s_light = new Sprite();
            s_light.x = SHIFT + LIGHT_OFFSET.x * LIGHT_SCALE;
            s_light.y = LIGHT_OFFSET.y * LIGHT_SCALE;
            s_light.scaleX = s_light.scaleY = LIGHT_SCALE;
            s_layer.addChild(s_light);

            ImageCache.GetImageWithCallBack(LIGHT_IMAGE, function(url:String, image:BitmapData):void {
                    var bitmap:Bitmap = new Bitmap(image, "auto", true);
                    bitmap.scaleX = bitmap.scaleY = LIGHT_IMAGE_SCALE;
                    bitmap.x = -image.width * LIGHT_IMAGE_SCALE * 0.5;
                    bitmap.y = -image.height * LIGHT_IMAGE_SCALE * 0.5;
                    s_light.addChild(bitmap);
                });

            s_explosion = new Sprite();
            s_explosion.x = SHIFT;
            s_explosion.scaleX = s_explosion.scaleY = BASE_SCALE;
            s_layer.addChild(s_explosion);

            ImageCache.GetImageWithCallBack(IMAGE, function(url:String, image:BitmapData):void {
                    var bitmap:Bitmap = new Bitmap(image, "auto", true);
                    bitmap.x = -image.width * 0.5;
                    bitmap.y = -image.height * 0.5;
                    s_explosion.addChild(bitmap);
                });

            SOUNDS.Play("destroytownhall");

            TweenLite.to(s_white, WHITE_OUT_SECONDS, {"alpha": 0, "ease": Quad.easeIn, "onComplete": removeWhite});
            TweenLite.to(s_light, BEAMS_OUT_SECONDS, {"alpha": 0, "ease": Quad.easeIn});
            TweenLite.to(s_explosion, HOLD_SECONDS, {
                        "scaleX": BASE_SCALE * GROWTH,
                        "scaleY": BASE_SCALE * GROWTH,
                        "y": -RISE,
                        "ease": Sine.easeOut
                    });

            s_layer.addEventListener(Event.ENTER_FRAME, rumble);
            TweenLite.delayedCall(HOLD_SECONDS, fadeOut);
        }

        private static function removeWhite():void {
            if (s_white && s_white.parent)
                s_white.parent.removeChild(s_white);

            s_white = null;
        }

        private static function rumble(e:Event):void {
            BASE.Shake(SHAKE_AMOUNT);
        }

        /**
         * The explosion fades away as the crater it left fades in beneath it.
         */
        private static function fadeOut():void {
            s_layer.removeEventListener(Event.ENTER_FRAME, rumble);

            s_crater = createLayer();
            s_crater.alpha = 0;
            MAP._EFFECTSTOP.addChildAt(s_crater, MAP._EFFECTSTOP.getChildIndex(s_layer));

            var crater:Sprite = new Sprite();
            crater.x = CRATER_SHIFT - CRATER_OFFSET.x * BASE_SCALE * CRATER_SCALE;
            crater.y = -CRATER_OFFSET.y * BASE_SCALE * CRATER_SCALE;
            crater.scaleX = crater.scaleY = BASE_SCALE * CRATER_SCALE;
            s_crater.addChild(crater);

            var scorch:Sprite = new Sprite();
            scorch.x = CRATER_OFFSET.x;
            scorch.y = CRATER_OFFSET.y;
            scorch.scaleX = scorch.scaleY = SCORCH_SCALE;
            crater.addChild(scorch);

            ImageCache.GetImageWithCallBack(SCORCH_IMAGE, function(url:String, image:BitmapData):void {
                    var bitmap:Bitmap = new Bitmap(image, "auto", true);
                    bitmap.x = -image.width * 0.5;
                    bitmap.y = -image.height * 0.5;
                    scorch.addChild(bitmap);
                });

            ImageCache.GetImageWithCallBack(CRATER_IMAGE, function(url:String, image:BitmapData):void {
                    var bitmap:Bitmap = new Bitmap(image, "auto", true);
                    bitmap.x = -image.width * 0.5;
                    bitmap.y = -image.height * 0.5;
                    crater.addChild(bitmap);
                });

            TweenLite.to(s_crater, FADE_OUT_SECONDS, {"alpha": 1});
            TweenLite.to(s_layer, FADE_OUT_SECONDS, {"alpha": 0, "onComplete": exploded});
        }

        private static function exploded():void {
            if (s_layer && s_layer.parent)
                s_layer.parent.removeChild(s_layer);

            s_layer = null;
            s_explosion = null;
            s_light = null;

            TweenLite.delayedCall(CRATER_HOLD_SECONDS, finished);
        }

        private static function finished():void {
            if (s_crater && s_crater.parent)
                s_crater.parent.removeChild(s_crater);

            s_crater = null;
            releaseImages();
            zoomBack();
            unlockYard();

            UI2.Show("top");
            UI2.Show("bottom");

            var onComplete:Function = s_onComplete;
            s_onComplete = null;

            if (onComplete != null)
                onComplete();
        }

        private static function createLayer():Sprite {
            var layer:Sprite = new Sprite();

            layer.x = YARD_MIDDLE.x;
            layer.y = YARD_MIDDLE.y;
            layer.scaleX = layer.scaleY = 1 / ZOOM_OUT;
            layer.mouseEnabled = false;
            layer.mouseChildren = false;

            return layer;
        }

        private static function zoomOut():void {
            s_wasZoomed = GLOBAL._zoomed;

            if (s_wasZoomed)
                return;

            GLOBAL._zoomed = true;
            UI2._top.mcZoom.gotoAndStop(2);
            MAP._GROUND.scaleX = MAP._GROUND.scaleY = ZOOM_OUT;
        }

        private static function zoomBack():void {
            if (s_wasZoomed)
                return;

            GLOBAL._zoomed = false;
            UI2._top.mcZoom.gotoAndStop(1);
            MAP._GROUND.scaleX = MAP._GROUND.scaleY = 1;
            MAP.FocusTo(YARD_MIDDLE.x, YARD_MIDDLE.y, 0.01);
        }

        private static function lockYard():void {
            MAP._canScroll = false;

            s_inputBlocker = new Sprite();
            s_inputBlocker.graphics.beginFill(0, 0);
            s_inputBlocker.graphics.drawRect(GLOBAL._SCREEN.x, GLOBAL._SCREEN.y, GLOBAL._SCREEN.width, GLOBAL._SCREEN.height);
            s_inputBlocker.graphics.endFill();
            GLOBAL._layerTop.addChild(s_inputBlocker);

            GLOBAL._ROOT.stage.addEventListener(MouseEvent.MOUSE_WHEEL, blockWheel, true, int.MAX_VALUE);
        }

        private static function unlockYard():void {
            MAP._canScroll = true;

            if (s_inputBlocker && s_inputBlocker.parent)
                s_inputBlocker.parent.removeChild(s_inputBlocker);

            s_inputBlocker = null;
            GLOBAL._ROOT.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, blockWheel, true);
        }

        private static function blockWheel(e:MouseEvent):void {
            e.stopImmediatePropagation();
        }
    }
}

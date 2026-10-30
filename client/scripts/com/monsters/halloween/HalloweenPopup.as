package com.monsters.halloween {
    import com.monsters.display.ImageCache;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import gs.TweenLite;
    import gs.easing.Back;
    import gs.easing.Quad;

    public class HalloweenPopup {
        private static const SCALE:Number = 0.66;

        private static const CORNER:int = 12;

        private static const FILL:uint = 0xff7e01;

        private static const BORDER_TOP:uint = 0x8a5a1c;

        private static const BORDER_BOTTOM:uint = 0x4b2c00;

        private static const BEVEL_TOP:uint = 0xd47326;

        private static const BEVEL_BOTTOM:uint = 0xb35c05;

        protected static const TITLE_COLOUR:uint = 0x140000;

        private static const BODY_COLOUR:uint = 0x350000;

        protected static const TITLE_SIZE:int = 30;

        private static const BODY_LEADING:int = 2;

        private static const BUTTON_HEIGHT:int = 47;

        private static const SHADOW:uint = 0x1e1a05;

        private static const CLOSE_INSET:int = 17;

        private static const CLOSE_RADIUS:Number = 23;

        private static const CLOSE_RING:Number = 4.5;

        private static const CLOSE_RED:uint = 0xb81c10;

        private static const CLOSE_CROSS_RED:uint = 0xc01010;

        private static const CLOSE_CROSS_ARM:Number = 8;

        private static const CLOSE_CROSS_THICKNESS:Number = 4.5;

        private static const DODGE_TILT:Number = -25;

        private static const DODGE_TILT_SECONDS:Number = 0.15;

        private static const DODGE_FADE_SECONDS:Number = 0.3;

        private static const GHOST:String = "events/halloween/hwn_dare_ghost.png";

        protected var m_centreHeight:Number = 0.5;

        protected var m_isCloseTrick:Boolean = false;

        protected var m_boxWidth:int;

        protected var m_boxHeight:int = 217;

        protected var m_textX:int = 24;

        protected var m_textWidth:int;

        protected var m_title:String;

        protected var m_titleY:int = 14;

        protected var m_isTitleCentred:Boolean = false;

        protected var m_body:String;

        protected var m_bodySize:int;

        protected var m_bodyY:int;

        protected var m_isBodyBold:Boolean = false;

        protected var m_bodyColour:uint = BODY_COLOUR;

        protected var m_buttonLabel:String;

        protected var m_buttonX:int;

        protected var m_buttonY:int;

        protected var m_buttonWidth:int;

        protected var m_graphic:String = GHOST;

        protected var m_graphicX:int;

        protected var m_graphicY:int = -27;

        protected var m_graphicScale:Number = 1;

        protected var m_bodyField:TextField;

        private var m_mc:MovieClip;

        private var m_box:MovieClip;

        private var m_onButton:Function;

        private var m_onClosed:Function;

        public function Show(onButton:Function = null, onClosed:Function = null):void {
            m_onButton = onButton;
            m_onClosed = onClosed;
            m_mc = new MovieClip();

            var box:MovieClip = m_mc.addChild(new MovieClip()) as MovieClip;
            m_box = box;
            box.scaleX = box.scaleY = SCALE;
            box.x = -int(m_boxWidth * SCALE * 0.5);
            box.y = -int(m_boxHeight * SCALE * 0.5);
            drawBox(box);

            if (m_isTitleCentred)
                addText(box, m_title, TITLE_SIZE, true, true, 0, m_titleY, m_boxWidth, TextFormatAlign.CENTER);
            else
                addText(box, m_title, TITLE_SIZE, true, true, m_textX, m_titleY, m_textWidth);

            m_bodyField = addText(box, m_body, m_bodySize, false, m_isBodyBold, m_textX, m_bodyY, m_textWidth);

            var button:Button_CLIP = box.addChild(new Button_CLIP()) as Button_CLIP;
            button.Setup(m_buttonLabel, false, m_buttonWidth, BUTTON_HEIGHT);
            button.x = m_buttonX;
            button.y = m_buttonY;
            button.addEventListener(MouseEvent.CLICK, clickedButton);

            var graphic:MovieClip = box.addChild(new MovieClip()) as MovieClip;
            graphic.x = m_graphicX;
            graphic.y = m_graphicY;
            graphic.scaleX = graphic.scaleY = m_graphicScale;
            graphic.mouseEnabled = false;

            ImageCache.GetImageWithCallBack(m_graphic, function(url:String, image:BitmapData):void {
                    graphic.addChild(new Bitmap(image, "auto", true));
                });

            box.addChild(createCloseButton());

            POPUPSETTINGS.AlignToCenter(m_mc);
            placeBox();
            m_mc.addEventListener(Event.ENTER_FRAME, placeOnScreen);
            POPUPS.Push(m_mc);
        }

        /**
         * POPUPS centres the popup when it's shown, so the box is placed against that same centre up front, or it would
         * show a frame in the middle of the screen first. It's placed again on its first frame on screen in case the
         * screen changed size while it waited in the queue.
         */
        private function placeOnScreen(e:Event):void {
            if (!m_mc || !m_mc.stage)
                return;

            m_mc.removeEventListener(Event.ENTER_FRAME, placeOnScreen);
            placeBox();
        }

        private function placeBox():void {
            var centreY:Number = GLOBAL._SCREEN.y + GLOBAL._SCREEN.height * m_centreHeight;
            m_box.y = int(centreY - m_mc.y - m_boxHeight * SCALE * 0.5);
        }

        private function createCloseButton():MovieClip {
            var button:MovieClip = new MovieClip();
            var arm:Number = CLOSE_CROSS_ARM;

            button.graphics.beginFill(CLOSE_RED);
            button.graphics.drawCircle(0, 0, CLOSE_RADIUS);
            button.graphics.beginFill(0xffffff);
            button.graphics.drawCircle(0, 0, CLOSE_RADIUS - CLOSE_RING);
            button.graphics.endFill();

            button.graphics.lineStyle(CLOSE_CROSS_THICKNESS, CLOSE_CROSS_RED, 1, false, "normal", "round");
            button.graphics.moveTo(-arm, -arm);
            button.graphics.lineTo(arm, arm);
            button.graphics.moveTo(-arm, arm);
            button.graphics.lineTo(arm, -arm);

            button.x = m_boxWidth - CLOSE_INSET;
            button.y = CLOSE_INSET;
            button.buttonMode = true;

            if (m_isCloseTrick)
                button.addEventListener(MouseEvent.ROLL_OVER, dodgeClose);
            else
                button.addEventListener(MouseEvent.CLICK, clickedClose);

            return button;
        }

        protected function closeVanished():void {
        }

        private function dodgeClose(e:MouseEvent):void {
            var button:MovieClip = e.currentTarget as MovieClip;

            button.removeEventListener(MouseEvent.ROLL_OVER, dodgeClose);
            button.mouseEnabled = false;
            button.buttonMode = false;

            TweenLite.to(button, DODGE_TILT_SECONDS, {"rotation": DODGE_TILT, "ease": Back.easeOut});
            TweenLite.to(button, DODGE_FADE_SECONDS, {
                        "alpha": 0,
                        "delay": DODGE_TILT_SECONDS,
                        "ease": Quad.easeIn,
                        "overwrite": false,
                        "onComplete": function():void {
                            button.visible = false;
                            closeVanished();
                        }
                    });
        }

        private function drawBox(box:MovieClip):void {
            var shape:Shape = new Shape();
            var matrix:Matrix = new Matrix();

            shape.graphics.beginFill(SHADOW, 0.25);
            shape.graphics.drawRoundRect(5, 5, m_boxWidth, m_boxHeight, CORNER, CORNER);
            shape.graphics.beginFill(SHADOW, 0.45);
            shape.graphics.drawRoundRect(3, 3, m_boxWidth, m_boxHeight, CORNER, CORNER);

            matrix.createGradientBox(m_boxWidth, m_boxHeight, Math.PI / 2);
            shape.graphics.beginGradientFill(GradientType.LINEAR, [BORDER_TOP, BORDER_BOTTOM], [1, 1], [0, 255], matrix);
            shape.graphics.drawRoundRect(0, 0, m_boxWidth, m_boxHeight, CORNER, CORNER);

            shape.graphics.beginGradientFill(GradientType.LINEAR, [BEVEL_TOP, BEVEL_BOTTOM], [1, 1], [0, 255], matrix);
            shape.graphics.drawRoundRect(1, 1, m_boxWidth - 2, m_boxHeight - 2, CORNER - 2, CORNER - 2);

            shape.graphics.beginFill(FILL);
            shape.graphics.drawRoundRect(3, 3, m_boxWidth - 6, m_boxHeight - 6, CORNER - 4, CORNER - 4);
            shape.graphics.endFill();

            box.addChild(shape);
        }

        private function addText(box:MovieClip, html:String, size:int, isTitle:Boolean, isBold:Boolean, x:int, y:int, width:int, align:String = "left"):TextField {
            var field:TextField = box.addChild(new TextField()) as TextField;
            field.selectable = false;
            field.mouseEnabled = false;
            field.multiline = true;
            field.wordWrap = true;
            field.width = width;

            var format:TextFormat = new TextFormat(FONTS.VERDANA, size, isTitle ? TITLE_COLOUR : m_bodyColour, isBold);
            format.align = align;
            format.leading = isTitle ? 0 : BODY_LEADING;

            field.defaultTextFormat = format;
            field.htmlText = html;
            field.height = field.textHeight + 6;
            field.x = x;
            field.y = y;

            return field;
        }

        /**
         * A run of text at another size, for the bigger and smaller words in a line.
         *
         * @param {String} text - The words
         * @param {int} size - Their size
         */
        protected static function sized(text:String, size:int):String {
            return "<font size=\"" + size + "\">" + text + "</font>";
        }

        /**
         * A run of text in another colour.
         *
         * @param {String} text - The words
         * @param {uint} colour - Their colour
         */
        protected static function coloured(text:String, colour:uint):String {
            return "<font color=\"#" + ("00000" + colour.toString(16)).substr(-6) + "\">" + text + "</font>";
        }

        private function clickedButton(e:MouseEvent = null):void {
            var onButton:Function = m_onButton;

            close();

            if (onButton != null)
                onButton();
        }

        private function clickedClose(e:MouseEvent = null):void {
            close();
        }

        private function close():void {
            var onClosed:Function = m_onClosed;

            SOUNDS.Play("close");
            POPUPS.Next();

            m_mc = null;
            m_box = null;
            m_onButton = null;
            m_onClosed = null;

            if (onClosed != null)
                onClosed();
        }
    }
}

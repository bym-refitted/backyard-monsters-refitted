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

    public class HalloweenDarePopup {
        private static const SCALE:Number = 0.6;
        private static const CENTRE_HEIGHT:Number = 0.72;

        private static const BOX_WIDTH:int = 557;
        private static const BOX_HEIGHT:int = 217;
        private static const CORNER:int = 12;

        private static const FILL:uint = 0xff7e01;
        private static const BORDER_TOP:uint = 0x8a5a1c;
        private static const BORDER_BOTTOM:uint = 0x4b2c00;
        private static const BEVEL_TOP:uint = 0xd47326;
        private static const BEVEL_BOTTOM:uint = 0xb35c05;
        private static const TITLE_COLOUR:uint = 0x140000;
        private static const BODY_COLOUR:uint = 0x350000;

        private static const TEXT_X:int = 24;

        private static const TITLE_SIZE:int = 30;
        private static const TITLE_Y:int = 14;
        private static const BODY_SIZE:int = 19;
        private static const BODY_Y:int = 62;
        private static const BODY_LEADING:int = 2;
        private static const BUTTON_X:int = 14;
        private static const BUTTON_Y:int = 149;
        private static const BUTTON_WIDTH:int = 323;
        private static const BUTTON_HEIGHT:int = 47;

        private static const SHADOW:uint = 0x1e1a05;

        private static const CLOSE_X:int = BOX_WIDTH - 17;
        private static const CLOSE_Y:int = 17;
        private static const CLOSE_RADIUS:Number = 23;
        private static const CLOSE_RING:Number = 4.5;
        private static const CLOSE_RED:uint = 0xb81c10;
        private static const CLOSE_CROSS_RED:uint = 0xc01010;
        private static const CLOSE_CROSS_ARM:Number = 8;
        private static const CLOSE_CROSS_THICKNESS:Number = 4.5;

        private static const TEXT_WIDTH:int = 282;

        private static const GRAPHIC:String = "events/halloween/hwn_dare_ghost.png";
        private static const GRAPHIC_X:int = 306;
        private static const GRAPHIC_Y:int = -27;

        private var m_mc:MovieClip;

        private var m_box:MovieClip;

        private var m_onOpen:Function;

        private var m_onClosed:Function;

        public function Show(onOpen:Function, onClosed:Function = null):void {
            m_onOpen = onOpen;
            m_onClosed = onClosed;
            m_mc = new MovieClip();

            var box:MovieClip = m_mc.addChild(new MovieClip()) as MovieClip;
            m_box = box;
            box.scaleX = box.scaleY = SCALE;
            box.x = -int(BOX_WIDTH * SCALE * 0.5);
            box.y = -int(BOX_HEIGHT * SCALE * 0.5);
            drawBox(box);

            addText(box, KEYS.Get("hwn_dare_title"), TITLE_SIZE, true, TITLE_Y);
            addText(box, KEYS.Get("hwn_dare_body"), BODY_SIZE, false, BODY_Y);

            var button:Button_CLIP = box.addChild(new Button_CLIP()) as Button_CLIP;
            button.Setup(KEYS.Get("hwn_dare_btn"), false, BUTTON_WIDTH, BUTTON_HEIGHT);
            button.x = BUTTON_X;
            button.y = BUTTON_Y;
            button.addEventListener(MouseEvent.CLICK, clickedOpen);

            var graphic:MovieClip = box.addChild(new MovieClip()) as MovieClip;
            graphic.x = GRAPHIC_X;
            graphic.y = GRAPHIC_Y;
            graphic.mouseEnabled = false;
            ImageCache.GetImageWithCallBack(GRAPHIC, function(url:String, image:BitmapData):void {
                    graphic.addChild(new Bitmap(image, "auto", true));
                });

            box.addChild(createCloseButton());

            m_mc.addEventListener(Event.ENTER_FRAME, placeOnScreen);
            POPUPS.Push(m_mc);
        }

        private function placeOnScreen(e:Event):void {
            if (!m_mc || !m_mc.stage)
                return;

            m_mc.removeEventListener(Event.ENTER_FRAME, placeOnScreen);

            var centreY:Number = GLOBAL._SCREEN.y + GLOBAL._SCREEN.height * CENTRE_HEIGHT;
            m_box.y = int(centreY - m_mc.y - BOX_HEIGHT * SCALE * 0.5);
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

            button.x = CLOSE_X;
            button.y = CLOSE_Y;
            button.buttonMode = true;
            button.addEventListener(MouseEvent.CLICK, clickedClose);

            return button;
        }

        private function drawBox(box:MovieClip):void {
            var shape:Shape = new Shape();
            var matrix:Matrix = new Matrix();

            shape.graphics.beginFill(SHADOW, 0.25);
            shape.graphics.drawRoundRect(5, 5, BOX_WIDTH, BOX_HEIGHT, CORNER, CORNER);
            shape.graphics.beginFill(SHADOW, 0.45);
            shape.graphics.drawRoundRect(3, 3, BOX_WIDTH, BOX_HEIGHT, CORNER, CORNER);

            matrix.createGradientBox(BOX_WIDTH, BOX_HEIGHT, Math.PI / 2);
            shape.graphics.beginGradientFill(GradientType.LINEAR, [BORDER_TOP, BORDER_BOTTOM], [1, 1], [0, 255], matrix);
            shape.graphics.drawRoundRect(0, 0, BOX_WIDTH, BOX_HEIGHT, CORNER, CORNER);

            shape.graphics.beginGradientFill(GradientType.LINEAR, [BEVEL_TOP, BEVEL_BOTTOM], [1, 1], [0, 255], matrix);
            shape.graphics.drawRoundRect(1, 1, BOX_WIDTH - 2, BOX_HEIGHT - 2, CORNER - 2, CORNER - 2);

            shape.graphics.beginFill(FILL);
            shape.graphics.drawRoundRect(3, 3, BOX_WIDTH - 6, BOX_HEIGHT - 6, CORNER - 4, CORNER - 4);
            shape.graphics.endFill();

            box.addChild(shape);
        }

        private function addText(box:MovieClip, html:String, size:int, isTitle:Boolean, y:int):void {
            var field:TextField = box.addChild(new TextField()) as TextField;
            field.selectable = false;
            field.mouseEnabled = false;
            field.multiline = true;
            field.wordWrap = true;
            field.width = TEXT_WIDTH;
            var format:TextFormat = new TextFormat(FONTS.VERDANA, size, isTitle ? TITLE_COLOUR : BODY_COLOUR, isTitle);
            format.leading = isTitle ? 0 : BODY_LEADING;
            field.defaultTextFormat = format;
            field.htmlText = html;
            field.height = field.textHeight + 6;
            field.x = TEXT_X;
            field.y = y;
        }

        private function clickedOpen(e:MouseEvent = null):void {
            var onOpen:Function = m_onOpen;

            close();

            if (onOpen != null)
                onOpen();
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
            m_onOpen = null;
            m_onClosed = null;

            if (onClosed != null)
                onClosed();
        }
    }
}

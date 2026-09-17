package com.monsters.rendering {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;

    public class ViewportCanvas extends Sprite {
        public const origin:Point = new Point();
        private var data:BitmapData;
        private var bitmap:Bitmap;
        private const fill:Shape = new Shape();
        private const corner:Point = new Point();
        private var worldWidth:int;
        private var worldHeight:int;
        private var filled:Boolean;

        public function ViewportCanvas(initial:BitmapData) {
            data = initial;
            worldWidth = data.width;
            worldHeight = data.height;
            bitmap = new Bitmap(data);
            addChild(bitmap);
            addChild(fill);
            mouseEnabled = mouseChildren = false;
        }

        public function prepare():BitmapData {
            var matrix:Matrix = transform.concatenatedMatrix;
            var supported:Boolean = matrix.b == 0 && matrix.c == 0 && matrix.a == matrix.d && matrix.a >= 0.5 && matrix.a <= 1;
            var width:int = worldWidth;
            var height:int = worldHeight;
            var left:int = 0;
            var top:int = 0;
            if (supported) {
                var screenToWorld:Matrix = matrix.clone();
                screenToWorld.invert();
                corner.setTo(0, 0);
                var start:Point = screenToWorld.transformPoint(corner);
                corner.setTo(stage.stageWidth, stage.stageHeight);
                var end:Point = screenToWorld.transformPoint(corner);
                width = Math.min(worldWidth, Math.ceil((end.x - start.x + 128) / 64) * 64);
                height = Math.min(worldHeight, Math.ceil((end.y - start.y + 128) / 64) * 64);
                left = Math.max(0, Math.min(worldWidth - width, Math.floor(start.x / 64) * 64 - 64));
                top = Math.max(0, Math.min(worldHeight - height, Math.floor(start.y / 64) * 64 - 64));
            }
            var changed:Boolean = width != data.width || height != data.height;
            if (changed) {
                data = new BitmapData(width, height, false, 0);
                bitmap.bitmapData = data;
            }
            if (changed || left != origin.x || top != origin.y || !filled) {
                origin.setTo(left, top);
                bitmap.x = left;
                bitmap.y = top;
                fill.graphics.clear();
                fill.graphics.beginBitmapFill(data, new Matrix(1, 0, 0, 1, left, top), false, false);
                fill.graphics.drawRect(left, top, width, height);
                fill.graphics.endFill();
                filled = true;
            }
            bitmap.visible = !supported || matrix.a == 1;
            fill.visible = !bitmap.visible;
            return data;
        }
    }
}

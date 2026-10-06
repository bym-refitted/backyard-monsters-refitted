package com.monsters.rendering {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    use namespace renderer_friend;

    public class Renderer {

        renderer_friend static var _debug:Boolean;

        private static var _debugShape:Shape;

        renderer_friend var _canvas:BitmapData;

        renderer_friend var _viewRect:Rectangle;

        private const _matrix:Matrix = new Matrix();

        private const _pt:Point = new Point();

        private const _bm:Bitmap = new Bitmap();

        private const _drawBounds:Rectangle = new Rectangle();

        private var _alphaMask:BitmapData;

        private var _alphaMaskAlpha:uint;

        private var _curCopyIndex:uint;

        private var _curDrawIndex:uint;

        public function Renderer(canvas:BitmapData, viewRect:Rectangle) {
            super();
            this.renderer_friend::_canvas = canvas;
            this.renderer_friend::_viewRect = viewRect;
        }

        public static function get debug():Boolean {
            return renderer_friend::_debug;
        }

        public static function set debug(enable:Boolean):void {
            renderer_friend::_debug = enable;
            if (renderer_friend::_debug) {
                _debugShape = _debugShape || new Shape();
                RasterData.renderer_friend::showDebug();
            }
            else {
                _debugShape = null;
                RasterData.renderer_friend::hideDebug();
            }
        }

        public function set canvas(canvas:BitmapData):void {
            this.renderer_friend::_canvas = canvas;
        }

        public function dispose():void {
            if (this._alphaMask) {
                this._alphaMask.dispose();
                this._alphaMask = null;
            }
        }

        private function getAlphaMask(width:int, height:int, alpha:uint):BitmapData {
            if (!this._alphaMask || this._alphaMask.width < width || this._alphaMask.height < height) {
                if (this._alphaMask) {
                    width = Math.max(width, this._alphaMask.width);
                    height = Math.max(height, this._alphaMask.height);
                }
                var mask:BitmapData = new BitmapData(width, height, true, alpha);
                if (this._alphaMask) {
                    this._alphaMask.dispose();
                }
                this._alphaMask = mask;
                this._alphaMaskAlpha = alpha;
            }
            else if (this._alphaMaskAlpha != alpha) {
                this._alphaMask.fillRect(this._alphaMask.rect, alpha);
                this._alphaMaskAlpha = alpha;
            }
            return this._alphaMask;
        }

        public function render():void {
            var visibleData:Vector.<RasterData> = RasterData.renderer_friend::s_visibleData;
            this._curCopyIndex = this._curDrawIndex = 0;
            if (RasterData.renderer_friend::s_needsSort) {
                visibleData.sort(this.sortRasterData);
                RasterData.renderer_friend::s_needsSort = false;
            }
            this.renderer_friend::_canvas.lock();
            this.rasterize(RasterData.renderer_friend::s_unsortedData.concat(visibleData));
            this.renderer_friend::_canvas.unlock();
        }

        private function cull(entries:Vector.<RasterData>):void {
            for each (var entry:RasterData in entries) {
                var bounds:Rectangle = entry.renderer_friend::_rect;
                bounds.x = entry.renderer_friend::_pt.x;
                bounds.y = entry.renderer_friend::_pt.y;

                if (this.renderer_friend::_viewRect.intersects(bounds)) {
                    entries[entries.length] = entry;
                }
            }
        }

        private function sortRasterData(data1:RasterData, data2:RasterData):Number {
            return data1.renderer_friend::_depth - data2.renderer_friend::_depth;
        }

        private function rasterize(entries:Vector.<RasterData>):void {
            for each (var entry:RasterData in entries) {
                if (!entry || entry.renderer_friend::_cleared || !entry.renderer_friend::_pt) {
                    continue;
                }

                var entryBmd:BitmapData = entry.renderer_friend::_data as BitmapData;
                this._pt.x = entry.renderer_friend::_pt.x;
                this._pt.y = entry.renderer_friend::_pt.y;

                if (entryBmd && !entry.renderer_friend::_blendMode && !entry.renderer_friend::_filter && (entry.renderer_friend::_scaleX & entry.renderer_friend::_scaleY) === 100) {
                    var alphaMask:BitmapData = null;
                    if (entry.renderer_friend::_alpha !== 0xff000000) {
                        alphaMask = this.getAlphaMask(entryBmd.width, entryBmd.height, entry.renderer_friend::_alpha);
                    }

                    this.renderer_friend::_canvas.copyPixels(entryBmd, entryBmd.rect, this._pt, alphaMask);

                }
                else {
                    this._matrix.createBox(entry.renderer_friend::_scaleX * 0.01, entry.renderer_friend::_scaleY * 0.01, 0, this._pt.x, this._pt.y);

                    if (Boolean(entry.renderer_friend::_filter) && Boolean(entryBmd)) {
                        this._bm.bitmapData = entryBmd;
                        this._bm.filters = [entry.renderer_friend::_filter];
                        this.renderer_friend::_canvas.draw(this._bm, this._matrix, null, entry.renderer_friend::_blendMode);
                    }
                    else if (entryBmd) {
                        var right:Number = this._pt.x + entryBmd.width * this._matrix.a;
                        var bottom:Number = this._pt.y + entryBmd.height * this._matrix.d;
                        // Round outward and keep a pixel of padding at transformed edges.
                        this._drawBounds.x = Math.floor(Math.min(this._pt.x, right)) - 1;
                        this._drawBounds.y = Math.floor(Math.min(this._pt.y, bottom)) - 1;
                        this._drawBounds.width = Math.ceil(Math.max(this._pt.x, right)) + 1 - this._drawBounds.x;
                        this._drawBounds.height = Math.ceil(Math.max(this._pt.y, bottom)) + 1 - this._drawBounds.y;
                        this.renderer_friend::_canvas.draw(entryBmd, this._matrix, null, entry.renderer_friend::_blendMode, this._drawBounds);
                    }
                    else {
                        this.renderer_friend::_canvas.draw(entry.renderer_friend::_data, this._matrix, null, entry.renderer_friend::_blendMode);
                    }
                }
            }
        }
    }
}

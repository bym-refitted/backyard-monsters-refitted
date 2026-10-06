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

        private const _copyBounds:Rectangle = new Rectangle();

        private const _groundCache:GroundRasterCache = new GroundRasterCache();

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
            this._groundCache.dispose();
            this.renderer_friend::_canvas = canvas;
        }

        public function dispose():void {
            this._groundCache.dispose();
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
            var groundEntries:Vector.<RasterData> = RasterData.renderer_friend::s_unsortedData;
            var cachedEntryCount:int = this._groundCache.render(groundEntries, this, this.renderer_friend::_canvas);
            this.rasterize(groundEntries.concat(visibleData), null, cachedEntryCount);
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

        renderer_friend function rasterize(entries:Vector.<RasterData>, clip:Rectangle = null, start:int = 0, target:BitmapData = null):void {
            var canvas:BitmapData = target || this.renderer_friend::_canvas;
            for (var index:int = start; index < entries.length; ++index) {
                var entry:RasterData = entries[index];
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

                    this._copyBounds.setTo(0, 0, entryBmd.width, entryBmd.height);
                    if (clip) {
                        this._copyBounds.x = Math.max(0, clip.x - this._pt.x);
                        this._copyBounds.y = Math.max(0, clip.y - this._pt.y);
                        this._copyBounds.width = Math.min(entryBmd.width, clip.right - this._pt.x) - this._copyBounds.x;
                        this._copyBounds.height = Math.min(entryBmd.height, clip.bottom - this._pt.y) - this._copyBounds.y;
                        this._pt.x += this._copyBounds.x;
                        this._pt.y += this._copyBounds.y;
                    }
                    if (this._copyBounds.width > 0 && this._copyBounds.height > 0) {
                        canvas.copyPixels(entryBmd, this._copyBounds, this._pt, alphaMask);
                    }

                }
                else {
                    this._matrix.createBox(entry.renderer_friend::_scaleX * 0.01, entry.renderer_friend::_scaleY * 0.01, 0, this._pt.x, this._pt.y);

                    if (Boolean(entry.renderer_friend::_filter) && Boolean(entryBmd)) {
                        this._bm.bitmapData = entryBmd;
                        this._bm.filters = [entry.renderer_friend::_filter];
                        
                        canvas.draw(this._bm, this._matrix, null, entry.renderer_friend::_blendMode, clip);
                    }
                    else if (entryBmd) {
                        var right:Number = this._pt.x + entryBmd.width * this._matrix.a;
                        var bottom:Number = this._pt.y + entryBmd.height * this._matrix.d;
                        // Round outward and keep a pixel of padding at transformed edges.
                        this._drawBounds.x = Math.floor(Math.min(this._pt.x, right)) - 1;
                        this._drawBounds.y = Math.floor(Math.min(this._pt.y, bottom)) - 1;
                        this._drawBounds.width = Math.ceil(Math.max(this._pt.x, right)) + 1 - this._drawBounds.x;
                        this._drawBounds.height = Math.ceil(Math.max(this._pt.y, bottom)) + 1 - this._drawBounds.y;
                        if (clip) {
                            right = Math.min(this._drawBounds.right, clip.right);
                            bottom = Math.min(this._drawBounds.bottom, clip.bottom);
                            this._drawBounds.x = Math.max(this._drawBounds.x, clip.x);
                            this._drawBounds.y = Math.max(this._drawBounds.y, clip.y);
                            this._drawBounds.width = right - this._drawBounds.x;
                            this._drawBounds.height = bottom - this._drawBounds.y;
                        }
                        if (this._drawBounds.width > 0 && this._drawBounds.height > 0) {
                            canvas.draw(entryBmd, this._matrix, null, entry.renderer_friend::_blendMode, this._drawBounds);
                        }
                    }
                    else {
                        canvas.draw(entry.renderer_friend::_data, this._matrix, null, entry.renderer_friend::_blendMode, clip);
                    }
                }
            }
        }
    }
}

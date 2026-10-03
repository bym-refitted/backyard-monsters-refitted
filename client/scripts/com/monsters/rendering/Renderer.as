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
        private const _origin:Point = new Point();
        private var _worldCanvas:BitmapData;
        private var _worldWidth:int;
        private var _worldHeight:int;
        private const _worldRegion:Rectangle = new Rectangle();
        private const _localRegion:Rectangle = new Rectangle();
        private const _worldPoint:Point = new Point();
        private const _localPoint:Point = new Point();
        private const _single:Vector.<RasterData> = new Vector.<RasterData>(1, true);

        public function setViewport(target:BitmapData, origin:Point):void {
            this._canvas = target;
            this._origin.setTo(origin.x, origin.y);
        }

        public function dispose():void {
            this._groundCache.dispose();
            if (this._worldCanvas)
                this._worldCanvas.dispose();
            this._worldCanvas = null;
            this._single[0] = null;
        }

        private var _curCopyIndex:uint;

        private var _curDrawIndex:uint;

        public function Renderer(param1:BitmapData, param2:Rectangle) {
            super();
            this.renderer_friend::_canvas = param1;
            this._origin.setTo(0, 0);
            this.renderer_friend::_viewRect = param2;
        }

        public static function get debug():Boolean {
            return renderer_friend::_debug;
        }

        public static function set debug(param1:Boolean):void {
            renderer_friend::_debug = param1;
            if (renderer_friend::_debug) {
                _debugShape = _debugShape || new Shape();
                RasterData.renderer_friend::showDebug();
            }
            else {
                _debugShape = null;
                RasterData.renderer_friend::hideDebug();
            }
        }

        public function set canvas(param1:BitmapData):void {
            this.dispose();
            this.renderer_friend::_canvas = param1;
            this._origin.setTo(0, 0);
        }

        public function render():void {
            var _loc1_:Vector.<RasterData> = RasterData.renderer_friend::s_visibleData;
            this._curCopyIndex = this._curDrawIndex = 0;
            if (RasterData.renderer_friend::s_needsSort) {
                _loc1_.sort(this.sortRasterData);
                RasterData.renderer_friend::s_needsSort = false;
            }
            this.renderer_friend::_canvas.lock();
            var ground:Vector.<RasterData> = RasterData.renderer_friend::s_unsortedData;
            var base:BitmapData = ground.length && ground[0] ? ground[0]._data as BitmapData : null;
            this._worldWidth = Math.max(this._origin.x + this._canvas.width, base ? base.width : 0);
            this._worldHeight = Math.max(this._origin.y + this._canvas.height, base ? base.height : 0);
            var cached:int = this._groundCache.render(ground, this, this.renderer_friend::_canvas, this._origin);
            this.rasterize(ground, null, cached);
            this.rasterize(_loc1_);
            this.renderer_friend::_canvas.unlock();
        }

        private function cull(param1:Vector.<RasterData>):void {
            var _loc3_:RasterData = null;
            var _loc4_:Rectangle = null;
            var _loc2_:Vector.<RasterData> = param1;
            for each (_loc3_ in _loc2_) {
                (_loc4_ = _loc3_.renderer_friend::_rect).x = _loc3_.renderer_friend::_pt.x;
                _loc4_.y = _loc3_.renderer_friend::_pt.y;
                if (this.renderer_friend::_viewRect.intersects(_loc4_)) {
                    _loc2_[_loc2_.length] = _loc3_;
                }
            }
        }

        private function sortRasterData(param1:RasterData, param2:RasterData):Number {
            return param1.renderer_friend::_depth - param2.renderer_friend::_depth;
        }

        renderer_friend function rasterize(param1:Vector.<RasterData>, clip:Rectangle = null, start:int = 0, target:BitmapData = null):void {
            var entries:Vector.<RasterData> = null;
            var entry:RasterData = null;
            var entryBmd:BitmapData = null;
            var alphaMask:BitmapData = null;
            var i:int = start;
            var canvas:BitmapData = target || this.renderer_friend::_canvas;

            entries = param1;
            var len:int = int(entries.length);

            while (i < len) {
                entry = entries[i];
                if (!entry || entry.renderer_friend::_cleared || !entry.renderer_friend::_pt) {
                    i++;
                    continue;
                }
                if (!target && (entry._scaleX != 100 || entry._scaleY != 100) &&
                        (this._worldWidth != canvas.width || this._worldHeight != canvas.height)) {
                    this.rasterizeScaledInWorld(entry, canvas);
                    i++;
                    continue;
                }
                entryBmd = entry.renderer_friend::_data as BitmapData;
                this._pt.x = entry.renderer_friend::_pt.x;
                this._pt.y = entry.renderer_friend::_pt.y;
                if (entryBmd && !entry.renderer_friend::_blendMode && !entry.renderer_friend::_filter && (entry.renderer_friend::_scaleX & entry.renderer_friend::_scaleY) === 100) {
                    if (!target) {
                        this._pt.x = int(this._pt.x) - this._origin.x;
                        this._pt.y = int(this._pt.y) - this._origin.y;
                    }
                    if (entry.renderer_friend::_alpha !== 4278190080) {
                        alphaMask = new BitmapData(entryBmd.width, entryBmd.height, true, entry.renderer_friend::_alpha);
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
                    canvas.copyPixels(entryBmd, this._copyBounds, this._pt, alphaMask);
                    if (alphaMask) {
                        alphaMask.dispose();
                        alphaMask = null;
                    }
                }
                else {
                    if (!target) {
                        this._pt.x -= this._origin.x;
                        this._pt.y -= this._origin.y;
                    }
                    this._matrix.createBox(entry.renderer_friend::_scaleX * 0.01, entry.renderer_friend::_scaleY * 0.01, 0, this._pt.x, this._pt.y);
                    if (Boolean(entry.renderer_friend::_filter) && Boolean(entryBmd)) {
                        this._bm.bitmapData = entryBmd;
                        this._bm.filters = [entry.renderer_friend::_filter];
                        canvas.draw(this._bm, this._matrix, null, entry.renderer_friend::_blendMode, clip);
                    }
                    else {
                        if (entryBmd) {
                            var right:Number = this._pt.x + entryBmd.width * this._matrix.a;
                            var bottom:Number = this._pt.y + entryBmd.height * this._matrix.d;
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
                            if (this._drawBounds.width > 0 && this._drawBounds.height > 0)
                                canvas.draw(entryBmd, this._matrix, null, entry.renderer_friend::_blendMode, this._drawBounds);
                        }
                        else {
                            canvas.draw(entry.renderer_friend::_data, this._matrix, null, entry.renderer_friend::_blendMode, clip);
                        }
                    }
                }
                i++;
            }
        }

        private function rasterizeScaledInWorld(entry:RasterData, canvas:BitmapData):void {
            this._worldRegion.setTo(this._origin.x, this._origin.y, canvas.width, canvas.height);
            var source:BitmapData = entry._data as BitmapData;
            if (source && !entry._filter) {
                var x:Number = entry._pt.x + source.width * entry._scaleX * 0.01;
                var y:Number = entry._pt.y + source.height * entry._scaleY * 0.01;
                var copied:Boolean = !entry._blendMode && (entry._scaleX & entry._scaleY) === 100;
                if (copied) {
                    x = entry._pt.x + source.width;
                    y = entry._pt.y + source.height;
                }
                var left:Number = Math.max(this._worldRegion.x, Math.floor(Math.min(entry._pt.x, x)) - 2);
                var top:Number = Math.max(this._worldRegion.y, Math.floor(Math.min(entry._pt.y, y)) - 2);
                var right:Number = Math.min(this._worldRegion.right, Math.ceil(Math.max(entry._pt.x, x)) + 2);
                var bottom:Number = Math.min(this._worldRegion.bottom, Math.ceil(Math.max(entry._pt.y, y)) + 2);
                if (right <= left || bottom <= top)
                    return;
                this._worldRegion.setTo(left, top, right - left, bottom - top);
            }
            if (!this._worldCanvas || this._worldCanvas.width != this._worldWidth ||
                    this._worldCanvas.height != this._worldHeight || this._worldCanvas.transparent != canvas.transparent) {
                if (this._worldCanvas)
                    this._worldCanvas.dispose();
                this._worldCanvas = new BitmapData(this._worldWidth, this._worldHeight, canvas.transparent, 0);
            }
            this._localRegion.setTo(this._worldRegion.x - this._origin.x, this._worldRegion.y - this._origin.y,
                    this._worldRegion.width, this._worldRegion.height);
            this._worldPoint.setTo(this._worldRegion.x, this._worldRegion.y);
            this._worldCanvas.copyPixels(canvas, this._localRegion, this._worldPoint);
            this._single[0] = entry;
            this.rasterize(this._single, null, 0, this._worldCanvas);
            this._single[0] = null;
            this._localPoint.setTo(this._localRegion.x, this._localRegion.y);
            canvas.copyPixels(this._worldCanvas, this._worldRegion, this._localPoint);
        }
    }
}

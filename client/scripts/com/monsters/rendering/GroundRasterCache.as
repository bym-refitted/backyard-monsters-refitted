package com.monsters.rendering {
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    use namespace renderer_friend;

    internal class GroundRasterCache {
        private static const TILE_SIZE:int = 256;
        private static const BOUNDS_PADDING:int = 2;
        private static const OPAQUE_ALPHA:uint = 0xff000000;

        private var bitmap:BitmapData;
        private var entryStates:Dictionary = new Dictionary();
        private var dirtyTiles:Vector.<Boolean>;
        private var tileColumns:int;
        private var tileRows:int;
        private var renderGeneration:uint;

        private const origin:Point = new Point();
        private const tileBounds:Rectangle = new Rectangle();
        private const copyBounds:Rectangle = new Rectangle();
        private const tileEntries:Vector.<RasterData> = new Vector.<RasterData>();

        public function dispose():void {
            if (bitmap) {
                bitmap.dispose();
            }
            bitmap = null;
            entryStates = new Dictionary();
            dirtyTiles = null;
            tileEntries.length = 0;
        }

        // Returns the number of leading entries already drawn onto the target.
        public function render(entries:Vector.<RasterData>, renderer:Renderer, target:BitmapData):int {
            var baseEntry:RasterData = entries.length ? entries[0] : null;
            if (!canCacheBase(baseEntry, target)) {
                dispose();
                return 0;
            }

            var cachedEntryCount:int = countSupportedEntries(entries);
            if (cachedEntryCount < 2) {
                dispose();
                return 0;
            }

            ensureBitmap(target.width, target.height);
            updateEntryStates(entries, cachedEntryCount);
            redrawDirtyTiles(entries, cachedEntryCount, renderer);

            copyBounds.setTo(0, 0, target.width, target.height);
            target.copyPixels(bitmap, copyBounds, origin);
            return cachedEntryCount;
        }

        private function canCacheBase(entry:RasterData, target:BitmapData):Boolean {
            if (!entry || !entry.cacheable || entry._cleared || !entry._pt) {
                return false;
            }

            var source:BitmapData = entry._data as BitmapData;
            // Every tile must begin with an opaque background that fully replaces it.
            return source != null && !source.transparent &&
                entry._pt.x == 0 && entry._pt.y == 0 &&
                !entry._filter && !entry._blendMode && entry._alpha == OPAQUE_ALPHA &&
                entry._scaleX == 100 && entry._scaleY == 100 &&
                source.width == target.width && source.height == target.height;
        }

        private function countSupportedEntries(entries:Vector.<RasterData>):int {
            var count:int = 0;
            for each (var entry:RasterData in entries) {
                // Stop at the first unsupported entry to preserve compositing order.
                if (!entry || entry._cleared || !entry._pt || entry._filter) {
                    break;
                }

                var source:BitmapData = entry._data as BitmapData;
                if (!source && !(entry._data is DisplayObject)) {
                    break;
                }

                // Tile clipping must not change copyPixels' fractional-position rounding.
                if (source && !entry._blendMode && (entry._scaleX & entry._scaleY) === 100 &&
                        (entry._pt.x != int(entry._pt.x) || entry._pt.y != int(entry._pt.y))) {
                    break;
                }
                ++count;
            }
            return count;
        }

        private function ensureBitmap(width:int, height:int):void {
            if (bitmap && bitmap.width == width && bitmap.height == height) {
                return;
            }

            dispose();
            bitmap = new BitmapData(width, height, false, 0);
            tileColumns = Math.ceil(width / TILE_SIZE);
            tileRows = Math.ceil(height / TILE_SIZE);
            dirtyTiles = new Vector.<Boolean>(tileColumns * tileRows, true);
            markAllTilesDirty();
        }

        private function updateEntryStates(entries:Vector.<RasterData>, count:int):void {
            ++renderGeneration;
            var previousOrderIndex:int = -1;

            for (var index:int = 0; index < count; ++index) {
                var entry:RasterData = entries[index];
                var state:Object = entryStates[entry];
                if (state) {
                    if (state.orderIndex < previousOrderIndex) {
                        markAllTilesDirty();
                    }
                    previousOrderIndex = state.orderIndex;
                }

                // Sources without explicit caching support are redrawn every render.
                if (!entry.cacheable || !state || state.source !== entry._data ||
                        state.revision != entry._revision || state.x != entry._pt.x || state.y != entry._pt.y ||
                        state.scaleX != entry._scaleX || state.scaleY != entry._scaleY ||
                        state.alpha != entry._alpha || state.blendMode != entry._blendMode) {
                    if (state) {
                        markTilesDirty(state.bounds);
                    }

                    var bounds:Rectangle = getEntryBounds(entry);
                    state = {
                            source: entry._data,
                            revision: entry._revision,
                            x: entry._pt.x,
                            y: entry._pt.y,
                            scaleX: entry._scaleX,
                            scaleY: entry._scaleY,
                            alpha: entry._alpha,
                            blendMode: entry._blendMode,
                            bounds: bounds
                        };
                    entryStates[entry] = state;
                    markTilesDirty(bounds);
                }
                state.orderIndex = index;
                state.lastSeenGeneration = renderGeneration;
            }

            // Removed or hidden entries still need their previous pixels erased.
            for (var key:Object in entryStates) {
                var previousState:Object = entryStates[key];
                if (previousState.lastSeenGeneration != renderGeneration) {
                    markTilesDirty(previousState.bounds);
                    delete entryStates[key];
                }
            }
        }

        private function getEntryBounds(entry:RasterData):Rectangle {
            var source:BitmapData = entry._data as BitmapData;
            var display:DisplayObject = entry._data as DisplayObject;
            var sourceBounds:Rectangle = source ? source.rect : display.getBounds(display);
            var left:Number = entry._pt.x + sourceBounds.x * entry._scaleX * 0.01;
            var top:Number = entry._pt.y + sourceBounds.y * entry._scaleY * 0.01;
            var right:Number = left + sourceBounds.width * entry._scaleX * 0.01;
            var bottom:Number = top + sourceBounds.height * entry._scaleY * 0.01;

            // Round outward, including negative scales, and pad transformed edges.
            var bounds:Rectangle = new Rectangle(
                    Math.floor(Math.min(left, right)) - BOUNDS_PADDING,
                    Math.floor(Math.min(top, bottom)) - BOUNDS_PADDING, 0, 0);
            bounds.width = Math.ceil(Math.max(left, right)) + BOUNDS_PADDING - bounds.x;
            bounds.height = Math.ceil(Math.max(top, bottom)) + BOUNDS_PADDING - bounds.y;
            return bounds;
        }

        private function redrawDirtyTiles(entries:Vector.<RasterData>, count:int, renderer:Renderer):void {
            bitmap.lock();
            for (var tileIndex:int = 0; tileIndex < dirtyTiles.length; ++tileIndex) {
                if (!dirtyTiles[tileIndex]) {
                    continue;
                }

                tileBounds.setTo(tileIndex % tileColumns * TILE_SIZE,
                        int(tileIndex / tileColumns) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
                tileBounds.width = Math.min(TILE_SIZE, bitmap.width - tileBounds.x);
                tileBounds.height = Math.min(TILE_SIZE, bitmap.height - tileBounds.y);

                tileEntries.length = 0;
                for (var entryIndex:int = 0; entryIndex < count; ++entryIndex) {
                    var entry:RasterData = entries[entryIndex];
                    var bounds:Rectangle = entryStates[entry].bounds;
                    if (bounds.intersects(tileBounds)) {
                        tileEntries.push(entry);
                    }
                }
                renderer.rasterize(tileEntries, tileBounds, 0, bitmap);
                dirtyTiles[tileIndex] = false;
            }
            bitmap.unlock();
        }

        private function markAllTilesDirty():void {
            for (var index:int = 0; index < dirtyTiles.length; ++index) {
                dirtyTiles[index] = true;
            }
        }

        private function markTilesDirty(bounds:Rectangle):void {
            var firstColumn:int = Math.max(0, Math.floor(bounds.x / TILE_SIZE));
            var firstRow:int = Math.max(0, Math.floor(bounds.y / TILE_SIZE));
            var lastColumn:int = Math.min(tileColumns - 1, Math.floor((bounds.right - 1) / TILE_SIZE));
            var lastRow:int = Math.min(tileRows - 1, Math.floor((bounds.bottom - 1) / TILE_SIZE));

            for (var row:int = firstRow; row <= lastRow; ++row) {
                for (var column:int = firstColumn; column <= lastColumn; ++column) {
                    dirtyTiles[row * tileColumns + column] = true;
                }
            }
        }
    }
}

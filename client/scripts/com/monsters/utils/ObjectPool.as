package com.monsters.utils
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   /**
    * Object pool for frequently allocated geometry and bitmap objects.
    * Reduces GC pressure by reusing objects instead of creating new ones.
    * 
    * Usage:
    *   var pt:Point = ObjectPool.getPoint(10, 20);
    *   // use pt...
    *   ObjectPool.returnPoint(pt);
    */
   public class ObjectPool
   {
      // Pool size limits to prevent unbounded memory growth
      private static const MAX_POINT_POOL:int = 500;
      private static const MAX_RECT_POOL:int = 500;
      private static const MAX_MATRIX_POOL:int = 100;
      private static const MAX_BMD_PER_SIZE:int = 50;
      
      // Point pool
      private static var _pointPool:Vector.<Point> = new Vector.<Point>();
      private static var _pointIndex:int = 0;
      
      // Rectangle pool
      private static var _rectPool:Vector.<Rectangle> = new Vector.<Rectangle>();
      private static var _rectIndex:int = 0;
      
      // Matrix pool
      private static var _matrixPool:Vector.<Matrix> = new Vector.<Matrix>();
      private static var _matrixIndex:int = 0;
      
      // BitmapData pools (bucketed by power-of-2 sizes)
      private static var _bmdPools:Object = {};
      private static var _bmdPoolCounts:Object = {};
      
      // Statistics for debugging
      private static var _stats:Object = {
         pointsCreated: 0,
         pointsReused: 0,
         rectsCreated: 0,
         rectsReused: 0,
         matrixCreated: 0,
         matrixReused: 0,
         bmdCreated: 0,
         bmdReused: 0
      };
      
      //------------------------------------------------------------------
      // Point pooling
      //------------------------------------------------------------------
      
      /**
       * Get a Point from the pool, or create a new one if pool is empty.
       */
      public static function getPoint(x:Number = 0, y:Number = 0):Point
      {
         var p:Point;
         if (_pointIndex > 0)
         {
            p = _pointPool[--_pointIndex];
            p.x = x;
            p.y = y;
            _stats.pointsReused++;
         }
         else
         {
            p = new Point(x, y);
            _stats.pointsCreated++;
         }
         return p;
      }
      
      /**
       * Return a Point to the pool for reuse.
       */
      public static function returnPoint(p:Point):void
      {
         if (p && _pointIndex < MAX_POINT_POOL)
         {
            _pointPool[_pointIndex++] = p;
         }
      }
      
      /**
       * Update a Point's values in-place (alternative to getting a new one).
       */
      public static function setPoint(p:Point, x:Number, y:Number):Point
      {
         p.x = x;
         p.y = y;
         return p;
      }
      
      //------------------------------------------------------------------
      // Rectangle pooling
      //------------------------------------------------------------------
      
      /**
       * Get a Rectangle from the pool, or create a new one if pool is empty.
       */
      public static function getRect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):Rectangle
      {
         var r:Rectangle;
         if (_rectIndex > 0)
         {
            r = _rectPool[--_rectIndex];
            r.x = x;
            r.y = y;
            r.width = width;
            r.height = height;
            _stats.rectsReused++;
         }
         else
         {
            r = new Rectangle(x, y, width, height);
            _stats.rectsCreated++;
         }
         return r;
      }
      
      /**
       * Return a Rectangle to the pool for reuse.
       */
      public static function returnRect(r:Rectangle):void
      {
         if (r && _rectIndex < MAX_RECT_POOL)
         {
            _rectPool[_rectIndex++] = r;
         }
      }
      
      /**
       * Update a Rectangle's values in-place.
       */
      public static function setRect(r:Rectangle, x:Number, y:Number, width:Number, height:Number):Rectangle
      {
         r.x = x;
         r.y = y;
         r.width = width;
         r.height = height;
         return r;
      }
      
      //------------------------------------------------------------------
      // Matrix pooling
      //------------------------------------------------------------------
      
      /**
       * Get a Matrix from the pool, or create a new one if pool is empty.
       */
      public static function getMatrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0):Matrix
      {
         var m:Matrix;
         if (_matrixIndex > 0)
         {
            m = _matrixPool[--_matrixIndex];
            m.a = a;
            m.b = b;
            m.c = c;
            m.d = d;
            m.tx = tx;
            m.ty = ty;
            _stats.matrixReused++;
         }
         else
         {
            m = new Matrix(a, b, c, d, tx, ty);
            _stats.matrixCreated++;
         }
         return m;
      }
      
      /**
       * Return a Matrix to the pool for reuse.
       */
      public static function returnMatrix(m:Matrix):void
      {
         if (m && _matrixIndex < MAX_MATRIX_POOL)
         {
            _matrixPool[_matrixIndex++] = m;
         }
      }
      
      //------------------------------------------------------------------
      // BitmapData pooling (bucketed by size)
      //------------------------------------------------------------------
      
      /**
       * Get a BitmapData from the pool, or create a new one.
       * Sizes are rounded up to power-of-2 for efficient pooling.
       */
      public static function getBitmapData(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0x00000000):BitmapData
      {
         // Round up to power of 2 for pooling efficiency
         var pw:int = nextPow2(width);
         var ph:int = nextPow2(height);
         var key:String = pw + "x" + ph + (transparent ? "t" : "o");
         
         if (!_bmdPools[key])
         {
            _bmdPools[key] = [];
            _bmdPoolCounts[key] = 0;
         }
         
         var pool:Array = _bmdPools[key];
         var bmd:BitmapData;
         
         if (pool.length > 0)
         {
            bmd = pool.pop();
            bmd.fillRect(bmd.rect, fillColor);
            _stats.bmdReused++;
         }
         else
         {
            bmd = new BitmapData(pw, ph, transparent, fillColor);
            _stats.bmdCreated++;
         }
         return bmd;
      }
      
      /**
       * Return a BitmapData to the pool for reuse.
       * Note: Do NOT dispose the BitmapData before returning.
       */
      public static function returnBitmapData(bmd:BitmapData):void
      {
         if (!bmd) return;
         
         var key:String = bmd.width + "x" + bmd.height + (bmd.transparent ? "t" : "o");
         
         if (!_bmdPools[key])
         {
            _bmdPools[key] = [];
            _bmdPoolCounts[key] = 0;
         }
         
         if (_bmdPools[key].length < MAX_BMD_PER_SIZE)
         {
            _bmdPools[key].push(bmd);
         }
         else
         {
            // Pool is full, dispose this one
            bmd.dispose();
         }
      }
      
      //------------------------------------------------------------------
      // Utility methods
      //------------------------------------------------------------------
      
      /**
       * Round up to the next power of 2.
       */
      private static function nextPow2(v:int):int
      {
         if (v <= 0) return 1;
         v--;
         v |= v >> 1;
         v |= v >> 2;
         v |= v >> 4;
         v |= v >> 8;
         v |= v >> 16;
         return v + 1;
      }
      
      /**
       * Clear all pools and release memory.
       * Call this when transitioning between major game states.
       */
      public static function clearAll():void
      {
         _pointPool.length = 0;
         _pointIndex = 0;
         
         _rectPool.length = 0;
         _rectIndex = 0;
         
         _matrixPool.length = 0;
         _matrixIndex = 0;
         
         // Dispose all pooled BitmapData
         for (var key:String in _bmdPools)
         {
            var pool:Array = _bmdPools[key];
            for each (var bmd:BitmapData in pool)
            {
               if (bmd)
               {
                  bmd.dispose();
               }
            }
            pool.length = 0;
         }
         _bmdPools = {};
         _bmdPoolCounts = {};
      }
      
      /**
       * Get pool statistics for debugging.
       */
      public static function getStats():Object
      {
         return {
            points: {
               poolSize: _pointIndex,
               created: _stats.pointsCreated,
               reused: _stats.pointsReused,
               hitRate: _stats.pointsReused / Math.max(1, _stats.pointsCreated + _stats.pointsReused)
            },
            rects: {
               poolSize: _rectIndex,
               created: _stats.rectsCreated,
               reused: _stats.rectsReused,
               hitRate: _stats.rectsReused / Math.max(1, _stats.rectsCreated + _stats.rectsReused)
            },
            matrices: {
               poolSize: _matrixIndex,
               created: _stats.matrixCreated,
               reused: _stats.matrixReused,
               hitRate: _stats.matrixReused / Math.max(1, _stats.matrixCreated + _stats.matrixReused)
            },
            bitmapData: {
               created: _stats.bmdCreated,
               reused: _stats.bmdReused,
               hitRate: _stats.bmdReused / Math.max(1, _stats.bmdCreated + _stats.bmdReused)
            }
         };
      }
      
      /**
       * Reset statistics counters.
       */
      public static function resetStats():void
      {
         _stats.pointsCreated = 0;
         _stats.pointsReused = 0;
         _stats.rectsCreated = 0;
         _stats.rectsReused = 0;
         _stats.matrixCreated = 0;
         _stats.matrixReused = 0;
         _stats.bmdCreated = 0;
         _stats.bmdReused = 0;
      }
   }
}

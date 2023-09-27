package org.bytearray.display
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ScaleBitmap extends Bitmap
   {
       
      
      protected var _originalBitmap:BitmapData;
      
      protected var _scale9Grid:Rectangle = null;
      
      public function ScaleBitmap(param1:BitmapData = null, param2:String = "auto", param3:Boolean = false)
      {
         super(param1,param2,param3);
         this._originalBitmap = param1.clone();
      }
      
      override public function set bitmapData(param1:BitmapData) : void
      {
         this._originalBitmap = param1.clone();
         if(this._scale9Grid != null)
         {
            if(!this.validGrid(this._scale9Grid))
            {
               this._scale9Grid = null;
            }
            this.setSize(param1.width,param1.height);
         }
         else
         {
            this.assignBitmapData(this._originalBitmap.clone());
         }
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 != width)
         {
            this.setSize(param1,height);
         }
      }
      
      override public function set height(param1:Number) : void
      {
         if(param1 != height)
         {
            this.setSize(width,param1);
         }
      }
      
      override public function set scale9Grid(param1:Rectangle) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._scale9Grid == null && param1 != null || this._scale9Grid != null && !this._scale9Grid.equals(param1))
         {
            if(param1 == null)
            {
               _loc2_ = width;
               _loc3_ = height;
               this._scale9Grid = null;
               this.assignBitmapData(this._originalBitmap.clone());
               this.setSize(_loc2_,_loc3_);
            }
            else
            {
               if(!this.validGrid(param1))
               {
                  throw new Error("#001 - The _scale9Grid does not match the original BitmapData");
               }
               this._scale9Grid = param1.clone();
               this.resizeBitmap(width,height);
               scaleX = 1;
               scaleY = 1;
            }
         }
      }
      
      private function assignBitmapData(param1:BitmapData) : void
      {
         super.bitmapData.dispose();
         super.bitmapData = param1;
      }
      
      private function validGrid(param1:Rectangle) : Boolean
      {
         return param1.right <= this._originalBitmap.width && param1.bottom <= this._originalBitmap.height;
      }
      
      override public function get scale9Grid() : Rectangle
      {
         return this._scale9Grid;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         if(this._scale9Grid == null)
         {
            super.width = param1;
            super.height = param2;
         }
         else
         {
            param1 = Math.max(param1,this._originalBitmap.width - this._scale9Grid.width);
            param2 = Math.max(param2,this._originalBitmap.height - this._scale9Grid.height);
            this.resizeBitmap(param1,param2);
         }
      }
      
      public function getOriginalBitmapData() : BitmapData
      {
         return this._originalBitmap;
      }
      
      protected function resizeBitmap(param1:Number, param2:Number) : void
      {
         var _loc8_:Rectangle = null;
         var _loc9_:Rectangle = null;
         var _loc12_:int = 0;
         var _loc3_:BitmapData = new BitmapData(param1,param2,true,0);
         var _loc4_:Array = [0,this._scale9Grid.top,this._scale9Grid.bottom,this._originalBitmap.height];
         var _loc5_:Array = [0,this._scale9Grid.left,this._scale9Grid.right,this._originalBitmap.width];
         var _loc6_:Array = [0,this._scale9Grid.top,param2 - (this._originalBitmap.height - this._scale9Grid.bottom),param2];
         var _loc7_:Array = [0,this._scale9Grid.left,param1 - (this._originalBitmap.width - this._scale9Grid.right),param1];
         var _loc10_:Matrix = new Matrix();
         var _loc11_:int = 0;
         while(_loc11_ < 3)
         {
            _loc12_ = 0;
            while(_loc12_ < 3)
            {
               _loc8_ = new Rectangle(_loc5_[_loc11_],_loc4_[_loc12_],_loc5_[_loc11_ + 1] - _loc5_[_loc11_],_loc4_[_loc12_ + 1] - _loc4_[_loc12_]);
               _loc9_ = new Rectangle(_loc7_[_loc11_],_loc6_[_loc12_],_loc7_[_loc11_ + 1] - _loc7_[_loc11_],_loc6_[_loc12_ + 1] - _loc6_[_loc12_]);
               _loc10_.identity();
               _loc10_.a = _loc9_.width / _loc8_.width;
               _loc10_.d = _loc9_.height / _loc8_.height;
               _loc10_.tx = _loc9_.x - _loc8_.x * _loc10_.a;
               _loc10_.ty = _loc9_.y - _loc8_.y * _loc10_.d;
               _loc3_.draw(this._originalBitmap,_loc10_,null,null,_loc9_,smoothing);
               _loc12_++;
            }
            _loc11_++;
         }
         this.assignBitmapData(_loc3_);
      }
   }
}

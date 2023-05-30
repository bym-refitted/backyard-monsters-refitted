package com.cc.screenshot
{
   import com.gskinner.geom.ColorMatrix;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class screenshot
   {
      
      public static var _rawImage:BitmapData;
      
      public static var _processedImage:BitmapData;
       
      
      public function screenshot()
      {
         super();
      }
      
      public static function Take(param1:Number, param2:Number) : void
      {
         _rawImage = new BitmapData(700,460,false,0);
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(param1,param2);
         _rawImage.draw(GLOBAL._layerMap,_loc3_,null,null,_rawImage.rect,true);
      }
      
      public static function Process(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0) : void
      {
         var _loc7_:ColorMatrix = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:BitmapData = null;
         var _loc11_:Matrix = null;
         var _loc12_:Sprite = null;
         var _loc13_:BitmapData = null;
         var _loc14_:BitmapData = null;
         var _loc15_:ColorTransform = null;
         _processedImage = _rawImage.clone();
         if(param1 != 0)
         {
            (_loc7_ = new ColorMatrix()).adjustBrightness(param1);
            _processedImage.applyFilter(_processedImage,_processedImage.rect,_processedImage.rect.topLeft,new ColorMatrixFilter(_loc7_));
         }
         if(param2 != 0)
         {
            (_loc7_ = new ColorMatrix()).adjustContrast(param2);
            _processedImage.applyFilter(_processedImage,_processedImage.rect,_processedImage.rect.topLeft,new ColorMatrixFilter(_loc7_));
         }
         if(param3 != 0)
         {
            (_loc7_ = new ColorMatrix()).adjustSaturation(param3);
            _processedImage.applyFilter(_processedImage,_processedImage.rect,_processedImage.rect.topLeft,new ColorMatrixFilter(_loc7_));
         }
         if(param4)
         {
            _loc8_ = 100 - param4 + 30;
            _loc9_ = 50 + (100 - param4 + 30) / 2;
            _loc10_ = _processedImage.clone();
            _loc10_.applyFilter(_loc10_,_loc10_.rect,_loc10_.rect.topLeft,new BlurFilter(3,3,3));
            (_loc11_ = new Matrix()).createGradientBox(_loc10_.width,_loc10_.height * (_loc8_ / 100),90 / (180 / Math.PI),0,_loc10_.height * ((_loc9_ - _loc8_) / 100));
            (_loc12_ = new Sprite()).graphics.beginGradientFill("linear",new Array(16777215,16777215,16777215,16777215),new Array(0,1,1,0),new Array(0,85,170,255),_loc11_);
            _loc12_.graphics.drawRect(0,0,_loc10_.width,_loc10_.height);
            (_loc13_ = new BitmapData(_loc10_.width,_loc10_.height,true,16777215)).draw(_loc12_);
            _loc10_.copyPixels(_processedImage,_processedImage.rect,_processedImage.rect.topLeft,_loc13_,_loc13_.rect.topLeft,true);
            _processedImage = _loc10_;
         }
         if(param5 > 0)
         {
            (_loc14_ = _rawImage.clone()).noise(1,0,255,7,true);
            _loc15_ = new ColorTransform(1,1,1,param5 * 10 / 100);
            _processedImage.draw(_loc14_,null,_loc15_,"multiply");
            _loc15_ = new ColorTransform(1,1,1,param5 * 5 / 100);
            _processedImage.draw(_loc14_,null,_loc15_,"screen");
         }
         if(param6)
         {
            if(param6 == 1)
            {
               _processedImage.copyPixels(new screenshot_border1(0,0),_processedImage.rect,new Point(0,0));
            }
            if(param6 == 2)
            {
               _processedImage.copyPixels(new screenshot_border2(0,0),_processedImage.rect,new Point(0,0));
            }
            if(param6 == 3)
            {
               _processedImage.copyPixels(new screenshot_border3(0,0),_processedImage.rect,new Point(0,0));
            }
         }
      }
      
      public static function Show() : void
      {
         Take(-20,-20);
         POPUPS.Push(new screenshot_ui());
      }
   }
}

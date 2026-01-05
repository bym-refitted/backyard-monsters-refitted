package com.monsters.display
{
   import flash.display.BitmapData;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ImageText
   {
       
      
      public function ImageText()
      {
         super();
      }
      
      public static function Get(param1:String, param2:int = 13, param3:int = 0, param4:Array = null) : BitmapData
      {
         var _loc5_:TextFormat;
         (_loc5_ = new TextFormat()).font = "Groboldov";
         _loc5_.size = param2;
         _loc5_.color = 16777215;
         _loc5_.letterSpacing = param3;
         var _loc6_:TextField;
         (_loc6_ = new TextField()).embedFonts = true;
         _loc6_.antiAliasType = AntiAliasType.NORMAL;
         _loc6_.width = 600;
         _loc6_.defaultTextFormat = _loc5_;
         _loc6_.htmlText = param1;
         if(param4)
         {
            _loc6_.filters = param4;
         }
         else
         {
            _loc6_.filters = [new GlowFilter(0,1,2,2,5,2)];
         }
         var _loc7_:BitmapData;
         (_loc7_ = new BitmapData(_loc6_.textWidth + 5,_loc6_.textHeight + 5,true,0)).draw(_loc6_);
         return _loc7_;
      }
   }
}

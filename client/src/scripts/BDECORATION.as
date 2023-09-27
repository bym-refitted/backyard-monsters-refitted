package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BDECORATION extends BFOUNDATION
   {
       
      
      public var _animMC:MovieClip;
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public function BDECORATION(param1:int)
      {
         var _loc2_:int = 0;
         _loc2_ = int(GLOBAL._buildingProps[param1 - 1].size);
         _type = param1;
         _footprint = [new Rectangle(0,0,_loc2_,_loc2_)];
         _gridCost = [[new Rectangle(0,0,_loc2_,_loc2_),2]];
         super();
         super.SetProps();
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         super.Place(param1);
         Constructed();
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(GLOBAL._render && this._frameNumber % 2 == 0)
         {
            AnimFrame();
         }
         ++this._frameNumber;
      }
   }
}

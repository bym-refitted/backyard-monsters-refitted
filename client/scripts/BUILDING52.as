package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING52 extends BEXPIRABLE
   {
       
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public function BUILDING52()
      {
         _type = 52;
         super();
         _footprint = [new Rectangle(0,0,40,40)];
         _gridCost = [[new Rectangle(0,0,40,40),20]];
         imageData = GLOBAL._buildingProps[_type - 1].imageData;
         SetProps();
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         super.Place(param1);
         if(_placing == false)
         {
            SIGNS.CreateForBuilding(this);
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(GLOBAL._render && this._frameNumber % 2 == 0 && CREEPS._creepCount == 0)
         {
            this.AnimFrame();
         }
         ++this._frameNumber;
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         _animContainerBMD.copyPixels(_animBMD,new Rectangle(24 * _animTick,0,24,30),new Point(0,0));
         ++_animTick;
         if(_animTick == 22)
         {
            _animTick = 0;
         }
      }
   }
}

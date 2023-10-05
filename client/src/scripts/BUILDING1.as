package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING1 extends BRESOURCE
   {
       
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public function BUILDING1()
      {
         this._frameNumber = Math.random() * 5;
         super();
         this._frameNumber = int(Math.random() * 5);
         _type = 1;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         _spoutPoint = new Point(-23,-20);
         _spoutHeight = 45;
         SetProps();
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(GLOBAL._render && _animLoaded && _countdownBuild.Get() + _countdownUpgrade.Get() + _countdownFortify.Get() == 0 && _producing && _canFunction)
         {
            if((GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "help" || GLOBAL.mode == "view") && this._frameNumber % 3 == 0 && CREEPS._creepCount == 0)
            {
               AnimFrame();
            }
            else if(this._frameNumber % 10 == 0)
            {
               AnimFrame();
            }
         }
         ++this._frameNumber;
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
      }
   }
}

package
{
   import com.monsters.display.ImageCache;
   import com.monsters.interfaces.ICoreBuilding;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class OutpostDefender extends BFOUNDATION implements ICoreBuilding
   {
      
      public static const k_TYPE:int = 140;
      
      private static var colorData:Vector.<ColorData>;
       
      
      public function OutpostDefender()
      {
         super();
         colorData = Vector.<ColorData>([new ColorData("self.light.png"),new ColorData("enemy.light.png"),new ColorData("ally.light.png"),new ColorData("neutral.light.png")]);
         _animRandomStart = false;
         _footprint = [new Rectangle(0,0,130,130)];
         _gridCost = [[new Rectangle(0,0,130,130),10],[new Rectangle(10,10,110,110),200]];
         _type = k_TYPE;
         SetProps();
         animContainer.visible = false;
      }
      
      public function setLightFromRelationship(param1:uint) : void
      {
         ImageCache.GetImageWithCallBack(colorData[param1].lightAnimation,this.loadedLightAnimationImage);
      }
      
      private function loadedLightAnimationImage(param1:String, param2:BitmapData) : void
      {
         _animBMD = param2;
         animContainer.visible = true;
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         if(_animLoaded && !animContainer.visible)
         {
            this.setLightFromRelationship(BASE.loadObject["relationship"]);
         }
         super.TickFast(param1);
         AnimFrame();
      }
   }
}

class ColorData
{
    
   
   public var lightAnimation:String;
   
   public function ColorData(param1:String)
   {
      super();
      this.lightAnimation = "buildings/outpostdefender/" + param1;
   }
}

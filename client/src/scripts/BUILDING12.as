package
{
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BUILDING12 extends BFOUNDATION
   {
       
      
      public function BUILDING12()
      {
         super();
         _type = 12;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         SetProps();
      }
      
      override public function Tick(param1:int) : void
      {
         if(_countdownBuild.Get() > 0 || health < maxHealth * 0.5)
         {
            _canFunction = false;
         }
         else
         {
            _canFunction = true;
         }
         super.Tick(param1);
      }
      
      public function Fund() : void
      {
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         super.Place(param1);
      }
      
      override public function Cancel() : void
      {
         GLOBAL._bStore = null;
         super.Cancel();
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bStore = null;
         return super.RecycleC();
      }
      
      override public function Description() : void
      {
         super.Description();
         _buildingTitle = KEYS.Get("#b_generalstore#");
         _buildingDescription = KEYS.Get("building_generalstore_desc1");
         _specialDescription = KEYS.Get("building_generalstore_desc2",{"v1":GLOBAL._resourceNames[4]});
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
         GLOBAL._bStore = this;
         super.Constructed();
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(_countdownBuild.Get() <= 0)
         {
            GLOBAL._bStore = this;
         }
      }
   }
}

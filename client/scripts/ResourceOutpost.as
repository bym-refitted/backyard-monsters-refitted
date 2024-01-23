package
{
   import com.monsters.interfaces.ICoreBuilding;
   import com.monsters.maproom3.MapRoom3Cell;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class ResourceOutpost extends BFOUNDATION implements ICoreBuilding
   {
      
      public static const k_TYPE:int = 139;
       
      
      public function ResourceOutpost()
      {
         super();
         _footprint = [new Rectangle(0,0,130,130)];
         _gridCost = [[new Rectangle(0,0,130,130),10],[new Rectangle(10,10,110,110),200]];
         _type = k_TYPE;
         SetProps();
      }
      
      public function get resourcesPerSecond() : int
      {
         if(GLOBAL._currentCell as MapRoom3Cell == null || !_buildingProps.rps || _buildingProps.rps.length < int((GLOBAL._currentCell as MapRoom3Cell).baseLevel * 0.1 - 1))
         {
            return 0;
         }
         return _buildingProps.rps[int((GLOBAL._currentCell as MapRoom3Cell).baseLevel * 0.1 - 1)];
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         GLOBAL.setTownHall(this);
      }
      
      override public function Cancel() : void
      {
         GLOBAL.setTownHall(null);
         super.Cancel();
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         GLOBAL.setTownHall(this);
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         AnimFrame();
      }
   }
}

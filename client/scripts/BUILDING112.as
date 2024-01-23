package
{
   import com.monsters.ai.WMBASE;
   import com.monsters.interfaces.ICoreBuilding;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING112 extends BSTORAGE implements ICoreBuilding
   {
       
      
      public function BUILDING112()
      {
         super();
         _type = 112;
         _footprint = [new Rectangle(0,0,130,130)];
         _gridCost = [[new Rectangle(0,0,130,130),10],[new Rectangle(10,10,110,110),200]];
         _spoutPoint = new Point(0,-55);
         _spoutHeight = 115;
         SetProps();
      }
      
      override public function Repair() : void
      {
         super.Repair();
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         if(!MAP._dragged)
         {
            super.Place(param1);
            _hasResources = true;
         }
      }
      
      override public function Cancel() : void
      {
         GLOBAL.setTownHall(null);
         super.Cancel();
      }
      
      override public function Recycle() : void
      {
         GLOBAL.Message(KEYS.Get("msg_recycleoutpost"));
      }
      
      override public function RecycleB(param1:MouseEvent = null) : void
      {
         GLOBAL.Message(KEYS.Get("msg_recycleoutpost"));
      }
      
      override public function RecycleC() : void
      {
         GLOBAL.Message(KEYS.Get("msg_recycleoutpost"));
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         super.Destroyed(param1);
         if((!MapRoomManager.instance.isInMapRoom2or3 || BASE.isInfernoMainYardOrOutpost) && GLOBAL.mode == "wmattack")
         {
            WMBASE._destroyed = true;
         }
      }
      
      override public function Description() : void
      {
         super.Description();
         _buildingDescription = KEYS.Get("outpost_upgradedesc");
         _recycleDescription = KEYS.Get("th_recycledesc");
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         GLOBAL.setTownHall(this);
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         GLOBAL.setTownHall(this);
      }
   }
}

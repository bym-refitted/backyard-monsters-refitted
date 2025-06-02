package
{
   import com.monsters.pathing.PATHING;
   import flash.events.*;
   import flash.geom.Rectangle;
   
   public class BWALL extends BFOUNDATION
   {
       
      
      public function BWALL()
      {
         super();
      }
      
      override public function GridCost(param1:Boolean = true) : void
      {
         super.GridCost(param1);
         PATHING.RegisterBuilding(new Rectangle(_mc.x,_mc.y,20,20),this,param1);
      }
      
      override public function Description() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Description();
         if(_lvl.Get() < _buildingProps.hp.length)
         {
            _loc1_ = int(_buildingProps.hp[_lvl.Get() - 1].Get());
            _loc2_ = int(_buildingProps.hp[_lvl.Get()].Get());
            _upgradeDescription = KEYS.Get("building_wall_upgrade",{
               "v1":GLOBAL.FormatNumber(_loc1_),
               "v2":GLOBAL.FormatNumber(_loc2_),
               "v3":int(100 / _loc1_ * _loc2_) - 100
            });
         }
      }
      
      override public function RecycleC() : void
      {
         PATHING.RegisterBuilding(new Rectangle(_mc.x,_mc.y,20,20),this,false);
         super.RecycleC();
      }
   }
}

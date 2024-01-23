package
{
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BUILDING15 extends BFOUNDATION
   {
       
      
      public var _capacity:int;
      
      public var _space:int;
      
      public var _housing:Object;
      
      public function BUILDING15()
      {
         super();
         _type = 15;
         this._capacity = 0;
         this._housing = {};
         _footprint = [new Rectangle(0,0,160,160)];
         _gridCost = [[new Rectangle(10,10,140,20),400],[new Rectangle(130,30,20,120),400],[new Rectangle(10,30,20,120),400],[new Rectangle(30,130,30,20),400],[new Rectangle(100,130,30,20),400]];
         SetProps();
      }
      
      override public function StopMoveB() : void
      {
         super.StopMoveB();
         UpdateHousedCreatureTargets();
      }
      
      override public function Description() : void
      {
         super.Description();
         _upgradeDescription = KEYS.Get("bdg_housing_capacitydesc",{
            "v1":GLOBAL.FormatNumber(_buildingProps.capacity[_lvl.Get() - 1]),
            "v2":GLOBAL.FormatNumber(_buildingProps.capacity[_lvl.Get()])
         });
         if(_recycleCosts != null)
         {
            _recycleDescription = "<b>" + KEYS.Get("bdg_housing_recycledesc") + "</b><br>" + _recycleCosts;
         }
         HOUSING.HousingSpace();
         if(BASE.isMainYardOrInfernoMainYard)
         {
            _blockRecycle = false;
         }
         var _loc1_:int = HOUSING._housingSpace.Get();
         var _loc2_:int = int(_buildingProps.capacity[_lvl.Get() - 1]);
         if(HOUSING._housingSpace.Get() - _buildingProps.capacity[_lvl.Get() - 1] < 0)
         {
            _recycleDescription = "<font color=\"#CC0000\">" + KEYS.Get("bdg_housing_recyclewarning") + "</font>";
            _blockRecycle = true;
         }
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         HOUSING.AddHouse(this);
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Upgraded();
         HOUSING.HousingSpace();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["upgrade-ho-" + _lvl.Get(),KEYS.Get("pop_housingupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_housingupgraded_streambody"),"upgrade-housing.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_housingupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_housingupgraded_body",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Tick(param1:int) : void
      {
         super.Tick(param1);
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function RecycleC() : void
      {
         super.RecycleC();
         HOUSING.HousingSpace();
         HOUSING.RemoveHouse(this);
         RelocateHousedCreatures();
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         var _loc3_:CreepBase = null;
         super.Destroyed(param1);
         var _loc2_:Boolean = MapRoomManager.instance.isInMapRoom3;
         var _loc4_:int = 0;
         while(_loc4_ < _creatures.length)
         {
            _creatures[_loc4_].setHealth(_loc2_ ? _creatures[_loc4_].health * 0.5 : 0);
            _loc4_++;
         }
         if(!MapRoomManager.instance.isInMapRoom3)
         {
            HOUSING.Cull();
            HOUSING.RemoveHouse(this);
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(m_isCleared)
         {
            return;
         }
         if(health > 10 && health < maxHealth && health % 1000 == 0)
         {
            setHealth(maxHealth);
         }
         if(_countdownBuild.Get() == 0)
         {
            HOUSING.AddHouse(this);
         }
      }
   }
}

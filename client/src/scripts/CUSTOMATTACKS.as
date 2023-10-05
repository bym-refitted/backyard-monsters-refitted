package
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.geom.Point;
   
   public class CUSTOMATTACKS
   {
      
      public static var _history:Object;
      
      public static var _inProgress:Boolean;
      
      public static var _lastClick:int = 0;
      
      public static var _started:Boolean;
      
      public static var _isAI:Boolean = false;
      
      public static var _attacks:Array = [8000,18800,43240,97290,214038,460182,966382,1981082,3962164,7726221,14679819,27157666,48883798,85546647,145429299,189058089,245775516,319508170,415360622,539968808,701959450,912547286,1186311471,1542204913,2004866386,2606326302,3388224193,4404691451,5726098886,7443928552,9677107118,12580239253,16354311030,21260604338,27638785640,35930421332,46709547731,60722412051];
       
      
      public function CUSTOMATTACKS()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _started = false;
      }
      
      public static function TrojanHorse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc4_:BFOUNDATION = null;
         if(!BUILDING27._exists && !BASE.isInfernoMainYardOrOutpost)
         {
            _loc1_ = GLOBAL._mapHeight;
            _loc2_ = -800 - (GLOBAL._mapHeight - 800) / 2;
            _loc3_ = GRID.ToISO(-70,_loc2_,0);
            _loc4_ = BASE.addBuildingC(27);
            ++BASE._buildingCount;
            _loc4_.Setup({
               "t":27,
               "X":-70,
               "Y":_loc2_,
               "id":BASE._buildingCount
            });
            MAP.FocusTo(_loc3_.x,_loc3_.y,2);
            BASE.Save(0,false,true);
         }
      }
      
      public static function CustomAttack(param1:Array, param2:Boolean = false) : Array
      {
         _started = true;
         WMATTACK._isAI = false;
         WMATTACK.AttackB();
         UI2.Show("scareAway");
         if(UI2._scareAway)
         {
            UI2._scareAway.addEventListener("scareAway",MONSTERBAITER.End);
         }
         var _loc3_:Array = WMATTACK.SpawnA(param1);
         var _loc4_:MonsterBase = _loc3_[0][0];
         MAP.FocusTo(_loc4_.x,_loc4_.y,2);
         return _loc3_;
      }
      
      public static function WMIAttack(param1:Array) : Array
      {
         _started = true;
         WMATTACK._isAI = false;
         WMATTACK.AttackB();
         UI2.Show("scareAway");
         if(UI2._scareAway)
         {
            UI2._scareAway.addEventListener("scareAway",MONSTERBAITER.End);
         }
         return WMATTACK.SpawnA(param1);
      }
      
      public static function TutorialAttack() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:CreepBase = null;
         _started = true;
         _loc1_ = WMATTACK.SpawnA([["C2","bounce",1,180,-10,0,1]]);
         _loc1_ = WMATTACK.SpawnA([["C2","bounce",2,190,-5,0,1]]);
         _loc1_ = WMATTACK.SpawnA([["C2","bounce",2,190,10,0,1]]);
         _loc1_ = WMATTACK.SpawnA([["C2","bounce",1,250,5,0,1]]);
         _loc1_ = WMATTACK.SpawnA([["C2","bounce",2,190,0,0,1]]);
         _loc2_ = _loc1_[0][0];
         _loc3_ = Point.distance(new Point(GLOBAL._bTower.x,GLOBAL._bTower.y),new Point(_loc2_.x,_loc2_.y));
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicipanic");
         }
         else
         {
            SOUNDS.PlayMusic("musicpanic");
         }
         WMATTACK.AttackB();
         WMATTACK.AttackC();
         MAP.FocusTo(GLOBAL._bTower.x,GLOBAL._bTower.y,int(_loc3_ / 100),0,0,false);
         for each(_loc4_ in CREEPS._creeps)
         {
            _loc4_.maxHealthProperty.value = 1;
            _loc4_.setHealth(1);
         }
         WMATTACK._isAI = false;
         WMATTACK._inProgress = true;
      }
   }
}

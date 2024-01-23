package
{
   import com.monsters.ai.TRIBES;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MONSTERBUNKER
   {
      
      public static const TYPE:uint = 22;
      
      public static var _mc:MONSTERBUNKERPOPUP;
      
      public static var s_PersistantBunker:PersistentMonsterBunker;
      
      public static var _open:Boolean;
      
      public static var _bunkerCapacity:int;
      
      public static var _bunkerUsed:int;
      
      public static var _bunkerSpace:int;
      
      public static var _housingBuildingUpgrading:Boolean;
      
      public static var _creatures:Object;
       
      
      public function MONSTERBUNKER()
      {
         super();
      }
      
      public static function Data(param1:Object) : void
      {
         _creatures = param1;
         if(_creatures.C100)
         {
            _creatures.C12 = _creatures.C100;
            delete _creatures.C100;
         }
      }
      
      public static function Show(param1:MouseEvent = null) : void
      {
         Hide(param1);
         _open = true;
         GLOBAL.BlockerAdd();
         if(MapRoomManager.instance.isInMapRoom3)
         {
            s_PersistantBunker = GLOBAL._layerWindows.addChild(new PersistentMonsterBunker()) as PersistentMonsterBunker;
            s_PersistantBunker.Center();
            s_PersistantBunker.ScaleUp();
         }
         else
         {
            _mc = GLOBAL._layerWindows.addChild(new MONSTERBUNKERPOPUP()) as MONSTERBUNKERPOPUP;
            _mc.Center();
            _mc.ScaleUp();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            if(_mc)
            {
               GLOBAL._layerWindows.removeChild(_mc);
            }
            if(s_PersistantBunker)
            {
               GLOBAL._layerWindows.removeChild(s_PersistantBunker);
            }
            _open = false;
            _mc = null;
            s_PersistantBunker = null;
         }
      }
      
      public static function BunkerStore(param1:String, param2:*, param3:Boolean = false) : Boolean
      {
         var _loc6_:* = undefined;
         var _loc7_:Array = null;
         var _loc8_:Vector.<Object> = null;
         var _loc9_:BFOUNDATION = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         if(param1 == "C100")
         {
            param1 = "C12";
         }
         var _loc4_:int = CREATURES.GetProperty(param1,"cStorage");
         var _loc5_:Boolean = (GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMVIEW) && TRIBES.TribeForID(BASE._wmID).behaviour == "juice";
         if(_bunkerSpace < _loc4_ && !_loc5_)
         {
            return false;
         }
         if(!param3)
         {
            if(param2._monsters[param1])
            {
               param2._monsters[param1] += 1;
            }
            else
            {
               param2._monsters[param1] = 1;
            }
            if(GLOBAL._render)
            {
               if(_loc5_)
               {
                  if(_loc6_ = CREATURES.Spawn(param1,MAP._BUILDINGTOPS,"juice",new Point(param2.x,param2.y),0))
                  {
                     _loc6_.ModeJuice();
                  }
               }
               else
               {
                  _loc7_ = [];
                  _loc8_ = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
                  for each(_loc9_ in _loc8_)
                  {
                     if(_loc9_._countdownBuild.Get() <= 0 && _loc9_.health > 0)
                     {
                        _loc10_ = _loc9_._mc.x - param2.x;
                        _loc11_ = _loc9_._mc.y - param2.y;
                        _loc12_ = int(Math.sqrt(_loc10_ * _loc10_ + _loc11_ * _loc11_));
                        _loc7_.push({
                           "mc":_loc9_,
                           "dist":_loc12_
                        });
                     }
                  }
                  if(_loc7_.length == 0)
                  {
                     return false;
                  }
                  _loc7_.sortOn(["dist"],Array.NUMERIC);
                  _loc9_ = _loc7_[0].mc;
                  CREATURES.Spawn(param1,MAP._BUILDINGTOPS,"bunkering",new Point(param2._mc.x,param2._mc.y),0,GRID.FromISO(_loc9_._mc.x,_loc9_._mc.y),_loc9_);
               }
            }
         }
         return true;
      }
      
      public static function Cull() : void
      {
         _bunkerCapacity = 0;
         _bunkerUsed = 0;
         _bunkerSpace = 0;
      }
      
      public static function Populate() : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:BFOUNDATION = null;
         var _loc9_:Point = null;
         var _loc1_:Array = [];
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BASE.isInfernoMainYardOrOutpost ? HOUSINGBUNKER : BUILDING15);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.health > 0)
            {
               _loc1_.push(_loc3_);
            }
         }
         if(_loc1_.length > 0)
         {
            for(_loc4_ in _creatures)
            {
               if((_loc5_ = int(_creatures[_loc4_])) > 50)
               {
                  _loc5_ = 50;
               }
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc7_ = Math.random() * _loc1_.length;
                  _loc8_ = _loc1_[_loc7_];
                  _loc9_ = GRID.FromISO(_loc8_.x,_loc8_.y);
                  CREATURES.Spawn(_loc4_,MAP._BUILDINGTOPS,"pen",PointInBunker(_loc9_),Math.random() * 360,_loc9_,_loc8_);
                  _loc6_++;
               }
            }
         }
      }
      
      public static function PointInBunker(param1:Point) : Point
      {
         var _loc2_:Rectangle = new Rectangle(30,40,110,80);
         return GRID.ToISO(param1.x + (_loc2_.x + Math.random() * _loc2_.width),param1.y + (_loc2_.y + Math.random() * _loc2_.height),0);
      }
      
      public static function Tick() : void
      {
         if(_open)
         {
         }
      }
      
      public static function isBunkerBuilding(param1:int) : Boolean
      {
         return param1 === 22 || param1 === 128;
      }
   }
}

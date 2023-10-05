package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import gs.*;
   import gs.easing.*;
   
   public class WORKERS
   {
      
      public static var _workers:Array;
      
      public static var _sayings:Object;
       
      
      public function WORKERS()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _workers = [];
         if(BASE.isInfernoMainYardOrOutpost)
         {
            _sayings = {
               "assign":[KEYS.Get("ai_worker_comment1"),KEYS.Get("ai_worker_comment2"),KEYS.Get("ai_worker_comment3"),KEYS.Get("ai_worker_comment5"),KEYS.Get("ai_worker_comment6"),KEYS.Get("ai_worker_comment7")],
               "remove":[KEYS.Get("ai_worker_cancel1"),KEYS.Get("ai_worker_cancel2"),KEYS.Get("ai_worker_cancel3"),KEYS.Get("ai_worker_cancel4")],
               "doneConstruct":[KEYS.Get("ai_worker_doneconstruct1"),KEYS.Get("ai_worker_doneconstruct2"),KEYS.Get("ai_worker_doneconstruct3"),KEYS.Get("ai_worker_doneconstruct4")],
               "doneRepair":[KEYS.Get("ai_worker_donerepair1"),KEYS.Get("ai_worker_donerepair2"),KEYS.Get("ai_worker_donerepair3"),KEYS.Get("ai_worker_donerepair4")],
               "doneUpgrade":[KEYS.Get("ai_worker_doneupgrade1"),KEYS.Get("ai_worker_doneupgrade2"),KEYS.Get("ai_worker_doneupgrade3"),KEYS.Get("ai_worker_doneupgrade4")]
            };
         }
         else
         {
            _sayings = {
               "assign":[KEYS.Get("ui_worker_assign1"),KEYS.Get("ui_worker_assign2"),KEYS.Get("ui_worker_assign3"),KEYS.Get("ui_worker_assign4"),KEYS.Get("ui_worker_assign5"),KEYS.Get("ui_worker_assign6")],
               "remove":[KEYS.Get("ui_worker_remove1"),KEYS.Get("ui_worker_remove2"),KEYS.Get("ui_worker_remove3"),KEYS.Get("ui_worker_remove4")],
               "doneConstruct":[KEYS.Get("ui_worker_doneconstruct1"),KEYS.Get("ui_worker_doneconstruct2"),KEYS.Get("ui_worker_doneconstruct3"),KEYS.Get("ui_worker_doneconstruct4"),KEYS.Get("ui_worker_doneconstruct5"),KEYS.Get("ui_worker_doneconstruct6"),KEYS.Get("ui_worker_doneconstruct7"),KEYS.Get("ui_worker_doneconstruct8")],
               "doneRepair":[KEYS.Get("ui_worker_donerepair1"),KEYS.Get("ui_worker_donerepair2")],
               "doneUpgrade":[KEYS.Get("ui_worker_doneupgrade1"),KEYS.Get("ui_worker_doneupgrade2"),KEYS.Get("ui_worker_doneupgrade3"),KEYS.Get("ui_worker_doneupgrade4"),KEYS.Get("ui_worker_doneupgrade5")]
            };
         }
      }
      
      public static function Spawn() : Object
      {
         var _loc2_:Point = null;
         if(TUTORIAL._stage < 10)
         {
            _loc2_ = new Point(0,0);
         }
         else
         {
            _loc2_ = new Point(GLOBAL._mapWidth / 2 - Math.random() * GLOBAL._mapWidth,GLOBAL._mapHeight / 2 - Math.random() * GLOBAL._mapHeight);
         }
         var _loc1_:WORKER = MAP._BUILDINGTOPS.addChild(new WORKER(MAP._BUILDINGTOPS,_loc2_,Math.random() * 360)) as WORKER;
         _workers.push({
            "mc":_loc1_,
            "task":null
         });
         QUESTS._global.worder_count = _workers.length;
         return {"mc":_loc1_};
      }
      
      public static function Tick() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(GLOBAL._render)
         {
            for(_loc1_ in _workers)
            {
               _loc2_ = _workers[_loc1_];
               _loc2_.mc.Tick();
            }
         }
      }
      
      public static function Assign(param1:BFOUNDATION) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:int = 3000;
         var _loc3_:Object = null;
         for(_loc4_ in _workers)
         {
            if(!(_loc5_ = _workers[_loc4_]).task)
            {
               if((_loc6_ = Point.distance(new Point(_loc5_.mc.x,_loc5_.mc.y),new Point(param1._mc.x,param1._mc.y))) < _loc2_)
               {
                  _loc2_ = _loc6_;
                  _loc3_ = _loc5_;
               }
            }
         }
         if(_loc3_)
         {
            _loc3_.task = param1;
            _loc3_.mc.Target(new Point(param1._mc.x,param1._mc.y + param1._mcFootprint.height / 2),param1);
            _loc3_.mc._targetTask = param1;
            _loc7_ = "";
            if(!GLOBAL._catchup)
            {
               _loc7_ = String(_sayings.assign[int(Math.random() * _sayings.assign.length)]);
               Say(_loc7_,_loc3_.mc);
            }
            else
            {
               _loc3_.mc.x = param1._mc.x;
               _loc3_.mc.y = param1._mc.y;
               _loc3_.mc._targetPosition = new Point(param1._mc.x,param1._mc.y + param1._mcFootprint.height / 2 - 5);
               _loc3_.mc._waypoints = [new Point(param1._mc.x,param1._mc.y + param1._mcFootprint.height / 2 - 5)];
               param1._hasWorker = true;
            }
            return {
               "mc":_loc3_.mc,
               "say":_loc7_
            };
         }
         return null;
      }
      
      public static function Remove(param1:BFOUNDATION, param2:Boolean = true, param3:String = "Construct") : MovieClip
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Point = null;
         for(_loc4_ in _workers)
         {
            if((_loc5_ = _workers[_loc4_]).task == param1)
            {
               _loc5_.task = null;
               _loc5_.mc._targetTask = null;
               param1._hasWorker = false;
               if(GLOBAL._render)
               {
                  _loc5_.mc.Wander();
                  if(param2)
                  {
                     _loc6_ = _sayings["done" + param3];
                     Say(_loc6_[int(Math.random() * _loc6_.length)],_loc5_.mc);
                  }
                  else
                  {
                     Say(_sayings.remove[int(Math.random() * _sayings.remove.length)],_loc5_.mc);
                  }
               }
               else
               {
                  _loc7_ = new Point(param1._mc.x + 20,param1._mc.y + 80);
                  _loc5_.mc._targetPosition = _loc7_;
                  _loc5_.mc._waypoints = [];
                  _loc5_.mc.x = _loc7_.x;
                  _loc5_.mc.y = _loc7_.y;
               }
               return _loc5_.mc;
            }
         }
         return null;
      }
      
      public static function Say(param1:String, param2:MovieClip = null, param3:int = 2000) : void
      {
         if(!param2)
         {
            param2 = _workers[0].mc;
            param2.Target(new Point(param2.x + 20,param2.y + 150));
            param2.Move();
            param2.Update();
         }
         param2.Say(param1,param3);
      }
   }
}

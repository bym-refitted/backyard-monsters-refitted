package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import gs.*;
   import gs.easing.*;
   
   public class QUEUE
   {
      
      public static var _mc:MovieClip;
      
      public static var _items:Object;
      
      public static var _item:Object;
      
      public static var _stack:Array;
      
      public static var _workerCount:int;
      
      public static var _workingCount:int;
      
      public static var _placed:int = 0;
       
      
      public function QUEUE()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _items = {};
         _stack = [];
         _workerCount = 0;
         _workingCount = 0;
      }
      
      public static function Spawn(param1:int = 0) : void
      {
         var _loc3_:int = 0;
         if(!BASE.isMainYard)
         {
            if(_workerCount > 0)
            {
               _workerCount = WORKERS._workers.length;
               return;
            }
            if(param1 > 1)
            {
               param1 = 1;
            }
         }
         if(param1 == 0)
         {
            param1 = 1;
            if(STORE._storeData.BEW)
            {
               if(!BASE.isMainYard)
               {
                  if(STORE._storeData.BEW.q > 0)
                  {
                     LOGGER.Log("log","QUEUE.Spawn Outpost " + BASE._loadedBaseID + "  has store data for " + STORE._storeData.BEW.q + " extra worker(s)");
                  }
               }
               else
               {
                  param1 += STORE._storeData.BEW.q;
               }
            }
         }
         _workerCount += param1;
         var _loc2_:Object = {};
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.WMATTACK && GLOBAL.mode != GLOBAL.e_BASE_MODE.WMVIEW)
         {
            _loc3_ = 0;
            while(_loc3_ < param1)
            {
               _loc2_ = WORKERS.Spawn();
               _stack.push({
                  "id":null,
                  "workermc":_loc2_.mc,
                  "active":false,
                  "expanded":false,
                  "building":null,
                  "title":"",
                  "message":"",
                  "say":""
               });
               _loc3_++;
            }
            UI_WORKERS.Update();
         }
      }
      
      public static function CanDo() : Object
      {
         var errorName:String = null;
         var stackIndex:int = 0;
         while(stackIndex < _stack.length)
         {
            if(!_stack[stackIndex].active)
            {
               return {
                  "error":false,
                  "errormessage":""
               };
            }
            stackIndex++;
         }
         if(!STORE.CheckUpgrade("BEW"))
         {
            if(GLOBAL._bStore)
            {
               errorName = KEYS.Get("ui_worker_busy");
            }
            else
            {
               errorName = KEYS.Get("ui_worker_waitforfinish");
               if(TUTORIAL._stage >= 200)
               {
                  errorName += " " + KEYS.Get("ui_worker_impatient");
               }
               else
               {
                  errorName += " " + KEYS.Get("ui_worker_tute");
               }
            }
         }
         else if(STORE.CheckUpgrade("BEW").q + 1 == 5)
         {
            errorName = KEYS.Get("ui_worker_5busy");
         }
         else
         {
            errorName = KEYS.Get("ui_worker_xbusy",{
               "v1":STORE.CheckUpgrade("BEW").q + 1,
               "v2":STORE.CheckUpgrade("BEW").q + 1
            });
         }
         return {
            "error":true,
            "errormessage":errorName
         };
      }
      
      public static function GetBuilding() : BFOUNDATION
      {
         var _loc1_:BFOUNDATION = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BFOUNDATION = null;
         if(!BASE.isMainYard)
         {
            if(_stack[0].active)
            {
               return _stack[0].building;
            }
            return null;
         }
         _loc1_ = null;
         _loc2_ = 2000000000;
         _loc3_ = 0;
         while(_loc3_ < _stack.length)
         {
            if((_loc4_ = _stack[_loc3_].building)._type != 7 && _loc4_._countdownUpgrade.Get() + _loc4_._countdownBuild.Get() + _loc4_._countdownFortify.Get() < _loc2_)
            {
               _loc1_ = _loc4_;
               _loc2_ = _loc4_._countdownUpgrade.Get() + _loc4_._countdownBuild.Get() + _loc4_._countdownFortify.Get();
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function GetFinishCost() : int
      {
         var _loc2_:int = 0;
         var _loc1_:BFOUNDATION = GetBuilding();
         if(_loc1_)
         {
            _loc2_ = _loc1_._countdownUpgrade.Get() + _loc1_._countdownBuild.Get() + _loc1_._countdownFortify.Get();
            return STORE.GetTimeCost(_loc2_);
         }
         return 0;
      }
      
      public static function Add(param1:String, buildingFoundation:BFOUNDATION = null) : Boolean
      {
         var stackIndex:int = 0;
         var _loc4_:Object = null;
         var worker:Object = null;
         _items[param1] = {
            "id":param1,
            "building":buildingFoundation
         };

         var test = CanDo();
         if(test.error){
            // GLOBAL.Message("QUEUE.as - CanDo: " + test.errormessage);
         }// test.errorMessage
         if(!test.error)
         {
            if(worker = WORKERS.Assign(buildingFoundation))
            {
               stackIndex = 0;
               while(stackIndex < _stack.length)
               {
                  if((_loc4_ = _stack[stackIndex]).workermc == worker.mc)
                  {
                     _stack[stackIndex].id = param1;
                     _stack[stackIndex].active = true;
                     _stack[stackIndex].building = buildingFoundation;
                     _stack[stackIndex].say = worker.say;
                     _stack[stackIndex].timestamp = GLOBAL.Timestamp();
                     break;
                  }
                  stackIndex++;
               }
               _placed += 1;
            }
            Sort();
            Tick();
            return true;
         }
         return false;
      }
      
      public static function Remove(param1:String, param2:Boolean, param3:BFOUNDATION = null) : MovieClip
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         delete _items[param1];
         _loc4_ = 0;
         while(_loc4_ < _stack.length)
         {
            if((_loc5_ = _stack[_loc4_]).id == param1)
            {
               _stack[_loc4_].active = false;
               _stack[_loc4_].id = "";
               _stack[_loc4_].message = "";
               _stack[_loc4_].say = "";
               _stack[_loc4_].timestamp = "";
               Sort();
               return WORKERS.Remove(_loc5_.building,param2);
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function Tick() : void
      {
         var upgradingCount:int = 0;
         var i:int = 0;
         var s:Object = null;
         var msg:String = null;
         var title:String = null;
         try
         {
            _workingCount = 0;
            upgradingCount = 0;
            i = 0;
            while(i < _stack.length)
            {
               s = _stack[i];
               if(!STORE._storeData.BST)
               {
               }
               if(s.active)
               {
                  ++_workingCount;
                  if(Boolean(s.building) && s.building._countdownUpgrade.Get() > 0)
                  {
                     upgradingCount++;
                  }
                  msg = "";
                  title = "";
                  if(s.building._hasWorker)
                  {
                     if(Boolean(s.building._hasResources) || s.building._repairing > 0)
                     {
                        title = String(s.title);
                        msg = String(s.message);
                     }
                     else
                     {
                        title = KEYS.Get("ui_worker_waiting");
                     }
                  }
                  else
                  {
                     s.title = KEYS.Get("ui_worker_walking");
                     s.message = s.say;
                     title = KEYS.Get("ui_worker_walking");
                     msg = String(s.say);
                  }
                  if(!s.expanded)
                  {
                     s.expanded = true;
                  }
               }
               else if(s.expanded)
               {
                  s.expanded = false;
               }
               i++;
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Queue.Tick: " + e.message + " | " + e.getStackTrace());
         }
         UI_WORKERS.Update();
      }
      
      public static function Update(param1:String, param2:String, param3:String) : void
      {
         var _loc5_:Object = null;
         var _loc4_:int = 0;
         while(_loc4_ < _stack.length)
         {
            if((_loc5_ = _stack[_loc4_]).id == param1)
            {
               _stack[_loc4_].title = param2;
               _stack[_loc4_].message = param3;
               break;
            }
            _loc4_++;
         }
         Tick();
      }
      
      public static function JumpToWorker(param1:int) : void
      {
         var _loc2_:MovieClip = _stack[param1].workermc;
         MAP.FocusTo(_loc2_.x,_loc2_.y,0.5);
      }
      
      public static function Move(param1:int, param2:int) : void
      {
      }
      
      public static function Speed(param1:MouseEvent) : void
      {
         STORE.SpeedUp("SP4");
      }
      
      public static function Sort() : void
      {
         var _loc3_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < _stack.length)
         {
            _loc3_ = {
               "stack":_stack[_loc2_],
               "active":Number(_stack[_loc2_].active)
            };
            if(_loc3_.stack.building)
            {
               if(_loc3_.stack.building._type == 7)
               {
                  _loc3_.active = 0.5;
               }
            }
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         _loc1_.sortOn("active",Array.NUMERIC | Array.DESCENDING);
         _loc2_ = 0;
         while(_loc2_ < _stack.length)
         {
            _stack[_loc2_] = _loc1_[_loc2_].stack;
            _loc2_++;
         }
      }
   }
}

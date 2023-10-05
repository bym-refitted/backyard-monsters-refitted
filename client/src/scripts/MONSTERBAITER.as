package
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MONSTERBAITER
   {
      
      public static const TYPE:uint = 19;
      
      public static var _mc:MONSTERBAITERPOPUP;
      
      public static var _attacking:int = 0;
      
      public static var _scaredAway:Boolean = false;
      
      public static var _musk:int = 0;
      
      public static var _muskLimit:int = 300;
      
      public static var _replenishRate:int = 0;
      
      public static var _currentAttackers:Array;
      
      public static var _attPrep:int = 0;
      
      public static var _attackPt:Point;
      
      public static var _queue:Object = {};
      
      public static var _attackDir:int = 0;
      
      public static var _frameNumber:int = 0;
       
      
      public function MONSTERBAITER()
      {
         super();
      }
      
      public static function Tick() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(GLOBAL._bBaiter)
         {
            _musk = _muskLimit;
            if(_mc)
            {
               _mc.Update();
            }
            if(_attPrep > 0)
            {
               if(_attPrep == 1)
               {
                  UI2._warning.Update("<font size=\"28\">" + KEYS.Get("msg_dontpanic") + "</font>");
                  _attPrep = 0;
                  _loc1_ = [].concat();
                  for(_loc2_ in _queue)
                  {
                     if(_queue[_loc2_] > 0)
                     {
                        _loc4_ = [_loc2_,"bounce",_queue[_loc2_],_attackPt.x,_attackPt.y,0,0];
                        _loc1_.push(_loc4_);
                     }
                  }
                  WMATTACK._type = WMATTACK.TYPE_DAMAGE;
                  MONSTERBAITER._currentAttackers = CUSTOMATTACKS.CustomAttack(_loc1_);
                  for each(_loc3_ in _currentAttackers)
                  {
                     for each(_loc5_ in _loc3_)
                     {
                        _loc5_._hitLimit = int.MAX_VALUE;
                     }
                  }
               }
               else
               {
                  UI2._warning.Update("<font size=\"28\">" + int(_attPrep - 1) + "</font>");
                  if(BASE.isInfernoMainYardOrOutpost)
                  {
                     SOUNDS.PlayMusic("musicipanic");
                  }
                  else
                  {
                     SOUNDS.PlayMusic("musicpanic");
                  }
                  --_attPrep;
               }
            }
            ++_frameNumber;
         }
      }
      
      public static function PrepAttack() : void
      {
         _scaredAway = true;
         _attPrep = 4;
         _attacking = 1;
         MAP.FocusTo(GLOBAL._bBaiter.x,GLOBAL._bBaiter.y,2);
         UI2.Show("warning");
         BASE.Save();
         UI2.Hide("top");
         UI2.Hide("bottom");
      }
      
      public static function End(param1:Boolean = false) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         _scaredAway = true;
         if(!param1)
         {
            SOUNDS.Play("wmbhorn");
         }
         UI2.Hide("scareAway");
         UI2.Hide("warning");
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicibuild");
         }
         else
         {
            SOUNDS.PlayMusic("musicbuild");
         }
         for each(_loc2_ in _currentAttackers)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_].changeModeRetreat();
               _loc3_++;
            }
         }
         _attacking = 0;
         _currentAttackers = [];
      }
      
      public static function Setup(param1:Object = null) : void
      {
         if(param1)
         {
            if(Boolean(param1.queue) && param1.queue != undefined)
            {
               if(param1.queue.C100 != undefined)
               {
                  param1.queue.C12 = param1.queue.C100;
                  delete param1.queue.C100;
               }
               _queue = param1.queue;
            }
            if(Boolean(param1.attackDir) && param1.attackDir != undefined)
            {
               _attackDir = param1.attackDir;
            }
            if(Boolean(param1.musk) && param1.musk != undefined)
            {
               _musk = param1.musk;
            }
         }
      }
      
      public static function Update() : void
      {
         var _loc1_:Object = null;
         try
         {
            if(GLOBAL._bBaiter != null)
            {
               _loc1_ = GLOBAL._buildingProps[18];
               _muskLimit = _loc1_.capacity[GLOBAL._bBaiter._lvl.Get() - 1];
               _replenishRate = _loc1_.produce[GLOBAL._bBaiter._lvl.Get() - 1];
            }
         }
         catch(e:*)
         {
         }
      }
      
      public static function Fill() : void
      {
         _musk = _muskLimit;
      }
      
      public static function Export() : Object
      {
         return {
            "queue":_queue,
            "attackDir":_attackDir,
            "musk":_musk
         };
      }
      
      public static function Show() : void
      {
         if(!_mc)
         {
            SOUNDS.Play("click1");
            GLOBAL.BlockerAdd();
            _mc = GLOBAL._layerWindows.addChild(new MONSTERBAITERPOPUP()) as MONSTERBAITERPOPUP;
            _mc.Setup(_queue,_attackDir);
            _mc.Center();
            _mc.ScaleUp();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("close");
         GLOBAL.BlockerRemove();
         if(_mc)
         {
            GLOBAL._layerWindows.removeChild(_mc);
            _mc = null;
         }
      }
   }
}

package gs
{
   import flash.errors.*;
   import flash.utils.*;
   import gs.utils.tween.*;
   
   public class OverwriteManager
   {
      
      public static const version:Number = 3.12;
      
      public static const NONE:int = 0;
      
      public static const ALL:int = 1;
      
      public static const AUTO:int = 2;
      
      public static const CONCURRENT:int = 3;
      
      public static var mode:int;
      
      public static var enabled:Boolean;
       
      
      public function OverwriteManager()
      {
         super();
      }
      
      public static function init(param1:int = 2) : int
      {
         if(TweenLite.version < 10.09)
         {
         }
         TweenLite.overwriteManager = OverwriteManager;
         mode = param1;
         enabled = true;
         return mode;
      }
      
      public static function manageOverwrites(param1:TweenLite, param2:Array) : void
      {
         var _loc7_:int = 0;
         var _loc8_:TweenLite = null;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:TweenInfo = null;
         var _loc14_:Array = null;
         var _loc3_:Object = param1.vars;
         var _loc4_:int;
         if((_loc4_ = _loc3_.overwrite == undefined ? mode : int(_loc3_.overwrite)) < 2 || param2 == null)
         {
            return;
         }
         var _loc5_:Number = param1.startTime;
         var _loc6_:Array = [];
         var _loc9_:int = -1;
         _loc7_ = int(param2.length - 1);
         while(_loc7_ > -1)
         {
            if((_loc8_ = param2[_loc7_]) == param1)
            {
               _loc9_ = _loc7_;
            }
            else if(_loc7_ < _loc9_ && _loc8_.startTime <= _loc5_ && _loc8_.startTime + _loc8_.duration * 1000 / _loc8_.combinedTimeScale > _loc5_)
            {
               _loc6_[_loc6_.length] = _loc8_;
            }
            _loc7_--;
         }
         if(_loc6_.length == 0 || param1.tweens.length == 0)
         {
            return;
         }
         if(_loc4_ == AUTO)
         {
            _loc10_ = param1.tweens;
            _loc11_ = {};
            _loc7_ = int(_loc10_.length - 1);
            while(_loc7_ > -1)
            {
               if((_loc13_ = _loc10_[_loc7_]).isPlugin)
               {
                  if(_loc13_.name == "_MULTIPLE_")
                  {
                     _loc12_ = int((_loc14_ = _loc13_.target.overwriteProps).length - 1);
                     while(_loc12_ > -1)
                     {
                        _loc11_[_loc14_[_loc12_]] = true;
                        _loc12_--;
                     }
                  }
                  else
                  {
                     _loc11_[_loc13_.name] = true;
                  }
                  _loc11_[_loc13_.target.propName] = true;
               }
               else
               {
                  _loc11_[_loc13_.name] = true;
               }
               _loc7_--;
            }
            _loc7_ = int(_loc6_.length - 1);
            while(_loc7_ > -1)
            {
               killVars(_loc11_,_loc6_[_loc7_].exposedVars,_loc6_[_loc7_].tweens);
               _loc7_--;
            }
         }
         else
         {
            _loc7_ = int(_loc6_.length - 1);
            while(_loc7_ > -1)
            {
               _loc6_[_loc7_].enabled = false;
               _loc7_--;
            }
         }
      }
      
      public static function killVars(param1:Object, param2:Object, param3:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TweenInfo = null;
         _loc4_ = int(param3.length - 1);
         while(_loc4_ > -1)
         {
            if((_loc6_ = param3[_loc4_]).name in param1)
            {
               param3.splice(_loc4_,1);
            }
            else if(_loc6_.isPlugin && _loc6_.name == "_MULTIPLE_")
            {
               _loc6_.target.killProps(param1);
               if(_loc6_.target.overwriteProps.length == 0)
               {
                  param3.splice(_loc4_,1);
               }
            }
            _loc4_--;
         }
         for(_loc5_ in param1)
         {
            delete param2[_loc5_];
         }
      }
   }
}

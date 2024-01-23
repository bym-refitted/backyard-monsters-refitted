package com.monsters.managers
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class InstanceManager
   {
      
      public static const k_ClassDisposalMethod:String = "Clean";
      
      protected static const k_Inheritance:Dictionary = new Dictionary();
      
      protected static const k_Instances:Dictionary = new Dictionary();
       
      
      public function InstanceManager()
      {
         super();
      }
      
      public static function getInstance(param1:Class) : Object
      {
         var _loc4_:Class = null;
         var _loc5_:String = null;
         var _loc2_:Class = new param1();
         var _loc3_:Class = param1;
         while(_loc3_ != null && _loc3_ != Object)
         {
            k_Instances[_loc3_] = k_Instances[_loc3_] || new Vector.<Object>();
            k_Instances[_loc3_].push(_loc2_);
            _loc4_ = _loc3_;
            if(k_Inheritance[_loc4_] !== undefined)
            {
               _loc3_ = k_Inheritance[_loc3_];
            }
            else
            {
               _loc3_ = !!(_loc5_ = getQualifiedSuperclassName(_loc3_)) ? getDefinitionByName(_loc5_) as Class : null;
               k_Inheritance[_loc4_] = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public static function getInstancesByClass(param1:Class) : Vector.<Object>
      {
         if(k_Instances[param1] === undefined)
         {
            return new Vector.<Object>(0);
         }
         return k_Instances[param1];
      }
      
      public static function clearInstance(param1:Object) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:int = 0;
         var _loc2_:Class = param1.constructor;
         while(_loc2_ != null && _loc2_ != Object)
         {
            if((_loc5_ = (_loc4_ = k_Instances[_loc2_]).indexOf(param1)) !== -1)
            {
               _loc4_.splice(_loc5_,1);
            }
            _loc3_ = _loc2_;
            if(k_Inheritance[_loc3_] !== undefined)
            {
               _loc2_ = k_Inheritance[_loc2_];
            }
         }
         if(param1.hasOwnProperty(k_ClassDisposalMethod) && param1[k_ClassDisposalMethod] is Function)
         {
            param1[k_ClassDisposalMethod].call(param1);
         }
      }
      
      public static function clearAll() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:Class = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         for(_loc4_ in k_Instances)
         {
            _loc1_ = k_Instances[_loc4_];
            _loc5_ = int(_loc1_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc3_ = _loc1_[_loc5_];
               _loc2_ = _loc3_.constructor;
               if(_loc4_ == _loc2_ && _loc3_.hasOwnProperty(k_ClassDisposalMethod) && _loc3_[k_ClassDisposalMethod] is Function)
               {
                  _loc3_[k_ClassDisposalMethod].call(_loc3_);
               }
               _loc5_--;
            }
            k_Instances[_loc4_] = new Vector.<Object>();
         }
      }
      
      public static function addInstance(param1:Object) : void
      {
         var _loc3_:Class = null;
         var _loc4_:String = null;
         var _loc2_:Class = param1.constructor;
         while(_loc2_ != null && _loc2_ != Object)
         {
            k_Instances[_loc2_] = k_Instances[_loc2_] || new Vector.<Object>();
            k_Instances[_loc2_].push(param1);
            _loc3_ = _loc2_;
            if(k_Inheritance[_loc3_] !== undefined)
            {
               _loc2_ = k_Inheritance[_loc2_];
            }
            else
            {
               _loc2_ = !!(_loc4_ = getQualifiedSuperclassName(_loc2_)) ? getDefinitionByName(_loc4_) as Class : null;
               k_Inheritance[_loc3_] = _loc2_;
            }
         }
      }
      
      public static function removeInstance(param1:Object) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:int = 0;
         var _loc2_:Class = param1.constructor;
         while(_loc2_ != null && _loc2_ != Object)
         {
            if((_loc5_ = (_loc4_ = k_Instances[_loc2_]).indexOf(param1)) !== -1)
            {
               _loc4_.splice(_loc5_,1);
            }
            _loc3_ = _loc2_;
            if(k_Inheritance[_loc3_] !== undefined)
            {
               _loc2_ = k_Inheritance[_loc2_];
            }
         }
      }
      
      public static function removeAll() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in k_Instances)
         {
            k_Instances[_loc1_] = new Vector.<Object>();
         }
      }
   }
}

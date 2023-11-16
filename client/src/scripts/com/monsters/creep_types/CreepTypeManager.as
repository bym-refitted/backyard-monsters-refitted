package com.monsters.creep_types
{
   public class CreepTypeManager
   {
      
      private static var s_Instance:CreepTypeManager = null;
       
      
      private var m_CreepTypes:Vector.<CreepType>;
      
      public function CreepTypeManager(param1:SingletonLock)
      {
         this.m_CreepTypes = new Vector.<CreepType>();
         super();
      }
      
      public static function get instance() : CreepTypeManager
      {
         return s_Instance = s_Instance || new CreepTypeManager(new SingletonLock());
      }
      
      internal function RegisterCreepType(param1:CreepType) : void
      {
         if(this.m_CreepTypes.indexOf(param1) == -1)
         {
            this.m_CreepTypes.push(param1);
         }
      }
      
      internal function DeregisterCreepType(param1:CreepType) : void
      {
         var _loc2_:int = this.m_CreepTypes.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.m_CreepTypes.splice(_loc2_,1);
         }
      }
      
      public function AddExposedCreepTypes(param1:Object) : void
      {
         var _loc4_:CreepType = null;
         var _loc2_:uint = this.m_CreepTypes.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.m_CreepTypes[_loc3_];
            if(param1[_loc4_.id] != null)
            {
               _loc4_.dependent = param1[_loc4_.id].dependent;
               _loc4_.type = param1[_loc4_.id].type;
               _loc4_.movement = param1[_loc4_.id].movement;
               _loc4_.pathing = param1[_loc4_.id].pathing;
               _loc4_.blocked = param1[_loc4_.id].blocked;
               _loc4_.classType = param1[_loc4_.id].classType;
            }
            param1[_loc4_.id] = _loc4_;
            _loc3_++;
         }
      }
   }
}

class SingletonLock
{
    
   
   public function SingletonLock()
   {
      super();
   }
}

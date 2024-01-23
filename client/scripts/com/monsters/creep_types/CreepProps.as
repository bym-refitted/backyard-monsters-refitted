package com.monsters.creep_types
{
   import utils.exposed.ExposedStructure;
   
   public class CreepProps extends ExposedStructure
   {
       
      
      private var m_Speed:Number;
      
      private var m_Health:uint;
      
      private var m_Damage:uint;
      
      private var m_BuildTime:uint;
      
      private var m_GooCost:uint;
      
      private var m_StorageCost:uint;
      
      private var m_Bucket:uint;
      
      private var m_TargetGroup:uint;
      
      public function CreepProps()
      {
         super();
      }
      
      public function get speed() : Number
      {
         return this.m_Speed;
      }
      
      public function set speed(param1:Number) : void
      {
         this.m_Speed = param1;
      }
      
      public function get health() : uint
      {
         return this.m_Health;
      }
      
      public function set health(param1:uint) : void
      {
         this.m_Health = param1;
      }
      
      public function get damage() : uint
      {
         return this.m_Damage;
      }
      
      public function set damage(param1:uint) : void
      {
         this.m_Damage = param1;
      }
      
      public function get buildTime() : uint
      {
         return this.m_BuildTime;
      }
      
      public function set buildTime(param1:uint) : void
      {
         this.m_BuildTime = param1;
      }
      
      public function get gooCost() : uint
      {
         return this.m_GooCost;
      }
      
      public function set gooCost(param1:uint) : void
      {
         this.m_GooCost = param1;
      }
      
      public function get storageCost() : uint
      {
         return this.m_StorageCost;
      }
      
      public function set storageCost(param1:uint) : void
      {
         this.m_StorageCost = param1;
      }
      
      public function get bucket() : uint
      {
         return this.m_Bucket;
      }
      
      public function set bucket(param1:uint) : void
      {
         this.m_Bucket = param1;
      }
      
      public function get targetGroup() : uint
      {
         return this.m_TargetGroup;
      }
      
      public function set targetGroup(param1:uint) : void
      {
         this.m_TargetGroup = param1;
      }
      
      override protected function _Init() : void
      {
         super._Init();
      }
      
      override protected function _Destroy() : void
      {
         super._Destroy();
      }
   }
}

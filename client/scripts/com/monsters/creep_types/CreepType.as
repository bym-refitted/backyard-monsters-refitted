package com.monsters.creep_types
{
   import utils.exposed.ExposedObject;
   
   public class CreepType extends ExposedObject
   {
       
      
      private var m_Id:String;
      
      private var m_Name:String;
      
      private var m_Description:String;
      
      private var m_Index:uint;
      
      private var m_Page:uint;
      
      private var m_Order:uint;
      
      private var m_Resource:uint;
      
      private var m_Time:uint;
      
      private var m_Level:uint;
      
      private var m_Stream:Vector.<String>;
      
      private var m_BaseProps:CreepProps;
      
      private var m_Upgrades:Vector.<CreepUpgrade>;
      
      public var trainingCosts:Array;
      
      public var props:Object;
      
      public var dependent:String = "";
      
      public var type:String = "";
      
      public var movement:String = "";
      
      public var pathing:String = "";
      
      public var blocked:Boolean = false;
      
      public var classType:Class = null;
      
      public function CreepType()
      {
         this.m_Stream = new Vector.<String>();
         this.m_BaseProps = new CreepProps();
         this.m_Upgrades = new Vector.<CreepUpgrade>();
         this.trainingCosts = new Array();
         this.props = new Object();
         super();
      }
      
      public function get id() : String
      {
         return this.m_Id;
      }
      
      public function set id(param1:String) : void
      {
         this.m_Id = param1;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function set name(param1:String) : void
      {
         this.m_Name = param1;
      }
      
      public function get description() : String
      {
         return this.m_Description;
      }
      
      public function set description(param1:String) : void
      {
         this.m_Description = param1;
      }
      
      public function get index() : uint
      {
         return this.m_Index;
      }
      
      public function set index(param1:uint) : void
      {
         this.m_Index = param1;
      }
      
      public function get page() : uint
      {
         return this.m_Page;
      }
      
      public function set page(param1:uint) : void
      {
         this.m_Page = param1;
      }
      
      public function get order() : uint
      {
         return this.m_Order;
      }
      
      public function set order(param1:uint) : void
      {
         this.m_Order = param1;
      }
      
      public function get resource() : uint
      {
         return this.m_Resource;
      }
      
      public function set resource(param1:uint) : void
      {
         this.m_Resource = param1;
      }
      
      public function get time() : uint
      {
         return this.m_Time;
      }
      
      public function set time(param1:uint) : void
      {
         this.m_Time = param1;
      }
      
      public function get level() : uint
      {
         return this.m_Level;
      }
      
      public function set level(param1:uint) : void
      {
         this.m_Level = param1;
      }
      
      public function get baseProps() : CreepProps
      {
         return this.m_BaseProps;
      }
      
      public function set baseProps(param1:CreepProps) : void
      {
         this.m_BaseProps = param1;
      }
      
      public function get upgrades() : Vector.<CreepUpgrade>
      {
         return this.m_Upgrades;
      }
      
      public function set upgrades(param1:Vector.<CreepUpgrade>) : void
      {
         this.m_Upgrades = param1;
      }
      
      public function get stream() : Vector.<String>
      {
         return this.m_Stream;
      }
      
      public function set stream(param1:Vector.<String>) : void
      {
         this.m_Stream = param1;
      }
      
      override protected function _Init() : void
      {
         var _loc3_:CreepUpgrade = null;
         super._Init();
         CreepTypeManager.instance.RegisterCreepType(this);
         this.props.speed = [this.m_BaseProps.speed];
         this.props.health = [this.m_BaseProps.health];
         this.props.damage = [this.m_BaseProps.damage];
         this.props.cTime = [this.m_BaseProps.buildTime];
         this.props.cResource = [this.m_BaseProps.gooCost];
         this.props.cStorage = [this.m_BaseProps.storageCost];
         this.props.bucket = [this.m_BaseProps.bucket];
         this.props.targetGroup = [this.m_BaseProps.targetGroup];
         var _loc1_:uint = this.m_Upgrades.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.m_Upgrades[_loc2_];
            this.trainingCosts.push([_loc3_.upgradePuttyCost,_loc3_.upgradeTime]);
            this.props.speed.push(_loc3_.upgradeProps.speed);
            this.props.health.push(_loc3_.upgradeProps.health);
            this.props.damage.push(_loc3_.upgradeProps.damage);
            this.props.cTime.push(_loc3_.upgradeProps.buildTime);
            this.props.cResource.push(_loc3_.upgradeProps.gooCost);
            this.props.cStorage.push(_loc3_.upgradeProps.storageCost);
            this.props.bucket.push(_loc3_.upgradeProps.bucket);
            this.props.targetGroup.push(_loc3_.upgradeProps.targetGroup);
            _loc2_++;
         }
      }
      
      override protected function _Destroy() : void
      {
         CreepTypeManager.instance.DeregisterCreepType(this);
         this.trainingCosts.length = 0;
         this.trainingCosts = null;
         this.props = null;
         super._Destroy();
      }
   }
}

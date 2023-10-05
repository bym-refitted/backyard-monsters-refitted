package com.monsters.baseplanner
{
   public class PlannerNode
   {
      
      public static const TYPE_DEFENSIVE:String = "defensive";
      
      public static const TYPE_BUILDING:String = "building";
      
      public static const TYPE_RESOURCE:String = "resource";
      
      public static const TYPE_DECORATION:String = "decoration";
      
      public static const TYPE_TRAP:String = "trap";
      
      public static const TYPE_WALL:String = "wall";
      
      public static const TYPE_MISC:String = "misc";
      
      protected static const MAX_TEXT_BEFORE_LEVEL:int = 16;
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var id:int;
      
      public var type:int;
      
      public var level:int;
      
      public var fortification:int;
      
      public var building:BFOUNDATION;
      
      public var props:Object;
      
      private var shootrange:int;
      
      public var category:String;
      
      public var categoryName:String;
      
      public var name:String;
      
      public var displayName:String;
      
      public var displayNameFull:String;
      
      public var stored:int;
      
      public var order:int;
      
      public var isSet:Boolean;
      
      public function PlannerNode(param1:BFOUNDATION, param2:Number = 0, param3:Number = 0, param4:int = 0)
      {
         super();
         this.building = param1;
         this.x = param2;
         this.y = param3;
         this.id = param1._id;
         this.type = param1._type;
         this.level = param1._lvl.Get();
         this.fortification = param1._fortification.Get();
         this.order = param4;
         this.shootrange = param1._range;
         this.name = KEYS.Get(GLOBAL._buildingProps[this.type - 1].name);
         this.defineCategory(param1._type);
         if(this.category != TYPE_DECORATION)
         {
            if(this.name.length > MAX_TEXT_BEFORE_LEVEL && this.name.indexOf(" ") != this.name.lastIndexOf(" "))
            {
               this.displayName = this.name.substr(0,this.name.lastIndexOf(" "));
            }
            else
            {
               this.displayName = this.name;
            }
            if(param1._buildingProps.type != "enemy")
            {
               this.displayName += " " + KEYS.Get("basePlanner_buildingLevel") + param1._lvl.Get();
            }
         }
         else
         {
            this.displayName = this.name;
         }
         this.displayNameFull = this.displayName;
         if(this.building._fortification.Get() > 0)
         {
            this.displayNameFull += " " + KEYS.Get("basePlanner_buildingFort") + " " + param1._fortification.Get();
         }
      }
      
      public function place(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function store() : void
      {
         this.x;
         this.y;
         this.stored = 1;
      }
      
      public function get range() : int
      {
         return this.shootrange;
      }
      
      public function defineCategory(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.props = GLOBAL._buildingProps[param1 - 1];
         if(!this.props)
         {
            return;
         }
         var _loc4_:int = int(this.props.group);
         var _loc5_:String = String(this.props.type);
         switch(_loc4_)
         {
            case 1:
               _loc2_ = TYPE_RESOURCE;
               _loc3_ = KEYS.Get("basePlanner_catResource");
               break;
            case 2:
               _loc2_ = TYPE_BUILDING;
               _loc3_ = KEYS.Get("basePlanner_catBuilding");
               break;
            case 3:
               _loc2_ = TYPE_DEFENSIVE;
               _loc3_ = KEYS.Get("basePlanner_catDefensive");
               if(_loc5_ == "wall")
               {
                  _loc2_ = TYPE_WALL;
                  _loc3_ = KEYS.Get("basePlanner_catWall");
               }
               else if(_loc5_ == "trap")
               {
                  _loc2_ = TYPE_TRAP;
                  _loc3_ = KEYS.Get("basePlanner_catTrap");
               }
               break;
            case 4:
               _loc2_ = TYPE_DECORATION;
               _loc3_ = KEYS.Get("basePlanner_catDecoration");
               break;
            default:
               _loc2_ = TYPE_MISC;
               _loc3_ = KEYS.Get("basePlanner_catMisc");
         }
         this.categoryName = _loc3_;
         this.category = _loc2_;
      }
   }
}

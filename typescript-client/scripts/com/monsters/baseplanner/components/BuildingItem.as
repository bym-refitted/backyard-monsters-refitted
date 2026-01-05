package com.monsters.baseplanner.components
{
   import com.monsters.baseplanner.PlannerDesignView;
   import com.monsters.baseplanner.PlannerNode;
   import com.monsters.baseplanner.events.BasePlannerNodeEvent;
   import com.monsters.debug.Console;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BuildingItem extends PlannerItem
   {
      
      public static const TYPE_DEFENSIVE:String = "defensive";
      
      public static const TYPE_BUILDING:String = "building";
      
      public static const TYPE_RESOURCE:String = "resource";
      
      public static const TYPE_DECORATION:String = "decoration";
      
      public static const TYPE_TRAP:String = "trap";
      
      public static const TYPE_WALL:String = "wall";
      
      public static const TYPE_MISC:String = "misc";
       
      
      public var props:Object;
      
      public var node:PlannerNode;
      
      public var category:String;
      
      public var desc:String;
      
      private var mcX:Number;
      
      private var mcY:Number;
      
      private var mcSize:Number;
      
      public function BuildingItem(param1:PlannerNode)
      {
         super();
         this.node = param1;
         mc = new BasePlannerPopup_DisplayItem_Building();
         addChild(mc);
         if(YARD_PROPS._yardProps[this.node.type - 1].type == "decoration")
         {
            size = new Rectangle(0,0,YARD_PROPS._yardProps[this.node.type - 1].size,YARD_PROPS._yardProps[this.node.type - 1].size);
         }
         else
         {
            size = new Rectangle(0,0,this.node.building._footprint[0].width,this.node.building._footprint[0].height);
         }
         this.category = this.defineCategory(this.node.type);
         this.desc = this.node.name + " " + KEYS.Get("basePlanner_buildingLevel") + this.node.level;
         x = int(this.node.x / PlannerDesignView.MOUSE_POSITION_SNAP_THRESHHOLD) * PlannerDesignView.MOUSE_POSITION_SNAP_THRESHHOLD;
         y = int(this.node.y / PlannerDesignView.MOUSE_POSITION_SNAP_THRESHHOLD) * PlannerDesignView.MOUSE_POSITION_SNAP_THRESHHOLD;
         this.setPositionReference();
         mc.width = size.width;
         mc.height = size.height;
         this.mcSize = mc.width;
         mc.x = mc.width / 2;
         mc.y = mc.height / 2;
         mc.mcFrame.gotoAndStop(1);
         mc.mcBG.gotoAndStop(this.category);
         if(this.category == TYPE_TRAP && this.node.type == 117)
         {
            mc.mcBG.gotoAndStop("htrap");
         }
         mc.mcIcon.gotoAndStop(this.node.type);
         mc.mcInvalid.visible = false;
         this.toggleMoreInfo(false);
      }
      
      public function rangeCategory() : uint
      {
         if(YARD_PROPS._yardProps[this.node.type - 1].attackType)
         {
            return YARD_PROPS._yardProps[this.node.type - 1].attackType;
         }
         return 0;
      }
      
      public function updateScale(param1:Number) : void
      {
         this.scaleX = this.scaleY = param1;
      }
      
      public function get scale() : Number
      {
         return scaleX;
      }
      
      public function get widthsize() : Number
      {
         return this.mcSize;
      }
      
      public function defineCategory(param1:int) : String
      {
         var _loc2_:String = null;
         this.props = GLOBAL._buildingProps[param1 - 1];
         if(!this.props)
         {
            Console.warning("props fail" + param1);
            return null;
         }
         var _loc3_:int = int(this.props.group);
         var _loc4_:String = String(this.props.type);
         switch(_loc3_)
         {
            case 1:
               _loc2_ = TYPE_RESOURCE;
               break;
            case 2:
               _loc2_ = TYPE_BUILDING;
               break;
            case 3:
               _loc2_ = TYPE_DEFENSIVE;
               if(_loc4_ == "wall")
               {
                  _loc2_ = TYPE_WALL;
               }
               else if(_loc4_ == "trap")
               {
                  _loc2_ = TYPE_TRAP;
               }
               break;
            case 4:
               _loc2_ = TYPE_DECORATION;
               break;
            default:
               _loc2_ = TYPE_MISC;
         }
         return _loc2_;
      }
      
      public function setPositionReference() : Point
      {
         this.mcX = x;
         this.mcY = y;
         this.node.place(x,y);
         return new Point(this.mcX,this.mcY);
      }
      
      public function resetPositionReference() : void
      {
         x = this.mcX;
         y = this.mcY;
      }
      
      public function toggleMoreInfo(param1:Boolean = false, param2:Boolean = true) : void
      {
         if(this.node.category == PlannerNode.TYPE_DECORATION)
         {
            mc.mcFort.mcLevel.tLabel.visible = false;
            mc.mcFort.mcLevel.tLabel.htmlText = "";
            mc.mcLevel.tLabel.htmlText = "";
            mc.mcLevel.tLabel.visible = false;
            return;
         }
         if(Boolean(this.node.level) && param1)
         {
            mc.mcLevel.tLabel.htmlText = this.node.level;
            mc.mcLevel.tLabel.visible = true;
         }
         else
         {
            mc.mcLevel.tLabel.htmlText = "";
            mc.mcLevel.tLabel.visible = false;
         }
         if(this.node.fortification && param1 && param2)
         {
            mc.mcFort.mcLevel.tLabel.htmlText = this.node.fortification;
            mc.mcFort.mcLevel.tLabel.visible = true;
         }
         else
         {
            mc.mcFort.mcLevel.tLabel.htmlText = "";
            mc.mcFort.mcLevel.tLabel.visible = false;
         }
      }
      
      public function toggleInvalid(param1:Boolean = false) : void
      {
         mc.mcInvalid.visible = param1;
      }
      
      override public function onMouseDown(param1:MouseEvent = null) : void
      {
         super.onMouseDown(param1);
      }
      
      override public function onMouseUp(param1:MouseEvent = null) : void
      {
         super.onMouseDown(param1);
         if(!PLANNER.basePlanner.popup.designView._dragged)
         {
            dispatchEvent(new BasePlannerNodeEvent(PlannerDesignView.BUILDING_CLICK,this.node));
         }
      }
      
      override public function onRollOver(param1:MouseEvent = null) : void
      {
         dispatchEvent(new BasePlannerNodeEvent(PlannerDesignView.BUILDING_OVER,this.node));
         mc.mcFrame.gotoAndStop("on");
      }
      
      override public function onRollOut(param1:MouseEvent = null) : void
      {
         dispatchEvent(new BasePlannerNodeEvent(PlannerDesignView.BUILDING_OUT,this.node));
         mc.mcFrame.gotoAndStop("off");
      }
      
      public function addShadow() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.distance = 5;
         _loc1_.angle = 45;
         _loc1_.color = 0;
         _loc1_.alpha = 0.5;
         _loc1_.blurX = 3;
         _loc1_.blurY = 3;
         _loc1_.strength = 1;
         _loc1_.quality = 15;
         mc.filters = new Array(_loc1_);
      }
      
      public function removeShadow() : void
      {
         mc.filters = [];
      }
   }
}

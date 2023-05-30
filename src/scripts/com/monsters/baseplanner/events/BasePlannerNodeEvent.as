package com.monsters.baseplanner.events
{
   import com.monsters.baseplanner.PlannerNode;
   import flash.events.Event;
   
   public class BasePlannerNodeEvent extends Event
   {
       
      
      private var _node:PlannerNode;
      
      public function BasePlannerNodeEvent(param1:String, param2:PlannerNode)
      {
         this._node = param2;
         super(param1);
      }
      
      public function get node() : PlannerNode
      {
         return this._node;
      }
   }
}

package com.monsters.ai
{
   import flash.geom.Point;
   
   public class Solution
   {
       
      
      public var degrees:Number;
      
      public var entryPoint:Point;
      
      public var wayPoints:Array;
      
      public var composition:Array;
      
      public var targetBuilding;
      
      public var defensiveBuilding;
      
      public var resourcesGained:Number;
      
      public var damageTaken:Number;
      
      public var attack:Object;
      
      public var targetHP:Number;
      
      public var looters:Object;
      
      public var tanks:Object;
      
      public var dps:Object;
      
      public var anything:Object;
      
      public var distanceToTarget:Number;
      
      public var nearestTower:Point;
      
      public var attackTime:Number;
      
      public var distances:Object;
      
      public var towersInPath:Array;
      
      public function Solution(param1:Number, param2:Number, param3:Number)
      {
         super();
         var _loc4_:Number = 0.0174532925;
         this.degrees = param1;
         this.entryPoint = new Point(param2 * Math.cos(param1 * _loc4_),param3 * Math.sin(param1 * _loc4_));
         this.wayPoints = [];
         this.resourcesGained = 0;
         this.damageTaken = 0;
         this.targetHP = 0;
         this.towersInPath = [].concat();
      }
      
      public function toString() : String
      {
         return "Solution";
      }
   }
}

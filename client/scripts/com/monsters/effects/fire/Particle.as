package com.monsters.effects.fire
{
   public class Particle
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var vx:Number;
      
      public var vy:Number;
      
      public var life:int;
      
      public var clock:Number;
      
      public var next:Particle;
      
      public function Particle(param1:Number, param2:Number)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.vx = 0;
         this.vy = 0;
         this.life = 0;
         this.clock = Math.random() * Math.PI * 2;
      }
   }
}

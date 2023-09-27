package com.monsters.replayableEvents.monsterInvasion
{
   public class WaveObj
   {
      
      public static const DIR:Object = {
         "N":270,
         "S":90,
         "E":0,
         "W":180
      };
       
      
      public var creatureID:String;
      
      public var behavior:String;
      
      public var numCreep:int;
      
      public var direction:int;
      
      public var level:int;
      
      public var powerLevel:int;
      
      public var cameraFocus:Boolean;
      
      public function WaveObj(param1:String, param2:String, param3:int, param4:int, param5:int = 0, param6:int = 0, param7:Boolean = false)
      {
         super();
         this.creatureID = param1;
         this.behavior = param2;
         this.numCreep = param3;
         this.direction = param4;
         this.level = param5;
         this.powerLevel = param6;
         this.cameraFocus = param7;
      }
   }
}

package com.monsters.ai
{
   public interface IPROCESS
   {
       
      
      function Trigger(param1:Number = 1) : void;
      
      function Process(param1:Solution, param2:Function) : void;
      
      function onProcess(param1:Array, param2:BFOUNDATION = null, param3:int = 0, param4:Boolean = false, param5:BFOUNDATION = null) : void;
      
      function beginProcessB() : void;
      
      function ProcessB(param1:Solution) : void;
      
      function ProcessC(param1:Solution) : void;
   }
}

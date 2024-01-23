package com.monsters.interfaces
{
   public interface IHandler extends IExportable
   {
       
      
      function initialize(param1:Object = null) : void;
      
      function get name() : String;
   }
}

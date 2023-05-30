package com.monsters.monsters
{
   import com.monsters.monsters.components.Component;
   
   public interface IComponentOwner
   {
       
      
      function addComponent(param1:Component, param2:String = "", param3:uint = 0) : void;
      
      function removeComponent(param1:Component) : void;
      
      function getComponent(param1:Component) : Component;
      
      function getComponentByType(param1:Class) : Component;
      
      function getComponentByName(param1:String) : Component;
   }
}

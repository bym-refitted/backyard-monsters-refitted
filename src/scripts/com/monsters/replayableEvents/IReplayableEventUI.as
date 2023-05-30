package com.monsters.replayableEvents
{
   import flash.display.DisplayObject;
   import flash.events.IEventDispatcher;
   
   public interface IReplayableEventUI extends IEventDispatcher
   {
       
      
      function get eventUI() : DisplayObject;
      
      function setup(param1:ReplayableEvent) : void;
      
      function update() : void;
   }
}

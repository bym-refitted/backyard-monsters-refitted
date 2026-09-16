package com.bymrefitted.ui.interfaces
{
   import flash.events.MouseEvent;

   /**
    * Interface for windows that support the "FullScreen" action.
    */
   public interface IFullScreenActionHandler
   {
      /**
       * Handles the FullScreen action triggered by a MouseEvent.
       */
      function FullScreen(param1:MouseEvent = null):void;
   }
}
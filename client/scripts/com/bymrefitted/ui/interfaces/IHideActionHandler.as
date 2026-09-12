package com.bymrefitted.ui.interfaces
{
   import flash.events.MouseEvent;

   /**
    * Interface for windows that support the "Hide" operation, e.g. closing the window.
    */
   public interface IHideActionHandler
   {
      /**
       * Hides the window, typically by closing it.
       */
      function Hide(param1:MouseEvent = null):void;
   }
}
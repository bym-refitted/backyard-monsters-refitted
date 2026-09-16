package com.bymrefitted.ui.interfaces
{
   import flash.events.MouseEvent;

   /**
    * Interface for windows that support the "Help" operation, e.g. showing help information.
    */
   public interface IHelpActionHandler
   {
      /**
       * Shows the help information for the window.
       */
      function Help(param1:MouseEvent = null):void;
   }
}
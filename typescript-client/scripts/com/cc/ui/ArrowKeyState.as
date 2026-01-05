package com.cc.ui
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   
   public class ArrowKeyState
   {
      
      private static var _leftPressed:Boolean;
      
      private static var _rightPressed:Boolean;
      
      private static var _lastX:int;
      
      private static var _upPressed:Boolean;
      
      private static var _downPressed:Boolean;
      
      private static var _lastY:int;
      
      private static const MINIMUM_LOG_DURATION:int = 500;
      
      private static var _startPress:int;
      
      private static var _logged:Boolean = false;
       
      
      public function ArrowKeyState()
      {
         super();
      }
      
      public static function Reset() : void
      {
         _leftPressed = _rightPressed = _upPressed = _downPressed = false;
         _lastX = _lastY = 0;
      }
      
      public static function KeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Boolean = true;
         switch(param1.keyCode)
         {
            case Keyboard.LEFT:
               _leftPressed = true;
               _lastX = 1;
               break;
            case Keyboard.RIGHT:
               _rightPressed = true;
               _lastX = -1;
               break;
            case Keyboard.UP:
               _upPressed = true;
               _lastY = 1;
               break;
            case Keyboard.DOWN:
               _downPressed = true;
               _lastY = -1;
               break;
            default:
               _loc2_ = false;
         }
         if(!_logged && _loc2_ && !_startPress)
         {
            _startPress = getTimer();
         }
      }
      
      public static function KeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:Boolean = true;
         switch(param1.keyCode)
         {
            case Keyboard.LEFT:
               _leftPressed = false;
               break;
            case Keyboard.RIGHT:
               _rightPressed = false;
               break;
            case Keyboard.UP:
               _upPressed = false;
               break;
            case Keyboard.DOWN:
               _downPressed = false;
               break;
            case Keyboard.CONTROL:
               _upPressed = _downPressed = _leftPressed = _rightPressed = false;
               break;
            default:
               _loc2_ = false;
         }
         if(!_logged && _loc2_ && Boolean(_startPress))
         {
            if(getTimer() - _startPress >= MINIMUM_LOG_DURATION)
            {
               _logged = true;
            }
            _startPress = 0;
         }
      }
      
      public static function get ArrowKeyPressed() : Boolean
      {
         return _upPressed || _downPressed || _leftPressed || _rightPressed;
      }
      
      public static function get xDir() : int
      {
         var _loc1_:int = 0;
         if(_leftPressed && _rightPressed)
         {
            _loc1_ = _lastX;
         }
         else if(_leftPressed)
         {
            _loc1_ = 1;
         }
         else if(_rightPressed)
         {
            _loc1_ = -1;
         }
         return _loc1_;
      }
      
      public static function get yDir() : int
      {
         var _loc1_:int = 0;
         if(_upPressed && _downPressed)
         {
            _loc1_ = _lastY;
         }
         else if(_upPressed)
         {
            _loc1_ = 1;
         }
         else if(_downPressed)
         {
            _loc1_ = -1;
         }
         return _loc1_;
      }
   }
}

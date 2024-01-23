package
{
   import flash.events.MouseEvent;
   
   public class HATCHERYCC
   {
      
      public static const TYPE:int = 16;
      
      public static const DEFAULT_QUEUE_LIMIT:uint = 20;
      
      public static var queueLimit:uint = DEFAULT_QUEUE_LIMIT;
      
      public static var doesShowInfernoCreeps:Boolean = false;
      
      public static var _mc:HATCHERYCCPOPUP;
      
      public static var _open:Boolean = false;
       
      
      public function HATCHERYCC()
      {
         super();
      }
      
      public static function Show() : void
      {
         if(!_open)
         {
            _open = true;
            GLOBAL.BlockerAdd();
            _mc = GLOBAL._layerWindows.addChild(new HATCHERYCCPOPUP()) as HATCHERYCCPOPUP;
            _mc.Setup();
            _mc.Center();
            _mc.ScaleUp();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            _open = false;
            GLOBAL._layerWindows.removeChild(_mc);
            _mc = null;
         }
      }
      
      public static function Tick() : void
      {
         if(_mc)
         {
            _mc.Update();
         }
      }
   }
}

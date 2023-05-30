package
{
   import flash.events.MouseEvent;
   
   public class HATCHERY
   {
      
      public static const TYPE:uint = 13;
      
      public static var _mc:HATCHERYPOPUP;
      
      public static var _open:Boolean = false;
       
      
      public function HATCHERY()
      {
         super();
      }
      
      public static function Show(param1:BUILDING13) : void
      {
         if(!_open)
         {
            _open = true;
            GLOBAL.BlockerAdd();
            _mc = GLOBAL._layerWindows.addChild(new HATCHERYPOPUP()) as HATCHERYPOPUP;
            _mc.Setup(param1);
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

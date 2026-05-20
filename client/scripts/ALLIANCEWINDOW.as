package
{
   import flash.events.MouseEvent;

   public class ALLIANCEWINDOW
   {

      public static var _mc:ALLIANCEPOPUP = null;

      public static var _open:Boolean = false;

      public function ALLIANCEWINDOW()
      {
         super();
      }

      public static function Show(param1:MouseEvent = null) : void
      {
         if (!_open)
         {
            SOUNDS.Play("click1");
            _open = true;
            GLOBAL.BlockerAdd();
            _mc = GLOBAL._layerWindows.addChild(new ALLIANCEPOPUP()) as ALLIANCEPOPUP;
            _mc.Center();
            _mc.ScaleUp();
         }
      }

      public static function Hide(param1:MouseEvent = null) : void
      {
         if (_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            _open = false;
            GLOBAL._layerWindows.removeChild(_mc);
            _mc = null;
         }
      }
   }
}

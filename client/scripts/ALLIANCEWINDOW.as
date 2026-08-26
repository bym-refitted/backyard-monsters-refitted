package
{
   import com.monsters.alliances.ALLIANCES;
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
            ALLIANCES.LoadMyAlliance(RefreshTabLabels, true);
            ALLIANCES.LoadMessages(RefreshTabLabels, true);
            GLOBAL.BlockerAdd();
            _mc = GLOBAL._layerWindows.addChild(new ALLIANCEPOPUP()) as ALLIANCEPOPUP;
            _mc.Center();
            _mc.ScaleUp();
         }
      }

      /**
       * Redraws the tab strip once a store lands. Doubles as the load callback:
       * both stores are fetched before the popup exists, so their counts arrive
       * after the tabs have been drawn.
       * 
       * @param {Object} param1 - The loaded payload, unused; the labels read the store.
       */
      public static function RefreshTabLabels(param1:Object = null) : void
      {
         if (_open && _mc != null) _mc.RefreshTabLabels();
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

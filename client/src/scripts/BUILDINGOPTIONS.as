package
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class BUILDINGOPTIONS
   {
      
      public static var _do:BUILDINGOPTIONSPOPUP;
      
      public static var _doBG:DisplayObject;
      
      public static var _building:BFOUNDATION;
      
      public static var _open:Boolean;
       
      
      public function BUILDINGOPTIONS()
      {
         super();
      }
      
      public static function Show(param1:BFOUNDATION, param2:String = "info") : void
      {
         if(!_open)
         {
            GLOBAL.BlockerAdd();
            SOUNDS.Play("click1");
            BASE.BuildingDeselect();
            _building = param1;
            _open = true;
            _do = GLOBAL._layerWindows.addChild(new BUILDINGOPTIONSPOPUP(param2)) as BUILDINGOPTIONSPOPUP;
            _do.Center();
            _do.ScaleUp();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            _open = false;
            GLOBAL._layerWindows.removeChild(_do);
            _do = null;
         }
      }
   }
}

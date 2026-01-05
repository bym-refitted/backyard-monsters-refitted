package
{
   import com.monsters.mailbox.MailBox;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   
   public class MAILBOX
   {
      
      public static var _loader:Loader;
      
      public static var _open:Boolean;
      
      private static var loaded:Boolean = false;
      
      public static var _handleTruceRequests:Boolean = true;
      
      public static var _threadidToOpen:int = -1;
      
      public static var _mc:MailBox;
       
      
      public function MAILBOX()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _mc = null;
      }
      
      public static function Show() : void
      {
         SOUNDS.Play("click1");
         _mc = new MailBox();
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(_mc);
         _mc.Setup();
      }
      
      public static function Tick() : void
      {
         if(Boolean(_mc) && GLOBAL.Timestamp() % 15 == 0)
         {
            _mc.Tick();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         try
         {
            SOUNDS.Play("close");
            GLOBAL.BlockerRemove();
            GLOBAL._layerWindows.removeChild(_mc);
            _mc = null;
         }
         catch(e:Error)
         {
         }
      }
      
      public static function ShowWithThreadId(param1:int) : void
      {
         _threadidToOpen = param1;
         Show();
      }
   }
}

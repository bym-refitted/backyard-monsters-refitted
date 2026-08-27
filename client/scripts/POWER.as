package
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.desktop.NativeApplication;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;

   // iOS battery / thermal + resume helper. Two client-only, no-downside jobs, both keyed off the
   // app moving between foreground and background (NativeApplication ACTIVATE/DEACTIVATE):
   //
   //   1) THERMAL — when the app is not in the foreground (backgrounded, Control Center, an incoming
   //      call) there is no reason to keep rendering, so drop the frame rate to IDLE_FPS and restore
   //      PLAY_FPS on return. The sim is getTimer-based + server-authoritative, so it just catches up.
   //
   //   2) RESUME REFRESH — the client's build/resource countdowns only advance while the app is awake,
   //      so after a LONG background they are stale (a build that finished while you were away still
   //      shows as in-progress). Desktop fixes this with a page reload; a packaged AIR iOS app can't
   //      reload itself (CallJS("reloadPage") is a no-op with no JS host), which is why the old "Oops /
   //      Reload" popup did nothing. Instead, on resume after RELOAD_AFTER_MS we re-fetch the current
   //      yard straight from the authoritative server via BASE.LoadBase — but only when the player is
   //      sitting idle in their OWN main yard (never mid-attack, in a map room, or with a save/load in
   //      flight). GLOBAL.TickFast separately suppresses the anti-speedhack "Time Threshold" popup on
   //      iOS so nothing flashes before this refresh lands.
   //
   // Everything here is gated by the fact it's only wired up on iOS (POWER.setup in GAME.as's
   // _iosViewport block), so desktop is untouched.
   public class POWER
   {
      public static const PLAY_FPS:Number = 40; // authored rate (60 would run anims/time ~1.5x fast)
      public static const IDLE_FPS:Number = 2;   // app not in the foreground
      // Backgrounded at least this long -> refresh from the server on resume. 5 min matches
      // GLOBAL.TIME_ELAPSED_THRESHHOLD (the point the sim itself considers the clock jump "large").
      public static const RELOAD_AFTER_MS:Number = 300000;

      private static var _setup:Boolean = false;
      private static var _stage:Stage;
      private static var _bgAt:Number = 0;   // getTimer() when we last went to the background (0 = none)

      public static function setup(stage:Stage) : void
      {
         if(_setup || !stage)
         {
            return;
         }
         _setup = true;
         _stage = stage;
         stage.frameRate = PLAY_FPS;
         try
         {
            var app:NativeApplication = NativeApplication.nativeApplication;
            app.addEventListener(Event.ACTIVATE,onActivate);
            app.addEventListener(Event.DEACTIVATE,onDeactivate);
         }
         catch(e:Error)
         {
         }
      }

      private static function onActivate(e:Event) : void
      {
         if(_stage)
         {
            _stage.frameRate = PLAY_FPS;
         }
         maybeReload();
      }

      private static function onDeactivate(e:Event) : void
      {
         if(_stage)
         {
            _stage.frameRate = IDLE_FPS;
         }
         _bgAt = getTimer();
      }

      // Re-sync stale client state after a long background by re-fetching the current yard from the
      // server. Heavily guarded: only when idle in the main yard, so we never yank the player out of
      // an attack / map room / an in-flight save or load.
      private static function maybeReload() : void
      {
         try
         {
            if(_bgAt <= 0)
            {
               return;
            }
            var away:Number = getTimer() - _bgAt;
            _bgAt = 0;
            if(away < RELOAD_AFTER_MS)
            {
               return;
            }
            if(GLOBAL.isInAttackMode || MapRoomManager.instance.isOpen)
            {
               return;
            }
            if(BASE._saving || BASE._loading)
            {
               return;
            }
            if(GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD || !BASE.isMainYard)
            {
               return;
            }
            // Same call the game uses to return to the main yard (GLOBAL ~1586): re-load from server.
            BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,int(EnumYardType.MAIN_YARD));
         }
         catch(err:Error)
         {
         }
      }
   }
}

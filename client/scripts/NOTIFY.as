package
{
   import com.monsters.managers.InstanceManager;
   import flash.desktop.NativeApplication;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.StatusEvent;
   import flash.external.ExtensionContext;

   // iOS local notifications: buzz the player when a building build / upgrade / fortify finishes,
   // even with the app backgrounded or closed. Native side is a tiny custom ANE (com.bym.notif)
   // over UNUserNotificationCenter — see ios/ane/. Local notifications need NO push entitlement or
   // server, so this is 100% client-side (no ban risk) and works with free-provisioning sideload.
   //
   // STRATEGY — schedule on DEACTIVATE, cancel on ACTIVATE:
   //   * Going to the background is exactly the moment notifications become useful, so that's when
   //     we (re)schedule from the live base state. Coming back to the foreground, we clear them all
   //     (no point buzzing the player while they're already looking at the game; they'll be
   //     rescheduled next time the app is backgrounded).
   //   * Countdowns are RELATIVE remaining seconds, so at the instant we background, `remaining` IS
   //     the fire delay. Build progress is real wall-clock while a worker is assigned, so a
   //     notification `remaining` seconds out lands on the real completion (survives app kill too).
   //   * We iterate WORKERS._workers (buildings with a worker actually counting down) rather than
   //     every building, which sidesteps queued/stalled builds that aren't progressing yet.
   //
   // Everything is guarded and the call site (GAME.as) is gated on GLOBAL._iosViewport, so desktop
   // is untouched and a missing/failed ANE just silently no-ops.
   public class NOTIFY
   {
      private static const EXT_ID:String = "com.bym.notif";

      // Fun, randomised copy (BYM's goofy tone). iOS renders emoji in notification banners.
      // A line is picked at random each time so the alerts never feel canned.
      private static const MSG_UPGRADE:Array = [
         "notify_upgrade_1", "notify_upgrade_2", "notify_upgrade_3", "notify_upgrade_4"
      ];
      private static const MSG_BUILD:Array = [
         "notify_build_1", "notify_build_2", "notify_build_3", "notify_build_4"
      ];
      private static const MSG_FORTIFY:Array = [
         "notify_fortify_1", "notify_fortify_2", "notify_fortify_3", "notify_fortify_4"
      ];
      private static const MSG_CHAMPION:Array = [
         "notify_champion_1", "notify_champion_2", "notify_champion_3", "notify_champion_4"
      ];
      private static const MSG_COLLECTORS:Array = [
         "notify_collectors_1", "notify_collectors_2", "notify_collectors_3", "notify_collectors_4"
      ];

      private static var _ctx:ExtensionContext;
      private static var _setup:Boolean = false;

      public static function init(stage:Stage) : void
      {
         if(_setup)
         {
            return;
         }
         _setup = true;
         try
         {
            _ctx = ExtensionContext.createExtensionContext(EXT_ID,null);
            if(!_ctx)
            {
               return;
            }
            _ctx.addEventListener(StatusEvent.STATUS,onStatus);
            _ctx.call("requestPermission");
            var app:NativeApplication = NativeApplication.nativeApplication;
            app.addEventListener(Event.DEACTIVATE,onDeactivate);
            app.addEventListener(Event.ACTIVATE,onActivate);
         }
         catch(e:Error)
         {
            _ctx = null;
         }
      }

      // Native permission result ("granted"/"denied"); nothing to do — scheduling just no-ops if denied.
      private static function onStatus(e:StatusEvent) : void
      {
      }

      private static function onDeactivate(e:Event) : void
      {
         scheduleAll();
      }

      private static function onActivate(e:Event) : void
      {
         cancelAll();
      }

      private static function cancelAll() : void
      {
         try
         {
            if(_ctx)
            {
               _ctx.call("cancelAll");
            }
         }
         catch(e:Error)
         {
         }
      }

      // Reschedule one notification per worker-assigned build/upgrade/fortify from the live base state.
      private static function scheduleAll() : void
      {
         var w:Object = null;
         var b:Object = null;
         var rem:Number = NaN;
         if(!_ctx)
         {
            return;
         }
         try
         {
            _ctx.call("cancelAll");
            var workers:Array = WORKERS._workers;
            if(!workers)
            {
               return;
            }
            for(var i:int = 0; i < workers.length; i++)
            {
               w = workers[i];
               if(!w || !w.task)
               {
                  continue;
               }
               b = w.task;
               rem = remainingSeconds(b);
               if(rem <= 0)
               {
                  continue;
               }
               _ctx.call("schedule","b" + b._id,titleFor(b),bodyFor(b),rem);
            }
            scheduleChampionFeed();
            scheduleCollectorsFull();
         }
         catch(e:Error)
         {
         }
      }

      // Champion feeding: _feedTime is an ABSOLUTE server-epoch timestamp of when it next gets
      // hungry (set as Timestamp()+feedTime in CHAMPIONCAGE), so remaining = feedTime - now.
      // CREATURES._guardian is a getter that returns the live champion or null.
      private static function scheduleChampionFeed() : void
      {
         try
         {
            var g:Object = CREATURES._guardian;
            if(!g)
            {
               return;
            }
            var rem:Number = g._feedTime.Get() - GLOBAL.Timestamp();
            if(rem > 0)
            {
               _ctx.call("schedule","champion",KEYS.Get("notify_champion_title"),pick(MSG_CHAMPION),rem);
            }
         }
         catch(e:Error)
         {
         }
      }

      // Resource collectors (harvesters) filling up: each holds _stored of productionCapacity and
      // gains productionValue every productionTimeout secs, so time-to-full = ceil(room/value)*timeout.
      // We fire ONE notification at the moment the LAST producing collector fills — i.e. when you've
      // stopped producing entirely and every extra second is wasted.
      private static function scheduleCollectorsFull() : void
      {
         var r:Object = null;
         try
         {
            var list:Vector.<Object> = InstanceManager.getInstancesByClass(BRESOURCE);
            if(!list)
            {
               return;
            }
            var maxFull:Number = 0;
            var anyProducing:Boolean = false;
            for each(r in list)
            {
               if(!r || !r._producing || !r._canFunction)
               {
                  continue;
               }
               var room:Number = Number(r.productionCapacity) - r._stored.Get();
               var val:Number = Number(r.productionValue);
               var timeout:Number = Number(r.productionTimeout);
               if(room <= 0 || val <= 0 || timeout <= 0)
               {
                  continue;
               }
               var secs:Number = Math.ceil(room / val) * timeout;
               anyProducing = true;
               if(secs > maxFull)
               {
                  maxFull = secs;
               }
            }
            if(anyProducing && maxFull > 0)
            {
               _ctx.call("schedule","collectorsfull",KEYS.Get("notify_collectors_title"),pick(MSG_COLLECTORS),maxFull);
            }
         }
         catch(e:Error)
         {
         }
      }

      private static function pick(a:Array) : String
      {
         return KEYS.Get(a[int(Math.random() * a.length)]);
      }

      private static function remainingSeconds(b:Object) : Number
      {
         try
         {
            return b._countdownBuild.Get() + b._countdownUpgrade.Get() + b._countdownFortify.Get();
         }
         catch(e:Error)
         {
         }
         return 0;
      }

      // Localised building name (falls back to the app name).
      private static function titleFor(b:Object) : String
      {
         try
         {
            var props:Object = GLOBAL._buildingProps[b._type - 1];
            if(props && props.name)
            {
               return KEYS.Get(props.name);
            }
         }
         catch(e:Error)
         {
         }
         return "Backyard Monsters";
      }

      // Which action finished. Spanish (the player's language on this build); building name in title
      // is already localised via KEYS above.
      private static function bodyFor(b:Object) : String
      {
         try
         {
            if(b._countdownUpgrade.Get() > 0)
            {
               return pick(MSG_UPGRADE);
            }
            if(b._countdownBuild.Get() > 0)
            {
               return pick(MSG_BUILD);
            }
            if(b._countdownFortify.Get() > 0)
            {
               return pick(MSG_FORTIFY);
            }
         }
         catch(e:Error)
         {
         }
         return KEYS.Get("notify_done");
      }
   }
}

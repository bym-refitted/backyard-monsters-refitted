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
         "¡Subió de nivel! Ahora es aún más temible 😎",
         "Mejora lista 💪 los vecinos ya están temblando",
         "¡Más grande y más chulo! Obra terminada ✨",
         "¡Nivel completado! Alguien ha estado ocupado 🏗️"
      ];
      private static const MSG_BUILD:Array = [
         "¡Construido y en pie! Los obreros piden un aplauso 👏",
         "Obra terminada 🎉 huele a cemento fresco",
         "¡Ya está listo! Bienvenido al patio 🧱",
         "¡Nueva estructura desbloqueada! A darle uso 🔨"
      ];
      private static const MSG_FORTIFY:Array = [
         "¡Muro reforzado! Que vengan si se atreven 🛡️",
         "Fortificado 🧱 ahora rebota hasta un Wormzer 🐛",
         "¡Defensas al máximo! Aquí no entra ni el viento 💨",
         "¡Muro más duro que nunca! Los atacantes lo van a odiar 😈"
      ];
      private static const MSG_CHAMPION:Array = [
         "¡GRRR! Tu campeón ruge de hambre 🦖 dale de comer ya",
         "Tu campeón te mira con ojitos... y con mucha hambre 🍖",
         "Se oye un rugido en el patio 😋 ¡toca comer!",
         "¡Estómago vacío en el patio! No lo hagas esperar 🥩"
      ];
      private static const MSG_COLLECTORS:Array = [
         "¡Recolectores a reventar! Ve a vaciarlos 💰",
         "Tus recursos están hasta arriba 🪙 ¡a recoger!",
         "¡Alerta de abundancia! Los recolectores no dan más 📦",
         "¡Llenos hasta el borde! Estás desperdiciando, corre 🏃💨"
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
               _ctx.call("schedule","champion","🦖 Tu campeón",pick(MSG_CHAMPION),rem);
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
               _ctx.call("schedule","collectorsfull","💰 Recolectores llenos",pick(MSG_COLLECTORS),maxFull);
            }
         }
         catch(e:Error)
         {
         }
      }

      private static function pick(a:Array) : String
      {
         return a[int(Math.random() * a.length)];
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
         return "¡Listo! ✅";
      }
   }
}

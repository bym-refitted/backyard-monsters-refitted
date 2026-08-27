package
{
   import com.monsters.managers.InstanceManager;

   /**
    * A single running cumulative wall-upgrade job. Charges the whole resource
    * pool once, then walks ONE worker wall-to-wall raising each wall to its
    * target level. Deliberately never enters QUEUE._stack, so it neither
    * consumes nor is blocked by the 5-slot worker-queue cap.
    */
   public class BulkWallJob
   {

      private static var _current:BulkWallJob;

      /** Ordered Array of { wall:BFOUNDATION, target:int }. */
      private var _list:Array;

      /** Index into _list of the wall being worked. */
      private var _index:int = 0;

      /** The wall whose worker we currently hold, or null. */
      private var _reserved:BFOUNDATION;

      public function BulkWallJob()
      {
         super();
      }

      /**
       * @return True while a bulk wall-upgrade job is active.
       */
      public static function isRunning() : Boolean
      {
         return _current != null;
      }

      /**
       * Upgrade time in seconds for the wall's next step.
       *
       * @param w A wall below its target level.
       * @return Seconds for the step, scaled by the global build-time factor.
       */
      private static function stepTime(w:BFOUNDATION) : int
      {
         var c:Object = w._buildingProps.costs[w._lvl.Get()];
         return c ? int(c.time.Get() * GLOBAL._buildTime) : int(5 * GLOBAL._buildTime);
      }

      /**
       * Charges the full pool and starts the job.
       *
       * @param plan Output of BulkWallUpgrade.buildPlan.
       */
      public static function start(plan:Object) : void
      {
         if(_current != null)
         {
            return;
         }
         var inferno:Boolean = BulkWallUpgrade.isInfernoYard();
         var i:int = 1;
         while(i < 5)
         {
            var amt:Number = Number(plan.pool["r" + i]);
            if(amt > 0)
            {
               BASE.Charge(i,amt,false,inferno);
            }
            i++;
         }

         var job:BulkWallJob = new BulkWallJob();
         job._list = [];
         var w:BFOUNDATION = null;
         for each(w in plan.walls)
         {
            var tgt:int = int(plan.targets[w._id]);
            job._list.push({"wall":w,"target":tgt});
            w._bulkWallTarget = tgt;
            if(w._countdownUpgrade.Get() == 0 && w._lvl.Get() < tgt)
            {
               w._countdownUpgrade.Set(stepTime(w));
            }
         }
         job._index = 0;
         _current = job;
         GLOBAL.Message(KEYS.Get("bwu_msg_started"));
         BASE.Save();
      }

      /**
       * Drops the in-memory job without refund and without clearing cU / bwT on
       * the walls. Used when leaving BUILD mode; resumeFromLoad rebuilds it
       * after the next load.
       */
      public static function cancelForModeChange() : void
      {
         if(_current)
         {
            _current.releaseWorker(false);
            _current = null;
         }
      }

      /**
       * Called once after a base finishes loading. Rebuilds the job from any
       * walls that still carry a persisted bulk-upgrade target so they keep
       * upgrading one worker at a time. No-op if none, or if a job already runs.
       */
      public static function resumeFromLoad() : void
      {
         if(_current != null)
         {
            return;
         }
         var pending:Array = [];
         var all:Vector.<Object> = InstanceManager.getInstancesByClass(BWALL);
         var w:BFOUNDATION = null;
         for each(w in all)
         {
            if(w._bulkWallTarget > 0 && w._lvl.Get() < w._bulkWallTarget)
            {
               pending.push({"wall":w,"target":w._bulkWallTarget});
            }
            else if(w._bulkWallTarget > 0)
            {
               w._bulkWallTarget = 0; // already at/above target - stale marker
            }
         }
         if(pending.length == 0)
         {
            return;
         }
         var job:BulkWallJob = new BulkWallJob();
         job._list = pending;
         job._index = 0;
         _current = job;
      }

      /**
       * Advances the job by one second. Called from the GLOBAL 1-second loop.
       */
      public static function tick() : void
      {
         if(_current)
         {
            _current.step();
         }
      }

      private function releaseWorker(done:Boolean) : void
      {
         if(_reserved)
         {
            WORKERS.Remove(_reserved,done,"Upgrade");
            _reserved = null;
         }
      }

      private function step() : void
      {
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != "ibuild")
         {
            return; // paused off-BUILD; resumeFromLoad restarts after the next load
         }

         if(_index >= _list.length)
         {
            releaseWorker(true);
            _current = null;
            BASE.Save();
            return;
         }

         var entry:Object = _list[_index];
         var wall:BFOUNDATION = entry.wall as BFOUNDATION;

         if(wall == null || InstanceManager.getInstancesByClass(BWALL).indexOf(wall) < 0)
         {
            releaseWorker(false);
            _index++;
            return;
         }

         if(wall._lvl.Get() >= int(entry.target))
         {
            wall._bulkWallTarget = 0;
            releaseWorker(true);
            _index++;
            return;
         }

         if(_reserved != wall)
         {
            releaseWorker(false);
            var got:Object = WORKERS.Assign(wall);
            if(got == null)
            {
               return; // all workers busy; retry next second
            }
            _reserved = wall;
         }

         wall._hasResources = true; // pre-paid; never wait on ResourcePackages

         if(wall._hasWorker && wall._countdownUpgrade.Get() == 0 && wall._lvl.Get() < int(entry.target))
         {
            wall._countdownUpgrade.Set(stepTime(wall));
         }
         // BFOUNDATION.Tick decrements _countdownUpgrade (needs _hasWorker && _hasResources)
         // and calls Upgraded() at 0. Upgraded()'s QUEUE.Remove("building"+id) is a harmless
         // no-op here and does NOT free the worker, so _reserved stays valid for the next step.
      }
   }
}

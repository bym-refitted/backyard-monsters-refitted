package
{
   import com.monsters.managers.InstanceManager;

   /**
    * Resource-only cumulative wall upgrade.
    *
    * Drives the STORE popup's per-tier selection screen, computes each tier's
    * cumulative resource cost, checks affordability, and hands a confirmed plan
    * to BulkWallJob. Stateless; every entry point is static.
    */
   public class BulkWallUpgrade
   {

      public function BulkWallUpgrade()
      {
         super();
      }

      /**
       * Highest wall level the player may currently reach, from the town-hall
       * gating table. Outposts have every level unlocked.
       *
       * @return Max reachable wall level (2..5), or 1 if nothing is unlocked.
       */
      public static function maxWallLevel() : int
      {
         if(BASE.isOutpost)
         {
            return 5;
         }
         var th:int = GLOBAL.townHall ? GLOBAL.townHall._lvl.Get() : 1;
         if(th >= 6)
         {
            return 5;
         }
         if(th >= 5)
         {
            return 4;
         }
         if(th >= 4)
         {
            return 3;
         }
         if(th >= 3)
         {
            return 2;
         }
         return 1;
      }

      /**
       * @return True when walls in the current yard draw on the inferno
       *         resource pool rather than the normal one.
       */
      public static function isInfernoYard() : Boolean
      {
         return BASE.isInfernoBuilding(17) || BASE.isInfernoMainYardOrOutpost;
      }

      /**
       * Store item keys for every tier the town hall currently allows, in
       * ascending order. Inferno yards only expose the two inferno tiers.
       *
       * @return Array of store item key strings (may be empty).
       */
      public static function reachableTierKeys() : Array
      {
         var keys:Array = [];
         var max:int = maxWallLevel();
         if(isInfernoYard())
         {
            if(max >= 2)
            {
               keys.push("RBLK2I");
            }
            if(max >= 3)
            {
               keys.push("RBLK3I");
            }
            return keys;
         }
         var tier:int = 2;
         while(tier <= 5 && tier <= max)
         {
            keys.push("RBLK" + tier);
            tier++;
         }
         return keys;
      }

      /**
       * Tier number (2..5) encoded in a store item key such as "RBLK3" or
       * "RBLK2I".
       *
       * @param key Store item key.
       * @return The tier level.
       */
      public static function tierOfKey(key:String) : int
      {
         return int(key.substr(4,1));
      }

      /**
       * Which walls to upgrade to reach targetLevel, and the pooled cost.
       *
       * @param targetLevel Destination wall level (2..5).
       * @return { walls:Array, targets:Object (_id -> int), pool:Object
       *         ({r1,r2,r3,r4} ints), targetLevel:int, count:int } — every wall
       *         with no active countdown that is currently below targetLevel,
       *         plus the summed step cost to raise each one to targetLevel.
       */
      public static function buildPlan(targetLevel:int) : Object
      {
         var walls:Array = [];
         var targets:Object = {};
         var pool:Object = {"r1":0,"r2":0,"r3":0,"r4":0}; // Number arithmetic — a max base can exceed int range
         var all:Vector.<Object> = InstanceManager.getInstancesByClass(BWALL);
         var w:BFOUNDATION = null;
         var lvl:int = 0;
         var c:Object = null;
         for each(w in all)
         {
            if(w._lvl == null || w._lvl.Get() >= targetLevel)
            {
               continue;
            }
            if(w._countdownBuild.Get() + w._countdownUpgrade.Get() + w._countdownFortify.Get() > 0)
            {
               continue;
            }
            walls.push(w);
            targets[w._id] = targetLevel;
            lvl = w._lvl.Get();
            while(lvl < targetLevel)
            {
               c = w._buildingProps.costs[lvl];
               if(c)
               {
                  pool.r1 += Number(c.r1.Get());
                  pool.r2 += Number(c.r2.Get());
                  pool.r3 += Number(c.r3.Get());
                  pool.r4 += Number(c.r4.Get());
               }
               lvl++;
            }
         }
         return {
            "walls":walls,
            "targets":targets,
            "pool":pool,
            "targetLevel":targetLevel,
            "count":walls.length
         };
      }

      /**
       * All-or-nothing affordability: does the player currently hold every
       * resource the pool needs?
       *
       * The silo capacity cap is deliberately NOT checked — a cumulative bulk
       * cost is a sum of many individually-affordable steps and can exceed silo
       * size, and overflow / dev resources legitimately sit above the cap. The
       * only real constraint is the current balance.
       *
       * @param pool {r1,r2,r3,r4} total cost.
       * @return True only if every non-zero cost is covered by the balance.
       */
      public static function canAfford(pool:Object) : Boolean
      {
         var res:Object = isInfernoYard() ? BASE._iresources : BASE._resources;
         var i:int = 1;
         while(i < 5)
         {
            var need:Number = Number(pool["r" + i]);
            if(need > 0 && need > Number(res["r" + i].Get()))
            {
               return false;
            }
            i++;
         }
         return true;
      }

      /**
       * "1,000 Twigs, 2,000 Pebbles" for a cost pool, or "-" when empty.
       *
       * @param pool {r1,r2,r3,r4} total cost.
       * @return Formatted, comma-joined resource cost string.
       */
      public static function costString(pool:Object) : String
      {
         var names:Array = isInfernoYard() ? GLOBAL.iresourceNames : GLOBAL._resourceNames;
         var parts:Array = [];
         var i:int = 1;
         while(i < 5)
         {
            if(Number(pool["r" + i]) > 0)
            {
               parts.push(GLOBAL.FormatNumber(Number(pool["r" + i])) + " " + KEYS.Get(names[i - 1]));
            }
            i++;
         }
         return parts.length > 0 ? parts.join(", ") : "-";
      }

      /**
       * Summary for one tier row in the store.
       *
       * @param targetLevel Tier level (2..5).
       * @return { count:int, pool:Object, costText:String, affordable:Boolean }.
       */
      public static function tierInfo(targetLevel:int) : Object
      {
         var plan:Object = buildPlan(targetLevel);
         return {
            "count":plan.count,
            "pool":plan.pool,
            "costText":costString(plan.pool),
            "affordable":canAfford(plan.pool)
         };
      }

      /**
       * Fills in the title / description of every RBLK* store row. Called by
       * STORE.Variables() each time the store renders. The per-row cost and
       * wall count are rendered separately by STORE.Switch via rowCostHtml /
       * rowCountText.
       *
       * @param storeItems The STORE._storeItems object.
       */
      public static function updateStoreRows(storeItems:Object) : void
      {
         var keys:Array = ["RBLK2","RBLK3","RBLK4","RBLK5","RBLK2I","RBLK3I"];
         var k:String = null;
         var plan:Object = null;
         var costTxt:String = null;
         for each(k in keys)
         {
            if(storeItems[k] == null)
            {
               continue;
            }
            plan = buildPlan(tierOfKey(k));
            costTxt = costString(plan.pool);
            if(!canAfford(plan.pool))
            {
               costTxt = "<font color=\"#CC0000\">" + costTxt + "</font>";
            }
            storeItems[k].t = KEYS.Get("bwu_tier_" + tierOfKey(k));
            storeItems[k].d = KEYS.Get("bwu_tier_desc")
               + "<br><b>" + KEYS.Get("bwu_cost_label") + "</b> " + costTxt;
            storeItems[k].c = [0];
         }
      }

      /**
       * Text for the footer column of an RBLK* store row, e.g. "8 walls".
       *
       * @param storeKey e.g. "RBLK3".
       * @return Wall-count string.
       */
      public static function rowCountText(storeKey:String) : String
      {
         return KEYS.Get("bwu_walls_count",{"v1":buildPlan(tierOfKey(storeKey)).count});
      }

      /**
       * Purchase-branch entry point for one tier row. Validates and, on
       * confirmation, spends the pool and starts the job.
       *
       * @param targetLevel Tier level (2..5).
       */
      public static function confirmTier(targetLevel:int) : void
      {
         if(BulkWallJob.isRunning())
         {
            GLOBAL.Message(KEYS.Get("bwu_running"));
            return;
         }
         var plan:Object = buildPlan(targetLevel);
         if(plan.count == 0)
         {
            GLOBAL.Message(KEYS.Get("bwu_none"));
            return;
         }
         if(!canAfford(plan.pool))
         {
            GLOBAL.Message(KEYS.Get("bwu_short",{"v1":costString(plan.pool)}));
            return;
         }
         STORE.Hide();
         GLOBAL.Message(KEYS.Get("bwu_confirm",{
            "v1":plan.count,
            "v2":targetLevel,
            "v3":costString(plan.pool)
         }),KEYS.Get("btn_upgrade"),function():void
         {
            BulkWallJob.start(plan);
         });
      }

      /**
       * Opens the STORE popup filtered to the reachable tier rows that have at
       * least one wall to raise. Shows a message instead if there are none.
       */
      public static function openStore() : void
      {
         var all:Array = reachableTierKeys();
         var keys:Array = [];
         var k:String = null;
         for each(k in all)
         {
            if(buildPlan(tierOfKey(k)).count > 0)
            {
               keys.push(k);
            }
         }
         if(keys.length == 0)
         {
            GLOBAL.Message(KEYS.Get("bwu_none"));
            return;
         }
         STORE.ShowB(1,0,keys);
      }
   }
}

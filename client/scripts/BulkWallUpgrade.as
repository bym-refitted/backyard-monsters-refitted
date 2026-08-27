package
{
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
       * Fills in the title / description of every RBLK* store row from live
       * wall data. Called by STORE.Variables() each time the store renders.
       * Task 1: names only; Task 2 adds the real cumulative cost.
       *
       * @param storeItems The STORE._storeItems object.
       */
      public static function updateStoreRows(storeItems:Object) : void
      {
         var keys:Array = ["RBLK2","RBLK3","RBLK4","RBLK5","RBLK2I","RBLK3I"];
         var k:String = null;
         for each(k in keys)
         {
            if(storeItems[k] == null)
            {
               continue;
            }
            storeItems[k].t = KEYS.Get("bwu_tier_" + tierOfKey(k));
            storeItems[k].d = KEYS.Get("bwu_tier_desc",{"v1":0,"v2":"—"});
            storeItems[k].c = [0];
         }
      }

      /**
       * Opens the STORE popup filtered to the reachable tier rows. Shows a
       * message instead if nothing can be bulk-upgraded from here.
       */
      public static function openStore() : void
      {
         var keys:Array = reachableTierKeys();
         if(keys.length == 0)
         {
            GLOBAL.Message(KEYS.Get("bwu_none"));
            return;
         }
         STORE.ShowB(1,0,keys);
      }
   }
}

package
{
   /**
    * Structured battle report accumulated during an attack, uploaded on attack end
    * as saveData.battlereport. Populated beside the existing ATTACK.Log() sites.
    *
    * PR 1a scope: building damage/HP/loot, loot totals, attacking force, siege,
    * catapult. dd/k/ml (combat-path attribution) are PR 1b and not recorded here.
    *
    * See docs/superpowers/specs/2026-08-29-attack-battle-reports-design.md.
    */
   public class AttackReport
   {
      private static var _buildings:Object;
      private static var _lootTotal:Array;      // [r1,r2,r3,r4]
      private static var _flung:Object;         // creatureID string -> cumulative int count flung this attack
      private static var _siege:Object;
      private static var _catapult:Object;
      private static var _retreated:Boolean;

      public function AttackReport() { super(); }

      public static function Reset() : void
      {
         _buildings = {};
         _lootTotal = [0, 0, 0, 0];
         _flung = {};
         _siege = {};
         _catapult = {};
         _retreated = false;
      }

      public static function RecordBuilding(id:String, t:int, x:int, y:int, hp:int, mhp:int) : void
      {
         var b:Object = _buildings[id];
         if(!b)
         {
            b = {"t":t, "x":x, "y":y, "hp":hp, "mhp":mhp, "l":0};
            _buildings[id] = b;
         }
         else
         {
            b.hp = hp;
            b.mhp = mhp;
         }
      }

      public static function RecordLoot(id:String, amount:Number) : void
      {
         if(amount <= 0) return;
         var b:Object = _buildings[id];
         if(b) b.l += amount;
      }

      /**
       * Records monsters flung/sent this attack, accumulating across fling waves.
       * Called at the fling site (ATTACK.Spawn) with the per-wave bucket count for
       * one creature type. This — NOT the attacker's remaining roster — is what
       * report.atk.m must reflect.
       */
      public static function RecordFlung(creatureId:String, count:int) : void
      {
         if(count <= 0) return;
         _flung[creatureId] = int(_flung[creatureId] || 0) + count;
      }

      /**
       * Sets the loot 4-tuple to the running attack total. ATTACK._loot is already
       * the cumulative grand total for the whole attack, so this is an assignment,
       * not an accumulation — calling it repeatedly across mid-attack saves is safe.
       */
      public static function SetLootTotal(r1:Number, r2:Number, r3:Number, r4:Number) : void
      {
         _lootTotal[0] = Math.max(0, r1);
         _lootTotal[1] = Math.max(0, r2);
         _lootTotal[2] = Math.max(0, r3);
         _lootTotal[3] = Math.max(0, r4);
      }

      public static function RecordSiege(siegeId:String) : void
      {
         if(AttackReportEnums.siegeId(siegeId) < 0) return;
         _siege[siegeId] = int(_siege[siegeId] || 0) + 1;
      }

      public static function RecordCatapult(bombId:String) : void
      {
         if(AttackReportEnums.powerupId(bombId) < 0) return;
         _catapult[bombId] = int(_catapult[bombId] || 0) + 1;
      }

      public static function RecordOutcomeRetreat() : void
      {
         _retreated = true;
      }

      public static function Serialize(attackerChampion:Object) : String
      {
         if(!_buildings) return "";

         var report:Object = {};
         report.v = 1;
         report.d = damagePercent();
         report.dur = int(GLOBAL.Timestamp() - ATTACK._attackStart);
         report.o = outcome(report.d);
         report.loot = [int(_lootTotal[0]), int(_lootTotal[1]), int(_lootTotal[2]), int(_lootTotal[3])];
         report.b = buildingArray();
         report.atk = attackForce(attackerChampion);

         var s:Array = countObjectToPairs(_siege, AttackReportEnums.SIEGE);
         if(s.length > 0) report.s = s;
         var cat:Array = countObjectToPairs(_catapult, AttackReportEnums.POWERUPS);
         if(cat.length > 0) report.cat = cat;

         // Empty attack — nothing worth sending.
         if(report.b.length == 0 && report.atk.m.length == 0 && report.atk.c == -1
            && !report.s && !report.cat)
         {
            return "";
         }

         return JSON.stringify(report);
      }

      private static function damagePercent() : int
      {
         var max:Number = Number(BFOUNDATION.totalBuildingMaxHP);
         if(max <= 0) return 0;
         var pct:Number = 100 - (100 * Number(BFOUNDATION.totalBuildingHP) / max);
         return Math.max(0, Math.min(100, Math.round(pct)));
      }

      private static function outcome(damage:int) : int
      {
         if(damage >= 100) return 2;      // flattened
         if(_retreated) return 0;          // retreat
         return 1;                          // timeout
      }

      private static function buildingArray() : Array
      {
         var out:Array = [];
         var id:String;
         for(id in _buildings)
         {
            var b:Object = _buildings[id];
            var e:Object = {"t":int(b.t), "x":int(b.x), "y":int(b.y), "hp":int(b.hp), "mhp":int(b.mhp)};
            if(b.l > 0) e.l = int(b.l);
            out.push(e);
         }
         return out;
      }

      /**
       * report.atk.m is "monsters flung/sent this attack" — accumulated at the fling
       * site via RecordFlung, NOT derived from the attacker's roster (which per mode
       * is either the un-sent remainder or the whole owned army). The champion still
       * comes from the passed-in guardian-save object.
       */
      private static function attackForce(champion:Object) : Object
      {
         var m:Array = [];
         var key:String;
         for(key in _flung)
         {
            var enumId:int = AttackReportEnums.monsterId(key);
            var count:int = int(_flung[key]);
            if(enumId >= 0 && count > 0) m.push([enumId, count]);
         }
         var c:int = -1;
         if(champion)
         {
            var ck:String = championKey(champion);
            if(ck) c = AttackReportEnums.championId(ck);
         }
         return {"m":m, "c":c};
      }

      private static function championKey(v:*) : String
      {
         if(v is Array) return (v as Array).length > 0 ? championKey((v as Array)[0]) : null;
         if(v is String) return v as String;
         var raw:* = (v && v.hasOwnProperty("type")) ? v.type : ((v && v.hasOwnProperty("t")) ? v.t : null);
         if(raw == null) return null;
         var s:String = String(raw);
         return s.charAt(0) == "G" ? s : "G" + s;
      }

      private static function countObjectToPairs(counts:Object, enumTable:Array) : Array
      {
         var out:Array = [];
         var key:String;
         for(key in counts)
         {
            var id:int = enumTable.indexOf(key);
            if(id >= 0 && counts[key] > 0) out.push([id, int(counts[key])]);
         }
         return out;
      }
   }
}

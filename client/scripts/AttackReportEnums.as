package
{
   /**
    * Mirror of server/src/services/attacklogs/attackReportEnums.ts.
    * APPEND-ONLY. Never reorder — the index is the wire value.
    * Kept in sync via attackReportEnums.fixture.json.
    */
   public class AttackReportEnums
   {
      public static const MONSTERS:Array = [
         "C1","C2","C3","C4","C5","C6","C7","C8","C9","C10",
         "C11","C12","C13","C14","C15","C16","C17","C18","C19",
         "IC1","IC2","IC3","IC4","IC5","IC6","IC7","IC8"
      ];

      public static const CHAMPIONS:Array = ["G1","G2","G3","G4","G5"];

      public static const SIEGE:Array = ["decoy","vacuum","jars"];

      public static const POWERUPS:Array = [
         "tw0","tw1","tw2","pb0","pb1","pb2","pb3","pu0","pu1","pu2","pu3"
      ];

      public function AttackReportEnums() { super(); }

      public static function monsterId(key:String) : int { return MONSTERS.indexOf(key); }
      public static function championId(key:String) : int { return CHAMPIONS.indexOf(key); }
      public static function siegeId(key:String) : int { return SIEGE.indexOf(key); }
      public static function powerupId(key:String) : int { return POWERUPS.indexOf(key); }
   }
}

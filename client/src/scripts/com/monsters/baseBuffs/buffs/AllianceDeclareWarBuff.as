package com.monsters.baseBuffs.buffs
{
   import com.monsters.baseBuffs.BaseBuff;
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class AllianceDeclareWarBuff extends BaseBuff
   {
      
      public static const ID:uint = 11;
       
      
      public function AllianceDeclareWarBuff(param1:String = "", param2:String = "")
      {
         super("ap_declarewar");
      }
      
      override public function get description() : String
      {
         return KEYS.Get(MapRoomManager.instance.isInMapRoom2 ? "ap_declarewar_desc" : "nwm_ap_declarewar_desc");
      }
      
      override public function apply() : void
      {
      }
      
      override public function clear() : void
      {
      }
   }
}

package com.monsters.event_store
{
   public class EventStorePrizeData
   {
      
      private static const AVAILABLE_ITEMS:Array = [{
         "id":"prize_rezghul",
         "name_key":"prize_rezghul",
         "description_key":"prize_description_rezghul",
         "image":"event_store/prize_rezghul.png",
         "locked_image":"event_store/prize_rezghul_locked.png",
         "preview_image":"event_store/prize_rezghul.png",
         "xpcost":9999,
         "correspondingRewardId":"unlockRezghul"
      },{
         "id":"prize_gold_totem",
         "name_key":"prize_gold_totem",
         "description_key":"prize_description_gold_totem",
         "image":"event_store/prize_gold_totem.png",
         "locked_image":"event_store/prize_gold_totem_locked.png",
         "preview_image":"event_store/prize_gold_totem.png",
         "xpcost":9999
      },{
         "id":"prize_black_totem",
         "name_key":"prize_black_totem",
         "description_key":"prize_description_black_totem",
         "image":"event_store/prize_black_totem.png",
         "locked_image":"event_store/prize_black_totem_locked.png",
         "preview_image":"event_store/prize_black_totem.png",
         "xpcost":9999
      },{
         "id":"prize_spurtz_cannon_1",
         "name_key":"prize_spurtz_cannon_1",
         "description_key":"prize_description_spurtz_cannon_1",
         "image":"event_store/prize_spurtz_cannon_1.png",
         "locked_image":"event_store/prize_spurtz_cannon_1_locked.png",
         "preview_image":"event_store/prize_spurtz_cannon_1.png",
         "xpcost":9999,
         "correspondingRewardId":"spurtzCannonReward"
      },{
         "id":"prize_spurtz_cannon_2",
         "name_key":"prize_spurtz_cannon_2",
         "description_key":"prize_description_spurtz_cannon_2",
         "image":"event_store/prize_spurtz_cannon_2.png",
         "locked_image":"event_store/prize_spurtz_cannon_2_locked.png",
         "preview_image":"event_store/prize_spurtz_cannon_2.png",
         "xpcost":9999,
         "correspondingRewardId":"spurtzCannonReward2",
         "requiredReward":"spurtzCannonReward"
      },{
         "id":"prize_spurtz_cannon_bd",
         "name_key":"prize_spurtz_cannon_bd",
         "description_key":"prize_description_spurtz_cannon_bd",
         "image":"event_store/prize_spurtz_cannon_bd.png",
         "locked_image":"event_store/prize_spurtz_cannon_bd_locked.png",
         "preview_image":"event_store/prize_spurtz_cannon_bd.png",
         "xpcost":9999,
         "correspondingRewardId":"spurtzCannonReward3",
         "requiredReward":"spurtzCannonReward2"
      },{
         "id":"prize_unlock_vorg",
         "name_key":"prize_unlock_vorg",
         "description_key":"prize_description_unlock_vorg",
         "image":"event_store/prize_unlock_vorg.png",
         "locked_image":"event_store/prize_unlock_vorg_locked.png",
         "preview_image":"event_store/prize_unlock_vorg.png",
         "xpcost":9999,
         "correspondingRewardId":"unlockVorg"
      },{
         "id":"prize_unlock_slimeattikus",
         "name_key":"prize_unlock_slimeattikus",
         "description_key":"prize_description_unlock_slimeattikus",
         "image":"event_store/prize_unlock_slimeattikus.png",
         "locked_image":"event_store/prize_unlock_slimeattikus_locked.png",
         "preview_image":"event_store/prize_unlock_slimeattikus.png",
         "xpcost":9999,
         "correspondingRewardId":"unlockSlimeattikus"
      },{
         "id":"prize_korath",
         "name_key":"prize_korath",
         "description_key":"prize_description_korath",
         "image":"event_store/prize_korath.png",
         "locked_image":"event_store/prize_korath_locked.png",
         "preview_image":"event_store/prize_korath.png",
         "xpcost":9999,
         "correspondingRewardId":"KorathReward",
         "correspondingRewardValue":0
      },{
         "id":"prize_korath_ability_1",
         "name_key":"prize_korath_ability_1",
         "description_key":"prize_description_korath_ability_1",
         "image":"event_store/prize_korath_ability_1.png",
         "locked_image":"event_store/prize_korath_ability_1_locked.png",
         "preview_image":"event_store/prize_korath_ability_1.png",
         "xpcost":9999,
         "correspondingRewardId":"KorathReward",
         "correspondingRewardValue":1,
         "requiredReward":"KorathReward"
      },{
         "id":"prize_korath_ability_2",
         "name_key":"prize_korath_ability_2",
         "description_key":"prize_description_korath_ability_2",
         "image":"event_store/prize_korath_ability_2.png",
         "locked_image":"event_store/prize_korath_ability_2_locked.png",
         "preview_image":"event_store/prize_korath_ability_2.png",
         "xpcost":9999,
         "correspondingRewardId":"KorathReward",
         "correspondingRewardValue":2,
         "requiredReward":"KorathReward",
         "requiredRewardValue":1
      }];
       
      
      public function EventStorePrizeData()
      {
         super();
      }
      
      internal static function FindEventStorePrizeData(param1:String) : Object
      {
         var _loc4_:Object = null;
         var _loc2_:uint = AVAILABLE_ITEMS.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = AVAILABLE_ITEMS[_loc3_]).id == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

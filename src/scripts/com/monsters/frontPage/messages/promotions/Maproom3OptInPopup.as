package com.monsters.frontPage.messages.promotions
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.maproom3.popups.MapRoom3ConfirmMigrationPopup;
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class Maproom3OptInPopup extends KeywordMessage
   {
      
      private static const NAME:String = "nwm";
      
      private static const TIME_UNTIL_RESET:uint = 432000;
      
      private static const k_POPUP_IMAGES:Array = ["fp_world_map_popup1.jpg","fp_world_map_popup2.jpg","fp_world_map_popup3.jpg"];
       
      
      public function Maproom3OptInPopup()
      {
         var _loc1_:int = Math.floor(Math.random() * k_POPUP_IMAGES.length);
         super(NAME,"btn_joinnow",k_POPUP_IMAGES[_loc1_]);
      }
      
      override public function setup(param1:Object) : void
      {
         super.setup(param1);
         markAsUnseenIfOlderThan(TIME_UNTIL_RESET);
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return !hasBeenSeen && !MapRoomManager.instance.isInMapRoom3;
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         MapRoom3ConfirmMigrationPopup.instance.Show();
      }
   }
}

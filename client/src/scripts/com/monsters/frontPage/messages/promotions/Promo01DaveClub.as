package com.monsters.frontPage.messages.promotions
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.subscriptions.SubscriptionHandler;
   
   public class Promo01DaveClub extends KeywordMessage
   {
      
      private static const TIME_UNTIL_RESET:uint = 604800;
      
      public static const NAME:String = "promodaveclub";
       
      
      private var m_CanBeShown:Boolean = false;
      
      public function Promo01DaveClub()
      {
         super("promodaveclub","btn_tellmore","fp_promodaveclub_v2.jpg");
      }
      
      public function get canBeShown() : Boolean
      {
         return this.m_CanBeShown;
      }
      
      public function set canBeShown(param1:Boolean) : void
      {
         this.m_CanBeShown = param1;
      }
      
      override public function setup(param1:Object) : void
      {
         super.setup(param1);
         markAsUnseenIfOlderThan(TIME_UNTIL_RESET);
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return this.m_CanBeShown;
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         SubscriptionHandler.instance.showPromoPopup();
      }
   }
}

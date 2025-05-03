package com.monsters.subscriptions
{
   import com.cc.tests.ABTest;
   import com.monsters.baseplanner.BasePlanner;
   import com.monsters.frontPage.FrontPageHandler;
   import com.monsters.frontPage.FrontPageLibrary;
   import com.monsters.frontPage.messages.promotions.Promo01DaveClub;
   import com.monsters.frontPage.messages.promotions.Promo02DaveClub;
   import com.monsters.interfaces.IHandler;
   import com.monsters.rewarding.Reward;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.subscriptions.rewards.DAVEStatueReward;
   import com.monsters.subscriptions.rewards.ExtraTilesReward;
   import com.monsters.subscriptions.rewards.GoldenDAVEReward;
   import com.monsters.subscriptions.rewards.ImprovedHCCReward;
   import com.monsters.subscriptions.rewards.YardPlannerExtraSlotsReward;
   import com.monsters.subscriptions.ui.SubscriptionJoinPopup;
   import com.monsters.subscriptions.ui.SubscriptionResourceIcon;
   import com.monsters.subscriptions.ui.controlPanel.SubscriptionControlPanelPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SubscriptionHandler implements IHandler
   {
      
      public static const JOIN:String = "startSubscription";
      
      public static const CANCEL:String = "cancelSubscription";
      
      public static const CANCELCONFIRM:String = "cancelConfirmation";
      
      public static const CLOSECONFIRM:String = "closeConfirmation";
      
      public static const CHANGE:String = "changeSubscription";
      
      public static const REACTIVATE:String = "reactiveSubscription";
      
      private static var _instance:SubscriptionHandler;
      
      public static var ignoreAB:Boolean = false;
       
      
      private var _rewardIDs:Vector.<String>;
      
      private var _renewalDate:uint;
      
      private var _expirationDate:uint;
      
      private var _icon:SubscriptionResourceIcon;
      
      private var _service:SubscriptionService;
      
      private var _subscriptionID:Number;
      
      public function SubscriptionHandler()
      {
         this._rewardIDs = Vector.<String>([ImprovedHCCReward.ID,DAVEStatueReward.ID,GoldenDAVEReward.ID,ExtraTilesReward.ID,YardPlannerExtraSlotsReward.ID]);
         super();
      }
      
      public static function get instance() : SubscriptionHandler
      {
         if(!_instance)
         {
            _instance = new SubscriptionHandler();
            _instance._service = new SubscriptionService();
         }
         return _instance;
      }
      
      public static function get isEnabledForAll() : Boolean
      {
         return GLOBAL._flags["subscriptions"] > 0 && GLOBAL._flags["subscriptions_ab"] == 0;
      }
      
      public static function setRenewalDateDEBUG(param1:uint) : void
      {
         _instance._renewalDate = param1;
         _instance.updateSubscriptionStatus();
      }
      
      public static function setExpirationDateDEBUG(param1:uint) : void
      {
         _instance._expirationDate = param1;
         _instance.updateSubscriptionStatus();
      }
      
      public function get name() : String
      {
         return "subscriptions";
      }
      
      public function get isSubscriptionActive() : Boolean
      {
         // return Boolean(this._renewalDate) || Boolean(this._expirationDate);
         return true;
      }
      
      public function get renewalDate() : uint
      {
         return this._renewalDate;
      }
      
      public function get expirationDate() : uint
      {
         return this._expirationDate;
      }
      
      public function get service() : SubscriptionService
      {
         return _instance._service;
      }
      
      private function specialUser() : Boolean
      {
         return ignoreAB || (LOGIN._playerID == 12467111 || LOGIN._playerID == 3099454);
      }
      
      public function initialize(param1:Object = null) : void
      {
         if(!SubscriptionHandler.isEnabledForAll && !ABTest.isInTestGroup("davesclub108",64) && !this.specialUser() || !GLOBAL.isAtHome() || !GLOBAL._flags["subscriptions"] || GLOBAL.isNoob())
         {
            return;
         }
         this.unlockTeaserInformation();
         this.addIcon();
         this._service.addEventListener(SubscriptionStatusEvent.STATUS_EVENT,this.recievedSubscriptionData);
         this._service.getSubscriptionData();
      }
      
      protected function recievedSubscriptionData(param1:SubscriptionStatusEvent) : void
      {
         this._subscriptionID = param1.subscriptionID;
         this._renewalDate = param1.renewalDate;
         this._expirationDate = param1.expirationDate;
         this.updateSubscriptionStatus();
      }
      
      private function updateSubscriptionStatus() : void
      {
         this.updateRewards();
         this._icon.update(this.isSubscriptionActive);
         var _loc1_:Promo01DaveClub = FrontPageLibrary.getMessageByName(Promo01DaveClub.NAME) as Promo01DaveClub;
         var _loc2_:Promo02DaveClub = FrontPageLibrary.getMessageByName(Promo02DaveClub.NAME) as Promo02DaveClub;
         if(_loc1_ && !ABTest.isInTestGroup("davesclub108",64) && !this.isSubscriptionActive)
         {
            _loc1_.canBeShown = true;
         }
         else if(_loc2_ && ABTest.isInTestGroup("davesclub108",64) && SubscriptionHandler.isEnabledForAll)
         {
            _loc2_.canBeShown = true;
         }
         if(!_loc1_ && !_loc2_)
         {
            return;
         }
         if(FrontPageHandler.hasBeenSetupThisSession == false)
         {
            return;
         }
         if(FrontPageHandler.hasBeenSeenThisSession == false || FrontPageHandler.isVisible)
         {
            FrontPageHandler.showPopup(true);
         }
         else if(POPUPS.hasPopupsOpen())
         {
            FrontPageHandler.refresh();
         }
      }
      
      private function unlockTeaserInformation() : void
      {
         var _loc1_:DAVEStatueReward = RewardHandler.instance.getRewardByID(DAVEStatueReward.ID) as DAVEStatueReward;
         if(_loc1_ == null || _loc1_.hasBeenApplied == false)
         {
            DAVEStatueReward.unlockTeaserInformation(this.showPromoPopup);
         }
         if(SubscriptionHandler.isEnabledForAll)
         {
            BasePlanner.maxNumberOfSlots = 10;
         }
      }
      
      private function addIcon() : void
      {
         this._icon = new SubscriptionResourceIcon(this.isSubscriptionActive);
         UI2._top.addResourceBar(this._icon);
         this._icon.addEventListener(MouseEvent.CLICK,this.clickedIcon,false,0,true);
      }
      
      protected function clickedIcon(param1:Event) : void
      {
         if(this.isSubscriptionActive)
         {
            this.showControlPanel();
         }
         else
         {
            GLOBAL.Message(KEYS.Get("disabled_daveclub"));
         }
      }
      
      private function showControlPanel() : void
      {
         var _loc1_:SubscriptionControlPanelPopup = new SubscriptionControlPanelPopup();
         POPUPS.Push(_loc1_);
         _loc1_.addEventListener(Event.CLOSE,this.clickedClosePanel);
         _loc1_.addEventListener(CHANGE,this.clickedChange);
         _loc1_.addEventListener(CANCEL,this.clickedCancel);
         _loc1_.addEventListener(REACTIVATE,this.clickedReactivate);
         _loc1_.addEventListener(SubscriptionControlPanelPopup.PLACE_DAVE_STATUE,this.clickedPlace);
         _loc1_.addEventListener(SubscriptionControlPanelPopup.REMOVE_DAVE_STATUE,this.clickedRemove);
         _loc1_.addEventListener(SubscriptionControlPanelPopup.SAVE,this.clickedSave);
      }
      
      protected function clickedClosePanel(param1:Event) : void
      {
         var _loc2_:SubscriptionControlPanelPopup = param1.target as SubscriptionControlPanelPopup;
         _loc2_.removeEventListener(Event.CLOSE,this.clickedClosePanel);
         _loc2_.removeEventListener(CHANGE,this.clickedChange);
         _loc2_.removeEventListener(CANCEL,this.clickedCancel);
         _loc2_.removeEventListener(REACTIVATE,this.clickedReactivate);
         _loc2_.removeEventListener(SubscriptionControlPanelPopup.PLACE_DAVE_STATUE,this.clickedPlace);
         _loc2_.removeEventListener(SubscriptionControlPanelPopup.REMOVE_DAVE_STATUE,this.clickedRemove);
         _loc2_.removeEventListener(SubscriptionControlPanelPopup.SAVE,this.clickedSave);
         POPUPS.Next();
      }
      
      protected function clickedReactivate(param1:Event) : void
      {
         this._service.reactivateSubscription(this._subscriptionID);
      }
      
      protected function clickedChange(param1:Event) : void
      {
         this._service.changeSubscription(this._subscriptionID);
      }
      
      protected function clickedCancel(param1:Event) : void
      {
         this._service.cancelSubscription(this._subscriptionID);
      }
      
      protected function clickedPlace(param1:Event) : void
      {
         LOGGER.StatB({"st1":"daves_club"},"golden_dave_placed");
         BASE.addBuildingB(DAVEStatueReward.DAVE_STATUE_TYPE_ID,true);
      }
      
      protected function clickedRemove(param1:Event) : void
      {
         var _loc2_:BFOUNDATION = DAVEStatueReward.findStatueRewardInWorld();
         if(_loc2_ != null)
         {
            _loc2_.RecycleC();
         }
      }
      
      protected function clickedSave(param1:Event) : void
      {
         var _loc2_:SubscriptionControlPanelPopup = param1.target as SubscriptionControlPanelPopup;
         var _loc3_:Reward = RewardHandler.instance.getRewardByID(GoldenDAVEReward.ID);
         if(this.updateRewardValue(_loc3_,_loc2_.goldDavesToggle))
         {
            if(_loc2_.goldDavesToggle)
            {
               LOGGER.StatB({"st1":"daves_club"},"dave_on");
            }
            else
            {
               LOGGER.StatB({"st1":"daves_club"},"dave_off");
            }
         }
         _loc3_ = RewardHandler.instance.getRewardByID(ExtraTilesReward.ID);
         this.updateRewardValue(_loc3_,_loc2_.bgTileSelected);
         POPUPS.Next();
         BASE.Save();
      }
      
      private function updateRewardValue(param1:Reward, param2:Number) : Boolean
      {
         if(param1.value == param2)
         {
            return false;
         }
         param1.value = param2;
         RewardHandler.instance.applyReward(param1);
         return true;
      }
      
      public function showPromoPopup() : void
      {
         if (this.isSubscriptionActive) 
         {
            var _loc1_:SubscriptionJoinPopup = new SubscriptionJoinPopup();
            POPUPS.Push(_loc1_);
            _loc1_.addEventListener(JOIN,this.clickedJoin);
            _loc1_.addEventListener(Event.CLOSE,this.clickedClose);
         }
         else
         {
            GLOBAL.Message(KEYS.Get("disabled_daveclub"));
         }
      }
      
      protected function clickedJoin(param1:Event) : void
      {
         this._service.startSubscription();
         this.clickedClose(param1);
      }
      
      protected function clickedClose(param1:Event) : void
      {
         var _loc2_:SubscriptionJoinPopup = param1.target as SubscriptionJoinPopup;
         _loc2_.removeEventListener(JOIN,this.clickedJoin);
         _loc2_.removeEventListener(Event.CLOSE,this.clickedClose);
         POPUPS.Next();
      }
      
      private function updateRewards() : void
      {
         var _loc2_:Reward = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._rewardIDs.length)
         {
            if(this.isSubscriptionActive)
            {
               _loc2_ = RewardHandler.instance.updateExistingOrAddNewReward(this._rewardIDs[_loc1_]);
               if(!_loc2_.hasBeenApplied)
               {
                  RewardHandler.instance.applyReward(_loc2_);
               }
            }
            else
            {
               RewardHandler.instance.removeRewardByID(this._rewardIDs[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      public function importData(param1:Object) : void
      {
         this._renewalDate = GLOBAL.StatGet("renewal");
         this._expirationDate = GLOBAL.StatGet("expiration");
         this.updateRewards();
      }
      
      public function exportData() : Object
      {
         GLOBAL.StatSet("renewal",this._renewalDate,false);
         GLOBAL.StatSet("expiration",this._expirationDate,false);
         return null;
      }
   }
}

package com.monsters.subscriptions.ui.controlPanel
{
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.subscriptions.SubscriptionHandler;
   import com.monsters.subscriptions.rewards.DAVEStatueReward;
   import com.monsters.subscriptions.rewards.ExtraTilesReward;
   import com.monsters.subscriptions.rewards.GoldenDAVEReward;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SubscriptionControlPanelPopup extends subscriptions_controlPanel_popup
   {
      
      public static const SAVE:String = "saveChanges";
      
      public static const PLACE_DAVE_STATUE:String = "placeDAVEStatue";
      
      public static const REMOVE_DAVE_STATUE:String = "removeDAVEStatue";
       
      
      public var bgTileSelected:int;
      
      public var goldDavesToggle:int;
      
      private var _tiles:Vector.<MovieClip>;
      
      private var _memberPopup:MembershipPopup = null;
      
      public function SubscriptionControlPanelPopup()
      {
         super();
         this.setup();
         tDavesGold_title.htmlText = KEYS.Get("dc_panel_golddave");
         mcDave1.gotoAndStop(1);
         mcDave2.gotoAndStop(2);
         mcDavesGoldToggle.gotoAndStop(this.goldDavesToggle + 1);
         mcDavesGoldToggle.addEventListener(MouseEvent.CLICK,this.clickedGoldDaveToggle);
         mcDavesGoldToggle.buttonMode = true;
         mcDave3.gotoAndStop(3);
         if(DAVEStatueReward.doesStatueRewardExistsInInventory())
         {
            bPlaceDave.buttonMode = true;
            bPlaceDave.Setup(KEYS.Get("btn_placedave"));
            bPlaceDave.addEventListener(MouseEvent.CLICK,this.clickedPlaceDaveStatue);
         }
         else
         {
            bPlaceDave.buttonMode = true;
            bPlaceDave.Setup(KEYS.Get("btn_removedave"));
            bPlaceDave.addEventListener(MouseEvent.CLICK,this.clickedRemoveDaveStatue);
         }
         bSave.buttonMode = true;
         bSave.Highlight = true;
         bSave.Setup(KEYS.Get("btn_save"));
         bSave.addEventListener(MouseEvent.CLICK,this.clickedSave);
         bMembership.Setup(KEYS.Get("btn_membership"));
         bMembership.buttonMode = true;
         bMembership.addEventListener(MouseEvent.CLICK,this.clickedMembership);
         this._memberPopup = null;
         tMembers_title.htmlText = KEYS.Get("dc_panel_benefits");
         tMembers_desc.htmlText = KEYS.Get("dc_panel_benefitsdesc");
         tTerrainSelect.htmlText = KEYS.Get("dc_panel_terrain");
         this._tiles = Vector.<MovieClip>([mcTile1,mcTile2,mcTile3,mcTile4]);
         var _loc1_:int = 0;
         while(_loc1_ < this._tiles.length)
         {
            this._tiles[_loc1_].buttonMode = true;
            this._tiles[_loc1_].mcSelect.visible = false;
            this._tiles[_loc1_].addEventListener(MouseEvent.CLICK,this.clickedBGTileSelect);
            switch(_loc1_)
            {
               case 0:
                  this._tiles[_loc1_].mcTerrain.gotoAndStop("isograss1");
                  break;
               case 1:
                  this._tiles[_loc1_].mcTerrain.gotoAndStop("rockgrass");
                  break;
               case 2:
                  this._tiles[_loc1_].mcTerrain.gotoAndStop("isosand3");
                  break;
               case 3:
                  this._tiles[_loc1_].mcTerrain.gotoAndStop("isocrater1");
                  break;
            }
            _loc1_++;
         }
         this._tiles[this.bgTileSelected].mcSelect.visible = true;
      }
      
      private function setup() : void
      {
         this.bgTileSelected = RewardHandler.instance.getRewardByID(ExtraTilesReward.ID).value;
         this.goldDavesToggle = RewardHandler.instance.getRewardByID(GoldenDAVEReward.ID).value;
      }
      
      private function clickedGoldDaveToggle(param1:MouseEvent = null) : void
      {
         this.goldDavesToggle = (this.goldDavesToggle + 1) % 2;
         mcDavesGoldToggle.gotoAndStop(this.goldDavesToggle + 1);
      }
      
      private function clickedPlaceDaveStatue(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(PLACE_DAVE_STATUE));
         this.Hide();
      }
      
      private function clickedRemoveDaveStatue(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(REMOVE_DAVE_STATUE));
         this.Hide();
      }
      
      private function clickedSave(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(SAVE));
      }
      
      private function clickedMembership(param1:MouseEvent = null) : void
      {
         this._memberPopup = new MembershipPopup();
         this._memberPopup.addEventListener(SubscriptionHandler.REACTIVATE,this.membershipReactivated);
         this._memberPopup.addEventListener(SubscriptionHandler.CHANGE,this.membershipChanged);
         this._memberPopup.addEventListener(SubscriptionHandler.CANCEL,this.membershipCancel);
         this._memberPopup.addEventListener(Event.CLOSE,this.clickedCloseMembership);
         POPUPS.Add(this._memberPopup);
         POPUPSETTINGS.AlignToCenter(this._memberPopup);
      }
      
      protected function membershipReactivated(param1:Event) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.REACTIVATE));
      }
      
      private function membershipChanged(param1:Event) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.CHANGE));
      }
      
      private function membershipCancel(param1:Event) : void
      {
         dispatchEvent(new Event(SubscriptionHandler.CANCEL));
      }
      
      private function clickedCloseMembership(param1:Event) : void
      {
         if(this._memberPopup)
         {
            this._memberPopup.removeEventListener(SubscriptionHandler.REACTIVATE,this.membershipReactivated);
            this._memberPopup.removeEventListener(SubscriptionHandler.CHANGE,this.membershipChanged);
            this._memberPopup.removeEventListener(SubscriptionHandler.CANCEL,this.membershipCancel);
            this._memberPopup.removeEventListener(Event.CLOSE,this.clickedCloseMembership);
         }
         POPUPS.Remove(this._memberPopup);
      }
      
      private function clickedBGTileSelect(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._tiles.length)
         {
            this._tiles[_loc2_].mcSelect.visible = false;
            if(param1.currentTarget == this._tiles[_loc2_])
            {
               this.bgTileSelected = _loc2_;
            }
            _loc2_++;
         }
         param1.currentTarget.mcSelect.visible = true;
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         mcDavesGoldToggle.removeEventListener(MouseEvent.CLICK,this.clickedGoldDaveToggle);
         bPlaceDave.removeEventListener(MouseEvent.CLICK,this.clickedPlaceDaveStatue);
         bSave.removeEventListener(MouseEvent.CLICK,this.clickedSave);
         bMembership.removeEventListener(MouseEvent.CLICK,this.clickedMembership);
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

package com.monsters.alliances.tabs
{
   public class SuggestedTab extends MembersTab
   {
      public function SuggestedTab()
      {
         super();
      }

      override protected function get _titleKey():String
      {
         return "alliance_suggested_title";
      }

      /**
       * Suggested members aren't in the alliance yet, so the actions are to
       * visit their base or invite them.
       * @param {Object} rowData - The row the actions apply to
       * @returns {Array} Visit Base + Invite actions for MemberActionPopup
       */
      override protected function _actionsFor(rowData:Object):Array
      {
         return [
               {labelKey: "alliance_btn_visit", handler: _onVisitBase},
               {labelKey: "alliance_btn_invite", handler: _onInvite}
            ];
      }

      /**
       * Invites the suggested player to the alliance. Stubbed for now.
       * @param {Object} rowData - The row that was acted on
       */
      private function _onInvite(rowData:Object):void
      {
         // TODO: send invite request to server for rowData
      }

      /**
       * @returns {Array} Suggested member rows. Mock data until the server-side
       * suggestion payload is wired up.
       */
      override protected function _memberData():Array
      {
         return [
               {level: 38, name: "Korgan", online: true, ep: "42118903", attacker: ""},
               {level: 35, name: "Mira", online: false, ep: "31995210", attacker: ""},
               {level: 44, name: "Thorne", online: true, ep: "58740112", attacker: ""}
            ];
      }
   }
}

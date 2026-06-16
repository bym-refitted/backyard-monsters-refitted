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

      override protected function get _actionLabelKey():String
      {
         return "alliance_btn_invite";
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

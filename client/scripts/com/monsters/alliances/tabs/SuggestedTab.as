package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;

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
       * Invites the suggested player. The store drops its candidate list on success,
       * so _load refetches and the invited player drops out of the table - the server
       * leaves out anyone already holding a pending invite.
       *
       * @param {Object} rowData - The row that was acted on
       */
      private function _onInvite(rowData:Object):void
      {
         ALLIANCES.InviteUser(int(rowData.user_id), function(response:Object):void
            {
               if (response == null)
               {
                  GLOBAL.Message(KEYS.Get("alliance_err_generic"));
                  return;
               }

               if (response.error)
               {
                  GLOBAL.Message(String(response.error));
                  return;
               }

               GLOBAL.Message(KEYS.Get("alliance_invite_sent"));

               _load();
            });
      }

      /**
       * Candidates come from their own store cache rather than the roster one, but
       * arrive in the same row shape, so the inherited mapping and table draw them.
       */
      override protected function _load():void
      {
         var answeredDuringBuild:Boolean = true;

         ALLIANCES.LoadSuggested(function(members:Array):void
            {
               _members = (members != null) ? _mapRows(members) : [];

               if (!answeredDuringBuild) _rerender();
            });

         answeredDuringBuild = false;
      }
   }
}

package com.monsters.alliances.tabs {
    import com.monsters.alliances.ALLIANCES;
    import com.monsters.maproom_advanced.MapRoom;
    import com.monsters.maproom_manager.MapRoomManager;

    public class SuggestedTab extends MembersTab {
        private static const CODE_OUTSIDE_WORLD:String = "ALLIANCE_OUTSIDE_WORLD";

        public function SuggestedTab() {
            super();
        }

        override protected function get _titleKey():String {
            return "alliance_suggested_title";
        }

        /**
         * Suggested members aren't in the alliance yet, so the actions are to
         * visit their base or invite them.
         * @param {Object} rowData - The row the actions apply to
         * @returns {Array} Visit Base + Invite actions for MemberActionPopup
         */
        override protected function _actionsFor(rowData:Object):Array {
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
        private function _onInvite(rowData:Object):void {
            var outsideWorld:String = CODE_OUTSIDE_WORLD;

            ALLIANCES.InviteUser(int(rowData.user_id), function(response:Object):void {
                    if (response == null) {
                        GLOBAL.Message(KEYS.Get("alliance_err_generic"));
                        return;
                    }

                    if (response.error) {
                        if (response.code == outsideWorld) {
                            _showCantInvite(String(response.error));
                            return;
                        }

                        GLOBAL.Message(String(response.error));
                        return;
                    }

                    GLOBAL.Message(KEYS.Get("alliance_invite_sent"));

                    _load();
                });
        }

        /**
         * Tells the leader the player is out of reach, and offers the map rather than
         * only refusing.
         *
         * This is the original's dialog: its invite button compared world and sector,
         * and on a mismatch raised a box headed cant_invite.png, bodied with
         * error_cannot_invite_outside_world, whose one button ran
         * `cc.sendToSwf("openmap")` and closed the alliance window. The message the
         * server sends is that same string; the header art is not in the repo, so the
         * title is drawn as text like the other alliance popups.
         *
         * @param {String} reason - The server's explanation, shown as the body.
         */
        private function _showCantInvite(reason:String):void {
            new AllianceMessagePopup().Show(
                    KEYS.Get("alliance_cant_invite_title"),
                    reason,
                    "alliance_btn_open_map",
                    _openMap
                );
        }

        /**
         * Opens the map room behind the alliance window.
         *
         * Map Room 2 draws its cells around MapRoom._homePoint, which only _Setup fills
         * in - showing it without that throws, since the player may never have opened the
         * map this session. Map Room 3 prepares its own cell data when shown, so it needs
         * nothing here.
         */
        private function _openMap():void {
            ALLIANCEWINDOW.Hide();

            if (MapRoomManager.instance.isInMapRoom2) {
                if (GLOBAL._mapHome == null)
                    return;

                MapRoom._Setup(GLOBAL._mapHome);
            }

            MapRoomManager.instance.Show();
        }

        /**
         * Candidates come from their own store cache rather than the roster one, but
         * arrive in the same row shape, so the inherited mapping and table draw them.
         */
        override protected function _load():void {
            var answeredDuringBuild:Boolean = true;

            ALLIANCES.LoadSuggested(function(members:Array):void {
                    _members = (members != null) ? _mapRows(members) : [];

                    if (!answeredDuringBuild)
                        _rerender();
                });

            answeredDuringBuild = false;
        }
    }
}

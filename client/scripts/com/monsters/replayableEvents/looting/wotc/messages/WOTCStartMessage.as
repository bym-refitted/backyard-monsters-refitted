package com.monsters.replayableEvents.looting.wotc.messages {
    import com.monsters.frontPage.FrontPageHandler;
    import com.monsters.frontPage.messages.KeywordMessage;
    import com.monsters.managers.InstanceManager;
    import com.monsters.maproom_manager.MapRoomManager;

    public class WOTCStartMessage extends KeywordMessage {

        public function WOTCStartMessage() {
            var _loc1_:Vector.<Object> = null;
            var _loc3_:String = null;
            _loc1_ = InstanceManager.getInstancesByClass(BUILDING11);
            var _loc2_:BUILDING11 = _loc1_.length ? _loc1_[0] as BUILDING11 : null;
            if (!_loc2_) {
                _loc3_ = "";
            }
            else if (!MapRoomManager.instance.isInMapRoom2) {
                _loc3_ = "btn_upgradenow";
            }
            else {
                _loc3_ = "btn_openmap";
            }
            super("wotcstart", _loc3_);
        }

        override protected function onButtonClick():void {
            var _loc1_:Vector.<Object> = null;
            _loc1_ = InstanceManager.getInstancesByClass(BUILDING11);
            var _loc2_:BUILDING11 = _loc1_.length ? _loc1_[0] as BUILDING11 : null;
            if (!MapRoomManager.instance.isInMapRoom2 && Boolean(_loc2_)) {
                FrontPageHandler.closeAll();
                BUILDINGOPTIONS.Show(_loc2_, "upgrade");
            }
            else if (MapRoomManager.instance.isInMapRoom2) {
                GLOBAL.ShowMap();
            }
        }

        override public function refresh():void {
            var _loc1_:Vector.<Object> = null;
            var _loc3_:String = null;
            _loc1_ = InstanceManager.getInstancesByClass(BUILDING11);
            var _loc2_:BUILDING11 = _loc1_.length ? _loc1_[0] as BUILDING11 : null;
            if (!_loc2_) {
                _loc3_ = "";
            }
            else if (!MapRoomManager.instance.isInMapRoom2) {
                _loc3_ = "btn_upgradenow";
            }
            else {
                _loc3_ = "btn_openmap";
            }
            _buttonCopy = _loc3_ ? KEYS.Get(_loc3_) : null;
        }
    }
}

package com.monsters.external_interface
{
    import com.monsters.alliances.ALLIANCES;
    import flash.external.ExternalInterface;
    import com.monsters.radio.RADIO;
    import com.monsters.maproom_manager.MapRoomManager;
    import com.monsters.enums.EnumYardType;

    public class ExternalInterfaceManager
    {
        private static var _init:Boolean = false;

        public function ExternalInterfaceManager()
        {
            super();
        }

        /**
         * Sets up the external interface callbacks if ExternalInterface is available.
         * This method should only be called once. Muptiple calls will have no effect after the first setup.
         */
        public static function Initialize():void
        {
            if (!ExternalInterface.available || _init) return;
            _init = true;

            ExternalInterface.addCallback("openbase", function(baseLoadParamsStr:String):void
                {
                    var baseLoadParams:Object = null;
                    var yardType:int = 0;
                    if (BASE._saveCounterA == BASE._saveCounterB && !BASE._saving && !BASE._loading)
                    {
                        GLOBAL._currentCell = null;
                        baseLoadParams = JSON.parse(baseLoadParamsStr);
                        yardType = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
                        if (baseLoadParams.viewleader)
                        {
                            BASE.LoadBase(baseLoadParams.url, baseLoadParams.userid, Number(baseLoadParams.baseid), GLOBAL.e_BASE_MODE.VIEW, true, yardType);
                        }
                        else if (Boolean(baseLoadParams.infurl) && BASE.isInfernoMainYardOrOutpost)
                        {
                            BASE.LoadBase(baseLoadParams.infurl, 0, Number(baseLoadParams.infbaseid), GLOBAL.e_BASE_MODE.IVIEW, true, EnumYardType.INFERNO_YARD);
                        }
                        else
                        {
                            BASE.LoadBase(baseLoadParams.url, baseLoadParams.userid, Number(baseLoadParams.baseid), GLOBAL.e_BASE_MODE.HELP, true, yardType);
                        }
                    }
                });
            ExternalInterface.addCallback("fbcBuyItem", function(param1:String):void
                {
                    STORE.FacebookCreditPurchaseB(param1);
                });
            ExternalInterface.addCallback("callbackgift", function(param1:String):void
                {
                    POPUPS.CallbackGift(param1);
                });
            ExternalInterface.addCallback("callbackshiny", function(param1:String):void
                {
                    POPUPS.CallbackShiny(param1);
                });
            ExternalInterface.addCallback("twitteraccount", function(param1:String):void
                {
                    RADIO.TwitterCallback(param1);
                });
            ExternalInterface.addCallback("updateCredits", function(param1:String):void
                {
                    STORE.updateCredits(param1);
                });
            ExternalInterface.addCallback("fbcAdd", function(param1:String):void
                {
                    BUY.FBCAdd(param1);
                });
            ExternalInterface.addCallback("fbcOfferDaily", function(param1:String):void
                {
                    BUY.FBCOfferDaily(param1);
                });
            ExternalInterface.addCallback("fbcOfferEarn", function(param1:String):void
                {
                    BUY.FBCOfferEarn(param1);
                });
            ExternalInterface.addCallback("fbcNcp", function(param1:String):void
                {
                    BUY.FBCNcp(param1);
                });
            ExternalInterface.addCallback("fbcNcpConfirm", function(param1:String):void
                {
                    BUY.FBCNcpConfirm(param1);
                });
            ExternalInterface.addCallback("purchaseReceive", function(param1:String):void
                {
                    BUY.purchaseReceive(param1);
                });
            ExternalInterface.addCallback("purchaseComplete", function(param1:String):void
                {
                    BUY.purchaseComplete(param1);
                });
            ExternalInterface.addCallback("receivePurchase", function(param1:String):void
                {
                    BUY.purchaseReceive(param1);
                });
            ExternalInterface.addCallback("startPromoTimer", function(param1:String):void
                {
                    BUY.startPromo(param1);
                });
            ExternalInterface.addCallback("alliancesupdate", function(param1:String):void
                {
                    ALLIANCES.AlliancesServerUpdate(param1);
                });
            ExternalInterface.addCallback("alliancesViewLeader", function(param1:String):void
                {
                    ALLIANCES.AlliancesViewLeader(param1);
                });
            ExternalInterface.addCallback("openmap", function(param1:String):void
                {
                    GLOBAL.ShowMap();
                });
        }
    }
}

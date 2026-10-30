package com.monsters.halloween {
    import com.monsters.pathing.PATHING;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class HalloweenMiniPumpkin extends BDECORATION {

        public static const TYPE:int = 53;

        private static const PICK_SHAKES:int = 60;

        public function HalloweenMiniPumpkin() {
            super(TYPE);
        }

        override public function Setup(building:Object):void {
            _expireTime = int(building.e);
            super.Setup(building);
        }

        override public function Export():Object {
            var exported:Object = super.Export();
            exported.e = _expireTime;
            return exported;
        }

        override public function PlaceB():void {
            super.PlaceB();
            _origin = new Point(_mc.x, _mc.y);
        }

        override protected function setupHit(layer:uint, level:int, state:String):void {
            super.setupHit(_RASTERDATA_TOP, level, state);
        }

        override public function Description():void {
            _buildingTitle = "<b>" + _buildingProps.name + "</b>";
            _specialDescription = "";
        }

        public function get isSpoiled():Boolean {
            return _expireTime > 0 && GLOBAL.Timestamp() >= _expireTime;
        }

        private function get isAtHome():Boolean {
            return GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard;
        }

        override public function TickFast(event:Event = null):void {
            super.TickFast(event);

            if (isAtHome && isSpoiled && !_picking)
                remove();
        }

        override public function Click(event:MouseEvent = null):void {
            if (!isAtHome || _picking || isSpoiled)
                return;

            super.Click(event);
        }

        public function sendWorker():void {
            if (_picking || isSpoiled)
                return;

            if (QUEUE.Add(queueKey, this))
                _picking = true;
            else
                POPUPS.DisplayWorker(2, this);
        }

        override public function HasWorker():void {
            if (_shake > PICK_SHAKES) {
                _mc.x = _mcBase.x = _origin.x;
                _mc.y = _mcBase.y = _origin.y;
                HalloweenPumpkinPatch.pick(this);
                return;
            }

            if (_shake % 2 == 0) {
                _mc.x = _origin.x - 2 + Math.random() * 4;
                _mc.y = _origin.y - 2 + Math.random() * 4;
                _mcBase.x = _origin.x - 1 + Math.random() * 2;
                _mcBase.y = _origin.y - 1 + Math.random() * 2;
            }

            ++_shake;
            updateRasterData();
        }

        public function get queueKey():String {
            return "pumpkin" + _id;
        }

        public function remove():void {
            GridCost(false);
            PATHING.ResetCosts();
            clear();
            BASE.Save();
        }
    }
}

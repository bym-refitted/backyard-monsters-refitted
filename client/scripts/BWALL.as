package {
    import com.monsters.display.ImageCache;
    import com.monsters.managers.InstanceManager;
    import com.monsters.pathing.PATHING;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import gs.TweenLite;

    public class BWALL extends BFOUNDATION {

        private static const k_WALL_SIZE:int = 20;

        private static const k_LINE_PRELOAD_TIMEOUT:Number = 3;

        private static var _lineUpgradeRunning:Boolean = false;

        public function BWALL() {
            super();
        }

        override public function GridCost(param1:Boolean = true):void {
            super.GridCost(param1);
            PATHING.RegisterBuilding(new Rectangle(_mc.x, _mc.y, 20, 20), this, param1);
        }

        override public function Description():void {
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            super.Description();
            if (_lvl.Get() < _buildingProps.hp.length) {
                _loc1_ = int(_buildingProps.hp[_lvl.Get() - 1]);
                _loc2_ = int(_buildingProps.hp[_lvl.Get()]);
                _upgradeDescription = KEYS.Get("building_wall_upgrade", {
                            "v1": GLOBAL.FormatNumber(_loc1_),
                            "v2": GLOBAL.FormatNumber(_loc2_),
                            "v3": int(100 / _loc1_ * _loc2_) - 100
                        });
            }
        }

        override public function RecycleC():void {
            PATHING.RegisterBuilding(new Rectangle(_mc.x, _mc.y, 20, 20), this, false);
            super.RecycleC();
        }

        /**
         * Walls take no build time, and Tick only finishes builds with a countdown, so the wall is finished here.
         * Then the next wall is picked up, unless this one was built instantly with Shiny.
         */
        override public function Place(param1:MouseEvent = null):void {
            var isNew:Boolean = _id == 0;
            super.Place(param1);
            if (!isNew || _id == 0) {
                return;
            }
            if (!_constructed && _countdownBuild.Get() == 0) {
                Constructed();
                if (BASE._pendingPurchase.length == 0) {
                    BASE.Save();
                }
            }
            if (!_buildInstant) {
                ContinuePlacing(_type);
            }
        }

        /**
         * Picks up another wall of the same type. Stops at the Town Hall's limit, or when short of resources
         * with the build menu's offer to buy them.
         */
        public static function ContinuePlacing(type:int):void {
            var check:Object = BASE.CanBuild(type);
            if (!check.error) {
                BASE.addBuildingB(type);
                return;
            }
            if (check.needResource) {
                offerTopoff(getCost(GLOBAL._buildingProps[type - 1].costs[0]), BASE.isInfernoBuilding(type), false, function():void {
                        BASE.addBuildingB(type);
                    });
            }
        }

        /**
         * Upgrades every wall in the line through a wall by one level at once, without workers.
         */
        public static function UpgradeLine(wall:BFOUNDATION):void {
            if (_lineUpgradeRunning) {
                return;
            }
            var upgrade:Object = prepareLineUpgrade(wall);
            if (!upgrade) {
                return;
            }
            if (isShort(upgrade.cost, upgrade.isInferno)) {
                offerLineTopoff(wall, upgrade);
                return;
            }
            GLOBAL.Message(KEYS.Get("wall_upgradeline_confirm", {
                        "v1": upgrade.targets.length,
                        "v2": describeResources(upgrade.cost, upgrade.isInferno)
                    }), KEYS.Get("btn_upgrade"), function():void {
                    upgradeLineNow(wall);
                });
        }

        /**
         * Loads the new level images first so the whole line changes in the same frame, then works the line
         * out again, as it may have changed while loading.
         */
        private static function upgradeLineNow(wall:BFOUNDATION):void {
            if (_lineUpgradeRunning) {
                return;
            }
            var upgrade:Object = prepareLineUpgrade(wall);
            if (!upgrade) {
                return;
            }
            if (isShort(upgrade.cost, upgrade.isInferno)) {
                offerLineTopoff(wall, upgrade);
                return;
            }
            _lineUpgradeRunning = true;
            var baseID:Number = BASE._loadedBaseID;
            preloadNextLevelImages(upgrade.targets, function():void {
                    _lineUpgradeRunning = false;
                    var isSameYard:Boolean = BASE._loadedBaseID == baseID && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD;
                    if (!isSameYard || InstanceManager.getInstancesByClass(BWALL).indexOf(wall) < 0) {
                        return;
                    }
                    var ready:Object = prepareLineUpgrade(wall);
                    if (!ready) {
                        return;
                    }
                    if (isShort(ready.cost, ready.isInferno)) {
                        offerLineTopoff(wall, ready);
                        return;
                    }
                    for (var i:int = 0; i < ready.cost.length; i++) {
                        if (ready.cost[i] > 0) {
                            BASE.Charge(i + 1, ready.cost[i], false, ready.isInferno);
                        }
                    }
                    for each (var target:BFOUNDATION in ready.targets) {
                        target.Upgraded();
                        target.Update(true);
                    }
                    BASE.Save();
                });
        }

private static function offerLineTopoff(wall:BFOUNDATION, upgrade:Object):void {
            offerTopoff(upgrade.cost, upgrade.isInferno, true, function():void {
                    upgradeLineNow(wall);
                });
        }

private static function preloadNextLevelImages(walls:Vector.<BFOUNDATION>, onReady:Function):void {
            var urls:Array = [];
            for each (var wall:BFOUNDATION in walls) {
                var imageData:Object = GLOBAL._buildingProps[wall._type - 1].imageData;
                var level:int = wall._lvl.Get() + 1;
                while (level > 1 && !imageData[level]) {
                    level--;
                }
                for each (var imageName:String in _IMAGE_NAMES) {
                    if (imageData[level][imageName]) {
                        var url:String = imageData.baseurl + imageData[level][imageName][0];
                        if (urls.indexOf(url) < 0) {
                            urls.push(url);
                        }
                    }
                }
            }
            var pending:int = urls.length;
            var called:Boolean = false;
            var ready:Function = function():void {
                if (!called) {
                    called = true;
                    onReady();
                }
            };
            if (pending == 0) {
                ready();
                return;
            }
            TweenLite.delayedCall(k_LINE_PRELOAD_TIMEOUT, ready);
            for each (var imageURL:String in urls) {
                ImageCache.GetImageWithCallBack(imageURL, function(... loaded):void {
                        if (--pending == 0) {
                            ready();
                        }
                    }, true, 2);
            }
        }

private static function prepareLineUpgrade(wall:BFOUNDATION):Object {
            var targets:Vector.<BFOUNDATION> = getLineUpgradeTargets(wall);
            if (targets.length == 0) {
                GLOBAL.Message(KEYS.Get("wall_upgradeline_none"));
                return null;
            }
            return {
                    "targets": targets,
                    "cost": getUpgradeCost(targets),
                    "isInferno": BASE.isInfernoBuilding(wall._type)
                };
        }

private static function getLineUpgradeTargets(wall:BFOUNDATION):Vector.<BFOUNDATION> {
            var targets:Vector.<BFOUNDATION> = new Vector.<BFOUNDATION>();
            for each (var lineWall:BFOUNDATION in getLine(wall)) {
                if (lineWall.health < lineWall.maxHealth || lineWall._repairing) {
                    continue;
                }
                var check:Object = BASE.CanUpgrade(lineWall);
                if (!check.error || check.needResource > 0) {
                    targets.push(lineWall);
                }
            }
            return targets;
        }

        /**
         * Walls of the same type placed end to end with a wall along one grid axis. On a corner, the longer axis wins.
         */
        public static function getLine(wall:BFOUNDATION):Vector.<BFOUNDATION> {
            var wallsByCell:Object = {};
            for each (var other:BFOUNDATION in InstanceManager.getInstancesByClass(BWALL)) {
                if (other._type == wall._type) {
                    wallsByCell[getCellKey(GRID.FromISO(other._mc.x, other._mc.y))] = other;
                }
            }
            var origin:Point = GRID.FromISO(wall._mc.x, wall._mc.y);
            var row:Vector.<BFOUNDATION> = getRun(wall, wallsByCell, origin, 1, 0);
            var column:Vector.<BFOUNDATION> = getRun(wall, wallsByCell, origin, 0, 1);
            return column.length > row.length ? column : row;
        }

private static function getRun(wall:BFOUNDATION, wallsByCell:Object, origin:Point, stepX:int, stepY:int):Vector.<BFOUNDATION> {
            var run:Vector.<BFOUNDATION> = new Vector.<BFOUNDATION>();
            run.push(wall);
            for each (var direction:int in [1, -1]) {
                var cell:Point = origin.clone();
                while (true) {
                    cell.offset(stepX * k_WALL_SIZE * direction, stepY * k_WALL_SIZE * direction);
                    var next:BFOUNDATION = wallsByCell[getCellKey(cell)];
                    if (!next) {
                        break;
                    }
                    run.push(next);
                }
            }
            return run;
        }

        private static function getCellKey(cell:Point):String {
            return cell.x + "_" + cell.y;
        }

private static function getCost(costEntry:Object):Array {
            var cost:Array = [];
            for (var i:int = 1; i <= 4; i++) {
                cost.push(int(costEntry["r" + i].Get()));
            }
            return cost;
        }

private static function getUpgradeCost(walls:Vector.<BFOUNDATION>):Array {
            var cost:Array = [0, 0, 0, 0];
            for each (var wall:BFOUNDATION in walls) {
                var levelCost:Array = getCost(wall._buildingProps.costs[wall._lvl.Get()]);
                for (var i:int = 0; i < cost.length; i++) {
                    cost[i] += levelCost[i];
                }
            }
            return cost;
        }

private static function getShortfall(cost:Array, isInferno:Boolean):Array {
            var resources:Object = isInferno ? BASE._iresources : BASE._resources;
            var shortfall:Array = [];
            for (var i:int = 0; i < cost.length; i++) {
                shortfall.push(Math.max(0, cost[i] - resources["r" + (i + 1)].Get()));
            }
            return shortfall;
        }

private static function isShort(cost:Array, isInferno:Boolean):Boolean {
            return getTotal(getShortfall(cost, isInferno)) > 0;
        }

private static function isOverCapacity(cost:Array, isInferno:Boolean):Boolean {
            var resources:Object = isInferno ? BASE._iresources : BASE._resources;
            for (var i:int = 0; i < cost.length; i++) {
                if (cost[i] > resources["r" + (i + 1) + "max"]) {
                    return true;
                }
            }
            return false;
        }

        private static function getTotal(amounts:Array):int {
            var total:int = 0;
            for each (var amount:int in amounts) {
                total += amount;
            }
            return total;
        }

private static function getTopoffPrice(missing:int):int {
            return Math.ceil(Math.pow(Math.sqrt(missing / 2), 0.75));
        }

        /**
         * Same short-of-resources messages and Shiny top-off as BUILDINGOPTIONSPOPUP's build and upgrade.
         */
        private static function offerTopoff(cost:Array, isInferno:Boolean, isUpgrade:Boolean, onFunded:Function):void {
            if (isOverCapacity(cost, isInferno)) {
                var silosKey:String = isUpgrade ? "buildoptions_err_moresilosupgrade" : "buildoptions_err_moresilos";
                GLOBAL.Message(KEYS.Get(isInferno ? "inf_" + silosKey : silosKey));
                return;
            }
            var missing:int = getTotal(getShortfall(cost, isInferno));
            GLOBAL.Message(KEYS.Get(isUpgrade ? "buildoptions_err_moreresourcesupgrade" : "buildoptions_err_moreresources", {
                        "v1": GLOBAL.FormatNumber(missing),
                        "v2": GLOBAL.FormatNumber(getTopoffPrice(missing))
                    }), KEYS.Get("btn_getresources"), function():void {
                    topoff(cost, isInferno, onFunded);
                });
        }

private static function topoff(cost:Array, isInferno:Boolean, onFunded:Function):void {
            if (isOverCapacity(cost, isInferno)) {
                GLOBAL.Message(KEYS.Get("msg_overcapacity"));
                return;
            }
            if (BASE._pendingPurchase.length > 0) {
                return;
            }
            var shortfall:Array = getShortfall(cost, isInferno);
            var price:int = getTopoffPrice(getTotal(shortfall));
            if (price > BASE._credits.Get()) {
                POPUPS.DisplayGetShiny();
                return;
            }
            for (var i:int = 0; i < shortfall.length; i++) {
                if (shortfall[i] > 0) {
                    BASE.Fund(i + 1, shortfall[i], false, null, isInferno);
                }
            }
            onFunded();
            BASE.Purchase("BRTOPUP", price, "BWALL.topoff");
        }

private static function describeResources(amounts:Array, isInferno:Boolean):String {
            var parts:Array = [];
            for (var i:int = 0; i < amounts.length; i++) {
                if (amounts[i] > 0) {
                    parts.push(GLOBAL.FormatNumber(amounts[i]) + " " + GLOBAL.getResourceName("r" + (i + 1), isInferno));
                }
            }
            return parts.join(", ");
        }
    }
}

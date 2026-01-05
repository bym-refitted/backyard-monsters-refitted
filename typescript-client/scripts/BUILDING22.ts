import { SecNum } from './com/cc/utils/SecNum';
import { MapRoomManager } from './com/monsters/maproom_manager/MapRoomManager';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { CreepInfo } from './com/monsters/player/CreepInfo';
import { SiegeWeapons } from './com/monsters/siege/SiegeWeapons';
import { Decoy } from './com/monsters/siege/weapons/Decoy';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import MovieClip from 'openfl/display/MovieClip';
import Shape from 'openfl/display/Shape';
import Sprite from 'openfl/display/Sprite';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { Bunker } from './Bunker';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { CREATURELOCKER } from './CREATURELOCKER';
import { CREATURES } from './CREATURES';
import { GLOBAL } from './GLOBAL';
import { KEYS } from './KEYS';
import { MAP } from './MAP';
import { POPUPS } from './POPUPS';
import { SOUNDS } from './SOUNDS';
import { Targeting } from './Targeting';
import { TweenLite, Expo } from './gs/TweenLite';

/**
 * BUILDING22 - Monster Bunker
 * Extends Bunker for monster defense building with creature storage
 */
export class BUILDING22 extends Bunker {
    private static readonly kPercentAllowed: number = 0.1;
    
    public _animMC: MovieClip | null = null;
    public _animFrame: number = 0;
    public _field: BitmapData | null = null;
    public _fieldBMP: Bitmap | null = null;
    public _frameNumber: number = 0;
    public _animBitmap: BitmapData | null = null;
    public _blend: number = 0;
    public _blending: boolean = false;
    public _bank: SecNum | null = null;
    public _monsters: Record<string, any> = {};
    public _open: boolean = false;
    public _releaseCooldown: number = 0;
    public _targetCreeps: any[] = [];
    public _targetFlyers: any[] = [];
    public _targetCreep: any = null;
    public _hasTargets: boolean = false;
    public _tickNumber: number = 0;
    public _capacity: number = 0;
    private _logged: boolean = false;
    private _radiusGraphic: Shape | null = null;

    constructor() {
        super();
        this._type = 22;
        this._frameNumber = 0;
        this._footprint = [new Rectangle(0, 0, 90, 90)];
        this._gridCost = [
            [new Rectangle(0, 0, 10, 10), 50],
            [new Rectangle(80, 0, 10, 10), 50],
            [new Rectangle(0, 80, 10, 10), 50],
            [new Rectangle(80, 80, 10, 10), 50]
        ];
        this._spoutPoint = new Point(0, 0);
        this._spoutHeight = 40;
        this._monsters = {};
        this._monstersDispatched = {};
        this._targetCreeps = [];
        this._targetFlyers = [];
        this.SetProps();
    }

    public FindTargets(count: number, priority: number = 1): void {
        if (this._lvl.Get() > 0 && this.health > 0) {
            let targets: any[] = Targeting.getCreepsInRange(
                GLOBAL._buildingProps[21].stats[this._lvl.Get() - 1].range,
                this._position!.add(new Point(0, this._footprint[0].height / 2)),
                Targeting.getOldStyleTargets(0)
            );
            this._hasTargets = false;
            if (targets.length > 0) {
                this._targetCreeps = [];
                if (priority === 1) {
                    targets.sort((a, b) => a.dist - b.dist);
                } else if (priority === 2) {
                    targets.sort((a, b) => b.dist - a.dist);
                } else if (priority === 3) {
                    targets.sort((a, b) => b.hp - a.hp);
                } else if (priority === 4) {
                    targets.sort((a, b) => a.hp - b.hp);
                }
                let added = 0;
                for (const target of targets) {
                    added++;
                    if (added <= count && target.creep._behaviour !== "retreat") {
                        this._targetCreeps.push({
                            creep: target.creep,
                            dist: target.dist,
                            position: target.pos
                        });
                        this._hasTargets = true;
                    }
                }
            }
            // Check for flying targets if we have flying attackers
            if ((this._monsters["C12"] && GLOBAL.player.m_upgrades["C12"]?.powerup) ||
                (this._monsters["C5"] && GLOBAL.player.m_upgrades["C5"]?.powerup) ||
                this._monsters["IC5"] || this._monsters["IC7"]) {
                targets = Targeting.getCreepsInRange(
                    GLOBAL._buildingProps[21].stats[this._lvl.Get() - 1].range,
                    this._position!.add(new Point(0, this._footprint[0].height / 2)),
                    Targeting.getOldStyleTargets(2)
                );
                if (targets.length > 0) {
                    this._targetFlyers = [];
                    if (priority === 1) {
                        targets.sort((a, b) => a.dist - b.dist);
                    } else if (priority === 2) {
                        targets.sort((a, b) => b.dist - a.dist);
                    } else if (priority === 3) {
                        targets.sort((a, b) => b.hp - a.hp);
                    } else if (priority === 4) {
                        targets.sort((a, b) => a.hp - b.hp);
                    }
                    let added = 0;
                    for (const target of targets) {
                        added++;
                        if (added <= count && target.creep._behaviour !== "retreat") {
                            this._targetFlyers.push({
                                creep: target.creep,
                                dist: target.dist,
                                position: target.pos
                            });
                            this._hasTargets = true;
                        }
                    }
                }
            } else {
                this._targetFlyers = [];
            }
            return;
        }
        this._targetCreeps = [];
        this._targetFlyers = [];
        this._hasTargets = false;
    }

    public GetTarget(flying: number = 0): any {
        if (this._hasTargets) {
            if (flying > 0 && this._targetFlyers.length > 0) {
                let idx = Math.floor(Math.random() * this._targetFlyers.length);
                if (idx > this._targetFlyers.length) idx = 2;
                return this._targetFlyers[idx].creep;
            }
            if (this._targetCreeps.length > 0) {
                let idx = Math.floor(Math.random() * this._targetCreeps.length);
                if (idx > this._targetCreeps.length) idx = 2;
                return this._targetCreeps[idx].creep;
            }
            return null;
        }
        return null;
    }

    private numMonsters(creatureId: string): number {
        if (this._monsters[creatureId]) {
            return MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard 
                ? this._monsters[creatureId].length 
                : this._monsters[creatureId];
        }
        return 0;
    }

    public EjectCreeps(targetPos: Point): void {
        let creatureToRelease: string | null = null;
        for (const creatureId in this._monsters) {
            if (this._monsters[creatureId] && this._monstersDispatched[creatureId] < this.numMonsters(creatureId) && this._animTick >= 15) {
                creatureToRelease = creatureId;
                if (creatureToRelease) {
                    let dx: number = targetPos.x - this._position!.x;
                    let dy: number = targetPos.y - this._position!.y;
                    const fw: number = this._footprint[0].width;
                    const fh: number = this._footprint[0].height;
                    if (dy <= 0) {
                        dy = fh / 4;
                        dx = dx <= 0 ? fw / -3 : fw / 2;
                    } else {
                        dy = fh / 2;
                        dx = dx <= 0 ? fw / -4 : fw / 2;
                    }
                    const spawned = CREATURES.Spawn(creatureToRelease, MAP._BUILDINGTOPS, "decoy", this._position!.add(new Point(dx, dy)), Math.random() * 360);
                    if (spawned) {
                        spawned._homeBunker = this;
                        ++this._monstersDispatched[creatureToRelease];
                        ++this._monstersDispatchedTotal;
                    }
                }
            }
        }
    }

    private DecoyInRange(): boolean {
        if (SiegeWeapons.activeWeapon && SiegeWeapons.activeWeaponID === Decoy.ID) {
            const decoy = SiegeWeapons.activeWeapon as Decoy;
            if (decoy) {
                const pos = new Point(decoy.x, decoy.y);
                if (GLOBAL.QuickDistance(pos, this._position!) < decoy.range) {
                    return true;
                }
            }
        }
        return false;
    }

    private getNumReleasableCreeps(creatureId: string): number {
        if (!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard) {
            return this._monsters[creatureId];
        }
        let count: number = this.numMonsters(creatureId);
        const minHealth: number = CREATURES.GetProperty(creatureId, "health", 0, true);
        for (let i = count - 1; i >= 0; i--) {
            if (this._monsters[creatureId][i].self || this._monsters[creatureId][i].queued || 
                this._monsters[creatureId][i].health < minHealth * BUILDING22.kPercentAllowed) {
                count--;
            }
        }
        return count;
    }

    private getNextCreepToRelease(creatureId: string): CreepInfo | null {
        if (!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard) {
            return null;
        }
        const total: number = this._monsters[creatureId].length;
        const minHealth: number = CREATURES.GetProperty(creatureId, "health", 0, true);
        for (let i = 0; i < total; i++) {
            if (!this._monsters[creatureId][i].self && !this._monsters[creatureId][i].queued &&
                this._monsters[creatureId][i].health > minHealth * BUILDING22.kPercentAllowed) {
                return this._monsters[creatureId][i];
            }
        }
        return null;
    }

    public override TickAttack(): void {
        super.TickAttack();
        if (this.health > 0) {
            this._capacity = GLOBAL._buildingProps[21].capacity[this._lvl.Get() - 1];
        }
        this._used = 0;
        for (const creatureId in this._monsters) {
            this._used += CREATURES.GetProperty(creatureId, "cStorage", 0, true) * this.numMonsters(creatureId);
            if (!this._monstersDispatched[creatureId]) {
                this._monstersDispatched[creatureId] = 0;
            }
        }
        this.Cull();
        
        // Check if targets are dead
        let deadTarget = false;
        for (const target of this._targetCreeps) {
            if (target.creep.health <= 0) deadTarget = true;
        }
        for (const target of this._targetFlyers) {
            if (target.creep.health <= 0) deadTarget = true;
        }
        if (deadTarget) {
            this._targetCreeps = [];
            this._targetFlyers = [];
            this._hasTargets = false;
        }
        
        if (this._countdownUpgrade.Get() === 0 && ((!this._hasTargets || deadTarget) && this._frameNumber % 10 === 0 || this._frameNumber % 60 === 0)) {
            this.FindTargets(3);
        }
        ++this._tickNumber;
        
        // Release creatures to attack
        if ((this._targetFlyers.length > 0 || this._targetCreeps.length > 0) && (this._animTick >= 15 || GLOBAL._catchup) && this._tickNumber % 30 === 0) {
            let creatureToRelease: string | null = null;
            this._targetCreeps.sort((a, b) => a.dist - b.dist);
            this._targetFlyers.sort((a, b) => a.dist - b.dist);
            
            if (this._targetFlyers.length > 0 && this.getNumReleasableCreeps("C12") > 0 && 
                this._monstersDispatched["C12"] < this.numMonsters("C12") && GLOBAL.player.m_upgrades["C12"]?.powerup) {
                creatureToRelease = "C12";
            } else if (this._targetFlyers.length > 0 && this.getNumReleasableCreeps("C5") > 0 && 
                       this._monstersDispatched["C5"] < this.numMonsters("C5") && GLOBAL.player.m_upgrades["C5"]?.powerup) {
                creatureToRelease = "C5";
            } else if (this._targetFlyers.length > 0 && this.getNumReleasableCreeps("IC5") > 0 && 
                       this._monstersDispatched["IC5"] < this.numMonsters("IC5")) {
                creatureToRelease = "IC5";
            } else if (this._targetFlyers.length > 0 && this.getNumReleasableCreeps("IC7") > 0 && 
                       this._monstersDispatched["IC7"] < this.numMonsters("IC7")) {
                creatureToRelease = "IC7";
            } else if (this._targetCreeps.length > 0) {
                for (const cid in this._monsters) {
                    if (this._monsters[cid] && this.getNumReleasableCreeps(cid) > 0 && this._monstersDispatched[cid] < this.numMonsters(cid)) {
                        creatureToRelease = cid;
                    }
                }
            }
            
            if (creatureToRelease) {
                if (!this._logged) {
                    const monsterList: any[] = [];
                    for (const cid in this._monsters) {
                        if (this.numMonsters(cid) > 0) {
                            const name = KEYS.Get(CREATURELOCKER._creatures[cid].name);
                            monsterList.push([this.numMonsters(cid), name]);
                        }
                    }
                    this._logged = true;
                    ATTACK.Log("b" + this._id, `<font color="#FF0000">${KEYS.Get("attacklog_unleashed", {
                        v1: this._lvl.Get(),
                        v2: KEYS.Get(this._buildingProps.name),
                        v3: GLOBAL.Array2String(monsterList)
                    })}</font>`);
                }
                
                let targetCreep: MonsterBase;
                if (this._targetFlyers.length > 0 && (creatureToRelease === "C12" || creatureToRelease === "C5" || creatureToRelease === "IC5" || creatureToRelease === "IC7")) {
                    targetCreep = this._targetFlyers[Math.floor(Math.random() * this._targetFlyers.length)].creep;
                } else {
                    targetCreep = this._targetCreeps[Math.floor(Math.random() * this._targetCreeps.length)].creep;
                }
                
                let dx: number = targetCreep._tmpPoint.x - this._position!.x;
                let dy: number = targetCreep._tmpPoint.y - this._position!.y;
                const fw: number = this._footprint[0].width;
                const fh: number = this._footprint[0].height;
                if (dy <= 0) {
                    dy = fh / 4;
                    dx = dx <= 0 ? fw / -3 : fw / 2;
                } else {
                    dy = fh / 2;
                    dx = dx <= 0 ? fw / -4 : fw / 2;
                }
                
                const creepInfo = this.getNextCreepToRelease(creatureToRelease);
                const spawned = CREATURES.Spawn(creatureToRelease, MAP._BUILDINGTOPS, "defend", 
                    this._position!.add(new Point(dx, dy)), Math.random() * 360, null, null, 0, 
                    creepInfo ? creepInfo.health : Number.MAX_SAFE_INTEGER);
                    
                if (spawned) {
                    spawned._targetCreep = targetCreep;
                    spawned._homeBunker = this;
                    spawned._hasTarget = true;
                    if (creepInfo) {
                        creepInfo.self = spawned;
                    }
                    if (spawned._pathing === "direct") {
                        spawned._phase = 1;
                    }
                    spawned.WaypointTo(spawned._targetCreep._tmpPoint);
                    spawned._targetPosition = spawned._targetCreep._tmpPoint;
                    ++this._monstersDispatched[creatureToRelease];
                    ++this._monstersDispatchedTotal;
                }
            }
        }
    }

    public override TickFast(event: Event | null = null): void {
        ++this._frameNumber;
        if (!GLOBAL._catchup) {
            if (this._used > 0 && (this._targetCreeps.length > 0 || this._targetFlyers.length > 0 || this._monstersDispatchedTotal > 0 || this.DecoyInRange())) {
                if (this._animTick === 1) {
                    SOUNDS.Play("bunkerdoor");
                }
                if (this._animTick < 15) {
                    this._animTick += 1;
                    this.AnimFrame(false);
                }
            } else {
                if (this._animTick === 15) {
                    SOUNDS.Play("bunkerdoor");
                }
                if (this._animTick > 0) {
                    --this._animTick;
                    this.AnimFrame(false);
                }
            }
        }
    }

    public override Description(): void {
        super.Description();
        this._upgradeDescription = KEYS.Get("bunker_upgrade_desc");
    }

    public override Update(force: boolean = false): void {
        super.Update(force);
    }

    public override Constructed(): void {
        super.Constructed();
        if (this._lvl.Get() > 0) {
            this._capacity = GLOBAL._buildingProps[21].capacity[this._lvl.Get() - 1];
            this._range = GLOBAL._buildingProps[this._type - 1].stats[this._lvl.Get() - 1].range;
        }
    }

    public override Destroyed(byAttacker: boolean = true): void {
        for (const creatureId in this._monsters) {
            if (MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard) {
                for (let i = 0; i < this._monsters[creatureId].length; i++) {
                    this._monsters[creatureId][i].health *= 0.5;
                }
            } else {
                this._monsters[creatureId] = this._monstersDispatched[creatureId];
                if (this._monsters[creatureId] === 0) {
                    delete this._monsters[creatureId];
                }
            }
        }
        super.Destroyed();
    }

    public override Upgraded(): void {
        super.Upgraded();
        if (this._lvl.Get() > 0) {
            this._capacity = GLOBAL._buildingProps[21].capacity[this._lvl.Get() - 1];
            this._range = GLOBAL._buildingProps[this._type - 1].stats[this._lvl.Get() - 1].range;
        }
    }

    public override Recycle(): void {
        this._blockRecycle = false;
        if (MapRoomManager.instance.isInMapRoom3 && !BASE.isMainYardOrInfernoMainYard) {
            for (const creatureId in this._monsters) {
                if (this._monsters[creatureId].length) {
                    this._blockRecycle = true;
                    break;
                }
            }
        }
        super.Recycle();
    }

    public override RecycleC(): void {
        super.RecycleC();
        this._capacity = 0;
        this.Cull();
    }

    public Cull(): void {
        let changed = false;
        while (this._used > this._capacity) {
            for (const creatureId in this._monsters) {
                if (this.numMonsters(creatureId)) {
                    --this._monsters[creatureId];
                    this._used -= CREATURELOCKER._creatures[creatureId].props.cStorage;
                    changed = true;
                } else {
                    this._monsters[creatureId] = 0;
                    delete this._monsters[creatureId];
                    changed = true;
                }
            }
        }
        for (const creatureId in this._monsters) {
            if (this._monsters[creatureId] && this._monsters[creatureId] === 0) {
                delete this._monsters[creatureId];
                changed = true;
            }
        }
        if (changed) {
            BASE.Save();
        }
    }

    public RemoveCreature(creatureId: string): void {
        --this._monsters[creatureId];
        if (this._monsters[creatureId] < 0) {
            this._monsters[creatureId] = 0;
        }
        --this._monstersDispatched[creatureId];
        if (this._monstersDispatched[creatureId] < 0) {
            this._monstersDispatched[creatureId] = 0;
        }
        --this._monstersDispatchedTotal;
        if (this._monstersDispatchedTotal < 0) {
            this._monstersDispatchedTotal = 0;
        }
    }

    public override Over(event: MouseEvent): void {
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && this._lvl.Get() > 0 && 
            this._countdownBuild.Get() === 0 && this._countdownFortify.Get() === 0 && 
            this._countdownUpgrade.Get() === 0 && this.health > 0) {
            TweenLite.delayedCall(0.25, this.RangeIndicator.bind(this));
        }
    }

    private RangeIndicator(): void {
        const color: number = 0xFFFFFF;
        this._radiusGraphic = new Shape();
        this._radiusGraphic.graphics.beginFill(0xFFFFFF, 0.1);
        this._radiusGraphic.graphics.lineStyle(1, color, 0.25);
        const container: Sprite = new Sprite();
        const center: Point = this._position!.add(new Point(0, this._footprint[0].height * 0.25));
        const size: Point = new Point(this._range * 2.8, this._range * 1.2);
        this._radiusGraphic.graphics.drawEllipse(0, 0, size.x, size.y);
        this._radiusGraphic.x = -(size.x * 0.5);
        this._radiusGraphic.y = -(size.y * 0.5);
        container.addChild(this._radiusGraphic);
        container.x = center.x;
        container.y = center.y;
        MAP._BUILDINGFOOTPRINTS.addChild(container);
        TweenLite.from(container, 0.25, {
            alpha: 0.5,
            scaleX: 0.25,
            scaleY: 0,
            delay: 0,
            ease: Expo.easeOut
        });
        TweenLite.killDelayedCallsTo(this.RangeIndicator);
    }

    public override Out(event: MouseEvent): void {
        if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD && this._radiusGraphic) {
            if (this._radiusGraphic.parent) {
                this._radiusGraphic.parent.removeChild(this._radiusGraphic);
            }
            this._radiusGraphic = null;
        }
        TweenLite.killDelayedCallsTo(this.RangeIndicator);
    }

    private linkMonstersToData(building: any): void {
        if (!this._monsters) {
            this._monsters = {};
        }
        const monsterListLength: number = GLOBAL.player.monsterList.length;
        for (let i = 0; i < monsterListLength; i++) {
            const creeps = GLOBAL.player.monsterList[i].getOwnedCreeps(this._id);
            if (creeps.length) {
                this._monsters[GLOBAL.player.monsterList[i].m_creatureID] = creeps;
                this._monstersDispatched[GLOBAL.player.monsterList[i].m_creatureID] = 0;
            }
        }
    }

    public override Setup(building: any): void {
        super.Setup(building);
        if (MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard) {
            this.linkMonstersToData(building);
        } else {
            for (const creatureId in building.m) {
                this._monsters[creatureId] = building.m[creatureId];
                this._monstersDispatched[creatureId] = 0;
            }
        }
        if (this._lvl.Get() > 0) {
            this._capacity = GLOBAL._buildingProps[21].capacity[this._lvl.Get() - 1];
            this._range = GLOBAL._buildingProps[this._type - 1].stats[this._lvl.Get() - 1].range;
        }
    }

    public override Export(): any {
        const data: any = super.Export();
        if (this._monsters && this.health > 0) {
            for (const creatureId in this._monsters) {
                let count = 0;
                if (typeof this._monsters[creatureId] === "number") {
                    count = this._monsters[creatureId];
                } else if (this._monsters[creatureId].length > 0) {
                    count = this._monsters[creatureId].length;
                }
                if (data.m) {
                    data.m[creatureId] = count;
                } else {
                    data.m = { [creatureId]: count };
                }
            }
        }
        return data;
    }
}

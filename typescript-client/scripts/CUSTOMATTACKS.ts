import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { CreepBase } from './com/monsters/monsters/creeps/CreepBase';
import Point from 'openfl/geom/Point';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BUILDING27 } from './BUILDING27';
import { CREEPS } from './CREEPS';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { MAP } from './MAP';
import { MONSTERBAITER } from './MONSTERBAITER';
import { SOUNDS } from './SOUNDS';
import { UI2 } from './UI2';
import { WMATTACK } from './WMATTACK';

/**
 * CUSTOMATTACKS - Custom Attack Management
 * Handles special attack scenarios like Trojan Horse and tutorial attacks
 */
export class CUSTOMATTACKS {
    public static _history: any = {};
    public static _inProgress: boolean = false;
    public static _lastClick: number = 0;
    public static _started: boolean = false;
    public static _isAI: boolean = false;
    public static _attacks: number[] = [
        8000, 18800, 43240, 97290, 214038, 460182, 966382, 1981082, 3962164, 7726221,
        14679819, 27157666, 48883798, 85546647, 145429299, 189058089, 245775516,
        319508170, 415360622, 539968808, 701959450, 912547286, 1186311471, 1542204913,
        2004866386, 2606326302, 3388224193, 4404691451, 5726098886, 7443928552,
        9677107118, 12580239253, 16354311030, 21260604338, 27638785640, 35930421332,
        46709547731, 60722412051
    ];

    constructor() {}

    public static Setup(): void {
        CUSTOMATTACKS._started = false;
    }

    public static TrojanHorse(): void {
        if (!BUILDING27._exists && !BASE.isInfernoMainYardOrOutpost) {
            const mapHeight: number = GLOBAL._mapHeight;
            const yPos: number = -800 - (mapHeight - 800) / 2;
            const isoPos: Point = GRID.ToISO(-70, yPos, 0);
            const building: BFOUNDATION = BASE.addBuildingC(27);
            ++BASE._buildingCount;
            building.Setup({
                t: 27,
                X: -70,
                Y: yPos,
                id: BASE._buildingCount
            });
            MAP.FocusTo(isoPos.x, isoPos.y, 2);
            BASE.Save(0, false, true);
        }
    }

    public static CustomAttack(attackData: any[], autoAttack: boolean = false): any[] {
        CUSTOMATTACKS._started = true;
        WMATTACK._isAI = false;
        WMATTACK.AttackB();
        UI2.Show("scareAway");
        if (UI2._scareAway) {
            UI2._scareAway.addEventListener("scareAway", MONSTERBAITER.End);
        }
        const spawned: any[] = WMATTACK.SpawnA(attackData);
        const firstMonster: MonsterBase = spawned[0][0];
        MAP.FocusTo(firstMonster.x, firstMonster.y, 2);
        return spawned;
    }

    public static WMIAttack(attackData: any[]): any[] {
        CUSTOMATTACKS._started = true;
        WMATTACK._isAI = false;
        WMATTACK.AttackB();
        UI2.Show("scareAway");
        if (UI2._scareAway) {
            UI2._scareAway.addEventListener("scareAway", MONSTERBAITER.End);
        }
        return WMATTACK.SpawnA(attackData);
    }

    public static TutorialAttack(): void {
        CUSTOMATTACKS._started = true;
        let spawned: any[] = WMATTACK.SpawnA([["C2", "bounce", 1, 180, -10, 0, 1]]);
        spawned = WMATTACK.SpawnA([["C2", "bounce", 2, 190, -5, 0, 1]]);
        spawned = WMATTACK.SpawnA([["C2", "bounce", 2, 190, 10, 0, 1]]);
        spawned = WMATTACK.SpawnA([["C2", "bounce", 1, 250, 5, 0, 1]]);
        spawned = WMATTACK.SpawnA([["C2", "bounce", 2, 190, 0, 0, 1]]);
        const monster = spawned[0][0];
        const distance: number = Point.distance(new Point(GLOBAL._bTower.x, GLOBAL._bTower.y), new Point(monster.x, monster.y));
        if (BASE.isInfernoMainYardOrOutpost) {
            SOUNDS.PlayMusic("musicipanic");
        } else {
            SOUNDS.PlayMusic("musicpanic");
        }
        WMATTACK.AttackB();
        WMATTACK.AttackC();
        MAP.FocusTo(GLOBAL._bTower.x, GLOBAL._bTower.y, Math.floor(distance / 100), 0, 0, false);
        for (const creepId in CREEPS._creeps) {
            const creep = CREEPS._creeps[creepId] as CreepBase;
            creep.maxHealthProperty.value = 1;
            creep.setHealth(1);
        }
        WMATTACK._isAI = false;
        WMATTACK._inProgress = true;
    }
}

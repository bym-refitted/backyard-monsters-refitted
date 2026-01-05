import { ResourceBombs } from './com/monsters/effects/ResourceBombs';
import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import Point from 'openfl/geom/Point';
import { ATTACK } from './ATTACK';
import { BASE } from './BASE';
import { BFOUNDATION } from './BFOUNDATION';
import { BTOWER } from './BTOWER';
import { BUILDING22 } from './BUILDING22';
import { CREEPS } from './CREEPS';
import { MAP } from './MAP';
import { SIEGEWEAPONPOPUP } from './SIEGEWEAPONPOPUP';
import { UI2 } from './UI2';

/**
 * DROPZONE - Drop Zone Manager
 * Handles targeting zones for spawning creatures and siege weapons
 */
export class DROPZONE {
    public static readonly GROUND: number = 1;
    public static readonly BUILDINGS: number = 2;
    public static readonly MONSTERS: number = 3;
    public static readonly SIEGEWEAPON_GROUND: number = 4;
    public static readonly SIEGEWEAPON_BUILDINGS: number = 5;
    public static readonly SIEGEWEAPON_GROUND_SPECIAL: number = 6;
    public static readonly SIEGEWEAPON_GROUND_SPECIAL_RADIUS: number = 30;

    public _size: number;
    public _middle: Point;
    public _dropTarget: number = 1;
    private _targetedBuildings: BFOUNDATION[] = [];
    public x: number = 0;
    public y: number = 0;
    public ring1: any;

    constructor(size: number = 32, dropTarget: number = 1) {
        this._middle = new Point(0, 0);
        this._targetedBuildings = [];
        this._size = size;
        this._dropTarget = dropTarget;
        this.ring1 = {};
        // In original: ring1.addEventListener(MouseEvent.MOUSE_UP, this.Place);
        // ring1.addEventListener(MouseEvent.MOUSE_DOWN, MAP.Click);
        // addEventListener(Event.ENTER_FRAME, this.Follow);
        this.Update(this._size, dropTarget);
    }

    public Update(size: number, dropTarget: number): void {
        this._size = size;
        this._dropTarget = dropTarget;
        if (this.ring1) {
            this.ring1.width = this._size * 1.2;
            this.ring1.height = this._size * 1.2 * 0.5;
        }
    }

    public Place(event: MouseEvent): void {
        if (!MAP._dragged && ATTACK._countdown >= 0) {
            this.Drop();
        }
    }

    public Follow(event: Event | null = null): void {
        if (MAP._GROUND) {
            this.x = MAP._GROUND.mouseX;
            this.y = MAP._GROUND.mouseY;
            switch (this._dropTarget) {
                case DROPZONE.GROUND:
                    if (!BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                        this.ring1.gotoAndStop(1);
                    } else {
                        this.ring1.gotoAndStop(2);
                    }
                    break;
                case DROPZONE.SIEGEWEAPON_GROUND:
                    if (!BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                        this.ring1.gotoAndStop(1);
                    } else {
                        this.ring1.gotoAndStop(2);
                    }
                    this.UpdateTargetBuildings(this.x, this.y, this._size);
                    break;
                case DROPZONE.SIEGEWEAPON_GROUND_SPECIAL:
                    if (!BASE.BuildingOverlap(new Point(this.x, this.y), DROPZONE.SIEGEWEAPON_GROUND_SPECIAL_RADIUS, true, true, true)) {
                        this.ring1.gotoAndStop(1);
                    } else {
                        this.ring1.gotoAndStop(2);
                    }
                    this.UpdateTargetBuildings(this.x, this.y, this._size);
                    break;
                case DROPZONE.BUILDINGS:
                case DROPZONE.SIEGEWEAPON_BUILDINGS:
                    if (BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                        this.ring1.gotoAndStop(1);
                    } else {
                        this.ring1.gotoAndStop(2);
                    }
                    this.UpdateTargetBuildings(this.x, this.y, this._size);
                    break;
                case DROPZONE.MONSTERS:
                    if (CREEPS.CreepOverlap(new Point(this.x, this.y), this._size)) {
                        this.ring1.gotoAndStop(1);
                    } else {
                        this.ring1.gotoAndStop(2);
                    }
                    break;
            }
        }
    }

    public Clear(): void {
        while (this._targetedBuildings.length) {
            this._targetedBuildings.pop()!.disableHighlight();
        }
    }

    public Destroy(): void {
        this.Clear();
        // removeEventListener(Event.ENTER_FRAME, this.Follow);
    }

    public get isOverTarget(): boolean {
        return this._targetedBuildings.length > 0;
    }

    public UpdateTargetBuildings(x: number, y: number, size: number): void {
        this.Clear();
        BASE.GetBuildingOverlap(x, y, size, this._targetedBuildings);
        switch (this._dropTarget) {
            case DROPZONE.SIEGEWEAPON_BUILDINGS:
                for (let i = this._targetedBuildings.length - 1; i >= 0; i--) {
                    if (!(this._targetedBuildings[i] instanceof BTOWER)) {
                        this._targetedBuildings.splice(i, 1);
                    }
                }
                break;
            case DROPZONE.SIEGEWEAPON_GROUND_SPECIAL:
                for (let i = this._targetedBuildings.length - 1; i >= 0; i--) {
                    if (!(this._targetedBuildings[i] instanceof BUILDING22)) {
                        this._targetedBuildings.splice(i, 1);
                    }
                }
                break;
        }
        for (let i = 0; i < this._targetedBuildings.length; i++) {
            this._targetedBuildings[i].highlight(0x333399);
        }
    }

    public Drop(): void {
        let siegePopup: SIEGEWEAPONPOPUP;
        switch (this._dropTarget) {
            case DROPZONE.GROUND:
                if (!BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                    ATTACK.Spawn(new Point(this.x, this.y), this._size / 2);
                }
                break;
            case DROPZONE.BUILDINGS:
                if (BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                    ResourceBombs.BombDrop();
                }
                break;
            case DROPZONE.MONSTERS:
                if (CREEPS.CreepOverlap(new Point(this.x, this.y), this._size)) {
                    ResourceBombs.BombDrop();
                }
                break;
            case DROPZONE.SIEGEWEAPON_GROUND:
                if (BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                    break;
                }
                siegePopup = UI2._top._siegeweapon;
                if (siegePopup && siegePopup._state === 1) {
                    siegePopup.Fire(this.x, this.y);
                }
                break;
            case DROPZONE.SIEGEWEAPON_BUILDINGS:
                if (!BASE.BuildingOverlap(new Point(this.x, this.y), this._size, true, true, true)) {
                    break;
                }
                siegePopup = UI2._top._siegeweapon;
                if (siegePopup && siegePopup._state === 1) {
                    siegePopup.Fire(this.x, this.y);
                }
                break;
            case DROPZONE.SIEGEWEAPON_GROUND_SPECIAL:
                if (BASE.BuildingOverlap(new Point(this.x, this.y), DROPZONE.SIEGEWEAPON_GROUND_SPECIAL_RADIUS, true, true, true)) {
                    break;
                }
                siegePopup = UI2._top._siegeweapon;
                if (siegePopup && siegePopup._state === 1) {
                    siegePopup.Fire(this.x, this.y);
                }
                break;
        }
    }
}

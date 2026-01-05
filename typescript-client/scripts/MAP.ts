import { BYMConfig } from './com/monsters/configs/BYMConfig';
import { KeyboardInputHandler } from './com/monsters/input/KeyboardInputHandler';
import { MonsterBase } from './com/monsters/monsters/MonsterBase';
import { RasterData } from './com/monsters/rendering/RasterData';
import { Renderer } from './com/monsters/rendering/Renderer';
import Bitmap from 'openfl/display/Bitmap';
import BitmapData from 'openfl/display/BitmapData';
import DisplayObject from 'openfl/display/DisplayObject';
import MovieClip from 'openfl/display/MovieClip';
import Sprite from 'openfl/display/Sprite';
import Stage from 'openfl/display/Stage';
import Event from 'openfl/events/Event';
import KeyboardEvent from 'openfl/events/KeyboardEvent';
import MouseEvent from 'openfl/events/MouseEvent';
import Matrix from 'openfl/geom/Matrix';
import Point from 'openfl/geom/Point';
import Rectangle from 'openfl/geom/Rectangle';
import { BFOUNDATION } from './BFOUNDATION';
import { CREEPS } from './CREEPS';
import { GLOBAL } from './GLOBAL';
import { GRID } from './GRID';
import { LOGGER } from './LOGGER';
import { MAPBG } from './MAPBG';
import { Targeting } from './Targeting';
import { TweenLite } from './gs/TweenLite';
import { UI2 } from './UI2';

/**
 * MAP - Main Game Map Management
 * Handles map rendering, scrolling, layers, and input
 */
export class MAP {
    public static _inited: boolean = false;
    public static _dragX: number = 0;
    public static _dragY: number = 0;
    public static tx: number = 0;
    public static ty: number = 0;
    public static targX: number = 0;
    public static targY: number = 0;
    public static d: number = 0;
    public static _startX: number = 0;
    public static _startY: number = 0;
    public static _autoScroll: boolean = false;
    public static stage: Stage;
    public static _dragging: boolean = false;
    public static _dragged: boolean = false;
    public static _dragDistance: number = 0;
    public static _EFFECTSBMP: BitmapData | null = null;
    public static _GROUND: Sprite | null = null;
    public static _EDGE: MovieClip | null = null;
    public static _UNDERLAY: MovieClip | null = null;
    public static _RESOURCES: MovieClip | null = null;
    public static _BUILDINGBASES: MovieClip | null = null;
    public static _WORKERS: MovieClip | null = null;
    public static _WALLS: MovieClip | null = null;
    public static _EFFECTS: Sprite | null = null;
    public static _CREEPSMC: MovieClip | null = null;
    public static _BUILDINGFOOTPRINTS: MovieClip | null = null;
    public static _BUILDINGINFO: MovieClip | null = null;
    public static _PROJECTILES: MovieClip | null = null;
    public static _FIREBALLS: MovieClip | null = null;
    public static _EFFECTSTOP: MovieClip | null = null;
    public static _BGTILES: MovieClip | null = null;
    public static _BUILDINGTOPS: Sprite | null = null;
    public static _damageGrid: Record<string, any> = {};
    public static _following: boolean = false;
    public static _sortTo: number = 0;
    public static _canScroll: boolean = true;

    public static readonly MAP_TYPE_GRASS: number = 0;
    public static readonly MAP_TYPE_ROCK: number = 1;
    public static readonly MAP_TYPE_SAND: number = 2;
    public static readonly MAP_TYPE_CRATER: number = 3;
    public static readonly MAP_TYPE_LAVA: number = 4;
    public static readonly DEPTH_SHADOW: number = 1;
    public static readonly MAP_WIDTH: number = 3994;
    public static readonly MAP_HEIGHT: number = 1994;

    protected static _bmdTile: BitmapData | null = null;
    protected static s_texture: string = "";
    private static _instance: MAP | null = null;
    private static _canvas: BitmapData | null = null;
    private static _canvasContainer: Bitmap | null = null;
    private static readonly _viewRect: Rectangle = new Rectangle();
    protected static _effectsRasterData: RasterData | null = null;
    public static vol: number = 1;

    protected _renderer: Renderer | null = null;
    protected readonly _point: Point = new Point();

    constructor(texture: string) {
        MAP._instance = this;
        MAP.stage = GLOBAL._ROOT.stage;
        try {
            MAP.tx = GLOBAL._SCREENINIT.width / 2;
            MAP.ty = GLOBAL._SCREENINIT.height / 2;
            MAP._viewRect.x = GLOBAL._SCREEN.x + MAP.MAP_WIDTH / 2;
            MAP._viewRect.y = GLOBAL._SCREEN.y + MAP.MAP_HEIGHT / 2;
            MAP._viewRect.width = GLOBAL._SCREEN.width;
            MAP._viewRect.height = GLOBAL._SCREEN.height;
            MAP._GROUND = GLOBAL._layerMap.addChild(new Sprite()) as Sprite;
            if (!BYMConfig.instance.RENDERER_ON) {
                MAP._BGTILES = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            }
            if (BYMConfig.instance.RENDERER_ON) {
                MAP._canvas = new BitmapData(MAP.MAP_WIDTH, MAP.MAP_HEIGHT, false, 0);
                MAP._canvasContainer = new Bitmap(MAP._canvas);
                MAP._canvasContainer.x = -MAP._canvasContainer.width / 2;
                MAP._canvasContainer.y = -MAP._canvasContainer.height / 2;
                MAP._GROUND.addChild(MAP._canvasContainer);
            }
        } catch (e: any) {
            LOGGER.Log("err", "MAP.Setup A: " + e.message + " | " + e.stack);
        }
        try {
            MAP._GROUND.x = MAP.tx;
            MAP._GROUND.y = MAP.ty;
            MAP._UNDERLAY = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            if (BYMConfig.instance.RENDERER_ON) {
                MAP._EFFECTSBMP = new BitmapData(MAP._canvas!.width, MAP._canvas!.height, false, 0);
                MAP._effectsRasterData = new RasterData(MAP._EFFECTSBMP, new Point((MAP._canvas!.width - MAP._EFFECTSBMP.width) * 0.5, (MAP._canvas!.height - MAP._EFFECTSBMP.height) * 0.5), 0, null, true);
            } else {
                MAP._EFFECTSBMP = new BitmapData(3200, 1800, true, 0);
                const efxbmp: Bitmap = MAP._GROUND.addChild(new Bitmap(MAP._EFFECTSBMP)) as Bitmap;
                efxbmp.x = -MAP._EFFECTSBMP.width * 0.5;
                efxbmp.y = -MAP._EFFECTSBMP.height * 0.5;
            }
            MAP.s_texture = texture;
            MAP.swapBG(MAP.s_texture);
            MAP._EFFECTS = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._EFFECTS.mouseEnabled = false;
            MAP._EFFECTS.mouseChildren = false;
            MAP._BUILDINGBASES = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._BUILDINGBASES.mouseEnabled = false;
            MAP._BUILDINGBASES.mouseChildren = true;
            MAP._BUILDINGFOOTPRINTS = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._BUILDINGFOOTPRINTS.mouseEnabled = false;
            MAP._BUILDINGFOOTPRINTS.mouseChildren = false;
            MAP._CREEPSMC = BYMConfig.instance.RENDERER_ON ? new MovieClip() : MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._CREEPSMC.mouseEnabled = false;
            MAP._CREEPSMC.mouseChildren = true;
            MAP._BUILDINGTOPS = MAP._GROUND.addChild(new Sprite()) as Sprite;
            MAP._BUILDINGTOPS.mouseEnabled = false;
            MAP._BUILDINGTOPS.mouseChildren = true;
            MAP._RESOURCES = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._RESOURCES.mouseEnabled = false;
            MAP._RESOURCES.mouseChildren = false;
            MAP._BUILDINGINFO = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._BUILDINGINFO.mouseEnabled = false;
            MAP._BUILDINGINFO.mouseChildren = true;
            MAP._PROJECTILES = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._PROJECTILES.mouseEnabled = false;
            MAP._PROJECTILES.mouseChildren = false;
            MAP._FIREBALLS = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._FIREBALLS.mouseEnabled = false;
            MAP._FIREBALLS.mouseChildren = false;
            MAP._EFFECTSTOP = MAP._GROUND.addChild(new MovieClip()) as MovieClip;
            MAP._EFFECTSTOP.mouseEnabled = false;
            MAP._EFFECTSTOP.mouseChildren = false;
            MAP._dragged = false;
            MAP._GROUND.addEventListener(MouseEvent.MOUSE_DOWN, MAP.Click);
            MAP._GROUND.addEventListener(Event.ENTER_FRAME, MAP.Scroll);
            MAP._GROUND.stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyboardInputHandler.instance.OnKeyDown);
            if (GLOBAL.DOES_USE_SCROLL) {
                MAP._GROUND.stage.addEventListener(MouseEvent.MOUSE_WHEEL, MAP.onMouseScroll);
            }
            MAP._GROUND.stage.addEventListener(KeyboardEvent.KEY_UP, MAP.KeyUp);
            MAP._EDGE = null;
        } catch (e: any) {
            LOGGER.Log("err", "MAP.Setup B: " + e.message + " | " + e.stack);
        }
        if (!BYMConfig.instance.RENDERER_ON) MAP.Edge();
        if (BYMConfig.instance.RENDERER_ON) {
            this._renderer = new Renderer(MAP._canvas!, MAP._viewRect);
            GLOBAL._ROOT.addEventListener(Event.RENDER, this.render.bind(this));
        }
        Targeting.init();
        MAP._inited = true;
    }

    public static get effectsBMD(): BitmapData | null { return MAP._EFFECTSBMP; }
    public static get texture(): string { return MAP.s_texture; }
    public static get instance(): MAP | null { return MAP._instance; }

    public static swapBG(textureName: string): void {
        MAP.s_texture = textureName;
        if (!BYMConfig.instance.RENDERER_ON && MAP._BGTILES) {
            while (MAP._BGTILES.numChildren) MAP._BGTILES.removeChildAt(0);
        }
        MAP._bmdTile = MAPBG.MakeTile(MAP.s_texture);
        if (BYMConfig.instance.RENDERER_ON) {
            const pt: Point = new Point();
            for (let i = 0; i < 4; i++) {
                for (let j = 0; j < 4; j++) {
                    pt.x = i * 1000;
                    pt.y = j * 500;
                    MAP._EFFECTSBMP!.copyPixels(MAP._bmdTile!, MAP._bmdTile!.rect, pt);
                }
            }
            MAP._bmdTile!.dispose();
            MAP._bmdTile = null;
            MAP.Edge();
        } else if (MAP._BGTILES) {
            for (let i = -2; i < 2; i++) {
                for (let j = -2; j < 2; j++) {
                    const tile: DisplayObject = MAP._BGTILES.addChild(new Bitmap(MAP._bmdTile!));
                    tile.x = i * 998;
                    tile.y = j * 498;
                    tile.cacheAsBitmap = true;
                }
            }
        }
    }

    public static swapIntBG(bgType: number): void {
        let textureName: string;
        switch (bgType) {
            case MAP.MAP_TYPE_ROCK: textureName = "rock"; break;
            case MAP.MAP_TYPE_SAND: textureName = "sand"; break;
            case MAP.MAP_TYPE_CRATER: textureName = "crater"; break;
            case MAP.MAP_TYPE_LAVA: textureName = "lava"; break;
            default: textureName = "grass";
        }
        MAP.swapBG(textureName);
    }

    public static Clear(): void {
        if (MAP._GROUND) {
            MAP._GROUND.removeEventListener(MouseEvent.MOUSE_DOWN, MAP.Click);
            MAP._GROUND.removeEventListener(Event.ENTER_FRAME, MAP.Scroll);
            while (MAP._GROUND.numChildren) MAP._GROUND.removeChildAt(0);
        }
        if (MAP._BUILDINGTOPS) {
            while (MAP._BUILDINGTOPS.numChildren) MAP._BUILDINGTOPS.removeChildAt(0);
        }
        if (BYMConfig.instance.RENDERER_ON && GLOBAL._ROOT.hasEventListener(Event.RENDER) && MAP._instance) {
            GLOBAL._ROOT.removeEventListener(Event.RENDER, MAP._instance.render);
        }
        MAP._BGTILES = null;
        MAP._BUILDINGBASES = null;
        MAP._BUILDINGFOOTPRINTS = null;
        MAP._BUILDINGTOPS = null;
        MAP._RESOURCES = null;
        MAP._BUILDINGINFO = null;
        MAP._PROJECTILES = null;
        MAP._FIREBALLS = null;
        MAP._EFFECTS = null;
        MAP._EFFECTSTOP = null;
        MAP._GROUND = null;
        MAP.s_texture = "";
        if (MAP._effectsRasterData) MAP._effectsRasterData.clear();
        if (MAP._bmdTile) MAP._bmdTile.dispose();
        if (MAP._canvas) MAP._canvas.dispose();
        if (MAP._EFFECTSBMP) MAP._EFFECTSBMP.dispose();
        MAP._effectsRasterData = null;
        MAP._bmdTile = null;
        MAP._canvas = null;
        MAP._EFFECTSBMP = null;
        MAP._inited = false;
    }

    public static Edge(): void {
        if (GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode !== GLOBAL.e_BASE_MODE.IBUILD) return;
        try {
            if (MAP._EDGE && MAP._EDGE.parent === MAP._UNDERLAY) MAP._UNDERLAY!.removeChild(MAP._EDGE);
            MAP._EDGE = BYMConfig.instance.RENDERER_ON ? new MovieClip() : MAP._UNDERLAY!.addChild(new MovieClip()) as MovieClip;
            MAP._EDGE.graphics.lineStyle(2, 0xFFFFFF, 0.5);
            let iso: Point = GRID.ToISO((0 - GLOBAL._mapWidth) / 2, (0 - GLOBAL._mapHeight) / 2, 0);
            MAP._EDGE.graphics.moveTo(iso.x, iso.y);
            iso = GRID.ToISO(GLOBAL._mapWidth / 2, (0 - GLOBAL._mapHeight) / 2, 0);
            MAP._EDGE.graphics.lineTo(iso.x, iso.y);
            iso = GRID.ToISO(GLOBAL._mapWidth / 2, GLOBAL._mapHeight / 2, 0);
            MAP._EDGE.graphics.lineTo(iso.x, iso.y);
            iso = GRID.ToISO((0 - GLOBAL._mapWidth) / 2, GLOBAL._mapHeight / 2, 0);
            MAP._EDGE.graphics.lineTo(iso.x, iso.y);
            iso = GRID.ToISO((0 - GLOBAL._mapWidth) / 2, (0 - GLOBAL._mapHeight) / 2, 0);
            MAP._EDGE.graphics.lineTo(iso.x, iso.y);
            if (BYMConfig.instance.RENDERER_ON) {
                MAP._EFFECTSBMP!.draw(MAP._EDGE, new Matrix(1, 0, 0, 1, MAP._EFFECTSBMP!.width * 0.5, MAP._EFFECTSBMP!.height * 0.5));
            } else {
                MAP._EDGE.cacheAsBitmap = true;
            }
        } catch (e: any) {
            LOGGER.Log("err", "MAP.Edge: " + e.message + " | " + e.stack);
        }
    }

    public static SortDepth(force: boolean = false, reverse: boolean = false): void {
        if (BYMConfig.instance.RENDERER_ON || !MAP._BUILDINGTOPS) return;
        const sorted: any[] = [];
        for (let i = MAP._BUILDINGTOPS.numChildren - 1; i >= 0; i--) {
            const child: DisplayObject = MAP._BUILDINGTOPS.getChildAt(i);
            const offset: number = child.height * 0.5;
            sorted.push({ depth: (child.y + offset) * 1000 + child.x, mc: child });
        }
        sorted.sort((a, b) => a.depth - b.depth);
        for (let i = 0; i < sorted.length; i++) {
            if (MAP._BUILDINGTOPS.getChildIndex(sorted[i].mc) !== i) {
                MAP._BUILDINGTOPS.setChildIndex(sorted[i].mc, i);
            }
        }
    }

    private static onMouseScroll(event: MouseEvent): void {
        GLOBAL.magnification += event.delta * 0.05;
    }

    public static KeyUp(event: KeyboardEvent): void {}

    public static Click(event: MouseEvent | null = null): void {
        if (UI2._scrollMap && MAP.stage) {
            MAP._dragX = MAP.stage.mouseX - MAP._GROUND!.x;
            MAP._dragY = MAP.stage.mouseY - MAP._GROUND!.y;
            MAP._startX = MAP._GROUND!.x;
            MAP._startY = MAP._GROUND!.y;
            MAP._dragging = true;
            MAP.stage.addEventListener(MouseEvent.MOUSE_UP, MAP.Release);
        }
    }

    public static Release(event: MouseEvent): void {
        MAP._dragging = false;
        MAP._dragged = false;
        MAP.stage?.removeEventListener(MouseEvent.MOUSE_UP, MAP.Release);
    }

    public static Focus(x: number, y: number): void {
        if (!GLOBAL._catchup && MAP._GROUND) {
            MAP.tx = GLOBAL._SCREEN.x - (x - GLOBAL._SCREEN.width / 2);
            MAP.ty = GLOBAL._SCREEN.y - (y - GLOBAL._SCREEN.height / 2);
            MAP._GROUND.x = MAP.tx;
            MAP._GROUND.y = MAP.ty;
            MAP._instance?.resizeViewRect();
        }
    }

    public static FocusTo(x: number, y: number, time: number, delay: number = 0, pause: number = 0, 
                          ease: boolean = true, callback: Function | null = null): void {
        if (!GLOBAL._catchup && MAP._GROUND) {
            const FocusToDone = () => {
                if (!MAP._GROUND) return;
                MAP.tx = MAP._GROUND.x;
                MAP.ty = MAP._GROUND.y;
                MAP._autoScroll = false;
                if (callback) callback();
                MAP._instance?.resizeViewRect();
                BFOUNDATION.updateAllRasterData();
            };
            if (pause > 0) {
                UI2.Hide("top");
                UI2.Hide("bottom");
            }
            MAP._autoScroll = true;
            MAP.tx = 0 - (x - 380);
            MAP.ty = 0 - (y - 340);
            TweenLite.to(MAP._GROUND, time, {
                x: MAP.tx, y: MAP.ty,
                ease: ease ? "Cubic.easeInOut" : "Linear.easeNone",
                delay: delay,
                onUpdate: BFOUNDATION.updateAllRasterData,
                onComplete: FocusToDone,
                overwrite: false
            });
        }
    }

    public static FollowStart(): void {
        UI2.Hide("top");
        UI2.Hide("bottom");
        MAP._following = true;
    }

    public static FollowStop(): void {
        UI2.Show("top");
        UI2.Show("bottom");
        MAP._following = false;
    }

    public static Scroll(event: Event | null = null): void {
        if (!MAP._GROUND || !MAP.stage) return;
        if (MAP._following) {
            const creeps = CREEPS._creeps;
            let count = 0;
            MAP.tx = 0;
            MAP.ty = 0;
            for (const key in creeps) {
                const monster: MonsterBase = creeps[key];
                if (monster._behaviour === "attack" || monster._behaviour === "loot") {
                    count++;
                    MAP.tx += monster.x;
                    MAP.ty += monster.y;
                }
            }
            if (count <= 0) {
                MAP.tx = MAP._dragX;
                MAP.ty = MAP._dragY;
                if (CREEPS._creepCount === 0) MAP.FollowStop();
                return;
            }
            MAP.tx /= count;
            MAP.ty /= count;
            MAP.tx = 0 - MAP.tx + GLOBAL._ROOT.stage.stageWidth * 0.5;
            MAP.ty = 0 - MAP.ty + GLOBAL._ROOT.stage.stageHeight * 0.5;
            MAP._dragX = MAP.tx;
            MAP._dragY = MAP.ty;
            BFOUNDATION.updateAllRasterData();
        } else if (MAP._dragging && UI2._scrollMap && !MAP._autoScroll && MAP._canScroll) {
            const mx = MAP.stage.mouseX;
            const my = MAP.stage.mouseY;
            MAP.tx = (mx - MAP._dragX) >> 0;
            MAP.ty = (my - MAP._dragY) >> 0;
            const dx = mx - (MAP._dragX + MAP._startX);
            const dy = my - (MAP._dragY + MAP._startY);
            MAP._dragDistance = Math.abs(dx * dx + dy * dy);
            if (MAP._dragDistance > 100) {
                MAP._dragged = true;
                BFOUNDATION.updateAllRasterData();
            }
        }
        // Boundary constraints
        const w = GLOBAL._ROOT.stage.stageWidth;
        const h = GLOBAL._ROOT.stage.stageHeight;
        const minX = -1615, maxX = 2375, minY = -650, maxY = 1325;
        let limit = maxX - (w >> 1);
        if (MAP.tx > limit) MAP.tx = limit;
        limit = minX + (w >> 1);
        if (MAP.tx < limit) MAP.tx = limit;
        limit = minY + (h >> 1);
        if (MAP.ty < limit) MAP.ty = limit;
        limit = maxY - (h >> 1);
        if (MAP.ty > limit) MAP.ty = limit;
        
        MAP.targX = MAP._GROUND.x;
        MAP.targY = MAP._GROUND.y;
        if (MAP.targX < MAP.tx) MAP.targX += (MAP.tx - MAP.targX) >> 1;
        else if (MAP.targX > MAP.tx) MAP.targX -= (MAP.targX - MAP.tx) >> 1;
        if (Math.abs(MAP.targX - MAP.tx) <= 2) MAP.targX = MAP.tx;
        if (MAP.targY < MAP.ty - 1) MAP.targY += (MAP.ty - MAP.targY) >> 1;
        else MAP.targY -= (MAP.targY - MAP.ty) >> 1;
        if (Math.abs(MAP.targY - MAP.ty) <= 2) MAP.targY = MAP.ty;
        if (!MAP._autoScroll) {
            MAP._GROUND.x = MAP.targX >> 0;
            MAP._GROUND.y = MAP.targY >> 0;
        }
        MAP._instance?.resizeViewRect();
    }

    public get canvas(): BitmapData | null { return MAP._canvas; }
    public get canvasContainer(): Bitmap | null { return MAP._canvasContainer; }
    public get offset(): Point {
        this._point.x = MAP._canvasContainer!.x;
        this._point.y = MAP._canvasContainer!.y;
        return this._point;
    }
    public get viewRect(): Rectangle { return MAP._viewRect; }

    public resizeCanvas(): void {
        if (MAP._inited && MAP._canvas && (MAP._canvas.width !== GLOBAL._SCREEN.width || MAP._canvas.height !== GLOBAL._SCREEN.height)) {
            MAP._canvas = new BitmapData(GLOBAL._SCREEN.width, GLOBAL._SCREEN.height, true, 0xFF00FF00);
            MAP._canvasContainer!.bitmapData = MAP._canvas;
            MAP._canvasContainer!.x = GLOBAL._SCREEN.x;
            MAP._canvasContainer!.y = GLOBAL._SCREEN.y;
            this._renderer!.canvas = MAP._canvas;
        }
    }

    public resizeViewRect(): void {
        const rect = GLOBAL._SCREEN;
        MAP._viewRect.width = rect.width * (1 / MAP._GROUND!.scaleX) + 32;
        MAP._viewRect.height = rect.height * (1 / MAP._GROUND!.scaleY) + 32;
        MAP._viewRect.x = -(MAP._GROUND!.x * (1 / MAP._GROUND!.scaleX)) + (MAP.MAP_WIDTH >>> 1) + rect.x - 32;
        MAP._viewRect.y = -(MAP._GROUND!.y * (1 / MAP._GROUND!.scaleY)) + (MAP.MAP_HEIGHT >>> 1) + rect.y - 32;
    }

    private render(event: Event): void {
        this._renderer?.render();
    }
}

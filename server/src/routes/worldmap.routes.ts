import Router from "@koa/router";
import { debugDataLog } from "../middleware/debugDataLog";
import { KoaController } from "../utils/KoaController";
import { Context, Next } from "koa";

const router = new Router();

const mapRoomVersion: KoaController = async (ctx, next) => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    version: 3,
    h: "someHashValue",
  };
};

const initMapRoom: KoaController = async (ctx, next) => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    celldata: [
      {
        x: 500,
        y: 500,
      },
    ],
    h: "someHashValue",
  };
};

const mapRoomGetCells: KoaController = async (ctx, next) => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    celldata: [
      {
        n: "Placeholder name",
        uid: 101, // user ID
        bid: 1234, // base ID
        tid: 0, // wild monster tribe ID
        x: 500, // base x-coord
        y: 500, // base y-coord
        aid: 0,
        l: 0,
        pl: 0,
        r: 0,
        dm: 0,
        rel: 7,
        lo: 0,
        fr: 0,
        p: 0,
        d: 0,
        t: 0,
        fbid: "",
      },
    ],
    h: "someHashValue",
  };
};

const getNewMap: KoaController = async (ctx, next) => {
  const cells = []; // Represents each cell
  const mapGrid = 500; // Represents the size of the map by width & height, must be kept at 500

  // Loops through each row and column of the map (X/Y co-ordinates) and creates a new cell
  for (let x = 0; x < mapGrid; x++) {
    for (let y = 0; y < mapGrid; y++) {
      cells.push({
        h: 0,
        t: 100,
      });
    }
  }

  const response = {
    newmap: true, // forces the player onto map room 3 and skips the migration process.
    mapheaderurl: "http://localhost:3001/api/bm/getnewmap", // Reminder: put in ENV
    width: 500,
    height: 500,
    data: cells,
    h: "someHashValue",
  };

  ctx.status = 200;
  ctx.body = response;
};

router.get(
  "/worldmapv3/setmapversion",
  debugDataLog(),
  async (ctx: Context, next: Next) => mapRoomVersion(ctx, next)
);
router.post(
  "/worldmapv3/setmapversion",
  debugDataLog("Set maproom version"),
  async (ctx: Context, next: Next) => mapRoomVersion(ctx, next)
);

router.get(
  "/worldmapv3/initworldmap",
  debugDataLog(),
  async (ctx: Context, next: Next) => initMapRoom(ctx, next)
);
router.post(
  "/worldmapv3/initworldmap",
  debugDataLog("Init maproom data"),
  async (ctx: Context, next: Next) => initMapRoom(ctx, next)
);

router.get(
  "/worldmapv3/getcells",
  debugDataLog(),
  async (ctx: Context, next: Next) => mapRoomGetCells(ctx, next)
);
router.post(
  "/worldmapv3/getcells",
  debugDataLog("Get maproom cells"),
  async (ctx: Context, next: Next) => mapRoomGetCells(ctx, next)
);

router.get(
  "/api/bm/getnewmap",
  debugDataLog("Get new map"),
  async (ctx: Context, next: Next) => getNewMap(ctx, next)
);

router.post(
  "/api/bm/getnewmap",
  debugDataLog("Posting to new maproom"),
  async (ctx: Context, next: Next) => getNewMap(ctx, next)
);

export default router;

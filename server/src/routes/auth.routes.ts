import { Router, Request, Response } from "express";
import { debugDataLog } from "../middleware/debugDataLog";
import login from "../controllers/login";

const router = Router();

// This data will be returned by the login controller instead, remember to remove
const getPlayerInfo = (res: Response) => {
  res.status(200).json({
    error: 0,
    version: 128,
    userid: 101,
    username: "John",
    last_name: "Doe",
    pic_square: "",
    timeplayed: 200,
    email: "reactX@hotmail.com",
    stats: {
      inferno: {},
    },
    friendcount: 0,
    sessioncount: 1,
    addtime: 100,
    mapversion: 3,
    mailversion: 1,
    soundversion: 1,
    languageversion: 8,
    app_id: "2de76fv89",
    tpid: "t76fbxXsw",
    currency_url: "",
    bookmarks: {},
    _isFan: 0,
    sendgift: 1,
    sendinvite: 1,
    language: "en",
    h: "someHashValue",
  });
};

router.get(
  "/api/player/getinfo/",
  debugDataLog(),
  (_: any, res: Response) => getPlayerInfo(res)
);

// New routes for authentication to be used
// router.post("/api/player/getinfo/", debugDataLog("User login attempt"), login);
// router.post("/api/player/register/", debugDataLog("Registering user"), register);

router.post(
  "/api/player/getinfo/",
  debugDataLog("Posting player info"),
  (_: Request, res: Response) => getPlayerInfo(res)
);

export default router;

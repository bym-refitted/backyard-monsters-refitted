import Router from "@koa/router";
import { debugDataLog } from "../middleware/debugDataLog";
import { login } from "../controllers/login";
import { register } from "../controllers/register";

const router = new Router();

// New routes for authentication to be used
router.post("/api/player/getinfo", debugDataLog("User login attempt"), login);
router.post("/api/player/register",  debugDataLog("Registering user"), register);

export default router;

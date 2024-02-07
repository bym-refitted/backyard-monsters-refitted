import { createClient, type RedisClientType } from 'redis';
import router from "../app.routes";
import { logging } from "./logger";

const REDIS_USER_ID_TTL = 20; // seconds

export let redisClient: RedisClientType;

export const createRedisClient = async (): Promise<RedisClientType> => {

    const host = process.env.REDIS_HOST || "127.0.0.1";
    const port = process.env.REDIS_PORT || 6379;
    const user = process.env.REDIS_USER || "";
    const pass = process.env.REDIS_PASS || "";

    redisClient = createClient({
        username: user, // use your Redis user. More info https://redis.io/docs/management/security/acl/
        password: pass, // use your password here
        socket: {
            host: host,
            port: parseInt(String(port)),
        }
    });

    redisClient.on("connect", () => {
        logging("Redis client connected")
    })

    redisClient.on('error', (err) => {
        console.log('Redis Client Error', err.message)
        redisClient.disconnect()
    });

    await redisClient.connect();

    return redisClient
}

export const setUserIDCache = async (id: string | number, instanceID?: string)=> {
    redisClient.set(`bymr:user:${id}`, instanceID || id, {
        EX: REDIS_USER_ID_TTL,
    }).catch((err) => {
        if (process.env.ENV === "local") {
            logging("Error on caching user id on redis", err.message)
        }
    })
}

export const getUserIDCache = (id: string | number) => {
    return new Promise((resolve) => {
        redisClient.get(`bymr:user:${id}`)
            .then(resolve)
            .catch(() => {
                resolve(null)
            })
    })
}
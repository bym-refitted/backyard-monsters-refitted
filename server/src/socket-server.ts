import * as net from "net";
import { logging } from "./utils/logger";
import { Socket } from "node:net";
import { getUserIDCache, redisClient, setUserIDCache } from "./utils/redis";

const policyFile = '<?xml version="1.0"?><cross-domain-policy><site-control permitted-cross-domain-policies="all" /><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>';


interface SocketData {
    userID: string;
    instanceID: string;
}

export const newSocketServer = (host: string, port: number) => {

    const sockets: Map<Socket, SocketData> = new Map<Socket, SocketData>();
    const server = net.createServer()
    server.listen(port, host, () => {
        logging(`TCP Server running on: ${host}:${port}`)
    })

    server.on("connection", function (socket) {
        logging(`Socket connected: ${socket.remoteAddress}:${socket.remotePort}`)

        sockets.set(socket, { userID: "", instanceID: "" });
        let requestData = '';
        socket.on("data", async (data) => {
            if (process.env.ENV === "local") {
                logging(`Data received from: ${socket.remoteAddress}:${socket.remotePort} ${data.toString()}`)
            }
            requestData += data.toString();
            if (requestData.includes('<policy-file-request/>\0')) {
                socket.write(policyFile);
                socket.end()
                return;
            }

            const message = data.toString();
            if (message.includes("login") || message.includes("ping")) {
                const [action, id, instanceID] = message.split(":");
                if (action === "login") {
                    sockets.set(socket, { userID: id, instanceID: instanceID })
                }
                let sameInstance = await checkUserInstance(id, instanceID);
                if (!sameInstance) {
                    socket.write(sameInstance.toString())
                    return;
                } else {
                    await setUserIDCache(id, instanceID)
                    socket.write(sameInstance.toString())
                }
            }
        })

        socket.on("error", (error) => {
            sockets.delete(socket);
            logging(`Socket error: ${socket.remoteAddress}:${socket.remotePort} -  ${error.name}:${error.message}`)
        })

        socket.on("close", () => {
            sockets.delete(socket);
            logging(`Socket disconnected: ${socket.remoteAddress}:${socket.remotePort}`)
        })

        socket.setTimeout(10000, async () => {
            logging(`Socket timeout ${socket.remoteAddress}:${socket.remotePort} `)
            const data = sockets.get(socket);
            if (data) {
                const sameInstance = await checkUserInstance(data.userID, data.instanceID);
                if (sameInstance) {
                    await redisClient.del(`bymr:user:${data.userID}`)
                }
            }
            sockets.delete(socket)
        })
    })
}

const checkUserInstance = async (id: string, instanceID: string): Promise<boolean> => {
    const uid = await getUserIDCache(id);
    if (uid) {
        if (uid === id || uid === instanceID) {
            return true;
        }
    }
    return false;
}
import * as net from "net";
import { logging } from "../utils/logger";
import { Socket } from "node:net";
import { OPCODE } from "./opcode";
import { socketSaveBase } from "../controllers/baseSave";
import { socketUpdateSaved } from "../controllers/updateSaved";


const policyFile = '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>';


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

        const user: SocketData = { userID: "", instanceID: "" }
        sockets.set(socket, user);
        let requestData = '';

        const sendData = (opcode: OPCODE, data) => {
            const jsonData = JSON.stringify(data);
            const opcodeBuffer = Buffer.alloc(2);
            opcodeBuffer.writeUInt16BE(opcode);
            const dataBuffer = Buffer.from(jsonData, 'utf8');
            const dataLengthBuffer = Buffer.alloc(4);
            dataLengthBuffer.writeUInt32BE(dataBuffer.length)
            const sendDataBuffer = Buffer.concat([opcodeBuffer, dataLengthBuffer, dataBuffer]);
            socket.write(sendDataBuffer);
            if (![OPCODE.PING].includes(opcode)) {
                logging(`Data sent opcode=${opcode}; data-length=${dataBuffer.length}`)
            }
        }

        const userExists = (userid: string): boolean => {
            for (const [sock, data] of sockets.entries()) {
                if (data.userID === userid && sock !== socket) {
                    return true;
                }
            }
            return false;
        }

        socket.on("data", async (message: Buffer) => {
            requestData += message.toString();
            if (requestData.includes('<policy-file-request/>\0')) {
                socket.write(policyFile);
                socket.end()
                return;
            }

            const HEADER = 6;
            if (message.length < HEADER) {
                return;
            }

            const opcode = message.readUInt16BE(0);
            if (!(opcode in OPCODE)) {
                socket.end();
                return
            }

            const length = message.readUInt32BE(2);
            const jsonData = message.slice(HEADER, length + HEADER).toString('utf8');

            // // // Parse the JSON payload into an object
            const parsedData = tryParse(jsonData);

            if (![OPCODE.PING].includes(opcode)) {
                logging(`Message receive opcode=${opcode}; data-length=${length}x`)
            }

            try {
                switch (opcode) {
                    case OPCODE.PING: {
                        sendData(OPCODE.PING, {})
                        break;
                    }
                    case OPCODE.LOGIN: {
                        const exists = userExists(parsedData._userid);
                        if (exists) {
                            sendData(OPCODE.LOGIN, { "__error": "Instance already exists" })
                            socket.end();
                            return;
                        }

                        user.userID = parsedData._userid;
                        user.instanceID = parsedData._instanceid;
                        sockets.set(socket, user);
                        break;
                    }
                    case OPCODE.GET_NEW_MAP: {
                        logging("Getting new map")
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
                            newmap: true,
                            mapheaderurl: "http://localhost:3001/api/bm/getnewmap",
                            width: 500,
                            height: 500,
                            // data: cells
                        };
                        sendData(OPCODE.GET_NEW_MAP, response)
                        break;
                    }
                    case OPCODE.BASE_SAVE: {
                        console.log("saving base: ", user.userID, parsedData.resources)
                        const data = await socketSaveBase(user.userID, parsedData)
                        sendData(OPCODE.BASE_SAVE, data)
                        break;
                    }
                    case OPCODE.UPDATE_SAVE: {
                        const data = await socketUpdateSaved(user.userID, parsedData)
                        sendData(OPCODE.UPDATE_SAVE, data)
                        break;
                    }
                }
            } catch (e) {
                sendData(opcode, { "__error": true })
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
            sockets.delete(socket)
        })
    })
}

const tryParse = (data: string) => {
    try {
        return JSON.parse(data);
    } catch (e) {
        return null;
    }
}
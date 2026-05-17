import type { TCPSocketListenOptions } from "bun";
import { logger } from "../utils/logger.js";
import { initGateway, handleOpen, handleMessage, handleClose, type SocketData } from "./ChatGateway.js";

const POLICY = Buffer.from(
  '<cross-domain-policy>' +
  '<allow-access-from domain="*" to-ports="3002" secure="false"/>' +
  '</cross-domain-policy>\0'
);

const POLICY_REQUEST = "<policy-file-request/>";

const DEFAULT_SOCKET_DATA = { userId: null, displayName: "", channel: null, lastMsgAt: 0 };

/**
 * Flash Player requires a socket policy before allowing raw socket connections.
 * It probes port 843 first, sending "<policy-file-request/>" and expecting the
 * policy XML back. Without this, any SWF not in the local-trusted sandbox is blocked.
 */
const startPolicyServer = () => {
  const HOSTNAME = "0.0.0.0";
  const PORT = 843;

  try {
    const options: TCPSocketListenOptions<null> = {
      hostname: HOSTNAME,
      port: PORT,
      socket: {
        data: (socket, data) => {
          if (!data.toString().includes(POLICY_REQUEST)) return;
          socket.write(POLICY);
          socket.end();
        },
        error: (_, err) => logger.warn(`Socket policy server error: ${err.message}`),
      },
    };

    Bun.listen(options);
    logger.info(`Flash socket policy server listening on port ${PORT}`);
  } catch (err) {
    logger.warn(`Could not start socket policy server on port ${PORT}: ${err}`);
  }
};

/**
 * Initialises the chat subsystem: Redis pub/sub gateway, Flash socket policy server, 
 * and WebSocket server.
 */
export const startChatServer = () => {
  const PORT = Number(process.env.CHAT_WS_PORT);

  initGateway();
  startPolicyServer();

  const options = {
    port: PORT,
    fetch: (req: Request, server: Bun.Server<SocketData>) => {
      if (server.upgrade(req, { data: DEFAULT_SOCKET_DATA })) return undefined;
      return new Response("WebSocket only", { status: 426 });
    },
    websocket: {
      open: handleOpen,
      message: handleMessage,
      close: handleClose,
      idleTimeout: 120,
    },
  };

  Bun.serve<SocketData>(options);

  logger.info(`Chat WebSocket server listening on port ${PORT}`);
};

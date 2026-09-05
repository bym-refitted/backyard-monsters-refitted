import { allianceChannelKey } from "./chatChannels.js";
import { ServerMessageType, type HistoryEntry, type ServerMessage } from "./chatProtocol.js";
import { publishToChannel } from "./chatTransport.js";

/**
 * Delivers a shout to everyone currently in an alliance's channel.
 *
 * Shouts are raised on the API side when membership changes, but the channel
 * roster lives with the gateway. Publishing the finished message straight to the
 * alliance channel means the gateway fans it out through the subscription it
 * already holds - it does not care which side published.
 *
 * @param {number} allianceId - The alliance whose channel should receive it.
 * @param {HistoryEntry} entry - The shout, with its text already composed.
 */
export const publishAllianceShout = (allianceId: number, entry: HistoryEntry) => {
  const channel = allianceChannelKey(allianceId);

  const message: ServerMessage = {
    type: ServerMessageType.Message,
    channel,
    messageType: entry.messageType,
    userId: entry.userId,
    displayName: entry.displayName,
    picSquare: entry.picSquare,
    allianceImage: entry.allianceImage,
    body: entry.body,
    ts: entry.ts,
  };

  publishToChannel(channel, JSON.stringify(message));
};

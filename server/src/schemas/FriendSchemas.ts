import z from "zod";

import { PLAYER_SEARCH_MIN_LENGTH } from "../config/FriendConfig.js";

/**
 * Schema for the launcher's player search box. The length floor keeps a one or
 * two letter search from paging through the whole player base.
 */
export const SearchPlayersSchema = z.object({
  search: z.string().trim().min(PLAYER_SEARCH_MIN_LENGTH).max(30),
});

/**
 * Schema for sending a friend request, and for removing a friend or cancelling
 * a request - both name the other player.
 */
export const FriendTargetSchema = z.object({
  userid: z.coerce.number().int().positive(),
});

/**
 * Schema for accepting or declining an incoming friend request.
 */
export const RespondFriendRequestSchema = z.object({
  request_id: z.coerce.number().int().positive(),
  accept: z.boolean(),
});

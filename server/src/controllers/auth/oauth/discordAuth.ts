import { Context } from "koa";
import { BASE_URL, PORT } from "../../../server.js";
import { z } from "zod";
import { authFailureErr } from "../../../errors/errorCodes..js";
import { errorLog } from "../../../utils/logger.js";

const UserQuerySchema = z.object({
  code: z.string(),
});

interface OAuthToken {
  access_token: string;
  refresh_token: string;
  errors?: {};
}

const oAuth2Url = "https://discord.com/api/v10/oauth2/token";
const discordUserUrl = "https://discord.com/api/v10/users/@me";

export const discordAuth = async (ctx: Context) => {
  try {
    const { code } = UserQuerySchema.parse(ctx.request.query);
    if (!code) throw authFailureErr;

    const accessToken = await getAccessToken(code);
    const currentUser = await getCurrentUser(accessToken);

    ctx.body = currentUser;
  } catch (err) {
    errorLog(`Failed to process Discord OAuth2 request: ${err.message}`);
    throw authFailureErr;
  }
};

const getAccessToken = async (code: string): Promise<string> => {
  const queryParams = new URLSearchParams({
    client_id: process.env.DISCORD_CLIENT_ID,
    client_secret: process.env.DISCORD_SECRET,
    grant_type: "authorization_code",
    code,
    redirect_uri: `${BASE_URL}:${PORT}/api/auth/discord/redirect`,
  });

  const response = await fetch(oAuth2Url, {
    method: "POST",
    body: queryParams.toString(),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
  });

  const responseData: OAuthToken = await response.json();
  if (!response.ok || responseData.errors) {
    errorLog("Error returned while fetching access token");
    throw authFailureErr;
  }

  return responseData.access_token;
};

const getCurrentUser = async (accessToken: string): Promise<any> => {
  const response = await fetch(discordUserUrl, {
    method: "GET",
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  if (!response.ok) throw authFailureErr;

  return response.json();
};

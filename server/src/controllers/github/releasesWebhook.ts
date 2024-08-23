import { Env } from "../../enums/Env";
import { KoaController } from "../../utils/KoaController";
import { getLatestSwfFromGithub } from "../../utils/getLatestSwfFromGithub";
import { createHmac } from "crypto";
import { setApiVersion } from "../../server";
import { Status } from "../../enums/StatusCodes";

interface ReleasePayload {
  release: {
    tag_name: string;
  };
}

/** Webhook event which authenticates & subscribes to GitHub Releases  
 * + downloads the latest version of client files
 * + updates the global API version based on the file version
*/
export const releasesWebhook: KoaController = async (ctx) => {
  const payload = ctx.request.body as ReleasePayload;

  if (process.env.ENV !== Env.LOCAL) {
    const receivedSig = ctx.request.headers["x-hub-signature"];
    const computedSig =
      "sha1=" +
      createHmac("sha1", process.env.GITHUB_WEBHOOK_SECRET)
        .update(JSON.stringify(payload))
        .digest("hex");

    if (receivedSig !== computedSig) {
      ctx.status = Status.UNAUTHORIZED;
      ctx.body = { error: "Mismatched signatures" };
      return;
    }
  }
  if (ctx.request.headers["x-github-event"] === "release") {
    // Handle the release event
    console.log(`New release published: ${payload.release.tag_name}`);
    setApiVersion(await getLatestSwfFromGithub());
  }

  ctx.status = Status.OK;
};

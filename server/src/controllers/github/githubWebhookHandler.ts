import { KoaController } from "../../utils/KoaController";
import { getLatestSwfFromGithub } from "../../utils/github";
import { createHmac } from "crypto";

export const githubWebhookHandler: KoaController = async (ctx) => {
  const payload = ctx.request.body as any;
  if (process.env.ENV !== "local") {
    const receivedSig = ctx.request.headers["x-hub-signature"];
    const computedSig =
      "sha1=" +
      createHmac("sha1", process.env.GITHUB_WEBHOOK_SECRET)
        .update(JSON.stringify(payload))
        .digest("hex");

    if (receivedSig !== computedSig) {
      ctx.status = 401;
      ctx.body = { error: "Mismatched signatures" };
      return;
    }
  }
  // Check if the event is a release
  if (ctx.request.headers["x-github-event"] === "release") {
    // Handle the release event
    console.log(`New release published: ${payload.release.tag_name}`);
    ctx.globalApiVersion = await getLatestSwfFromGithub();
  }

  ctx.status = 200;
};

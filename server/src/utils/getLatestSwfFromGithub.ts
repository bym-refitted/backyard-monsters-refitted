import { Octokit } from "octokit";
import { errorLog, logging } from "./logger";
import fs from "fs";

interface LaunchMetadata {
  currentGameVersion: string;
  currentLauncherVersion: string;
  builds: Record<string, string>;
  flashRuntimes: Record<string, string>;
}

export const getLatestSwfFromGithub = async (): Promise<string> => {
  const octokit = new Octokit({ auth: process.env.GITHUB_AUTH_TOKEN });

  const { data: releases } = await octokit.request(
    "GET /repos/{owner}/{repo}/releases",
    {
      owner: "bym-refitted",
      repo: "backyard-monsters-refitted",
      headers: {
        "X-GitHub-Api-Version": "2022-11-28",
      },
    }
  );

  const latestRelease = releases[0].assets.find(
    (asset) => asset && asset.name.startsWith("bymr-stable")
  );

  if (!latestRelease) errorLog("No latest release found."); // TODO: handle this better

  const releaseName = latestRelease.name;
  const releaseVersion = releaseName.match(/bymr-stable-(.*).swf/)[1];

  // Create a folder to store the api versioning files if not exists
  const folderPath = process.env.API_VERSIONING_FOLDER_PATH || "../api-versioning";
  
  if (!fs.existsSync(folderPath)) fs.mkdirSync(folderPath, { recursive: true });

  // Check launch.json version, if not changed leave it as is
  const launchMetadataFile = `${folderPath}/launch.json`;

  if (fs.existsSync(launchMetadataFile)) {
    const currentLaunchMetadata = JSON.parse(
      fs.readFileSync(launchMetadataFile, "utf-8")
    );

    if (releaseVersion === currentLaunchMetadata.currentGameVersion)
      return releaseVersion;
  }

  // Donwload the latest SWF Release
  const assetData = await octokit.request(latestRelease.url, {
    headers: {
      accept: "application/octet-stream",
    },
  });

  const writer = fs.createWriteStream(`${folderPath}/${releaseName}`);
  writer.write(Buffer.from(assetData.data));
  writer.end();
  logging("Downloaded the latest release.");

  // Update the launch.json file
  const launchJsonContents: LaunchMetadata = {
    currentGameVersion: releaseVersion,
    currentLauncherVersion: "0.1.0",
    builds: {
      stable: `bymr-stable-${releaseVersion}.swf`,
      http: `bymr-http-stable-${releaseVersion}.swf`,
      local: `bymr-local-stable-${releaseVersion}.swf`,
    },
    flashRuntimes: {
      windows: "flashPlayer.exe",
      darwin: "flashplayer32.dmg",
      linux: "flashPlayer",
    },
  };

  // Write contents to launch.json
  fs.writeFileSync(
    launchMetadataFile,
    JSON.stringify(launchJsonContents, null, 2)
  );

  return releaseVersion;
};

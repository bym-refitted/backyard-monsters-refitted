import { Octokit } from "octokit";
import fs from "fs";

export const getLatestSwfFromGithub = async () => {
  const octokit = new Octokit({
    auth: process.env.GITHUB_AUTH_TOKEN,
  });

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

  const latestRelease = releases[0];
  const asset = latestRelease.assets.find(
    (asset) => asset && asset.name.startsWith("bymr-stable")
  );
  if (!asset) console.error("No asset found for the latest release"); // TODO: handle this better
  const newFileName = asset.name;
  console.log(`ASSET ${JSON.stringify(asset)}`);
  const newVersionTag = newFileName.match(/bymr-stable-(.*).swf/)[1];

  // Create a folder to store the api versioning files if not exists
  const folderPath =
    process.env.API_VERSIONING_FOLDER_PATH || "../api-versioning";
  if (!fs.existsSync(folderPath)) {
    fs.mkdirSync(folderPath, { recursive: true });
  }

  // Check launch.json version, if not changed leave it as is
  const launchMetadataFile = `${folderPath}/launch.json`;
  if (fs.existsSync(launchMetadataFile)) {
    const currentLaunchMetadata = JSON.parse(
      fs.readFileSync(launchMetadataFile, "utf-8")
    );
    if (newVersionTag === currentLaunchMetadata.currentGameVersion) {
      return newVersionTag;
    }
  }

  // Donwload the latest release
  const assetData = await octokit.request(asset.url, {
    headers: {
      accept: "application/octet-stream",
    },
  });

  const writer = fs.createWriteStream(`${folderPath}/${newFileName}`);
  writer.write(Buffer.from(assetData.data));
  writer.end();
  console.log("Downloaded the latest release");

  // Process the swf name, get the version -> this should be stored in some global place
  // Update the launch.json file
  const launchJsonContents = {
    currentGameVersion: newVersionTag,
    currentLauncherVersion: "0.1.0",
    builds: {
      stable: `bymr-stable-${newVersionTag}.swf`,
      http: `bymr-http-stable-${newVersionTag}.swf`,
      local: `bymr-local-stable-${newVersionTag}.swf`,
    },
    flashRuntimes: {
      windows: "flashPlayer_windows.exe",
      darwin: "flashplayer32.dmg",
      linux: "linuxflashurlnotyetavailable",
    },
  };
  fs.writeFileSync(
    launchMetadataFile,
    JSON.stringify(launchJsonContents, null, 2)
  );
  // prepend the routes
  return newVersionTag;
};

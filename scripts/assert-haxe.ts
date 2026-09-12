import { $ } from "bun";

/**
 * This script checks if Haxe is installed and if the version is 4 or higher. 
 * If not, it prints an error message and exits the process.
 */

const result = await $`haxe --version`
    .quiet()
    .catch(() => null);

if (result === null) {
    console.error("Error: Haxe is not installed or not found in PATH. Please install Haxe and try again.");
    console.error("Download Haxe 4.x from https://haxe.org/download/ and make sure it's added to your PATH. Then try again.");
    process.exit(1);
}

const version = (await result.text()).trim();

const versionSplit = version.split(".");

if (versionSplit.length < 2) {
    console.error(`Error: Unexpected Haxe version format "${version}". Expected format "major.minor.patch". Please check your Haxe installation.`);
    process.exit(1);
}

const majorVersion = parseInt(versionSplit[0]!, 10);

if (isNaN(majorVersion) || majorVersion < 4) {
    console.error(`Error: Haxe version 4 or higher is required. Found version ${version}. Please update Haxe and try again.`);
    console.error("Download Haxe 4.x from https://haxe.org/download/ and make sure it's added to your PATH. Then try again.");
    process.exit(1);
}

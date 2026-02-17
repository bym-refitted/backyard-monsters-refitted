import { $ } from "bun";

if (await $`openfl --version`.quiet().catch(() => null) === null) {
    console.error("Error: OpenFL is not installed or not found in PATH. Please install OpenFL and try again.");
    console.error("Install OpenFL by running `haxelib install openfl` and make sure it's added to your PATH. Then try again.");
    process.exit(1);
}
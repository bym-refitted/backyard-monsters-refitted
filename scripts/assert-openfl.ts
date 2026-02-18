import { $ } from "bun";

if (await $`openfl --version`.quiet().catch(() => null) === null) {
    console.error("Error: OpenFL is not installed or not found in PATH. Please install OpenFL and try again.");
    console.error("Refer to HAXE.md on how to install Lime.");
    process.exit(1);
}
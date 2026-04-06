import { $ } from "bun";

if (await $`lime`.quiet().catch(() => null) === null) {
    console.error("Error: Lime is not installed or not found in PATH. Please install Lime and try again.");
    console.error("Refer to HAXE.md on how to install Lime.");
    process.exit(1);
}
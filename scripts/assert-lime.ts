import { $ } from "bun";

if (await $`lime`.quiet().catch(() => null) === null) {
    console.error("Error: Lime is not installed or not found in PATH. Please install Lime and try again.");
    console.error("Install Lime by running `haxelib install lime` and make sure it's added to your PATH. Then try again.");
    process.exit(1);
}
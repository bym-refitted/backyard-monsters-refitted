import path from "path";

const nameOfSwf = "client-hx";

const haxeProjectDir = "client-hx";

const haxeBuildDir = path.join(haxeProjectDir, "Export", "flash");

const buildfileDir = path.join(haxeBuildDir, "haxe");

const filesToPatch = [
    "debug.hxml",
    "final.hxml",
    "release.hxml"
];

if (! (await Bun.file(haxeProjectDir).stat()).isDirectory()) {
    console.error(`Error: Haxe project directory "${haxeProjectDir}" does not exist. Run this script from the root of the repository.`);
    process.exit(1);
}

console.log(`Patching Haxe build files to produce a .swc instead of a .swf...`);
console.log(`Haxe project directory: ${haxeProjectDir}`);

for (const file of filesToPatch) {
    const filePath = path.join(buildfileDir, file);

    if (! (await Bun.file(filePath).stat()).isFile()) {
        console.error(`Error: Build file "${filePath}" does not exist. Make sure the Haxe project has been built at least once.`);
        process.exit(1);
    }

    let content = await Bun.file(filePath).text();
    content = content.replace(`${nameOfSwf}\.swf`, `${nameOfSwf}\.swc`);
    await Bun.write(filePath, content);
    console.log(`Patched ${filePath}`);
}
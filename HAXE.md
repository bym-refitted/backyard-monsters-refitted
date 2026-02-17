# Haxe Client Library

This repository includes a small Haxe project in client-hx as part of the gradual AS3 to Haxe migration.
It builds into a SWC and is linked from the AS3 client during the transition.

## Dependencies

Required tools:

- Haxe 4.x (with haxelib)
- Lime (haxelib: lime)
- OpenFL (haxelib: openfl)
- Bun (used to run the build scripts in package.json)

If you have Haxe installed, install the Haxe libraries with:

```bash
haxelib install lime
haxelib install openfl
```

Make sure that both Lime and OpenFL are inside your PATH (the haxelib installer should ask for your password to do this for you).

## Build

From the repo root, run one of the build scripts:

```bash
bun run haxelib:build:debug
bun run haxelib:build:release
bun run haxelib:build:final
```

The build pipeline:

1. `haxelib:compile` runs `lime build flash` in client-hx.
2. `haxelib:patch` rewrites the generated HXML files to output a SWC instead of a SWF.
3. `haxelib:swc:*` runs Haxe on the patched HXML.
4. `haxelib:copy` copies the SWC to bin/client-hx.swc.

## Why This Exists

The Haxe client library is part of a gradual migration from ActionScript 3 to Haxe. We move code one piece at a time into Haxe, compile it as a SWC, and then include that SWC from the AS3 client. This lets the AS3 code call migrated Haxe code while the rest of the client remains in AS3.

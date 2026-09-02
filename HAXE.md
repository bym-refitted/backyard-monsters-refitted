# Haxe Client Library

This repository includes a Haxe project in client-hx as part of the gradual AS3 to Haxe migration.
It builds into a SWC (Flash Library) and is linked from the AS3 client during the transition.

As the AS3 client depends on this library, it must be compiled **before** the AS3 client.

## Dependencies

Required tools:

- Haxe 4.x (with haxelib)
- Lime (haxelib: lime)
- OpenFL (haxelib: openfl)
- Bun (used to run the build scripts in package.json)

If you have Haxe installed, install the Haxe libraries with:

```bash
haxelib install lime

haxelib run lime setup

haxelib install openfl

haxelib run openfl setup
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

## Formatter

Haxe has a formatter configuration that lives inside `client-hx/hxformat.json`. A specification for it can be found [here](https://github.com/vshaxe/vshaxe/wiki/Formatting).

Currently, the formatter is configured to indent without tabs and with 3 spaces, as this matches the formatting of the current AS3-codebase.

While 3 spaces are arguably unconventional, it is preferred to remain consistent with the original AS3 codebase, especially when copy-pasting code during migration.

The Haxe extension for VSCode already uses the configuration of `hxformat.json` for formatting, but we also provide convenience scripts to format the codebase manually:

Execute `bun run haxelib:format:setup` once to install the `formatter` library using haxelib.
Then execute `bun run haxelib:format` from the project root to format the codebase.

## Why This Exists

The Haxe client library is part of a gradual migration from ActionScript 3 to Haxe. We move code one piece at a time into Haxe, compile it as a SWC, and then include that SWC from the AS3 client. This lets the AS3 code call migrated Haxe code while the rest of the client remains in AS3.

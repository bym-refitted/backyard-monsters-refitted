/**
 * Side-effect module: neutralise PORT before src/server.ts enters the graph.
 *
 * verify-battle-report.ts imports this FIRST. A bare `process.env.PORT = "0"`
 * statement in that script would not work: ES module `import` declarations are
 * hoisted and their modules fully evaluated before any sibling top-level
 * statement runs, so `import { postgres } from "../src/server.js"` — and its
 * `app.listen(PORT)` IIFE — would fire while PORT is still "3001" (from .env),
 * colliding with a running dev server. Doing it in a dependency-free module that
 * is imported before server.js guarantees it runs first.
 */
process.env.PORT = "0";

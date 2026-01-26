/**
 * PM2 Ecosystem Configuration
 *
 * Manages the BYMR server process with Bun runtime.
 * Uses .mjs extension to ensure PM2 treats this as an ESM module.
 *
 * Start: pm2 start ecosystem.config.mjs
 *
 * @see https://pm2.keymetrics.io/docs/usage/application-declaration/
 */
export const apps = [
  {
    name: "bymr-server",
    script: "server-wrapper.js",
    interpreter: "bun",
    interpreter_args: "--bun",
    env: {
      NODE_ENV: "production",
      PATH: `${process.env.HOME}/.bun/bin:${process.env.PATH}`,
    },
  },
];

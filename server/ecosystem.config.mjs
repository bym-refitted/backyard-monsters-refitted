/**
 * PM2 Ecosystem Configuration
 *
 * Manages the BYMR server process with Bun runtime.
 * Uses .mjs extension to ensure PM2 treats this as an ESM module.
 *
 * Restarts back off exponentially (100ms, growing to at most 15s) so a crash while
 * PostgreSQL or Redis is briefly down never exhausts PM2's restart limit.
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
    exp_backoff_restart_delay: 100,
    env: {
      NODE_ENV: "production",
      PATH: `${process.env.HOME}/.bun/bin:${process.env.PATH}`,
    },
  },
];

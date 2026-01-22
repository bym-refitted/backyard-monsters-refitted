module.exports = {
  apps: [
    {
      name: "bymr-server",
      script: "./dist/server.js",
      exec_mode: "fork",
      interpreter: "bun",
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};

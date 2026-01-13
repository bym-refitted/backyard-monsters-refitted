module.exports = {
  apps: [
    {
      name: "bymr-server",
      script: "./dist/server.js",
      exec_mode: "fork",
      node_args: "--env-file=.env",
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};

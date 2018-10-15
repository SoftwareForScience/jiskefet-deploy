module.exports = {
  apps : [{
    name: 'API',
    cwd: '/var/lib/jiskefet/jiskefet-api',
    script: 'npm',

    // Options reference: https://pm2.io/doc/en/runtime/reference/ecosystem-file/
    args: 'run start',
    instances: 'max',
    exec_mode: 'cluster',
    autorestart: true,
    watch: false,
  }],
};

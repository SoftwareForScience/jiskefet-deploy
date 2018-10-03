module.exports = {
    apps: [{
        name: 'API',
        script: 'run start',

        // Options reference: https://pm2.io/doc/en/runtime/reference/ecosystem-file/
        instances: max,
        exec_mode: 'cluster',
        autorestart: true,
        watch: false,
        max_memory_restart: '1G',
        env: {
            NODE_ENV: 'development'
        },
        env_production: {
            NODE_ENV: 'production'
        }
    }],
};

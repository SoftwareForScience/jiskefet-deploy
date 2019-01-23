# Process management

- [Process management](#process-management)
  - [PM2 quick start](#pm2-quick-start)
  - [PM2 additional information](#pm2-additional-information)

[Back to table of contents](../README.md#table-of-contents)

If the ansible-playbook has been deployed successfully, then the Node.js processes will be managed by [PM2 (Process Manager 2)](https://pm2.keymetrics.io). PM2 has been chosen because of the following features:
-  Monitoring
-  Log management
-  Hot reloading
-  Cluster mode

PM2 will run under user `jiskefet-api` with the json file below.
```json
{
    "apps": [
        {   
            "name": "API",
            "cwd": "/var/lib/jiskefet/jiskefet-api",
            "script": "npm",
            "args": "run start",
            "instances": "max",
            "exec_mode": "cluster",
            "autorestart": true,
            "watch": false,
            "env": {
                "NODE_ENV": "dev"
            },
            "env_dev": {
                "NODE_ENV": "dev"
            },
            "env_staging": {
                "NODE_ENV": "staging"
            },
            "env_production": {
                "NODE_ENV": "prod"
            }
        }
    ]
}
```

## PM2 quick start
1. Go to the directory `/var/lib/jiskefet`.
2. Check if `ecosystem.json` exists in the directory.
3. Run `pm2 start ecosystem.json` in your terminal.
4. Run `pm2 list` to get an overview of the processes or `pm2 monit` to use the monitoring functionality.

## PM2 additional information
-  If your `ecosystem.json` has been updated, please run `pm2 reload ecosystem.json --update-env` to get the new changes.
-  If the API has been updated, you need to run the following in order to get the latest API running:
   1.  `pm2 kill` to stop all the current pm2 processes.
   2.  `pm2 start ecosystem.json` to start pm2 again

[Back to table of contents](../README.md#table-of-contents)

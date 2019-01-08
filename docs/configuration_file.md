# 1. Configuration file
[Back to table of contents](../README.md#table-of-contents)

To configure the ansible scripts the file `ansible.config.json` needs to be created in the root of the ansible directory.
A template to this file has already been created called `ansible.config.json.template`. In this configuration file a few changed need to be made:

## Deploy from .tar
The `use_local_repository` variable determines for ansible which repositories to deploy. By filling in “yes”, ansible will deploy the supplied *.tar files. By filling in `“no”`, ansible will clone the projects from the urls:

```json
"use_local_repository": "yes",
```

Be sure to have the `*.tar` files in the root of `jiskefet-project-v**`*  folder if local repositories are to be used. The hierarchy should be:
```
jiskefet-project-v**/
|
|–- sfs-ansible/
|–- jiskefet-api.tar
|–- jiskefet-ui.tar
```

\* i.e. `jiskefet-project-v1.0`

## Deploy from GitHub
Change the GitHub URLs to the repositories that need to be used. The URLs do not have to be changed if the `"use_local_repository"` variable is set to `"yes"`:
```json
"remote_repository_url": {
  "jiskefet_api": "https://github.com/",
  "jiskefet_ui": "https://github.com/"
},
```

Specify which branch ansible should pull. The default branch is currently set to master.
```json
"repository_branch":{
    "jiskefet_api": "master",
    "jiskefet_ui": "master"
},
```

## Port

Change the api server's port number, the default is set to 3000.
```json
"PORT": 3000
```

## DB config

Change the variable `host` to the ip address of the database server, the `username` and `password` to set the 
credentials for the database and the `database` variable to a database name. In most cases the rest of the variables can stay as their defaults.
```json
"database_config": {
  "type": "mysql",
  "host": "localhost",
  "port": 3306,
  "username": "",
  "password": "",
  "database": "",
  "entities": [
     "src/**/**.entity{.ts,.js}"
   ],
  "synchronize": true
}
```

[Back to table of contents](../README.md#table-of-contents)
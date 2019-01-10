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

## USE_CERN_SSO flag
Specify whether the application should use the CERN SSO. If the value is set to `"false"`, the application will use Github's SSO.
```json
"USE_CERN_SSO": "false",
```

## Jiskefet API settings (all fields are required)
Change the variable `host` to the ip address of the database server, the `username` and `password` to set the 
credentials for the database and the `database` variable to a database name. In most cases the rest of the variables can stay as their defaults.
```json
"jiskefet_api_general_settings": {
        "USE_API_PREFIX": "false",
        "PORT": 3000,
        "TYPEORM_CONNECTION": "mysql",
        "TYPEORM_HOST": "",
        "TYPEORM_USERNAME": "",
        "TYPEORM_PASSWORD": "",
        "TYPEORM_DATABASE": "",
        "TYPEORM_PORT": 3306,
        "TYPEORM_SYNCHRONIZE": "true",
        "TYPEORM_LOGGING": "false",
        "TYPEORM_ENTITIES": "src/**/**.entity{.ts,.js}",
        "TYPEORM_MIGRATIONS": "src/migration/*{.ts,.js}",
        "TYPEORM_MIGRATIONS_DIR": "src/migration",
        "JWT_SECRET_KEY": "",
        "JWT_EXPIRE_TIME":"1h",
        "SUB_SYSTEM_TOKEN_EXPIRES_IN": "365 days",
        "USE_INFO_LOGGER": "false"
    },
```

## OAuth settings (all fields are required)
Fill in the OAuth client id, client secret and the redirect uri (this is the callback url).
```json
"jiskefet_oauth_settings": {
        "CLIENT_ID": "",
        "CLIENT_SECRET": "",
        "AUTH_REDIRECT_URI": ""
    },
```

## Mock/test database settings (optional)
These settings are optional, fill the settings in if you want to run `"npm run test"`. The test will then run against a test database.
```json
"jiskefet_api_optional_settings": {
        "TEST_DB_CONNECTION": "mysql",
        "TEST_DB_HOST": "localhost",
        "TEST_DB_USERNAME": "",
        "TEST_DB_PASSWORD": "",
        "TEST_DB_DATABASE": "jiskefet_test",
        "TEST_DB_PORT": "3306",
        "TEST_DB_SYNCHRONIZE": "true",
        "TEST_DB_LOGGING": "true",
        "TEST_DB_ENTITIES": "src/**/**.entity{.ts,.js}"
    },
```
## Jiskefet UI settings
Fill in the API endpoint for the front end to make request against.
```json
"jiskefet_ui_settings":{ 
        "API_URL": "http://localhost:3000/"
    },
```

[Back to table of contents](../README.md#table-of-contents)
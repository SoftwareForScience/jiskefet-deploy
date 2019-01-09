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

## CERN OAuth settings (all fields are required)
Fill in the settings only if `"USE_CERN_SSO"` flag is set to `"true"`.  
Please remember to replace the placeholder `"<CLIENT_ID_HERE>"` at the `"CERN_AUTH_URL"` with the `"CERN_CLIENT_ID"`.
```json
"jiskefet_api_cern_settings": {
        "CERN_AUTH_URL": "https://oauth.web.cern.ch/OAuth/Authorize?response_type=code&client_id=<CLIENT_ID_HERE>&redirect_uri=http://127.0.0.1:8080/callback",
        "CERN_CLIENT_ID": "",
        "CERN_CLIENT_SECRET": "",
        "CERN_AUTH_TOKEN_HOST": "https://oauth.web.cern.ch/",
        "CERN_AUTH_TOKEN_PATH": "oauth/token",
        "CERN_RESOURCE_API_URL": "https://oauthresource.web.cern.ch/api/user"
    },
```

## Github OAuth settings (all fields are required)
Fill in the settings only if `"USE_CERN_SSO"` flag is set to `"false"`.  
Please remember to replace the placeholder `"<CLIENT_ID_HERE>"` at the `"GITHUB_AUTH_URL"` with the `"GITHUB_CLIENT_ID"`.
```json
 "jiskefet_api_github_settings": {
        "GITHUB_AUTH_URL": "https://github.com/login/oauth/authorize?response_type=code&client_id=<CLIENT_ID_HERE>&redirect_uri=http://localhost:8080/callback&state=yx_4404.!dcbR%40YR44yQ",
        "GITHUB_CLIENT_ID": "",
        "GITHUB_CLIENT_SECRET": "",
        "GITHUB_AUTH_TOKEN_HOST": "https://github.com",
        "GITHUB_AUTH_TOKEN_PATH": "/login/oauth/access_token",
        "GITHUB_RESOURCE_API_URL": "https://api.github.com/user"
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
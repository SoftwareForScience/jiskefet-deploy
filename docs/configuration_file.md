# 1. Configuration file

- [1. Configuration file](#1-configuration-file)
  - [Deploy from .tar](#deploy-from-tar)
  - [Deploy from GitHub](#deploy-from-github)
  - [USE_CERN_SSO flag](#usecernsso-flag)
  - [Jiskefet API settings (all fields are required)](#jiskefet-api-settings-all-fields-are-required)
  - [OAuth settings (all fields are required)](#oauth-settings-all-fields-are-required)
  - [Jiskefet CERN OAuth setting](#jiskefet-cern-oauth-setting)
  - [Mock/test database settings (optional)](#mocktest-database-settings-optional)
  - [List of extra configuration fields](#list-of-extra-configuration-fields)


[Back to table of contents](../README.md#table-of-contents)

To configure the ansible scripts the file `ansible.config.yml` needs to be created in the root of the ansible directory.
A template to this file has already been created called `ansible.config.yml.template`. In this configuration file a few changed need to be made:

## Deploy from .tar
The `use_local_repository` variable determines for ansible which repositories to deploy. By filling in `'yes'`, ansible will deploy the supplied *.tar files. By filling in `'no'`, ansible will clone the projects from the urls:

```yaml
use_local_repository: 'no'
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
If `use_local_repository` is set to `'no'`, the project will be retrieved from GitHub. The default repository URL's are:
```yaml
jiskefet_api: 'https://github.com/SoftwareForScience/jiskefet-api.git'
jiskefet_ui: 'https://github.com/SoftwareForScience/jiskefet-ui.git'
```
If the repository URL's are different, please add the following to the `ansible.config.yml` file:
```yaml
remote_repository_url:
  jiskefet_api: 'FILL_IN_YOUR_REPOSITORY_URL_HERE'
  jiskefet_ui: 'FILL_IN_YOUR_REPOSITORY_URL_HERE'
```

The default branch it pulls is currently set to `'master'`. If you want to specify another branch, please add the following to the `ansible.config.yml` file:
```yaml
repository_branch:
  jiskefet_api: 'FILL_IN_YOUR_BRANCH_HERE'
  jiskefet_ui: 'FILL_IN_YOUR_BRANCH_HERE'
```

## USE_CERN_SSO flag
Specify whether the application should use the CERN SSO. If the value is set to `'false'`, the application will use Github's SSO. The `USE_CERN_SSO` flag is set to `'false'` by default, if you want to use CERN's SSO, please add the following to the `ansible.config.yml` file:
```yaml
USE_CERN_SSO: 'true'
```

## Jiskefet API settings (all fields are required)
Change the variable `host` to the ip address of the database server, the `username` and `password` to set the 
credentials for the database and the `database` variable to a database name. 
```yaml
  TYPEORM_HOST: 'FILL_IN_YOUR_HOST_HERE'
  TYPEORM_USERNAME: 'FILL_IN_YOUR_USERNAME_HERE'
  TYPEORM_PASSWORD: 'FILL_IN_YOUR_PASSWORD_HERE'
  TYPEORM_DATABASE: 'FILL_IN_YOUR_DATABASE_HERE'
```

## OAuth settings (all fields are required)
Fill in the OAuth client id, client secret and the redirect uri (this is the url should end with `'/callback'`).
```yaml
jiskefet_oauth_settings:
  CLIENT_ID: 'FILL_IN_YOUR_CLIENT_ID_HERE'
  CLIENT_SECRET: 'FILL_IN_YOUR_CLIENT_SECRET_HERE'
  AUTH_REDIRECT_URI: 'FILL_IN_YOUR_AUTH_REDIRECT_URI_HERE'
```

## Jiskefet CERN OAuth setting
Fill in the values only if the `'USE_CERN_SSO'` setting is set to `'true'`.
```yaml
jiskefet_cern_oauth_settings:
  CERN_REGISTERED_URI: 'FILL_IN_YOUR_CERN_REGISTERED_URI_HERE'
```

## Mock/test database settings (optional)
These settings are optional, fill the settings in if you want to run `'npm run test'`. The test will then run against a test database.
```yaml
jiskefet_api_optional_settings:
  TEST_DB_HOST: FILL_IN_YOUR_HOST_HERE'
  TEST_DB_USERNAME: 'FILL_IN_YOUR_USERNAME_HERE'
  TEST_DB_PASSWORD: 'FILL_IN_YOUR_PASSWORD_HERE'
  TEST_DB_DATABASE: 'FILL_IN_YOUR_DATABASE_HERE'
```
## List of extra configuration fields
A list of extra configuration fields is provided in order to overwrite the default fields.

Name | Explanation | possible values/ examples 
---- | ---- | ---- 
remote_repository_url | object that contains the two repository URL's 
 ∟ jiskefet_api | git URL for the jiskefet API repository 
 ∟ jiskefet_ui | git URL for the jiskefet UI repository 
repository_branch | object that contains the branches that git should pull 
 ∟ jiskefet_api | a specific branch to pull for jiskefet_api project | e.g. `'develop'` 
 ∟ jiskefet_ui | a specific branch to pull for the jiskefet_ui project |  e.g. `'develop'` 
jiskefet_api_general_settings | object that contains all the general settings 
 ∟ USE_API_BASE_PATH | adds `'/api'` to the API url, default is set to `'true'` | `'true'` or `'false'` 
 ∟ PORT | set port number of the jiskefet API project, default port is `'3000'` | number between 1 - 65535 
 ∟ TYPEORM_CONNECTION | set the connection type of TYPEORM, currently only `'mysql'` is supported | please see the [official docs](https://github.com/typeorm/typeorm/blob/master/docs/connection-options.md#what-is-connectionoptions) 
 ∟ TYPEORM_PORT | set the database port, default is set to `'3306'` | number between 1 - 65535 
 ∟ TYPEORM_SYNCHRONIZE | set if the database should synchronize with the models in the `'src/entities'` folder | `'true'` or `'false'` 
 ∟ TYPEORM_LOGGING | enables logging of all queries and errors, default is set to `'false'` | `'true'` or `'false'` 
 ∟ JWT_EXPIRE_TIME | sets the expire time of the user's session, default is set to `'1h'` | e.g. `'8h'` 
 ∟ SUB_SYSTEM_TOKEN_EXPIRES_IN | sets the expire time of the subsystem tokens, default is set to `'365 days'` | e.g. `'30 days'` 
 ∟ USE_INFO_LOGGER | specify whether the application should use InfoLogger, default is set to `'false'` | `'true'` or `'false'` 
jiskefet_api_optional_settings | object that contains the optional settings of the jiskefet API project 
 ∟ TEST_DB_CONNECTION | set the connection type of TYPEORM, currently only `'mysql'` is supported | please see the [official docs](https://github.com/typeorm/typeorm/blob/master/docs/connection-options.md#what-is-connectionoptions) 
 ∟ TEST_DB_PORT | set the database port, default is set to `'3306'` | number between 1 - 65535 
 ∟ TEST_DB_SYNCHRONIZE | set if the database should synchronize with the models in the `'src/entities'` folder | `'true'` or `'false'` 
 ∟ TEST_DB_LOGGING | enables logging of all queries and errors, default is set to `'false'` | `'true'` or `'false'`
 
 [Back to table of contents](../README.md#table-of-contents)

# 3. Running ansible

- [3. Running ansible](#3-running-ansible)
  - [How to deploy](#how-to-deploy)
  - [Ansible tags](#ansible-tags)
  
[Back to table of contents](../README.md#table-of-contents)

## How to deploy
To deploy the database and web application servers with ansible, open terminal and cd to the project dir:
```
$ cd PATH/TO/jiskefet-deploy
```

Executing the following command will deploy the web application and database.
```
$ ansible-playbook site.yml
```

## Ansible tags
This ansible playbook currently supports the following tags:  

Tag name | Description  
---- | ---   
git_pull | Pulls the latest version of UI and API based on the branch specified in the ansible.config.yml from git and deploys it to the servers. (this tag cannot complete without failure if the command `ansible-playbook site.yml` has not been executed)  
recreate_database | Drops and creates the database specified in the variable `jiskefet_api_general_settings.TYPEORM_DATABASE`. This task will only run when explicitly called.

To use these tags in ansible, execute the following command:
```zsh
$ ansible-playbook site.yml --tags git_pull
```


Make sure you are running the required version of Ansible, ansible-playbook and python ([see requirements](./system_requirements.md))

[Back to table of contents](../README.md#table-of-contents)

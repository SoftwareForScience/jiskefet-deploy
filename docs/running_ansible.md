# 4. Running ansible
[Back to table of contents](../README.md#table-of-contents)

To deploy the database and web application servers with ansible, open terminal and cd to the project dir:
```
$ cd PATH/TO/sfs-ansible
```

Executing the following command will deploy the web application and database.
```
$ ansible-playbook site.yml
```

Make sure you are running the required version of Ansible, ansible-playbook and python ([see requirements](system_requirements))

[Back to table of contents](../README.md#table-of-contents)

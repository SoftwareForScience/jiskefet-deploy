# Instructions
### 1. Configuration file
To configure the ansible scripts the file ansible.config.json needs to be created in the root of the ansible directory.
A template to this file has already been created called ansible.config.json.template. In this configuration file a few changed need to be made:

The **use_local_repository** variable determines for ansible which repositories to deploy. By filling in “yes”, ansible will deploy the supplied *.tar files. By filling in “no”, ansible will clone the projects from the urls:

```json
"use_local_repository": "yes",
```

Be sure to have the \*.tar files in the root of jiskefet-project-v\*\* folder if local repositories are to be used. The hierarchy should be:
```
jiskefet-project-v**/
|
|–- sfs-ansible/
|–- jiskefet-api.tar
|–- jiskefet-ui.tar
```

Change the github urls to the repositories that need to be used. The URL's do not have to be changed if the "use_local_repository" variable is set to "yes":
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

Set the deploy environment. The available values are:

1. dev 
2. staging 
3. prod 

```json
"deploy_environment": "dev",
```

Change the variable **host** to the ip address of the database server, the **username** and **password** to set the 
credentials for the database and the **database** variable to a database name (for example jiskefet):
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

Replace the **localhost** in this variable with the ip-address of the api machine:	
```json	
"api_url_constant": "'http://localhost/api/';"	
```	

### 2. Setting up ssh
To make a connection to the servers ssh needs to be configured on the machine by executing the following command:
```
$ ssh-keygen  -f jiskefet
Press ENTER twice to set it as default without a passphrase.
```
Navigate to the .ssh folder:
```
cd ~/.ssh
```

After that, change the ssh config by executing the following command:
```
$ vi config
```
and adding the following lines into the document:
```
########## Jiskefet ##########

Host jiskefet-api
    HostName IP_ADDRESS_HERE
    User root
    Port 22
    IdentityFile ~/.ssh/jiskefet

Host jiskefet-db
    HostName IP_ADDRESS_HERE
    User root
    Port 22
    IdentityFile ~/.ssh/jiskefet
```
*Do NOT forget to change the ip addresses in the config file.*

Execute the following commands to copy the ssh keys to the servers:
```
$ ssh-copy-id -i jiskefet.pub jiskefet-api
$ ssh-copy-id -i jiskefet.pub jiskefet-db
```

To test the connections the following command can be executed:
```
$ ansible -m ping all
```

If everything went well the following output should show:
```
vm-jiskefet-db | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
vm-jiskefet-api | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

### 3. Running ansible
To deploy the database and web application servers with ansible open a command prompt and navigate to the ansible folder
by executing the next command (do not forget to change the path):
```
$ cd PATH/TO/sfs-ansible
```

Executing the following command will deploy the web application and database
```
$ ansible-playbook site.yml
```

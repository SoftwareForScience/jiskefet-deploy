# Instructions
### 1. Configuration file
To configure the ansible scripts the file ansible.config.json needs to be created in the root of the ansible directory.
A template to this file has already been created. In this configuration file a few changed need to be made:

Change the github urls to the repositories that need to be used (if needed):
```json
"git_urls": {
  "jiskefet_api": "https://github.com/",
  "jiskefet_ui": "https://github.com/"
},
```
*Changing these URL's is not mandatory if the repositories are are delivered with the ansible script as .tar files*

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
*Other variables are not to be changed.*

### 2. Setting up ssh
To make a connection to the servers ssh needs to be configured on the machine by executing the following command:
```
$ ssh-keygen  -f jiskefet
Press ENTER twice to set it as default without a passphrase.
```
After that change the ssh config by executing the following command:
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

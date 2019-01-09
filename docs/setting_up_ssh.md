# 2. Setting up ssh
[Back to table of contents](../README.md#table-of-contents)

To make a connection to the servers ssh needs to be configured on the machine by executing the following command:
```bash
$ ssh-keygen  -f jiskefet
# Press ENTER twice to set it as default without a passphrase.
```
Navigate to the .ssh folder:
```bash
cd ~/.ssh
```

After that, change the ssh config by executing the following command:
```bash
$ vi config
```
and adding the following lines into the document:
```bash
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
```bash
$ ssh-copy-id -i jiskefet.pub jiskefet-api
$ ssh-copy-id -i jiskefet.pub jiskefet-db
```

To test the connections the following command can be executed:
```bash
$ ansible -m ping all
```

If everything went well the following output should show:
```bash
vm-jiskefet-db | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
vm-jiskefet-api | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

[Back to table of contents](../README.md#table-of-contents)
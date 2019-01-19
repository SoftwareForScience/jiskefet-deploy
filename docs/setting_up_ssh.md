# 2. Setting up ssh
[Back to table of contents](../README.md#table-of-contents)  

This playbook currently supports two ways of connecting to the servers.
1. [Using ssh with a key file](#using-ssh-with-a-key-file)
2. [Using user and password](#using-ssh-with-user-and-password)

Please follow one of the two options presented above.

## Using ssh with a key file
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
jiskefet-db | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
jiskefet-api | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```
## Using ssh with user and password
There are several ways connecting to the servers defined in the `hosts` file.
### Using `hosts` file

```ini
[webservers]
jiskefet-api  ansible=your_user_here ansible_ssh_pass=your_password_here

[dbservers]
jiskefet-db   ansible=your_user_here ansible_ssh_pass=your_password_here
```

### Using `group_vars` folder
 The files in this folder will apply to the host groups that are defined in the `hosts` file.

The `hosts` file currently contains two groups:
* `[webservers]`
* `[dbservers]`

Each of the host groups has it's own file in the `groups_var` folder.

If all the host groups are using the same user and password, please update the file at `group_vars/all.yml`. This file will apply to all the hosts. If the user and or password is different between the host groups, please update the other files at `groups_vars/*.yml`
```yaml
# group_vars/*.yml
ansible_user: your_user_here
ansible_ssh_pass: your_password_here
```

### Using `host_vars` folder
If there are several web servers and database servers under the host groups, each using a different user and password to get into the machine,

If you want to have a granular control over all the servers that are in the `hosts` file, you can add `server_name.yml` file to the `host_vars` folder. In the `server_name.yml` file add the fields that you want to overwrite e.g.:
```yaml
# host_vars/server_name.yml
ansible_user: another_user_here
ansible_ssh_pass: another_password_here
```

[Back to table of contents](../README.md#table-of-contents)
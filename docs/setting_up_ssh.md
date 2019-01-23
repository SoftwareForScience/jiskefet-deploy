# 2. Setting up ssh

- [2. Setting up ssh](#2-setting-up-ssh)
  - [Using ssh with a key file](#using-ssh-with-a-key-file)
  - [Using ssh with user and password](#using-ssh-with-user-and-password)
    - [Using `group_vars` folder](#using-groupvars-folder)
    - [Using `host_vars` folder](#using-hostvars-folder)
    - [Using `hosts` file](#using-hosts-file)
  - [Encryption using ansible-vault](#encryption-using-ansible-vault)
    - [How to run playbook with encrypted vars.](#how-to-run-playbook-with-encrypted-vars)


[Back to table of contents](../README.md#table-of-contents)  

## Using ssh with a key file
To make a connection to the servers, ssh needs to be configured on the machine by executing the following command:
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
*Do NOT forget to change the IP addresses in the config file.*

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

### Using `group_vars` folder
 The files in this folder will apply to the host groups that are defined in the `hosts` file.

The `hosts` file currently contains two groups:
* `[webservers]`
* `[dbservers]`

Each of the host groups has it's own folder in the `groups_var` folder. The folder would look as follow:
```
group_vars
|----all
|     |-- vars.yml
|     |-- vault.yml
|
|----dbservers
|     |-- vars.yml
|     |-- vault.yml
|
|----webservers
      |-- vars.yml
      |-- vault.yml
```

If all the host groups are using the same variables, please update the file at `group_vars/all/vars.yml` and `group_vars/all/vault.yml`. This file will apply to all the hosts. If the variables are different between the host groups, please update the other files at `groups_vars/*/vars.yml` and `group_vars/*/vault.yml`.

### Using `host_vars` folder
If you want to have granular control over all the servers that are in the `hosts` file, you can add `server_name` folder to the `host_vars` folder. This folder follows the same principle as the `group_vars` section above.

This ansible-playbook has a built in step by step `host_vars` with `host` creation when running `ansible-playbook site.yml`.
```
host_vars
|----webserver1
|     |-- vars.yml
|     |-- vault.yml
|
|----webserver2
|     |-- vars.yml
|     |-- vault.yml
|
|----databaseserver1
|     |-- vars.yml
|     |-- vault.yml
|
|----databaseserver2
      |-- vars.yml
      |-- vault.yml
```

### Using `hosts` file
It is possible to set the ssh parameters in the host file as displayed below. The drawback is that the credentials will be exposed. If possible, please refrain from using this setup.

```ini
[webservers]
jiskefet-api  ansible=your_user_here ansible_ssh_pass=your_password_here

[dbservers]
jiskefet-db   ansible=your_user_here ansible_ssh_pass=your_password_here
```

## Encryption using ansible-vault
[A best practice approach](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#variables-and-vaults) is to define all the variables, including any sensitive ones in the `vars.yml`. The next is to copy all the sensitive variables such as passwords and other secrets over to the `vault.yml` and prefix the variables with `vault_`. Now all the variables in `vars.yml` that contains sensitive information needs to point to the matching `vault_`variable using jinja2 syntax. An example can be seen below.

```yaml
# group_vars/all/vars.yml
ansible_user: your_user_here
ansible_ssh_pass: "{{ vault_ansible_ssh_pass }}"
```

```yaml
# group_vars/all/vault.yml
vault_ansible_ssh_pass: your_password_here

```
The last step is to encrypt the `vault.yml` with the following command:
```zsh
$ ansible-vault encrypt path/group_vars/all/vault.yml
```
A prompt will ask you to set a new vault password to encrypt and decrypt the vault. For more information please go to the official documentation from Ansible [here](https://docs.ansible.com/ansible/latest/user_guide/vault.html).

To edit the encrypted files, please execute the following command:
```zsh
$ ansible-vault edit path/group_vars/all/vault.yml
```

To remove encryption from the vault files, execute the following command:
```zsh
$ ansible-vault decrypt path/group_vars/all/vault.yml
```

### How to run playbook with encrypted vars.
There are several options to run the playbook with variables encrypted by ansible-vault. The current implementation uses `ansible.cfg` to set the path to the vault password file.

```cfg
# If set configures the path to the Vault password file as an alternative to
# specifying --vault-password-file on the command line.
vault_password_file = /path/to/vault_pass
```
If you want ansible to prompt the user for input, pass the `--ask-vault-pass` flag to the console.
```zsh
$ ansible-playbook --ask-vault-pass site.yml
```
For other options please go to the official documentation from Ansible [here](https://docs.ansible.com/ansible/latest/user_guide/vault.html#providing-vault-passwords).


[Back to table of contents](../README.md#table-of-contents)
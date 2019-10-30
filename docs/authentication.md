Notes on authentication
===
The recommended way of setting up Ansible authentication is:

1. Passwordless SSH to target host
2. Privilege escalation (i.e. `su`) on target host

Passwordless SSH to target host
---
By default, Ansible needs to be able to SSH from the controlling host to all the target hosts without being prompted for password. Here we explain 2 ways of achieving this.

#### With Kerberos
If you run Ansible with your CERN account and try to connect to Kerberos-enabled hosts (like Openstack instances you manage or default CERN CentOS 7 installations), you should be able to rely on Kerberos authentication to SSH without being prompted for password. Nothing to be done then.

#### With public/private keys
If you use a local account or hosts without Kerberos, you need to setup passwordless SSH using public/private keys. Here's a short guide:

1. Make sure you have a public key on the controlling node, it is usually called `~/.ssh/id_rsa.pub` or `~/.ssh/id_dsa.pub`. If not, you can create one with `ssh-keygen`.
2. Add the contents of your `id_rsa.pub` (or similar) to `~/.ssh/authorized_keys` on each **target host**. To do that, either SSH into it and copy the contents, or run `ssh-copy-id your_username@target_hostname` on the controlling node.
3. Since you are now relying on SSH public key authentication, you must make sure that your inventory file does not contain the `ansible_become_method=ksu` option (see next section), as this only works with Kerberos.

For more information on SSH public key authentication, see [here](https://help.ubuntu.com/community/SSH/OpenSSH/Keys).

Privilege escalation on the target host
---
Some of the commands executed by Ansible on the target hosts need *root* privileges (e.g. install a package or copy a file to `/etc/`). Here we explain 2 ways of achieving this (more detailed info [here](https://docs.ansible.com/ansible/latest/user_guide/become.html)):

#### With Kerberos
As for the passswordless SSH access, if we target CERN Openstack or default CERN CentOS 7 installations we can rely on Kerberos to do privilege escalation. You just need to tell Ansible to use Kerberos (instead of the default `sudo`) via the `ansible_become_method=ksu` option. In your inventory, add this option to each host or group:

```
[grafana]
my-grafana-server.cern.ch ansible_become_method=ksu    # tell ansible to use Kerberos
```

#### With public/private keys
An alternative to Kerberos is using the default `sudo` method. To do so, we need to configure the target hosts to allow passwordless sudo for the account we are using to SSH. Here's a way of doing it:

1. Login to the target host **as root**
2. Execute `gpasswd -a USER wheel` to add the user to the wheel group (replace `USER` with the account you plan to use)
3. Execute the following: `echo -e "%wheel ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers.d/zzz-ansible`

Retrying command from the previous chapter
---
If we now look again at the same command to deploy the `grafana` role, we should be able to get rid of the `-u root` option:

```
ansible-playbook -i /tmp/inventory-test ansible/monitoring.yml
...
PLAY [grafana]

*******************************************************************************************
TASK [Gathering Facts]
*******************************************************************************************
ok: [my-grafana-server.cern.ch]
```

SSH as root
---
A third option, as we saw before, is to login as root via the `-u root` option when executing an Ansible command. Although not encouraged, in some situations (e.g. quick checks) it might be practical, particularly on CERN Openstack nodes where passwordless SSH with root is configured by default.

Next steps
---
Now that we have our test inventory properly configured, let's look at [role creation](create-role.md).

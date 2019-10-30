Getting started
===

Get Ansible
---
Install Ansible first on the controlling node.

On CERN CentOS 7 (**as root**):
```
yum install -y ansible
```
or
```
yum install -y python-pip python-devel
pip install ansible
```

On Mac OS:
```
brew install ansible
```

Clone this repo
---
Next, clone this repo (in this example, via KRB5, but you can do it either via HTTPS or SSH).

```
git clone https://:@gitlab.cern.ch:8443/AliceO2Group/system-configuration.git
```

There are 2 folders inside the repo, 1 for Ansible (the one we're interested in) and 1 for Foreman (ignore it).

```
cd system-configuration
tree -d -L 1
.
|-- ansible       // this is what we want
`-- foreman
```

Explore this repo
---
O2 Ansible recipes are stored in this CERN gitlab repo.
The directory structure is the following (some don't exist yet, just listed for illustration):

```
|-- ansible
|   `-- aliecs.yml                             // this is a playlist
|   `-- configuration.yml                      // this is another playlist
|   ...
|   |-- inventory-o2-lab                       // this is an inventory
|   ...
|   |-- roles                                  // roles should be placed here
|       |-- admin-essentials                   //    this is a role
|       |-- consul                             //    this is another role
|       ...
```

Tweak Ansible configuration
---
#### SSH host key verification
For dynamic nodes that change SSH keys often (e.g. Openstack nodes), the SSH host key verification is not really useful and can make using Ansible a pain. To disable this check, do the following:

```
echo -e "[defaults]\nhost_key_checking = False\n" >> ~/.ansible.cfg
```

### AFS home directories
If your home directory **is not** on AFS, skip to the next section.

Ansible's SSH multiplexing doesn't play well with AFS. If you run Ansible with a user with its home directory in AFS (such as your CERN main account), you might see the following error: `Failed to connect to the host via ssh: bind: Operation not permitted`. To fix it, please do the following:

```
echo -e "[ssh_connection]\ncontrol_path_dir = /tmp/.ansible/cp\n" >> ~/.ansible.cfg
```

Explore Ansible commands
---
Ansible comes with 2 main executables: `ansible` (good for *ad-hoc* commands) and `ansible-playbook` (the one we use to deploy roles).

### Ansible *ad-hoc* commands
Ansible *ad-hoc* commands can be executed like this:

```
Usage: ansible <host-pattern> [options]
```

`<host-pattern>` allows us to select which hosts from the [inventory](create-test-inventory.md) to target. You can use a specific hostname, a group or `all` for all hosts. You can also use patterns (more information available [here](http://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html)).

The commonly used options for the `ansible` command are:

* `-i INVENTORY`: path to inventory file/directory (defaults to `/etc/ansible/hosts`).
* `-m MODULE_NAME`: module to execute (defaults to `command` but can be any of the hundreds of available modules - see [here](http://docs.ansible.com/ansible/latest/modules/modules_by_category.html)).
* `-a MODULE_ARGS`: arguments to the module, very useful with the default `command` module to execute commands on the target hosts.
* `-u REMOTE_USER`: connect via SSH as this user
* `-C`: only check, don't do any changes

We can now try to ping all hosts on the existing *o2-lab* inventory:

```
ansible all -i ansible/inventory-o2-lab/hosts -m ping
```

This will fail with the message `Failed to connect to the host via ssh: Permission denied` unless you have [passwordless SSH access](authentication.md) to the hosts in the inventory set up, but it gives an idea of what can be achieved. If you want to explore the power of Ansible *ad-hoc* commands, see [here](http://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html).

### Executing Ansible playbooks
Ansible [playbooks](create-playbook.md) can be executed like this

```
Usage: ansible-playbook [options] playbook.yml [playbook2 ...]
```

The commonly used options for the `ansible-playbook` command are:

* `-i INVENTORY`: path to inventory file/directory (defaults to `/etc/ansible/hosts`).
* `-l SUBSET`: limit selected hosts (see `<host-pattern>` info in the Ansible *ad-hoc* commands section)
* `-t TAGS`: only run plays and tasks tagged with these values
* `-C`: only check, don't do any changes

We can now try to execute the monitoring playbook, available at `ansible/monitoring.yml`. The playbook specifies list of [roles](create-role.md) to be executed, see the following annotated version:
```
---
- hosts: influxdb
  roles:
    - { role: telegraf, tags: telegraf }
    - { role: influxdb, tags: influxdb }

- hosts: grafana                           # for hosts in the grafana group     
  roles:                                   #   apply the following roles
    - { role: telegraf, tags: telegraf }   #      telegraf (+ add a tag)
    - { role: grafana, tags: grafana }     #      grafana (+ add a tag)

- hosts: monitoring
  roles:
    - { role: telegraf, tags: telegraf }
    - { role: influxdb, tags: influxdb }
    - { role: grafana, tags: grafana }
```

To execute it, we would simply run this command:

```
ansible-playbook -i ansible/inventory-o2-lab ansible/monitoring.yml
```

Next steps
---
By now, you should be almost ready to run Ansible. Let's [create a test inventory](create-test-inventory.md) so that you can play with existing and/or new roles.

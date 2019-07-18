This page tries to list some guidelines and best practices to be followed inside the O2 project. 

Roles
---
###### Name
Role names should be all lowercase, with words separated by dashes (-).

###### Documentation
Each role should have its own dedicated README.md file. Include at least the following sections:

- **introduction**: general description of what the role does (installs this and that, opens that port in firewall, creates sample config files in ...)
- **variables**: table with list of variables (name, default value, notes) that can be overwritten by users of the role (typically, the ones defined in `defaults`)

###### Variables
Variables which are supposed to be overwritten by users of the role (typically via `group_vars` or `host_vars` in an inventory) should go into `defaults` and documented in the README.md file. Other variables should go in `vars`.  

Variables names should be prefixed by the role name in the form `role_xxx`. If the role name includes a dash (-), it should be replaced by an underscore (_).

Inventories
---
###### Name
Inventory names should be prefixed by `inventory-`. Words should be separated by dashes (-).

###### Organization
Each distinct setup (e.g. o2 lab, TPC test setup, ITS commissioning lab, ...) should go in a dedicated inventory directory. It should follow the following structure: 

```
|-- inventory-secret-lab
|   |-- hosts                 // list of hosts
|   |-- group_vars            // group variables, optional
|   |   `-- group-name-1      //    e.g flps or epns
|   |   `-- group-name-2
|   `-- host_vars             // host variables, optional
|       `-- host-name-1       //    e.g. o2-srv-123
|       `-- host-name-2
```

`group_vars` and `host_vars` should be used to overwrite the default role settings.

Tags
---
Tags provide a way of selecting which parts of the playbooks are executed. By following the guidelines below we can gain flexibility in their execution.

###### Role name as tag
When linking a role to a host or a group of hosts, add a tag with the role name. For example (from monitoring.yml):
```
...
- hosts: grafana
  roles:
    - { role: telegraf, tags: telegraf }
    - { role: grafana, tags: grafana }
...
```
This allows us, for example, to only deploy a specific role: 
```
ansible-playbook -i inventory-o2-lab -t telegraf -s site.yml
```

###### Special tags
Use the following tags to categorize the tasks inside a role:
 
* **installation**: tasks related to installing the role, typically using the *package* module.
* **configuration**: tasks related to configuring the role, typically deploying *templated* configuration files.
* **execution**: tasks related to running the role, typically using the *service* module.

This allows us, for example, to target a specific category of tasks: 
```
### install 
ansible-playbook -i inventory-o2-lab -t installation -s site.yml

### install and configure but don't start
ansible-playbook -i inventory-o2-lab -t installation,configuration -s site.yml
```

Ansible best practices
---
The Ansible documentation provides a nice page on [best practices](http://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html) to follow. We recommend that you take a look. 

Next steps
---
You can now have a look at some [examples](examples-commands.md) on how to run Ansible commands.
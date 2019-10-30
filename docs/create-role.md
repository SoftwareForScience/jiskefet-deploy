Create a role
===
A role is a reusable block that normally deploys and configures an application or module. The Ansible documentation on roles can be found [here](http://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html). 

Directory structure
---
A role should be contained in a single directory under [roles](../roles). Inside this directory, the following subdirectories can exist: 

```
roles/my-role/
|-- defaults       # default values for variables that normally change between setups
|-- files          # files to be deployed by the role (e.g. config files)
|-- handlers       # on change operations (e.g. restart service)
|-- meta           # meta data (e.g. role dependencies)
|-- tasks          # list of tasks to be executed
|-- templates      # templated files to be deployed by the role (e.g. config files)
`-- vars           # variables to be used in tasks
```

#### Tasks
Normally we start by creating the tasks. This is where we define the list of operations to be executed. Tasks go in a file called `roles/my-role/tasks/main.yml`. Let's look at a specific task from [telegraf](../roles/telegraf/tasks/main.yml) to give an idea of what it consists of: 

```
---                                                           # this is needed at the top of the file
- name: Ensure telegraf {{ telegraf_version }} is present     # task name, should be verbose
  package:                                                    # install using the package module
    name: "https://..."                                       #    name or URL of the package
    state: present                                            #    package should be present 
  notify: Restart telegraf                                    # once done, execute this handler
  tags: installation                                          # this concerns installation
```

The best way to learn how to write tasks is to have a look at existing tasks. Feel free to browse the existing roles in this repo and have a look at what others have done. For more advanced cases, please refer to the [Ansible docs](http://docs.ansible.com/ansible/latest/). 

#### Handlers
Handlers go to `roles/my-role/handlers/main.yml`. They are useful for example to automatize the restart of services whenever a change happens, normally a change in a configuration file or a package upgrade. If we look again at an example from [telegraf](../roles/telegraf/handlers/main.yml), this is what we have: 

```
---
- name: Restart telegraf
  service: name=telegraf state=restarted
```

Tasks that want to restart the telegraf service should use the `notify` option like in the previous section.

#### Variables
It is quite useful to use variables in the roles, either to customize different setups (i.e. inventories) or to easily update a role without having to change things on multiple places. Please follow these simple rules: 

1. Variables that can be overridden in the inventory files go to `defaults`.
2. Other variables go to `vars`.
3. Roles should be self-contained, i.e., all used variables should have a default value set, either in `defaults` or in `vars`. 

Ansible has extensive documentation on [variable usage](http://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html). 

#### Files and templates
Files and templates are normally (but not always) configuration files that we copy to the target host. Files which are simply copied should go to `files`. Files which are changed (normally via variables) go to `templates`. In general, templating is preferred over simple file copying because it makes the roles more flexible. More information on templating can be found [here](http://docs.ansible.com/ansible/latest/modules/template_module.html).

#### Meta
This is normally only used when we want a role to include or import another role. 

My first role
---
We can now create a simple dummy role that installs a package. Let's create a directory for this role: 

```
mkdir ansible/roles/dummy-role
mkdir ansible/roles/dummy-role/tasks
```

Now let's create a task that installs a package e.g. `emacs`. Create the file `ansible/roles/dummy-role/tasks/main.yml` and add the following content: 

```
---
- name: Ensure emacs is present
  package:
    name: "emacs"
    state: present
```

Next steps
---
Now that we have a role, we need to [create a playbook](create-playbook.md) to associate it with groups of hosts. 

Create a playbook
===
Playbooks is where we associate roles to groups of hosts. The idea is that in the playbook we say which roles should be deployed for a group of hosts and then in the inventory we define which hosts belong to each group. 

Playbooks should be located on the top level `ansible` directory. A playbook looks like this: 

```
---
- hosts: grafana                           // for the grafana group of hosts
  roles:                                   // deploy these roles
    - { role: telegraf, tags: telegraf }   //    collectd (+ add a tag)
    - { role: grafana, tags: grafana }     //    grafana (+ add a tag)
```

If we now relate to the role we created in the previous chapter, we could create a playbook that deploys our role. Create the file `ansible/dummy-playbook.yml` and add the following content: 

```
---
- hosts: testing
  roles:
    - { role: dummy-role, tags: dummy-role }
```

If we now edit our test inventory to add a new group `testing`: 

```
[grafana]
my-mon-server.cern.ch       # replace this with your hostname

[influxdb]
my-mon-server.cern.ch       # replace this with your hostname

[testing]
my-test-server.cern.ch      # replace this with your hostname, can be the same as above
```

We should be able to deploy our newly created role with the following command: 

```
ansible-playbook -i /tmp/inventory-test ansible/dummy-playbook.yml
```

Top level playbook
---
Playbooks can include other playbooks (sub-playbooks). Using this, we have a top level playbook called [site.yml](../site.yml) that includes all other playbooks. 

Each newly created playbook should be included in [site.yml](../site.yml).

Create new playbook vs add to existing playbook
---
Sub-playbooks should correspond to O2 subsystems like monitoring, quality control or logging. If you are creating a new role, consider if it makes sense to add it to an existing playbook instead of creating a new playbook. 

Next steps
---
You can now have a look at some of the [best practices and guidelines](best-practices.md).


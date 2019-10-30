Create your own inventory for tests
===
An Ansible inventory is basically a list of hostnames grouped into logical sets: 
```
# example from official documentation
[jiskefet-frontend]
foo.example.com
bar.example.com

[jiskefet-backend]
one.example.com
two.example.com
three.example.com
```
More information can be found [here](http://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html).

In order to test the roles you develop, it is useful to have a private inventory on which you can test without risking rolling out changes to official setups. An easy way to do this is to create a few [CERN Openstack](http://openstack.cern.ch) instances and use them to test your Ansible work. 

Create CERN Openstack instances
---
To create CERN Openstack instances, please follow the instructions available [here](https://clouddocs.web.cern.ch/clouddocs/). 

Create an Ansible inventory
---
In its simplest form, an Ansible inventory is just an INI file with groups of hosts. Please put the content of the file below in a file called `inventory-test`, replacing `my-mon-server.cern.ch` with whatever name you used to create your CERN Openstack instance.  Put it somewhere outside the repo because this is not something you want to push upstream. Here we assume it's in `/tmp`.

```
[grafana]
my-mon-server.cern.ch   # replace this with your hostname

[influxdb]
my-mon-server.cern.ch   # replace this with your hostname
```

We can now run the ping *ad-hoc* command from the previous section against this new inventory:  

```
ansible all -i /tmp/inventory-test -m ping
...
my-mon-server.cern.ch | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

If we do the same with the monitoring playbook, it should do a bunch of tasks like setting up YUM repos and deploying packages like grafana and influxdb: 

```
ansible-playbook -u root -i /tmp/inventory-test ansible/monitoring.yml
...
PLAY [grafana] 

*******************************************************************************************
TASK [Gathering Facts] 
*******************************************************************************************
ok: [my-grafana-server.cern.ch]

TASK [o2-base : Ensure CERN repository exists] *******************************************************************************************************************************************************************************************************************************************************************************************************
ok: [my-grafana-server.cern.ch]

TASK [o2-base : Install CERN certificates required by alisw repo] ************************************************************************************************************************************************************************************************************************************************************************************
ok: [my-grafana-server.cern.ch]

TASK [o2-base : Set up ALICE Software EL7 repo] ******************************************************************************************************************************************************************************************************************************************************************************************************
ok: [my-grafana-server.cern.ch]

...

TASK [telegraf : Ensure telegraf 1.10.4 is present] **************************************************************************************************************************************************************************************************************************************************************************************************
changed: [my-grafana-server.cern.ch]

...

TASK [grafana : Ensure grafana 6.1.6 is present] *****************************************************************************************************************************************************************************************************************************************************************************************************
changed: [vasco-flp1.cern.ch]

...
```

Next steps
---
Notice the `-u root` option used. Ideally you should be able to SSH as a normal user and then Ansible would use existing privilege escalation systems to execute the tasks that need it. Let's see how to [setup proper authentication](authentication.md).

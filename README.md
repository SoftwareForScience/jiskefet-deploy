## Description
This bookkeeping system is a system for A Large Ion Collider Experiment
(ALICE) to keep track of what is happening to the data produced by the detectors. The electric signals produced by the various detectors which
together are the ALICE detector are being reconstructed, calibrated, compressed and used in numerous but specific ways. It is important to register  
how this is done to make a reproduction of data possible and thereby a validation of the information produced. The project is also known as the
Jiskefet project.  

This is the **Ansible playbook** to deploy the Jiskefet project.   
The **front-end UI** can be found here: https://github.com/BastiaanReinalda/jiskefet-ui  
And the **back-end API** can be found here: https://github.com/BastiaanReinalda/jiskefet-api  

## Quick Start

- copy **files/ormconfig.json.example** as **files/ormconfig.json** and set your own values.
- make sure you can connect to vm servers via  
`$ ssh vm-jiskefet-api`  
and  
`$ ssh vm-jiskefet-db`
- run playbook: `$ ansible-playbook site.yml`

## Directory Layout
See [playbooks best practices: content organization](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_best_practices.html#content-organization) for the recommended ansible directory layout, which the layout below is based on.

```YML
ansible.configure         # configuration file for ansible
hosts                     # list of hosts (aliases)

site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
    db/                   # same kind of structure as "common" was above, done for the db role
    web/                  # same kind of structure as "common" was above, done for the web role
```

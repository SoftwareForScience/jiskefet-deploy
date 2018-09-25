# Quick start:
Install roles from Ansible Galaxy:
`$ ansible-galaxy install -r requirements.yml`


---

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

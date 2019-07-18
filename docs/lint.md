Linting roles and playbooks
===

An Ansible file can be checked for the best practices and behaviour that could potentially be improved.
This is done using `ansible-lint`.

Installation
---

```
pip install ansible-lint
```

In case you don't have `pip` installed run `yum install python-pip` on CentOS 7 or `brew install python` on MacOS.


Usage
---

Linting a file or a role is as simple as:
```
ansible-lint <file>/<role_dir>
```


Recommended options:

| Option   |      Description      |  Recommended/CI value |
|----------|-----------------------|-----------------------|
| `-x` |  disables certain rule(s), the full list of rules is available in [here](https://docs.ansible.com/ansible-lint/rules/default_rules.html) | `403,701` |
| `--exclude` |    excludes files/directories, eg. imported roles  |   `ansible/roles/ansible-mesos,ansible/roles/ansible-zookeeper`  |



Sample commands
---

Linting `flp-standalone` playbook:
```
ansible-lint ansible/flp-standalone.yml -x 403,701 --exclude ansible/roles/ansible-mesos,ansible/roles/ansible-zookeeper
```


Linting `flp-standalone` role:
```
ansible-lint ansible/roles/flp-standalone -x 403,701 --exclude ansible/roles/ansible-mesos,ansible/roles/ansible-zookeeper
```

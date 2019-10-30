# mariadb

An Ansible role that installs MariaDB, changes mysql root password, and makes sure it runs on startup.

## Requirements

No specific requirements, just CC7 and Yum.

## Dependencies

None.

## Role Variables

mysql_root_password: password for mysql user root (new one to be set)
mysql_root_old_password: current password for mysql user root (will be changed)

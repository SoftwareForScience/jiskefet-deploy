# Jiskefet Deployment

This bookkeeping system is a system for A Large Ion Collider Experiment
(ALICE) to keep track of what is happening to the data produced by the detectors. The electric signals produced by the various detectors which
together are the ALICE detector are being reconstructed, calibrated, compressed and used in numerous but specific ways. It is important to register  
how this is done to make a reproduction of data possible and thereby a validation of the information produced. The project is also known as the
Jiskefet project.

This is the **Ansible playbook** to deploy the Jiskefet project.   
The **front-end UI** can be found here: https://github.com/SoftwareForScience/jiskefet-ui  
And the **back-end API** can be found here: https://github.com/SoftwareForScience/jiskefet-api  
For the separate **Jenkins CI** playbook, see table of contents.
 
## Table of Contents

- [Quick start](#quick-start)
- Installation instructions
  1. [Configuration file](docs/configuration_file.md)
  2. [Setting up ssh](docs/setting_up_ssh.md)
  3. [Running the Ansible playbook](docs/running_ansible.md)
- Manage processes after installation
  - [Managing API with pm2](docs/managing_processes.md)
- General information
  - [System requirements](docs/system_requirements.md)
  - [Deployment diagram](docs/deployment_diagram.md)
-  [Continuous integration with Jenkins (separate playbook)](ci/README.md)
-  [Troubleshooting](#troubleshooting)


## Quick Start

1. Copy the `ansible.config.yml.template` as `ansible.config.yml` and change the variables to the appropriate values ([more info](docs/configuration_file.md)).
2. Make sure that the two CentOS server are online ([more info](docs/setting_up_ssh.md)):
    ```bash 
    $ ping IP_ADDR_SERVER_1
    $ ping IP_ADDR_SERVER_2
    ```
3. Run playbook twice (first time an ansible-vault will be setup, second time to deploy the application stack): 
    ```bash
    $ ansible-playbook site.yml
    ```
    or run command if you are not root on the remotes
    ```bash
    $ ansible-playbook site.yml -K
    ```
4. Open a browser and navigate to http://SERVER_IP_HERE/api/doc/ to see the swagger documentation of the project.

## Troubleshooting

Having troubles deploying this playbook?  Please see if the table below can solve the problem(s).

Question | Answer
--- | ---
task `ping hosts to see if hosts are up` returns the error `'{{ name }}: Name or service not known'` | This error occurs when an alias is used in the `hosts` file. In order for the ping command to know where to send the ping request to, the alias with the ip address needs to be added to `/etc/hosts`. e.g. `'127.0.0.1 lorem-ipsum'`


[Back to table of contents](#table-of-contents)

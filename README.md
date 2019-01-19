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
- General information
  - [System requirements](docs/system_requirements.md)
  - [Deployment diagram](docs/deployment_diagram.md)
-  [Continuous integration with Jenkins (separate playbook)](ci/README.md)


## Quick Start

1. Copy the `ansible.config.json.template` as `ansible.config.json` and change the variables to the appropriate values ([more info](docs/configuration_file.md)).
2. Make sure you can connect to two CentOS servers via ssh ([more info](docs/setting_up_ssh.md)):
    ```bash 
    $ ssh jiskefet-api
    $ ssh jiskefet-db
    ```
3. Run playbook: 
    ```bash
    $ ansible-playbook site.yml
    ```
4. Open a browser and navigate to http://SERVER_IP_HERE/api/doc/ to see the swagger documentation of the project.

[Back to table of contents](#table-of-contents)

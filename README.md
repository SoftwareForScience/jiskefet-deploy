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

For more detailed instructions on setting up this project please refer to [these instructions.](https://github.com/misharigot/sfs-ansible/blob/develop/Instruction.md) 

## System requirements
**Host machine specifications**  
**Hardware**  
None  
**Software**  

Package name | Version 
--- | --- 
ansible | 2.4.2.0  
ansible-playbook | 2.4.2.0  
python | 2.7.5   

**API and UI machine specifications**  
**Hardware**  

Component | Requirement 
--- | --- 
Minimum CPU | 2 cores   

**Software**  
None

**DB machine specifications**

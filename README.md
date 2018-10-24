## Description
This bookkeeping system is a system for A Large Ion Collider Experiment
(ALICE) to keep track of what is happening to the data produced by the detectors. The electric signals produced by the various detectors which
together are the ALICE detector are being reconstructed, calibrated, compressed and used in numerous but specific ways. It is important to register  
how this is done to make a reproduction of data possible and thereby a validation of the information produced. The project is also known as the
Jiskefet project.  

This is the **Ansible playbook** to deploy the Jiskefet project.   
The **front-end UI** can be found here: https://github.com/SoftwareForScience/jiskefet-ui  
And the **back-end API** can be found here: https://github.com/SoftwareForScience/jiskefet-api  

## Quick Start

- Copy the *ansible.config.json.template* as *ansible.config.json*
- Change the variables to the appropriate values
- Make sure you can connect to vm servers via  
`$ ssh vm-jiskefet-api`  
and  
`$ ssh vm-jiskefet-db`
- Run playbook: `$ ansible-playbook site.yml`
- Open a browser and navigate to http://SERVER_IP_HERE/api/doc/ to see the swagger documentation of the project.

For more detailed instructions on setting up this project please refer to [these instructions.](https://github.com/SoftwareForScience/sfs-ansible/blob/develop/Instructions.md) 

## System requirements  
### **Host machine specifications**  
**Hardware**  
None  
**Software**  

Name | Version 
--- | --- 
ansible | 2.4.2.0  
ansible-playbook | 2.4.2.0  
python | 2.7.5   

### **API and UI machine specifications**  
**Hardware**  

Component | Requirement 
--- | --- 
CPU | Minimum 2 cores   

**Software**  

Name | Version 
--- | --- 
CentOS | Linux 7 (Core) 

### **DB machine specifications**
**Hardware**  

**Software**  

Name | Version 
--- | --- 
CentOS | Linux 7 (Core) 
MariaDB | 10.1.36-MariaDB


## Deployment diagram
![alt text][dd]

[dd]: https://github.com/misharigot/sfs-ansible/blob/develop/Deployment_Diagram_Jiskefet.png "Deployment diagram"

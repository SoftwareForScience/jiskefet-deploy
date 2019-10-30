Examples of commands
===
A few examples: 

Run the main playbook on all hosts: 
```
ansible-playbook -i ansible/inventory-o2-lab ansible/site.yml
```

Deploy `telegraf` on all nodes: 
```
ansible-playbook -i ansible/inventory-o2-lab -t telegraf ansible/site.yml
``` 

Same as previous, but on a single host: 
```
ansible-playbook -i ansible/inventory-o2-lab -l aido2web1-gpn.cern.ch -t telegraf ansible/site.yml
```

Same as previous, but only the stuff related to configuring telegraf:
```
ansible-playbook -i ansible/inventory-o2-lab -l aido2web1-gpn.cern.ch -t telegraf,configuration ansible/site.yml
```
